package model;

import utils.FormatUtils;

public class PaymentInfo {
    private String orderId;
    private String billId;
    private Double amount;
    private String description;
    private String status;
    
    public PaymentInfo() {}
    
    public PaymentInfo(String orderId, String billId, Double amount, String description) {
        this.orderId = orderId;
        this.billId = billId;
        this.amount = amount;
        this.description = description;
        this.status = "PENDING";
    }
    
    // Getters and Setters
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    
    public String getBillId() { return billId; }
    public void setBillId(String billId) { this.billId = billId; }
    
    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    // Safe format methods
    public String getFormattedAmount() {
        return FormatUtils.formatAmountWithCurrency(amount);
    }
    
    public String getAmountString() {
        return FormatUtils.formatAmount(amount);
    }
    
    public Double getAmountValue() {
        return amount != null ? amount : 0.0;
    }
    
    // JavaScript safe amount (không có dấu phẩy)
    public String getJsAmount() {
        return String.valueOf(getAmountValue());
    }
} 