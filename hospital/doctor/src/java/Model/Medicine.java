/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ASUS
 */
public class Medicine {
    private int medicineId;
    private String name;
    private String unit;
    private int quantityInStock;
    private String description;

    public Medicine() {
    }

    public Medicine(int medicineId, String name, String unit, int quantityInStock, String description) {
        this.medicineId = medicineId;
        this.name = name;
        this.unit = unit;
        this.quantityInStock = quantityInStock;
        this.description = description;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(int quantityInStock) {
        this.quantityInStock = quantityInStock;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Medicine{" + "medicineId=" + medicineId + ", name=" + name + ", unit=" + unit + ", quantityInStock=" + quantityInStock + ", description=" + description + '}';
    }

}
