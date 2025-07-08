package model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model class for Staff Schedule - Quản lý lịch làm việc và nghỉ phép của nhân viên
 * @author TranHongPhuoc
 */
public class StaffSchedule {
    private int scheduleId;
    private int staffId;
    private Date workDate;
    private Integer slotId;
    private String status;
    private Integer approvedBy;
    private Timestamp approvedAt;
    private Timestamp createdAt;
    private String reason;
    
    // Additional fields from JOIN
    private String staffName;
    private String slotName;
    private String employmentType;
    private String approverName;
    
    // Thời gian ca làm việc (ví dụ: 08:00 - 12:00), dùng cho hiển thị
    private String slotTime;
    
    // Constants for status
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_APPROVED = "approved";
    public static final String STATUS_REJECTED = "rejected";
    
    // Constants for employment types
    public static final String EMPLOYMENT_FULLTIME = "fulltime";
    public static final String EMPLOYMENT_PARTTIME = "parttime";
    
    // Business constants
    public static final int MAX_LEAVE_DAYS_PER_MONTH = 6;
    
    // Constructors
    public StaffSchedule() {
        this.status = STATUS_PENDING;
    }

    public StaffSchedule(int staffId, Date workDate) {
        this();
        this.staffId = staffId;
        this.workDate = workDate;
    }

    // Getters và Setters
    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public Integer getSlotId() {
        return slotId;
    }

    public void setSlotId(Integer slotId) {
        this.slotId = slotId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status != null) {
            status = status.toLowerCase();
            if (!status.equals("pending") && !status.equals("approved") && !status.equals("rejected")) {
                throw new IllegalArgumentException("Status must be 'pending', 'approved' or 'rejected'");
            }
        }
        this.status = status;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    // Getters/Setters cho thông tin bổ sung
    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getSlotName() {
        return slotName;
    }

    public void setSlotName(String slotName) {
        this.slotName = slotName;
    }

    public String getEmploymentType() {
        return employmentType;
    }

    public void setEmploymentType(String employmentType) {
        this.employmentType = employmentType;
    }

    public String getApproverName() {
        return approverName;
    }

    public void setApproverName(String approverName) {
        this.approverName = approverName;
    }

    // Thời gian ca làm việc (ví dụ: 08:00 - 12:00), dùng cho hiển thị
    public String getSlotTime() {
        return slotTime;
    }

    public void setSlotTime(String slotTime) {
        this.slotTime = slotTime;
    }

    // Phương thức kiểm tra hợp lệ
    public boolean isValid() {
        // Kiểm tra staffId
        if (staffId <= 0) {
            return false;
        }
        
        // Kiểm tra workDate
        if (workDate == null) {
            return false;
        }
        
        return true;
    }

    // Phương thức kiểm tra có phải nghỉ phép không (dựa vào slotId null)
    public boolean isLeaveRequest() {
        return slotId == null;
    }

    // Phương thức kiểm tra có phải đăng ký làm việc không
    public boolean isWorkRequest() {
        return slotId != null;
    }

    // Phương thức kiểm tra đã được phê duyệt chưa
    public boolean isApproved() {
        return "approved".equals(status);
    }

    // Phương thức kiểm tra bị từ chối
    public boolean isRejected() {
        return "rejected".equals(status);
    }

    // Phương thức kiểm tra đang chờ phê duyệt
    public boolean isPending() {
        return "pending".equals(status);
    }

    /**
     * Lấy tên hiển thị cho loại yêu cầu
     */
    public String getRequestTypeDisplayName() {
        if (isWorkRequest()) {
            return "Đăng ký ca";
        } else {
            return "Nghỉ phép";
        }
    }
    
    /**
     * Lấy tên hiển thị cho trạng thái
     */
    public String getStatusDisplayName() {
        switch (status) {
            case STATUS_PENDING:
                return "Chờ phê duyệt";
            case STATUS_APPROVED:
                return "Đã phê duyệt";
            case STATUS_REJECTED:
                return "Đã từ chối";
            default:
                return status;
        }
    }
    
    /**
     * Lấy CSS class cho trạng thái (để styling)
     */
    public String getStatusCssClass() {
        switch (status) {
            case STATUS_PENDING:
                return "badge-warning";
            case STATUS_APPROVED:
                return "badge-success";
            case STATUS_REJECTED:
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }
    
    /**
     * Lấy CSS class cho loại yêu cầu (để styling)
     */
    public String getRequestTypeCssClass() {
        if (isWorkRequest()) {
            return "badge-info";
        } else {
            return "badge-warning";
        }
    }

    @Override
    public String toString() {
        return "StaffSchedule{" +
                "scheduleId=" + scheduleId +
                ", staffId=" + staffId +
                ", workDate=" + workDate +
                ", slotId=" + slotId +
                ", status='" + status + '\'' +
                ", approvedBy=" + approvedBy +
                ", approvedAt=" + approvedAt +
                ", staffName='" + staffName + '\'' +
                ", slotName='" + slotName + '\'' +
                ", employmentType='" + employmentType + '\'' +
                '}';
    }
} 