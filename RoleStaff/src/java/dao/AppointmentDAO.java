/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.SlotReservation;

/**
 *
 * @author tranhongphuoc
 */
public class AppointmentDAO {
    
    // Status constants cho reservation
    public static final String STATUS_RESERVED = "ĐANG GIỮ CHỖ";
    public static final String STATUS_WAITING_PAYMENT = "CHờ THANH TOÁN";
    public static final String STATUS_CONFIRMED = "ĐÃ ĐẶT";
    public static final String STATUS_EXPIRED = "HẾT HẠN";
    public static final String STATUS_CANCELLED = "ĐÃ HỦY";
    
    public static boolean insertAppointment(int scheduleId, int patientId, LocalDate workDate, LocalTime startTime, String reason) {
        String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason)
            SELECT ?, ds.doctor_id, ?, ds.slot_id, N'Đã đặt', ?
            FROM DoctorSchedule ds
            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
            WHERE ds.schedule_id = ? AND ts.start_time = ?
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setString(3, reason);
            ps.setInt(4, scheduleId);
            ps.setTime(5, Time.valueOf(startTime));

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean checkAppointmentExists(int scheduleId, LocalDate workDate, LocalTime startTime) {
        String sql = """
            SELECT COUNT(*) 
            FROM Appointment a
            JOIN DoctorSchedule ds ON a.doctor_id = ds.doctor_id
            JOIN TimeSlot ts ON a.slot_id = ts.slot_id
            WHERE ds.schedule_id = ? 
            AND a.work_date = ? 
            AND ts.start_time = ?
            AND a.status != N'Đã hủy'
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setTime(3, Time.valueOf(startTime));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.work_date, a.slot_id, a.status, a.reason, 
                   d.full_name AS doctor_name, ts.start_time, ts.end_time
            FROM Appointment a 
            LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
            LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
            WHERE a.patient_id = ? 
            ORDER BY a.work_date DESC
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setAppointmentId(rs.getInt("appointment_id"));
                ap.setPatientId(patientId);
                ap.setWorkDate(rs.getDate("work_date").toLocalDate());
                ap.setSlotId(rs.getInt("slot_id"));
                ap.setStatus(rs.getString("status"));
                ap.setReason(rs.getString("reason"));
                ap.setDoctorName(rs.getString("doctor_name"));
                
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                if (startTime != null) {
                    ap.setStartTime(startTime.toLocalTime());
                }
                if (endTime != null) {
                    ap.setEndTime(endTime.toLocalTime());
                }

                list.add(ap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<Appointment> getUpcomingAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.work_date, a.slot_id, a.status, a.reason, "
                + "d.full_name AS doctor_name, s.start_time, s.end_time "
                + "FROM Appointment a "
                + "JOIN Doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN TimeSlot s ON a.slot_id = s.slot_id "
                + "WHERE a.patient_id = ? AND a.work_date >= GETDATE() "
                + "ORDER BY a.work_date ASC";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setAppointmentId(rs.getInt("appointment_id"));
                ap.setWorkDate(rs.getDate("work_date").toLocalDate());
                ap.setSlotId(rs.getInt("slot_id"));
                ap.setDoctorName(rs.getString("doctor_name"));
                ap.setStatus(rs.getString("status"));
                
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                if (startTime != null) {
                    ap.setStartTime(startTime.toLocalTime());
                }
                if (endTime != null) {
                    ap.setEndTime(endTime.toLocalTime());
                }
                
                list.add(ap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.work_date, a.slot_id, a.status, a.reason,
                   p.full_name AS patient_name,
                   t.start_time, t.end_time
            FROM Appointment a
            JOIN Patients p ON a.patient_id = p.patient_id
            JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.doctor_id = ? AND a.status != N'Đã hủy'
            ORDER BY a.work_date DESC, t.start_time ASC
        """;

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setAppointmentId(rs.getInt("appointment_id"));
                ap.setPatientId(rs.getInt("patient_id"));
                ap.setDoctorId(doctorId);
                ap.setWorkDate(rs.getDate("work_date").toLocalDate());
                ap.setSlotId(rs.getInt("slot_id"));
                ap.setStatus(rs.getString("status"));
                ap.setReason(rs.getString("reason"));
                ap.setDoctorName(rs.getString("patient_name")); // Lưu tên bệnh nhân vào doctorName
                
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                if (startTime != null) {
                    ap.setStartTime(startTime.toLocalTime());
                }
                if (endTime != null) {
                    ap.setEndTime(endTime.toLocalTime());
                }

                list.add(ap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static boolean addAppointment(Appointment appointment) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // Method mới phù hợp với slotId từ form
    public static boolean insertAppointmentBySlotId(int slotId, int patientId, int doctorId, LocalDate workDate, LocalTime startTime, String reason) {
        String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason)
            VALUES (?, ?, ?, ?, N'Đã đặt', ?)
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setDate(3, java.sql.Date.valueOf(workDate));
            ps.setInt(4, slotId);
            ps.setString(5, reason);

            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: patientId=" + patientId + ", doctorId=" + doctorId + ", workDate=" + workDate + ", slotId=" + slotId + ", reason=" + reason);
            
            int result = ps.executeUpdate();
            System.out.println("SQL execution result: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error in insertAppointmentBySlotId: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Method mới để check appointment theo slotId
    public static boolean checkAppointmentExistsBySlotId(int slotId, LocalDate workDate, LocalTime startTime) {
        String sql = """
            SELECT COUNT(*) 
            FROM Appointment a
            WHERE a.slot_id = ? 
            AND a.work_date = ? 
            AND a.status != N'Đã hủy'
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Found " + count + " existing appointments for slotId=" + slotId + ", workDate=" + workDate);
                return count > 0;
            }
        } catch (Exception e) {
            System.err.println("Error in checkAppointmentExistsBySlotId: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // ==================== SLOT RESERVATION METHODS ====================
    
    /**
     * Tạo reservation mới - tạm khóa slot trong 5 phút
     * Sử dụng bảng Appointment với status đặc biệt
     */
    public static SlotReservation createReservation(int doctorId, LocalDate workDate, 
                                                   int slotId, int patientId, String reason) {
        
        // Kiểm tra slot có available không
        if (!isSlotAvailable(doctorId, workDate, slotId)) {
            return null;
        }
        
        String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Tạo timestamp cho việc hết hạn
            Timestamp expiresAt = Timestamp.valueOf(LocalDateTime.now().plusMinutes(5));
            String reservationReason = String.format("RESERVATION|%s|%s", 
                                                    expiresAt.toString(), 
                                                    reason != null ? reason : "");
            
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setDate(3, java.sql.Date.valueOf(workDate));
            ps.setInt(4, slotId);
            ps.setString(5, STATUS_RESERVED);
            ps.setString(6, reservationReason);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int appointmentId = rs.getInt(1);
                    
                    // Tạo SlotReservation object
                    SlotReservation reservation = new SlotReservation(doctorId, workDate, slotId, patientId);
                    reservation.setAppointmentId(appointmentId);
                    reservation.setExpiresAt(expiresAt);
                    reservation.setReservedAt(Timestamp.valueOf(LocalDateTime.now()));
                    
                    return reservation;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Kiểm tra slot có available để đặt không
     */
    public static boolean isSlotAvailable(int doctorId, LocalDate workDate, int slotId) {
        String sql = """
            SELECT COUNT(*) FROM Appointment 
            WHERE doctor_id = ? AND work_date = ? AND slot_id = ? 
            AND status NOT IN (?, ?)
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setInt(3, slotId);
            ps.setString(4, STATUS_EXPIRED);
            ps.setString(5, STATUS_CANCELLED);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking slot availability: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy reservation theo appointmentId
     */
    public static SlotReservation getReservationById(int appointmentId) {
        String sql = """
            SELECT appointment_id, patient_id, doctor_id, work_date, slot_id, status, reason
            FROM Appointment WHERE appointment_id = ?
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy reservation đang active của patient
     */
    public static SlotReservation getActiveReservationByPatient(int patientId) {
        String sql = """
            SELECT appointment_id, patient_id, doctor_id, work_date, slot_id, status, reason
            FROM Appointment 
            WHERE patient_id = ? AND status = ?
            ORDER BY appointment_id DESC
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ps.setString(2, STATUS_RESERVED);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                SlotReservation reservation = mapResultSetToReservation(rs);
                // Kiểm tra có hết hạn chưa
                if (reservation != null && reservation.isExpired()) {
                    // Auto expire
                    expireReservation(reservation.getAppointmentId());
                    return null;
                }
                return reservation;
            }
        } catch (SQLException e) {
            System.err.println("Error getting active reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Confirm reservation - chuyển sang trạng thái chờ thanh toán
     */
    public static boolean confirmReservation(int appointmentId, String payosOrderId) {
        String sql = """
            UPDATE Appointment 
            SET status = ?, reason = CONCAT(reason, '|PAYOS_ORDER:', ?)
            WHERE appointment_id = ? AND status = ?
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, STATUS_WAITING_PAYMENT);
            ps.setString(2, payosOrderId);
            ps.setInt(3, appointmentId);
            ps.setString(4, STATUS_RESERVED);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error confirming reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Complete reservation - chuyển sang trạng thái đã đặt
     */
    public static boolean completeReservation(int appointmentId) {
        String sql = """
            UPDATE Appointment 
            SET status = ?
            WHERE appointment_id = ? AND status = ?
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, STATUS_CONFIRMED);
            ps.setInt(2, appointmentId);
            ps.setString(3, STATUS_WAITING_PAYMENT);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error completing reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Expire reservation - đánh dấu hết hạn
     */
    public static boolean expireReservation(int appointmentId) {
        String sql = """
            UPDATE Appointment 
            SET status = ?
            WHERE appointment_id = ? AND status = ?
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, STATUS_EXPIRED);
            ps.setInt(2, appointmentId);
            ps.setString(3, STATUS_RESERVED);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error expiring reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Cancel reservation
     */
    public static boolean cancelReservation(int appointmentId) {
        String sql = """
            UPDATE Appointment 
            SET status = ?
            WHERE appointment_id = ? AND status IN (?, ?)
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, STATUS_CANCELLED);
            ps.setInt(2, appointmentId);
            ps.setString(3, STATUS_RESERVED);
            ps.setString(4, STATUS_WAITING_PAYMENT);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error cancelling reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Dọn dẹp các reservation hết hạn (chạy định kỳ)
     */
    public static int cleanupExpiredReservations() {
        String sql = """
            UPDATE Appointment 
            SET status = ?
            WHERE status = ? 
            AND reason LIKE 'RESERVATION|%|%'
            AND DATEDIFF(MINUTE, 
                CAST(SUBSTRING(reason, 13, 19) AS DATETIME), 
                GETDATE()) > 5
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, STATUS_EXPIRED);
            ps.setString(2, STATUS_RESERVED);
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error cleaning expired reservations: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lấy tất cả reservations theo status
     */
    public static List<SlotReservation> getReservationsByStatus(String status) {
        List<SlotReservation> reservations = new ArrayList<>();
        String sql = """
            SELECT appointment_id, patient_id, doctor_id, work_date, slot_id, status, reason
            FROM Appointment 
            WHERE status = ? AND reason LIKE 'RESERVATION|%'
            ORDER BY appointment_id DESC
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                SlotReservation reservation = mapResultSetToReservation(rs);
                if (reservation != null) {
                    reservations.add(reservation);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting reservations by status: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }
    
    /**
     * Map ResultSet to SlotReservation object
     */
    private static SlotReservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        SlotReservation reservation = new SlotReservation();
        
        reservation.setAppointmentId(rs.getInt("appointment_id"));
        reservation.setPatientId(rs.getInt("patient_id"));
        reservation.setDoctorId(rs.getInt("doctor_id"));
        reservation.setWorkDate(rs.getDate("work_date").toLocalDate());
        reservation.setSlotId(rs.getInt("slot_id"));
        reservation.setStatus(rs.getString("status"));
        
        // Parse reason field để lấy thông tin reservation
        String reason = rs.getString("reason");
        if (reason != null && reason.startsWith("RESERVATION|")) {
            String[] parts = reason.split("\\|");
            if (parts.length >= 2) {
                try {
                    Timestamp expiresAt = Timestamp.valueOf(parts[1]);
                    reservation.setExpiresAt(expiresAt);
                } catch (Exception e) {
                    System.err.println("Error parsing expires timestamp: " + e.getMessage());
                }
            }
            
            // Tìm PayOS order ID
            for (String part : parts) {
                if (part.startsWith("PAYOS_ORDER:")) {
                    reservation.setPayosOrderId(part.substring(12));
                    break;
                }
            }
        }
        
        return reservation;
    }
    
    /**
     * Lấy danh sách slots đã được đặt để disable trên UI
     */
    public static List<Integer> getBookedSlots(int doctorId, LocalDate workDate) {
        List<Integer> bookedSlots = new ArrayList<>();
        String sql = """
            SELECT slot_id FROM Appointment 
            WHERE doctor_id = ? AND work_date = ? 
            AND status IN (?, ?, ?)
        """;
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setString(3, STATUS_CONFIRMED);
            ps.setString(4, STATUS_WAITING_PAYMENT);
            ps.setString(5, STATUS_RESERVED);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookedSlots.add(rs.getInt("slot_id"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting booked slots: " + e.getMessage());
            e.printStackTrace();
        }
        return bookedSlots;
    }
}