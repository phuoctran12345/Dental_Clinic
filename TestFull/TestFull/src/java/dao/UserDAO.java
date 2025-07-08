package dao;

import java.security.MessageDigest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import utils.DBContext;
import model.User;
import model.Patients;

/**
 * UserDAO - Refactored theo pattern của PatientDAO
 * với instance variables + resource cleanup + static wrappers
 */
public class UserDAO {

    // Instance variables cho connection management (theo PatientDAO pattern)
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;
    
    // SQL Constants
    private static final String GET_ALL = "SELECT * FROM Users";
    private static final String GET_BY_ID = "SELECT * FROM Users WHERE user_id = ?";
    private static final String GET_BY_EMAIL = "SELECT * FROM Users WHERE email = ?";
    private static final String LOGIN_QUERY = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
    private static final String INSERT_USER = "INSERT INTO Users (email, password_hash, role) VALUES (?, ?, ?)";
    private static final String UPDATE_PASSWORD = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
    private static final String UPDATE_PASSWORD_BY_EMAIL = "UPDATE Users SET password_hash = ? WHERE email = ?";
    private static final String UPDATE_USER = "UPDATE Users SET email = ?, avatar = ? WHERE user_id = ?";
    private static final String CHECK_EMAIL = "SELECT 1 FROM Users WHERE email = ?";
    private static final String REGISTER_PATIENT = "INSERT INTO Users (email, password_hash, role) VALUES (?, ?, 'PATIENT')";
    
    /**
     * Đóng tất cả resources (connection, statement, resultset)
     */
    private void closeResources() {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Lấy tất cả users (instance method)
     */
    public List<User> getAll() throws SQLException {
        List<User> users = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL);
                rs = ps.executeQuery();
                while (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    users.add(user);
                }
            }
        } finally {
            closeResources();
        }
        return users;
    }
    
    /**
     * Lấy user theo ID (instance method)
     */
    public User getUserById(Integer userId) throws SQLException {
        User user = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_ID);
                ps.setInt(1, userId);
                rs = ps.executeQuery();
            if (rs.next()) {
                    user = mapResultSetToUser(rs);
            }
            }
        } finally {
            closeResources();
        }
        return user;
    }

    /**
     * Lấy user theo email - Internal method (instance method)
     */
    private User getUserByEmailInternal(String email) throws SQLException {
        User user = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_EMAIL);
            ps.setString(1, email);
                rs = ps.executeQuery();
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } finally {
            closeResources();
        }
        return user;
    }

    /**
     * Đăng nhập user (instance method) - KHÔNG HASH
     */
    public User loginUserInstance(String email, String password) throws SQLException {
        User user = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(LOGIN_QUERY);
                ps.setString(1, email);
                // So sánh trực tiếp mật khẩu gốc, không hash
                ps.setString(2, password); 
                rs = ps.executeQuery();
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } finally {
            closeResources();
        }
        return user;
    }

    /**
     * Đăng ký user mới (instance method) - KHÔNG HASH
     */
    public int registerUserInstance(String email, String password, String role) throws SQLException {
        int generatedId = 0;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, email);
                // Lưu mật khẩu gốc, không hash
                ps.setString(2, password); 
                ps.setString(3, role);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } finally {
            closeResources();
        }
        return generatedId;
    }

    /**
     * Cập nhật mật khẩu (instance method) - KHÔNG HASH
     */
    public boolean updatePasswordInstance(int userId, String newPassword) throws SQLException {
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_PASSWORD);
                // Cập nhật mật khẩu gốc, không hash
                ps.setString(1, newPassword); 
                ps.setInt(2, userId);

                int rowsUpdated = ps.executeUpdate();
                result = rowsUpdated > 0;
            }
        } finally {
            closeResources();
        }
        return result;
    }
    
    /**
     * Cập nhật user (instance method)
     */
    public boolean updateUserInstance(User user) throws SQLException {
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_USER);
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getAvatar());
            ps.setInt(3, user.getUserId());
            
            int rowsUpdated = ps.executeUpdate();
                result = rowsUpdated > 0;
            }
        } finally {
            closeResources();
        }
        return result;
        }
    
    /**
     * Cập nhật mật khẩu theo email (instance method) - KHÔNG HASH
     */
    public boolean updatePasswordByEmailInstance(String email, String newPassword) throws SQLException {
        if (email == null || email.trim().isEmpty() || newPassword == null || newPassword.isEmpty()) {
            return false;
        }
        
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                conn.setAutoCommit(false);
                try {
                    ps = conn.prepareStatement(UPDATE_PASSWORD_BY_EMAIL);
                    // Cập nhật mật khẩu gốc, không hash
                    ps.setString(1, newPassword);
                    ps.setString(2, email.trim().toLowerCase());
                    
                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        conn.commit();
                        result = true;
                    } else {
                        conn.rollback();
                    }
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                }
            }
        } finally {
            closeResources();
        }
        return result;
    }
    
    /**
     * Kiểm tra username có tồn tại không (instance method)
     */
        public boolean isEmailExistsInstance(String email) throws SQLException {
        boolean exists = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(CHECK_EMAIL);
                ps.setString(1, email);
                rs = ps.executeQuery();
                exists = rs.next();
            }
        } finally {
            closeResources();
        }
        return exists;
    }
    
    /**
     * Kiểm tra email đã tồn tại trong database chưa (instance method)
     */
    public boolean isPatientExistsInstance(String email) throws SQLException {
        boolean exists = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_EMAIL);
            ps.setString(1, email);
                rs = ps.executeQuery();
                exists = rs.next();
            }
        } finally {
            closeResources();
        }
        return exists;
    }
    
    /**
     * Map ResultSet to User object
     */
   private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setEmail(rs.getString("email"));
        user.setUsername(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setAvatar(rs.getString("avatar"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    // ==================== STATIC WRAPPER METHODS FOR SERVLET COMPATIBILITY ====================
    
    /**
     * Static wrapper for getUserByEmail - Servlet compatibility
     */
    public static User getUserByEmail(String email) {
        try {
            UserDAO dao = new UserDAO();
            return dao.getUserByEmailInternal(email);
        } catch (SQLException e) {
            e.printStackTrace();
        return null;
    }
    }
    
    /**
     * Static wrapper for getUserByEmailAndPassword - Servlet compatibility
     */
    public static User getUserByEmailAndPassword(String email, String password) {
        try {
            UserDAO dao = new UserDAO();
            return dao.loginUserInstance(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Static wrapper for registerPatient - Servlet compatibility - KHÔNG HASH
     */
    public static int registerPatient(String email, String password) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(REGISTER_PATIENT, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, email);
                // Lưu mật khẩu gốc, không hash
                ps.setString(2, password);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
        return 0;
    }
    
    /**
     * Static wrapper for getPatientByUserId - Servlet compatibility
     */
    public static Patients getPatientByUserId(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                // Fix: Sử dụng user_id thay vì id
                String sql = "SELECT * FROM Patients WHERE user_id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    Patients patient = new Patients();
                    // Fix: Sử dụng user_id cho setId
                    patient.setId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setDateOfBirth(rs.getDate("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    return patient;
    }
            }
        } catch (Exception e) {
            System.err.println("❌ Lỗi getPatientByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
        return null;
    }
    
    /**
     * Mã hóa mật khẩu bằng MD5
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
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
    
    // ==================== SERVLET COMPATIBILITY STATIC METHODS ====================
    
    public static boolean updatePassword(int userId, String newPassword) {
        try {
            UserDAO dao = new UserDAO();
            return dao.updatePasswordInstance(userId, newPassword);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean isEmailExists(String email) {
        try {
            UserDAO dao = new UserDAO();
            return dao.isEmailExistsInstance(email);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean isPatientExists(String email) {
        try {
            UserDAO dao = new UserDAO();
            return dao.isPatientExistsInstance(email);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updatePasswordByEmail(String email, String newPassword) {
        try {
            UserDAO dao = new UserDAO();
            return dao.updatePasswordByEmailInstance(email, newPassword);
        } catch (SQLException e) {
                    return false;
                }
    }

    public static User loginUser(String email, String password) {
        try {
            UserDAO dao = new UserDAO();
            return dao.loginUserInstance(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
    }
    }

    public static boolean updateUser(User user) {
        try {
            UserDAO dao = new UserDAO();
            return dao.updateUserInstance(user);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
      /**
     * Static - Get user by ID
     */
    public static User getUserById(int userId) {
        try {
            UserDAO dao = new UserDAO();
            return dao.getUserById(Integer.valueOf(userId)); // Call instance method with Integer
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
    }
    }

    public static boolean savePatientInfo(int user_id, String fullName, String phone, String dateOfBirth, String gender) {
        String sql = "INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user_id);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, dateOfBirth);
            ps.setString(5, gender);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi savePatientInfo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updatePasswordHash(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updatePasswordPlainText(String email, String newPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static void testDatabaseConnection() {
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                String sql = "SELECT COUNT(*) as total FROM Users";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("✅ [TEST] Database connected. Total users: " + rs.getInt("total"));
                    }
                }
            }
                } catch (Exception e) {
            System.err.println("❌ [TEST] Database connection failed: " + e.getMessage());
        }
    }
    
       /**
     * Lấy connection tĩnh cho static methods
     */
    private static Connection getConnect() {
        return DBContext.getConnection();
    }

    /**
     * MAIN METHOD - Test database connection và các method (KHÔNG HASH)
     */
    public static void main(String[] args) {
        System.out.println("🧪 [TEST] Bắt đầu test UserDAO (NO HASHING)...");
        
        // Test 1: Database connection
        System.out.println("\n=== TEST 1: Database Connection ===");
        testDatabaseConnection();
        
        // Test 2: Check user exists
        System.out.println("\n=== TEST 2: Check User Exists ===");
        String testEmail = "phuocthde180577@fpt.edu.vn";
        String testPassword = "Phuoc12345#";
        
        User user = getUserByEmail(testEmail);
        if (user != null) {
            System.out.println("✅ User found:");
            System.out.println("   - ID: " + user.getUserId());
            System.out.println("   - Username: " + user.getUsername());
            System.out.println("   - Email: " + user.getEmail());
            System.out.println("   - Password in DB: " + user.getPasswordHash());
            System.out.println("   - Role: " + user.getRole());
            
            // Test 3: Compare passwords
            System.out.println("\n=== TEST 3: Password Comparison ===");
            System.out.println("Input password: " + testPassword);
            System.out.println("DB password:    " + user.getPasswordHash());
            System.out.println("Passwords match: " + testPassword.equals(user.getPasswordHash()));
            
            // Test 4: Login test
            System.out.println("\n=== TEST 4: Login Test ===");
            User loginResult = loginUser(testEmail, testPassword);
            if (loginResult != null) {
                System.out.println("✅ Login successful!");
                System.out.println("   - Logged in as: " + loginResult.getUsername());
            } else {
                System.out.println("❌ Login failed!");
            }
        } else {
            System.out.println("❌ User NOT found with email: " + testEmail);
        }
        
        System.out.println("\n🏁 [TEST] Test completed!");
    }

    /**
     * Xóa user theo user_id (static method)
     */
    public static boolean deleteUserById(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM Users WHERE user_id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
        return false;
    }
} 