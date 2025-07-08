/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Home
 */
public class TimeSlot {
    private int slotId;
    private LocalTime startTime;
    private LocalTime endTime;
    private String slotName; //  tên ca làm việc 
    private boolean isBooked; // Thêm field để kiểm tra slot đã đặt chưa // xử lý để đặt lịch cho nguời thân 
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    public TimeSlot() {
        this.isBooked = false; // Mặc định chưa đặt
    }

    public TimeSlot(int slotId, LocalTime startTime, LocalTime endTime) {
        this.slotId = slotId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isBooked = false;
        this.slotName = String.format("Ca %d (%s)", slotId, getFormattedTime());
    }

    public TimeSlot(int slotId, LocalTime startTime, LocalTime endTime, boolean isBooked) {
        this.slotId = slotId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isBooked = isBooked;
        this.slotName = String.format("Ca %d (%s)", slotId, getFormattedTime());
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

    public String getSlotName() {
        if (slotName == null) {
            slotName = String.format("Ca %d (%s)", slotId, getFormattedTime());
        }
        return slotName;
    }

    public void setSlotName(String slotName) {
        this.slotName = slotName;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public void setBooked(boolean booked) {
        isBooked = booked;
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
     * Kiểm tra xem một thời điểm có nằm trong khoảng thời gian này không
     */
    public boolean isTimeInSlot(LocalTime time) {
        if (startTime != null && endTime != null && time != null) {
            return !time.isBefore(startTime) && !time.isAfter(endTime);
        }
        return false;
    }

    /**
     * Kiểm tra xem khoảng thời gian này có trùng với khoảng thời gian khác không
     */
    public boolean overlapsWith(TimeSlot other) {
        if (startTime == null || endTime == null || 
            other.startTime == null || other.endTime == null) {
            return false;
        }
        return !startTime.isAfter(other.endTime) && !endTime.isBefore(other.startTime);
    }

    public String getDisplayTime() {
        return startTime.format(DateTimeFormatter.ofPattern("HH:mm")) + 
               " - " + 
               endTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    @Override
    public String toString() {
        return "TimeSlot{" + 
               "slotId=" + slotId + 
               ", startTime=" + (startTime != null ? startTime.format(TIME_FORMATTER) : "null") + 
               ", endTime=" + (endTime != null ? endTime.format(TIME_FORMATTER) : "null") + 
               ", isBooked=" + isBooked +
               '}';
    }
}
