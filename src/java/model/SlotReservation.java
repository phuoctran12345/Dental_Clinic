package model;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * SlotReservation model - Quản lý việc tạm khóa slot trong 5 phút
 * KHÔNG cần tạo bảng mới - sử dụng bảng Appointment với status đặc biệt
 */
public class SlotReservation {
    
    // Sử dụng appointment_id thay vì reservationId
    private int appointmentId;
    private int doctorId;
    private LocalDate workDate;
    private int slotId;
    private int patientId;
    
    // Status reservation đặc biệt:
    // "ĐANG GIỮ CHỖ" - slot đang được tạm khóa trong 5 phút
    // "CHờ THANH TOÁN" - đã confirm, chờ thanh toán PayOS
    // "ĐÃ ĐẶT" - đã thanh toán thành công
    // "HẾT HẠN" - reservation đã hết 5 phút
    private String status; 
    
    private Timestamp reservedAt;
    private Timestamp expiresAt;
    private Timestamp confirmedAt;
    
    // Link với PayOS payment
    private String payosOrderId; // Tương ứng với Bills.payos_order_id
    private String billId;       // Link với Bills.bill_id
    
    // Appointment details
    private String reason;       // Lý do khám bệnh
    
    // Constants cho status (English - Chỉ 4 trạng thái chính)
    public static final String STATUS_BOOKED = "BOOKED";               // ĐÃ ĐẶT LỊCH
    public static final String STATUS_COMPLETED = "COMPLETED";         // HOÀN THÀNH
    public static final String STATUS_CANCELLED = "CANCELLED";         // ĐÃ HỦY
    public static final String STATUS_WAITING_PAYMENT = "WAITING_PAYMENT"; // CHỜ THANH TOÁN
    
    // Constructors
    public SlotReservation() {
    }
    
    /**
     * Constructor cho việc tạo reservation mới
     */
    public SlotReservation(int doctorId, LocalDate workDate, int slotId, int patientId) {
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.slotId = slotId;
        this.patientId = patientId;
        this.status = STATUS_BOOKED;
        this.reservedAt = Timestamp.valueOf(LocalDateTime.now());
        this.expiresAt = Timestamp.valueOf(LocalDateTime.now().plusMinutes(5)); // 5 phút
    }
    
    /**
     * Constructor với reason
     */
    public SlotReservation(int doctorId, LocalDate workDate, int slotId, int patientId, String reason) {
        this(doctorId, workDate, slotId, patientId);
        this.reason = reason;
    }
    
    // Getters and Setters
    public int getAppointmentId() {
        return appointmentId;
    }
    
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    
    // Backward compatibility
    public int getReservationId() {
        return appointmentId;
    }
    
    public void setReservationId(int reservationId) {
        this.appointmentId = reservationId;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public LocalDate getWorkDate() {
        return workDate;
    }
    
    public void setWorkDate(LocalDate workDate) {
        this.workDate = workDate;
    }
    
    public int getSlotId() {
        return slotId;
    }
    
    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getReservedAt() {
        return reservedAt;
    }
    
    public void setReservedAt(Timestamp reservedAt) {
        this.reservedAt = reservedAt;
    }
    
    public Timestamp getExpiresAt() {
        return expiresAt;
    }
    
    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }
    
    public Timestamp getConfirmedAt() {
        return confirmedAt;
    }
    
    public void setConfirmedAt(Timestamp confirmedAt) {
        this.confirmedAt = confirmedAt;
    }
    
    public String getPayosOrderId() {
        return payosOrderId;
    }
    
    public void setPayosOrderId(String payosOrderId) {
        this.payosOrderId = payosOrderId;
    }
    
    // Backward compatibility
    public String getOrderId() {
        return payosOrderId;
    }
    
    public void setOrderId(String orderId) {
        this.payosOrderId = orderId;
    }
    
    public String getBillId() {
        return billId;
    }
    
    public void setBillId(String billId) {
        this.billId = billId;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
    
    // Utility Methods
    
    /**
     * Kiểm tra reservation có hết hạn chưa
     */
    public boolean isExpired() {
        return expiresAt != null && System.currentTimeMillis() > expiresAt.getTime();
    }
    
    /**
     * Kiểm tra reservation có còn hiệu lực không
     */
    public boolean isActive() {
        return STATUS_BOOKED.equals(status) && !isExpired();
    }
    
    /**
     * Kiểm tra có đã confirmed chưa
     */
    public boolean isConfirmed() {
        return STATUS_COMPLETED.equals(status);
    }
    
    /**
     * Kiểm tra có đang chờ thanh toán không
     */
    public boolean isWaitingPayment() {
        return STATUS_WAITING_PAYMENT.equals(status);
    }
    
    /**
     * Lấy thời gian còn lại (seconds)
     */
    public long getRemainingSeconds() {
        if (expiresAt == null) return 0;
        long remaining = (expiresAt.getTime() - System.currentTimeMillis()) / 1000;
        return Math.max(0, remaining);
    }
    
    /**
     * Lấy thời gian còn lại (phút:giây)
     */
    public String getRemainingTime() {
        long seconds = getRemainingSeconds();
        long minutes = seconds / 60;
        long secs = seconds % 60;
        return String.format("%d:%02d", minutes, secs);
    }
    
    /**
     * Chuyển đổi status từ reservation sang appointment (render ra giao diện)
     */
    public String getAppointmentStatus() {
        switch (status) {
            case STATUS_BOOKED:
                return "Đã đặt lịch";
            case STATUS_COMPLETED:
                return "Hoàn thành";
            case STATUS_CANCELLED:
                return "Đã hủy";
            case STATUS_WAITING_PAYMENT:
                return "Chờ thanh toán";
            default:
                return status;
        }
    }
    
    @Override
    public String toString() {
        return String.format("SlotReservation{appointmentId=%d, doctorId=%d, workDate=%s, slotId=%d, " +
                           "patientId=%d, status='%s', payosOrderId='%s', remaining='%s'}", 
                           appointmentId, doctorId, workDate, slotId, patientId, 
                           status, payosOrderId, getRemainingTime());
    }
}