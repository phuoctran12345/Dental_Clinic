/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDate;

/**
 *
 * @author Home
 */
public class DoctorSchedule {

    private int scheduleId;
    private long doctorId;
    private java.time.LocalDate workDate;
    private int slotId;
    private TimeSlot timeSlot;  // để chứa dữ liệu thời gian khi JOIN (có thể không dùng khi insert)

    public DoctorSchedule() {
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

    public TimeSlot getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(TimeSlot timeSlot) {
        this.timeSlot = timeSlot;
    }

    public DoctorSchedule(int scheduleId, long doctorId, LocalDate workDate, int slotId, TimeSlot timeSlot) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.timeSlot = timeSlot;
    }

    @Override
    public String toString() {
        return "DoctorSchedule{" + "scheduleId=" + scheduleId + ", doctorId=" + doctorId + ", workDate=" + workDate + ", slotId=" + slotId + ", timeSlot=" + timeSlot + '}';
    }

   
}
