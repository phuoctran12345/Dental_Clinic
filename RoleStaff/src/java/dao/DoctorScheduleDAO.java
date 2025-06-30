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

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public DoctorScheduleDAO() {
        conn = DBContext.getConnection();
    }

    public boolean addSchedule(DoctorSchedule schedule) {
        String sql = "INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id, status) VALUES (?, ?, ?, ?)";
        try {
            ps = conn.prepareStatement(sql);
            ps.setLong(1, schedule.getDoctorId());
            ps.setDate(2, schedule.getWorkDate());
            ps.setInt(3, schedule.getSlotId());
            ps.setString(4, "Chờ xác nhận"); // Đặt tiếng Việt chuẩn
            int result = ps.executeUpdate();
            System.out.println("Insert result: " + result); // In ra để debug
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra log/console
            return false;
        }
    }

    public boolean updateScheduleStatus(int scheduleId, String status) {
        String sql = "UPDATE DoctorSchedule SET status = ? WHERE schedule_id = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<DoctorSchedule> getSchedulesByDoctorId(long doctorId) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM DoctorSchedule WHERE doctor_id = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setLong(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getLong("doctor_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setSlotId(rs.getInt("slot_id"));
                schedule.setStatus(rs.getString("status"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public List<DoctorSchedule> getAllPendingSchedules() {
        List<DoctorSchedule> schedules = new ArrayList<>();
           String sql = "SELECT * FROM DoctorSchedule WHERE status = N'Chờ xác nhận'";
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getLong("doctor_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setSlotId(rs.getInt("slot_id"));
                schedule.setStatus(rs.getString("status"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    
    
    public static List<DoctorSchedule> getAvailableSchedulesByDoctor(int doctorId) {
        List<DoctorSchedule> list = new ArrayList<>();
        String sql = "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, "
                + "ts.start_time, ts.end_time, ds.status "
                + "FROM DoctorSchedule ds "
                + "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id "
                + "WHERE ds.doctor_id = ? "
                + "AND ds.status = N'Đã xác nhận đăng kí lịch hẹn với bác sĩ' "
                + "AND ds.work_date >= CONVERT(date, GETDATE()) "
                + "AND NOT EXISTS ("
                + "    SELECT 1 FROM Appointment ap "
                + "    WHERE ap.doctor_id = ds.doctor_id "
                + "      AND ap.work_date = ds.work_date "
                + "      AND ap.slot_id = ds.slot_id "
                + "      AND ap.status IN (N'Đã đặt', N'Đang chờ khám')"
                + ") "
                + "ORDER BY ds.work_date ASC, ts.start_time ASC";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                try {
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

                    list.add(ds);
                } catch (SQLException e) {
                    System.err.println("Lỗi khi đọc dữ liệu từ ResultSet: " + e.getMessage());
                    continue;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn lịch khám: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public static List<DoctorSchedule> getAvailableSchedules(int doctorId, String workDate) {
        List<DoctorSchedule> list = new ArrayList<>();
        String sql = "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, "
                + "ts.start_time, ts.end_time, ds.status "
                + "FROM DoctorSchedule ds "
                + "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id "
                + "WHERE ds.doctor_id = ? "
                + "AND ds.work_date = ? "
                + "AND ds.work_date >= CONVERT(date, GETDATE()) "
                + "AND ds.status IN (N'Đã xác nhận đăng kí lịch hẹn với bác sĩ', N'approved', N'Chờ xác nhận') "
                + "AND NOT EXISTS ("
                + "    SELECT 1 FROM Appointment ap "
                + "    WHERE ap.doctor_id = ds.doctor_id "
                + "      AND ap.work_date = ds.work_date "
                + "      AND ap.slot_id = ds.slot_id "
                + "      AND ap.status IN (N'Đã đặt', N'Đang chờ khám')"
                + ") "
                + "ORDER BY ts.start_time ASC";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(workDate));
            ResultSet rs = ps.executeQuery();

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
        }

        return list;
    }

    public List<DoctorSchedule> getApprovedSchedulesByDoctorId(long doctorId) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM DoctorSchedule WHERE doctor_id = ? AND status = N'approved'";
        try {
            ps = conn.prepareStatement(sql);
            ps.setLong(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getLong("doctor_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setSlotId(rs.getInt("slot_id"));
                schedule.setStatus(rs.getString("status"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public static List<model.Doctors> getDoctorsByWorkDate(String workDate) {
        List<model.Doctors> list = new ArrayList<>();
        String sql = "SELECT d.doctor_id, d.full_name, d.specialty, d.phone, d.status, d.avatar FROM Doctors d JOIN DoctorSchedule ds ON d.doctor_id = ds.doctor_id WHERE ds.work_date = ? AND ds.status = 'approved'";
        try (Connection conn = utils.DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(workDate));
            ResultSet rs = ps.executeQuery();
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
        }
        return list;
    }

    public static List<String> getWorkDatesByDoctorId(int doctorId) {
        List<String> workDates = new ArrayList<>();
        String sql = "SELECT DISTINCT work_date FROM DoctorSchedule WHERE doctor_id = ? AND status IN (N'Đã xác nhận đăng kí lịch hẹn với bác sĩ', N'approved') ORDER BY work_date ASC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                workDates.add(rs.getDate("work_date").toString());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return workDates;
    }
} 