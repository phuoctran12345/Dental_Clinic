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
import static utils.DBContext.getConnection;

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

    // Status constants cho reservation
    public static final String STATUS_RESERVED = "ĐANG GIỮ CHỖ";
    public static final String STATUS_WAITING_PAYMENT = "CHờ THANH TOÁN";
    public static final String STATUS_CONFIRMED = "ĐÃ ĐẶT";
    public static final String STATUS_EXPIRED = "HẾT HẠN";
    public static final String STATUS_CANCELLED = "ĐÃ HỦY";

    // Status constants cho quản lý hàng đợi bệnh nhân
    public static final String STATUS_WAITING = "Đang chờ";          // Bệnh nhân đang chờ được gọi
    public static final String STATUS_IN_TREATMENT = "Đang điều trị"; // Bệnh nhân đang được khám/điều trị
    public static final String STATUS_COMPLETED = "Hoàn thành";       // Đã hoàn thành khám/điều trị
    public static final String STATUS_CONFIRMED_ALT = "Đã xác nhận";  // Đã xác nhận lịch hẹn

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
                ps.setLong(2, appointment.getDoctorId());  // ✅ Dùng setLong
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
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
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

    /*-------------------------------------------------------------*/
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
     * Đếm số bệnh nhân đang chờ hôm nay
     */
    public static int getWaitingPatientsCount(long doctorId, String dateStr) throws SQLException {
        String sql = """
            SELECT COUNT(*) as count
            FROM Appointment 
            WHERE doctor_id = ? 
            AND work_date = ?
            AND (status = 'CONFIRMED' OR status = 'PENDING' OR status = 'Đang chờ')
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, doctorId);
            ps.setString(2, dateStr);
            
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
    

}
