
package Model;

import java.time.LocalTime;


public class TimeSlot {
    private int slotId;
    private java.time.LocalTime startTime;
    private java.time.LocalTime endTime;

    public TimeSlot() {
    }

    public TimeSlot(int slotId, LocalTime startTime, LocalTime endTime) {
        this.slotId = slotId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
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

    @Override
    public String toString() {
        return "TimeSlot{" + "slotId=" + slotId + ", startTime=" + startTime + ", endTime=" + endTime + '}';
    }
    
}
