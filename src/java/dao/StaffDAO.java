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

/**
 * Class StaffDAO chứa các phương thức thao tác với database liên quan đến nhân viên
 * @author TranHongPhuoc
 */
public class StaffDAO {

    private static final String GET_ALL = "SELECT * FROM Staff";
    private static final String GET_BY_ID = "SELECT * FROM Staff WHERE staff_id = ?";
    private static final String GET_BY_USER_ID = "SELECT * FROM Staff WHERE user_id = ?";
    private static final String INSERT = "INSERT INTO Staff (user_id, full_name, phone, date_of_birth, gender, address, position, employment_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE Staff SET full_name = ?, phone = ?, date_of_birth = ?, gender = ?, address = ?, position = ?, employment_type = ?, avatar = ? WHERE staff_id = ?";
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
    public static List<Staff> getAll() throws SQLException {
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
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(rs.getInt("user_id"));
                    
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
                    staff.setAvatar(rs.getString("avatar"));
                    
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
                    staff.setAvatar(rs.getString("avatar"));
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
                    staff.setAvatar(rs.getString("avatar"));
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
                ptm = conn.prepareStatement(INSERT);
                ptm.setInt(1, userId);
                ptm.setString(2, fullName);
                ptm.setString(3, phone);
                ptm.setString(4, dateOfBirth);
                ptm.setString(5, gender);
                ptm.setString(6, address);
                ptm.setString(7, position);
                ptm.setString(8, employmentType);
                int rowsAffected = ptm.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
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
                System.out.println("[StaffDAO] updateStaff - Updating staff: " + staff.getStaffId());
                System.out.println("[StaffDAO] updateStaff - Avatar value: " + staff.getAvatar());
                System.out.println("[StaffDAO] updateStaff - SQL: " + UPDATE);
                
                ptm = conn.prepareStatement(UPDATE);
                ptm.setString(1, staff.getFullName());
                ptm.setString(2, staff.getPhone());
                ptm.setDate(3, new java.sql.Date(staff.getDateOfBirth().getTime()));
                ptm.setString(4, staff.getGender());
                ptm.setString(5, staff.getAddress());
                ptm.setString(6, staff.getPosition());
                ptm.setString(7, staff.getEmploymentType());
                ptm.setString(8, staff.getAvatar());
                ptm.setInt(9, (int) staff.getStaffId());
                
                System.out.println("[StaffDAO] updateStaff - Parameters set, executing update...");
                int rowsAffected = ptm.executeUpdate();
                System.out.println("[StaffDAO] updateStaff - Rows affected: " + rowsAffected);
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            System.out.println("[StaffDAO] updateStaff - Exception: " + e.getMessage());
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
    public static boolean delete(int staffId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = getConnect();
            if (conn != null) {
                ptm = conn.prepareStatement(DELETE);
                ptm.setInt(1, staffId);
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
            List<Staff> staffList = getAll();
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
}
