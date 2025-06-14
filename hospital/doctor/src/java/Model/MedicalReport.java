/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author ASUS
 */
public class MedicalReport {
    private int reportId;
    private int appointmentId;
    private int doctorId;
    private int patientId;
    private String diagnosis;
    private String treatmentPlan;
    private String note;
    private Date createdAt;
    private String sign;

    public MedicalReport() {
    }

    public MedicalReport(int reportId, int appointmentId, int doctorId, int patientId, String diagnosis, String treatmentPlan, String note, Date createdAt, String sign) {
        this.reportId = reportId;
        this.appointmentId = appointmentId;
        this.doctorId = doctorId;
        this.patientId = patientId;
        this.diagnosis = diagnosis;
        this.treatmentPlan = treatmentPlan;
        this.note = note;
        this.createdAt = createdAt;
        this.sign = sign;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getTreatmentPlan() {
        return treatmentPlan;
    }

    public void setTreatmentPlan(String treatmentPlan) {
        this.treatmentPlan = treatmentPlan;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    @Override
    public String toString() {
        return "MedicalReport{" + "reportId=" + reportId + ", appointmentId=" + appointmentId + ", doctorId=" + doctorId + ", patientId=" + patientId + ", diagnosis=" + diagnosis + ", treatmentPlan=" + treatmentPlan + ", note=" + note + ", createdAt=" + createdAt + ", sign=" + sign + '}';
    }
    
}
