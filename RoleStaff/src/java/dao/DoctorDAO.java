/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import model.Doctors;
import java.sql.*;
import java.util.HashSet;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;
import utils.DBContext;


public class DoctorDAO {
    public static Connection getConnect() {
        return DBContext.getConnection();
    }
    public static Doctors getDoctorInfo(int doctorId) {
        String sql = "SELECT * FROM Doctors WHERE doctor_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Doctors(
                    rs.getInt("doctor_id"),
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
     public static Set<Integer> getWorkDaysOfDoctor(long doctorId, int year, int month) {
        Set<Integer> workDays = new HashSet<>();
        String sql = "SELECT DISTINCT DAY(work_date) AS day FROM DoctorSchedule " +
                     "WHERE doctor_id = ? AND YEAR(work_date) = ? AND MONTH(work_date) = ?";

        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, doctorId);
            ps.setInt(2, year);
            ps.setInt(3, month);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                workDays.add(rs.getInt("day"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return workDays;
    }
    
    
     public static void main(String[] args) {
    Connection conn = getConnect();
    if (conn != null) {
        System.out.println("✅ Kết nối database thành công!");

        // Test lấy thông tin bác sĩ có userId = 1
        Doctors doctor = getDoctorInfo(1);
        if (doctor != null) {
            System.out.println("Thông tin bác sĩ:");
            System.out.println("Họ tên: " + doctor.getFull_name());
            System.out.println("Chuyên khoa: " + doctor.getSpecialty());
        } else {
            System.out.println("❌ Không tìm thấy bác sĩ với userId = 1");
        }
    } else {
        System.out.println("❌ Kết nối database thất bại!");
    }
     }

    public static List<Doctors> getAllDoctorsOnline() {
        List<Doctors> doctors = new ArrayList<>();
        String sql = "SELECT * FROM Doctors WHERE status = 'active'";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctors doctor = new Doctors(
                    rs.getLong("doctor_id"),
                    rs.getString("full_name"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getDate("date_of_birth"),
                    rs.getString("gender"),
                    rs.getString("specialty"),
                    rs.getString("license_number"),
                    rs.getDate("created_at")
                );
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            System.out.println("Error getting doctors: " + e);
        }
        return doctors;
    }
    
      public static List<Doctors> filterDoctors(String keyword, String specialty) {
        List<Doctors> list = new ArrayList<>();
        String sql = "SELECT * FROM Doctors WHERE 1=1";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND full_name LIKE ?";
        }
        if (specialty != null && !specialty.isEmpty()) {
            sql += " AND specialty = ?";
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            if (specialty != null && !specialty.isEmpty()) {
                ps.setString(i++, specialty);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctors d = new Doctors();
                d.setDoctor_id(rs.getInt("doctor_id"));
                d.setFull_name(rs.getString("full_name"));
                d.setSpecialty(rs.getString("specialty"));
                d.setPhone(rs.getString("phone"));
                d.setAvatar(rs.getString("avatar"));
                d.setStatus(rs.getString("status"));

                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
      
      
    public static List<String> getAllSpecialties() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT specialty FROM Doctors";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("specialty"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
        public static List<Doctors> getAllDoctors() {
        List<Doctors> list = new ArrayList<>();
        String sql = "SELECT * FROM Doctors";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctors doctor = new Doctors();
                doctor.setDoctor_id(rs.getInt("doctor_id"));
                doctor.setUser_id(rs.getInt("user_id"));
                doctor.setFull_name(rs.getString("full_name"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setAddress(rs.getString("address"));
                doctor.setDate_of_birth(rs.getDate("date_of_birth"));
                doctor.setGender(rs.getString("gender"));

                doctor.setSpecialty(rs.getString("specialty"));
                doctor.setLicense_number(rs.getString("license_number"));
                doctor.setCreated_at(rs.getDate("created_at"));
                doctor.setStatus(rs.getString("status"));
                doctor.setAvatar(rs.getString("avatar"));
                list.add(doctor);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

        public static Doctors getDoctorById(int doctorId) throws SQLException {
        Doctors doctor = null;

        String sql = "SELECT doctor_id, full_name, specialty, phone, status FROM Doctors WHERE doctor_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                doctor = new Doctors();
                doctor.setDoctor_id(rs.getInt("doctor_id"));
                doctor.setFull_name(rs.getString("full_name"));
                doctor.setSpecialty(rs.getString("specialty"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setStatus(rs.getString("status"));
            }
        }
        return doctor;
    }

    public static Doctors getDoctorByUserId(int userId) {
        String sql = "SELECT * FROM Doctors WHERE user_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Doctors(
                    rs.getInt("doctor_id"),
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
            System.out.println("Error getting doctor by user id: " + e);
        }
        return null;
    }
    

}

     
    


