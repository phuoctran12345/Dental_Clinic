/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.ArrayList;
import java.util.List;
import static Model.DatabaseInfo.DBURL;
import static Model.DatabaseInfo.DRIVERNAME;
import static Model.DatabaseInfo.PASSDB;
import static Model.DatabaseInfo.USERDB;

/**
 * UserDAO - Data Access Object cho bảng Users và OTP_Requests
 * @author ASUS
 */
public class UserDAO {

    /**
     * Kết nối database với logging chi tiết
     */
    public static Connection getConnect() {
        try {
            Class.forName(DRIVERNAME);
            System.out.println("🔌 Driver SQL Server đã được load thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Lỗi loading driver: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
        
        try {
            System.out.println("🔗 Đang kết nối đến database: " + DBURL);
            Connection con = DriverManager.getConnection(DBURL, USERDB, PASSDB);
            
            if (con != null) {
                System.out.println("✅ Kết nối database thành công!");
                return con;
            } else {
                System.err.println("❌ Connection trả về null!");
                return null;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kết nối database: " + e.getMessage());
            System.err.println("📋 Chi tiết lỗi:");
            System.err.println("   - URL: " + DBURL);
            System.err.println("   - User: " + USERDB);
            System.err.println("   - Error Code: " + e.getErrorCode());
            System.err.println("   - SQL State: " + e.getSQLState());
            e.printStackTrace();
            return null;
        }
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
    
    /**
     * Lấy thông tin user theo email
     */
    public static User getUserByEmail(String email) {
        try (Connection conn = getConnect()) {
            if (conn == null) return null;
            
            String sql = "SELECT * FROM Users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
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
            System.err.println("❌ Lỗi getUserByEmail: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy thông tin user theo ID
     */
    public static User getUserById(int userId) {
        try (Connection conn = getConnect()) {
            if (conn == null) return null;
            
            String sql = "SELECT * FROM Users WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
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
            System.err.println("❌ Lỗi getUserById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy danh sách tất cả users
     */
    public static List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = getConnect()) {
            if (conn == null) return users;
            
            String sql = "SELECT * FROM Users ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                users.add(new User(
                    rs.getInt("user_id"),
                    rs.getString("password_hash"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi getAllUsers: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Tạo user mới
     */
    public static boolean createUser(String email, String password, String role) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "INSERT INTO Users (email, password_hash, role, created_at) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            ps.setString(3, role);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Tạo user thành công: " + email);
                return true;
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi createUser: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lưu OTP vào session thay vì database
     * Đơn giản hơn và không cần tạo bảng
     */
    public static boolean saveOTP(String email, String otp) {
        try {
            // Chỉ log thông tin, không lưu vào database
            System.out.println("✅ Tạo OTP thành công cho email: " + email + " | OTP: " + otp);
            System.out.println("⏰ OTP sẽ hết hạn sau 5 phút");
            return true;
        } catch (Exception e) {
            System.err.println("❌ Lỗi tạo OTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xác minh OTP từ session thay vì database
     * Method này sẽ được gọi từ servlet với session
     */
    public static boolean verifyOTP(String inputOTP, String sessionOTP) {
        try {
            if (sessionOTP == null || inputOTP == null) {
                System.out.println("❌ OTP không tồn tại trong session");
                return false;
            }
            
            boolean isValid = sessionOTP.equals(inputOTP.trim());
            
            if (isValid) {
                System.out.println("✅ OTP xác minh thành công");
            } else {
                System.out.println("❌ OTP không đúng: " + inputOTP + " != " + sessionOTP);
            }
            
            return isValid;
        } catch (Exception e) {
            System.err.println("❌ Lỗi verifyOTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
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
     * Cập nhật thông tin user
     */
    public static boolean updateUser(User user) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "UPDATE Users SET email = ?, role = ? WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getRole());
            ps.setInt(3, user.getUserId());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Cập nhật user thành công: " + user.getEmail());
                return true;
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi updateUser: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
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
     * Đếm số lượng users theo role
     */
    public static int countUsersByRole(String role) {
        try (Connection conn = getConnect()) {
            if (conn == null) return 0;
            
            String sql = "SELECT COUNT(*) as count FROM Users WHERE role = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi countUsersByRole: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Kiểm tra user có active không
     */
    public static boolean isUserActive(String email) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "SELECT is_active FROM Users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBoolean("is_active");
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi isUserActive: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Cập nhật trạng thái active của user
     */
    public static boolean updateUserStatus(String email, boolean isActive) {
        try (Connection conn = getConnect()) {
            if (conn == null) return false;
            
            String sql = "UPDATE Users SET is_active = ? WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setString(2, email);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Cập nhật trạng thái user: " + email + " -> " + (isActive ? "Active" : "Inactive"));
                return true;
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi updateUserStatus: " + e.getMessage());
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
            conn = DBConnection.getConnection();
            
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
            conn = DBConnection.getConnection();
            
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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
