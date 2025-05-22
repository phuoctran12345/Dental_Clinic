/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.*;

/**
 *
 * @author Home
 */
public class HospitalDB implements DatabaseInfo {

    public static Connection getConnect() {
        try {
            Class.forName(DRIVERNAME);
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading driver" + e);
        }
        try {
            Connection con = DriverManager.getConnection(DBURL, USERDB, PASSDB);
            return con;
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }
        return null;
    }

    //-----------------------------------------------------------------------------------------
    public static User getUserByEmailAndPassword(String email, String passwordHash) {
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();
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
                        rs.getString("phone"),
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

    public static boolean isPatientExists(String email, String phone) {
        String sql = "SELECT * FROM users WHERE email = ? OR phone = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            System.out.println("Checking existence for email: " + email + " | phone: " + phone);

            ps.setString(1, email);
            ps.setString(2, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có dòng kết quả thì đã tồn tại
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    //--------------------------------------------------------------------------------------------

    // Thêm khách hàng mới vào database
    public static boolean registerPatient(String username, String email, String phone, String passwordHash) {
        String sql = "INSERT INTO users (username, email, phone, password_hash, role) VALUES (?, ?, ?, ?, 'PATIENT')";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Kiểm tra dữ liệu đầu vào
            if (username == null || email == null || phone == null || passwordHash == null
                    || username.isEmpty() || email.isEmpty() || phone.isEmpty() || passwordHash.isEmpty()) {
                return false; // Tránh lỗi NULL
            }

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, passwordHash);

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0; // Trả về true nếu thành công

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
