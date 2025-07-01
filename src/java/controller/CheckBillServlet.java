package controller;

import dao.BillDAO;
import model.Bill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet để kiểm tra và cập nhật bill
 */
@WebServlet("/checkBill")
public class CheckBillServlet extends HttpServlet {
    
    private BillDAO billDAO = new BillDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        String billId = request.getParameter("billId");
        String orderId = request.getParameter("orderId");
        
        // ENHANCED: Handle auto-update from payment page
        if ("autoUpdate".equals(action)) {
            handleAutoUpdate(request, response);
            return;
        } else if ("manualUpdate".equals(action)) {
            handleManualUpdate(request, response);
            return;
        }
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Bill Checker</title></head><body>");
        out.println("<h2>🔍 KIỂM TRA HÓA ĐƠN</h2>");
        
        try {
            if ("checkById".equals(action) && billId != null) {
                // Kiểm tra bill theo bill_id
                Bill bill = billDAO.getBillById(billId);
                displayBillInfo(out, bill, "Bill ID: " + billId);
                
            } else if ("checkByOrder".equals(action) && orderId != null) {
                // Kiểm tra bill theo order_id
                Bill bill = billDAO.getBillByOrderId(orderId);
                displayBillInfo(out, bill, "Order ID: " + orderId);
                
            } else if ("updateStatus".equals(action) && billId != null) {
                // Cập nhật trạng thái thành công
                boolean updated = billDAO.updatePaymentStatus(
                    billId, 
                    "success", 
                    "MB_BANK_" + System.currentTimeMillis(), 
                    "Payment completed via MB Bank app"
                );
                
                out.println("<div style='color: green; font-weight: bold;'>");
                if (updated) {
                    out.println("✅ ĐÃ CẬP NHẬT TRẠNG THÁI THÀNH CÔNG!");
                    
                    // Hiển thị bill sau khi update
                    Bill updatedBill = billDAO.getBillById(billId);
                    displayBillInfo(out, updatedBill, "Updated Bill: " + billId);
                } else {
                    out.println("❌ KHÔNG THỂ CẬP NHẬT!");
                }
                out.println("</div>");
                
            } else {
                // Form nhập liệu
                showCheckForm(out);
            }
            
        } catch (SQLException e) {
            out.println("<div style='color: red;'>");
            out.println("❌ LỖI DATABASE: " + e.getMessage());
            out.println("</div>");
            e.printStackTrace();
        }
        
        out.println("<hr>");
        out.println("<p><a href='checkBill'>🔄 Làm mới</a> | ");
        out.println("<a href='payment?serviceId=3&doctorId=1&workDate=2025-06-19&slotId=3005&reason=TEST+QR+SCAN'>💳 Tạo Bill Mới</a> | ");
        out.println("<a href='payment?serviceId=10'>💳 Payment Demo</a></p>");
        
        // JavaScript cho auto-refresh để phát hiện thanh toán
        out.println("<script>");
        out.println("// Auto-refresh mỗi 5 giây để kiểm tra trạng thái mới");
        out.println("setInterval(function() {");
        out.println("  // Chỉ refresh nếu có bills pending");
        out.println("  var pendingBills = document.querySelectorAll('[style*=\"#ffc107\"]');");
        out.println("  if (pendingBills.length > 0) {");
        out.println("    console.log('Kiểm tra auto-detect...');");
        out.println("    location.reload();");
        out.println("  }");
        out.println("}, 5000);");
        out.println("</script>");
        
        out.println("</body></html>");
    }
    
    /**
     * ENHANCED: Handle auto-update from payment page via AJAX
     */
    private void handleAutoUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String orderId = request.getParameter("orderId");
        String paymentRef = request.getParameter("paymentRef");
        
        if (orderId == null || orderId.isEmpty()) {
            out.println("{\"success\": false, \"message\": \"Missing orderId\"}");
            return;
        }
        
        try {
            BillDAO billDAO = new BillDAO();
            Bill bill = billDAO.getBillByOrderId(orderId);
            
            if (bill == null) {
                out.println("{\"success\": false, \"message\": \"Order not found\"}");
                return;
            }
            
            if ("success".equals(bill.getPaymentStatus())) {
                out.println("{\"success\": true, \"message\": \"Payment already completed\", \"status\": \"already_paid\"}");
                return;
            }
            
            // Update payment status to success
            String transactionId = "TEST_" + System.currentTimeMillis();
            if (paymentRef != null && !paymentRef.isEmpty()) {
                transactionId = paymentRef + "_" + System.currentTimeMillis();
            }
            
            boolean updated = billDAO.updatePaymentStatus(
                bill.getBillId(),
                "success",
                transactionId,
                "Test payment update - Manual trigger"
            );
            
            if (updated) {
                System.out.println("🧪 TEST UPDATE: Payment marked as success for " + orderId);
                out.println("{\"success\": true, \"message\": \"Payment marked as successful\", \"status\": \"success\"}");
            } else {
                out.println("{\"success\": false, \"message\": \"Failed to update payment status\"}");
            }
            
        } catch (Exception e) {
            System.err.println("❌ AUTO UPDATE ERROR: " + e.getMessage());
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }
    
    private void handleManualUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation of manual update logic
    }
    
    private void displayBillInfo(PrintWriter out, Bill bill, String title) {
        out.println("<h3>" + title + "</h3>");
        
        if (bill == null) {
            out.println("<div style='color: red; font-weight: bold;'>");
            out.println("❌ KHÔNG TÌM THẤY HÓA ĐƠN!");
            out.println("</div>");
            return;
        }
        
        out.println("<div style='background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
        out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
        
        out.println("<tr><td><strong>Bill ID:</strong></td><td>" + bill.getBillId() + "</td></tr>");
        out.println("<tr><td><strong>Order ID:</strong></td><td>" + bill.getOrderId() + "</td></tr>");
        out.println("<tr><td><strong>Khách hàng:</strong></td><td>" + bill.getCustomerName() + "</td></tr>");
        out.println("<tr><td><strong>Số điện thoại:</strong></td><td>" + bill.getCustomerPhone() + "</td></tr>");
        out.println("<tr><td><strong>Số tiền:</strong></td><td>" + bill.getFormattedAmount() + "</td></tr>");
        
        // Trạng thái thanh toán
        String statusColor = getStatusColor(bill.getPaymentStatus());
        out.println("<tr><td><strong>Trạng thái:</strong></td><td style='color: " + statusColor + "; font-weight: bold;'>");
        out.println(getStatusText(bill.getPaymentStatus()));
        out.println("</td></tr>");
        
        out.println("<tr><td><strong>Phương thức:</strong></td><td>" + bill.getPaymentMethod() + "</td></tr>");
        out.println("<tr><td><strong>Ngày tạo:</strong></td><td>" + 
                   (bill.getCreatedAt() != null ? bill.getCreatedAt().toString() : "N/A") + "</td></tr>");
        out.println("<tr><td><strong>Ngày thanh toán:</strong></td><td>" + 
                   (bill.getPaidAt() != null ? bill.getPaidAt().toString() : "Chưa thanh toán") + "</td></tr>");
        
        out.println("</table>");
        out.println("</div>");
        
        // Nút cập nhật trạng thái
        if ("pending".equals(bill.getPaymentStatus())) {
            out.println("<div style='margin: 10px 0;'>");
            out.println("<a href='checkBill?action=updateStatus&billId=" + bill.getBillId() + "' ");
            out.println("style='background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>");
            out.println("✅ ĐÁNH DẤU ĐÃ THANH TOÁN</a>");
            out.println("</div>");
        }
    }
    
    private void showCheckForm(PrintWriter out) {
        out.println("<h3>📋 FORM KIỂM TRA</h3>");
        
        // Hiển thị tất cả bills gần nhất
        out.println("<div style='background: #e7f3ff; padding: 15px; margin: 10px 0; border-radius: 5px;'>");
        out.println("<h4>🕒 HÓA ĐƠN GẦN NHẤT:</h4>");
        out.println("<div style='background: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; margin: 10px 0; border-radius: 5px;'>");
        out.println("<strong>📱 HƯỚNG DẪN:</strong> Quét QR trên điện thoại → Chờ 3 giây → Hệ thống tự động phát hiện thanh toán thành công");
        out.println("</div>");
        
        try {
            // Lấy 5 bills gần nhất từ database
            java.util.List<Bill> recentBills = billDAO.getRecentBills(5);
            if (recentBills != null && !recentBills.isEmpty()) {
                for (Bill bill : recentBills) {
                    String statusColor = getStatusColor(bill.getPaymentStatus());
                    out.println("<div style='border: 1px solid #ddd; margin: 5px 0; padding: 10px; border-radius: 3px;'>");
                    out.println("<p><strong>Bill ID:</strong> " + bill.getBillId() + " | ");
                    out.println("<strong>Order ID:</strong> " + bill.getOrderId() + "</p>");
                    out.println("<p><strong>Số tiền:</strong> " + bill.getFormattedAmount() + " | ");
                    out.println("<span style='color: " + statusColor + "; font-weight: bold;'>" + getStatusText(bill.getPaymentStatus()) + "</span></p>");
                    out.println("<p><a href='checkBill?action=checkById&billId=" + bill.getBillId() + "' style='color: #007bff;'>🔍 Kiểm tra</a>");
                    
                    // Nút manual update nếu đang pending - CHỈ KHI CẦN THIẾT
                    if ("pending".equals(bill.getPaymentStatus())) {
                        out.println(" | <small style='color: #666;'>⏳ Chờ auto-detect sau khi quét QR (3s)</small>");
                        
                        // Nút manual backup - chỉ hiện sau 5 phút
                        java.sql.Timestamp createdAt = bill.getCreatedAt();
                        if (createdAt != null) {
                            long timeDiff = System.currentTimeMillis() - createdAt.getTime();
                            if (timeDiff > 5 * 60 * 1000) { // 5 phút
                                out.println("<br><a href='checkBill?action=updateStatus&billId=" + bill.getBillId() + "' " +
                                           "style='color: #dc3545; font-size: 12px;' " +
                                           "onclick='return confirm(\"QR không hoạt động? Đánh dấu thủ công?\")'>❗ Manual Override (5+ phút)</a>");
                            }
                        }
                    }
                    out.println("</p></div>");
                }
            } else {
                out.println("<p>Không có hóa đơn nào trong hệ thống.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>Lỗi khi lấy danh sách bills: " + e.getMessage() + "</p>");
        }
        
        out.println("</div>");
        
        out.println("<form method='get'>");
        out.println("<p><strong>Kiểm tra theo Bill ID:</strong></p>");
        out.println("<input type='hidden' name='action' value='checkById'>");
        out.println("<input type='text' name='billId' placeholder='BILL_XXXXXXXX' style='padding: 5px; width: 200px;'>");
        out.println("<input type='submit' value='Kiểm tra' style='padding: 5px 15px; margin-left: 10px;'>");
        out.println("</form>");
        
        out.println("<form method='get' style='margin-top: 10px;'>");
        out.println("<p><strong>Kiểm tra theo Order ID:</strong></p>");
        out.println("<input type='hidden' name='action' value='checkByOrder'>");
        out.println("<input type='text' name='orderId' placeholder='ORDER_XXXXXXXXXXXXX' style='padding: 5px; width: 200px;'>");
        out.println("<input type='submit' value='Kiểm tra' style='padding: 5px 15px; margin-left: 10px;'>");
        out.println("</form>");
    }
    
    private String getStatusColor(String status) {
        switch (status) {
            case "success": return "#28a745";
            case "pending": return "#ffc107";
            case "cancelled": return "#dc3545";
            case "failed": return "#dc3545";
            default: return "#6c757d";
        }
    }
    
    private String getStatusText(String status) {
        switch (status) {
            case "success": return "✅ ĐÃ THANH TOÁN";
            case "pending": return "⏳ ĐANG CHỜ";
            case "cancelled": return "❌ ĐÃ HỦY";
            case "failed": return "❌ THẤT BẠI";
            default: return status.toUpperCase();
        }
    }
} 