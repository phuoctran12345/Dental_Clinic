package dao;

import model.Medicine;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Home
 */
public class MedicineDAO extends DBContext {

    public static java.sql.Connection getConnect() {
        return DBContext.getConnection();
    }

    public int insertMedicalReport(int appointmentId, long doctorId, int patientId,
            String diagnosis, String treatmentPlan, String note, String sign) throws SQLException {
        String sql = "INSERT INTO MedicalReport (appointment_id, doctor_id, patient_id, diagnosis, treatment_plan, note, sign) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnect(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, appointmentId);
            ps.setLong(2, doctorId);  // Sử dụng setLong vì doctor_id là BIGINT
            ps.setInt(3, patientId);
            ps.setString(4, diagnosis);
            ps.setString(5, treatmentPlan);
            ps.setString(6, note);
            ps.setString(7, sign);

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Không thể tạo báo cáo y tế, không có dòng nào bị ảnh hưởng.");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Không thể lấy ID của báo cáo y tế mới tạo.");
                }
            }
        }
    }

    // Thêm đơn thuốc gắn với báo cáo
    public void insertPrescription(int reportId, int medicineId, int quantity, String usage) throws SQLException {
        String sql = "INSERT INTO Prescription (report_id, medicine_id, quantity, usage) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnect(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity);
            ps.setString(4, usage);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Không thể thêm đơn thuốc, không có dòng nào bị ảnh hưởng.");
            }
        }
    }

    // Thêm thuốc mới
    public boolean addMedicine(Medicine medicine) throws SQLException {
        String sql = "INSERT INTO Medicine (name, unit, quantity_in_stock, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, medicine.getName());
            ps.setString(2, medicine.getUnit());
            ps.setInt(3, medicine.getQuantityInStock());
            ps.setString(4, medicine.getDescription());
            return ps.executeUpdate() > 0;
        }
    }

    // Cập nhật thông tin thuốc
    public boolean updateMedicine(Medicine medicine) throws SQLException {
        String sql = "UPDATE Medicine SET name=?, unit=?, quantity_in_stock=?, description=? WHERE medicine_id=?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, medicine.getName());
            ps.setString(2, medicine.getUnit());
            ps.setInt(3, medicine.getQuantityInStock());
            ps.setString(4, medicine.getDescription());
            ps.setInt(5, medicine.getMedicineId());
            return ps.executeUpdate() > 0;
        }
    }

    // Xóa thuốc
    public boolean deleteMedicine(int medicineId) throws SQLException {
        String sql = "DELETE FROM Medicine WHERE medicine_id=?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            return ps.executeUpdate() > 0;
        }
    }

    // Lấy thông tin một thuốc theo ID
    public Medicine getMedicineById(int medicineId) throws SQLException {
        String sql = "SELECT * FROM Medicine WHERE medicine_id=?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("medicine_id"));
                m.setName(rs.getString("name"));
                m.setUnit(rs.getString("unit"));
                m.setQuantityInStock(rs.getInt("quantity_in_stock"));
                m.setDescription(rs.getString("description"));
                return m;
            }
        }
        return null;
    }

    // Lấy danh sách tất cả thuốc
    public List<Medicine> getAllMedicine() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("medicine_id"));
                m.setName(rs.getString("name"));
                m.setUnit(rs.getString("unit"));
                m.setQuantityInStock(rs.getInt("quantity_in_stock"));
                m.setDescription(rs.getString("description"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách thuốc: " + e.getMessage());
        }
        return list;
    }

    // Kiểm tra số lượng thuốc trong kho
    public boolean hasEnoughStock(int medicineId, int requiredQty) throws SQLException {
        String sql = "SELECT quantity_in_stock FROM Medicine WHERE medicine_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int currentStock = rs.getInt("quantity_in_stock");
                return currentStock >= requiredQty;
            }
            return false; // Không tìm thấy thuốc
        }
    }

    // Giảm số lượng thuốc trong kho
    public boolean reduceMedicineStock(int medicineId, int quantity) throws SQLException {
        String sql = "UPDATE Medicine SET quantity_in_stock = quantity_in_stock - ? WHERE medicine_id = ? AND quantity_in_stock >= ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity); // Kiểm tra lại số lượng tồn kho
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Tìm kiếm thuốc theo tên
    public List<Medicine> searchMedicineByName(String name) throws SQLException {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine WHERE name LIKE ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("medicine_id"));
                m.setName(rs.getString("name"));
                m.setUnit(rs.getString("unit"));
                m.setQuantityInStock(rs.getInt("quantity_in_stock"));
                m.setDescription(rs.getString("description"));
                list.add(m);
            }
        }
        return list;
    }

    public void updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Không thể cập nhật trạng thái cuộc hẹn, không tìm thấy appointment_id: " + appointmentId);
            }
        }
    }
}
