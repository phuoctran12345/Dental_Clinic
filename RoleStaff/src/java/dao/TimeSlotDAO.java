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
        List<TimeSlot> timeSlots = new ArrayList<>();
        String sql = "SELECT * FROM TimeSlot ORDER BY start_time";
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
}
