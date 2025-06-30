package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DoctorSchedule;
import model.TimeSlot;
import utils.DBContext;
import java.time.LocalTime;
import java.sql.Time;

public class DoctorScheduleDAO {

    // Khai báo các hằng số SQL
    private static final String GET_ALL = "SELECT * FROM DoctorSchedule";
    private static final String GET_BY_ID = "SELECT * FROM DoctorSchedule WHERE schedule_id = ?";
    private static final String GET_BY_DOCTOR_ID = "SELECT * FROM DoctorSchedule WHERE doctor_id = ?";
    private static final String INSERT = "INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id, status) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_STATUS = "UPDATE DoctorSchedule SET status = ? WHERE schedule_id = ?";
    private static final String DELETE = "DELETE FROM DoctorSchedule WHERE schedule_id = ?";
    private static final String GET_PENDING = "SELECT * FROM DoctorSchedule WHERE status = N'Chờ xác nhận'";
    private static final String GET_APPROVED_BY_DOCTOR = "SELECT * FROM DoctorSchedule WHERE doctor_id = ? AND status = N'approved'";
    
    private static final String GET_AVAILABLE_BY_DOCTOR = 
        "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, " +
        "ts.start_time, ts.end_time, ds.status " +
        "FROM DoctorSchedule ds " +
        "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id " +
        "WHERE ds.doctor_id = ? " +
        "AND ds.status = N'Đã xác nhận đăng kí lịch hẹn với bác sĩ' " +
        "AND ds.work_date >= CONVERT(date, GETDATE()) " +
        "AND NOT EXISTS (" +
        "    SELECT 1 FROM Appointment ap " +
        "    WHERE ap.doctor_id = ds.doctor_id " +
        "      AND ap.work_date = ds.work_date " +
        "      AND ap.slot_id = ds.slot_id " +
        "      AND ap.status IN (N'Đã đặt', N'Đang chờ khám')" +
        ") " +
        "ORDER BY ds.work_date ASC, ts.start_time ASC";
        
    private static final String GET_AVAILABLE_BY_DOCTOR_DATE = 
        "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, " +
        "ts.start_time, ts.end_time, ds.status " +
        "FROM DoctorSchedule ds " +
        "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id " +
        "WHERE ds.doctor_id = ? " +
        "AND ds.work_date = ? " +
        "AND ds.work_date >= CONVERT(date, GETDATE()) " +
        "AND ds.status IN (N'Đã xác nhận đăng kí lịch hẹn với bác sĩ', N'approved', N'Chờ xác nhận') " +
        "AND NOT EXISTS (" +
        "    SELECT 1 FROM Appointment ap " +
        "    WHERE ap.doctor_id = ds.doctor_id " +
        "      AND ap.work_date = ds.work_date " +
        "      AND ap.slot_id = ds.slot_id " +
        "      AND ap.status IN (N'Đã đặt', N'Đang chờ khám')" +
        ") " +
        "ORDER BY ts.start_time ASC";
        
    private static final String GET_DOCTORS_BY_DATE = 
        "SELECT d.doctor_id, d.full_name, d.specialty, d.phone, d.status, d.avatar " +
        "FROM Doctors d JOIN DoctorSchedule ds ON d.doctor_id = ds.doctor_id " +
        "WHERE ds.work_date = ? AND ds.status = 'approved'";
        
    private static final String GET_WORK_DATES_BY_DOCTOR = 
        "SELECT DISTINCT work_date FROM DoctorSchedule " +
        "WHERE doctor_id = ? AND status IN (N'Đã xác nhận đăng kí lịch hẹn với bác sĩ', N'approved') " +
        "ORDER BY work_date ASC";
        
    private static final String GET_APPROVED_SLOTS_BY_DOCTOR_DATE = 
        "SELECT DISTINCT ds.slot_id, ds.status " +
        "FROM DoctorSchedule ds " +
        "WHERE ds.doctor_id = ? " +
        "AND ds.work_date = ? " +
        "AND ds.status IN (N'Đã xác nhận đăng kí lịch hẹn với bác sĩ', N'approved', N'Chờ xác nhận') " +
        "ORDER BY ds.slot_id ASC";

    // Khai báo biến instance
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public DoctorScheduleDAO() {
        conn = DBContext.getConnection();
    }

    // CRUD Methods cơ bản
    public List<DoctorSchedule> getAll() throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_ALL);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    public static DoctorSchedule getScheduleById(int id) throws SQLException {
        DoctorSchedule schedule = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_ID);
                ps.setInt(1, id);
                rs = ps.executeQuery();
                if (rs.next()) {
                    schedule = mapResultSetToSchedule(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        return schedule;
    }

    public boolean addSchedule(DoctorSchedule schedule) {
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(INSERT);
                ps.setLong(1, schedule.getDoctorId());
                ps.setDate(2, schedule.getWorkDate());
                ps.setInt(3, schedule.getSlotId());
                ps.setString(4, "Chờ xác nhận"); // Đặt tiếng Việt chuẩn
                int result = ps.executeUpdate();
                System.out.println("Insert result: " + result); // In ra để debug
                return result > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra log/console
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return false;
    }

    public boolean updateScheduleStatus(int scheduleId, String status) {
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(UPDATE_STATUS);
                ps.setString(1, status);
                ps.setInt(2, scheduleId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return false;
    }

    public boolean deleteSchedule(int scheduleId) throws SQLException {
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(DELETE);
                ps.setInt(1, scheduleId);
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return false;
    }

    // Search và Filter Methods
    public List<DoctorSchedule> getSchedulesByDoctorId(long doctorId) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_BY_DOCTOR_ID);
                ps.setLong(1, doctorId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    public List<DoctorSchedule> getAllPendingSchedules() {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_PENDING);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    public List<DoctorSchedule> getApprovedSchedulesByDoctorId(long doctorId) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(GET_APPROVED_BY_DOCTOR);
                ps.setLong(1, doctorId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    DoctorSchedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return schedules;
    }

    // Static Methods cho các truy vấn phức tạp
    public static List<DoctorSchedule> getAvailableSchedulesByDoctor(int doctorId) {
        List<DoctorSchedule> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_AVAILABLE_BY_DOCTOR);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();

            while (rs.next()) {
                try {
                    DoctorSchedule ds = mapResultSetToScheduleWithTimeSlot(rs);
                    list.add(ds);
                } catch (SQLException e) {
                    System.err.println("Lỗi khi đọc dữ liệu từ ResultSet: " + e.getMessage());
                    continue;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn lịch khám: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        return list;
    }

    public static List<DoctorSchedule> getAvailableSchedules(int doctorId, String workDate) {
        List<DoctorSchedule> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_AVAILABLE_BY_DOCTOR_DATE);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            rs = ps.executeQuery();

            while (rs.next()) {
                try {
                    DoctorSchedule ds = new DoctorSchedule();
                    ds.setScheduleId(rs.getInt("schedule_id"));
                    ds.setDoctorId(rs.getLong("doctor_id"));
                    ds.setWorkDate(rs.getDate("work_date"));
                    ds.setSlotId(rs.getInt("slot_id"));
                    
                    Time startTime = rs.getTime("start_time");
                    LocalTime localStartTime = startTime.toLocalTime();
                    LocalTime localEndTime = localStartTime.plusMinutes(30);
                    
                    ds.setStartTime(Time.valueOf(localStartTime));
                    ds.setEndTime(Time.valueOf(localEndTime));
                    ds.setStatus(rs.getString("status"));

                    TimeSlot ts = new TimeSlot();
                    ts.setStartTime(localStartTime);
                    ts.setEndTime(localEndTime);
                    ds.setTimeSlot(ts);

                    list.add(ds);
                } catch (SQLException e) {
                    System.err.println("Lỗi khi đọc dữ liệu từ ResultSet: " + e.getMessage());
                    continue;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn lịch khám: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        return list;
    }

    public static List<model.Doctors> getDoctorsByWorkDate(String workDate) {
        List<model.Doctors> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_DOCTORS_BY_DATE);
            ps.setDate(1, java.sql.Date.valueOf(workDate));
            rs = ps.executeQuery();
            while (rs.next()) {
                model.Doctors doctor = new model.Doctors();
                doctor.setDoctor_id(rs.getLong("doctor_id"));
                doctor.setFull_name(rs.getString("full_name"));
                doctor.setSpecialty(rs.getString("specialty"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setStatus(rs.getString("status"));
                doctor.setAvatar(rs.getString("avatar"));
                list.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public static List<String> getWorkDatesByDoctorId(int doctorId) {
        List<String> workDates = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_WORK_DATES_BY_DOCTOR);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                workDates.add(rs.getDate("work_date").toString());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return workDates;
    }

    public static List<Integer> getApprovedSlotIdsByDoctorAndDate(int doctorId, String workDate) {
        List<Integer> slotIds = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        System.out.println("🔍 [DEBUG] getApprovedSlotIdsByDoctorAndDate");
        System.out.println("   - Doctor ID: " + doctorId);
        System.out.println("   - Work Date: " + workDate);
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(GET_APPROVED_SLOTS_BY_DOCTOR_DATE);
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int slotId = rs.getInt("slot_id");
                String status = rs.getString("status");
                slotIds.add(slotId);
                System.out.println("   - Found slot: " + slotId + " with status: " + status);
            }
            
            if (slotIds.isEmpty()) {
                System.out.println("   ❌ No slots found! Checking raw data...");
                
                // Debug query - check all schedules for this doctor and date
                String debugSql = "SELECT ds.slot_id, ds.status FROM DoctorSchedule ds WHERE ds.doctor_id = ? AND ds.work_date = ?";
                try (PreparedStatement debugPs = conn.prepareStatement(debugSql)) {
                    debugPs.setInt(1, doctorId);
                    debugPs.setDate(2, java.sql.Date.valueOf(workDate));
                    ResultSet debugRs = debugPs.executeQuery();
                    
                    System.out.println("   🔍 All schedules for this doctor/date:");
                    while (debugRs.next()) {
                        System.out.println("      - Slot: " + debugRs.getInt("slot_id") + ", Status: '" + debugRs.getString("status") + "'");
                    }
                }
                
                // Check if appointments exist for this doctor/date
                String appointmentSql = "SELECT ap.slot_id, ap.status FROM Appointment ap WHERE ap.doctor_id = ? AND ap.work_date = ?";
                try (PreparedStatement apPs = conn.prepareStatement(appointmentSql)) {
                    apPs.setInt(1, doctorId);
                    apPs.setDate(2, java.sql.Date.valueOf(workDate));
                    ResultSet apRs = apPs.executeQuery();
                    
                    System.out.println("   🔍 All appointments for this doctor/date:");
                    boolean hasAppointments = false;
                    while (apRs.next()) {
                        hasAppointments = true;
                        System.out.println("      - Appointment Slot: " + apRs.getInt("slot_id") + ", Status: '" + apRs.getString("status") + "'");
                    }
                    if (!hasAppointments) {
                        System.out.println("      - No appointments found");
                    }
                }
            } else {
                System.out.println("   ✅ Found " + slotIds.size() + " approved slots: " + slotIds);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy slot_id: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        
        return slotIds;
    }

    // Utility Methods
    private static DoctorSchedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setDoctorId(rs.getLong("doctor_id"));
        schedule.setWorkDate(rs.getDate("work_date"));
        schedule.setSlotId(rs.getInt("slot_id"));
        schedule.setStatus(rs.getString("status"));
        return schedule;
    }

    private static DoctorSchedule mapResultSetToScheduleWithTimeSlot(ResultSet rs) throws SQLException {
        DoctorSchedule ds = new DoctorSchedule();
        ds.setScheduleId(rs.getInt("schedule_id"));
        ds.setDoctorId(rs.getLong("doctor_id"));
        ds.setWorkDate(rs.getDate("work_date"));
        ds.setSlotId(rs.getInt("slot_id"));
        ds.setStartTime(rs.getTime("start_time"));
        ds.setEndTime(rs.getTime("end_time"));
        ds.setStatus(rs.getString("status"));

        TimeSlot ts = new TimeSlot();
        ts.setStartTime(rs.getTime("start_time").toLocalTime());
        ts.setEndTime(rs.getTime("end_time").toLocalTime());
        ds.setTimeSlot(ts);

        return ds;
    }

    // Deprecated method - để tương thích ngược
    @Deprecated
    public static Object getAvailableDates(int parseInt) {
        throw new UnsupportedOperationException("Method deprecated. Use getWorkDatesByDoctorId instead.");
    }

    // Test main method
    public static void main(String[] args) {
        try {
            DoctorScheduleDAO dao = new DoctorScheduleDAO();
            
            // Test getAll
            List<DoctorSchedule> schedules = dao.getAll();
            System.out.println("All schedules count: " + schedules.size());
            
            // Test getSchedulesByDoctorId
            if (!schedules.isEmpty()) {
                long doctorId = schedules.get(0).getDoctorId();
                List<DoctorSchedule> doctorSchedules = dao.getSchedulesByDoctorId(doctorId);
                System.out.println("Schedules for doctor " + doctorId + ": " + doctorSchedules.size());
            }
            
            // Test getAllPendingSchedules
            List<DoctorSchedule> pendingSchedules = dao.getAllPendingSchedules();
            System.out.println("Pending schedules count: " + pendingSchedules.size());
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 