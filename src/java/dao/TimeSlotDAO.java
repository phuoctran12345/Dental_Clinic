/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.TimeSlot;
import utils.DBContext;

/**
 *
 * @author tranhongphuoc
 */
public class TimeSlotDAO {
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public TimeSlotDAO() {
        conn = DBContext.getConnection();
    }

    public List<TimeSlot> getAllTimeSlots() {
        List<TimeSlot> allSlots = new ArrayList<>();
        String sql = "SELECT * FROM TimeSlot ORDER BY start_time";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setStartTime(rs.getTime("start_time").toLocalTime());
                slot.setEndTime(rs.getTime("end_time").toLocalTime());
                allSlots.add(slot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return allSlots;
    }

    public TimeSlot getTimeSlotById(int slotId) {
        String sql = "SELECT * FROM TimeSlot WHERE slot_id = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, slotId);
            rs = ps.executeQuery();
            if (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                if (startTime != null && endTime != null) {
                    slot.setStartTime(startTime.toLocalTime());
                    slot.setEndTime(endTime.toLocalTime());
                }
                return slot;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addTimeSlot(LocalTime startTime, LocalTime endTime) {
        String sql = "INSERT INTO TimeSlot (start_time, end_time) VALUES (?, ?)";
        try {
            ps = conn.prepareStatement(sql);
            ps.setTime(1, Time.valueOf(startTime));
            ps.setTime(2, Time.valueOf(endTime));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTimeSlot(int slotId, LocalTime startTime, LocalTime endTime) {
        String sql = "UPDATE TimeSlot SET start_time = ?, end_time = ? WHERE slot_id = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setTime(1, Time.valueOf(startTime));
            ps.setTime(2, Time.valueOf(endTime));
            ps.setInt(3, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTimeSlot(int slotId) {
        String sql = "DELETE FROM TimeSlot WHERE slot_id = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<TimeSlot> getAvailableSlots(int doctorId, java.sql.Date workDate) {
        List<TimeSlot> availableSlots = new ArrayList<>();
        String sql = """
            SELECT ts.* FROM TimeSlot ts
            WHERE ts.slot_id IN (
                SELECT ds.slot_id FROM DoctorSchedule ds 
                WHERE ds.doctor_id = ? AND ds.work_date = ?
                AND ds.status = 'APPROVED'
            )
            AND ts.slot_id NOT IN (
                SELECT a.slot_id FROM Appointment a 
                WHERE a.doctor_id = ? AND a.work_date = ?
                AND a.status != 'CANCELLED'
            )
            ORDER BY ts.start_time
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, workDate);
            ps.setInt(3, doctorId);
            ps.setDate(4, workDate);
            
            try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setStartTime(rs.getTime("start_time").toLocalTime());
                slot.setEndTime(rs.getTime("end_time").toLocalTime());
                    availableSlots.add(slot);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableSlots;
    }

    /**
     * Lấy khung giờ theo ca làm việc
     * Ca 1: 3002-3009 (sáng)
     * Ca 2: 3010-3019 (chiều) 
     * Ca 3: 3002-3019 (cả ngày)
     */
    public static List<TimeSlot> getSlotsByShift(int shift) {
        List<TimeSlot> slots = new ArrayList<>();
        String sql = "";
        
        switch(shift) {
            case 1: // Ca sáng
                sql = "SELECT * FROM TimeSlot WHERE slot_id BETWEEN 3002 AND 3009 ORDER BY start_time ASC";
                break;
            case 2: // Ca chiều
                sql = "SELECT * FROM TimeSlot WHERE slot_id BETWEEN 3010 AND 3019 ORDER BY start_time ASC";
                break;
            case 3: // Cả ngày
                sql = "SELECT * FROM TimeSlot WHERE slot_id BETWEEN 3002 AND 3019 ORDER BY start_time ASC";
                break;
            default:
                return slots;
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setStartTime(rs.getTime("start_time").toLocalTime());
                slot.setEndTime(rs.getTime("end_time").toLocalTime());
                slots.add(slot);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return slots;
    }

    /**
     * Lấy thông tin TimeSlot từ danh sách slot_id cụ thể
     * Method này được dùng khi bác sĩ đã đăng ký các slot_id cụ thể
     */
    public static List<TimeSlot> getTimeSlotsByIds(List<Integer> slotIds) {
        List<TimeSlot> slots = new ArrayList<>();
        if (slotIds == null || slotIds.isEmpty()) {
            return slots;
        }

        // Tạo câu query với IN clause
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM TimeSlot WHERE slot_id IN (");
        for (int i = 0; i < slotIds.size(); i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
        }
        sql.append(") ORDER BY start_time ASC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters cho IN clause
            for (int i = 0; i < slotIds.size(); i++) {
                ps.setInt(i + 1, slotIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                    Time startTime = rs.getTime("start_time");
                    Time endTime = rs.getTime("end_time");
                    if (startTime != null && endTime != null) {
                        slot.setStartTime(startTime.toLocalTime());
                        slot.setEndTime(endTime.toLocalTime());
                    }
                slots.add(slot);
            }
            }
        } catch (SQLException e) {
            System.err.println("Error in getTimeSlotsByIds: " + e.getMessage());
            e.printStackTrace();
        }
        return slots;
    }

    /**
     * Lấy 3 ca chính trong ngày (slotId = 1, 2, 3)
     */
    public List<TimeSlot> getMainTimeSlots() {
        List<TimeSlot> timeSlots = new ArrayList<>();
        String sql = "SELECT * FROM TimeSlot WHERE slot_id IN (1,2,3) ORDER BY slot_id ASC";
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                if (startTime != null && endTime != null) {
                    slot.setStartTime(startTime.toLocalTime());
                    slot.setEndTime(endTime.toLocalTime());
                }
                timeSlots.add(slot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return timeSlots;
    }
}