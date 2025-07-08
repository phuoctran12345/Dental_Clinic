package dao;

import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;

public class RelativesAppointmentDAO {
    /**
     * Tạo appointment cho người thân
     * @return appointment_id
     */
    public static int createAppointmentForRelative(int doctorId, String workDate, int slotId, String serviceId, String reason, int relativeId, int bookedByUserId) {
        int generatedId = 0;
        try {
            String sql = "INSERT INTO Appointment (doctor_id, work_date, slot_id, status, reason, relative_id, booked_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
            Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setInt(3, slotId);
            ps.setString(4, "BOOKED");
            ps.setString(5, reason);
            ps.setInt(6, relativeId);
            ps.setInt(7, bookedByUserId);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }
} 