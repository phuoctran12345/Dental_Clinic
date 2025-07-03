package model;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

public class DoctorSchedule {
    private int scheduleId;
    private long doctorId;
    private Date workDate;
    private Integer slotId; // Dùng object Integer thay vì int bởi vì int k thể nhận giá trị null còn Integer thì có thể thì có 
    private Time startTime;
    private Time endTime;
    private String status;
    private TimeSlot timeSlot;

    public DoctorSchedule() {
    }

    public DoctorSchedule(int scheduleId, long doctorId, Date workDate, Integer slotId, String status) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.status = status;
    }

    public DoctorSchedule(int scheduleId, long doctorId, Date workDate, Integer slotId, Time startTime, Time endTime, String status) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public long getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(long doctorId) {
        this.doctorId = doctorId;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public void setWorkDate(LocalDate localDate) {
        if (localDate != null) {
            this.workDate = Date.valueOf(localDate);
        }
    }

    public Integer getSlotId() {
        return slotId;
    }

    public void setSlotId(Integer slotId) {
        this.slotId = slotId;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public TimeSlot getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(TimeSlot timeSlot) {
        this.timeSlot = timeSlot;
    }

    private Doctors doctor;
    
    public void setDoctor(Doctors doctor) {
        this.doctor = doctor;
    }
    
    public Doctors getDoctor() {
        return doctor;
    }
} 