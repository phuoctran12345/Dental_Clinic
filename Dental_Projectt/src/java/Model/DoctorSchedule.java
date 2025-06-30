package Model;

import java.time.LocalDate;
import java.util.Date;

public class DoctorSchedule {
    private int scheduleId;
    private int doctorId;
    private Date workDate;
    private int slotId;
    
    // Thuộc tính để join với các bảng khác
    private Doctors doctor;
    private TimeSlot timeSlot;

    // Constructor mặc định
    public DoctorSchedule() {}

    // Constructor cơ bản
    public DoctorSchedule(int scheduleId, int doctorId, Date workDate, int slotId) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
    }

    // Constructor với join data
    public DoctorSchedule(int scheduleId, int doctorId, Date workDate, 
                         int slotId, Doctors doctor, TimeSlot timeSlot) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.doctor = doctor;
        this.timeSlot = timeSlot;
    }

    // Getters và Setters
    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public Doctors getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctors doctor) {
        this.doctor = doctor;
    }

    public TimeSlot getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(TimeSlot timeSlot) {
        this.timeSlot = timeSlot;
    }

    @Override
    public String toString() {
        return "DoctorSchedule{" +
                "scheduleId=" + scheduleId +
                ", doctorId=" + doctorId +
                ", workDate=" + workDate +
                ", slotId=" + slotId +
                '}';
    }
} 