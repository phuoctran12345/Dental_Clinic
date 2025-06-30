package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Patients;
import utils.DBContext;

public class PatientDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public List<Patients> getAllPatients() {
        List<Patients> list = new ArrayList<>();
        String query = "SELECT * FROM Patients";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Patients(
                        rs.getInt("patient_id"),
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getDate("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return list;
    }

    public List<Patients> searchPatients(String keyword) {
        List<Patients> list = new ArrayList<>();
        String query = "SELECT * FROM Patients WHERE full_name LIKE ? OR phone LIKE ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Patients(
                        rs.getInt("patient_id"),
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getDate("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return list;
    }

    public List<Patients> filterPatientsByGender(String gender) {
        List<Patients> list = new ArrayList<>();
        String query = "SELECT * FROM Patients WHERE gender = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, gender);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Patients(
                        rs.getInt("patient_id"),
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getDate("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return list;
    }

    // Thêm dữ liệu mẫu
//    public void addSampleData() {
//        String query = "INSERT INTO Patients (id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";
//        try {
//            conn = DBContext.getConnection();
//            ps = conn.prepareStatement(query);
//            
//            // Thêm bệnh nhân 1
//            ps.setInt(1, 1);
//            ps.setString(2, "Nguyễn Văn A");
//            ps.setString(3, "0123456789");
//            ps.setDate(4, java.sql.Date.valueOf("1990-01-01"));
//            ps.setString(5, "male");
//            ps.executeUpdate();
//
//            // Thêm bệnh nhân 2
//            ps.setInt(1, 2);
//            ps.setString(2, "Trần Thị B");
//            ps.setString(3, "0987654321");
//            ps.setDate(4, java.sql.Date.valueOf("1995-05-15"));
//            ps.setString(5, "female");
//            ps.executeUpdate();
//
//            // Thêm bệnh nhân 3
//            ps.setInt(1, 3);
//            ps.setString(2, "Lê Văn C");
//            ps.setString(3, "0369852147");
//            ps.setDate(4, java.sql.Date.valueOf("1988-12-31"));
//            ps.setString(5, "other");
//            ps.executeUpdate();
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        } finally {
//           DBContext.closeConnection(conn, ps, rs);
//        }
//    }
    public static Patients getPatientByUserId(int userId) {
        String sql = "SELECT * FROM Patients WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Patients patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setPhone(rs.getString("phone"));  // sửa chính tả

                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
                patient.setCreatedAt(rs.getDate("created_at"));  // nếu có trường này trong DB

                patient.setAvatar(rs.getString("avatar"));
                // các field khác nếu cần
                return patient;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static int getTotalVisitsByPatientId(int patientId) {
        String sql = "SELECT COUNT(*) FROM Appointment WHERE patient_id = ? AND status = N'Đã khám'";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

}
