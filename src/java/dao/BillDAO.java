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
     * Tạo hóa đơn mới - KHỚP VỚI DATABASE STRUCTURE THỰC TẾ
     */
    public Bill createBill(Bill bill) throws SQLException {
        String sql = """
            INSERT INTO dbo.Bills 
            (bill_id, order_id, service_id, patient_id, user_id, amount, original_price, 
             discount_amount, tax_amount, payment_method, payment_status,
             customer_name, customer_phone, customer_email, doctor_id, 
             appointment_date, appointment_time, appointment_notes, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("🔧 Creating bill with parameters:");
            System.out.println("  1. bill_id: " + bill.getBillId());
            System.out.println("  2. order_id: " + bill.getOrderId());
            System.out.println("  3. service_id: " + bill.getServiceId());
            System.out.println("  4. patient_id: " + bill.getPatientId());
            System.out.println("  5. user_id: " + bill.getUserId());
            System.out.println("  6. amount: " + bill.getAmount());
            System.out.println("  7. original_price: " + bill.getOriginalPrice());
            System.out.println("  8. discount_amount: " + bill.getDiscountAmount());
            System.out.println("  9. tax_amount: " + bill.getTaxAmount());
            System.out.println("  10. payment_method: " + bill.getPaymentMethod());
            System.out.println("  11. payment_status: " + bill.getPaymentStatus());
            System.out.println("  12. customer_name: " + bill.getCustomerName());
            System.out.println("  13. customer_phone: " + bill.getCustomerPhone());
            System.out.println("  14. customer_email: " + bill.getCustomerEmail());
            System.out.println("  15. doctor_id: " + bill.getDoctorId());
            System.out.println("  16. appointment_date: " + bill.getAppointmentDate());
            System.out.println("  17. appointment_time: " + bill.getAppointmentTime());
            System.out.println("  18. appointment_notes: " + bill.getAppointmentNotes());
            System.out.println("  19. notes: " + bill.getNotes());
            
            stmt.setString(1, bill.getBillId());
            stmt.setString(2, bill.getOrderId());
            stmt.setInt(3, bill.getServiceId());
            stmt.setObject(4, bill.getPatientId());
            stmt.setObject(5, bill.getUserId());
            stmt.setBigDecimal(6, bill.getAmount());
            stmt.setBigDecimal(7, bill.getOriginalPrice());
            stmt.setBigDecimal(8, bill.getDiscountAmount());
            stmt.setBigDecimal(9, bill.getTaxAmount());
            stmt.setString(10, bill.getPaymentMethod());
            stmt.setString(11, bill.getPaymentStatus());
            stmt.setString(12, bill.getCustomerName());
            stmt.setString(13, bill.getCustomerPhone());
            stmt.setString(14, bill.getCustomerEmail());
            stmt.setObject(15, bill.getDoctorId());
            stmt.setObject(16, bill.getAppointmentDate());
            stmt.setObject(17, bill.getAppointmentTime());
            stmt.setString(18, bill.getAppointmentNotes());
            stmt.setString(19, bill.getNotes());
            
            int result = stmt.executeUpdate();
            System.out.println("📊 SQL execution result: " + result + " rows affected");
            
            if (result > 0) {
                System.out.println("✅ Created bill successfully: " + bill.getBillId());
                return getBillById(bill.getBillId());
            } else {
                System.err.println("❌ No rows were inserted");
                return null;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Error creating bill: " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            throw e;
        }
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
     * Lấy tất cả hóa đơn
     */
    public List<Bill> getAllBills() throws SQLException {
        String sql = """
            SELECT b.*, s.service_name, s.description as service_description 
            FROM dbo.Bills b
            LEFT JOIN dbo.Services s ON b.service_id = s.service_id
            WHERE b.is_deleted = 0
            ORDER BY b.created_at DESC
        """;
        
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
            
            System.out.println("✅ Loaded " + bills.size() + " bills from database");
            
        } catch (SQLException e) {
            System.err.println("❌ Error loading bills: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return bills;
    }

    
    /**
     * Cập nhật thanh toán
     */
    public boolean updatePayment(int billId, double paidAmount, String paymentMethod, String notes) throws SQLException {
        String sql = """
            UPDATE dbo.Bills 
            SET payment_status = CASE 
                    WHEN ? >= amount THEN 'PAID'
                    WHEN ? > 0 THEN 'PARTIAL'
                    ELSE 'PENDING'
                END,
                payment_method = ?,
                notes = ?,
                paid_at = CASE WHEN ? >= amount THEN GETDATE() ELSE paid_at END,
                updated_at = GETDATE()
            WHERE bill_id = ?
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, paidAmount);
            stmt.setDouble(2, paidAmount);
            stmt.setString(3, paymentMethod);
            stmt.setString(4, notes);
            stmt.setDouble(5, paidAmount);
            stmt.setString(6, String.valueOf(billId));
            
            return stmt.executeUpdate() > 0;
        }
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
     * Map ResultSet to Bill object - KHỚP VỚI DATABASE STRUCTURE THỰC TẾ
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
    
    /**
     * Cập nhật trạng thái thanh toán (version đơn giản với 2 tham số)
     */
    public boolean updatePaymentStatus(String billId, String paymentStatus) throws SQLException {
        String sql = """
            UPDATE dbo.Bills 
            SET payment_status = ?, 
                updated_at = GETDATE(),
                paid_at = CASE WHEN ? IN ('PAID', 'success', 'completed') THEN GETDATE() ELSE paid_at END,
                cancelled_at = CASE WHEN ? IN ('CANCELLED', 'cancelled') THEN GETDATE() ELSE cancelled_at END
            WHERE bill_id = ?
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paymentStatus);
            stmt.setString(2, paymentStatus);
            stmt.setString(3, paymentStatus);
            stmt.setString(4, billId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("✅ Updated payment status for bill " + billId + " to: " + paymentStatus);
                return true;
            } else {
                System.err.println("⚠️ No bill found with ID: " + billId);
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating payment status for bill: " + billId + " - " + e.getMessage());
            throw e;
        }
    }

    /**
     * Tạo bán hàng đơn giản - CHỈ LƯU TỔNG TIỀN ĐỂ BÁO CÁO
     * Khớp với Bills table structure
     */
    public boolean createSimpleSale(int staffUserId, java.math.BigDecimal totalAmount, String medicineDetails, String customerName) throws SQLException {
        String sql = """
            INSERT INTO dbo.Bills 
            (bill_id, order_id, service_id, patient_id, user_id, amount, original_price, 
             discount_amount, tax_amount, payment_method, payment_status, 
             customer_name, customer_phone, customer_email, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Tạo ID đơn giản
            String billId = "SALE" + System.currentTimeMillis();
            String orderId = "ORDER_" + System.currentTimeMillis();
            
            System.out.println("🛒 Creating simple sale with Bills structure:");
            System.out.println("  - Bill ID: " + billId);
            System.out.println("  - Order ID: " + orderId);
            System.out.println("  - Staff User ID: " + staffUserId);
            System.out.println("  - Total Amount: " + totalAmount);
            System.out.println("  - Customer Name: " + customerName);
            
            // Lấy service_id cho "Bán thuốc" - giả sử là service_id = 1 hoặc 3
            int pharmacyServiceId = 3; // Theo screenshot thì service_id = 3 nhiều nhất
            
            stmt.setString(1, billId);                    // bill_id
            stmt.setString(2, orderId);                   // order_id  
            stmt.setInt(3, pharmacyServiceId);            // service_id
            stmt.setObject(4, null);                      // patient_id = NULL (không phải bệnh nhân đăng ký)
            stmt.setInt(5, staffUserId);                  // user_id (staff)
            stmt.setBigDecimal(6, totalAmount);           // amount
            stmt.setBigDecimal(7, totalAmount);           // original_price
            stmt.setBigDecimal(8, java.math.BigDecimal.ZERO);  // discount_amount = 0
            stmt.setBigDecimal(9, java.math.BigDecimal.ZERO);  // tax_amount = 0
            stmt.setString(10, "CASH");                   // payment_method (override default PayOS)
            stmt.setString(11, "PAID");                   // payment_status (override default pending)
            stmt.setString(12, customerName);             // customer_name
            stmt.setObject(13, null);                     // customer_phone = NULL
            stmt.setObject(14, null);                     // customer_email = NULL
            stmt.setString(15, medicineDetails);          // notes
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Simple sale recorded successfully!");
                System.out.println("  - Bill ID: " + billId);
                System.out.println("  - Amount: " + totalAmount + " VND");
                return true;
            } else {
                System.err.println("❌ Failed to record simple sale - no rows affected");
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in createSimpleSale:");
            System.err.println("  - Message: " + e.getMessage());
            System.err.println("  - SQL State: " + e.getSQLState());
            System.err.println("  - Error Code: " + e.getErrorCode());
            e.printStackTrace();
            throw e;
        }
    }
    
    /**
     * Lấy tổng doanh thu bán thuốc theo ngày
     */
    public java.math.BigDecimal getDailyPharmacyRevenue(Date date) throws SQLException {
        String sql = """
            SELECT COALESCE(SUM(amount), 0) as daily_revenue
            FROM dbo.Bills 
            WHERE CAST(created_at AS DATE) = ? 
                AND payment_status = 'PAID'
                AND service_id = 1
                AND is_deleted = 0
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, date);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("daily_revenue");
            }
        }
        
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Lấy tổng doanh thu bán thuốc theo tháng
     */
    public java.math.BigDecimal getMonthlyPharmacyRevenue(int year, int month) throws SQLException {
        String sql = """
            SELECT COALESCE(SUM(amount), 0) as monthly_revenue
            FROM dbo.Bills 
            WHERE YEAR(created_at) = ? 
                AND MONTH(created_at) = ?
                AND payment_status = 'PAID'
                AND service_id = 1
                AND is_deleted = 0
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, year);
            stmt.setInt(2, month);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("monthly_revenue");
            }
        }
        
        return java.math.BigDecimal.ZERO;
    }

    // đặt lịch cho người thân
    public boolean createBillForRelative(String billId, String orderId, int serviceId, int patientId, int userId, 
                                       java.math.BigDecimal amount, java.math.BigDecimal originalPrice, 
                                       String customerName, String customerPhone, String customerEmail, 
                                       int doctorId, java.sql.Date appointmentDate, java.sql.Time appointmentTime, 
                                       String appointmentNotes) throws SQLException {
        String sql = """
            INSERT INTO Bills 
            (bill_id, order_id, service_id, patient_id, user_id, amount, original_price, 
             discount_amount, tax_amount, payment_method, payment_status, 
             customer_name, customer_phone, customer_email, doctor_id, 
             appointment_date, appointment_time, appointment_notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            stmt.setString(2, orderId);
            stmt.setInt(3, serviceId);
            stmt.setInt(4, patientId);
            stmt.setInt(5, userId);
            stmt.setBigDecimal(6, amount);
            stmt.setBigDecimal(7, originalPrice);
            stmt.setBigDecimal(8, java.math.BigDecimal.ZERO); // discount_amount
            stmt.setBigDecimal(9, java.math.BigDecimal.ZERO); // tax_amount
            stmt.setString(10, "PayOS"); // payment_method
            stmt.setString(11, "pending"); // payment_status
            stmt.setString(12, customerName);
            stmt.setString(13, customerPhone);
            stmt.setString(14, customerEmail);
            stmt.setInt(15, doctorId);
            stmt.setDate(16, appointmentDate);
            stmt.setTime(17, appointmentTime);
            stmt.setString(18, appointmentNotes);
            
            System.out.println("✅ Tạo bill cho người thân:");
            System.out.println("  - Bill ID: " + billId);
            System.out.println("  - Customer: " + customerName);
            System.out.println("  - Amount: " + amount);
            System.out.println("  - Booked by User ID: " + userId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Tạo bill mới cho người thân
     * @return bill_id
     */
    public static int createBill(int appointmentId, int patientId, int userId, java.math.BigDecimal amount, String paymentMethod, String status) {
        int billId = -1;
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        java.sql.ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            String sql = "INSERT INTO Bills (appointment_id, patient_id, user_id, amount, payment_method, status) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, appointmentId);
            ps.setInt(2, patientId);
            ps.setInt(3, userId);
            ps.setBigDecimal(4, amount);
            ps.setString(5, paymentMethod);
            ps.setString(6, status);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                billId = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(rs, ps, conn);
        }
        return billId;
    }
    
    
    
    

    // Đảm bảo có hàm close để tránh lỗi linter
    public static void close(java.sql.ResultSet rs, java.sql.PreparedStatement ps, java.sql.Connection conn) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
} 