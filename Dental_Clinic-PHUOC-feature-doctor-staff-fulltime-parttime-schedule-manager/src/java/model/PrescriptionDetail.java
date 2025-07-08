package model;

/**
 *
 * @author ASUS
 */
public class PrescriptionDetail {
    private int prescriptionId;
    private int medicineId;
    private String medicineName;
    private int quantity;
    private String usage;
    private String unit;

    public PrescriptionDetail() {
    }

    public PrescriptionDetail(int prescriptionId, int medicineId, String medicineName, int quantity, String usage, String unit) {
        this.prescriptionId = prescriptionId;
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.quantity = quantity;
        this.usage = usage;
        this.unit = unit;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
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

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    @Override
    public String toString() {
        return "PrescriptionDetail{" + 
               "prescriptionId=" + prescriptionId + 
               ", medicineId=" + medicineId + 
               ", medicineName=" + medicineName + 
               ", quantity=" + quantity + 
               ", usage=" + usage + 
               ", unit=" + unit + '}';
    }
}