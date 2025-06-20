package dao;

import java.sql.*;
import utils.DBContext;
import model.User;
import model.Patients;

/**
 *
 * @author Home
 */
public class HospitalDAO {

    public static Connection getConnect() {
        return DBContext.getConnection();
    }

    //-----------------------------------------------------------------------------------------
    public static User getUserByEmailAndPassword(String email, String passwordHash) {
        User user = null;
        try {
            Connection conn = getConnect();
            String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at"),
                        rs.getString("avatar")
                );
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    //--------------------------------------------------------------------------------------------

    public static boolean isPatientExists(String email) {
        String sql = "SELECT * FROM users WHERE email = ? AND role = 'PATIENT'";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            System.out.println("Checking existence for email: " + email);
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                boolean exists = rs.next();
                System.out.println("Exists? " + exists);
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm khách hàng mới vào database
    public static int registerPatient(String email, String passwordHash) {
        String sql = "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, 'PATIENT')";
        try (Connection conn = getConnect(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Tạo username từ email (lấy phần trước @)
            String username = email.split("@")[0];
            
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, passwordHash);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static boolean savePatientInfo(int id, String fullName, String phone, String dateOfBirth, String gender) {
        String sql = "INSERT INTO Patients (id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnect(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, dateOfBirth);
            ps.setString(5, gender);

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
//--------------------------------------------------------------------------------------------
    
     public static Patients getPatientByUserId(int id) {
        Patients patients = null;
        String sql = "SELECT patient_id, id, full_name, phone, date_of_birth, gender " +
                     "FROM Patients WHERE id = ?";

        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                patients = new Patients();
                patients.setPatientId(rs.getInt("patient_id"));
                patients.setId(rs.getInt("id"));
                patients.setFullName(rs.getString("full_name"));
                patients.setPhone(rs.getString("phone"));
                patients.setDateOfBirth(rs.getDate("date_of_birth"));
                patients.setGender(rs.getString("gender"));
                patients.setCreatedAt(rs.getDate("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    public static void main(String[] args) {
        System.out.println("=== Bắt đầu test HospitalDAO ===");
        
        // Test kết nối database
        System.out.println("\n1. Test kết nối database:");
        Connection conn = getConnect();
        if (conn != null) {
            System.out.println("✅ Kết nối database thành công!");
        } else {
            System.out.println("❌ Kết nối database thất bại!");
            return;
        }

        // Test đăng ký bệnh nhân mới
        System.out.println("\n2. Test đăng ký bệnh nhân mới:");
        String testEmail = "test@example.com";
        String testPassword = "hashed_password_123";
        
        // Kiểm tra email đã tồn tại chưa
        if (isPatientExists(testEmail)) {
            System.out.println("❌ Email đã tồn tại trong hệ thống!");
        } else {
            // Thử đăng ký bệnh nhân mới
            int userId = registerPatient(testEmail, testPassword);
            if (userId > 0) {
                System.out.println("✅ Đăng ký bệnh nhân mới thành công!");
                System.out.println("User ID: " + userId);
                
                // Test lưu thông tin bệnh nhân
                System.out.println("\n3. Test lưu thông tin bệnh nhân:");
                boolean saveResult = savePatientInfo(userId, "Nguyễn Văn A", "0123456789", "1990-01-01", "Nam");
                if (saveResult) {
                    System.out.println("✅ Lưu thông tin bệnh nhân thành công!");
                } else {
                    System.out.println("❌ Lưu thông tin bệnh nhân thất bại!");
                }
            } else {
                System.out.println("❌ Đăng ký bệnh nhân mới thất bại!");
            }
        }

        // Test đăng nhập
        System.out.println("\n4. Test đăng nhập:");
        User loggedInUser = getUserByEmailAndPassword(testEmail, testPassword);
        if (loggedInUser != null) {
            System.out.println("✅ Đăng nhập thành công!");
            System.out.println("Thông tin người dùng:");
            System.out.println("ID: " + loggedInUser.getId());
            System.out.println("Username: " + loggedInUser.getUsername());
            System.out.println("Email: " + loggedInUser.getEmail());
            System.out.println("Role: " + loggedInUser.getRole());
            
            // Test lấy thông tin bệnh nhân
            System.out.println("\n5. Test lấy thông tin bệnh nhân:");
            Patients patient = getPatientByUserId(loggedInUser.getId());
            if (patient != null) {
                System.out.println("✅ Lấy thông tin bệnh nhân thành công!");
                System.out.println("Thông tin bệnh nhân:");
                System.out.println("Patient ID: " + patient.getPatientId());
                System.out.println("Họ tên: " + patient.getFullName());
                System.out.println("Số điện thoại: " + patient.getPhone());
                System.out.println("Ngày sinh: " + patient.getDateOfBirth());
                System.out.println("Giới tính: " + patient.getGender());
            } else {
                System.out.println("❌ Không tìm thấy thông tin bệnh nhân!");
            }
        } else {
            System.out.println("❌ Đăng nhập thất bại!");
        }
    }
}
