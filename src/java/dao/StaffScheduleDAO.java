package dao;

import java.sql.*;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.StaffSchedule;
import utils.DBContext;

/**
 * Data Access Object for StaffSchedule
 * Xử lý các thao tác database cho lịch làm việc và nghỉ phép của nhân viên
 */
public class StaffScheduleDAO {
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public StaffScheduleDAO() {
        try {
            conn = new DBContext().getConnection();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    /**
     * Lấy tất cả yêu cầu chờ phê duyệt
     */
    public List<StaffSchedule> getPendingRequests() {
        List<StaffSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ss.*, s.full_name as staff_name, ts.start_time, ts.end_time 
            FROM StaffSchedule ss
            INNER JOIN Staff s ON ss.staff_id = s.staff_id
            LEFT JOIN TimeSlot ts ON ss.slot_id = ts.slot_id
            WHERE ss.status = 'pending'
            ORDER BY ss.work_date ASC, ts.start_time ASC
        """;
        
        try {
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                StaffSchedule schedule = new StaffSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setStaffId(rs.getInt("staff_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setSlotId((Integer) rs.getObject("slot_id"));
                schedule.setStatus(rs.getString("status"));
                schedule.setApprovedBy(rs.getInt("approved_by"));
                schedule.setApprovedAt(rs.getTimestamp("approved_at"));
                schedule.setCreatedAt(rs.getTimestamp("created_at"));
                schedule.setStaffName(rs.getString("staff_name"));
                Integer slotId = schedule.getSlotId();
                if (slotId != null) {
                    dao.TimeSlotDAO timeSlotDAO = new dao.TimeSlotDAO();
                    model.TimeSlot slot = timeSlotDAO.getTimeSlotById(slotId);
                    if (slot != null) {
                        schedule.setSlotName(slot.getSlotName());
                        schedule.setSlotTime(slot.getDisplayTime());
                    }
                }
                list.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Lấy lịch nhân viên theo tháng
     */
    public List<StaffSchedule> getStaffSchedulesByMonth(int staffId, int month, int year) {
        List<StaffSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ss.*, ts.start_time, ts.end_time 
            FROM StaffSchedule ss
            LEFT JOIN TimeSlot ts ON ss.slot_id = ts.slot_id
            WHERE ss.staff_id = ? 
            AND MONTH(ss.work_date) = ? 
            AND YEAR(ss.work_date) = ?
            ORDER BY ss.work_date ASC, ts.start_time ASC
        """;
        
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                StaffSchedule schedule = new StaffSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setStaffId(rs.getInt("staff_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setSlotId((Integer) rs.getObject("slot_id"));
                schedule.setStatus(rs.getString("status"));
                schedule.setApprovedBy(rs.getInt("approved_by"));
                schedule.setApprovedAt(rs.getTimestamp("approved_at"));
                schedule.setCreatedAt(rs.getTimestamp("created_at"));
                schedule.setStaffName(rs.getString("staff_name"));
                Integer slotId = schedule.getSlotId();
                if (slotId != null) {
                    dao.TimeSlotDAO timeSlotDAO = new dao.TimeSlotDAO();
                    model.TimeSlot slot = timeSlotDAO.getTimeSlotById(slotId);
                    if (slot != null) {
                        schedule.setSlotName(slot.getSlotName());
                        schedule.setSlotTime(slot.getDisplayTime());
                    }
                }
                list.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Lấy số ngày nghỉ phép đã được duyệt trong tháng
     */
    public int getApprovedLeaveDaysInMonth(int staffId, int month, int year) {
        int count = 0;
        String sql = """
            SELECT COUNT(*) as leave_count 
            FROM StaffSchedule 
            WHERE staff_id = ? 
            AND MONTH(work_date) = ? 
            AND YEAR(work_date) = ?
            AND slot_id IS NULL 
            AND status = 'approved'
        """;
        
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("leave_count");
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return count;
    }
    
    /**
     * Kiểm tra còn ngày nghỉ phép không
     */
    public boolean canTakeMoreLeave(int staffId, int month, int year) {
        int usedDays = getApprovedLeaveDaysInMonth(staffId, month, year);
        return usedDays < 6; // Maximum 6 days per month
    }
    
    /**
     * Kiểm tra slot đã được đặt chưa
     */
    public boolean isSlotBooked(int staffId, Date workDate, int slotId) {
        String sql = """
            SELECT COUNT(*) as count 
            FROM StaffSchedule 
            WHERE staff_id = ? 
            AND work_date = ? 
            AND slot_id = ?
        """;
        
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            ps.setDate(2, workDate);
            ps.setInt(3, slotId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Thêm yêu cầu lịch mới (cả nghỉ phép và ca làm việc)
     */
    public boolean addScheduleRequest(StaffSchedule schedule) {
        String sql = """
            INSERT INTO StaffSchedule (staff_id, work_date, slot_id, request_type, status, reason, created_at)
            VALUES (?, ?, ?, ?, 'pending', ?, GETDATE())
        """;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, schedule.getStaffId());
            ps.setDate(2, schedule.getWorkDate());
            Integer slotId = schedule.getSlotId();
            if (slotId != null && slotId != 0) {
                ps.setInt(3, slotId);
                ps.setString(4, "work");
            } else {
                ps.setNull(3, Types.INTEGER);
                ps.setString(4, "leave");
            }
            ps.setString(5, schedule.getReason() != null ? schedule.getReason() : "");

            System.out.println("🔍 Executing SQL: " + sql);
            System.out.println("📊 Parameters: staffId=" + schedule.getStaffId() +
                              ", workDate=" + schedule.getWorkDate() +
                              ", slotId=" + slotId +
                              ", requestType=" + (slotId != null && slotId != 0 ? "work" : "leave") +
                              ", reason=" + schedule.getReason());

            int result = ps.executeUpdate();
            System.out.println("✅ SQL executed successfully, rows affected: " + result);
            return result > 0;
        } catch (SQLException e) {
            System.out.println("❌ SQL Error in addScheduleRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật trạng thái yêu cầu (approve/reject)
     */
    public boolean updateRequestStatus(int scheduleId, String status, int approvedBy) {
        String sql = """
            UPDATE StaffSchedule 
            SET status = ?, approved_by = ?, approved_at = GETDATE()
            WHERE schedule_id = ?
        """;
        
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, approvedBy);
            ps.setInt(3, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Lấy yêu cầu theo ID
     */
    public StaffSchedule getScheduleById(long scheduleId) {
        String sql = """
            SELECT ss.*, s.full_name as staff_name, ts.slot_name, s.employment_type,
                   approver.full_name as approver_name
            FROM StaffSchedule ss
            JOIN Staff s ON ss.staff_id = s.staff_id
            LEFT JOIN TimeSlot ts ON ss.slot_id = ts.slot_id
            LEFT JOIN Staff approver ON ss.approved_by = approver.staff_id
            WHERE ss.schedule_id = ?
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, scheduleId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    StaffSchedule schedule = new StaffSchedule();
                    schedule.setScheduleId((int) rs.getLong("schedule_id"));
                    schedule.setStaffId((int) rs.getLong("staff_id"));
                    schedule.setWorkDate(rs.getDate("work_date"));
                    schedule.setSlotId((Integer) rs.getObject("slot_id"));
                    schedule.setStatus(rs.getString("status"));
                    schedule.setApprovedBy((Integer) rs.getObject("approved_by"));
                    schedule.setApprovedAt(rs.getTimestamp("approved_at"));
                    schedule.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Thông tin bổ sung
                    schedule.setStaffName(rs.getString("staff_name"));
                    schedule.setSlotName(rs.getString("slot_name"));
                    schedule.setEmploymentType(rs.getString("employment_type"));
                    schedule.setApproverName(rs.getString("approver_name"));
                    
                    return schedule;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Kiểm tra trùng lặp yêu cầu
     */
    private boolean isDuplicateRequest(StaffSchedule schedule) {
        String sql = """
            SELECT COUNT(*) as count
            FROM StaffSchedule
            WHERE staff_id = ?
            AND work_date = ?
            AND ((slot_id IS NULL AND ? IS NULL) OR slot_id = ?)
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, schedule.getStaffId());
            ps.setDate(2, schedule.getWorkDate());
            ps.setObject(3, schedule.getSlotId());
            ps.setObject(4, schedule.getSlotId());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public void close() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
} 