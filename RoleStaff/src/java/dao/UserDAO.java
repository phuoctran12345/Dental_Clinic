package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.Random;
import utils.DBContext;
import model.User;
import model.Patients;

/**
 * Class UserDAO chứa các phương thức thao tác với database liên quan đến người dùng
 * @author Home && Asus
 */
public class UserDAO {

    /**
     * Lấy kết nối đến database
     * @return Connection object
     * @return 
     */
    public static Connection getConnect() {
        return DBContext.getConnection();
    }

    /**
     * Lấy thông tin user dựa vào email và password
     * @param email Email của user
     * @param password Mật khẩu đã hash
     * @return User object nếu tìm thấy, null nếu không tìm thấy
     */
    public static User getUserByEmailAndPassword(String email, String password) {
        User user = null;
        try {
            Connection conn = getConnect();
            String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // Trong thực tế nên hash password trước khi so sánh
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("user_id"),
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

    /**
     * Kiểm tra email đã tồn tại trong database chưa
     * @param email Email cần kiểm tra
     * @return true nếu email đã tồn tại, false nếu chưa
     */
    public static boolean isPatientExists(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
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

    /**
     * Kiểm tra username đã tồn tại trong database chưa
     * @param username Username cần kiểm tra
     * @return true nếu username đã tồn tại, false nếu chưa
     */
    public static boolean isUsernameExists(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            System.out.println("Checking existence for username: " + username);
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                boolean exists = rs.next();
                System.out.println("Username exists? " + exists);
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đăng ký user mới với role là PATIENT
     * @param username Tên đăng nhập
     * @param email Email
     * @param passwordHash Mật khẩu đã hash
     * @return ID của user mới nếu đăng ký thành công, -1 nếu thất bại
     */
    public static int registerPatient(String username, String email, String passwordHash) {
        String sql = "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, 'PATIENT')";
        try (Connection conn = getConnect(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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

    /**
     * Lưu thông tin chi tiết của bệnh nhân
     * @param id ID của user
     * @param fullName Họ tên đầy đủ
     * @param phone Số điện thoại
     * @param dateOfBirth Ngày sinh
     * @param gender Giới tính
     * @return true nếu lưu thành công, false nếu thất bại
     */
    public static boolean savePatientInfo(int user_id, String fullName, String phone, String dateOfBirth, String gender) {
        String sql = "INSERT INTO Patients (id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnect(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, user_id);
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
    
    /**
     * Lấy thông tin chi tiết của bệnh nhân dựa vào user ID
     * @param id ID của user
     * @return Patients object chứa thông tin bệnh nhân, null nếu không tìm thấy
     */
    public static Patients getPatientByUserId(int id) {
        Patients patients = null;
        String sql = "SELECT patient_id, user_id, full_name, phone, date_of_birth, gender, created_at " +
                     "FROM Patients WHERE user_id = ?";

        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                patients = new Patients();
                patients.setPatientId(rs.getInt("patient_id"));
                patients.setId(rs.getInt("user_id"));
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


        

        

    public User getUserById(Integer userId) {
        User user = null;
        try {
            Connection conn = getConnect();
            String sql = "SELECT * FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
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

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET email = ?, avatar = ? WHERE user_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getAvatar());
            ps.setInt(3, user.getId());
            
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPassword); // Trong thực tế nên hash mật khẩu trước khi lưu
            ps.setInt(2, userId);
            
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static User checkLogin(String username, String password, String role) {
        String sql = "SELECT * FROM users WHERE username = ? AND password_hash = ? AND role = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password); // Trong thực tế nên mã hóa password
            ps.setString(3, role);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password_hash"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getDate("created_at"),
                    rs.getString("avatar")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error checking login: " + e);
        }
        return null;
    }
    
      /**
     * Đăng nhập user
     */
    public static User loginUser(String email, String password) {
        try (Connection conn = getConnect()) {
            if (conn == null) return null;
            
            String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("password_hash"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at")
                );
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi loginUser: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public static User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password_hash"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getDate("created_at"),
                    rs.getString("avatar")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by id: " + e);
        }
        return null;
    }

    public static User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password_hash"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at"),
                    rs.getString("avatar")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by email: " + e);
        }
        return null;
    }
    
    

    // Thêm khách hàng mới vào database
    public static int registerPatient(String email, String passwordHash) {
        String sql = "INSERT INTO Users (email, password_hash, role) VALUES (?, ?, 'PATIENT')";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về int user_id
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    
   
    
    /**
     * Mã hóa mật khẩu bằng MD5
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * Tạo mã OTP ngẫu nhiên 6 chữ số
     */
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
     
    /**
     * Cập nhật mật khẩu theo email
     */
    public static boolean updatePasswordByEmail(String email, String newPassword) {
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            System.err.println("❌ Email không được trống");
            return false;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            System.err.println("❌ Mật khẩu mới không được trống");
            return false;
        }
        
        if (newPassword.length() < 6) {
            System.err.println("❌ Mật khẩu phải có ít nhất 6 ký tự");
            return false;
        }
        
        email = email.trim().toLowerCase();
        
        // Kiểm tra email có tồn tại không
        if (!checkEmailExists(email)) {
            System.err.println("❌ Email không tồn tại trong hệ thống: " + email);
            return false;
        }
        
        try (Connection conn = getConnect()) {
            if (conn == null) {
                System.err.println("❌ Không thể kết nối database");
                return false;
            }
            
            // Bắt đầu transaction
            conn.setAutoCommit(false);
            
            try {
                String sql = "UPDATE Users SET password_hash = ? WHERE email = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                String hashedPassword = hashPassword(newPassword);
                
                ps.setString(1, hashedPassword);
                ps.setString(2, email);
                
                System.out.println("🔄 Đang cập nhật mật khẩu cho email: " + email);
                System.out.println("🔒 Mật khẩu đã được hash: " + hashedPassword.substring(0, 10) + "...");
                
                int result = ps.executeUpdate();
                
                if (result > 0) {
                    // Commit transaction
                    conn.commit();
                    System.out.println("✅ Cập nhật mật khẩu thành công cho: " + email);
                    System.out.println("📊 Số dòng được cập nhật: " + result);
                    
                    // Verify update bằng cách kiểm tra lại
                    if (verifyPasswordUpdate(email, newPassword)) {
                        System.out.println("✅ Xác minh cập nhật thành công!");
                        return true;
                    } else {
                        System.err.println("❌ Xác minh cập nhật thất bại!");
                        return false;
                    }
                } else {
                    // Rollback nếu không có dòng nào được cập nhật
                    conn.rollback();
                    System.err.println("❌ Không có dòng nào được cập nhật cho email: " + email);
                    return false;
                }
                
            } catch (Exception e) {
                // Rollback nếu có lỗi
                conn.rollback();
                throw e;
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi updatePasswordByEmail: " + e.getMessage());
            System.err.println("📧 Email: " + email);
            System.err.println("🔍 Chi tiết lỗi:");
            e.printStackTrace();
        }
        return false;
    }

    
      /**
     * Xác minh mật khẩu đã được cập nhật thành công
     */
    private static boolean verifyPasswordUpdate(String email, String newPassword) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "SELECT password_hash FROM Users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email.trim().toLowerCase());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String newHash = hashPassword(newPassword);
                
                boolean matches = storedHash.equals(newHash);
                System.out.println("🔍 Xác minh hash:");
                System.out.println("   - Hash mới: " + newHash.substring(0, 10) + "...");
                System.out.println("   - Hash DB:  " + storedHash.substring(0, 10) + "...");
                System.out.println("   - Khớp: " + (matches ? "✅" : "❌"));
                
                return matches;
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi verifyPasswordUpdate: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    
    /**
     * Kiểm tra email có tồn tại không
     */
    public static boolean checkEmailExists(String email) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "SELECT 1 FROM Users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.err.println("❌ Lỗi checkEmailExists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
      /**
     * Xóa user
     */
    public static boolean deleteUser(int userId) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "DELETE FROM Users WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Xóa user thành công: ID " + userId);
                return true;
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi deleteUser: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
        /**
     * Cập nhật mật khẩu theo email - Phiên bản đơn giản để debug
     */
    public static boolean updatePasswordByEmailSimple(String email, String newPassword) {
        System.out.println("🔄 [DEBUG] Bắt đầu updatePasswordByEmailSimple");
        System.out.println("📧 [DEBUG] Email: " + email);
        System.out.println("🔒 [DEBUG] Password length: " + (newPassword != null ? newPassword.length() : "null"));
        
        if (email == null || email.trim().isEmpty()) {
            System.err.println("❌ [DEBUG] Email trống");
            return false;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            System.err.println("❌ [DEBUG] Password trống");
            return false;
        }
        
        email = email.trim().toLowerCase();
        
        // Sử dụng DBConnection thay vì getConnect()
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            System.out.println("🔌 [DEBUG] Đang kết nối database...");
            conn = DBContext.getConnection();
            
            if (conn == null) {
                System.err.println("❌ [DEBUG] Connection null");
                return false;
            }
            
            System.out.println("✅ [DEBUG] Kết nối thành công!");
            
            // Kiểm tra email tồn tại trước
            String checkSql = "SELECT user_id, email, password_hash FROM Users WHERE email = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setString(1, email);
            ResultSet checkRs = ps.executeQuery();
            
            if (!checkRs.next()) {
                System.err.println("❌ [DEBUG] Email không tồn tại: " + email);
                return false;
            }
            
            int userId = checkRs.getInt("user_id");
            String oldHash = checkRs.getString("password_hash");
            System.out.println("✅ [DEBUG] Email tồn tại - UserID: " + userId);
            System.out.println("🔒 [DEBUG] Hash cũ: " + oldHash.substring(0, 10) + "...");
            
            // Đóng ResultSet và PreparedStatement cũ
            checkRs.close();
            ps.close();
            
            // Hash mật khẩu mới
            String newHash = hashPassword(newPassword);
            System.out.println("🔒 [DEBUG] Hash mới: " + newHash.substring(0, 10) + "...");
            
            // Cập nhật mật khẩu
            String updateSql = "UPDATE Users SET password_hash = ? WHERE email = ?";
            ps = conn.prepareStatement(updateSql);
            ps.setString(1, newHash);
            ps.setString(2, email);
            
            System.out.println("🔄 [DEBUG] Thực hiện UPDATE...");
            int rowsAffected = ps.executeUpdate();
            
            System.out.println("📊 [DEBUG] Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("✅ [DEBUG] UPDATE thành công!");
                
                // Verify bằng cách SELECT lại
                ps.close();
                String verifySql = "SELECT password_hash FROM Users WHERE email = ?";
                ps = conn.prepareStatement(verifySql);
                ps.setString(1, email);
                ResultSet verifyRs = ps.executeQuery();
                
                if (verifyRs.next()) {
                    String updatedHash = verifyRs.getString("password_hash");
                    System.out.println("🔍 [DEBUG] Hash sau update: " + updatedHash.substring(0, 10) + "...");
                    
                    boolean matches = newHash.equals(updatedHash);
                    System.out.println("✅ [DEBUG] Hash khớp: " + matches);
                    
                    verifyRs.close();
                    return matches;
                } else {
                    System.err.println("❌ [DEBUG] Không thể verify - không tìm thấy user");
                    return false;
                }
            } else {
                System.err.println("❌ [DEBUG] UPDATE thất bại - 0 rows affected");
                return false;
            }
            
        } catch (Exception e) {
            System.err.println("❌ [DEBUG] Exception: " + e.getMessage());
            System.err.println("❌ [DEBUG] Exception class: " + e.getClass().getName());
            e.printStackTrace();
            return false;
        } finally {
            // Đóng connection
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
                System.out.println("🔌 [DEBUG] Đã đóng connection");
            } catch (Exception e) {
                System.err.println("❌ [DEBUG] Lỗi đóng connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Test method để kiểm tra database connection và cấu trúc bảng
     */
    public static void testDatabaseConnection() {
        System.out.println("🧪 [TEST] Bắt đầu test database connection...");
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            
            if (conn == null) {
                System.err.println("❌ [TEST] Connection null");
                return;
            }
            
            System.out.println("✅ [TEST] Connection thành công!");
            
            // Test SELECT Users table
            String sql = "SELECT COUNT(*) as total FROM Users";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("📊 [TEST] Tổng số users: " + total);
            }
            
            // Test cấu trúc bảng
            sql = "SELECT TOP 1 user_id, email, password_hash, role FROM Users";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                System.out.println("📋 [TEST] Cấu trúc bảng Users OK:");
                System.out.println("   - user_id: " + rs.getInt("user_id"));
                System.out.println("   - email: " + rs.getString("email"));
                System.out.println("   - password_hash: " + rs.getString("password_hash").substring(0, 10) + "...");
                System.out.println("   - role: " + rs.getString("role"));
            }
            
            rs.close();
            ps.close();
            
        } catch (Exception e) {
            System.err.println("❌ [TEST] Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    System.err.println("❌ [TEST] Lỗi đóng connection: " + e.getMessage());
                }
            }
        }
    }
    
       /**
     * ⚠️ NGUY HIỂM: Cập nhật mật khẩu KHÔNG mã hóa (chỉ dùng để test)
     * KHÔNG nên sử dụng trong môi trường thực tế!
     */
    public static boolean updatePasswordPlainText(String email, String newPassword) {
        System.out.println("⚠️ [CẢNH BÁO] Đang lưu mật khẩu KHÔNG mã hóa - NGUY HIỂM!");
        System.out.println("📧 Email: " + email);
        System.out.println("🔓 Plain password: " + newPassword);
        
        String sql = "UPDATE Users SET password_hash = ? WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // KHÔNG hash, lưu trực tiếp mật khẩu
            ps.setString(1, newPassword);
            ps.setString(2, email);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ Cập nhật mật khẩu plain text thành công");
                return true;
            } else {
                System.err.println("❌ Cập nhật thất bại");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * ⚠️ NGUY HIỂM: Đăng nhập với mật khẩu plain text
     */
    public static User loginUserPlainText(String email, String password) {
        System.out.println("⚠️ [CẢNH BÁO] Đang đăng nhập với plain text - NGUY HIỂM!");
        
        try (Connection conn = getConnect()) {
            if (conn == null) return null;
            
            String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // So sánh trực tiếp, KHÔNG hash
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("password_hash"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at")
                );
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi loginUserPlainText: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    

}
