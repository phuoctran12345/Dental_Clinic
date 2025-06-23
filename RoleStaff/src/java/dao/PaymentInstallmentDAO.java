package dao;

import model.PaymentInstallment;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentInstallmentDAO {
    
    /**
     * Tạo kế hoạch trả góp cho hóa đơn
     */
    public boolean createInstallmentPlan(String billId, double totalAmount, double downPayment, int installmentCount) {
        try (Connection conn = DBContext.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_CreateInstallmentPlan(?, ?, ?, ?, ?)}")) {
            
            stmt.setString(1, billId);
            stmt.setBigDecimal(2, new java.math.BigDecimal(totalAmount));
            stmt.setBigDecimal(3, new java.math.BigDecimal(downPayment));
            stmt.setInt(4, installmentCount);
            stmt.setBigDecimal(5, new java.math.BigDecimal(0.0)); // Lãi suất 0%
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String result = rs.getString("result");
                System.out.println("✅ Created installment plan: " + result);
                return "SUCCESS".equals(result);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error creating installment plan: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Thanh toán một kỳ
     */
    public boolean payInstallment(int installmentId, double amountPaid, String paymentMethod, String transactionId) {
        try (Connection conn = DBContext.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_PayInstallment(?, ?, ?, ?)}")) {
            
            stmt.setInt(1, installmentId);
            stmt.setBigDecimal(2, new java.math.BigDecimal(amountPaid));
            stmt.setString(3, paymentMethod);
            stmt.setString(4, transactionId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String result = rs.getString("result");
                System.out.println("✅ Paid installment: " + result);
                return "SUCCESS".equals(result);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error paying installment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy danh sách kỳ trả góp theo bill_id
     */
    public List<PaymentInstallment> getInstallmentsByBillId(String billId) {
        List<PaymentInstallment> installments = new ArrayList<>();
        String sql = "SELECT * FROM PaymentInstallments WHERE bill_id = ? ORDER BY installment_number";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                PaymentInstallment installment = new PaymentInstallment();
                installment.setInstallmentId(rs.getInt("installment_id"));
                installment.setBillId(rs.getString("bill_id"));
                installment.setTotalAmount(rs.getDouble("total_amount"));
                installment.setDownPayment(rs.getDouble("down_payment"));
                installment.setInstallmentCount(rs.getInt("installment_count"));
                installment.setInstallmentNumber(rs.getInt("installment_number"));
                installment.setDueDate(rs.getDate("due_date"));
                installment.setAmountDue(rs.getDouble("amount_due"));
                installment.setAmountPaid(rs.getDouble("amount_paid"));
                installment.setRemainingAmount(rs.getDouble("remaining_amount"));
                installment.setPaymentDate(rs.getDate("payment_date"));
                installment.setStatus(rs.getString("status"));
                installment.setPaymentMethod(rs.getString("payment_method"));
                installment.setTransactionId(rs.getString("transaction_id"));
                installment.setLateFee(rs.getDouble("late_fee"));
                installment.setNotes(rs.getString("notes"));
                
                installments.add(installment);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting installments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return installments;
    }
    
    /**
     * Lấy tất cả kỳ trả góp cần nhắc nợ
     */
    public List<PaymentInstallment> getRemindersNeeded() {
        List<PaymentInstallment> reminders = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_GetRemindersNeeded}")) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                PaymentInstallment installment = new PaymentInstallment();
                installment.setInstallmentId(rs.getInt("installment_id"));
                installment.setBillId(rs.getString("bill_id"));
                installment.setCustomerName(rs.getString("customer_name"));
                installment.setCustomerPhone(rs.getString("customer_phone"));
                installment.setInstallmentNumber(rs.getInt("installment_number"));
                installment.setDueDate(rs.getDate("due_date"));
                installment.setAmountDue(rs.getDouble("amount_due"));
                installment.setRemainingAmount(rs.getDouble("remaining_amount"));
                installment.setDaysUntilDue(rs.getInt("days_until_due"));
                installment.setReminderType(rs.getString("reminder_type"));
                
                reminders.add(installment);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting reminders: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reminders;
    }
    
    /**
     * Cập nhật trạng thái quá hạn
     */
    public int updateOverdueInstallments() {
        try (Connection conn = DBContext.getConnection()) {
            // Thử với stored procedure trước
            try (CallableStatement stmt = conn.prepareCall("{CALL sp_UpdateOverdueInstallments}")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int updated = rs.getInt("overdue_installments_updated");
                    System.out.println("✅ Updated " + updated + " overdue installments using stored procedure");
                    return updated;
                }
            } catch (SQLException spException) {
                System.out.println("⚠️ Stored procedure not available, using fallback query");
                // Fallback với SQL thường
                String sql = "UPDATE PaymentInstallments SET status = 'overdue' WHERE due_date < GETDATE() AND status = 'pending'";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    int updated = stmt.executeUpdate();
                    System.out.println("✅ Updated " + updated + " overdue installments using fallback");
                    return updated;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating overdue installments: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lấy tóm tắt kế hoạch trả góp
     */
    public PaymentInstallment getInstallmentSummary(String billId) {
        String sql = "SELECT * FROM vw_InstallmentSummary WHERE bill_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                PaymentInstallment summary = new PaymentInstallment();
                summary.setBillId(rs.getString("bill_id"));
                summary.setTotalAmount(rs.getDouble("total_amount"));
                summary.setDownPayment(rs.getDouble("down_payment"));
                summary.setInstallmentCount(rs.getInt("total_installments"));
                summary.setPaidInstallments(rs.getInt("paid_installments"));
                summary.setOverdueInstallments(rs.getInt("overdue_installments"));
                summary.setPendingInstallments(rs.getInt("pending_installments"));
                summary.setTotalPaid(rs.getDouble("total_paid"));
                summary.setTotalRemaining(rs.getDouble("total_remaining"));
                summary.setTotalLateFees(rs.getDouble("total_late_fees"));
                summary.setNextDueDate(rs.getDate("next_due_date"));
                summary.setPlanStatus(rs.getString("plan_status"));
                
                return summary;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting installment summary: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
} 