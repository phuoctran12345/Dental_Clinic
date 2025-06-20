package dao;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.MedicalReport;
import model.Medicine;
import model.Prescription;
import utils.DBContext;

/**
 *
 * @author Home
 */
public class MedicineDAO extends DBContext {

    public int insertMedicalReport(int appointmentId, long doctorId, int patientId,
            String diagnosis, String treatmentPlan, String note, String sign) throws SQLException {
        String sql = "INSERT INTO MedicalReport (appointment_id, doctor_id, patient_id, diagnosis, treatment_plan, note, sign) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, appointmentId);
            ps.setLong(2, doctorId);
            ps.setInt(3, patientId);
            ps.setString(4, diagnosis);
            ps.setString(5, treatmentPlan);
            ps.setString(6, note);
            ps.setString(7, sign);

            ps.executeUpdate();

            // Lấy report_id vừa insert
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1; // lỗi
    }

    // Thêm đơn thuốc gắn với báo cáo
    public void insertPrescription(int reportId, int medicineId, int quantity, String usage) throws SQLException {
        String sql = "INSERT INTO Prescription (report_id, medicine_id, quantity, usage) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reportId);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity);
            ps.setString(4, usage);
            ps.executeUpdate();
        }
    }

    public static List<Medicine> getAllMedicine() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("medicine_id"));
                m.setName(rs.getString("name"));
                m.setUnit(rs.getString("unit"));
                m.setQuantityInStock(rs.getInt("quantity_in_stock"));
                m.setDescription(rs.getString("description"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean hasEnoughStock(int medicineId, int requiredQty) throws SQLException {
        String sql = "SELECT quantity_in_stock FROM Medicine WHERE medicine_id = ?";
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int currentStock = rs.getInt("quantity_in_stock");
                    return currentStock >= requiredQty;
                }
            }
        }
        return false;
    }

    public boolean reduceMedicineStock(int medicineId, int quantity) throws SQLException {
        String sql = "UPDATE Medicine SET quantity_in_stock = quantity_in_stock - ? WHERE medicine_id = ? AND quantity_in_stock >= ?";
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity); // Đảm bảo có đủ thuốc
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu cập nhật thành công
        }
    }

    public void updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        }
    }

    public static List<MedicalReport> getMedicalReportsByPatientId(int patientId) {
        List<MedicalReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM MedicalReport WHERE patient_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicalReport mr = new MedicalReport();
                    mr.setReportId(rs.getInt("report_id"));
                    mr.setAppointmentId(rs.getInt("appointment_id"));
                    mr.setPatientId(rs.getInt("patient_id"));
                    mr.setDoctorId(rs.getInt("doctor_id"));
                    mr.setDiagnosis(rs.getString("diagnosis"));
                    mr.setTreatmentPlan(rs.getString("treatment_plan"));
                    mr.setNote(rs.getString("note"));
                    mr.setCreatedAt(rs.getTimestamp("created_at"));
                    mr.setSign(rs.getString("sign"));
                    reports.add(mr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

 

    public MedicalReport getMedicalReportById(int reportId) {
    MedicalReport report = null;
    String sql = "SELECT mr.*, p.full_name AS patient_name, d.full_name AS doctor_name "
               + "FROM MedicalReport mr "
               + "JOIN Patients p ON mr.patient_id = p.patient_id "
               + "JOIN Doctors d ON mr.doctor_id = d.doctor_id "
               + "WHERE mr.report_id = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, reportId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            report = new MedicalReport();
            report.setReportId(rs.getInt("report_id"));
            report.setAppointmentId(rs.getInt("appointment_id"));
            report.setDoctorId(rs.getInt("doctor_id"));
            report.setPatientId(rs.getInt("patient_id"));
            report.setDiagnosis(rs.getString("diagnosis"));
            report.setTreatmentPlan(rs.getString("treatment_plan"));
            report.setNote(rs.getString("note"));
            report.setCreatedAt(rs.getTimestamp("created_at"));
            report.setSign(rs.getString("sign"));
            report.setPatientName(rs.getString("patient_name"));
            report.setDoctorName(rs.getString("doctor_name"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return report;
}


    public static List<Prescription> getPrescriptionsByReportId(int reportId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT p.prescription_id, p.report_id, p.medicine_id, m.name, p.quantity, p.usage "
                + "FROM Prescription p "
                + "JOIN Medicine m ON p.medicine_id = m.medicine_id "
                + "WHERE p.report_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Prescription pres = new Prescription();
                pres.setPrescriptionId(rs.getInt("prescription_id"));
                pres.setReportId(rs.getInt("report_id"));
                pres.setMedicineId(rs.getInt("medicine_id"));
                pres.setName(rs.getString("name"));
                pres.setQuantity(rs.getInt("quantity"));
                pres.setUsage(rs.getString("usage"));

                list.add(pres);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static MedicalReport getReportByAppointmentId(int appointmentId) {
        MedicalReport report = null;
        String sql = "SELECT mr.*, p.full_name AS patient_name, d.full_name AS doctor_name "
                + "FROM MedicalReport mr "
                + "JOIN Patients p ON mr.patient_id = p.patient_id "
                + "JOIN Doctors d ON mr.doctor_id = d.doctor_id "
                + "WHERE mr.appointment_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                report = new MedicalReport();
                report.setReportId(rs.getInt("report_id"));
                report.setAppointmentId(rs.getInt("appointment_id"));
                report.setDoctorId(rs.getInt("doctor_id"));
                report.setPatientId(rs.getInt("patient_id"));
                report.setDiagnosis(rs.getString("diagnosis"));
                report.setTreatmentPlan(rs.getString("treatment_plan"));
                report.setNote(rs.getString("note"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setSign(rs.getString("sign"));
                report.setPatientName(rs.getString("patient_name")); // set tên bệnh nhân
                report.setDoctorName(rs.getString("doctor_name"));   // set tên bác sĩ
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return report;
    }

}
