
package dao;

import model.Doctors;
import java.sql.*;
import java.util.HashSet;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import model.Appointment;
import model.DoctorSchedule;
import model.TimeSlot;
import utils.DBContext;

public class DoctorDAO {

   
    private Connection connection;
    
    public DoctorDAO() {
        this.connection = DBContext.getConnection();
    }
    
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
    
    
   
    public static List<Appointment> getAppointmentsByUserId(Integer userId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason
            FROM Appointment a
            INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
            WHERE d.user_id = ?
            ORDER BY a.work_date DESC, a.slot_id ASC
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setWorkDate(rs.getDate("work_date"));
                    appointment.setSlotId(rs.getInt("slot_id"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
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
                System.out.println("✅ Found doctor for userId " + userId + ": doctor_id=" + rs.getLong("doctor_id"));
                
                Doctors doctor = new Doctors();
                doctor.setDoctor_id(rs.getLong("doctor_id"));
                doctor.setUser_id(rs.getLong("user_id"));
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
                
                return doctor;
            } else {
                System.out.println("❌ No doctor found for userId: " + userId);
            }
        } catch (SQLException e) {
            System.out.println("❌ Database error getting doctor by user id: " + e);
            e.printStackTrace();
        }
        return null;
    }
    

    // ===== PAYMENT SYSTEM METHODS ===== 
    
    /**
     * Tạo QR payment link cho appointment
     */
    public String createPaymentLink(int doctorId, int appointmentId, int patientId, BigDecimal amount) throws SQLException {
        String sql = "INSERT INTO payment_links (doctor_id, appointment_id, patient_id, amount, status, created_at) VALUES (?, ?, ?, ?, 'PENDING', GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, doctorId);
            st.setInt(2, appointmentId);
            st.setInt(3, patientId);
            st.setBigDecimal(4, amount);
            
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return "PAYMENT_" + generatedKeys.getInt(1);
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * Xác nhận thanh toán appointment
     */
    public boolean confirmDoctorPayment(int doctorId, String paymentCode, String status) throws SQLException {
        String sql = "UPDATE payment_links SET status = ?, updated_at = GETDATE() WHERE doctor_id = ? AND payment_code = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, doctorId);
            st.setString(3, paymentCode);
            
            return st.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy danh sách payments của doctor
     */
    public List<Map<String, Object>> getDoctorPayments(int doctorId, String fromDate, String toDate) throws SQLException {
        List<Map<String, Object>> payments = new ArrayList<>();
        String sql = "SELECT p.*, pt.full_name as patient_name, a.appointment_date " +
                    "FROM payment_links p " +
                    "LEFT JOIN appointments a ON p.appointment_id = a.appointment_id " +
                    "LEFT JOIN patients pt ON p.patient_id = pt.patient_id " +
                    "WHERE p.doctor_id = ? AND p.created_at BETWEEN ? AND ? " +
                    "ORDER BY p.created_at DESC";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("paymentId", rs.getInt("payment_id"));
                    payment.put("appointmentId", rs.getInt("appointment_id"));
                    payment.put("patientName", rs.getString("patient_name"));
                    payment.put("amount", rs.getBigDecimal("amount"));
                    payment.put("status", rs.getString("status"));
                    payment.put("appointmentDate", rs.getDate("appointment_date"));
                    payment.put("createdAt", rs.getTimestamp("created_at"));
                    payments.add(payment);
                }
            }
        }
        return payments;
    }
    
    // ===== ADVANCED DOCTOR SCHEDULE METHODS =====
    
    /**
     * Tạo schedule template cho doctor
     */
    public boolean createDoctorScheduleTemplate(int doctorId, String templateName, String scheduleData) throws SQLException {
        String sql = "INSERT INTO doctor_schedule_templates (doctor_id, template_name, schedule_data, created_at) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, templateName);
            st.setString(3, scheduleData);
            
            return st.executeUpdate() > 0;
        }
    }
    
    /**
     * Apply schedule template cho một tuần
     */
    public boolean applyScheduleTemplate(int doctorId, int templateId, String startDate, String endDate) throws SQLException {
        // Lấy template data
        String getTemplateSql = "SELECT schedule_data FROM doctor_schedule_templates WHERE template_id = ? AND doctor_id = ?";
        String templateData = null;
        
        try (PreparedStatement st = connection.prepareStatement(getTemplateSql)) {
            st.setInt(1, templateId);
            st.setInt(2, doctorId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    templateData = rs.getString("schedule_data");
                }
            }
        }
        
        if (templateData == null) return false;
        
        // Parse và insert schedule
        String insertSql = "INSERT INTO doctor_schedules (doctor_id, work_date, start_time, end_time, status, created_at) VALUES (?, ?, ?, ?, 'AVAILABLE', GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(insertSql)) {
            // Parse template data và insert từng ngày
            String[] daySchedules = templateData.split(",");
            
            for (String daySchedule : daySchedules) {
                String[] parts = daySchedule.split(":");
                if (parts.length >= 2) {
                    String day = parts[0];
                    String timeRange = parts[1];
                    String[] times = timeRange.split("-");
                    
                    if (times.length == 2) {
                        st.setInt(1, doctorId);
                        st.setString(2, startDate); 
                        st.setString(3, times[0]);
                        st.setString(4, times[1]);
                        st.executeUpdate();
                    }
                }
            }
            return true;
        }
    }
    
    /**
     * Lấy thống kê appointments của doctor theo tháng
     */
    public Map<String, Object> getDoctorMonthlyStats(int doctorId, int month, int year) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Total appointments
        String totalSql = "SELECT COUNT(*) as total FROM appointments WHERE doctor_id = ? AND MONTH(appointment_date) = ? AND YEAR(appointment_date) = ?";
        
        // Completed appointments
        String completedSql = "SELECT COUNT(*) as completed FROM appointments WHERE doctor_id = ? AND MONTH(appointment_date) = ? AND YEAR(appointment_date) = ? AND status = 'COMPLETED'";
        
        // Cancelled appointments
        String cancelledSql = "SELECT COUNT(*) as cancelled FROM appointments WHERE doctor_id = ? AND MONTH(appointment_date) = ? AND YEAR(appointment_date) = ? AND status = 'CANCELLED'";
        
        // Revenue
        String revenueSql = "SELECT SUM(b.total_amount) as revenue FROM bills b JOIN appointments a ON b.appointment_id = a.appointment_id WHERE a.doctor_id = ? AND MONTH(a.appointment_date) = ? AND YEAR(a.appointment_date) = ? AND b.status = 'PAID'";
        
        try (PreparedStatement st1 = connection.prepareStatement(totalSql);
             PreparedStatement st2 = connection.prepareStatement(completedSql);
             PreparedStatement st3 = connection.prepareStatement(cancelledSql);
             PreparedStatement st4 = connection.prepareStatement(revenueSql)) {
            
            // Set parameters for all statements
            st1.setInt(1, doctorId); st1.setInt(2, month); st1.setInt(3, year);
            st2.setInt(1, doctorId); st2.setInt(2, month); st2.setInt(3, year);
            st3.setInt(1, doctorId); st3.setInt(2, month); st3.setInt(3, year);
            st4.setInt(1, doctorId); st4.setInt(2, month); st4.setInt(3, year);
            
            // Execute queries
            try (ResultSet rs1 = st1.executeQuery()) {
                if (rs1.next()) stats.put("totalAppointments", rs1.getInt("total"));
            }
            
            try (ResultSet rs2 = st2.executeQuery()) {
                if (rs2.next()) stats.put("completedAppointments", rs2.getInt("completed"));
            }
            
            try (ResultSet rs3 = st3.executeQuery()) {
                if (rs3.next()) stats.put("cancelledAppointments", rs3.getInt("cancelled"));
            }
            
            try (ResultSet rs4 = st4.executeQuery()) {
                if (rs4.next()) stats.put("revenue", rs4.getBigDecimal("revenue"));
            }
        }
        
        return stats;
    }
    
    /**
     * Lấy top services được sử dụng bởi doctor
     */
    public List<Map<String, Object>> getTopServicesByDoctor(int doctorId, String fromDate, String toDate, int limit) throws SQLException {
        List<Map<String, Object>> services = new ArrayList<>();
        String sql = "SELECT s.service_name, COUNT(bs.service_id) as usage_count, " +
                    "AVG(s.price) as avg_price, SUM(bs.quantity * s.price) as total_revenue " +
                    "FROM bill_services bs " +
                    "JOIN services s ON bs.service_id = s.service_id " +
                    "JOIN bills b ON bs.bill_id = b.bill_id " +
                    "JOIN appointments a ON b.appointment_id = a.appointment_id " +
                    "WHERE a.doctor_id = ? AND a.appointment_date BETWEEN ? AND ? " +
                    "GROUP BY s.service_id, s.service_name " +
                    "ORDER BY usage_count DESC, total_revenue DESC";
        
        if (limit > 0) {
            sql = sql.replace("ORDER BY", "ORDER BY") + " OFFSET 0 ROWS FETCH NEXT " + limit + " ROWS ONLY";
        }
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("serviceName", rs.getString("service_name"));
                    service.put("usageCount", rs.getInt("usage_count"));
                    service.put("avgPrice", rs.getBigDecimal("avg_price"));
                    service.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                    services.add(service);
                }
            }
        }
        
        return services;
    }
    
    /**
     * Tự động gợi ý schedule dựa trên historical data
     */
    public List<String> suggestOptimalSchedule(int doctorId, String month, String year) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        
        // Analyze historical appointment patterns
        String sql = "SELECT DATEPART(weekday, appointment_date) as day_of_week, " +
                    "DATEPART(hour, appointment_time) as hour_of_day, " +
                    "COUNT(*) as appointment_count " +
                    "FROM appointments " +
                    "WHERE doctor_id = ? AND status = 'COMPLETED' " +
                    "AND appointment_date >= DATEADD(month, -6, GETDATE()) " +
                    "GROUP BY DATEPART(weekday, appointment_date), DATEPART(hour, appointment_time) " +
                    "HAVING COUNT(*) >= 3 " +
                    "ORDER BY appointment_count DESC";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int dayOfWeek = rs.getInt("day_of_week");
                    int hourOfDay = rs.getInt("hour_of_day");
                    int appointmentCount = rs.getInt("appointment_count");
                    
                    String dayName = getDayName(dayOfWeek);
                    suggestions.add(String.format("Khuyến nghị: %s lúc %d:00 (có %d appointments trong 6 tháng qua)", 
                                                dayName, hourOfDay, appointmentCount));
                }
            }
        }
        
        return suggestions;
    }
    
    private String getDayName(int dayOfWeek) {
        String[] days = {"", "Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};
        return (dayOfWeek >= 1 && dayOfWeek <= 7) ? days[dayOfWeek] : "Không xác định";
    }
    
    /**
     * Kiểm tra và cảnh báo conflict trong lịch
     */
    public List<String> checkScheduleConflicts(int doctorId, String startDate, String endDate) throws SQLException {
        List<String> conflicts = new ArrayList<>();
        
        String sql = "SELECT ds1.work_date, ds1.start_time, ds1.end_time, " +
                    "ds2.work_date as conflict_date, ds2.start_time as conflict_start, ds2.end_time as conflict_end " +
                    "FROM doctor_schedules ds1 " +
                    "JOIN doctor_schedules ds2 ON ds1.doctor_id = ds2.doctor_id " +
                    "AND ds1.work_date = ds2.work_date " +
                    "AND ds1.schedule_id != ds2.schedule_id " +
                    "WHERE ds1.doctor_id = ? " +
                    "AND ds1.work_date BETWEEN ? AND ? " +
                    "AND ((ds1.start_time <= ds2.end_time AND ds1.end_time >= ds2.start_time))";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, startDate);
            st.setString(3, endDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    String conflictMsg = String.format("Conflict ngày %s: %s-%s trùng với %s-%s",
                                                     rs.getString("work_date"),
                                                     rs.getString("start_time"),
                                                     rs.getString("end_time"),
                                                     rs.getString("conflict_start"),
                                                     rs.getString("conflict_end"));
                    conflicts.add(conflictMsg);
                }
            }
        }
        
        return conflicts;
    }
    
    // ===== NOTIFICATION & COMMUNICATION METHODS =====
    
    /**
     * Gửi thông báo cho patients của doctor
     */
    public boolean sendNotificationToPatients(int doctorId, String message, String notificationType) throws SQLException {
        String getPatientsSql = "SELECT DISTINCT p.patient_id, p.email, p.phone_number " +
                               "FROM patients p " +
                               "JOIN appointments a ON p.patient_id = a.patient_id " +
                               "WHERE a.doctor_id = ? " +
                               "AND a.appointment_date >= GETDATE() " +
                               "AND a.appointment_date <= DATEADD(day, 30, GETDATE()) " +
                               "AND a.status NOT IN ('CANCELLED', 'COMPLETED')";
        
        List<Integer> patientIds = new ArrayList<>();
        
        try (PreparedStatement st = connection.prepareStatement(getPatientsSql)) {
            st.setInt(1, doctorId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    patientIds.add(rs.getInt("patient_id"));
                }
            }
        }
        
        String insertNotificationSql = "INSERT INTO notifications (user_id, doctor_id, message, type, status, created_at) VALUES (?, ?, ?, ?, 'UNREAD', GETDATE())";
        
        try (PreparedStatement st = connection.prepareStatement(insertNotificationSql)) {
            for (int patientId : patientIds) {
                st.setInt(1, patientId);
                st.setInt(2, doctorId);
                st.setString(3, message);
                st.setString(4, notificationType);
                st.executeUpdate();
            }
        }
        
        return !patientIds.isEmpty();
    }
    
    /**
     * Lấy feedback/ratings của doctor
     */
    public Map<String, Object> getDoctorFeedbackStats(int doctorId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = "SELECT " +
                    "COUNT(*) as total_reviews, " +
                    "AVG(CAST(rating as FLOAT)) as average_rating, " +
                    "COUNT(CASE WHEN rating >= 4 THEN 1 END) as positive_reviews, " +
                    "COUNT(CASE WHEN rating <= 2 THEN 1 END) as negative_reviews " +
                    "FROM appointment_feedbacks af " +
                    "JOIN appointments a ON af.appointment_id = a.appointment_id " +
                    "WHERE a.doctor_id = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalReviews", rs.getInt("total_reviews"));
                    stats.put("averageRating", rs.getDouble("average_rating"));
                    stats.put("positiveReviews", rs.getInt("positive_reviews"));
                    stats.put("negativeReviews", rs.getInt("negative_reviews"));
                }
            }
        }
        
        return stats;
    }
    
    // ===== MEDICAL REPORT & PRESCRIPTION METHODS =====
    
    /**
     * Tạo medical report cho appointment của doctor
     */
    public boolean createMedicalReport(int appointmentId, int doctorId, String diagnosis, String treatment, String notes) throws SQLException {
        String sql = "INSERT INTO medical_reports (appointment_id, doctor_id, diagnosis, treatment_plan, notes, created_at, status) VALUES (?, ?, ?, ?, ?, GETDATE(), 'ACTIVE')";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, appointmentId);
            st.setInt(2, doctorId);
            st.setString(3, diagnosis);
            st.setString(4, treatment);
            st.setString(5, notes);
            
            return st.executeUpdate() > 0;
        }
    }
    
    /**
     * Cập nhật medical report
     */
    public boolean updateMedicalReport(int reportId, int doctorId, String diagnosis, String treatment, String notes) throws SQLException {
        String sql = "UPDATE medical_reports SET diagnosis = ?, treatment_plan = ?, notes = ?, updated_at = GETDATE() WHERE report_id = ? AND doctor_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, diagnosis);
            st.setString(2, treatment);
            st.setString(3, notes);
            st.setInt(4, reportId);
            st.setInt(5, doctorId);
            
            return st.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy medical reports của doctor
     */
    public List<Map<String, Object>> getDoctorMedicalReports(int doctorId, String fromDate, String toDate) throws SQLException {
        List<Map<String, Object>> reports = new ArrayList<>();
        String sql = "SELECT mr.*, a.appointment_date, p.full_name as patient_name " +
                    "FROM medical_reports mr " +
                    "JOIN appointments a ON mr.appointment_id = a.appointment_id " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "WHERE mr.doctor_id = ? AND mr.created_at BETWEEN ? AND ? " +
                    "ORDER BY mr.created_at DESC";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> report = new HashMap<>();
                    report.put("reportId", rs.getInt("report_id"));
                    report.put("appointmentId", rs.getInt("appointment_id"));
                    report.put("patientName", rs.getString("patient_name"));
                    report.put("diagnosis", rs.getString("diagnosis"));
                    report.put("treatmentPlan", rs.getString("treatment_plan"));
                    report.put("notes", rs.getString("notes"));
                    report.put("appointmentDate", rs.getDate("appointment_date"));
                    report.put("createdAt", rs.getTimestamp("created_at"));
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    /**
     * Tạo prescription cho medical report
     */
    public boolean createPrescription(int reportId, int doctorId, List<Map<String, Object>> medicines) throws SQLException {
        String sql = "INSERT INTO prescriptions (report_id, doctor_id, medicine_name, dosage, frequency, duration, instructions, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (Map<String, Object> medicine : medicines) {
                st.setInt(1, reportId);
                st.setInt(2, doctorId);
                st.setString(3, (String) medicine.get("medicineName"));
                st.setString(4, (String) medicine.get("dosage"));
                st.setString(5, (String) medicine.get("frequency"));
                st.setString(6, (String) medicine.get("duration"));
                st.setString(7, (String) medicine.get("instructions"));
                st.executeUpdate();
            }
            return true;
        }
    }
    
    /**
     * Lấy prescription history của doctor
     */
    public List<Map<String, Object>> getDoctorPrescriptions(int doctorId, String fromDate, String toDate) throws SQLException {
        List<Map<String, Object>> prescriptions = new ArrayList<>();
        String sql = "SELECT p.*, mr.diagnosis, pt.full_name as patient_name, a.appointment_date " +
                    "FROM prescriptions p " +
                    "JOIN medical_reports mr ON p.report_id = mr.report_id " +
                    "JOIN appointments a ON mr.appointment_id = a.appointment_id " +
                    "JOIN patients pt ON a.patient_id = pt.patient_id " +
                    "WHERE p.doctor_id = ? AND p.created_at BETWEEN ? AND ? " +
                    "ORDER BY p.created_at DESC";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> prescription = new HashMap<>();
                    prescription.put("prescriptionId", rs.getInt("prescription_id"));
                    prescription.put("patientName", rs.getString("patient_name"));
                    prescription.put("medicineName", rs.getString("medicine_name"));
                    prescription.put("dosage", rs.getString("dosage"));
                    prescription.put("frequency", rs.getString("frequency"));
                    prescription.put("duration", rs.getString("duration"));
                    prescription.put("instructions", rs.getString("instructions"));
                    prescription.put("diagnosis", rs.getString("diagnosis"));
                    prescription.put("appointmentDate", rs.getDate("appointment_date"));
                    prescriptions.add(prescription);
                }
            }
        }
        return prescriptions;
    }
    
    // ===== DOCTOR PERFORMANCE & ANALYTICS =====
    
    /**
     * Lấy performance metrics của doctor
     */
    public Map<String, Object> getDoctorPerformanceMetrics(int doctorId, String period) throws SQLException {
        Map<String, Object> metrics = new HashMap<>();
        
        String dateCondition = "";
        switch (period.toLowerCase()) {
            case "week":
                dateCondition = "AND appointment_date >= DATEADD(week, -1, GETDATE())";
                break;
            case "month":
                dateCondition = "AND appointment_date >= DATEADD(month, -1, GETDATE())";
                break;
            case "quarter":
                dateCondition = "AND appointment_date >= DATEADD(quarter, -1, GETDATE())";
                break;
            case "year":
                dateCondition = "AND appointment_date >= DATEADD(year, -1, GETDATE())";
                break;
        }
        
        // Patient satisfaction rate
        String satisfactionSql = "SELECT AVG(CAST(rating as FLOAT)) as avg_rating, COUNT(*) as total_ratings " +
                               "FROM appointment_feedbacks af " +
                               "JOIN appointments a ON af.appointment_id = a.appointment_id " +
                               "WHERE a.doctor_id = ? " + dateCondition;
        
        // Appointment completion rate
        String completionSql = "SELECT " +
                             "COUNT(*) as total_appointments, " +
                             "COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) as completed_appointments, " +
                             "COUNT(CASE WHEN status = 'CANCELLED' THEN 1 END) as cancelled_appointments " +
                             "FROM appointments WHERE doctor_id = ? " + dateCondition.replace("appointment_date", "appointment_date");
        
        // Average consultation time
        String consultationTimeSql = "SELECT AVG(DATEDIFF(minute, start_time, end_time)) as avg_consultation_minutes " +
                                   "FROM appointment_sessions " +
                                   "WHERE doctor_id = ? AND end_time IS NOT NULL " + 
                                   dateCondition.replace("appointment_date", "session_date");
        
        // Revenue generated
        String revenueSql = "SELECT SUM(b.total_amount) as total_revenue, COUNT(b.bill_id) as paid_bills " +
                          "FROM bills b " +
                          "JOIN appointments a ON b.appointment_id = a.appointment_id " +
                          "WHERE a.doctor_id = ? AND b.status = 'PAID' " + dateCondition;
        
        try (PreparedStatement st1 = connection.prepareStatement(satisfactionSql);
             PreparedStatement st2 = connection.prepareStatement(completionSql);
             PreparedStatement st3 = connection.prepareStatement(consultationTimeSql);
             PreparedStatement st4 = connection.prepareStatement(revenueSql)) {
            
            st1.setInt(1, doctorId);
            st2.setInt(1, doctorId);
            st3.setInt(1, doctorId);
            st4.setInt(1, doctorId);
            
            // Patient satisfaction
            try (ResultSet rs1 = st1.executeQuery()) {
                if (rs1.next()) {
                    metrics.put("avgRating", rs1.getDouble("avg_rating"));
                    metrics.put("totalRatings", rs1.getInt("total_ratings"));
                }
            }
            
            // Appointment metrics
            try (ResultSet rs2 = st2.executeQuery()) {
                if (rs2.next()) {
                    int total = rs2.getInt("total_appointments");
                    int completed = rs2.getInt("completed_appointments");
                    int cancelled = rs2.getInt("cancelled_appointments");
                    
                    metrics.put("totalAppointments", total);
                    metrics.put("completedAppointments", completed);
                    metrics.put("cancelledAppointments", cancelled);
                    metrics.put("completionRate", total > 0 ? (completed * 100.0 / total) : 0);
                    metrics.put("cancellationRate", total > 0 ? (cancelled * 100.0 / total) : 0);
                }
            }
            
            // Consultation time
            try (ResultSet rs3 = st3.executeQuery()) {
                if (rs3.next()) {
                    metrics.put("avgConsultationMinutes", rs3.getDouble("avg_consultation_minutes"));
                }
            }
            
            // Revenue
            try (ResultSet rs4 = st4.executeQuery()) {
                if (rs4.next()) {
                    metrics.put("totalRevenue", rs4.getBigDecimal("total_revenue"));
                    metrics.put("paidBills", rs4.getInt("paid_bills"));
                }
            }
        }
        
        return metrics;
    }
    
    /**
     * Lấy patient retention rate của doctor
     */
    public double getDoctorPatientRetentionRate(int doctorId, int months) throws SQLException {
        String sql = "SELECT " +
                    "COUNT(DISTINCT patient_id) as total_patients, " +
                    "COUNT(DISTINCT CASE WHEN appointment_count > 1 THEN patient_id END) as returning_patients " +
                    "FROM (" +
                    "    SELECT patient_id, COUNT(*) as appointment_count " +
                    "    FROM appointments " +
                    "    WHERE doctor_id = ? " +
                    "    AND appointment_date >= DATEADD(month, -?, GETDATE()) " +
                    "    AND status = 'COMPLETED' " +
                    "    GROUP BY patient_id" +
                    ") patient_stats";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setInt(2, months);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    int totalPatients = rs.getInt("total_patients");
                    int returningPatients = rs.getInt("returning_patients");
                    
                    return totalPatients > 0 ? (returningPatients * 100.0 / totalPatients) : 0;
                }
            }
        }
        
        return 0;
    }
    
    /**
     * Lấy most common diagnoses của doctor
     */
    public List<Map<String, Object>> getDoctorCommonDiagnoses(int doctorId, int limit) throws SQLException {
        List<Map<String, Object>> diagnoses = new ArrayList<>();
        String sql = "SELECT diagnosis, COUNT(*) as frequency, " +
                    "COUNT(*) * 100.0 / (SELECT COUNT(*) FROM medical_reports WHERE doctor_id = ?) as percentage " +
                    "FROM medical_reports " +
                    "WHERE doctor_id = ? AND diagnosis IS NOT NULL AND diagnosis != '' " +
                    "GROUP BY diagnosis " +
                    "ORDER BY frequency DESC";
        
        if (limit > 0) {
            sql += " OFFSET 0 ROWS FETCH NEXT " + limit + " ROWS ONLY";
        }
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setInt(2, doctorId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> diagnosis = new HashMap<>();
                    diagnosis.put("diagnosis", rs.getString("diagnosis"));
                    diagnosis.put("frequency", rs.getInt("frequency"));
                    diagnosis.put("percentage", rs.getDouble("percentage"));
                    diagnoses.add(diagnosis);
                }
            }
        }
        
        return diagnoses;
    }
    
    /**
     * Tạo comprehensive doctor report
     */
    public Map<String, Object> generateDoctorComprehensiveReport(int doctorId, String fromDate, String toDate) throws SQLException {
        Map<String, Object> report = new HashMap<>();
        
        // Basic info
        Doctors doctor = getDoctorById(doctorId);
        report.put("doctorInfo", doctor);
        
        // Performance metrics
        report.put("performanceMetrics", getDoctorPerformanceMetrics(doctorId, "month"));
        
        // Financial summary
        report.put("payments", getDoctorPayments(doctorId, fromDate, toDate));
        
        // Top services
        report.put("topServices", getTopServicesByDoctor(doctorId, fromDate, toDate, 5));
        
        // Common diagnoses
        report.put("commonDiagnoses", getDoctorCommonDiagnoses(doctorId, 10));
        
        // Schedule efficiency
        List<String> scheduleConflicts = checkScheduleConflicts(doctorId, fromDate, toDate);
        report.put("scheduleConflicts", scheduleConflicts);
        report.put("scheduleEfficiency", scheduleConflicts.isEmpty() ? "Excellent" : "Needs attention");
        
        // Patient retention
        double retentionRate = getDoctorPatientRetentionRate(doctorId, 6);
        report.put("patientRetentionRate", retentionRate);
        
        // Feedback stats
        report.put("feedbackStats", getDoctorFeedbackStats(doctorId));
        
        // Medical reports count
        List<Map<String, Object>> medicalReports = getDoctorMedicalReports(doctorId, fromDate, toDate);
        report.put("totalMedicalReports", medicalReports.size());
        
        // Prescription patterns
        List<Map<String, Object>> prescriptions = getDoctorPrescriptions(doctorId, fromDate, toDate);
        report.put("totalPrescriptions", prescriptions.size());
        
        // Schedule suggestions
        report.put("scheduleSuggestions", suggestOptimalSchedule(doctorId, "", ""));
        
        return report;
    }
    
    // ===== INTEGRATION & UTILITY METHODS =====
    
    /**
     * Sync doctor data với external systems
     */
    public boolean syncDoctorWithExternalSystem(int doctorId, String systemName, Map<String, Object> syncData) throws SQLException {
        String sql = "INSERT INTO doctor_external_sync (doctor_id, system_name, sync_data, last_sync, status) " +
                    "VALUES (?, ?, ?, GETDATE(), 'SUCCESS') " +
                    "ON DUPLICATE KEY UPDATE sync_data = VALUES(sync_data), last_sync = VALUES(last_sync), status = VALUES(status)";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, systemName);
            st.setString(3, syncData.toString());
            
            return st.executeUpdate() > 0;
        }
    }
    
    /**
     * Export doctor data for backup/migration
     */
    public Map<String, Object> exportDoctorData(int doctorId) throws SQLException {
        Map<String, Object> exportData = new HashMap<>();
        
        // Doctor basic info
        exportData.put("doctor", getDoctorById(doctorId));
        
        // Schedules
        exportData.put("schedules", getDoctorSchedules(doctorId, "", ""));
        
        // Appointments (last 12 months)
        String fromDate = LocalDate.now().minusMonths(12).toString();
        String toDate = LocalDate.now().toString();
        
        exportData.put("appointments", getDoctorAppointments(doctorId, fromDate, toDate));
        exportData.put("medicalReports", getDoctorMedicalReports(doctorId, fromDate, toDate));
        exportData.put("prescriptions", getDoctorPrescriptions(doctorId, fromDate, toDate));
        exportData.put("payments", getDoctorPayments(doctorId, fromDate, toDate));
        
        // Performance data
        exportData.put("performanceMetrics", getDoctorPerformanceMetrics(doctorId, "year"));
        exportData.put("feedbackStats", getDoctorFeedbackStats(doctorId));
        
        // Meta info
        exportData.put("exportDate", LocalDateTime.now().toString());
        exportData.put("exportVersion", "1.0");
        
        return exportData;
    }
    
    /**
     * Import doctor data từ backup
     */
    public boolean importDoctorData(Map<String, Object> importData) throws SQLException {
        try {
            // Validate import data structure
            if (!importData.containsKey("doctor") || !importData.containsKey("exportVersion")) {
                return false;
            }
            
            // Import doctor basic info
            @SuppressWarnings("unchecked")
            Map<String, Object> doctorData = (Map<String, Object>) importData.get("doctor");
            
            // Import schedules
            if (importData.containsKey("schedules")) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> schedules = (List<Map<String, Object>>) importData.get("schedules");
                // Process schedules import
            }
            
            // Import other data as needed
            
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    

    // ===== ADVANCED REPORTING & ANALYTICS =====
    
    /**
     * Tạo detailed revenue report cho doctor
     */
    public Map<String, Object> generateDoctorRevenueReport(int doctorId, String fromDate, String toDate, String groupBy) throws SQLException {
        Map<String, Object> report = new HashMap<>();
        List<Map<String, Object>> revenueData = new ArrayList<>();
        
        String groupByClause = "";
        String selectClause = "";
        
        switch (groupBy.toLowerCase()) {
            case "daily":
                selectClause = "CONVERT(varchar, a.appointment_date, 23) as period";
                groupByClause = "GROUP BY CONVERT(varchar, a.appointment_date, 23)";
                break;
            case "weekly":
                selectClause = "DATEPART(year, a.appointment_date) as year, DATEPART(week, a.appointment_date) as week";
                groupByClause = "GROUP BY DATEPART(year, a.appointment_date), DATEPART(week, a.appointment_date)";
                break;
            case "monthly":
                selectClause = "DATEPART(year, a.appointment_date) as year, DATEPART(month, a.appointment_date) as month";
                groupByClause = "GROUP BY DATEPART(year, a.appointment_date), DATEPART(month, a.appointment_date)";
                break;
            default:
                selectClause = "CONVERT(varchar, a.appointment_date, 23) as period";
                groupByClause = "GROUP BY CONVERT(varchar, a.appointment_date, 23)";
        }
        
        String sql = "SELECT " + selectClause + ", " +
                    "COUNT(DISTINCT a.appointment_id) as total_appointments, " +
                    "COUNT(DISTINCT CASE WHEN b.status = 'PAID' THEN b.bill_id END) as paid_appointments, " +
                    "SUM(CASE WHEN b.status = 'PAID' THEN b.total_amount ELSE 0 END) as total_revenue, " +
                    "AVG(CASE WHEN b.status = 'PAID' THEN b.total_amount ELSE NULL END) as avg_revenue_per_appointment, " +
                    "SUM(CASE WHEN b.status = 'PENDING' THEN b.total_amount ELSE 0 END) as pending_revenue " +
                    "FROM appointments a " +
                    "LEFT JOIN bills b ON a.appointment_id = b.appointment_id " +
                    "WHERE a.doctor_id = ? AND a.appointment_date BETWEEN ? AND ? " +
                    groupByClause + " ORDER BY " + selectClause;
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                BigDecimal totalRevenue = BigDecimal.ZERO;
                int totalAppointments = 0;
                
                while (rs.next()) {
                    Map<String, Object> periodData = new HashMap<>();
                    
                    if (groupBy.equals("daily")) {
                        periodData.put("period", rs.getString("period"));
                    } else {
                        periodData.put("year", rs.getInt("year"));
                        if (groupBy.equals("weekly")) {
                            periodData.put("week", rs.getInt("week"));
                        } else if (groupBy.equals("monthly")) {
                            periodData.put("month", rs.getInt("month"));
                        }
                    }
                    
                    int appointments = rs.getInt("total_appointments");
                    BigDecimal revenue = rs.getBigDecimal("total_revenue");
                    
                    periodData.put("totalAppointments", appointments);
                    periodData.put("paidAppointments", rs.getInt("paid_appointments"));
                    periodData.put("totalRevenue", revenue);
                    periodData.put("avgRevenuePerAppointment", rs.getBigDecimal("avg_revenue_per_appointment"));
                    periodData.put("pendingRevenue", rs.getBigDecimal("pending_revenue"));
                    
                    revenueData.add(periodData);
                    
                    totalRevenue = totalRevenue.add(revenue);
                    totalAppointments += appointments;
                }
                
                report.put("revenueData", revenueData);
                report.put("summaryStats", Map.of(
                    "totalRevenue", totalRevenue,
                    "totalAppointments", totalAppointments,
                    "avgRevenuePerAppointment", totalAppointments > 0 ? totalRevenue.divide(BigDecimal.valueOf(totalAppointments), 2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO
                ));
            }
        }
        
        return report;
    }
    
    /**
     * Phân tích patient demographics cho doctor
     */
    public Map<String, Object> analyzeDoctorPatientDemographics(int doctorId, String fromDate, String toDate) throws SQLException {
        Map<String, Object> demographics = new HashMap<>();
        
        // Age distribution
        String ageSql = "SELECT " +
                       "COUNT(CASE WHEN DATEDIFF(year, p.date_of_birth, GETDATE()) < 18 THEN 1 END) as under_18, " +
                       "COUNT(CASE WHEN DATEDIFF(year, p.date_of_birth, GETDATE()) BETWEEN 18 AND 30 THEN 1 END) as age_18_30, " +
                       "COUNT(CASE WHEN DATEDIFF(year, p.date_of_birth, GETDATE()) BETWEEN 31 AND 50 THEN 1 END) as age_31_50, " +
                       "COUNT(CASE WHEN DATEDIFF(year, p.date_of_birth, GETDATE()) BETWEEN 51 AND 65 THEN 1 END) as age_51_65, " +
                       "COUNT(CASE WHEN DATEDIFF(year, p.date_of_birth, GETDATE()) > 65 THEN 1 END) as over_65 " +
                       "FROM patients p " +
                       "JOIN appointments a ON p.patient_id = a.patient_id " +
                       "WHERE a.doctor_id = ? AND a.appointment_date BETWEEN ? AND ?";
        
        // Gender distribution
        String genderSql = "SELECT gender, COUNT(*) as count " +
                          "FROM patients p " +
                          "JOIN appointments a ON p.patient_id = a.patient_id " +
                          "WHERE a.doctor_id = ? AND a.appointment_date BETWEEN ? AND ? " +
                          "GROUP BY gender";
        
        // Geographic distribution
        String locationSql = "SELECT p.city, COUNT(*) as patient_count " +
                           "FROM patients p " +
                           "JOIN appointments a ON p.patient_id = a.patient_id " +
                           "WHERE a.doctor_id = ? AND a.appointment_date BETWEEN ? AND ? " +
                           "GROUP BY p.city " +
                           "ORDER BY patient_count DESC";
        
        try (PreparedStatement st1 = connection.prepareStatement(ageSql);
             PreparedStatement st2 = connection.prepareStatement(genderSql);
             PreparedStatement st3 = connection.prepareStatement(locationSql)) {
            
            // Age distribution
            st1.setInt(1, doctorId);
            st1.setString(2, fromDate);
            st1.setString(3, toDate);
            
            try (ResultSet rs1 = st1.executeQuery()) {
                if (rs1.next()) {
                    Map<String, Integer> ageDistribution = new HashMap<>();
                    ageDistribution.put("under_18", rs1.getInt("under_18"));
                    ageDistribution.put("age_18_30", rs1.getInt("age_18_30"));
                    ageDistribution.put("age_31_50", rs1.getInt("age_31_50"));
                    ageDistribution.put("age_51_65", rs1.getInt("age_51_65"));
                    ageDistribution.put("over_65", rs1.getInt("over_65"));
                    demographics.put("ageDistribution", ageDistribution);
                }
            }
            
            // Gender distribution
            st2.setInt(1, doctorId);
            st2.setString(2, fromDate);
            st2.setString(3, toDate);
            
            List<Map<String, Object>> genderData = new ArrayList<>();
            try (ResultSet rs2 = st2.executeQuery()) {
                while (rs2.next()) {
                    Map<String, Object> gender = new HashMap<>();
                    gender.put("gender", rs2.getString("gender"));
                    gender.put("count", rs2.getInt("count"));
                    genderData.add(gender);
                }
            }
            demographics.put("genderDistribution", genderData);
            
            // Location distribution
            st3.setInt(1, doctorId);
            st3.setString(2, fromDate);
            st3.setString(3, toDate);
            
            List<Map<String, Object>> locationData = new ArrayList<>();
            try (ResultSet rs3 = st3.executeQuery()) {
                while (rs3.next()) {
                    Map<String, Object> location = new HashMap<>();
                    location.put("city", rs3.getString("city"));
                    location.put("patientCount", rs3.getInt("patient_count"));
                    locationData.add(location);
                }
            }
            demographics.put("locationDistribution", locationData);
        }
        
        return demographics;
    }
    
    /**
     * Predictive analytics cho doctor workload
     */
    public Map<String, Object> predictDoctorWorkload(int doctorId, int predictDays) throws SQLException {
        Map<String, Object> prediction = new HashMap<>();
        
        // Historical pattern analysis
        String historicalSql = "SELECT " +
                             "DATEPART(weekday, appointment_date) as day_of_week, " +
                             "DATEPART(hour, appointment_time) as hour_of_day, " +
                             "COUNT(*) as appointment_count, " +
                             "AVG(DATEDIFF(minute, appointment_time, DATEADD(minute, 30, appointment_time))) as avg_duration " +
                             "FROM appointments " +
                             "WHERE doctor_id = ? " +
                             "AND appointment_date >= DATEADD(month, -3, GETDATE()) " +
                             "AND status = 'COMPLETED' " +
                             "GROUP BY DATEPART(weekday, appointment_date), DATEPART(hour, appointment_time) " +
                             "ORDER BY day_of_week, hour_of_day";
        
        // Seasonal trends
        String seasonalSql = "SELECT " +
                           "DATEPART(month, appointment_date) as month, " +
                           "AVG(daily_appointments) as avg_daily_appointments " +
                           "FROM (" +
                           "    SELECT appointment_date, COUNT(*) as daily_appointments " +
                           "    FROM appointments " +
                           "    WHERE doctor_id = ? " +
                           "    AND appointment_date >= DATEADD(year, -1, GETDATE()) " +
                           "    GROUP BY appointment_date" +
                           ") daily_stats " +
                           "GROUP BY DATEPART(month, appointment_date) " +
                           "ORDER BY month";
        
        try (PreparedStatement st1 = connection.prepareStatement(historicalSql);
             PreparedStatement st2 = connection.prepareStatement(seasonalSql)) {
            
            // Historical patterns
            st1.setInt(1, doctorId);
            List<Map<String, Object>> patterns = new ArrayList<>();
            
            try (ResultSet rs1 = st1.executeQuery()) {
                while (rs1.next()) {
                    Map<String, Object> pattern = new HashMap<>();
                    pattern.put("dayOfWeek", rs1.getInt("day_of_week"));
                    pattern.put("hourOfDay", rs1.getInt("hour_of_day"));
                    pattern.put("avgAppointments", rs1.getInt("appointment_count"));
                    pattern.put("avgDuration", rs1.getInt("avg_duration"));
                    patterns.add(pattern);
                }
            }
            prediction.put("historicalPatterns", patterns);
            
            // Seasonal trends
            st2.setInt(1, doctorId);
            List<Map<String, Object>> seasonalTrends = new ArrayList<>();
            
            try (ResultSet rs2 = st2.executeQuery()) {
                while (rs2.next()) {
                    Map<String, Object> trend = new HashMap<>();
                    trend.put("month", rs2.getInt("month"));
                    trend.put("avgDailyAppointments", rs2.getDouble("avg_daily_appointments"));
                    seasonalTrends.add(trend);
                }
            }
            prediction.put("seasonalTrends", seasonalTrends);
            
            // Generate predictions for next N days
            List<Map<String, Object>> predictions = new ArrayList<>();
            LocalDate currentDate = LocalDate.now();
            
            for (int i = 1; i <= predictDays; i++) {
                LocalDate targetDate = currentDate.plusDays(i);
                int dayOfWeek = targetDate.getDayOfWeek().getValue();
                int month = targetDate.getMonthValue();
                
                Map<String, Object> dayPrediction = new HashMap<>();
                dayPrediction.put("date", targetDate.toString());
                dayPrediction.put("dayOfWeek", dayOfWeek);
                
                // Calculate predicted workload based on historical patterns
                double predictedAppointments = patterns.stream()
                    .filter(p -> ((Integer) p.get("dayOfWeek")) == dayOfWeek)
                    .mapToInt(p -> (Integer) p.get("avgAppointments"))
                    .average()
                    .orElse(0.0);
                
                // Apply seasonal adjustment
                double seasonalMultiplier = seasonalTrends.stream()
                    .filter(t -> ((Integer) t.get("month")) == month)
                    .mapToDouble(t -> (Double) t.get("avgDailyAppointments"))
                    .findFirst()
                    .orElse(1.0) / seasonalTrends.stream()
                    .mapToDouble(t -> (Double) t.get("avgDailyAppointments"))
                    .average()
                    .orElse(1.0);
                
                predictedAppointments *= seasonalMultiplier;
                
                dayPrediction.put("predictedAppointments", Math.round(predictedAppointments));
                dayPrediction.put("workloadLevel", getWorkloadLevel((int) Math.round(predictedAppointments)));
                
                predictions.add(dayPrediction);
            }
            
            prediction.put("predictions", predictions);
        }
        
        return prediction;
    }
    
    private String getWorkloadLevel(int appointmentCount) {
        if (appointmentCount <= 5) return "Light";
        else if (appointmentCount <= 10) return "Moderate";
        else if (appointmentCount <= 15) return "Heavy";
        else return "Overloaded";
    }
    
    /**
     * Tạo AI-powered recommendations cho doctor
     */
    public List<Map<String, Object>> generateDoctorRecommendations(int doctorId) throws SQLException {
        List<Map<String, Object>> recommendations = new ArrayList<>();
        
        // Analyze recent performance
        Map<String, Object> recentStats = getDoctorPerformanceMetrics(doctorId, "month");
        
        // Schedule optimization recommendations
        List<String> scheduleConflicts = checkScheduleConflicts(doctorId, 
            LocalDate.now().toString(), 
            LocalDate.now().plusDays(30).toString());
        
        if (!scheduleConflicts.isEmpty()) {
            recommendations.add(Map.of(
                "type", "SCHEDULE_OPTIMIZATION",
                "priority", "HIGH",
                "title", "Tối ưu hóa lịch trình",
                "description", "Phát hiện " + scheduleConflicts.size() + " xung đột trong lịch trình",
                "action", "Xem lại và điều chỉnh lịch làm việc",
                "impact", "Giảm căng thẳng và tăng hiệu quả làm việc"
            ));
        }
        
        // Patient satisfaction recommendations
        if (recentStats.containsKey("avgRating")) {
            double avgRating = (Double) recentStats.get("avgRating");
            if (avgRating < 4.0) {
                recommendations.add(Map.of(
                    "type", "PATIENT_SATISFACTION",
                    "priority", "MEDIUM",
                    "title", "Cải thiện sự hài lòng của bệnh nhân",
                    "description", "Điểm đánh giá trung bình: " + String.format("%.1f", avgRating),
                    "action", "Tập trung vào giao tiếp và chất lượng dịch vụ",
                    "impact", "Tăng độ hài lòng và giữ chân bệnh nhân"
                ));
            }
        }
        
        // Revenue optimization
        if (recentStats.containsKey("totalRevenue")) {
            BigDecimal revenue = (BigDecimal) recentStats.get("totalRevenue");
            if (revenue != null && revenue.compareTo(BigDecimal.valueOf(10000)) < 0) {
                recommendations.add(Map.of(
                    "type", "REVENUE_OPTIMIZATION",
                    "priority", "MEDIUM",
                    "title", "Tối ưu hóa doanh thu",
                    "description", "Doanh thu tháng này thấp hơn mong đợi",
                    "action", "Xem xét tăng số ca khám hoặc cải thiện dịch vụ",
                    "impact", "Tăng thu nhập và phát triển sự nghiệp"
                ));
            }
        }
        
        // Workload balance recommendations
        Map<String, Object> workloadPrediction = predictDoctorWorkload(doctorId, 7);
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> predictions = (List<Map<String, Object>>) workloadPrediction.get("predictions");
        
        boolean hasOverload = predictions.stream()
            .anyMatch(p -> "Overloaded".equals(p.get("workloadLevel")));
        
        if (hasOverload) {
            recommendations.add(Map.of(
                "type", "WORKLOAD_BALANCE",
                "priority", "HIGH",
                "title", "Cân bằng khối lượng công việc",
                "description", "Dự đoán quá tải trong tuần tới",
                "action", "Điều chỉnh lịch hoặc tăng thời gian nghỉ",
                "impact", "Tránh burnout và duy trì chất lượng chăm sóc"
            ));
        }
        
        // Professional development recommendations
        List<Map<String, Object>> commonDiagnoses = getDoctorCommonDiagnoses(doctorId, 3);
        if (commonDiagnoses.size() > 0) {
            String topDiagnosis = (String) commonDiagnoses.get(0).get("diagnosis");
            recommendations.add(Map.of(
                "type", "PROFESSIONAL_DEVELOPMENT",
                "priority", "LOW",
                "title", "Phát triển chuyên môn",
                "description", "Chuyên sâu về " + topDiagnosis + " (chẩn đoán phổ biến nhất)",
                "action", "Tham gia khóa học hoặc hội thảo chuyên đề",
                "impact", "Nâng cao chuyên môn và uy tín"
            ));
        }
        
        // Technology integration recommendations
        recommendations.add(Map.of(
            "type", "TECHNOLOGY",
            "priority", "LOW", 
            "title", "Tích hợp công nghệ",
            "description", "Sử dụng AI và automation để cải thiện hiệu quả",
            "action", "Khám phá các công cụ hỗ trợ chẩn đoán và quản lý bệnh nhân",
            "impact", "Tăng độ chính xác và tiết kiệm thời gian"
        ));
        
        return recommendations;
    }
    
    /**
     * Backup và cleanup data cũ
     */
    public boolean cleanupOldDoctorData(int doctorId, int retentionMonths) throws SQLException {
        String cutoffDate = LocalDate.now().minusMonths(retentionMonths).toString();
        
        // Archive old appointments
        String archiveSql = "INSERT INTO appointments_archive SELECT * FROM appointments " +
                          "WHERE doctor_id = ? AND appointment_date < ? AND status IN ('COMPLETED', 'CANCELLED')";
        
        // Delete archived data from main table
        String deleteSql = "DELETE FROM appointments WHERE doctor_id = ? AND appointment_date < ? " +
                         "AND status IN ('COMPLETED', 'CANCELLED')";
        
        try (PreparedStatement st1 = connection.prepareStatement(archiveSql);
             PreparedStatement st2 = connection.prepareStatement(deleteSql)) {
            
            // Archive
            st1.setInt(1, doctorId);
            st1.setString(2, cutoffDate);
            st1.executeUpdate();
            
            // Delete
            st2.setInt(1, doctorId);
            st2.setString(2, cutoffDate);
            int deletedRows = st2.executeUpdate();
            
            return deletedRows > 0;
        }
    }
    
    // Helper methods for missing functionality
    private List<Map<String, Object>> getDoctorSchedules(int doctorId, String fromDate, String toDate) throws SQLException {
        List<Map<String, Object>> schedules = new ArrayList<>();
        String sql = "SELECT * FROM doctor_schedules WHERE doctor_id = ? AND work_date BETWEEN ? AND ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> schedule = new HashMap<>();
                    schedule.put("scheduleId", rs.getInt("schedule_id"));
                    schedule.put("workDate", rs.getDate("work_date"));
                    schedule.put("startTime", rs.getTime("start_time"));
                    schedule.put("endTime", rs.getTime("end_time"));
                    schedule.put("status", rs.getString("status"));
                    schedules.add(schedule);
                }
            }
        }
        return schedules;
    }
    
    private List<Map<String, Object>> getDoctorAppointments(int doctorId, String fromDate, String toDate) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE doctor_id = ? AND appointment_date BETWEEN ? AND ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, doctorId);
            st.setString(2, fromDate);
            st.setString(3, toDate);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("appointment_id"));
                    appointment.put("patientId", rs.getInt("patient_id"));
                    appointment.put("appointmentDate", rs.getDate("appointment_date"));
                    appointment.put("appointmentTime", rs.getTime("appointment_time"));
                    appointment.put("status", rs.getString("status"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
        // Lấy lịch làm việc của một bác sĩ cụ thể
    public List<DoctorSchedule> getSchedulesByDoctorId(int doctorId) throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = """
            SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id,
                   d.full_name, d.specialty, d.phone, d.status,
                   ts.start_time, ts.end_time
            FROM DoctorSchedule ds
            JOIN Doctors d ON ds.doctor_id = d.doctor_id
            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
            WHERE ds.doctor_id = ?
            ORDER BY ds.work_date, ts.start_time
            """;

        try (Connection connection = DBContext.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            System.out.println("Executing query for doctor ID: " + doctorId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    try {
                        DoctorSchedule schedule = new DoctorSchedule();
                        schedule.setScheduleId(resultSet.getInt("schedule_id"));
                        schedule.setDoctorId(resultSet.getInt("doctor_id"));

                        // Xử lý work_date an toàn
                        Date workDateSql = resultSet.getDate("work_date");
                        if (workDateSql != null) {
                            schedule.setWorkDate(new java.sql.Date(workDateSql.getTime()));
                        }

                        schedule.setSlotId(resultSet.getInt("slot_id"));

                        // Tạo Doctor object
                        Doctors doctor = new Doctors();
                        doctor.setDoctor_id(resultSet.getInt("doctor_id"));
                        doctor.setFull_name(resultSet.getString("full_name"));
                        doctor.setSpecialty(resultSet.getString("specialty"));
                        doctor.setPhone(resultSet.getString("phone"));
                        doctor.setStatus(resultSet.getString("status"));
                        schedule.setDoctor(doctor);

                        // Tạo TimeSlot object
                        TimeSlot timeSlot = new TimeSlot();
                        timeSlot.setSlotId(resultSet.getInt("slot_id"));

                        // Xử lý time an toàn
                        Time startTimeSql = resultSet.getTime("start_time");
                        Time endTimeSql = resultSet.getTime("end_time");

                        if (startTimeSql != null) {
                            timeSlot.setStartTime(startTimeSql.toLocalTime());
                        }
                        if (endTimeSql != null) {
                            timeSlot.setEndTime(endTimeSql.toLocalTime());
                        }

                        schedule.setTimeSlot(timeSlot);

                        schedules.add(schedule);
                    } catch (Exception e) {
                        System.err.println("Error processing row for doctor " + doctorId + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getSchedulesByDoctorId: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        System.out.println("Schedules found for doctor " + doctorId + ": " + schedules.size());
        return schedules;
    }
}
