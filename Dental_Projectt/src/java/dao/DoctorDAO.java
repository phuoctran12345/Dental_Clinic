/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import java.sql.*;
import utils.DBContext;
import model.Doctor; 

public class DoctorDAO {
    public static Connection getConnect() {
        return DBContext.getConnection();
    }
    
    public static Doctor getDoctorInfo(int userId) {
        String sql = "SELECT * FROM Doctors WHERE user_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Doctor(
                    rs.getInt("doctor_id"),
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getDate("date_of_birth"),
                    rs.getString("gender"),
                    rs.getString("specialty"),
                    rs.getString("license_number"),
                    rs.getDate("created_at")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getting doctor info: " + e);
        }
        return null;
    }

    public static int getUserId(int doctorId) {
        String sql = "SELECT user_id FROM Doctors WHERE doctor_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            System.out.println("Error getting user id: " + e);
        }
        return -1;
    }
//     public static void main(String[] args) {
//    Connection conn = getConnect();
//    if (conn != null) {
//        System.out.println("✅ Kết nối database thành công!");
//
//        // Test lấy thông tin bác sĩ có userId = 1
//        Dortor doctor = getDoctorInfo(1);
//        if (doctor != null) {
//            System.out.println("Thông tin bác sĩ:");
//            System.out.println("Họ tên: " + doctor.getFullName());
//            System.out.println("Chuyên khoa: " + doctor.getSpecialty());
//        } else {
//            System.out.println("❌ Không tìm thấy bác sĩ với userId = 1");
//        }
//    } else {
//        System.out.println("❌ Kết nối database thất bại!");
//    }
}

     
    


