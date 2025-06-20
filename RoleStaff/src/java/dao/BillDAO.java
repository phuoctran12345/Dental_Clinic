package dao;

import model.Bill;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

/**
 * DAO class xử lý nghiệp vụ Bills
 */
public class BillDAO {
    
    private DBContext dbConnection = new DBContext();
    
    /**
     * Tạo hóa đơn mới
     */
    public Bill createBill(Bill bill) throws SQLException {
        String sql = """
            INSERT INTO dbo.Bills 
            (bill_id, order_id, service_id, patient_id, user_id, amount, original_price, 
             customer_name, customer_phone, customer_email, payment_method, payment_status,
             doctor_id, appointment_date, appointment_time, appointment_notes, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, bill.getBillId());
            stmt.setString(2, bill.getOrderId());
            stmt.setInt(3, bill.getServiceId());
            stmt.setObject(4, bill.getPatientId());
            stmt.setObject(5, bill.getUserId());
            stmt.setBigDecimal(6, bill.getAmount());
            stmt.setBigDecimal(7, bill.getOriginalPrice());
            stmt.setString(8, bill.getCustomerName());
            stmt.setString(9, bill.getCustomerPhone());
            stmt.setString(10, bill.getCustomerEmail());
            stmt.setString(11, bill.getPaymentMethod());
            stmt.setString(12, bill.getPaymentStatus());
            stmt.setObject(13, bill.getDoctorId());
            stmt.setObject(14, bill.getAppointmentDate());
            stmt.setObject(15, bill.getAppointmentTime());
            stmt.setString(16, bill.getAppointmentNotes());
            stmt.setString(17, bill.getNotes());
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                return getBillById(bill.getBillId());
            }
        }
        
        return null;
    }
    
    /**
     * Lấy hóa đơn theo bill_id
     */
    public Bill getBillById(String billId) throws SQLException {
        String sql = """
            SELECT b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.bill_id = ? AND b.is_deleted = 0
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        }
        
        return null;
    }
    
    /**
     * Lấy hóa đơn theo order_id
     */
    public Bill getBillByOrderId(String orderId) throws SQLException {
        String sql = """
            SELECT b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.order_id = ? AND b.is_deleted = 0
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        }
        
        return null;
    }
    
    /**
     * Cập nhật trạng thái thanh toán
     */
    public boolean updatePaymentStatus(String billId, String paymentStatus, 
                                     String payosTransactionId, String paymentResponse) throws SQLException {
        String sql = """
            UPDATE dbo.Bills 
            SET payment_status = ?, 
                payos_transaction_id = ?, 
                payment_gateway_response = ?,
                paid_at = CASE WHEN ? = 'success' THEN GETDATE() ELSE paid_at END,
                cancelled_at = CASE WHEN ? = 'cancelled' THEN GETDATE() ELSE cancelled_at END,
                updated_at = GETDATE()
            WHERE bill_id = ?
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paymentStatus);
            stmt.setString(2, payosTransactionId);
            stmt.setString(3, paymentResponse);
            stmt.setString(4, paymentStatus);
            stmt.setString(5, paymentStatus);
            stmt.setString(6, billId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy danh sách hóa đơn theo customer
     */
    public List<Bill> getBillsByCustomer(String customerPhone, int limit) throws SQLException {
        String sql = """
            SELECT TOP (?) b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.customer_phone = ? AND b.is_deleted = 0
            ORDER BY b.created_at DESC
        """;
        
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setString(2, customerPhone);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        }
        
        return bills;
    }
    
    /**
     * Lấy danh sách hóa đơn theo patient_id
     */
    public List<Bill> getBillsByPatientId(int patientId, int limit) throws SQLException {
        String sql = """
            SELECT TOP (?) b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.patient_id = ? AND b.is_deleted = 0
            ORDER BY b.created_at DESC
        """;
        
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, patientId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        }
        
        return bills;
    }
    
    /**
     * Lấy danh sách hóa đơn theo service_id
     */
    public List<Bill> getBillsByServiceId(int serviceId, int limit) throws SQLException {
        String sql = """
            SELECT TOP (?) b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.service_id = ? AND b.is_deleted = 0
            ORDER BY b.created_at DESC
        """;
        
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, serviceId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        }
        
        return bills;
    }
    
    /**
     * Lấy danh sách hóa đơn gần nhất
     */
    public List<Bill> getRecentBills(int limit) throws SQLException {
        String sql = """
            SELECT TOP (?) b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.is_deleted = 0
            ORDER BY b.created_at DESC
        """;
        
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        }
        
        return bills;
    }
    
    /**
     * Lấy danh sách hóa đơn theo trạng thái
     */
    public List<Bill> getBillsByStatus(String paymentStatus, int limit) throws SQLException {
        String sql = """
            SELECT TOP (?) b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.payment_status = ? AND b.is_deleted = 0
            ORDER BY b.created_at DESC
        """;
        
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setString(2, paymentStatus);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        }
        
        return bills;
    }
    
    /**
     * Lấy thống kê revenue theo ngày
     */
    public List<RevenueSummary> getRevenueByDate(Date fromDate, Date toDate) throws SQLException {
        String sql = """
            SELECT 
                CAST(b.created_at AS DATE) as bill_date,
                COUNT(b.bill_id) as total_bills,
                SUM(b.amount) as total_revenue,
                AVG(b.amount) as avg_bill_amount
            FROM dbo.Bills b
            WHERE b.payment_status = 'success' 
                AND b.is_deleted = 0
                AND CAST(b.created_at AS DATE) BETWEEN ? AND ?
            GROUP BY CAST(b.created_at AS DATE)
            ORDER BY bill_date DESC
        """;
        
        List<RevenueSummary> summaries = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, fromDate);
            stmt.setDate(2, toDate);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                RevenueSummary summary = new RevenueSummary();
                summary.setDate(rs.getDate("bill_date"));
                summary.setTotalBills(rs.getInt("total_bills"));
                summary.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                summary.setAvgBillAmount(rs.getBigDecimal("avg_bill_amount"));
                summaries.add(summary);
            }
        }
        
        return summaries;
    }
    
    /**
     * Lấy thống kê revenue theo dịch vụ
     */
    public List<ServiceRevenue> getRevenueByService(int limit) throws SQLException {
        String sql = """
            SELECT TOP (?)
                s.service_id,
                s.service_name,
                s.category,
                COUNT(b.bill_id) as total_bills,
                SUM(b.amount) as total_revenue,
                AVG(b.amount) as avg_bill_amount
            FROM dbo.Services s
            LEFT JOIN dbo.Bills b ON s.service_id = b.service_id 
                AND b.payment_status = 'success' 
                AND b.is_deleted = 0
            GROUP BY s.service_id, s.service_name, s.category
            ORDER BY total_revenue DESC
        """;
        
        List<ServiceRevenue> revenues = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ServiceRevenue revenue = new ServiceRevenue();
                revenue.setServiceId(rs.getInt("service_id"));
                revenue.setServiceName(rs.getString("service_name"));
                revenue.setCategory(rs.getString("category"));
                revenue.setTotalBills(rs.getInt("total_bills"));
                revenue.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                revenue.setAvgBillAmount(rs.getBigDecimal("avg_bill_amount"));
                revenues.add(revenue);
            }
        }
        
        return revenues;
    }
    
    /**
     * Xóa mềm hóa đơn
     */
    public boolean softDeleteBill(String billId) throws SQLException {
        String sql = "UPDATE dbo.Bills SET is_deleted = 1, updated_at = GETDATE() WHERE bill_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Kiểm tra bill có tồn tại
     */
    public boolean billExists(String billId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.Bills WHERE bill_id = ? AND is_deleted = 0";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }
    
    /**
     * Map ResultSet to Bill object
     */
    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        
        bill.setBillId(rs.getString("bill_id"));
        bill.setOrderId(rs.getString("order_id"));
        bill.setServiceId(rs.getInt("service_id"));
        
        // Null-safe way to get Integer objects
        Object patientIdObj = rs.getObject("patient_id");
        bill.setPatientId(patientIdObj != null ? (Integer) patientIdObj : null);
        
        Object userIdObj = rs.getObject("user_id");
        bill.setUserId(userIdObj != null ? (Integer) userIdObj : null);
        
        bill.setAmount(rs.getBigDecimal("amount"));
        bill.setOriginalPrice(rs.getBigDecimal("original_price"));
        bill.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        bill.setTaxAmount(rs.getBigDecimal("tax_amount"));
        bill.setPaymentMethod(rs.getString("payment_method"));
        bill.setPaymentStatus(rs.getString("payment_status"));
        bill.setCustomerName(rs.getString("customer_name"));
        bill.setCustomerPhone(rs.getString("customer_phone"));
        bill.setCustomerEmail(rs.getString("customer_email"));
        
        // Null-safe way to get doctor_id
        Object doctorIdObj = rs.getObject("doctor_id");
        bill.setDoctorId(doctorIdObj != null ? (Integer) doctorIdObj : null);
        
        bill.setAppointmentDate(rs.getDate("appointment_date"));
        bill.setAppointmentTime(rs.getTime("appointment_time"));
        bill.setAppointmentNotes(rs.getString("appointment_notes"));
        bill.setPayosOrderId(rs.getString("payos_order_id"));
        bill.setPayosTransactionId(rs.getString("payos_transaction_id"));
        bill.setPayosSignature(rs.getString("payos_signature"));
        bill.setPaymentGatewayResponse(rs.getString("payment_gateway_response"));
        bill.setCreatedAt(rs.getTimestamp("created_at"));
        bill.setUpdatedAt(rs.getTimestamp("updated_at"));
        bill.setPaidAt(rs.getTimestamp("paid_at"));
        bill.setCancelledAt(rs.getTimestamp("cancelled_at"));
        bill.setRefundedAt(rs.getTimestamp("refunded_at"));
        bill.setNotes(rs.getString("notes"));
        bill.setInternalNotes(rs.getString("internal_notes"));
        bill.setDeleted(rs.getBoolean("is_deleted"));
        
        // Service information if joined
        try {
            bill.setServiceName(rs.getString("service_name"));
            bill.setServiceDescription(rs.getString("service_description"));
        } catch (SQLException e) {
            // Ignore if columns don't exist
        }
        
        return bill;
    }
    
    /**
     * Inner class for Revenue Summary
     */
    public static class RevenueSummary {
        private Date date;
        private int totalBills;
        private java.math.BigDecimal totalRevenue;
        private java.math.BigDecimal avgBillAmount;
        
        // Getters and Setters
        public Date getDate() { return date; }
        public void setDate(Date date) { this.date = date; }
        public int getTotalBills() { return totalBills; }
        public void setTotalBills(int totalBills) { this.totalBills = totalBills; }
        public java.math.BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(java.math.BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
        public java.math.BigDecimal getAvgBillAmount() { return avgBillAmount; }
        public void setAvgBillAmount(java.math.BigDecimal avgBillAmount) { this.avgBillAmount = avgBillAmount; }
    }
    
    /**
     * Inner class for Service Revenue
     */
    public static class ServiceRevenue {
        private int serviceId;
        private String serviceName;
        private String category;
        private int totalBills;
        private java.math.BigDecimal totalRevenue;
        private java.math.BigDecimal avgBillAmount;
        
        // Getters and Setters
        public int getServiceId() { return serviceId; }
        public void setServiceId(int serviceId) { this.serviceId = serviceId; }
        public String getServiceName() { return serviceName; }
        public void setServiceName(String serviceName) { this.serviceName = serviceName; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public int getTotalBills() { return totalBills; }
        public void setTotalBills(int totalBills) { this.totalBills = totalBills; }
        public java.math.BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(java.math.BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
        public java.math.BigDecimal getAvgBillAmount() { return avgBillAmount; }
        public void setAvgBillAmount(java.math.BigDecimal avgBillAmount) { this.avgBillAmount = avgBillAmount; }
    }
} 