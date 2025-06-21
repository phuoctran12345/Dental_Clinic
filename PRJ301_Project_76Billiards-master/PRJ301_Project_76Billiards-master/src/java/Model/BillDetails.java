/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;



public class BillDetails {

    private int billDetailID;
    private int billID;
    private int tableID;
    private int selected;
    private double price;
    private double total;

    public BillDetails(int billDetailID, int billID, int tableID, int selected, double price, double total) {
        this.billDetailID = billDetailID;
        this.billID = billID;
        this.tableID = tableID;
        this.selected = selected;
        this.price = price;
        this.total = total;
    }

    public int getBillDetailID() {
        return billDetailID;
    }

    public void setBillDetailID(int billDetailID) {
        this.billDetailID = billDetailID;
    }

    public int getBillID() {
        return billID;
    }

    public void setBillID(int billID) {
        this.billID = billID;
    }

    public int getTableID() {
        return tableID;
    }

    public void setTableID(int tableID) {
        this.tableID = tableID;
    }

    public int getSelected() {
        return selected;
    }

    public void setSelected(int selected) {
        this.selected = selected;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "BillDetails{" + "billDetailID=" + billDetailID + ", billID=" + billID + ", tableID=" + tableID + ", selected=" + selected + ", price=" + price + ", total=" + total + '}';
    }

    

}