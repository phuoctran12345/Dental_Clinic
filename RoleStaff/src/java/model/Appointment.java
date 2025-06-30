package model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Appointment {
    private int appointmentId;
    private int patientId;
    private long doctorId;
    private LocalDate workDate;
    private int slotId;
    private String status;
    private String reason;
    private String doctorName;
    private LocalTime startTime;
    private LocalTime endTime;
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    public Appointment() {
    }

    public Appointment(int appointmentId, int patientId, long doctorId, LocalDate workDate, 
            int slotId, String status, String reason, String doctorName, 
            LocalTime startTime, LocalTime endTime) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.status = status;
        this.reason = reason;
        this.doctorName = doctorName;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
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

    public LocalDate getWorkDate() {
        return workDate;
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
}
