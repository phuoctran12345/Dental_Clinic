/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ASUS
 */
public class Prescription {
    private int prescriptionId;
    private int reportId;
    private int medicineId;
    private int quantity;
    private String usage;

    public Prescription() {
    }

    public Prescription(int prescriptionId, int reportId, int medicineId, int quantity, String usage) {
        this.prescriptionId = prescriptionId;
        this.reportId = reportId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.usage = usage;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getUsage() {
        return usage;
    }

    public void setUsage(String usage) {
        this.usage = usage;
    }

    @Override
    public String toString() {
        return "Prescription{" + "prescriptionId=" + prescriptionId + ", reportId=" + reportId + ", medicineId=" + medicineId + ", quantity=" + quantity + ", usage=" + usage + '}';
    }

}
