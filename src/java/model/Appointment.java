package model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Appointment {
    private int appointmentId;
    private int patientId;
    private long doctorId;  // ✅ Đổi thành long để khớp với BIGINT
    private LocalDate workDate;
    private int slotId;
    private String status;
    private String reason;
    private String doctorName;
    private String doctorSpecialty;  // ✅ Thêm doctor specialty
    private int previousAppointmentId;  // ✅ Thêm field mới
    private Integer bookedByUserId; // Ai là người thân đặt lịch
    
    private String patientName;
    private String patientPhone;
    private String patientEmail; // 🆕 Thêm email bệnh nhân
    private Date patientDateOfBirth;
    private String patientGender;
    private String serviceName;
    private LocalTime startTime;
    private LocalTime endTime;
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private int serviceId;
    private java.sql.Date appointmentDate;
    private String timeSlot;
    private String note;
    private Integer relativeId; // Người thân
    private String doctorEmail; // 🆕 Thêm email bác sĩ
    

    public Appointment() {
    }

     public Appointment(int appointmentId, int patientId, long doctorId, LocalDate workDate, int slotId, String status, String reason, String doctorName, String doctorSpecialty, int previousAppointmentId,Integer bookedByUserId ,String patientName, String patientPhone, Date patientDateOfBirth, String patientGender, String serviceName, LocalTime startTime, LocalTime endTime, int serviceId, java.sql.Date appointmentDate, String timeSlot, String note) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.status = status;
        this.reason = reason;
        this.doctorName = doctorName;
        this.doctorSpecialty = doctorSpecialty;
        this.previousAppointmentId = previousAppointmentId;
        this.bookedByUserId = bookedByUserId;
        this.patientName = patientName;
        this.patientPhone = patientPhone;
        this.patientDateOfBirth = patientDateOfBirth;
        this.patientGender = patientGender;
        this.serviceName = serviceName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.serviceId = serviceId;
        this.appointmentDate = appointmentDate;
        this.timeSlot = timeSlot;
        this.note = note;
    }

    public Date getPatientDateOfBirth() {
        return patientDateOfBirth;
    }

    public void setPatientDateOfBirth(Date patientDateOfBirth) {
        this.patientDateOfBirth = patientDateOfBirth;
    }

    public String getPatientGender() {
        return patientGender;
    }

    public void setPatientGender(String patientGender) {
        this.patientGender = patientGender;
    }
     
     

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    public String getDoctorSpecialty() {
        return doctorSpecialty;
    }

    public void setDoctorSpecialty(String doctorSpecialty) {
        this.doctorSpecialty = doctorSpecialty;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public long getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(long doctorId) {
        this.doctorId = doctorId;
    }
    
    // ✅ Thêm getter/setter cho previousAppointmentId
    public int getPreviousAppointmentId() {
        return previousAppointmentId;
    }

    public void setPreviousAppointmentId(int previousAppointmentId) {
        this.previousAppointmentId = previousAppointmentId;
    }

    public LocalDate getWorkDate() {
        return workDate;
    }

    public void setWorkDate(java.sql.Date workDate) {
        if (workDate != null) {
            this.workDate = workDate.toLocalDate();
        }
    }

    public void setWorkDate(LocalDate workDate) {
        this.workDate = workDate;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientPhone() {
        return patientPhone;
    }

    public void setPatientPhone(String patientPhone) {
        this.patientPhone = patientPhone;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    
    

    public static DateTimeFormatter getTIME_FORMATTER() {
        return TIME_FORMATTER;
    }
    
    

    /**
     * Lấy thời gian dạng chuỗi đẹp (ví dụ: "08:00 - 09:00")
     */
    public String getFormattedTime() {
        if (startTime != null && endTime != null) {
            return String.format("%s - %s", 
                startTime.format(TIME_FORMATTER),
                endTime.format(TIME_FORMATTER));
        }
        return "";
    }

    /**
     * Lấy ngày làm việc dạng chuỗi đẹp (ví dụ: "01/01/2024")
     */
    public String getFormattedDate() {
        if (workDate != null) {
            return workDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }

    /**
     * Kiểm tra xem lịch hẹn có phải là trong tương lai không
     */
    public boolean isUpcoming() {
        if (workDate == null) {
            return false;
        }
        LocalDate today = LocalDate.now();
        return workDate.isAfter(today) || workDate.isEqual(today);
    }

    @Override
    public String toString() {
        return "Appointment{" + 
               "appointmentId=" + appointmentId + 
               ", patientId=" + patientId + 
               ", doctorId=" + doctorId + 
               ", workDate=" + workDate + 
               ", slotId=" + slotId + 
               ", status=" + status + 
               ", reason=" + reason + 
               ", doctorName=" + doctorName + 
               ", startTime=" + (startTime != null ? startTime.format(TIME_FORMATTER) : "null") + 
               ", endTime=" + (endTime != null ? endTime.format(TIME_FORMATTER) : "null") + 
               '}';
    }

    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public int getServiceId() { return serviceId; }

    public void setAppointmentDate(java.sql.Date appointmentDate) { this.appointmentDate = appointmentDate; }
    public java.sql.Date getAppointmentDate() { return appointmentDate; }

    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
    public String getTimeSlot() { return timeSlot; }

    public void setNote(String note) { this.note = note; }
    public String getNote() { return note; }

    public void setCreatedBy(int createdBy) {
        // Có thể thêm field createdBy nếu cần
        // this.createdBy = createdBy;
    }

    public void setCreatedAt(java.util.Date createdAt) {
        // Có thể thêm field createdAt nếu cần
        // this.createdAt = createdAt;
    }

    // Getter cho JSTL compatibility
    public java.sql.Date getWorkDateAsSqlDate() {
        return workDate != null ? java.sql.Date.valueOf(workDate) : null;
    }

    // Safe format methods để tránh NullPointerException
    public String getFormattedStartTime() {
        return utils.FormatUtils.formatTime(startTime);
    }
    
    public String getFormattedEndTime() {
        return utils.FormatUtils.formatTime(endTime);
    }
    
    public String getFormattedTimeRange() {
        return utils.FormatUtils.formatTimeRange(startTime, endTime);
    }
    
    public String getFormattedWorkDate() {
        return utils.FormatUtils.formatDate(workDate);
    }

    public Integer getRelativeId() {
        return relativeId;
    }
    public void setRelativeId(Integer relativeId) {
        this.relativeId = relativeId;
    }
    public Integer getBookedByUserId() {
        return bookedByUserId;
    }
    public void setBookedByUserId(Integer bookedByUserId) {
        this.bookedByUserId = bookedByUserId;
    }

    // 🆕 Getter/Setter cho patientEmail
    public String getPatientEmail() {
        return patientEmail;
    }

    public void setPatientEmail(String patientEmail) {
        this.patientEmail = patientEmail;
    }

    // 🆕 Getter/Setter cho doctorEmail
    public String getDoctorEmail() {
        return doctorEmail;
    }

    public void setDoctorEmail(String doctorEmail) {
        this.doctorEmail = doctorEmail;
    }
}
