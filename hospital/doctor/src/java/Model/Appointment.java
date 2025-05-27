
package Model;

import java.time.LocalDate;


public class Appointment {
    private int appointmentId;
    private int patientId;
    private long doctorId;
    private java.time.LocalDate workDate;
    private int slotId;
    private String status;
    private String reason;

    public Appointment() {
    }

    public Appointment(int appointmentId, int patientId, long doctorId, LocalDate workDate, int slotId, String status, String reason) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.status = status;
        this.reason = reason;
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

    @Override
    public String toString() {
        return "Appointment{" + "appointmentId=" + appointmentId + ", patientId=" + patientId + ", doctorId=" + doctorId + ", workDate=" + workDate + ", slotId=" + slotId + ", status=" + status + ", reason=" + reason + '}';
    }
    
}
