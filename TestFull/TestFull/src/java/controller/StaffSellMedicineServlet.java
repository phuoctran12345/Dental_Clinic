package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.MedicineDAO;
import dao.BillDAO;
import dao.ServiceDAO;
import model.Medicine;
import model.Bill;
import model.User;
import model.Service;

/**
 * Servlet bán thuốc với UI thực tế
 */
@WebServlet(name = "StaffSellMedicineServlet", urlPatterns = {"/StaffSellMedicineServlet"})
public class StaffSellMedicineServlet extends HttpServlet {

    /**
     * GET - Hiển thị trang bán thuốc
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Load danh sách thuốc
            MedicineDAO medicineDAO = new MedicineDAO();
            List<Medicine> medicines = medicineDAO.getAllMedicine();
            if (medicines == null) {
                medicines = new ArrayList<>(); // Khởi tạo danh sách rỗng nếu null
                request.setAttribute("errorMessage", "Không tải được danh sách thuốc.");
            }
            request.setAttribute("medicines", medicines);
            
            // Forward tới JSP
            String jspPath = "/jsp/staff/staff_toathuoc.jsp";
            request.getRequestDispatcher(jspPath).forward(request, response);
            
        }catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
        // Trang lỗi tùy chỉnh
        
    }

    /**
     * POST - Tạo hóa đơn bán thuốc ĐƠN GIẢN
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Kiểm tra session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                out.println("{\"success\": false, \"message\": \"Vui lòng đăng nhập!\"}");
                return;
            }
            
            // Lấy thông tin ĐƠN GIẢN
            String customerName = request.getParameter("customer_name");
            String[] medicineIds = request.getParameterValues("medicine_id");
            String[] quantities = request.getParameterValues("quantity");
            
            // Validation đơn giản
            if (medicineIds == null || medicineIds.length == 0) {
                out.println("{\"success\": false, \"message\": \"Vui lòng chọn thuốc!\"}");
                return;
            }
            
            // Nếu không có tên khách hàng, dùng mặc định
            if (customerName == null || customerName.trim().isEmpty()) {
                customerName = "Khách mua thuốc";
            }
            
            // Tính tổng tiền và tạo chi tiết
            BigDecimal totalAmount = BigDecimal.ZERO;
            StringBuilder medicineDetails = new StringBuilder();
            medicineDetails.append("=== BÁN THUỐC ===\n");
            medicineDetails.append("Ngày: ").append(new java.util.Date()).append("\n");
            medicineDetails.append("Nhân viên: ").append(user.getUsername()).append("\n\n");
            
            MedicineDAO medicineDAO = new MedicineDAO();
            
            for (int i = 0; i < medicineIds.length; i++) {
                int medicineId = Integer.parseInt(medicineIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                
                Medicine medicine = medicineDAO.getMedicineById(medicineId);
                if (medicine != null && medicine.getQuantityInStock() >= quantity) {
                    BigDecimal price = new BigDecimal("10000"); // 10,000 VND per unit
                    BigDecimal itemTotal = price.multiply(new BigDecimal(quantity));
                    totalAmount = totalAmount.add(itemTotal);
                    
                    medicineDetails.append(String.format("• %s x %d %s = %,d VND\n", 
                        medicine.getName(), quantity, 
                        medicine.getUnit() != null ? medicine.getUnit() : "viên", 
                        itemTotal.longValue()));
                    
                    // Cập nhật tồn kho
                    medicineDAO.reduceMedicineStock(medicineId, quantity);
                }
            }
            
            medicineDetails.append(String.format("\nTỔNG CỘNG: %,d VND", totalAmount.longValue()));
            
            // LƯU ĐƠN GIẢN - CHỈ TỔNG TIỀN
            BillDAO billDAO = new BillDAO();
            boolean saved = billDAO.createSimpleSale(user.getUserId(), totalAmount, medicineDetails.toString(), customerName.trim());
            
            if (saved) {
                // Trả về thông tin để in bill
                String jsonResponse = String.format(
                        "{\"success\": true, " +
                        "\"message\": \"Bán hàng thành công!\", " +
                        "\"billId\": \"%s\", " +
                        "\"customerName\": \"%s\", " +
                        "\"totalAmount\": %d, " +
                        "\"medicineDetails\": \"%s\"}",
                        "BILL" + System.currentTimeMillis(),
                        customerName.replace("\"", "\\\""),
                        totalAmount.longValue(),
                        medicineDetails.toString().replace("\"", "\\\"").replace("\n", "\\n")
                );
                
                out.println(jsonResponse);
            } else {
                out.println("{\"success\": false, \"message\": \"Lỗi lưu dữ liệu!\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
    
    /**
     * Chuyển đổi payment method thành text hiển thị
     */
    private String getPaymentMethodText(String method) {
        if (method == null) return "Tiền mặt";
        switch (method) {
            case "CASH": return "Tiền mặt";
            case "BANK_TRANSFER": return "Chuyển khoản";
            case "CARD": return "Thẻ";
            case "MOMO": return "MoMo";
            case "ZALOPAY": return "ZaloPay";
            default: return "Tiền mặt";
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet bán thuốc với UI thực tế";
    }
}