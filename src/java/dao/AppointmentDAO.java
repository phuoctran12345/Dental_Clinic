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
import java.util.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.SlotReservation;
import static utils.DBContext.getConnection;
import model.TimeSlot;
import dao.TimeSlotDAO;

/**
 * AppointmentDAO - Data Access Object for Appointment table
 *
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

    // Status constants for Appointment (English - Chỉ 4 trạng thái chính)
    public static final String STATUS_BOOKED = "BOOKED";               // Đã đặt lịch (thay thế CONFIRMED)
    public static final String STATUS_COMPLETED = "COMPLETED";         // Hoàn thành
    public static final String STATUS_CANCELLED = "CANCELLED";         // Đã hủy
    public static final String STATUS_WAITING_PAYMENT = "WAITING_PAYMENT"; // Chờ thanh toán

    // Instance variables for connection management
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    /**
     * Lấy tất cả appointments
     */
    public  List<Appointment> getAll() {
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
     * Tạo appointment mới (chuẩn OOP - nhận đối tượng Appointment)
     */
    public int createAppointment(Appointment appointment) throws SQLException {
        int generatedId = 0;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, appointment.getPatientId());
                ps.setLong(2, appointment.getDoctorId());
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
                ps.setLong(2, appointment.getDoctorId());  // ✅ Dùng setLong
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
    private static Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("appointment_id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getLong("doctor_id"));  // ✅ Dùng getLong cho BIGINT
        appointment.setSlotId(rs.getInt("slot_id"));
        appointment.setWorkDate(rs.getDate("work_date").toLocalDate());
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        
        // ✅ Thêm doctor_name từ database nếu có
        try {
            appointment.setDoctorName(rs.getString("doctor_name"));
        } catch (SQLException e) {
            // Ignore nếu column không tồn tại
        }
        
        // ✅ Thêm previous_appointment_id nếu có
        try {
            appointment.setPreviousAppointmentId(rs.getInt("previous_appointment_id"));
        } catch (SQLException e) {
            // Ignore nếu column không tồn tại
        }
        
        return appointment;
    }

    /**
     * Map ResultSet to Appointment object (with details)
     */
    private static Appointment mapResultSetToAppointmentWithDetails(ResultSet rs) throws SQLException {
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
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ==================== STATIC METHODS FOR BACKWARD COMPATIBILITY ====================
    public static int createAppointmentStatic(Appointment appointment) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            return dao.createAppointment(appointment);
        } catch (Exception e) {
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

    public static List<Appointment> getAppointmentsByDoctorId(long doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, a.slot_id, a.status, a.reason, a.doctor_name, "
                + "p.full_name AS patient_name "
                + "FROM Appointment a "
                + "JOIN Patients p ON a.patient_id = p.patient_id "
                + "WHERE a.doctor_id = ? AND a.status = N'Đã đặt'";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, doctorId);  // ✅ Dùng setLong
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDoctorId(rs.getLong("doctor_id"));  // ✅ Dùng getLong
                a.setWorkDate(rs.getDate("work_date").toLocalDate());
                a.setSlotId(rs.getInt("slot_id"));
                a.setStatus(rs.getString("status"));
                a.setReason(rs.getString("reason"));
                a.setPatientName(rs.getString("patient_name"));
                a.setDoctorName(rs.getString("doctor_name"));  // ✅ Thêm doctor_name
                list.add(a);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //*-------------------------------------------------------------*

    public List<Appointment> getAppointmentsByUserId(int userId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();

        // Sửa lại query để phù hợp với database schema
        // Lấy appointments cho doctor dựa trên userId -> doctorId
        String query = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason
            FROM Appointment a
            INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
            WHERE d.user_id = ?
            ORDER BY a.work_date DESC, a.slot_id ASC
        """;

        System.out.println("Executing query for userId: " + userId);
        System.out.println("Query: " + query);

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            // Thiết lập tham số userId trong câu truy vấn
            stmt.setInt(1, userId);

            // Thực thi câu truy vấn
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    // Tạo một đối tượng Appointment mới cho mỗi bản ghi
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getLong("doctor_id"));  // ✅ Dùng getLong
                    appointment.setWorkDate(rs.getDate("work_date"));
                    appointment.setSlotId(rs.getInt("slot_id"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
//                     appointment.setPreviousAppointmentId(rs.getInt("previousAppointmentId")); 

                    // Thêm cuộc hẹn vào danh sách
                    appointments.add(appointment);

                    System.out.println("Added appointment: ID=" + appointment.getAppointmentId()
                            + ", Patient=" + appointment.getPatientId()
                            + ", Date=" + appointment.getWorkDate());
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getAppointmentsByUserId: " + e.getMessage());
            e.printStackTrace();
            // Xử lý hoặc ghi log lỗi nếu cần
            throw new SQLException("Lỗi khi lấy danh sách cuộc hẹn cho userId: " + userId, e);
        }

        System.out.println("Returning " + appointments.size() + " appointments");
        return appointments;
    }

    public static boolean isSlotAvailable(int doctorId, LocalDate workDate, int slotId) {
        try {
            //========================================================
            // ✅ KIỂM TRA THỜI GIAN REAL-TIME
            java.time.LocalDate currentDate = java.time.LocalDate.now();
            java.time.LocalTime currentTime = java.time.LocalTime.now();
            
            // Nếu là ngày trong quá khứ
            if (workDate.isBefore(currentDate)) {
                System.out.println("❌ Slot " + slotId + " không khả dụng: Ngày trong quá khứ (" + workDate + " < " + currentDate + ")");
                return false;
            }
            
            // Nếu là ngày hôm nay, kiểm tra thời gian
            if (workDate.equals(currentDate)) {
                // Lấy thông tin thời gian của slot
                TimeSlotDAO timeSlotDAO = new TimeSlotDAO();
                TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(slotId);
                
                if (timeSlot != null && timeSlot.getStartTime().isBefore(currentTime)) {
                    System.out.println("❌ Slot " + slotId + " không khả dụng: Đã qua thời gian (" + timeSlot.getStartTime() + " < " + currentTime + ")");
                    return false;
                }
            }
            
            // Kiểm tra slot đã được đặt chưa
            Connection conn = DBContext.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment WHERE doctor_id = ? AND work_date = ? AND slot_id = ? AND status = 'BOOKED' AND patient_id IS NOT NULL";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setInt(3, slotId);
            ResultSet rs = ps.executeQuery();
            boolean available = false;
            if (rs.next()) {
                available = rs.getInt(1) == 0;
            }
            conn.close();
            
            if (!available) {
                System.out.println("❌ Slot " + slotId + " không khả dụng: Đã được đặt");
            } else {
                System.out.println("✅ Slot " + slotId + " khả dụng");
            }
            
            return available;
        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra slot availability: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ HÀM MỚI: Kiểm tra slot có hết hạn không (đã qua thời gian)
     */
    public static boolean isSlotExpired(int slotId, LocalDate workDate) {
        try {
            java.time.LocalDate currentDate = java.time.LocalDate.now();
            java.time.LocalTime currentTime = java.time.LocalTime.now();
            
            // Nếu là ngày trong quá khứ
            if (workDate.isBefore(currentDate)) {
                return true;
            }
            
            // Nếu là ngày hôm nay, kiểm tra thời gian
            if (workDate.equals(currentDate)) {
                TimeSlotDAO timeSlotDAO = new TimeSlotDAO();
                TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(slotId);
                
                if (timeSlot != null && timeSlot.getStartTime().isBefore(currentTime)) {
                    return true;
                }
            }
            
            return false;
        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra slot expired: " + e.getMessage());
            return false;
        }
    }

    public static List<Integer> getBookedSlots(int doctorId, LocalDate workDate) {
            List<Integer> bookedSlots = new ArrayList<>();
        String sql = "SELECT slot_id FROM Appointment WHERE doctor_id = ? AND work_date = ? AND status != 'CANCELLED'";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            
            try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                bookedSlots.add(rs.getInt("slot_id"));
            }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedSlots;
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
            ps.setString(5, STATUS_WAITING_PAYMENT);
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

    /**
     * Tạo reservation cho người thân với relative_id và booked_by_user_id
     */
    public static SlotReservation createReservationForRelative(int doctorId, LocalDate workDate, int slotId, int patientId, String reason, int relativeId, int bookedByUserId) {
        try {
            if (!isSlotAvailable(doctorId, workDate, slotId)) {
                return null;
            }

            Connection conn = DBContext.getConnection();
            String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, relative_id, booked_by_user_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
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
            ps.setString(5, STATUS_WAITING_PAYMENT);
            ps.setString(6, reservationReason);
            ps.setInt(7, relativeId);
            ps.setInt(8, bookedByUserId);

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
                    
                    System.out.println("✅ TẠO RESERVATION CHO NGƯỜI THÂN: Appointment " + appointmentId 
                        + " | RelativeId " + relativeId + " | BookedBy " + bookedByUserId);
                }
            }
            conn.close();
            return reservation;
        } catch (Exception e) {
            System.err.println("❌ LỖI TẠO RESERVATION CHO NGƯỜI THÂN: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Tạo appointment cho người thân
     * @return appointment_id
     */
    public static int createAppointmentForRelative(int doctorId, String workDate, int slotId, String serviceId, String reason, int relativeId, int bookedByUserId) {
        int generatedId = 0;
        try {
            Appointment appointment = new Appointment();
            appointment.setDoctorId(doctorId);
            appointment.setWorkDate(LocalDate.parse(workDate));
            appointment.setSlotId(slotId);
            appointment.setStatus(STATUS_BOOKED);
            appointment.setReason(reason);
            appointment.setRelativeId(relativeId);
            appointment.setBookedByUserId(bookedByUserId);
            // Không set patientId (đặt cho người thân)

            String sql = "INSERT INTO Appointment (doctor_id, work_date, slot_id, status, reason, relative_id, booked_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
            Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setInt(3, slotId);
            ps.setString(4, STATUS_BOOKED);
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
            ps.setString(6, STATUS_BOOKED);

            int result = ps.executeUpdate();
            conn.close();

            System.out.println("✅ TẠO LỊCH HẸN THÀNH CÔNG: Patient " + patientId
                    + " | Doctor " + doctorId + " | Slot " + slotId + " | Date " + workDate);
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

    /**
     * Insert appointment cho người thân với relative_id
     */
    public static boolean insertAppointmentBySlotIdForRelative(int patientId, int doctorId, int slotId, LocalDate workDate, LocalTime startTime, String reason, int relativeId, int bookedByUserId) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                INSERT INTO Appointment (patient_id, doctor_id, slot_id, work_date, reason, status, relative_id, booked_by_user_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setInt(3, slotId);
            ps.setDate(4, java.sql.Date.valueOf(workDate));
            ps.setString(5, reason);
            ps.setString(6, STATUS_BOOKED);
            ps.setInt(7, relativeId);
            ps.setInt(8, bookedByUserId);

            int result = ps.executeUpdate();
            conn.close();

            System.out.println("✅ TẠO LỊCH HẸN CHO NGƯỜI THÂN THÀNH CÔNG: Patient " + patientId
                    + " | Doctor " + doctorId + " | Slot " + slotId + " | Date " + workDate 
                    + " | RelativeId " + relativeId + " | BookedBy " + bookedByUserId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ LỖI TẠO LỊCH HẸN CHO NGƯỜI THÂN: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean completeReservation(int appointmentId) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, STATUS_BOOKED); // ĐÃ ĐẶT → BOOKED
            ps.setInt(2, appointmentId);

            int result = ps.executeUpdate();
            conn.close();

            System.out.println("✅ HOÀN THÀNH RESERVATION: Appointment " + appointmentId + " → " + STATUS_BOOKED);
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ LỖI HOÀN THÀNH RESERVATION: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean cancelReservation(int appointmentId) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = "UPDATE Appointment SET status = ?, cancelled_at = GETDATE() WHERE appointment_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, STATUS_CANCELLED);
            ps.setInt(2, appointmentId);

            int result = ps.executeUpdate();
            conn.close();

            System.out.println("✅ CANCELLED RESERVATION: Appointment " + appointmentId + " → " + STATUS_CANCELLED);
            return result > 0;
        } catch (Exception e) {
            System.err.println("❌ LỖI HỦY RESERVATION: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Dọn dẹp các appointment có status = WAITING_PAYMENT và đã quá hạn
     * Sử dụng work_date và slot_id để xác định các appointment đã quá hạn
     */
    public static int cleanupExpiredReservations() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int deletedCount = 0;

        try {
            conn = DBContext.getConnection();
            
            // Lấy thời gian hiện tại
            LocalDateTime now = LocalDateTime.now();
            LocalDate today = now.toLocalDate();

            // Xóa các appointment quá hạn:
            // 1. Các appointment của những ngày trước
            // 2. Các appointment cùng ngày nhưng đã qua giờ bắt đầu
            String sql = """
                DELETE FROM a
                FROM Appointment a
                LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                WHERE a.status = ? 
                AND (
                    a.work_date < ? 
                    OR (
                        a.work_date = ? 
                        AND CAST(ts.start_time AS datetime) < CAST(GETDATE() AS datetime)
                    )
                )
            """;

            ps = conn.prepareStatement(sql);
            ps.setString(1, STATUS_WAITING_PAYMENT);
            ps.setDate(2, java.sql.Date.valueOf(today));
            ps.setDate(3, java.sql.Date.valueOf(today));

            deletedCount = ps.executeUpdate();

            // Log số lượng appointment đã xóa
            if (deletedCount > 0) {
                System.out.println("Đã xóa " + deletedCount + " appointment quá hạn.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        return deletedCount;
    }

    public static SlotReservation getActiveReservationByPatient(int patientId) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT a.*, t.start_time, t.end_time 
                FROM Appointment a
                LEFT JOIN TimeSlots t ON a.slot_id = t.slot_id
                WHERE a.patient_id = ? 
                AND a.status = ?
                AND a.reason LIKE 'RESERVATION|%'
                AND DATEDIFF(MINUTE, a.created_at, GETDATE()) <= 5
                ORDER BY a.created_at DESC
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            ps.setString(2, STATUS_WAITING_PAYMENT);

            ResultSet rs = ps.executeQuery();
            SlotReservation reservation = null;

            if (rs.next()) {
                int doctorId = rs.getInt("doctor_id");
                LocalDate workDate = rs.getDate("work_date").toLocalDate();
                int slotId = rs.getInt("slot_id");
                int appointmentId = rs.getInt("appointment_id");

                reservation = new SlotReservation(doctorId, workDate, slotId, patientId);
                reservation.setAppointmentId(appointmentId);
                reservation.setReservedAt(rs.getTimestamp("created_at"));

                // Parse expiration time from reason field
                String reason = rs.getString("reason");
                if (reason != null && reason.startsWith("RESERVATION|")) {
                    String[] parts = reason.split("\\|");
                    if (parts.length > 1) {
                        try {
                            reservation.setExpiresAt(Timestamp.valueOf(parts[1]));
                        } catch (Exception e) {
                            // Default to 5 minutes from created_at
                            reservation.setExpiresAt(Timestamp.valueOf(
                                rs.getTimestamp("created_at").toLocalDateTime().plusMinutes(5)
                            ));
                        }
                    }
                }
            }

            conn.close();
            return reservation;
        } catch (Exception e) {
            System.err.println("❌ LỖI GET ACTIVE RESERVATION: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static boolean confirmReservation(int appointmentId, String payosOrderId) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                UPDATE Appointment 
                SET status = ?, 
                    payos_order_id = ?,
                    confirmed_at = GETDATE()
                WHERE appointment_id = ? 
                AND status = ?
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, STATUS_BOOKED);
            ps.setString(2, payosOrderId);
            ps.setInt(3, appointmentId);
            ps.setString(4, STATUS_WAITING_PAYMENT);

            int result = ps.executeUpdate();
            conn.close();

            if (result > 0) {
                System.out.println("✅ CONFIRMED RESERVATION: Appointment " + appointmentId + " with PayOS order: " + payosOrderId);
                return true;
            } else {
                System.err.println("⚠️ No appointment found to confirm with ID: " + appointmentId);
                return false;
            }
        } catch (Exception e) {
            System.err.println("❌ LỖI CONFIRM RESERVATION: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static List<SlotReservation> getReservationsByStatus(String status) {
        List<SlotReservation> reservations = new ArrayList<>();
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT a.*, t.start_time, t.end_time 
                FROM Appointment a
                LEFT JOIN TimeSlots t ON a.slot_id = t.slot_id
                WHERE a.status = ?
                AND a.reason LIKE 'RESERVATION|%'
                ORDER BY a.created_at DESC
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int doctorId = rs.getInt("doctor_id");
                LocalDate workDate = rs.getDate("work_date").toLocalDate();
                int slotId = rs.getInt("slot_id");
                int patientId = rs.getInt("patient_id");
                int appointmentId = rs.getInt("appointment_id");

                SlotReservation reservation = new SlotReservation(doctorId, workDate, slotId, patientId);
                reservation.setAppointmentId(appointmentId);
                reservation.setReservedAt(rs.getTimestamp("created_at"));

                // Parse expiration time from reason field
                String reason = rs.getString("reason");
                if (reason != null && reason.startsWith("RESERVATION|")) {
                    String[] parts = reason.split("\\|");
                    if (parts.length > 1) {
                        try {
                            reservation.setExpiresAt(Timestamp.valueOf(parts[1]));
                        } catch (Exception e) {
                            // Default to 5 minutes from created_at
                            reservation.setExpiresAt(Timestamp.valueOf(
                                rs.getTimestamp("created_at").toLocalDateTime().plusMinutes(5)
                            ));
                        }
                    }
                }

                reservations.add(reservation);
            }

            conn.close();
            System.out.println("✅ Found " + reservations.size() + " reservations with status: " + status);
        } catch (Exception e) {
            System.err.println("❌ LỖI GET RESERVATIONS BY STATUS: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
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
                ap.setStartTime(rs.getTime("start_time").toLocalTime());
                ap.setEndTime(rs.getTime("end_time").toLocalTime());
                list.add(ap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy appointments của doctor theo ngày cụ thể
     */
    public static List<Appointment> getAppointmentsByDoctorAndDate(long doctorId, String dateStr) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.*, 
                   p.full_name as patient_name, 
                   p.phone as patient_phone,
                   d.full_name as doctor_name, 
                   d.specialty as doctor_specialty
            FROM Appointment a 
            LEFT JOIN Patients p ON a.patient_id = p.patient_id
            LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
            WHERE a.doctor_id = ? AND a.work_date = ?
            ORDER BY a.appointment_id ASC
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            ps.setString(2, dateStr);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getLong("doctor_id"));  // ✅ Không cần cast
                    appointment.setSlotId(rs.getInt("slot_id"));
                    appointment.setWorkDate(rs.getDate("work_date"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    
                    // Set additional details
                    appointment.setPatientName(rs.getString("patient_name"));
                    appointment.setPatientPhone(rs.getString("patient_phone"));
                    appointment.setDoctorName(rs.getString("doctor_name"));
                    appointment.setDoctorSpecialty(rs.getString("doctor_specialty"));
                    
                    
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting appointments by doctor and date: " + e.getMessage());
            throw e;
        }
        
        return appointments;
    }
    
    /**
     * Lấy appointments gần đây của doctor (trong X ngày)
     */
    public static List<Appointment> getRecentAppointmentsByDoctor(long doctorId, int days) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.*, 
                   p.full_name as patient_name, 
                   p.phone as patient_phone,
                   d.full_name as doctor_name, 
                   d.specialty as doctor_specialty
            FROM Appointment a 
            LEFT JOIN Patients p ON a.patient_id = p.patient_id
            LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
            WHERE a.doctor_id = ? 
            AND a.work_date >= DATEADD(day, -?, GETDATE())
            AND a.work_date <= GETDATE()
            ORDER BY a.work_date DESC, a.appointment_id DESC
            OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            ps.setInt(2, days);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getLong("doctor_id"));  // ✅ Đã đúng
                    appointment.setSlotId(rs.getInt("slot_id"));
                    appointment.setWorkDate(rs.getDate("work_date"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    
                    // Set additional details
                    appointment.setPatientName(rs.getString("patient_name"));
                    appointment.setPatientPhone(rs.getString("patient_phone"));
                    appointment.setDoctorName(rs.getString("doctor_name"));
                    appointment.setDoctorSpecialty(rs.getString("doctor_specialty"));
                    
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent appointments by doctor: " + e.getMessage());
            throw e;
        }
        
        return appointments;
    }
    
    /**
     * Đếm số appointments trong tháng của doctor
     */
    public static int getMonthlyAppointmentCount(long doctorId) throws SQLException {
        String sql = """
            SELECT COUNT(*) as count
            FROM Appointment 
            WHERE doctor_id = ? 
            AND MONTH(work_date) = MONTH(GETDATE())
            AND YEAR(work_date) = YEAR(GETDATE())
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting monthly appointment count: " + e.getMessage());
            throw e;
        }
        
        return 0;
    }
    
    /**
     * Đếm số bệnh nhân đang chờ hôm nay (sử dụng 4 status mới)
     */
    public static int getWaitingPatientsCount(long doctorId, String dateStr) throws SQLException {
        String sql = """
            SELECT COUNT(*) as count
            FROM Appointment 
            WHERE doctor_id = ? 
            AND work_date = ?
            AND status = ?
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            ps.setString(2, dateStr);
            ps.setString(3, STATUS_BOOKED); // Đếm số appointment đã đặt
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting waiting patients count: " + e.getMessage());
            throw e;
        }
        
        return 0;
    }

    /**
     * Chuyển đổi status từ tiếng Anh sang tiếng Việt (dùng cho render giao diện)
     * @param status Status tiếng Anh
     * @return Status tiếng Việt để hiển thị
     */
    public static String getStatusDisplayText(String status) {
        if (status == null) return "Không xác định";
        
        switch (status) {
            case STATUS_BOOKED:
                return "Đã đặt lịch";
            case STATUS_COMPLETED:
                return "Hoàn thành";
            case STATUS_CANCELLED:
                return "Đã hủy";
            case STATUS_WAITING_PAYMENT:
                return "Chờ thanh toán";
            default:
                return status; // Trả về status gốc nếu không map được
        }
    }

    /**
     * Lấy CSS class cho status (dùng cho styling giao diện)
     * @param status Status tiếng Anh
     * @return CSS class name
     */
    public static String getStatusCssClass(String status) {
        if (status == null) return "badge-secondary";
        
        switch (status) {
            case STATUS_BOOKED:
                return "badge-success";
            case STATUS_COMPLETED:
                return "badge-primary";
            case STATUS_CANCELLED:
                return "badge-danger";
            case STATUS_WAITING_PAYMENT:
                return "badge-warning";
            default:
                return "badge-secondary";
        }
    }

    /**
     * Lấy danh sách các status hợp lệ (dùng cho dropdown)
     */
    public static String[] getAllValidStatuses() {
        return new String[]{
            STATUS_BOOKED,
            STATUS_COMPLETED, 
            STATUS_CANCELLED,
            STATUS_WAITING_PAYMENT
        };
    }

    /**
     * Lấy danh sách status display text (dùng cho dropdown)
     */
    public static String[] getAllStatusDisplayTexts() {
        return new String[]{
            "Đã đặt lịch",
            "Hoàn thành",
            "Đã hủy", 
            "Chờ thanh toán"
        };
    }

    /**
     * Kiểm tra status có hợp lệ không
     */
    public static boolean isValidStatus(String status) {
        if (status == null) return false;
        return STATUS_BOOKED.equals(status) || 
               STATUS_COMPLETED.equals(status) || 
               STATUS_CANCELLED.equals(status) || 
               STATUS_WAITING_PAYMENT.equals(status);
    }
    
    // đặt lịch cho người thân
    public static List<Integer> getBookedSlotsForRelative(int doctorId, LocalDate workDate) {
        List<Integer> bookedSlots = new ArrayList<>();
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT DISTINCT a.slot_id 
                FROM Appointment a
                WHERE a.doctor_id = ? 
                AND a.work_date = ? 
                AND a.status IN (?, ?, ?)
                AND a.reason NOT LIKE 'RESERVATION|%'
            """;
            
            System.out.println("🔍 [Relative Booking] Checking booked slots for doctor " + doctorId + " on " + workDate);
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ps.setString(3, STATUS_BOOKED);
            ps.setString(4, STATUS_WAITING_PAYMENT);
            ps.setString(5, STATUS_COMPLETED);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int slotId = rs.getInt("slot_id");
                bookedSlots.add(slotId);
                System.out.println("📅 [Relative Booking] Found booked slot: " + slotId);
            }
            
            System.out.println("✅ [Relative Booking] Total booked slots: " + bookedSlots.size());
            conn.close();
        } catch (Exception e) {
            System.err.println("❌ [Relative Booking] Error getting booked slots: " + e.getMessage());
            e.printStackTrace();
        }
        return bookedSlots;
    }

    // Đảm bảo có hàm close để tránh lỗi linter khi gọi DBContext.close(rs, ps, conn). Nếu đã có hàm này ở DBContext thì import static và dùng lại.
    public static void close(java.sql.ResultSet rs, java.sql.PreparedStatement ps, java.sql.Connection conn) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    /**
     * Xóa các appointment có trạng thái WAITING_PAYMENT
     */
    public static boolean deleteWaitingPaymentAppointment(int appointmentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DBContext.getConnection();
            String sql = "DELETE FROM Appointment WHERE appointment_id = ? AND status = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ps.setString(2, STATUS_WAITING_PAYMENT);

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;

            if (success) {
                // Xóa bill tương ứng nếu có
                sql = "DELETE FROM Bills WHERE appointment_id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, appointmentId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(null, ps, conn);
        }
        return success;
    }

    /**
     * Xóa các appointment có trạng thái CANCELLED
     * Kiểm tra và xóa an toàn, đảm bảo không vi phạm ràng buộc foreign key
     */
    public static boolean deleteCancelledAppointment(int appointmentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBContext.getConnection();
            
            // Kiểm tra xem appointment có được tham chiếu bởi appointment khác không
            String checkSql = "SELECT COUNT(*) as ref_count FROM Appointment WHERE previous_appointment_id = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setInt(1, appointmentId);
            rs = ps.executeQuery();
            
            if (rs.next() && rs.getInt("ref_count") == 0) {
                // Nếu không có tham chiếu, tiến hành xóa
                String deleteSql = "DELETE FROM Appointment WHERE appointment_id = ? AND status = ?";
                ps = conn.prepareStatement(deleteSql);
                ps.setInt(1, appointmentId);
                ps.setString(2, STATUS_CANCELLED);

                int rowsAffected = ps.executeUpdate();
                success = rowsAffected > 0;

                if (success) {
                    // Xóa bill tương ứng nếu có
                    String deleteBillSql = "DELETE FROM Bills WHERE appointment_id = ?";
                    ps = conn.prepareStatement(deleteBillSql);
                    ps.setInt(1, appointmentId);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        return success;
    }

    /**
     * Xóa tất cả các appointment đã hủy (CANCELLED)
     * Trả về số lượng appointment đã xóa
     */
    public static int deleteAllCancelledAppointments() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int deletedCount = 0;

        try {
            conn = DBContext.getConnection();
            
            // Lấy danh sách các appointment đã hủy không được tham chiếu
            String sql = """
                SELECT appointment_id 
                FROM Appointment a
                WHERE status = ? 
                AND NOT EXISTS (
                    SELECT 1 
                    FROM Appointment b 
                    WHERE b.previous_appointment_id = a.appointment_id
                )
            """;
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, STATUS_CANCELLED);
            rs = ps.executeQuery();

            // Xóa từng appointment
            while (rs.next()) {
                int appointmentId = rs.getInt("appointment_id");
                if (deleteCancelledAppointment(appointmentId)) {
                    deletedCount++;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        return deletedCount;
    }

    /**
     * Lấy danh sách lịch hẹn của người thân
     * @param bookedByUserId ID của người đặt lịch
     * @return Danh sách các cuộc hẹn của người thân
     */
    public static List<Appointment> getRelativeAppointments(int bookedByUserId) {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            String sql = """
                SELECT a.*, 
                       p.full_name as patient_name,
                       p.phone as patient_phone,
                       d.full_name as doctor_name,
                       d.specialty as doctor_specialty,
                       ts.start_time,
                       ts.end_time
                FROM Appointment a
                JOIN Patients p ON a.patient_id = p.patient_id
                JOIN Doctors d ON a.doctor_id = d.doctor_id
                JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                WHERE a.booked_by_user_id = ? 
                AND a.status != 'CANCELLED'
                ORDER BY a.work_date DESC, ts.start_time ASC
            """;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookedByUserId);
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointmentWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return appointments;
    }

    /**
     * Kiểm tra xem một người dùng có phải là người đặt lịch cho một cuộc hẹn không
     * @param userId ID của người dùng
     * @param appointmentId ID của cuộc hẹn
     * @return true nếu người dùng là người đặt lịch
     */
    public static boolean isAppointmentBooker(int userId, int appointmentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean isBooker = false;

        try {
            conn = DBContext.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment WHERE appointment_id = ? AND booked_by_user_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ps.setInt(2, userId);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                isBooker = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("Error checking appointment booker: " + e.getMessage());
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        
        return isBooker;
    }

    /**
     * Lấy thông tin người đặt lịch của một cuộc hẹn
     * @param appointmentId ID của cuộc hẹn
     * @return User ID của người đặt lịch, hoặc -1 nếu không tìm thấy
     */
    public static int getAppointmentBooker(int appointmentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int bookerId = -1;

        try {
            conn = DBContext.getConnection();
            String sql = "SELECT booked_by_user_id FROM Appointment WHERE appointment_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                bookerId = rs.getInt("booked_by_user_id");
            }
        } catch (Exception e) {
            System.err.println("Error getting appointment booker: " + e.getMessage());
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        
        return bookerId;
    }
    
    
    
// lấy giá dịch vụ từ bảng Services:
    public long getServicePrice(int serviceId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        long price = 0;

        try {
            conn = DBContext.getConnection();
            String sql = "SELECT price FROM Services WHERE service_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getLong("price");
            }
        } catch (Exception e) {
            System.err.println("Error getting service price: " + e.getMessage());
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        
        return price;
    }
    


    // Phục vụ cho gửi calender n8n
    /**
     * Lấy email của bác sĩ và bệnh nhân từ appointment_id
     * @param appointmentId ID của cuộc hẹn
     * @return Mảng 2 phần tử [email bệnh nhân, email bác sĩ]
     */
    public static String[] getEmailsFromAppointment(int appointmentId) {
        String[] emails = new String[2];
        String sql = """
            SELECT u1.email as patient_email, u2.email as doctor_email
            FROM Appointment a
            JOIN Patients p ON a.patient_id = p.patient_id
            JOIN users u1 ON p.user_id = u1.user_id
            JOIN Doctors d ON a.doctor_id = d.doctor_id
            JOIN users u2 ON d.user_id = u2.user_id
            WHERE a.appointment_id = ?
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emails[0] = rs.getString("patient_email");
                    emails[1] = rs.getString("doctor_email");
                }
            }
        } catch (Exception e) {
            System.err.println("Error getting emails from appointment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return emails;
    }
    
    //=======================================================================================================================
        // code của TOÀN
    
     public static List<Appointment> getTodayWaitingAppointmentsByDoctorId(long doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.doctor_id = ? 
            AND CAST(a.work_date AS DATE) = CAST(GETDATE() AS DATE)
            AND a.status = N'booked'
            ORDER BY t.start_time ASC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Handle null previous_appointment_id
                int prevAppId = rs.getInt("previous_appointment_id");
                if (!rs.wasNull()) {
                    appointment.setPreviousAppointmentId(prevAppId);
                }
                
                // Thông tin bệnh nhân
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));
                appointment.setStartTime(rs.getTime("start_time").toLocalTime());
                appointment.setEndTime(rs.getTime("end_time").toLocalTime());
                
                appointments.add(appointment);
            }
        }
        
        return appointments;
    }
     
     public static List<Appointment> getAllAppointmentsByDoctorId(long doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   a.booked_by_user_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.doctor_id = ?
            ORDER BY a.work_date DESC, t.start_time ASC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Handle null previous_appointment_id
                int prevAppId = rs.getInt("previous_appointment_id");
                if (!rs.wasNull()) {
                    appointment.setPreviousAppointmentId(prevAppId);
                }
                
                // Handle null booked_by_user_id
                int bookedByUserId = rs.getInt("booked_by_user_id");
                if (!rs.wasNull()) {
                    appointment.setBookedByUserId(bookedByUserId);
                } else {
                    appointment.setBookedByUserId(null);
                }
                
                // Thông tin bệnh nhân
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));
                appointment.setStartTime(rs.getTime("start_time").toLocalTime());
                appointment.setEndTime(rs.getTime("end_time").toLocalTime());
                
                appointments.add(appointment);
            }
        }
        
        return appointments;
    }

/**
     * Lấy thông tin chi tiết của một cuộc hẹn (bao gồm thông tin bệnh nhân)
     */
    public static Appointment getAppointmentWithPatientInfo(int appointmentId) throws SQLException {
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.appointment_id = ?
        """;

        System.out.println("DEBUG - getAppointmentWithPatientInfo for appointmentId: " + appointmentId);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getLong("doctor_id"));  // ✅ Sửa thành getLong
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));

                // Handle null previous_appointment_id
                int prevAppId = rs.getInt("previous_appointment_id");
                if (!rs.wasNull()) {
                    appointment.setPreviousAppointmentId(prevAppId);
                }

                // Thông tin bệnh nhân
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));

                // ✅ FIX: Xử lý time slot đúng cách - convert từ Time sang LocalTime
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
                        System.err.println("Warning: Could not set start time for appointment " + appointmentId + ": " + e2.getMessage());
                        appointment.setStartTime(java.time.LocalTime.of(9, 0)); // Default 9:00 AM
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
                        System.err.println("Warning: Could not set end time for appointment " + appointmentId + ": " + e2.getMessage());
                        appointment.setEndTime(java.time.LocalTime.of(10, 0)); // Default 10:00 AM
                    }
                }

                System.out.println("DEBUG - Found appointment: patient_id=" + appointment.getPatientId()
                        + ", patient_name=" + appointment.getPatientName());

                return appointment;
            } else {
                System.out.println("DEBUG - No appointment found with ID: " + appointmentId);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getAppointmentWithPatientInfo: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.err.println("Error in getAppointmentWithPatientInfo: " + e.getMessage());
            throw new SQLException("Error getting appointment info", e);
        }

        return null;
    }

    /**
     * Lấy ID của appointment vừa được thêm vào
     * @return ID của appointment vừa thêm, hoặc -1 nếu thêm thất bại
     */
    public static int getLastInsertedAppointmentId() {
        int lastId = -1;
        try {
            Connection conn = DBContext.getConnection();
            String sql = "SELECT SCOPE_IDENTITY()"; // SQL Server function to get last inserted ID
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                lastId = rs.getInt(1);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lastId;
    }

    // 🆕 METHOD: Lấy danh sách appointments theo bác sĩ và ngày
    public static List<Appointment> getAppointmentsByDoctorAndDate(int doctorId, String workDate) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = """
                SELECT a.*, 
                       p.full_name as patient_name, 
                       p.phone as patient_phone,
                       p.email as patient_email,
                       d.full_name as doctor_name, 
                       d.specialty as doctor_specialty,
                       d.email as doctor_email,
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
                WHERE a.doctor_id = ? AND a.work_date = ? AND a.status = 'BOOKED'
                ORDER BY ts.start_time ASC
            """;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setString(2, workDate);
            rs = ps.executeQuery();

            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointmentWithDetails(rs);
                appointment.setPatientPhone(rs.getString("patient_phone"));
                appointment.setPatientEmail(rs.getString("patient_email"));
                appointment.setDoctorEmail(rs.getString("doctor_email"));
                
                String serviceName = rs.getString("service_name");
                if (serviceName != null) {
                    appointment.setServiceName(serviceName);
                } else {
                    appointment.setServiceName("Chưa có dịch vụ");
                }

                appointments.add(appointment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        return appointments;
    }

    // 🆕 METHOD: Cập nhật appointment với thông tin mới (static version)
    public static boolean updateAppointmentStatic(Appointment appointment) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = """
                UPDATE Appointment 
                SET patient_id = ?, doctor_id = ?, slot_id = ?, work_date = ?, 
                    reason = ?, status = ?, note = ?, updated_at = GETDATE()
                WHERE appointment_id = ?
            """;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointment.getPatientId());
            ps.setLong(2, appointment.getDoctorId());
            ps.setInt(3, appointment.getSlotId());
            ps.setString(4, appointment.getWorkDate().toString());
            ps.setString(5, appointment.getReason());
            ps.setString(6, appointment.getStatus());
            ps.setString(7, appointment.getNote());
            ps.setInt(8, appointment.getAppointmentId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    /**
     * Lấy tất cả lịch hẹn với đầy đủ thông tin (bệnh nhân, bác sĩ, dịch vụ, giờ...)
     */
    public List<Appointment> getAllAppointmentsWithDetails() {
        List<Appointment> appointments = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            String sql = """
                SELECT a.*, 
                       p.full_name as patient_name, p.phone as patient_phone,
                       u1.email as patient_email,
                       d.full_name as doctor_name, d.specialty as doctor_specialty,
                       u2.email as doctor_email,
                       ts.start_time, ts.end_time,
                       s.service_name
                FROM Appointment a
                LEFT JOIN Patients p ON a.patient_id = p.patient_id
                LEFT JOIN users u1 ON p.user_id = u1.user_id
                LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
                LEFT JOIN users u2 ON d.user_id = u2.user_id
                LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
                LEFT JOIN Bills b ON b.patient_id = a.patient_id 
                    AND b.appointment_date = a.work_date 
                    AND b.doctor_id = a.doctor_id
                LEFT JOIN Services s ON b.service_id = s.service_id
                ORDER BY a.work_date DESC, ts.start_time ASC
            """;
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointmentWithDetails(rs);
                // Set thêm các thông tin phụ
                appointment.setPatientPhone(rs.getString("patient_phone"));
                appointment.setServiceName(rs.getString("service_name") != null ? rs.getString("service_name") : "Chưa có dịch vụ");
                appointment.setDoctorSpecialty(rs.getString("doctor_specialty"));
                appointment.setPatientEmail(rs.getString("patient_email"));
                appointment.setDoctorEmail(rs.getString("doctor_email"));
                appointments.add(appointment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return appointments;
    }

    /**
     * Đổi lịch hẹn: cập nhật service_id, work_date, slot_id, reason cho appointmentId (KHÔNG đổi doctorId)
     */
    public static boolean rescheduleAppointment(int appointmentId, int serviceId, String newDate, int newSlotId, String reason) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            // Nếu có cột service_id trong bảng Appointment
            String sql = "UPDATE Appointment SET service_id = ?, work_date = ?, slot_id = ?, reason = ? WHERE appointment_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            ps.setString(2, newDate);
            ps.setInt(3, newSlotId);
            ps.setString(4, reason);
            ps.setInt(5, appointmentId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    /**
và     * Đổi lịch hẹn: chỉ cập nhật work_date và slot_id cho appointmentId
     */
    public static boolean updateAppointmentForReschedule(int appointmentId, String workDate, int slotId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            String sql = "UPDATE Appointment SET work_date = ?, slot_id = ? WHERE appointment_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, workDate);
            ps.setInt(2, slotId);
            ps.setInt(3, appointmentId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    /**
 * Lấy danh sách slot còn trống cho bác sĩ trong ngày, loại trừ slot của appointmentId (nếu có)
 */
public static List<TimeSlot> getAvailableSlots(int doctorId, String date, int appointmentId) {
    List<TimeSlot> availableSlots = new ArrayList<>();
    try {
        // Lấy tất cả slot
        List<TimeSlot> allSlots = TimeSlotDAO.getAllTimeSlots();
        // Lấy các slot đã được đặt (trừ appointmentId hiện tại)
        String sql = "SELECT slot_id FROM Appointment WHERE doctor_id = ? AND work_date = ? AND status != 'CANCELLED' AND appointment_id != ?";
        Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, doctorId);
        ps.setString(2, date);
        ps.setInt(3, appointmentId);
        ResultSet rs = ps.executeQuery();
        List<Integer> bookedSlotIds = new ArrayList<>();
        while (rs.next()) {
            bookedSlotIds.add(rs.getInt("slot_id"));
        }
        conn.close();
        // Lọc ra các slot chưa bị đặt
        for (TimeSlot slot : allSlots) {
            if (!bookedSlotIds.contains(slot.getSlotId())) {
                availableSlots.add(slot);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return availableSlots;
}

    /**
     * Đổi lịch hẹn: chỉ cập nhật work_date và slot_id cho appointmentId (không đổi bác sĩ, dịch vụ)
     */
    public static boolean rescheduleAppointmentDateTime(int appointmentId, String newDate, int newSlotId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            String sql = "UPDATE Appointment SET work_date = ?, slot_id = ? WHERE appointment_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newDate);
            ps.setInt(2, newSlotId);
            ps.setInt(3, appointmentId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

}
