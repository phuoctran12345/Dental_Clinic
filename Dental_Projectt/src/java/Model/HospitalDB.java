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
    String sql = "SELECT * FROM users WHERE email = ?";
    try (Connection conn = DBConnection.getConnection();
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
        String sql = "INSERT INTO users (email, password_hash, role) VALUES (?, ?, 'PATIENT')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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

    public static boolean savePatientInfo(int id, String fullName, String phone, String dateOfBirth, String gender) {
        String sql = "INSERT INTO Patients (id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, dateOfBirth); // yyyy-MM-dd
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

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            patients = new Patients();
            patients.setPatientId(rs.getInt("patient_id"));
            patients.setId(rs.getInt("id"));
            patients.setFullName(rs.getString("full_name"));
            patients.setPhone(rs.getString("phone"));  // sửa chính tả
            patients.setDateOfBirth(rs.getDate("date_of_birth"));
            patients.setGender(rs.getString("gender"));
            patients.setCreatedAt(rs.getDate("created_at"));  // nếu có trường này trong DB

        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
    return patients;  // sửa tên biến trả về
}

    
    
    
    
}
