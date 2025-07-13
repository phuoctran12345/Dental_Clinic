package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.List;

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
    
    // Patient Information (for display purposes)
    private String patientName;
    private String patientPhone;
    
    // Thông tin bill cha (nếu là bill con của trả góp)
    private String parentBillId;
    
    // thêm vào để manage cái trả góp 
    // Installment Information
    private PaymentInstallment installmentSummary;
    private List<PaymentInstallment> installmentDetails;
    private double totalRemaining;
    
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
    
    public String getPatientName() {
        return patientName;
    }
    
    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }
    
    public String getPatientPhone() {
        return patientPhone;
    }
    
    public void setPatientPhone(String patientPhone) {
        this.patientPhone = patientPhone;
    }
    
    public PaymentInstallment getInstallmentSummary() {
        return installmentSummary;
    }
    
    public void setInstallmentSummary(PaymentInstallment installmentSummary) {
        this.installmentSummary = installmentSummary;
    }
    
    public List<PaymentInstallment> getInstallmentDetails() {
        return installmentDetails;
    }
    
    public void setInstallmentDetails(List<PaymentInstallment> installmentDetails) {
        this.installmentDetails = installmentDetails;
    }
    
    public double getTotalRemaining() {
        return totalRemaining;
    }
    
    public void setTotalRemaining(double totalRemaining) {
        this.totalRemaining = totalRemaining;
    }
    
    public String getParentBillId() {
        return parentBillId;
    }
    public void setParentBillId(String parentBillId) {
        this.parentBillId = parentBillId;
    }
    
    /**
     * Lấy ngày tạo hóa đơn (alias cho createdAt để JSP sử dụng)
     */
    public Date getBillDate() {
        if (createdAt != null) {
            return new Date(createdAt.getTime());
        }
        return null;
    }
    
    /**
     * Lấy ngày tạo hóa đơn dưới dạng Timestamp
     */
    public Timestamp getBillDateTime() {
        return createdAt;
    }
    
    /**
     * Lấy trạng thái thanh toán (alias cho paymentStatus để JSP sử dụng)
     */
    public String getStatus() {
        return paymentStatus;
    }
    
    /**
     * Set trạng thái thanh toán (alias cho setPaymentStatus)
     */
    public void setStatus(String status) {
        this.paymentStatus = status;
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
     * Ưu tiên sử dụng amount trước, sau đó mới tính từ originalPrice
     */
    public BigDecimal getTotalAmount() {
        // Ưu tiên sử dụng amount nếu có
        if (amount != null) {
            return amount;
        }
        
        // Nếu không có amount, tính từ originalPrice
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
     * Lấy số tiền cuối cùng (alias cho getTotalAmount để đảm bảo tương thích)
     */
    public BigDecimal getFinalAmount() {
        return getTotalAmount();
    }
    
    /**
     * Kiểm tra trạng thái PAID (cho JSP sử dụng dễ hơn)
     */
    public boolean isPaidStatus() {
        return "PAID".equals(paymentStatus) || "success".equals(paymentStatus) || "Đã thanh toán".equals(paymentStatus);
    }
    
    /**
     * Kiểm tra trạng thái PENDING (cho JSP sử dụng dễ hơn)
     */
    public boolean isPendingStatus() {
        return "PENDING".equals(paymentStatus) || "pending".equals(paymentStatus) || "Chờ thanh toán".equals(paymentStatus);
    }
    
    /**
     * Lấy trạng thái chuẩn hóa cho JSP
     */
    public String getNormalizedStatus() {
        if (isPaidStatus()) return "PAID";
        if (isPendingStatus()) return "PENDING";
        if ("PARTIAL".equals(paymentStatus) || "partial".equals(paymentStatus)) return "PARTIAL";
        if ("CANCELLED".equals(paymentStatus) || "cancelled".equals(paymentStatus)) return "CANCELLED";
        if ("INSTALLMENT".equals(paymentStatus)) return "INSTALLMENT";
        return paymentStatus != null ? paymentStatus.toUpperCase() : "UNKNOWN";
    }
    
    /**
     * Lấy mô tả trạng thái (cho JSP hiển thị)
     */
    public String getStatusDescription() {
        return getStatusText();
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
    
    /**
     * Validate bill data before saving
     */
    public boolean isValid() {
        if (billId == null || billId.trim().isEmpty()) {
            return false;
        }
        if (customerName == null || customerName.trim().isEmpty()) {
            return false;
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }
        if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
            return false;
        }
        return true;
    }
    
    /**
     * Get validation errors
     */
    public java.util.List<String> getValidationErrors() {
        java.util.List<String> errors = new java.util.ArrayList<>();
        
        if (billId == null || billId.trim().isEmpty()) {
            errors.add("Bill ID không được để trống");
        }
        if (customerName == null || customerName.trim().isEmpty()) {
            errors.add("Tên khách hàng không được để trống");
        }
        if (customerPhone == null || customerPhone.trim().isEmpty()) {
            errors.add("Số điện thoại không được để trống");
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Số tiền phải lớn hơn 0");
        }
        if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
            errors.add("Trạng thái thanh toán không được để trống");
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            errors.add("Phương thức thanh toán không được để trống");
        }
        
        return errors;
    }
    
    /**
     * Sanitize input data
     */
    public void sanitizeInputs() {
        if (customerName != null) {
            customerName = customerName.trim().replaceAll("[<>\"']", "");
        }
        if (customerPhone != null) {
            customerPhone = customerPhone.trim().replaceAll("[^0-9+\\-\\s]", "");
        }
        if (customerEmail != null) {
            customerEmail = customerEmail.trim().toLowerCase();
        }
        if (notes != null) {
            notes = notes.trim().replaceAll("[<>]", "");
        }
        if (internalNotes != null) {
            internalNotes = internalNotes.trim().replaceAll("[<>]", "");
        }
    }
    
    /**
     * Check if bill can be cancelled
     */
    public boolean canBeCancelled() {
        return !"PAID".equals(paymentStatus) && 
               !"success".equals(paymentStatus) && 
               !"cancelled".equals(paymentStatus) &&
               !"refunded".equals(paymentStatus);
    }
    
    /**
     * Check if bill can be refunded
     */
    public boolean canBeRefunded() {
        return "PAID".equals(paymentStatus) || "success".equals(paymentStatus);
    }
    
    /**
     * Check if bill is installment type
     */
    public boolean isInstallmentBill() {
        return "INSTALLMENT".equals(paymentStatus);
    }
    
    /**
     * Get next installment due date (for installment bills)
     */
    public Date getNextInstallmentDueDate() {
        if (installmentSummary != null) {
            return installmentSummary.getNextDueDate();
        }
        return null;
    }
    
    /**
     * Get installment progress percentage
     */
    public double getInstallmentProgress() {
        if (installmentSummary != null) {
            try {
                int paid = installmentSummary.getPaidInstallments();
                int total = installmentSummary.getInstallmentCount();
                if (total > 0) {
                    return (double) paid / total * 100.0;
                }
            } catch (Exception e) {
                // Extended fields may not be available
                if (installmentDetails != null && !installmentDetails.isEmpty()) {
                    long paidCount = installmentDetails.stream()
                            .filter(inst -> "PAID".equals(inst.getStatus()))
                            .count();
                    return (double) paidCount / installmentDetails.size() * 100.0;
                }
            }
        }
        return 0.0;
    }
} 