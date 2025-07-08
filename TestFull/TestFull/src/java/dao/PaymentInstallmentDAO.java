package dao;

import model.PaymentInstallment;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class PaymentInstallmentDAO {
    
    // Connection pooling để tối ưu performance
    private static final int MAX_RETRIES = 3;
    private static final long RETRY_DELAY_MS = 100;
    
    // Thread-safe counters for monitoring
    private static final AtomicInteger totalQueries = new AtomicInteger(0);
    private static final AtomicInteger successfulQueries = new AtomicInteger(0);
    private static final AtomicInteger failedQueries = new AtomicInteger(0);
    
    /**
     * Get database connection with retry logic
     */
    private Connection getConnectionWithRetry() throws SQLException {
        SQLException lastException = null;
        
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                Connection conn = new DBContext().getConnection();
                if (conn != null && !conn.isClosed()) {
                    return conn;
                }
            } catch (SQLException e) {
                lastException = e;
                System.err.println("❌ Database connection attempt " + attempt + " failed: " + e.getMessage());
                
                if (attempt < MAX_RETRIES) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS * attempt); // Exponential backoff
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new SQLException("Connection retry interrupted", ie);
                    }
                }
            }
        }
        
        throw new SQLException("Failed to get database connection after " + MAX_RETRIES + " attempts", lastException);
    }
    
    /**
     * Execute query with monitoring and error handling
     */
    private <T> T executeQuery(String operation, java.util.function.Function<Connection, T> queryFunction) {
        totalQueries.incrementAndGet();
        long startTime = System.currentTimeMillis();
        
        try {
            System.out.println("🔗 Executing " + operation + "...");
            T result = queryFunction.apply(getConnectionWithRetry());
            
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("✅ " + operation + " completed in " + duration + "ms");
            successfulQueries.incrementAndGet();
            
            return result;
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            System.err.println("❌ " + operation + " failed after " + duration + "ms: " + e.getMessage());
            failedQueries.incrementAndGet();
            throw new RuntimeException("Database operation failed: " + operation, e);
        }
    }
    
    /**
     * Get performance statistics
     */
    public static String getPerformanceStats() {
        int total = totalQueries.get();
        int success = successfulQueries.get();
        int failed = failedQueries.get();
        double successRate = total > 0 ? (double) success / total * 100.0 : 0.0;
        
        return String.format("PaymentInstallmentDAO Stats - Total: %d, Success: %d (%.1f%%), Failed: %d", 
                           total, success, successRate, failed);
    }
    
    /**
     * Tạo kế hoạch trả góp cho hóa đơn
     */
    public boolean createInstallmentPlan(String billId, double totalAmount, double downPayment, int installmentCount) {
        System.out.println("💳 Creating installment plan for bill: " + billId);
        System.out.println("   - Total Amount: " + totalAmount);
        System.out.println("   - Down Payment: " + downPayment);
        System.out.println("   - Installment Count: " + installmentCount);
        
        // Validate constraints
        double minDownPayment = totalAmount * 0.3;
        if (downPayment < minDownPayment) {
            System.err.println("❌ Down payment too low. Required: " + minDownPayment + ", Got: " + downPayment);
            return false;
        }
        
        if (installmentCount < 3 || installmentCount > 12) {
            System.err.println("❌ Invalid installment count. Must be 3-12, Got: " + installmentCount);
            return false;
        }
        
        double remainingAmount = totalAmount - downPayment;
        double monthlyPayment = remainingAmount / installmentCount;
        
        String sql = """
            INSERT INTO dbo.PaymentInstallments
            (bill_id, total_amount, down_payment, installment_count, interest_rate,
             installment_number, due_date, amount_due, status, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Pre-calculate remaining amount and monthly payment
            System.out.println("   - Remaining amount: " + String.format("%,.0f", remainingAmount));
            System.out.println("   - Monthly payment: " + String.format("%,.0f", monthlyPayment));
            
            java.util.Calendar cal = java.util.Calendar.getInstance();
            
            for (int i = 1; i <= installmentCount; i++) {
                // Set bill and plan details (same for all installments in plan)
                stmt.setString(1, billId);
                stmt.setBigDecimal(2, java.math.BigDecimal.valueOf(totalAmount));
                stmt.setBigDecimal(3, java.math.BigDecimal.valueOf(downPayment));
                stmt.setInt(4, installmentCount);
                stmt.setBigDecimal(5, java.math.BigDecimal.ZERO); // interest_rate
                
                // Set specific details for this installment
                stmt.setInt(6, i); // installment_number
                
                // Set due date to be the same day of the month, for next months
                cal.add(java.util.Calendar.MONTH, 1);
                stmt.setDate(7, new java.sql.Date(cal.getTimeInMillis()));
                
                // Calculate installment amount, handle last installment carefully
                double installmentAmount = (i == installmentCount)
                    ? (remainingAmount - monthlyPayment * (installmentCount - 1))
                    : monthlyPayment;
                
                stmt.setBigDecimal(8, java.math.BigDecimal.valueOf(installmentAmount));
                stmt.setString(9, "PENDING"); // status
                
                stmt.addBatch();
                
                System.out.println("   - Batching Installment " + i + ": " +
                                 String.format("%,.0f", installmentAmount) + " VNĐ, Due: " +
                                 new java.sql.Date(cal.getTimeInMillis()));
            }
            
            int[] results = stmt.executeBatch();
            long successCount = java.util.Arrays.stream(results).filter(r -> r > 0).count();
            
            System.out.println("✅ Created " + successCount + "/" + installmentCount + " installments");
            return successCount == installmentCount;
            
        } catch (SQLException e) {
            System.err.println("❌ Error creating installment plan: " + e.getMessage());
            if (e instanceof java.sql.BatchUpdateException) {
                System.err.println("❌ Batch Update Exception details: " + ((java.sql.BatchUpdateException) e).getNextException());
            }
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Thanh toán một kỳ trả góp
     */
    public boolean payInstallment(int installmentId, double amountPaid, String paymentMethod, String transactionId) {
        System.out.println("💰 Processing installment payment:");
        System.out.println("   - Installment ID: " + installmentId);
        System.out.println("   - Amount Paid: " + amountPaid);
        System.out.println("   - Payment Method: " + paymentMethod);
        System.out.println("   - Transaction ID: " + transactionId);
        
        // Lấy thông tin kỳ trả góp hiện tại
        String selectSql = """
            SELECT amount_due, amount_paid, remaining_amount, status 
            FROM dbo.PaymentInstallments 
            WHERE installment_id = ?
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
            
            selectStmt.setInt(1, installmentId);
            ResultSet rs = selectStmt.executeQuery();
            
            if (!rs.next()) {
                System.err.println("❌ Installment not found: " + installmentId);
                return false;
            }
            
            double amountDue = rs.getDouble("amount_due");
            double currentAmountPaid = rs.getDouble("amount_paid");
            double remainingAmount = rs.getDouble("remaining_amount");
            String currentStatus = rs.getString("status");
            
            System.out.println("   - Current status: " + currentStatus);
            System.out.println("   - Amount due: " + amountDue);
            System.out.println("   - Already paid: " + currentAmountPaid);
            System.out.println("   - Remaining: " + (amountDue - currentAmountPaid));
            
            // Validate payment
            if ("PAID".equals(currentStatus)) {
                System.err.println("❌ Installment already fully paid");
                return false;
            }
            
            double totalPaidAfter = currentAmountPaid + amountPaid;
            if (totalPaidAfter > amountDue) {
                System.err.println("❌ Payment exceeds amount due. Max allowed: " + (amountDue - currentAmountPaid));
                return false;
            }
            
            // Determine new status
            String newStatus;
            if (totalPaidAfter >= amountDue) {
                newStatus = "PAID";
            } else if (totalPaidAfter > 0) {
                newStatus = "PARTIAL";
            } else {
                newStatus = "PENDING";
            }
            
            double newRemainingAmount = amountDue - totalPaidAfter;
            
            // Update installment
            String updateSql = """
                UPDATE dbo.PaymentInstallments 
                SET amount_paid = ?, 
                    remaining_amount = ?, 
                    payment_date = CASE WHEN ? = 'PAID' THEN CAST(GETDATE() AS DATE) ELSE payment_date END,
                    status = ?, 
                    payment_method = ?, 
                    transaction_id = ?
                WHERE installment_id = ?
            """;
            
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setBigDecimal(1, new java.math.BigDecimal(totalPaidAfter));
                updateStmt.setBigDecimal(2, new java.math.BigDecimal(newRemainingAmount));
                updateStmt.setString(3, newStatus);
                updateStmt.setString(4, newStatus);
                updateStmt.setString(5, paymentMethod);
                updateStmt.setString(6, transactionId);
                updateStmt.setInt(7, installmentId);
                
                int rowsAffected = updateStmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    System.out.println("✅ Payment processed successfully");
                    System.out.println("   - New status: " + newStatus);
                    System.out.println("   - Total paid: " + totalPaidAfter);
                    System.out.println("   - Remaining: " + newRemainingAmount);
                    
                    // Cập nhật next reminder date nếu cần
                    if ("PAID".equals(newStatus)) {
                        updateReminderStatus(conn, installmentId, false);
                    }
                    
                    return true;
                } else {
                    System.err.println("❌ No rows affected during update");
                    return false;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error processing installment payment: " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật trạng thái reminder cho kỳ trả góp
     */
    private void updateReminderStatus(Connection conn, int installmentId, boolean needsReminder) {
        String sql = """
            UPDATE dbo.PaymentInstallments 
            SET next_reminder_date = CASE WHEN ? = 1 THEN DATEADD(day, 3, CAST(GETDATE() AS DATE)) ELSE NULL END
            WHERE installment_id = ?
        """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, needsReminder);
            stmt.setInt(2, installmentId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("❌ Error updating reminder status: " + e.getMessage());
        }
    }
    
    /**
     * Lấy danh sách kỳ trả góp theo bill_id
     */
    public List<PaymentInstallment> getInstallmentsByBillId(String billId) {
        List<PaymentInstallment> installments = new ArrayList<>();
        String sql = """
            SELECT installment_id, bill_id, total_amount, down_payment, installment_count, 
                   ISNULL(interest_rate, 0) as interest_rate, installment_number, due_date, 
                   amount_due, ISNULL(amount_paid, 0) as amount_paid, 
                   ISNULL(remaining_amount, 0) as remaining_amount, payment_date, 
                   ISNULL(status, 'PENDING') as status, payment_method, transaction_id, 
                   ISNULL(late_fee, 0) as late_fee, last_reminder_date, 
                   ISNULL(reminder_count, 0) as reminder_count, next_reminder_date, notes
            FROM dbo.PaymentInstallments 
            WHERE bill_id = ? 
            ORDER BY installment_number ASC
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("📋 Loading installments for bill: " + billId);
            
            while (rs.next()) {
                PaymentInstallment installment = new PaymentInstallment();
                
                // Set only basic fields that are definitely in the model
                installment.setInstallmentId(rs.getInt("installment_id"));
                installment.setBillId(rs.getString("bill_id"));
                installment.setTotalAmount(rs.getDouble("total_amount"));
                installment.setDownPayment(rs.getDouble("down_payment"));
                installment.setInstallmentCount(rs.getInt("installment_count"));
                installment.setInstallmentNumber(rs.getInt("installment_number"));
                installment.setDueDate(rs.getDate("due_date"));
                installment.setAmountDue(rs.getDouble("amount_due"));
                installment.setAmountPaid(rs.getDouble("amount_paid"));
                installment.setPaymentDate(rs.getDate("payment_date"));
                installment.setStatus(rs.getString("status"));
                
                // Calculate remaining amount
                double amountPaid = rs.getDouble("amount_paid");
                double amountDue = rs.getDouble("amount_due");
                installment.setRemainingAmount(amountDue - amountPaid);
                
                // Set optional fields carefully
                String paymentMethod = rs.getString("payment_method");
                if (paymentMethod != null) {
                    installment.setPaymentMethod(paymentMethod);
                }
                
                String transactionId = rs.getString("transaction_id");
                if (transactionId != null) {
                    installment.setTransactionId(transactionId);
                }
                
                String notes = rs.getString("notes");
                if (notes != null) {
                    installment.setNotes(notes);
                }
                
                double lateFee = rs.getDouble("late_fee");
                installment.setLateFee(lateFee);
                
                installments.add(installment);
                
                System.out.println("   - Installment " + installment.getInstallmentNumber() + 
                                 ": " + String.format("%,.0f", installment.getAmountDue()) + 
                                 " VNĐ, Status: " + installment.getStatus() + 
                                 ", Due: " + installment.getDueDate());
            }
            
            System.out.println("✅ Loaded " + installments.size() + " installments");
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting installments for bill " + billId + ": " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        
        return installments;
    }
    
    /**
     * Lấy tất cả kỳ trả góp cần nhắc nợ
     */
    public List<PaymentInstallment> getRemindersNeeded() {
        List<PaymentInstallment> reminders = new ArrayList<>();
        
        String sql = """
            SELECT pi.installment_id, pi.bill_id, pi.installment_number, pi.due_date,
                   pi.amount_due, ISNULL(pi.amount_paid, 0) as amount_paid, 
                   ISNULL(pi.remaining_amount, 0) as remaining_amount, 
                   ISNULL(pi.status, 'PENDING') as status,
                   pi.last_reminder_date, ISNULL(pi.reminder_count, 0) as reminder_count, 
                   pi.next_reminder_date,
                   b.customer_name, b.customer_phone,
                   DATEDIFF(day, CAST(GETDATE() AS DATE), pi.due_date) AS days_until_due,
                   CASE 
                       WHEN DATEDIFF(day, CAST(GETDATE() AS DATE), pi.due_date) <= 0 THEN 'OVERDUE'
                       WHEN DATEDIFF(day, CAST(GETDATE() AS DATE), pi.due_date) <= 3 THEN 'DUE_SOON'
                       WHEN DATEDIFF(day, CAST(GETDATE() AS DATE), pi.due_date) <= 7 THEN 'REMINDER'
                       ELSE 'NORMAL'
                   END AS reminder_type
            FROM dbo.PaymentInstallments pi
            INNER JOIN dbo.Bills b ON pi.bill_id = b.bill_id
            WHERE ISNULL(pi.status, 'PENDING') IN ('PENDING', 'PARTIAL', 'OVERDUE')
              AND (
                  -- Quá hạn
                  pi.due_date < CAST(GETDATE() AS DATE)
                  OR 
                  -- Sắp đến hạn (3 ngày)
                  DATEDIFF(day, CAST(GETDATE() AS DATE), pi.due_date) <= 3
                  OR
                  -- Cần nhắc lại (7 ngày từ lần nhắc cuối)
                  (pi.next_reminder_date IS NOT NULL AND pi.next_reminder_date <= CAST(GETDATE() AS DATE))
              )
            ORDER BY pi.due_date ASC, pi.installment_number ASC
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("🔔 Checking for installments needing reminders...");
            
            while (rs.next()) {
                PaymentInstallment installment = new PaymentInstallment();
                installment.setInstallmentId(rs.getInt("installment_id"));
                installment.setBillId(rs.getString("bill_id"));
                installment.setInstallmentNumber(rs.getInt("installment_number"));
                installment.setDueDate(rs.getDate("due_date"));
                installment.setAmountDue(rs.getDouble("amount_due"));
                installment.setAmountPaid(rs.getDouble("amount_paid"));
                installment.setRemainingAmount(rs.getDouble("amount_due") - rs.getDouble("amount_paid"));
                installment.setStatus(rs.getString("status"));
                
                // Set customer info (these might be extended fields)
                String customerName = rs.getString("customer_name");
                String customerPhone = rs.getString("customer_phone");
                if (customerName != null) installment.setCustomerName(customerName);
                if (customerPhone != null) installment.setCustomerPhone(customerPhone);
                
                // Set reminder fields carefully
                int daysUntilDue = rs.getInt("days_until_due");
                String reminderType = rs.getString("reminder_type");
                installment.setDaysUntilDue(daysUntilDue);
                installment.setReminderType(reminderType);
                
                reminders.add(installment);
                
                System.out.println("   - " + installment.getCustomerName() + 
                                 " (Bill: " + installment.getBillId() + 
                                 ", Installment: " + installment.getInstallmentNumber() + 
                                 ", Type: " + installment.getReminderType() + 
                                 ", Days: " + installment.getDaysUntilDue() + ")");
            }
            
            System.out.println("✅ Found " + reminders.size() + " installments needing reminders");
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting reminders: " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        
        return reminders;
    }
    
    /**
     * Cập nhật trạng thái quá hạn
     */
    public int updateOverdueInstallments() {
        System.out.println("📅 Checking for overdue installments...");
        
        String sql = """
            UPDATE dbo.PaymentInstallments 
            SET status = 'OVERDUE',
                next_reminder_date = CASE 
                    WHEN next_reminder_date IS NULL OR next_reminder_date <= CAST(GETDATE() AS DATE) 
                    THEN DATEADD(day, 1, CAST(GETDATE() AS DATE)) 
                    ELSE next_reminder_date 
                END
            WHERE due_date < CAST(GETDATE() AS DATE) 
              AND status IN ('PENDING', 'PARTIAL')
              AND (ISNULL(amount_paid, 0) < amount_due)
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            int updated = stmt.executeUpdate();
            
            if (updated > 0) {
                System.out.println("⚠️ Updated " + updated + " installments to OVERDUE status");
                
                // Log chi tiết các installments bị overdue
                String selectSql = """
                    SELECT pi.installment_id, pi.bill_id, pi.installment_number, 
                           pi.due_date, pi.amount_due, pi.amount_paid,
                           b.customer_name, b.customer_phone
                    FROM dbo.PaymentInstallments pi
                    INNER JOIN dbo.Bills b ON pi.bill_id = b.bill_id
                    WHERE pi.status = 'OVERDUE'
                      AND pi.due_date < GETDATE()
                    ORDER BY pi.due_date ASC
                """;
                
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    ResultSet rs = selectStmt.executeQuery();
                    while (rs.next()) {
                        System.out.println("   ⚠️ " + rs.getString("customer_name") + 
                                         " - Bill: " + rs.getString("bill_id") + 
                                         ", Installment: " + rs.getInt("installment_number") + 
                                         ", Due: " + rs.getDate("due_date") + 
                                         ", Amount: " + String.format("%,.0f", rs.getDouble("amount_due")) + " VNĐ");
                    }
                }
            } else {
                System.out.println("✅ No overdue installments found");
            }
            
            return updated;
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating overdue installments: " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * Lấy tóm tắt kế hoạch trả góp
     */
    public PaymentInstallment getInstallmentSummary(String billId) {
        String sql = """
            SELECT 
                bill_id,
                MAX(total_amount) as total_amount,
                MAX(down_payment) as down_payment,
                MAX(installment_count) as total_installments,
                COUNT(*) as total_created_installments,
                SUM(CASE WHEN status = 'PAID' THEN 1 ELSE 0 END) as paid_installments,
                SUM(CASE WHEN status = 'OVERDUE' THEN 1 ELSE 0 END) as overdue_installments,
                SUM(CASE WHEN status IN ('PENDING', 'PARTIAL') THEN 1 ELSE 0 END) as pending_installments,
                SUM(ISNULL(amount_paid, 0)) as total_paid,
                SUM(amount_due - ISNULL(amount_paid, 0)) as total_remaining,
                SUM(ISNULL(late_fee, 0)) as total_late_fees,
                MIN(CASE WHEN status IN ('PENDING', 'PARTIAL', 'OVERDUE') THEN due_date ELSE NULL END) as next_due_date,
                CASE 
                    WHEN SUM(CASE WHEN status = 'PAID' THEN 1 ELSE 0 END) = COUNT(*) THEN 'COMPLETED'
                    WHEN SUM(CASE WHEN status = 'OVERDUE' THEN 1 ELSE 0 END) > 0 THEN 'OVERDUE'
                    WHEN SUM(CASE WHEN status IN ('PENDING', 'PARTIAL') THEN 1 ELSE 0 END) > 0 THEN 'ACTIVE'
                    ELSE 'UNKNOWN'
                END as plan_status
            FROM dbo.PaymentInstallments 
            WHERE bill_id = ?
            GROUP BY bill_id
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                PaymentInstallment summary = new PaymentInstallment();
                summary.setBillId(rs.getString("bill_id"));
                summary.setTotalAmount(rs.getDouble("total_amount"));
                summary.setDownPayment(rs.getDouble("down_payment"));
                summary.setInstallmentCount(rs.getInt("total_installments"));
                
                // Set summary statistics (these may be extended fields)
                try {
                summary.setPaidInstallments(rs.getInt("paid_installments"));
                summary.setOverdueInstallments(rs.getInt("overdue_installments"));
                summary.setPendingInstallments(rs.getInt("pending_installments"));
                summary.setTotalPaid(rs.getDouble("total_paid"));
                summary.setTotalRemaining(rs.getDouble("total_remaining"));
                summary.setTotalLateFees(rs.getDouble("total_late_fees"));
                summary.setNextDueDate(rs.getDate("next_due_date"));
                summary.setPlanStatus(rs.getString("plan_status"));
                } catch (Exception e) {
                    // Some methods may not exist, set basic info only
                    System.out.println("⚠️ Using basic summary info only: " + e.getMessage());
                }
                
                System.out.println("📊 Installment Summary for bill " + billId + ":");
                System.out.println("   - Total Amount: " + String.format("%,.0f", summary.getTotalAmount()) + " VNĐ");
                System.out.println("   - Down Payment: " + String.format("%,.0f", summary.getDownPayment()) + " VNĐ");
                System.out.println("   - Installments: " + summary.getInstallmentCount());
                
                // Safe logging for extended fields
                try {
                    System.out.println("   - Paid: " + summary.getPaidInstallments() + "/" + summary.getInstallmentCount());
                    System.out.println("   - Overdue: " + summary.getOverdueInstallments());
                    System.out.println("   - Pending: " + summary.getPendingInstallments());
                    System.out.println("   - Total Paid: " + String.format("%,.0f", summary.getTotalPaid()) + " VNĐ");
                    System.out.println("   - Total Remaining: " + String.format("%,.0f", summary.getTotalRemaining()) + " VNĐ");
                    System.out.println("   - Plan Status: " + summary.getPlanStatus());
                    System.out.println("   - Next Due Date: " + summary.getNextDueDate());
                } catch (Exception e) {
                    System.out.println("   - Extended info unavailable");
                }
                
                return summary;
            } else {
                System.out.println("⚠️ No installment plan found for bill: " + billId);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting installment summary for bill " + billId + ": " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thanh toán toàn bộ hóa đơn trả góp (trả nợ tất cả)
     */
    public boolean payOffFullInstallment(String billId, String paymentMethod, String transactionId) {
        System.out.println("💰 Processing full installment payoff for bill: " + billId);
        
        String sql = """
            UPDATE dbo.PaymentInstallments 
            SET amount_paid = amount_due,
                remaining_amount = 0,
                status = 'PAID',
                payment_date = GETDATE(),
                payment_method = ?,
                transaction_id = ?,
                updated_at = GETDATE(),
                next_reminder_date = NULL
            WHERE bill_id = ? 
              AND status IN ('PENDING', 'PARTIAL', 'OVERDUE')
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paymentMethod);
            stmt.setString(2, transactionId);
            stmt.setString(3, billId);
            
            int updatedRows = stmt.executeUpdate();
            
            if (updatedRows > 0) {
                System.out.println("✅ Paid off " + updatedRows + " remaining installments for bill " + billId);
                
                // Log chi tiết
                String selectSql = """
                    SELECT installment_number, amount_due, status 
                    FROM dbo.PaymentInstallments 
                    WHERE bill_id = ? 
                    ORDER BY installment_number
                """;
                
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    selectStmt.setString(1, billId);
                    ResultSet rs = selectStmt.executeQuery();
                    
                    while (rs.next()) {
                        System.out.println("   - Installment " + rs.getInt("installment_number") + 
                                         ": " + String.format("%,.0f", rs.getDouble("amount_due")) + 
                                         " VNĐ - " + rs.getString("status"));
                    }
                }
                
                return true;
            } else {
                System.out.println("⚠️ No pending installments found for bill " + billId);
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error paying off full installment for bill " + billId + ": " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Tính toán tổng số tiền còn nợ của một hóa đơn trả góp
     */
    public double getTotalRemainingAmount(String billId) {
        String sql = """
            SELECT SUM(amount_due - ISNULL(amount_paid, 0)) as total_remaining
            FROM dbo.PaymentInstallments 
            WHERE bill_id = ? 
              AND status IN ('PENDING', 'PARTIAL', 'OVERDUE')
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                double remaining = rs.getDouble("total_remaining");
                System.out.println("💰 Total remaining for bill " + billId + ": " + String.format("%,.0f", remaining) + " VNĐ");
                return remaining;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error calculating remaining amount for bill " + billId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /**
     * Lấy bill ID từ installment ID
     */
    public String getBillIdByInstallmentId(int installmentId) {
        String sql = """
            SELECT bill_id 
            FROM dbo.PaymentInstallments 
            WHERE installment_id = ?
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, installmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String billId = rs.getString("bill_id");
                System.out.println("🔍 Found bill ID " + billId + " for installment " + installmentId);
                return billId;
            } else {
                System.err.println("❌ No bill found for installment ID: " + installmentId);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting bill ID for installment " + installmentId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thanh toán kỳ trả góp theo bill ID và period number
     */
    public boolean payInstallmentByBillAndPeriod(String billId, int period, double amount, 
                                                 String paymentMethod, String transactionId, String notes) {
        System.out.println("💰 Paying installment - Bill: " + billId + ", Period: " + period + ", Amount: " + amount);
        
        String sql = """
            UPDATE dbo.PaymentInstallments 
            SET amount_paid = ?,
                remaining_amount = amount_due - ?,
                status = CASE 
                    WHEN ? >= amount_due THEN 'PAID'
                    WHEN ? > 0 THEN 'PARTIAL'
                    ELSE status
                END,
                payment_date = GETDATE(),
                payment_method = ?,
                transaction_id = ?,
                notes = ?,
                updated_at = GETDATE(),
                next_reminder_date = NULL
            WHERE bill_id = ? 
              AND installment_number = ?
              AND status IN ('PENDING', 'PARTIAL', 'OVERDUE')
        """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, amount);
            stmt.setDouble(2, amount);
            stmt.setDouble(3, amount);
            stmt.setDouble(4, amount);
            stmt.setString(5, paymentMethod);
            stmt.setString(6, transactionId);
            stmt.setString(7, notes);
            stmt.setString(8, billId);
            stmt.setInt(9, period);
            
            int updatedRows = stmt.executeUpdate();
            
            if (updatedRows > 0) {
                System.out.println("✅ Successfully paid installment " + period + " for bill " + billId);
                
                // Log chi tiết installment sau khi thanh toán
                String selectSql = """
                    SELECT installment_number, amount_due, amount_paid, status, payment_date 
                    FROM dbo.PaymentInstallments 
                    WHERE bill_id = ? AND installment_number = ?
                """;
                
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    selectStmt.setString(1, billId);
                    selectStmt.setInt(2, period);
                    ResultSet rs = selectStmt.executeQuery();
                    
                    if (rs.next()) {
                        System.out.println("📊 Updated installment details:");
                        System.out.println("   - Period: " + rs.getInt("installment_number"));
                        System.out.println("   - Due: " + String.format("%,.0f", rs.getDouble("amount_due")) + " VNĐ");
                        System.out.println("   - Paid: " + String.format("%,.0f", rs.getDouble("amount_paid")) + " VNĐ");
                        System.out.println("   - Status: " + rs.getString("status"));
                        System.out.println("   - Payment Date: " + rs.getTimestamp("payment_date"));
                    }
                }
                
                return true;
            } else {
                System.err.println("❌ No installment found to update for Bill " + billId + " Period " + period);
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error paying installment for bill " + billId + " period " + period + ": " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
} 