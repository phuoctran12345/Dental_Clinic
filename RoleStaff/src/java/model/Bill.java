package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Bill model class - Hóa đơn thanh toán
 */
public class Bill {
    
    // Primary Information
    private String billId;
    private String orderId;
    private int serviceId;
    private Integer patientId;
    private Integer userId;
    
    // Payment Information
    private BigDecimal amount;
    private BigDecimal originalPrice;
    private BigDecimal discountAmount;
    private BigDecimal taxAmount;
    private String paymentMethod;
    private String paymentStatus;
    
    // Customer Information
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    
    // Appointment Information
    private Integer doctorId;
    private Date appointmentDate;
    private Time appointmentTime;
    private String appointmentNotes;
    
    // PayOS Information
    private String payosOrderId;
    private String payosTransactionId;
    private String payosSignature;
    private String paymentGatewayResponse;
    private String transactionId;
    
    // Audit Information
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp paidAt;
    private Timestamp cancelledAt;
    private Timestamp refundedAt;
    
    // Additional Information
    private String notes;
    private String internalNotes;
    private boolean isDeleted;
    
    // Service Information (from join)
    private String serviceName;
    private String serviceDescription;
    
    // Default constructor
    public Bill() {
        this.paymentMethod = "PayOS";
        this.paymentStatus = "pending";
        this.isDeleted = false;
        this.discountAmount = BigDecimal.ZERO;
        this.taxAmount = BigDecimal.ZERO;
    }
    
    // Constructor with basic info
    public Bill(String billId, String orderId, int serviceId, String customerName, 
               String customerPhone, BigDecimal amount) {
        this();
        this.billId = billId;
        this.orderId = orderId;
        this.serviceId = serviceId;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.amount = amount;
        this.originalPrice = amount;
    }
    
    // Getters and Setters
    public String getBillId() {
        return billId;
    }
    
    public void setBillId(String billId) {
        this.billId = billId;
    }
    
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public int getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
    
    public Integer getPatientId() {
        return patientId;
    }
    
    public void setPatientId(Integer patientId) {
        this.patientId = patientId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }
    
    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public BigDecimal getTaxAmount() {
        return taxAmount;
    }
    
    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public String getCustomerEmail() {
        return customerEmail;
    }
    
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    
    public Integer getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(Integer doctorId) {
        this.doctorId = doctorId;
    }
    
    public Date getAppointmentDate() {
        return appointmentDate;
    }
    
    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    
    public Time getAppointmentTime() {
        return appointmentTime;
    }
    
    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }
    
    public String getAppointmentNotes() {
        return appointmentNotes;
    }
    
    public void setAppointmentNotes(String appointmentNotes) {
        this.appointmentNotes = appointmentNotes;
    }
    
    public String getPayosOrderId() {
        return payosOrderId;
    }
    
    public void setPayosOrderId(String payosOrderId) {
        this.payosOrderId = payosOrderId;
    }
    
    public String getPayosTransactionId() {
        return payosTransactionId;
    }
    
    public void setPayosTransactionId(String payosTransactionId) {
        this.payosTransactionId = payosTransactionId;
    }
    
    public String getPayosSignature() {
        return payosSignature;
    }
    
    public void setPayosSignature(String payosSignature) {
        this.payosSignature = payosSignature;
    }
    
    public String getPaymentGatewayResponse() {
        return paymentGatewayResponse;
    }
    
    public void setPaymentGatewayResponse(String paymentGatewayResponse) {
        this.paymentGatewayResponse = paymentGatewayResponse;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Timestamp getPaidAt() {
        return paidAt;
    }
    
    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }
    
    public Timestamp getCancelledAt() {
        return cancelledAt;
    }
    
    public void setCancelledAt(Timestamp cancelledAt) {
        this.cancelledAt = cancelledAt;
    }
    
    public Timestamp getRefundedAt() {
        return refundedAt;
    }
    
    public void setRefundedAt(Timestamp refundedAt) {
        this.refundedAt = refundedAt;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getInternalNotes() {
        return internalNotes;
    }
    
    public void setInternalNotes(String internalNotes) {
        this.internalNotes = internalNotes;
    }
    
    public boolean isDeleted() {
        return isDeleted;
    }
    
    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public String getServiceDescription() {
        return serviceDescription;
    }
    
    public void setServiceDescription(String serviceDescription) {
        this.serviceDescription = serviceDescription;
    }
    
    // Utility Methods
    
    /**
     * Định dạng amount theo format tiền Việt
     */
    public String getFormattedAmount() {
        if (amount == null) return "0 VNĐ";
        NumberFormat formatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return formatter.format(amount) + " VNĐ";
    }
    
    /**
     * Định dạng original price
     */
    public String getFormattedOriginalPrice() {
        if (originalPrice == null) return "0 VNĐ";
        NumberFormat formatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return formatter.format(originalPrice) + " VNĐ";
    }
    
    /**
     * Kiểm tra có được thanh toán chưa
     */
    public boolean isPaid() {
        return "success".equals(paymentStatus);
    }
    
    /**
     * Kiểm tra có bị hủy chưa
     */
    public boolean isCancelled() {
        return "cancelled".equals(paymentStatus);
    }
    
    /**
     * Kiểm tra có bị hoàn tiền chưa
     */
    public boolean isRefunded() {
        return "refunded".equals(paymentStatus);
    }
    
    /**
     * Kiểm tra đang chờ thanh toán
     */
    public boolean isPending() {
        return "pending".equals(paymentStatus);
    }
    
    /**
     * Kiểm tra đang xử lý
     */
    public boolean isProcessing() {
        return "processing".equals(paymentStatus);
    }
    
    /**
     * Kiểm tra thanh toán thất bại
     */
    public boolean isFailed() {
        return "failed".equals(paymentStatus);
    }
    
    /**
     * Lấy màu CSS cho status
     */
    public String getStatusColor() {
        switch (paymentStatus != null ? paymentStatus : "pending") {
            case "success":
                return "success";
            case "pending":
                return "warning";
            case "processing":
                return "info";
            case "failed":
            case "cancelled":
                return "danger";
            case "refunded":
                return "secondary";
            default:
                return "secondary";
        }
    }
    
    /**
     * Lấy icon cho status
     */
    public String getStatusIcon() {
        switch (paymentStatus != null ? paymentStatus : "pending") {
            case "success":
                return "fas fa-check-circle";
            case "pending":
                return "fas fa-clock";
            case "processing":
                return "fas fa-spinner fa-spin";
            case "failed":
                return "fas fa-times-circle";
            case "cancelled":
                return "fas fa-ban";
            case "refunded":
                return "fas fa-undo";
            default:
                return "fas fa-question-circle";
        }
    }
    
    /**
     * Lấy text hiển thị cho status
     */
    public String getStatusText() {
        switch (paymentStatus != null ? paymentStatus : "pending") {
            case "success":
                return "Đã thanh toán";
            case "pending":
                return "Chờ thanh toán";
            case "processing":
                return "Đang xử lý";
            case "failed":
                return "Thất bại";
            case "cancelled":
                return "Đã hủy";
            case "refunded":
                return "Đã hoàn tiền";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Kiểm tra có appointment information không
     */
    public boolean hasAppointmentInfo() {
        return doctorId != null && appointmentDate != null && appointmentTime != null;
    }
    
    /**
     * Tính total amount (bao gồm tax, trừ discount)
     */
    public BigDecimal getTotalAmount() {
        BigDecimal total = originalPrice != null ? originalPrice : BigDecimal.ZERO;
        
        if (discountAmount != null) {
            total = total.subtract(discountAmount);
        }
        
        if (taxAmount != null) {
            total = total.add(taxAmount);
        }
        
        return total;
    }
    
    /**
     * Tính discount percentage
     */
    public double getDiscountPercentage() {
        if (originalPrice == null || discountAmount == null || 
            originalPrice.compareTo(BigDecimal.ZERO) == 0) {
            return 0.0;
        }
        
        return discountAmount.divide(originalPrice, 4, BigDecimal.ROUND_HALF_UP)
                           .multiply(new BigDecimal(100))
                           .doubleValue();
    }
    
    @Override
    public String toString() {
        return String.format("Bill{billId='%s', orderId='%s', serviceName='%s', " +
                           "customerName='%s', amount=%s, status='%s'}", 
                           billId, orderId, serviceName, customerName, 
                           getFormattedAmount(), paymentStatus);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Bill bill = (Bill) obj;
        return billId != null ? billId.equals(bill.billId) : bill.billId == null;
    }
    
    @Override
    public int hashCode() {
        return billId != null ? billId.hashCode() : 0;
    }
} 