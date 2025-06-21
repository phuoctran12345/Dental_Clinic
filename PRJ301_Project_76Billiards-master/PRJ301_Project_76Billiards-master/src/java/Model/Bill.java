/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;


public class Bill {

   private int billID;
    private int customerID;
    private String startTime;
    private String date;
    private String statusBill;
    private String receiptImage;
    private BigDecimal totalBill;

    public Bill() {
    }

    public Bill(int billID, int customerID, String startTime, String date, String statusBill, String receiptImage, BigDecimal totalBill) {
        this.billID = billID;
        this.customerID = customerID;
        this.startTime = startTime;
        this.date = date;
        this.statusBill = statusBill;
        this.receiptImage = receiptImage;
        this.totalBill = totalBill;
    }

    public int getBillID() {
        return billID;
    }

    public void setBillID(int billID) {
        this.billID = billID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStatusBill() {
        return statusBill;
    }

    public void setStatusBill(String statusBill) {
        this.statusBill = statusBill;
    }

    public String getReceiptImage() {
        return receiptImage;
    }

    public void setReceiptImage(String receiptImage) {
        this.receiptImage = receiptImage;
    }

    public BigDecimal getTotalBill() {
        return totalBill;
    }

    public void setTotalBill(BigDecimal totalBill) {
        this.totalBill = totalBill;
    }

    @Override
    public String toString() {
        return "Bill{" + "billID=" + billID + ", customerID=" + customerID + ", startTime=" + startTime + ", date=" + date + ", statusBill=" + statusBill + ", receiptImage=" + receiptImage + ", totalBill=" + totalBill + '}';
    }
    
    
    
}
