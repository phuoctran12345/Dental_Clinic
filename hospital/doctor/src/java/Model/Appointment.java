/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;
import java.sql.Time;

/**
 *
 * @author ASUS
 */
public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private Date workDate;
    private int slotId;
    private String status;
    private String reason;
    private int previousAppointmentId;
    
    // Thêm các thuộc tính để hiển thị thông tin bệnh nhân và thời gian
    private String patientName;
    private String patientPhone;
    private Date patientDateOfBirth;
    private String patientGender;
    private Time startTime;
    private Time endTime;

    public Appointment() {
    }

    public Appointment(int appointmentId, int patientId, int doctorId, Date workDate, int slotId, String status, String reason, int previousAppointmentId) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.status = status;
        this.reason = reason;
        this.previousAppointmentId = previousAppointmentId;
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

    public int getPreviousAppointmentId() {
        return previousAppointmentId;
    }

    public void setPreviousAppointmentId(int previousAppointmentId) {
        this.previousAppointmentId = previousAppointmentId;
    }

    // Getter và Setter cho các thuộc tính mới
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

    @Override
    public String toString() {
        return "Appointment{" + "appointmentId=" + appointmentId + ", patientId=" + patientId + ", doctorId=" + doctorId + ", workDate=" + workDate + ", slotId=" + slotId + ", status=" + status + ", reason=" + reason + ", previousAppointmentId=" + previousAppointmentId + ", patientName=" + patientName + '}';
    }
    
}
