
package Model;

import java.time.LocalDate;


public class DoctorSchedule {
    private int scheduleId;
    private long doctorId;
    private java.time.LocalDate workDate;
    private int slotId;

    public DoctorSchedule() {
    }

    public DoctorSchedule(int scheduleId, long doctorId, LocalDate workDate, int slotId) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
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

    @Override
    public String toString() {
        return "DoctorSchedule{" + "scheduleId=" + scheduleId + ", doctorId=" + doctorId + ", workDate=" + workDate + ", slotId=" + slotId + '}';
    }
    
}
