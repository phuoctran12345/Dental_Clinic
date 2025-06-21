/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;
import static Model.DatabaseInfo.DBURL;
import static Model.DatabaseInfo.DRIVERNAME;
import static Model.DatabaseInfo.PASSDB;
import static Model.DatabaseInfo.USERDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author Home
 */
public class DoctorDAO implements DatabaseInfo {
    
    public static java.sql.Connection getConnect() {
        try {
            Class.forName(DRIVERNAME);
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading driver" + e);
        }
        try {
            java.sql.Connection con = DriverManager.getConnection(DBURL, USERDB, PASSDB);
            return con;
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }
        return null;
    }

    public static List<Appointment> getAppointmentsByDoctorId(int doctorId) {
    List<Appointment> list = new ArrayList<>();
    String sql = "SELECT * FROM Appointment WHERE doctor_id = ? AND status = N'Đã đặt'";

    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, doctorId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Appointment a = new Appointment();
            a.setAppointmentId(rs.getInt("appointment_id"));
            a.setPatientId(rs.getInt("patient_id"));
            a.setDoctorId(doctorId);
            a.setWorkDate(rs.getDate("work_date").toLocalDate());
            a.setSlotId(rs.getInt("slot_id"));
            list.add(a);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    
    
}
