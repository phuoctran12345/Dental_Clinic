package Model;

import java.time.LocalTime;

public class TimeSlot {
    private int slotId;
    private LocalTime startTime;
    private LocalTime endTime;

    // Constructor mặc định
    public TimeSlot() {}

    // Constructor đầy đủ
    public TimeSlot(int slotId, LocalTime startTime, LocalTime endTime) {
        this.slotId = slotId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getters và Setters
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

    // Phương thức tiện ích để hiển thị khung giờ
    public String getTimeRange() {
        return startTime + " - " + endTime;
    }

    @Override
    public String toString() {
        return "TimeSlot{" +
                "slotId=" + slotId +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                '}';
    }
} 