/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
import java.sql.*;
import utils.DBContext;
import model.Staff;
import model.User;
import java.util.ArrayList;
import java.util.List;
import static utils.DBContext.getConnection;

/**
 * Class StaffDAO chứa các phương thức thao tác với database liên quan đến nhân viên
 * @author TranHongPhuoc
 */
public class StaffDAO {

    private static final String GET_ALL = "SELECT s.*, u.email FROM Staff s LEFT JOIN users u ON s.user_id = u.user_id";
    private static final String GET_ALL_SIMPLE = "SELECT * FROM Staff";
    private static final String GET_BY_ID = "SELECT * FROM Staff WHERE staff_id = ?";
    private static final String GET_BY_USER_ID = "SELECT * FROM Staff WHERE user_id = ?";
    private static final String INSERT = "INSERT INTO Staff (user_id, full_name, phone, date_of_birth, gender, address, position, employment_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE Staff SET full_name = ?, phone = ?, date_of_birth = ?, gender = ?, address = ?, position = ?, employment_type = ? WHERE staff_id = ?";
    private static final String DELETE = "DELETE FROM Staff WHERE staff_id = ?";
    private static final String COUNT_BY_NAME = "SELECT COUNT(*) as total FROM Staff WHERE full_name = ?";

    /**
     * Lấy kết nối đến database
     */
    private static Connection getConnect() {
        return DBContext.getConnection();
    }

    /**
     * Lấy danh sách tất cả nhân viên
     */
    public static List<Staff> getAllStaff() throws SQLException {
        List<Staff> staffList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_ALL);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    Staff staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setUserId(rs.getInt("user_id"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhone(rs.getString("phone"));
                    staff.setDateOfBirth(rs.getDate("date_of_birth"));
                    staff.setGender(rs.getString("gender"));
                    staff.setAddress(rs.getString("address"));
                    staff.setPosition(rs.getString("position"));
                    staff.setEmploymentType(rs.getString("employment_type"));
                    staff.setCreatedAt(rs.getDate("created_at"));
                    
                    // Lấy email từ JOIN query
                    staff.setUserEmail(rs.getString("email"));
                    
                    staffList.add(staff);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return staffList;
    }

    /**
     * Lấy tất cả nhân viên (đơn giản, không JOIN)
     */
    public static List<Staff> getAllSimple() throws SQLException {
        List<Staff> staffList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_ALL_SIMPLE);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    Staff staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setUserId(rs.getInt("user_id"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhone(rs.getString("phone"));
                    staff.setDateOfBirth(rs.getDate("date_of_birth"));
                    staff.setGender(rs.getString("gender"));
                    staff.setAddress(rs.getString("address"));
                    staff.setPosition(rs.getString("position"));
                    staff.setEmploymentType(rs.getString("employment_type"));
                    staff.setCreatedAt(rs.getDate("created_at"));
                    
                    // Set email to null for simple query
                    staff.setUserEmail("N/A");
                    
                    staffList.add(staff);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return staffList;
    }

    /**
     * Lấy thông tin nhân viên theo ID
     */
    public static Staff getStaffById(int id) throws SQLException {
        Staff staff = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_BY_ID);
                ptm.setInt(1, id);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(rs.getInt("user_id"));
                    
                    staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setUserId(rs.getInt("user_id"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhone(rs.getString("phone"));
                    staff.setDateOfBirth(rs.getDate("date_of_birth"));
                    staff.setGender(rs.getString("gender"));
                    staff.setAddress(rs.getString("address"));
                    staff.setPosition(rs.getString("position"));
                    staff.setEmploymentType(rs.getString("employment_type"));
                    staff.setCreatedAt(rs.getDate("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return staff;
    }

    /**
     * Lấy thông tin nhân viên theo user_id
     */
    public static Staff getStaffByUserId(int userId) throws SQLException {
        Staff staff = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_BY_USER_ID);
                ptm.setInt(1, userId);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(rs.getInt("user_id"));
                    
                    staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setUserId(rs.getInt("user_id"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhone(rs.getString("phone"));
                    staff.setDateOfBirth(rs.getDate("date_of_birth"));
                    staff.setGender(rs.getString("gender"));
                    staff.setAddress(rs.getString("address"));
                    staff.setPosition(rs.getString("position"));
                    staff.setEmploymentType(rs.getString("employment_type"));
                    staff.setCreatedAt(rs.getDate("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return staff;
    }

    /**
     * Thêm nhân viên mới
     */
    public static boolean insert(int userId, String fullName, String phone, String dateOfBirth, String gender, String address, String position, String employmentType) {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = getConnect();
            if (conn != null) {
                System.out.println("=== StaffDAO.insert() Debug ===");
                System.out.println("userId: " + userId);
                System.out.println("fullName: " + fullName);
                System.out.println("phone: " + phone);
                System.out.println("dateOfBirth: " + dateOfBirth);
                System.out.println("gender: " + gender);
                System.out.println("address: " + address);
                System.out.println("position: " + position);
                System.out.println("employmentType: " + employmentType);
                
                ptm = conn.prepareStatement(INSERT);
                ptm.setInt(1, userId);
                ptm.setString(2, fullName);
                ptm.setString(3, phone);
                
                // Xử lý các giá trị null
                if (dateOfBirth != null) {
                    ptm.setString(4, dateOfBirth);
                } else {
                    ptm.setNull(4, java.sql.Types.VARCHAR);
                }
                
                if (gender != null) {
                    ptm.setString(5, gender);
                } else {
                    ptm.setNull(5, java.sql.Types.VARCHAR);
                }
                
                if (address != null) {
                    ptm.setString(6, address);
                } else {
                    ptm.setNull(6, java.sql.Types.VARCHAR);
                }
                
                ptm.setString(7, position);
                ptm.setString(8, employmentType);
                
                int rowsAffected = ptm.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            System.out.println("❌ Error in StaffDAO.insert(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ptm != null) ptm.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Cập nhật thông tin nhân viên
     */
    public static boolean updateStaff(Staff staff) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(UPDATE);
                ptm.setString(1, staff.getFullName());
                ptm.setString(2, staff.getPhone());
                ptm.setDate(3, new java.sql.Date(staff.getDateOfBirth().getTime()));
                ptm.setString(4, staff.getGender());
                ptm.setString(5, staff.getAddress());
                ptm.setString(6, staff.getPosition());
                ptm.setString(7, staff.getEmploymentType());
                ptm.setInt(8, (int) staff.getStaffId());
                int rowsAffected = ptm.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return false;
    }

    /**
     * Xóa nhân viên
     */
// Trong StaffDAO.java
public boolean deleteStaffById(int staffId) throws SQLException {
    String sql = "DELETE FROM staff WHERE staff_id = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, staffId);
        return ps.executeUpdate() > 0;
    }
}

    /**
     * Đếm số nhân viên có cùng tên
     */
    public static int countByName(String name) throws SQLException {
        int count = 0;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(COUNT_BY_NAME);
                ptm.setString(1, name);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return count;
    }

    /**
     * Test database connection
     */
    public static void testDatabaseConnection() {
        System.out.println("🧪 [TEST] Bắt đầu test database connection...");
        
        Connection conn = null;
        try {
            conn = getConnect();
            
            if (conn == null) {
                System.err.println("❌ [TEST] Connection null");
                return;
            }
            
            System.out.println("✅ [TEST] Connection thành công!");
            
            // Test SELECT Staff table
            String sql = "SELECT COUNT(*) as total FROM Staff";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("📊 [TEST] Tổng số nhân viên: " + total);
            }
            
            // Test cấu trúc bảng
            sql = "SELECT TOP 1 staff_id, user_id, full_name, phone FROM Staff";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                System.out.println("📋 [TEST] Cấu trúc bảng Staff OK:");
                System.out.println("   - staff_id: " + rs.getInt("staff_id"));
                System.out.println("   - user_id: " + rs.getInt("user_id"));
                System.out.println("   - full_name: " + rs.getString("full_name"));
                System.out.println("   - phone: " + rs.getString("phone"));
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

    // Test main
    public static void main(String[] args) {
        try {
            // Test getAll
            List<Staff> staffList = getAllStaff();
            System.out.println("All staff:");
            for (Staff s : staffList) {
                System.out.println(s.getFullName());
            }
            
            // Test getById
            Staff staff = getStaffById(1);
            if (staff != null) {
                System.out.println("\nStaff with ID 1:");
                System.out.println("Name: " + staff.getFullName());
                System.out.println("Phone: " + staff.getPhone());
            }
            
            // Test count
            String testName = "Nguyễn Văn A";
            int count = countByName(testName);
            System.out.println("\nNumber of staff named '" + testName + "': " + count);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void close() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    // Method test để kiểm tra dữ liệu Staff
    public static void testGetAllStaff() {
        try {
            System.out.println("=== Testing getAll() method ===");
            List<Staff> staffList = getAllStaff();
            System.out.println("Total staff found: " + staffList.size());
            for (Staff staff : staffList) {
                System.out.println("Staff ID: " + staff.getStaffId() + 
                                 ", Name: " + staff.getFullName() + 
                                 ", Email: " + staff.getUserEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Error in testGetAllStaff: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Method test để kiểm tra dữ liệu Staff (đơn giản)
    public static void testGetAllStaffSimple() {
        try {
            System.out.println("=== Testing getAllSimple() method ===");
            List<Staff> staffList = getAllSimple();
            System.out.println("Total staff found (simple): " + staffList.size());
            for (Staff staff : staffList) {
                System.out.println("Staff ID: " + staff.getStaffId() + 
                                 ", Name: " + staff.getFullName() + 
                                 ", Email: " + staff.getUserEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Error in testGetAllStaffSimple: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    
    public void addStaff(Staff staff, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn == null) throw new SQLException("Không thể kết nối cơ sở dữ liệu.");
            conn.setAutoCommit(false);

            String insertUserSql = "INSERT INTO users (password_hash, email, role, created_at) VALUES (?, ?, ?, GETDATE())";
            pstmt = conn.prepareStatement(insertUserSql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, password);
            pstmt.setString(2, staff.getUserEmail());
            pstmt.setString(3, "STAFF");
            pstmt.executeUpdate();
            rs = pstmt.getGeneratedKeys();
            int userId = rs.next() ? rs.getInt(1) : 0;

            String insertStaffSql = "INSERT INTO Staff (user_id, full_name, phone, position, employment_type, created_at, status, hire_date, department, work_schedule) " +
                                  "VALUES (?, ?, ?, ?, ?, GETDATE(), 'active', GETDATE(), 'General', 'full_day')";
            pstmt = conn.prepareStatement(insertStaffSql);
            pstmt.setInt(1, userId);
            pstmt.setString(2, staff.getFullName());
            pstmt.setString(3, staff.getPhone());
            pstmt.setString(4, staff.getPosition());
            pstmt.setString(5, staff.getEmploymentType());
            pstmt.executeUpdate();

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
}
