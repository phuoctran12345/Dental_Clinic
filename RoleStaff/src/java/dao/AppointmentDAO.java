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
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.SlotReservation;

/**
 * AppointmentDAO - Data Access Object for Appointment table
 * @author tranhongphuoc
 */
public class AppointmentDAO {
    
    // SQL Constants
    private static final String GET_ALL = "SELECT * FROM Appointment";
    private static final String GET_BY_ID = "SELECT * FROM Appointment WHERE appointment_id = ?";
    private static final String GET_BY_DATE = "SELECT * FROM Appointment WHERE work_date = ?";
    private static final String INSERT = "INSERT INTO Appointment (patient_id, doctor_id, slot_id, work_date, reason, status) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE Appointment SET patient_id = ?, doctor_id = ?, slot_id = ?, work_date = ?, reason = ?, status = ? WHERE appointment_id = ?";
    private static final String UPDATE_STATUS = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
    private static final String DELETE = "DELETE FROM Appointment WHERE appointment_id = ?";
    
    // Status constants cho reservation
    public static final String STATUS_RESERVED = "ĐANG GIỮ CHỖ";
    public static final String STATUS_WAITING_PAYMENT = "CHờ THANH TOÁN";
    public static final String STATUS_CONFIRMED = "ĐÃ ĐẶT";
    public static final String STATUS_EXPIRED = "HẾT HẠN";
    public static final String STATUS_CANCELLED = "ĐÃ HỦY";
    
    // Instance variables for connection management
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    /**
     * Lấy tất cả appointments
     */
    public List<Appointment> getAll() throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return appointments;
    }

    /**
     * Lấy appointment theo ID
     */
    public Appointment getAppointmentById(int appointmentId) throws SQLException {
        Appointment appointment = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = """
                    SELECT a.*, 
                           p.full_name as patient_name, 
                           p.phone as patient_phone,
                           d.full_name as doctor_name, 
                           d.specialty as doctor_specialty,
                           ts.start_time, 
                           ts.end_time,
                           s.service_name,
                           s.price as service_price
                    FROM Appointment a 
                    LEFT JOIN Patients p ON a.patient_id = p.patient_id
                    LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
                    LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                    LEFT JOIN Bills b ON b.patient_id = a.patient_id 
                        AND b.appointment_date = a.work_date 
                        AND b.doctor_id = a.doctor_id
                    LEFT JOIN Services s ON b.service_id = s.service_id
                    WHERE a.appointment_id = ?
                """;
                
                ps = conn.prepareStatement(sql);
                ps.setInt(1, appointmentId);
                rs = ps.executeQuery();
                
                            if (rs.next()) {
                    appointment = mapResultSetToAppointmentWithDetails(rs);
                    
                    // Set additional info
                    appointment.setPatientPhone(rs.getString("patient_phone"));
                    
                    // Set service info
                    String serviceName = rs.getString("service_name");
                    if (serviceName != null) {
                        appointment.setServiceName(serviceName);
                    } else {
                        appointment.setServiceName("Chưa có dịch vụ");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return appointment;
    }

    /**
     * Lấy appointments theo ngày với thông tin chi tiết
     */
    public List<Appointment> getAppointmentsByDate(java.sql.Date date) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String sql = """
                    SELECT a.*, 
                           p.full_name as patient_name, 
                           p.phone as patient_phone,
                           d.full_name as doctor_name, 
                           d.specialty as doctor_specialty,
                           ts.start_time, 
                           ts.end_time,
                           s.service_name,
                           s.price as service_price
                    FROM Appointment a 
                    LEFT JOIN Patients p ON a.patient_id = p.patient_id
                    LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
                    LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                    LEFT JOIN Bills b ON b.patient_id = a.patient_id 
                        AND b.appointment_date = a.work_date 
                        AND b.doctor_id = a.doctor_id
                    LEFT JOIN Services s ON b.service_id = s.service_id
                    WHERE a.work_date = ?
                    ORDER BY ts.start_time ASC
                """;
                
                ps = conn.prepareStatement(sql);
                ps.setDate(1, date);
                rs = ps.executeQuery();

                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointmentWithDetails(rs);
                    // Set additional info for date view
                    appointment.setPatientPhone(rs.getString("patient_phone"));
                    
                    // Set service info
                    String serviceName = rs.getString("service_name");
                    if (serviceName != null) {
                        appointment.setServiceName(serviceName);
                    } else {
                        appointment.setServiceName("Chưa có dịch vụ");
                    }
                    
                    appointments.add(appointment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return appointments;
    }

    /**
     * Tạo appointment mới
     */
    public int createAppointment(Appointment appointment) throws SQLException {
        int generatedId = 0;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, appointment.getPatientId());
                ps.setInt(2, appointment.getDoctorId());
                ps.setInt(3, appointment.getSlotId());
                ps.setDate(4, java.sql.Date.valueOf(appointment.getWorkDate()));
                ps.setString(5, appointment.getReason());
                ps.setString(6, appointment.getStatus());
                
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return generatedId;
    }

    /**
     * Cập nhật appointment
     */
    public boolean updateAppointment(Appointment appointment) throws SQLException {
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE);
                ps.setInt(1, appointment.getPatientId());
                ps.setInt(2, appointment.getDoctorId());
                ps.setInt(3, appointment.getSlotId());
                ps.setDate(4, java.sql.Date.valueOf(appointment.getWorkDate()));
                ps.setString(5, appointment.getReason());
                ps.setString(6, appointment.getStatus());
                ps.setInt(7, appointment.getAppointmentId());
                
                int rowsAffected = ps.executeUpdate();
                result = rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    /**
     * Cập nhật trạng thái appointment
     */
    public boolean updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_STATUS);
                ps.setString(1, status);
                ps.setInt(2, appointmentId);
                
                int rowsAffected = ps.executeUpdate();
                result = rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    /**
     * Xóa appointment
     */
    public boolean deleteAppointment(int appointmentId) throws SQLException {
        boolean result = false;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(DELETE);
                ps.setInt(1, appointmentId);
                
                int rowsAffected = ps.executeUpdate();
                result = rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    /**
     * Map ResultSet to Appointment object (basic)
     */
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("appointment_id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getInt("doctor_id"));
        appointment.setSlotId(rs.getInt("slot_id"));
        appointment.setWorkDate(rs.getDate("work_date").toLocalDate());
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        return appointment;
    }

    /**
     * Map ResultSet to Appointment object (with details)
     */
    private Appointment mapResultSetToAppointmentWithDetails(ResultSet rs) throws SQLException {
        Appointment appointment = mapResultSetToAppointment(rs);
        
        // Additional details
        appointment.setPatientName(rs.getString("patient_name"));
        appointment.setDoctorName(rs.getString("doctor_name"));
        
        // Safe handling for TIME columns - Try multiple approaches
        try {
            // First try as TIME
                Time startTime = rs.getTime("start_time");
                if (startTime != null) {
                appointment.setStartTime(startTime.toLocalTime());
            }
        } catch (Exception e1) {
            try {
                // Try as TIMESTAMP/DATETIME  
                Timestamp startTimestamp = rs.getTimestamp("start_time");
                if (startTimestamp != null) {
                    appointment.setStartTime(startTimestamp.toLocalDateTime().toLocalTime());
                }
            } catch (Exception e2) {
                // Silent fallback - don't spam logs
                appointment.setStartTime(LocalTime.of(9, 0)); // Default 9:00 AM
            }
        }
        
        try {
            // First try as TIME
            Time endTime = rs.getTime("end_time");
                if (endTime != null) {
                appointment.setEndTime(endTime.toLocalTime());
            }
        } catch (Exception e1) {
            try {
                // Try as TIMESTAMP/DATETIME
                Timestamp endTimestamp = rs.getTimestamp("end_time");
                if (endTimestamp != null) {
                    appointment.setEndTime(endTimestamp.toLocalDateTime().toLocalTime());
                }
            } catch (Exception e2) {
                // Silent fallback - don't spam logs
                appointment.setEndTime(LocalTime.of(10, 0)); // Default 10:00 AM  
            }
        }
        
        return appointment;
    }

    /**
     * Close database resources
     */
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ==================== STATIC METHODS FOR BACKWARD COMPATIBILITY ====================

    public static int createAppointmentStatic(Appointment appointment) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            return dao.createAppointment(appointment);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static List<Appointment> getAppointmentsByDateStatic(java.sql.Date date) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            return dao.getAppointmentsByDate(date);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static boolean updateAppointmentStatusStatic(int appointmentId, String status) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            return dao.updateAppointmentStatus(appointmentId, status);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Static methods needed by other classes
    public static List<Appointment> getAppointmentsByPatientId(int patientId) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> appointments = new ArrayList<>();
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT a.*, p.full_name AS patient_name, d.full_name AS doctor_name,
                       ts.start_time, ts.end_time
                FROM Appointment a
                LEFT JOIN Patients p ON a.patient_id = p.patient_id
                LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
                LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                WHERE a.patient_id = ?
                ORDER BY a.work_date DESC, ts.start_time ASC
            """;
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appointment = dao.mapResultSetToAppointmentWithDetails(rs);
                appointments.add(appointment);
            }
            conn.close();
            return appointments;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public static List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> appointments = new ArrayList<>();
            Connection conn = DBContext.getConnection();
        String sql = """
                SELECT a.*, p.full_name AS patient_name, d.full_name AS doctor_name,
                       ts.start_time, ts.end_time
            FROM Appointment a
                LEFT JOIN Patients p ON a.patient_id = p.patient_id
                LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
                LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                WHERE a.doctor_id = ? AND a.status != 'Đã hủy'
                ORDER BY a.work_date DESC, ts.start_time ASC
            """;
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appointment = dao.mapResultSetToAppointmentWithDetails(rs);
                appointments.add(appointment);
            }
            conn.close();
            return appointments;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static boolean isSlotAvailable(int doctorId, LocalDate workDate, int slotId) {
        try {
            Connection conn = DBContext.getConnection();
        String sql = """
                SELECT COUNT(*) FROM Appointment 
                WHERE doctor_id = ? AND work_date = ? AND slot_id = ? 
                AND status NOT IN (?, ?)
            """;
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setInt(3, slotId);
            ps.setString(4, STATUS_EXPIRED);
            ps.setString(5, STATUS_CANCELLED);
            ResultSet rs = ps.executeQuery();
            boolean available = false;
            if (rs.next()) {
                available = rs.getInt(1) == 0;
            }
            conn.close();
            return available;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Integer> getBookedSlots(int doctorId, LocalDate workDate) {
        try {
            List<Integer> bookedSlots = new ArrayList<>();
            Connection conn = DBContext.getConnection();
        String sql = """
                SELECT slot_id FROM Appointment 
                WHERE doctor_id = ? AND work_date = ? 
                AND status IN (?, ?, ?)
            """;
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setString(3, STATUS_CONFIRMED);
            ps.setString(4, STATUS_WAITING_PAYMENT);
            ps.setString(5, STATUS_RESERVED);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookedSlots.add(rs.getInt("slot_id"));
            }
            conn.close();
            return bookedSlots;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static SlotReservation createReservation(int doctorId, LocalDate workDate, int slotId, int patientId, String reason) {
        try {
        if (!isSlotAvailable(doctorId, workDate, slotId)) {
            return null;
        }
        
            Connection conn = DBContext.getConnection();
        String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        
            Timestamp expiresAt = Timestamp.valueOf(LocalDateTime.now().plusMinutes(5));
            String reservationReason = String.format("RESERVATION|%s|%s", 
                                                    expiresAt.toString(), 
                                                    reason != null ? reason : "");
            
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setDate(3, java.sql.Date.valueOf(workDate));
            ps.setInt(4, slotId);
            ps.setString(5, STATUS_RESERVED);
            ps.setString(6, reservationReason);
            
            int result = ps.executeUpdate();
            SlotReservation reservation = null;
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int appointmentId = rs.getInt(1);
                    reservation = new SlotReservation(doctorId, workDate, slotId, patientId);
                    reservation.setAppointmentId(appointmentId);
                    reservation.setExpiresAt(expiresAt);
                    reservation.setReservedAt(Timestamp.valueOf(LocalDateTime.now()));
                }
            }
            conn.close();
            return reservation;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Placeholder methods for missing functionality
    public static boolean insertAppointmentForRelative(int scheduleId, int patientId, String workDate, String startTime, int userId) {
        System.out.println("insertAppointmentForRelative: Not implemented yet");
        return false;
    }
    
    public static boolean checkAppointmentExistsBySlotId(int slotId, LocalDate workDate, LocalTime startTime) {
        System.out.println("checkAppointmentExistsBySlotId: Not implemented yet");
        return false;
    }

    public static boolean insertAppointmentBySlotId(int patientId, int doctorId, int slotId, LocalDate workDate, LocalTime startTime, String reason) {
        try {
            Connection conn = DBContext.getConnection();
        String sql = """
                INSERT INTO Appointment (patient_id, doctor_id, slot_id, work_date, reason, status)
                VALUES (?, ?, ?, ?, ?, ?)
            """;
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setInt(3, slotId);
            ps.setDate(4, java.sql.Date.valueOf(workDate));
            ps.setString(5, reason);
            ps.setString(6, "Đã xác nhận");
            
            int result = ps.executeUpdate();
            conn.close();
            
            System.out.println("✅ TẠO LỊCH HẸN THÀNH CÔNG: Patient " + patientId + 
                             " | Doctor " + doctorId + " | Slot " + slotId + " | Date " + workDate);
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ LỖI TẠO LỊCH HẸN: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean insertAppointmentBySlotId(int patientId, Integer doctorId, Integer slotId, LocalDate workDate, LocalTime startTime, String reason) {
        return insertAppointmentBySlotId(patientId, doctorId.intValue(), slotId.intValue(), workDate, startTime, reason);
    }

    public static boolean completeReservation(int appointmentId) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, STATUS_CONFIRMED); // "ĐÃ ĐẶT"
            ps.setInt(2, appointmentId);
            
            int result = ps.executeUpdate();
            conn.close();
            
            System.out.println("✅ HOÀN THÀNH RESERVATION: Appointment " + appointmentId + " → " + STATUS_CONFIRMED);
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ LỖI HOÀN THÀNH RESERVATION: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public static boolean cancelReservation(int appointmentId) {
        System.out.println("cancelReservation: Not implemented yet");
        return false;
    }
    
    public static int cleanupExpiredReservations() {
        System.out.println("cleanupExpiredReservations: Not implemented yet");
        return 0;
    }
    
    public static SlotReservation getActiveReservationByPatient(int patientId) {
        System.out.println("getActiveReservationByPatient: Not implemented yet");
        return null;
    }

    public static boolean confirmReservation(int appointmentId, String payosOrderId) {
        System.out.println("confirmReservation: Not implemented yet");
        return false;
    }

    public static List<SlotReservation> getReservationsByStatus(String status) {
        System.out.println("getReservationsByStatus: Not implemented yet");
        return new ArrayList<>();
    }
}