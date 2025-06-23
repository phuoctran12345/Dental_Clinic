package model;

import java.sql.Date;

public class PaymentInstallment {
    private int installmentId;
    private String billId;
    
    // Thông tin kế hoạch trả góp
    private double totalAmount;
    private double downPayment;
    private int installmentCount;
    private double interestRate;
    
    // Thông tin kỳ thanh toán hiện tại
    private int installmentNumber;
    private Date dueDate;
    private double amountDue;
    private double amountPaid;
    private double remainingAmount;
    private Date paymentDate;
    
    // Trạng thái
    private String status; // PENDING, PAID, PARTIAL, OVERDUE, COMPLETED
    
    // Thông tin thanh toán
    private String paymentMethod;
    private String transactionId;
    private double lateFee;
    
    // Thông tin nhắc nợ
    private Date lastReminderDate;
    private int reminderCount;
    private Date nextReminderDate;
    
    // Audit
    private Date createdAt;
    private Date updatedAt;
    private String notes;
    
    // Thông tin khách hàng (cho reminders)
    private String customerName;
    private String customerPhone;
    private int daysUntilDue;
    private String reminderType;
    
    // Thông tin tóm tắt (cho summary view)
    private int paidInstallments;
    private int overdueInstallments;
    private int pendingInstallments;
    private double totalPaid;
    private double totalRemaining;
    private double totalLateFees;
    private Date nextDueDate;
    private String planStatus;
    
    // Constructors
    public PaymentInstallment() {}
    
    public PaymentInstallment(String billId, double totalAmount, double downPayment, int installmentCount) {
        this.billId = billId;
        this.totalAmount = totalAmount;
        this.downPayment = downPayment;
        this.installmentCount = installmentCount;
        this.status = "PENDING";
    }
    
    // Getters and Setters
    public int getInstallmentId() { return installmentId; }
    public void setInstallmentId(int installmentId) { this.installmentId = installmentId; }
    
    public String getBillId() { return billId; }
    public void setBillId(String billId) { this.billId = billId; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public double getDownPayment() { return downPayment; }
    public void setDownPayment(double downPayment) { this.downPayment = downPayment; }
    
    public int getInstallmentCount() { return installmentCount; }
    public void setInstallmentCount(int installmentCount) { this.installmentCount = installmentCount; }
    
    public double getInterestRate() { return interestRate; }
    public void setInterestRate(double interestRate) { this.interestRate = interestRate; }
    
    public int getInstallmentNumber() { return installmentNumber; }
    public void setInstallmentNumber(int installmentNumber) { this.installmentNumber = installmentNumber; }
    
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    
    public double getAmountDue() { return amountDue; }
    public void setAmountDue(double amountDue) { this.amountDue = amountDue; }
    
    public double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(double amountPaid) { this.amountPaid = amountPaid; }
    
    public double getRemainingAmount() { return remainingAmount; }
    public void setRemainingAmount(double remainingAmount) { this.remainingAmount = remainingAmount; }
    
    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
    
    public double getLateFee() { return lateFee; }
    public void setLateFee(double lateFee) { this.lateFee = lateFee; }
    
    public Date getLastReminderDate() { return lastReminderDate; }
    public void setLastReminderDate(Date lastReminderDate) { this.lastReminderDate = lastReminderDate; }
    
    public int getReminderCount() { return reminderCount; }
    public void setReminderCount(int reminderCount) { this.reminderCount = reminderCount; }
    
    public Date getNextReminderDate() { return nextReminderDate; }
    public void setNextReminderDate(Date nextReminderDate) { this.nextReminderDate = nextReminderDate; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    // Customer info for reminders
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    
    public int getDaysUntilDue() { return daysUntilDue; }
    public void setDaysUntilDue(int daysUntilDue) { this.daysUntilDue = daysUntilDue; }
    
    public String getReminderType() { return reminderType; }
    public void setReminderType(String reminderType) { this.reminderType = reminderType; }
    
    // Summary info
    public int getPaidInstallments() { return paidInstallments; }
    public void setPaidInstallments(int paidInstallments) { this.paidInstallments = paidInstallments; }
    
    public int getOverdueInstallments() { return overdueInstallments; }
    public void setOverdueInstallments(int overdueInstallments) { this.overdueInstallments = overdueInstallments; }
    
    public int getPendingInstallments() { return pendingInstallments; }
    public void setPendingInstallments(int pendingInstallments) { this.pendingInstallments = pendingInstallments; }
    
    public double getTotalPaid() { return totalPaid; }
    public void setTotalPaid(double totalPaid) { this.totalPaid = totalPaid; }
    
    public double getTotalRemaining() { return totalRemaining; }
    public void setTotalRemaining(double totalRemaining) { this.totalRemaining = totalRemaining; }
    
    public double getTotalLateFees() { return totalLateFees; }
    public void setTotalLateFees(double totalLateFees) { this.totalLateFees = totalLateFees; }
    
    public Date getNextDueDate() { return nextDueDate; }
    public void setNextDueDate(Date nextDueDate) { this.nextDueDate = nextDueDate; }
    
    public String getPlanStatus() { return planStatus; }
    public void setPlanStatus(String planStatus) { this.planStatus = planStatus; }
    
    // Utility methods
    public boolean isPaid() {
        return "PAID".equals(status);
    }
    
    public boolean isOverdue() {
        return "OVERDUE".equals(status);
    }
    
    public boolean isPartial() {
        return "PARTIAL".equals(status);
    }
    
    public boolean isPending() {
        return "PENDING".equals(status);
    }
    
    public double getProgressPercentage() {
        if (amountDue == 0) return 0;
        return (amountPaid / amountDue) * 100;
    }
    
    public String getStatusDisplayName() {
        switch (status) {
            case "PENDING": return "Chờ thanh toán";
            case "PAID": return "Đã thanh toán";
            case "PARTIAL": return "Thanh toán một phần";
            case "OVERDUE": return "Quá hạn";
            case "COMPLETED": return "Hoàn thành";
            default: return status;
        }
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case "PAID": return "success";
            case "PENDING": return "warning";
            case "PARTIAL": return "info";
            case "OVERDUE": return "danger";
            case "COMPLETED": return "primary";
            default: return "secondary";
        }
    }
    
    @Override
    public String toString() {
        return "PaymentInstallment{" +
                "installmentId=" + installmentId +
                ", billId='" + billId + '\'' +
                ", installmentNumber=" + installmentNumber +
                ", amountDue=" + amountDue +
                ", amountPaid=" + amountPaid +
                ", status='" + status + '\'' +
                ", dueDate=" + dueDate +
                '}';
    }
} 