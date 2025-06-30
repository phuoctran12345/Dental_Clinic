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
        out.println("<a href='payment?serviceId=10'>💳 Quay về Payment</a></p>");
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
        String paymentRef = request.getParameter("paymentRef"); // Từ app banking
        
        if (orderId == null || orderId.isEmpty()) {
            out.println("{\"success\": false, \"message\": \"Missing orderId\"}");
            return;
        }
        
        try {
            // Tìm bill theo order ID
            Bill bill = billDAO.getBillByOrderId(orderId);
            
            if (bill == null) {
                out.println("{\"success\": false, \"message\": \"Bill not found\"}");
                return;
            }
            
            // Kiểm tra nếu đã thanh toán rồi
            if ("success".equals(bill.getPaymentStatus())) {
                out.println("{\"success\": true, \"message\": \"Already paid\", \"status\": \"success\"}");
                return;
            }
            
            // Cập nhật trạng thái thành công
            String transactionId = "AUTO_" + System.currentTimeMillis();
            if (paymentRef != null && !paymentRef.isEmpty()) {
                transactionId = "MBBANK_" + paymentRef;
            }
            
            boolean updated = billDAO.updatePaymentStatus(
                bill.getBillId(),
                "success",
                transactionId,
                "Auto-detected payment completion"
            );
            
            if (updated) {
                System.out.println("🎉 Auto-updated payment status for: " + bill.getBillId());
                out.println("{\"success\": true, \"message\": \"Payment status updated\", \"status\": \"success\"}");
            } else {
                out.println("{\"success\": false, \"message\": \"Failed to update status\"}");
            }
            
        } catch (SQLException e) {
            System.err.println("Error in auto-update: " + e.getMessage());
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"Database error: " + e.getMessage() + "\"}");
        }
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
        
        // Recent Bill ID từ logs
        out.println("<div style='background: #e7f3ff; padding: 15px; margin: 10px 0; border-radius: 5px;'>");
        out.println("<h4>🕒 HÓA ĐƠN GẦN NHẤT (từ logs):</h4>");
        out.println("<p><strong>Bill ID:</strong> BILL_8FF18D1F</p>");
        out.println("<p><strong>Order ID:</strong> ORDER_1749720539871</p>");
        out.println("<p><strong>Số tiền:</strong> 2,000 VND</p>");
        out.println("<p><a href='checkBill?action=checkById&billId=BILL_8FF18D1F' style='color: #007bff;'>🔍 Kiểm tra Bill này</a></p>");
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