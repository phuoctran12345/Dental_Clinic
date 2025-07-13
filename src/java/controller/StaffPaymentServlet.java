package controller;

import dao.BillDAO;
import dao.PatientDAO;
import dao.AppointmentDAO;
import dao.PaymentInstallmentDAO;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bill;
import model.Patients;
import model.Appointment;
import model.PaymentInstallment;
import model.Service;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import com.google.gson.Gson;
import java.util.logging.Level;
import java.util.logging.Logger;
  import jakarta.servlet.ServletException;
  import jakarta.servlet.http.HttpServletRequest;
  import jakarta.servlet.http.HttpServletResponse;

// @WebServlet annotation removed - using web.xml mapping instead
public class StaffPaymentServlet extends HttpServlet {

    // Performance monitoring
    private static final AtomicInteger totalRequests = new AtomicInteger(0);
    private static final AtomicInteger successfulRequests = new AtomicInteger(0);
    private static final AtomicInteger failedRequests = new AtomicInteger(0);
    
    /**
     * Get servlet performance statistics
     */
    public static String getServletStats() {
        int total = totalRequests.get();
        int success = successfulRequests.get();
        int failed = failedRequests.get();
        double successRate = total > 0 ? (double) success / total * 100.0 : 0.0;
        
        return String.format("StaffPaymentServlet Stats - Total: %d, Success: %d (%.1f%%), Failed: %d", 
                           total, success, successRate, failed);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        totalRequests.incrementAndGet();
        long startTime = System.currentTimeMillis();
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("getQR".equals(action)) {
            handleGetQR(request, response);
            return;
        }

        try {
            if ("payments".equals(action)) {
                handlePaymentManagement(request, response);
            } else if ("create".equals(action)) {
                handleCreateInvoice(request, response);
            } else if ("view".equals(action)) {
                handleViewInvoice(request, response);
            } else if ("installments".equals(action)) {
                handleInstallmentManagement(request, response);
            } else if ("installment_detail".equals(action)) {
                // This action will be removed. Redirect to the main installment page.
                response.sendRedirect(request.getContextPath() + "/StaffPaymentServlet?action=installments");
                return;
            } else if ("reminders".equals(action)) {
                handleReminders(request, response);
            } else {
                // Mặc định hiển thị trang quản lý thanh toán
                handlePaymentManagement(request, response);
            }
            
            // Success monitoring
            successfulRequests.incrementAndGet();
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("✅ doGet completed successfully in " + duration + "ms - Action: " + action);
            
        } catch (Exception e) {
            failedRequests.incrementAndGet();
            long duration = System.currentTimeMillis() - startTime;
            System.err.println("❌ doGet failed after " + duration + "ms - Action: " + action + " - Error: " + e.getMessage());
            e.printStackTrace();
            
            // Kiểm tra response đã committed chưa trước khi forward
            if (!response.isCommitted()) {
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
            } else {
                System.err.println("❌ Cannot forward - response already committed. Error: " + e.getMessage());
            }
        }
    }

    private void handleGetQR(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String billId = request.getParameter("billId");
        System.out.println("[DEBUG][getQR] billId=" + billId);
        if (billId == null || billId.trim().isEmpty()) {
            System.out.println("[DEBUG][getQR] Thiếu billId");
            response.getWriter().write("{\"success\":false,\"message\":\"Thiếu billId\"}");
            return;
        }
        BillDAO billDAO = new BillDAO();
        Bill bill = null;
        try {
            bill = billDAO.getBillById(billId);
        } catch (Exception ex) {
            System.out.println("[DEBUG][getQR] SQLException: " + ex.getMessage());
            ex.printStackTrace();
        }
        System.out.println("[DEBUG][getQR] bill object: " + bill);
        if (bill == null) {
            System.out.println("[DEBUG][getQR] Không tìm thấy hóa đơn");
            response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy hóa đơn\"}");
            return;
        }

        //==========================================
        // Gọi PayOSUtil để lấy QR code thật
        String qrUrl = utils.PayOSUtil.createPayOSPaymentRequestForStaff(bill, bill.getServiceName());
        System.out.println("[DEBUG][getQR] qrUrl: " + qrUrl);
        if (qrUrl == null || qrUrl.isEmpty()) {
            System.out.println("[DEBUG][getQR] Không tạo được mã QR! (qrUrl null hoặc rỗng)");
            response.getWriter().write("{\"success\":false,\"message\":\"Không tạo được mã QR!\"}");
            return;
        }
        response.getWriter().write("{\"success\":true,\"qrUrl\":\"" + qrUrl + "\"}");
        //==========================================
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[DEBUG][doPost] BẮT ĐẦU doPost - action=" + request.getParameter("action"));
        totalRequests.incrementAndGet();
        long startTime = System.currentTimeMillis();
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        System.out.println("🚀 doPost called with action: " + action);
        System.out.println("📋 Request URL: " + request.getRequestURL());
        System.out.println("📋 Context Path: " + request.getContextPath());
        System.out.println("📋 Servlet Path: " + request.getServletPath());

        // Đảm bảo không response bị commit sớm
        if ("createBill".equals(action)) {
            System.out.println("📋 Setting JSON content type for createBill action");
            response.setContentType("application/json;charset=UTF-8");
            response.setHeader("Cache-Control", "no-cache");
        }
        
        // Thêm action mới trong doPost để staff xác nhận đã nhận tiền chuyển khoản
        if ("confirmBankTransfer".equals(action)) {
            String billId = request.getParameter("billId");
            if (billId == null || billId.trim().isEmpty()) {
                sendJsonResponse(response, false, "Thiếu billId để xác nhận chuyển khoản", null);
                return;
            }
            BillDAO billDAO = new BillDAO();
            Bill bill = null;
                try {
                    bill = billDAO.getBillById(billId);
                } catch (SQLException ex) {
                    Logger.getLogger(StaffPaymentServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            if (bill == null) {
                sendJsonResponse(response, false, "Không tìm thấy hóa đơn để xác nhận", null);
                return;
            }
            if ("bank_transfer".equalsIgnoreCase(bill.getPaymentMethod()) &&
                ("PENDING".equalsIgnoreCase(bill.getPaymentStatus()) || "pending".equalsIgnoreCase(bill.getPaymentStatus()))) {
                boolean updated = false;
                try {
                    updated = billDAO.updatePaymentStatus(billId, "PAID");
                } catch (SQLException ex) {
                    Logger.getLogger(StaffPaymentServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (updated) {
                    sendJsonResponse(response, true, "Đã xác nhận thanh toán chuyển khoản thành công!", billId);
                } else {
                    sendJsonResponse(response, false, "Không thể cập nhật trạng thái hóa đơn!", null);
                }
            } else {
                sendJsonResponse(response, false, "Hóa đơn không ở trạng thái chờ chuyển khoản hoặc không phải chuyển khoản!", null);
            }
            return;
        }

        try {
            if ("createBill".equals(action)) {
                System.out.println("[DEBUG][doPost] Xử lý createBill - chỉ trả về JSON!");
                handleCreateBillFromModal(request, response);
                return; // Quan trọng: return ngay để không tiếp tục xử lý
            } else if ("process_payment".equals(action)) {
                handleProcessPayment(request, response);
            } else if ("create_invoice".equals(action)) {
                handleCreateNewInvoice(request, response);
            } else if ("create_installment".equals(action)) {
                handleCreateInstallment(request, response);
            } else if ("pay_installment".equals(action) || "payInstallment".equals(action)) {
                handlePayInstallment(request, response);
            } else if ("payOffInstallment".equals(action)) {
                handlePayOffInstallment(request, response);
            } else {
                // For non-AJAX requests, forward to JSP
                System.out.println("📋 No matching action, forwarding to doGet");
                doGet(request, response);
            }
            
            // Success monitoring (only if no exception thrown)
            successfulRequests.incrementAndGet();
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("✅ doPost completed successfully in " + duration + "ms - Action: " + action);
            
        } catch (Exception e) {
            System.err.println("[DEBUG][doPost] CATCH-ALL EXCEPTION: " + e.getMessage());
            failedRequests.incrementAndGet();
            long duration = System.currentTimeMillis() - startTime;
            System.err.println("❌ doPost failed after " + duration + "ms - Action: " + action + " - Error: " + e.getMessage());
            e.printStackTrace();
            System.err.println("❌ Error in doPost: " + e.getMessage());
            System.err.println("❌ Error type: " + e.getClass().getSimpleName());

            // Nếu là AJAX request (createBill), trả về JSON error
            if ("createBill".equals(action)) {
                System.err.println("❌ Sending JSON error response for createBill");
                if (!response.isCommitted()) {
                    try {
                        response.reset(); // Reset response nếu có thể
                        response.setContentType("application/json;charset=UTF-8");
                        response.setHeader("Cache-Control", "no-cache");
                        sendJsonResponse(response, false, "Lỗi server: " + e.getMessage(), null);
                    } catch (Exception jsonError) {
                        System.err.println("❌ Failed to send JSON error: " + jsonError.getMessage());
                        // Fallback: gửi text response
                        response.setContentType("text/plain;charset=UTF-8");
                        response.getWriter().write("Error: " + e.getMessage());
                    }
                } else {
                    System.err.println("❌ Cannot send JSON error - response already committed");
                }
            } else {
                // Nếu không phải AJAX, forward tới error page
                if (!response.isCommitted()) {
                    request.setAttribute("error", "Có lỗi khi xử lý thanh toán: " + e.getMessage());
                    try {
                        handlePaymentManagement(request, response);
                    } catch (Exception ex) {
                        System.err.println("❌ Error in handlePaymentManagement: " + ex.getMessage());
                    }
                }
            }
        }
    }

    /**
     * Xử lý trang quản lý thanh toán
     */
    private void handlePaymentManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long startTime = System.currentTimeMillis();
        try {
            System.out.println("💰 LOADING PAYMENT MANAGEMENT PAGE...");

            // Kiểm tra session timeout
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // Lấy danh sách hóa đơn từ database
            System.out.println("⏱️ Step 1: Starting to load bills and services...");
            BillDAO billDAO = new BillDAO();
            ServiceDAO serviceDAO = new ServiceDAO();

            // Load bills and services in parallel
            List<Bill> allBills = billDAO.getAllBills();
            List<Service> activeServices = serviceDAO.getActiveServices();

            System.out.println("📋 Step 2: Loaded " + allBills.size() + " bills and "
                    + activeServices.size() + " services in "
                    + (System.currentTimeMillis() - startTime) + "ms");

            // Log some services info
            if (!activeServices.isEmpty()) {
                System.out.println("🏥 Available services:");
                activeServices.stream().limit(5).forEach(service
                        -> System.out.println("  - " + service.getServiceName() + ": "
                                + String.format("%,.0f", service.getPrice()) + " VNĐ (" + service.getCategory() + ")")
                );
                if (activeServices.size() > 5) {
                    System.out.println("  ... and " + (activeServices.size() - 5) + " more services");
                }
            }

            // Tối ưu hóa: Sử dụng thông tin có sẵn thay vì query từng bill
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            // Map để cache số nợ còn lại của từng bill gốc, tránh query lặp lại
            java.util.Map<String, Double> parentBillRemainingMap = new java.util.HashMap<>();
            for (Bill bill : allBills) {
                try {
                    // Sử dụng customer_name và customer_phone có sẵn từ Bills table
                    if (bill.getPatientName() == null && bill.getCustomerName() != null) {
                        bill.setPatientName(bill.getCustomerName());
                    }

                    if (bill.getPatientPhone() == null && bill.getCustomerPhone() != null) {
                        bill.setPatientPhone(bill.getCustomerPhone());
                    }

                    // Set default values nếu thiếu thông tin
                    if (bill.getPatientName() == null) {
                        bill.setPatientName("Khách hàng " + bill.getBillId());
                    }
                    if (bill.getPatientPhone() == null) {
                        bill.setPatientPhone("Chưa có SĐT");
                    }
                    if (bill.getServiceName() == null) {
                        bill.setServiceName("Dịch vụ nha khoa");
                    }

                    // Nếu bill là bill trả góp, enrich số nợ còn lại từ summary
                    if ("INSTALLMENT".equalsIgnoreCase(bill.getPaymentStatus())) {
                        PaymentInstallment summary = installmentDAO.getInstallmentSummary(bill.getBillId());
                        if (summary != null) {
                            bill.setTotalRemaining(summary.getTotalRemaining());
                            System.out.println("[DEBUG] Bill trả góp: " + bill.getBillId() + " | totalRemaining: " + summary.getTotalRemaining());
                        }
                    }
                    // Nếu bill là bill con trả góp, luôn lấy số nợ còn lại của bill gốc (cache theo parentBillId)
                    if (bill.getParentBillId() != null && !bill.getParentBillId().isEmpty()) {
                        double parentTotalRemaining;
                        if (parentBillRemainingMap.containsKey(bill.getParentBillId())) {
                            parentTotalRemaining = parentBillRemainingMap.get(bill.getParentBillId());
                        } else {
                            parentTotalRemaining = installmentDAO.getTotalRemainingAmount(bill.getParentBillId());
                            parentBillRemainingMap.put(bill.getParentBillId(), parentTotalRemaining);
                        }
                        bill.setTotalRemaining(parentTotalRemaining); // Luôn là số nợ còn lại của bill gốc
                        System.out.println("[DEBUG] Bill con: " + bill.getBillId() + " | Bill gốc: " + bill.getParentBillId() + " | totalRemaining: " + parentTotalRemaining);
                    } else if (!"INSTALLMENT".equalsIgnoreCase(bill.getPaymentStatus())) {
                        // Bill gốc không phải trả góp: lấy số nợ còn lại nếu có
                        double selfRemaining = installmentDAO.getTotalRemainingAmount(bill.getBillId());
                        bill.setTotalRemaining(selfRemaining);
                        System.out.println("[DEBUG] Bill gốc: " + bill.getBillId() + " | totalRemaining: " + selfRemaining);
                    }

                } catch (Exception e) {
                    System.err.println("❌ Error processing bill " + bill.getBillId() + ": " + e.getMessage());
                    // Set minimal default values
                    bill.setPatientName("Khách hàng " + bill.getBillId());
                    bill.setPatientPhone("Chưa có SĐT");
                    bill.setServiceName("Dịch vụ nha khoa");
                }
            }

            // Tính toán statistics theo thời gian thực
            double totalRevenue = 0;
            double paidAmount = 0;
            double pendingAmount = 0;
            double partialAmount = 0;

            for (Bill bill : allBills) {
                double billAmount = bill.getAmount() != null ? bill.getAmount().doubleValue() : 0.0;
                totalRevenue += billAmount;

                String status = bill.getPaymentStatus();
                if ("PAID".equals(status) || "success".equals(status) || "Đã thanh toán".equals(status)) {
                    paidAmount += billAmount;
                } else if ("PENDING".equals(status) || "pending".equals(status) || "WAITING_PAYMENT".equals(status)) {
                    pendingAmount += billAmount;
                } else if ("PARTIAL".equals(status) || "partial".equals(status) || "Thanh toán một phần".equals(status)) {
                    paidAmount += billAmount * 0.5; // Giả sử trả 50%
                    partialAmount += billAmount * 0.5;
                }
            }

            long statTime = System.currentTimeMillis();
            System.out.println("⏱️ Step 3: Calculating stats...");
            System.out.println("📊 PAYMENT STATS:");
            System.out.println("  - Total Revenue: " + totalRevenue + " VNĐ");
            System.out.println("  - Paid Amount: " + paidAmount + " VNĐ");
            System.out.println("  - Pending Amount: " + pendingAmount + " VNĐ");
            System.out.println("  - Partial Amount: " + partialAmount + " VNĐ");
            System.out.println("⏱️ Step 4: Stats calculated in " + (System.currentTimeMillis() - statTime) + "ms");

            // Gửi dữ liệu cho JSP
            request.setAttribute("bills", allBills);
            request.setAttribute("services", activeServices);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("paidAmount", paidAmount);
            request.setAttribute("pendingAmount", pendingAmount);
            request.setAttribute("partialAmount", partialAmount);
            request.setAttribute("totalBills", allBills.size());

            long totalTime = System.currentTimeMillis() - startTime;
            System.out.println("✅ Step 5: Total processing time: " + totalTime + "ms");
            System.out.println("🚀 Forwarding to payment JSP with " + allBills.size() + " bills");

            // Forward đến trang quản lý thanh toán
            request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Kiểm tra response đã committed chưa trước khi forward
            if (!response.isCommitted()) {
                request.setAttribute("error", "Có lỗi khi tải dữ liệu thanh toán: " + e.getMessage());
                // Clear bills list để tránh lỗi trong JSP
                request.setAttribute("bills", new ArrayList<Bill>());
                request.setAttribute("services", new ArrayList<Service>());
                request.setAttribute("totalRevenue", 0.0);
                request.setAttribute("paidAmount", 0.0);
                request.setAttribute("pendingAmount", 0.0);
                request.setAttribute("partialAmount", 0.0);
                request.setAttribute("totalBills", 0);

                request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
            } else {
                System.err.println("❌ Cannot forward from handlePaymentManagement - response already committed. Error: " + e.getMessage());
            }
        }
    }

    private void handleProcessPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int billId = Integer.parseInt(request.getParameter("billId"));
            String paymentMethod = request.getParameter("paymentMethod");
            double paidAmount = Double.parseDouble(request.getParameter("paidAmount"));
            String notes = request.getParameter("notes");

            // Cập nhật thanh toán vào database
            BillDAO billDAO = new BillDAO();
            boolean success = billDAO.updatePayment(billId, paidAmount, paymentMethod, notes);

            if (success) {
                request.setAttribute("successMessage", "Cập nhật thanh toán thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi khi cập nhật thanh toán!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý thanh toán: " + e.getMessage());
        }

        // Quay lại trang quản lý
        handlePaymentManagement(request, response);
    }

    private void handleCreateInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters for new invoice
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String serviceIds = request.getParameter("serviceIds"); // Comma-separated service IDs
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");
            
            if (customerName == null || customerPhone == null || serviceIds == null) {
                request.setAttribute("errorMessage", "Thiếu thông tin bắt buộc để tạo hóa đơn!");
                handlePaymentManagement(request, response);
                return;
            }
            
            // Calculate total amount from selected services
            ServiceDAO serviceDAO = new ServiceDAO();
            double totalAmount = 0.0;
            String[] serviceIdArray = serviceIds.split(",");
            StringBuilder serviceNames = new StringBuilder();
            
            for (String serviceId : serviceIdArray) {
                try {
                    Service service = serviceDAO.getServiceById(Integer.parseInt(serviceId.trim()));
                    if (service != null) {
                        totalAmount += service.getPrice();
                        if (serviceNames.length() > 0) {
                            serviceNames.append(", ");
                        }
                        serviceNames.append(service.getServiceName());
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid service ID: " + serviceId);
                }
            }
            
            // Create new bill
            BillDAO billDAO = new BillDAO();
            String billId = "BILL" + System.currentTimeMillis(); // Generate unique bill ID
            
            Bill newBill = createBillObject(billId, customerName, customerPhone, 
                    totalAmount, "PENDING", paymentMethod != null ? paymentMethod : "CASH", 
                    notes, serviceIdArray.length > 0 ? serviceIdArray[0] : "1");
            
            Bill createdBill = billDAO.createBill(newBill);
            boolean success = (createdBill != null);
            
            if (success) {
                request.setAttribute("successMessage", "Tạo hóa đơn thành công! Mã hóa đơn: " + billId);
                System.out.println("✅ Created new invoice: " + billId + " for " + customerName);
            } else {
                request.setAttribute("errorMessage", "Có lỗi khi tạo hóa đơn!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tạo hóa đơn: " + e.getMessage());
        }
        
        // Return to payment management page
        handlePaymentManagement(request, response);
    }

    private void handleViewInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String billId = request.getParameter("billId");
            
            if (billId == null || billId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy mã hóa đơn!");
                handlePaymentManagement(request, response);
                return;
            }
            
            // Get bill details
            BillDAO billDAO = new BillDAO();
            Bill bill = billDAO.getBillById(billId);
            
            if (bill == null) {
                request.setAttribute("errorMessage", "Không tìm thấy hóa đơn với mã: " + billId);
                handlePaymentManagement(request, response);
                return;
            }
            
            // Get installment details if exists
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            List<PaymentInstallment> installments = installmentDAO.getInstallmentsByBillId(billId);
            
            // Get service details
            ServiceDAO serviceDAO = new ServiceDAO();
            Service service = null;
            try {
                if (bill.getServiceId() != 0) {
                    service = serviceDAO.getServiceById(bill.getServiceId());
                }
            } catch (Exception e) {
                System.err.println("Error loading service details: " + e.getMessage());
            }
            
            // Calculate payment summary
            double totalPaid = 0.0;
            double remainingAmount = bill.getAmount() != null ? bill.getAmount().doubleValue() : 0.0;
            
            if (installments != null && !installments.isEmpty()) {
                for (PaymentInstallment installment : installments) {
                    if ("PAID".equals(installment.getStatus())) {
                        totalPaid += installment.getAmountPaid();
                    }
                }
                remainingAmount -= totalPaid;
            } else if ("PAID".equals(bill.getPaymentStatus()) || "success".equals(bill.getPaymentStatus())) {
                totalPaid = remainingAmount;
                remainingAmount = 0.0;
            }
            
            // Set attributes for JSP
            request.setAttribute("bill", bill);
            request.setAttribute("service", service);
            request.setAttribute("installments", installments);
            request.setAttribute("totalPaid", totalPaid);
            request.setAttribute("remainingAmount", remainingAmount);
            request.setAttribute("viewMode", "invoice_detail");
            
            System.out.println("📋 Viewing invoice: " + billId + " - Total: " + bill.getAmount() + 
                    " VNĐ, Paid: " + totalPaid + " VNĐ, Remaining: " + remainingAmount + " VNĐ");
            
            // Forward to invoice detail page or back to payment management with detail view
            request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi xem chi tiết hóa đơn: " + e.getMessage());
            handlePaymentManagement(request, response);
        }
    }

    private void handleCreateNewInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String paymentMethod = request.getParameter("paymentMethod");
            String[] selectedServices = request.getParameterValues("services[]");

            System.out.println("💳 CREATING NEW INVOICE:");
            System.out.println("  - Customer: " + customerName);
            System.out.println("  - Phone: " + customerPhone);
            System.out.println("  - Payment Method: " + paymentMethod);

            if (selectedServices == null || selectedServices.length == 0) {
                request.setAttribute("errorMessage", "Vui lòng chọn ít nhất một dịch vụ!");
                handlePaymentManagement(request, response);
                return;
            }

            // Calculate total amount from selected services using ServiceDAO
            ServiceDAO serviceDAO = new ServiceDAO();
            double totalAmount = 0;

            for (String serviceIdStr : selectedServices) {
                try {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    Service service = serviceDAO.getServiceById(serviceId);
                    if (service != null) {
                        totalAmount += service.getPrice();
                        System.out.println("🔹 Added service: " + service.getServiceName() + " - " + service.getPrice() + " VNĐ");
                    } else {
                        System.err.println("⚠️ Service not found with ID: " + serviceId);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("⚠️ Invalid service ID: " + serviceIdStr);
                }
            }

            System.out.println("💰 Total calculated amount: " + totalAmount + " VNĐ");

            // Generate bill ID with BILL_ format (8 characters)
            String billId = "BILL_" + String.format("%08X", (int) (System.currentTimeMillis() % 0x100000000L));

            // Generate order ID with ORDER_ format (13 digits timestamp)
            String orderId = "ORDER_" + System.currentTimeMillis();

            BillDAO billDAO = new BillDAO();

            if ("installment".equals(paymentMethod)) {
                // Handle installment payment
                String downPaymentStr = request.getParameter("downPayment");
                String installmentCountStr = request.getParameter("installmentCount");
                String downPaymentMethod = request.getParameter("downPaymentMethod");

                if (downPaymentStr == null || downPaymentStr.trim().isEmpty()
                        || installmentCountStr == null || installmentCountStr.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Thông tin trả góp không đầy đủ!");
                    handlePaymentManagement(request, response);
                    return;
                }

                double downPayment = 0;
                int installmentCount = 0;
                try {
                    downPayment = Double.parseDouble(downPaymentStr.trim());
                    installmentCount = Integer.parseInt(installmentCountStr.trim());
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Thông tin trả góp không hợp lệ!");
                    handlePaymentManagement(request, response);
                    return;
                }

                // Create bill with INSTALLMENT status
                Bill bill = new Bill();
                bill.setBillId(billId);
                bill.setOrderId(orderId);
                bill.setCustomerName(customerName);
                bill.setCustomerPhone(customerPhone);
                bill.setAmount(new java.math.BigDecimal(totalAmount));
                bill.setPaymentStatus("INSTALLMENT");
                bill.setPaymentMethod(downPaymentMethod);
                bill.setServiceId(Integer.parseInt(selectedServices[0])); // Use first service as primary

                Bill createdBill = billDAO.createBill(bill);

                if (createdBill != null) {
                    // Create installment plan
                    PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
                    boolean installmentCreated = installmentDAO.createInstallmentPlan(
                            billId, totalAmount, downPayment, installmentCount);

                    if (installmentCreated) {
                        request.setAttribute("successMessage",
                                "Tạo hóa đơn và kế hoạch trả góp thành công! Mã HĐ: " + billId);
                        System.out.println("✅ Created bill and installment plan: " + billId);
                    } else {
                        request.setAttribute("errorMessage", "Tạo hóa đơn thành công nhưng lỗi khi tạo kế hoạch trả góp!");
                    }
                } else {
                    request.setAttribute("errorMessage", "Có lỗi khi tạo hóa đơn!");
                }

            } else {
                // Handle full payment
                String fullPaymentMethod = request.getParameter("fullPaymentMethod");
                String notes = request.getParameter("notes");
                String paidAmountStr = request.getParameter("paidAmount");

                double paidAmount = 0;
                try {
                    if (paidAmountStr != null && !paidAmountStr.trim().isEmpty()) {
                        paidAmount = Double.parseDouble(paidAmountStr.trim());
                    } else {
                        paidAmount = totalAmount; // Default to total amount
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Số tiền thanh toán không hợp lệ!");
                    handlePaymentManagement(request, response);
                    return;
                }

                // Create bill with PAID status
                Bill bill = new Bill();
                bill.setBillId(billId);
                bill.setOrderId(orderId);
                bill.setCustomerName(customerName);
                bill.setCustomerPhone(customerPhone);
                bill.setAmount(new java.math.BigDecimal(totalAmount));
                bill.setPaymentStatus("PAID");
                bill.setPaymentMethod(fullPaymentMethod);
                bill.setNotes(notes);
                bill.setServiceId(Integer.parseInt(selectedServices[0])); // Use first service as primary

                Bill createdBill = billDAO.createBill(bill);

                if (createdBill != null) {
                    request.setAttribute("successMessage",
                            "Tạo hóa đơn thành công! Mã HĐ: " + billId + " - Đã thanh toán đầy đủ");
                    System.out.println("✅ Created bill with full payment: " + billId);
                } else {
                    request.setAttribute("errorMessage", "Có lỗi khi tạo hóa đơn!");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi khi tạo hóa đơn: " + e.getMessage());
        }

        handlePaymentManagement(request, response);
    }

    /**
     * Xử lý trang quản lý trả góp
     */
    private void handleInstallmentManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("💰 LOADING INSTALLMENT MANAGEMENT PAGE (OPTIMIZED)...");
        try {
            BillDAO billDAO = new BillDAO();
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();

            // 1. Get all bills that are installment plans
            List<Bill> installmentBills = billDAO.getBillsByStatus("INSTALLMENT", Integer.MAX_VALUE); // Use large limit to get all

            // 2. For each bill, enrich it with details and summary
            for (Bill bill : installmentBills) {
                // Get and set detailed installment list for the accordion body
                List<PaymentInstallment> details = installmentDAO.getInstallmentsByBillId(bill.getBillId());
                bill.setInstallmentDetails(details);

                // Get and set summary info
                PaymentInstallment summary = installmentDAO.getInstallmentSummary(bill.getBillId());
                bill.setInstallmentSummary(summary);

                // Calculate and set total remaining amount
                if (summary != null) {
                    bill.setTotalRemaining(summary.getTotalRemaining());
                } else {
                    // Fallback calculation if summary is null
                    double totalRemaining = details.stream()
                            .filter(inst -> !"PAID".equalsIgnoreCase(inst.getStatus()))
                            .mapToDouble(PaymentInstallment::getRemainingAmount)
                            .sum();
                    bill.setTotalRemaining(totalRemaining);
                }
            }

            request.setAttribute("installmentBills", installmentBills);
            request.getRequestDispatcher("/jsp/staff/staff_tragop.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu trả góp: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_tragop.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý chi tiết kế hoạch trả góp
     */
    private void handleInstallmentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String billId = request.getParameter("billId");
            if (billId == null || billId.trim().isEmpty()) {
                response.sendRedirect("StaffPaymentServlet?action=installments");
                return;
            }

            System.out.println("📋 LOADING INSTALLMENT DETAIL FOR BILL: " + billId);

            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();

            // Lấy tóm tắt kế hoạch
            PaymentInstallment summary = installmentDAO.getInstallmentSummary(billId);

            // Lấy chi tiết từng kỳ
            List<PaymentInstallment> installments = installmentDAO.getInstallmentsByBillId(billId);

            System.out.println("📊 Found " + installments.size() + " installments for bill " + billId);

            // Gửi dữ liệu cho JSP
            request.setAttribute("summary", summary);
            request.setAttribute("installments", installments);
            request.setAttribute("billId", billId);

            // Forward đến trang chi tiết trả góp
            request.getRequestDispatcher("/jsp/staff/staff_tragop_chitiet.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi khi tải chi tiết trả góp: " + e.getMessage());
            response.sendRedirect("StaffPaymentServlet?action=installments");
        }
    }

    /**
     * Xử lý trang nhắc nợ
     */
    private void handleReminders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("🔔 LOADING REMINDERS PAGE...");

            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            List<PaymentInstallment> reminders = installmentDAO.getRemindersNeeded();

            System.out.println("📞 Found " + reminders.size() + " customers needing reminders");

            // Gửi dữ liệu cho JSP
            request.setAttribute("reminders", reminders);

            // Forward đến trang nhắc nợ
            request.getRequestDispatcher("/jsp/staff/staff_nhacno.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("error", "Có lỗi khi tải dữ liệu nhắc nợ: " + e.getMessage());
                request.setAttribute("reminders", new ArrayList<PaymentInstallment>());
                request.getRequestDispatcher("/jsp/staff/staff_nhacno.jsp").forward(request, response);
            } else {
                System.err.println("❌ Cannot forward from handleReminders - response already committed. Error: " + e.getMessage());
            }
        }
    }

    /**
     * Tạo kế hoạch trả góp mới
     */
    private void handleCreateInstallment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set content type for JSON response
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String billId = request.getParameter("billId");
            String totalAmountStr = request.getParameter("totalAmount");
            String downPaymentStr = request.getParameter("downPayment");
            String installmentCountStr = request.getParameter("installmentCount");

            // Validate required parameters
            if (billId == null || billId.trim().isEmpty()) {
                sendJsonResponse(response, false, "Thiếu mã hóa đơn", null);
                return;
            }

            if (totalAmountStr == null || downPaymentStr == null || installmentCountStr == null) {
                sendJsonResponse(response, false, "Thiếu thông tin trả góp", null);
                return;
            }

            double totalAmount = Double.parseDouble(totalAmountStr);
            double downPayment = Double.parseDouble(downPaymentStr);
            int installmentCount = Integer.parseInt(installmentCountStr);

            System.out.println("💳 CREATING INSTALLMENT PLAN:");
            System.out.println("  - Bill ID: " + billId);
            System.out.println("  - Total: " + totalAmount + " VNĐ");
            System.out.println("  - Down Payment: " + downPayment + " VNĐ");
            System.out.println("  - Installments: " + installmentCount + " months");

            // Validate input
            if (downPayment < totalAmount * 0.3) {
                sendJsonResponse(response, false, "Tiền đặt cọc phải tối thiểu 30% tổng số tiền!", null);
                return;
            }

            if (installmentCount < 3 || installmentCount > 12) {
                sendJsonResponse(response, false, "Số kỳ trả góp phải từ 3-12 tháng!", null);
                return;
            }

            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            boolean success = installmentDAO.createInstallmentPlan(billId, totalAmount, downPayment, installmentCount);

            if (success) {
                // Cập nhật trạng thái Bills thành INSTALLMENT
                BillDAO billDAO = new BillDAO();
                billDAO.updatePaymentStatus(billId, "INSTALLMENT");

                System.out.println("✅ Installment plan created successfully for bill " + billId);
                sendJsonResponse(response, true, "Tạo kế hoạch trả góp thành công!", billId);
            } else {
                System.err.println("❌ Failed to create installment plan for bill " + billId);
                sendJsonResponse(response, false, "Có lỗi khi tạo kế hoạch trả góp!", null);
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Number format error: " + e.getMessage());
            sendJsonResponse(response, false, "Dữ liệu số không hợp lệ", null);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Unexpected error: " + e.getMessage());
            sendJsonResponse(response, false, "Có lỗi khi tạo kế hoạch trả góp: " + e.getMessage(), null);
        }
    }

    /**
     * Thanh toán một kỳ trả góp
     */
    private void handlePayInstallment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set content type for JSON response
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy parameters từ frontend
            String billId = request.getParameter("billId");
            String periodStr = request.getParameter("period");
            String amountStr = request.getParameter("amount");
            String paymentMethod = request.getParameter("paymentMethod");
            String transactionId = request.getParameter("transactionId");
            String notes = request.getParameter("notes");

            System.out.println("💰 PAYING INSTALLMENT:");
            System.out.println("  - Bill ID: " + billId);
            System.out.println("  - Period: " + periodStr);
            System.out.println("  - Amount: " + amountStr + " VNĐ");
            System.out.println("  - Payment Method: " + paymentMethod);
            System.out.println("  - Transaction ID: " + transactionId);
            System.out.println("  - Notes: " + notes);

            // Validate parameters
            if (billId == null || billId.trim().isEmpty()) {
                sendJsonResponse(response, false, "Thiếu thông tin hóa đơn!", null);
                return;
            }

            if (periodStr == null || periodStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "Thiếu thông tin kỳ thanh toán!", null);
                return;
            }

            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                sendJsonResponse(response, false, "Vui lòng chọn phương thức thanh toán!", null);
                return;
            }

            int period = Integer.parseInt(periodStr);
            double amount = Double.parseDouble(amountStr);

            if (amount <= 0) {
                sendJsonResponse(response, false, "Số tiền thanh toán phải lớn hơn 0!", null);
                return;
            }

            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            boolean success = installmentDAO.payInstallmentByBillAndPeriod(billId, period, amount, paymentMethod, transactionId, notes);

            if (success) {
                // Tạo bill con cho kỳ trả góp này
                System.out.println("[DEBUG] 🚀 handlePayInstallment - About to create child bill");
                BillDAO billDAO = new BillDAO();
                Bill parentBill = billDAO.getBillById(billId);
                System.out.println("[DEBUG] Parent bill found: " + (parentBill != null ? "YES" : "NO"));
                String childBillId = null;
                if (parentBill != null) {
                    System.out.println("[DEBUG] Calling billDAO.createBillInstallment...");
                    childBillId = billDAO.createBillInstallment(parentBill, period, amount, paymentMethod, notes);
                    System.out.println("[DEBUG] billDAO.createBillInstallment returned: " + childBillId);
                }
                System.out.println("✅ Installment payment successful for Bill " + billId + " Period " + period);

                // Check if all installments for this bill are paid to update bill status
                checkAndUpdateBillStatus(billId);

                java.util.Map<String, Object> data = new java.util.HashMap<>();
                data.put("billId", childBillId);
                sendJsonResponse(response, true, "Thanh toán kỳ " + period + " thành công!", data);
            } else {
                System.err.println("❌ Failed to pay installment for Bill " + billId + " Period " + period);
                sendJsonResponse(response, false, "Có lỗi khi thanh toán kỳ trà góp!", null);
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Number format error: " + e.getMessage());
            sendJsonResponse(response, false, "Dữ liệu số không hợp lệ!", null);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Error paying installment: " + e.getMessage());
            sendJsonResponse(response, false, "Có lỗi khi thanh toán: " + e.getMessage(), null);
        }
    }

    /**
     * Lấy bill ID từ installment ID
     */
    private String getBillIdFromInstallmentId(int installmentId) {
        try {
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            // Chúng ta cần thêm method này vào DAO
            return installmentDAO.getBillIdByInstallmentId(installmentId);
        } catch (Exception e) {
            System.err.println("❌ Error getting bill ID: " + e.getMessage());
            return null;
        }
    }

    /**
     * Kiểm tra và cập nhật trạng thái bill nếu tất cả installments đã thanh
     * toán
     */
    private void checkAndUpdateBillStatus(String billId) {
        try {
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            BillDAO billDAO = new BillDAO();

            // Lấy tóm tắt installment
            PaymentInstallment summary = installmentDAO.getInstallmentSummary(billId);
            if (summary != null) {
                // Nếu tất cả kỳ đã thanh toán
                if (summary.getPaidInstallments() == summary.getInstallmentCount()) {
                    billDAO.updatePaymentStatus(billId, "PAID");
                    System.out.println("✅ Updated bill " + billId + " status to PAID");
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Error updating bill status: " + e.getMessage());
        }
    }

    /**
     * Xử lý tạo hóa đơn từ modal (AJAX)
     */
    private void handleCreateBillFromModal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🚀 CREATE BILL FROM MODAL - START");
        System.out.println("📋 Response committed before processing: " + response.isCommitted());

        // Kiểm tra response đã committed chưa
        if (response.isCommitted()) {
            System.err.println("❌ Response already committed at start of handleCreateBillFromModal");
            return;
        }

        try {
            // Lấy thông tin khách hàng
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            // Lấy thông tin dịch vụ
            String[] selectedServices = request.getParameterValues("selectedServices[]");
            if (selectedServices == null) {
                // Fallback: thử với tên khác
                selectedServices = request.getParameterValues("selectedServices");
            }
            if (selectedServices == null) {
                // Fallback: thử với indexed parameters
                List<String> servicesList = new ArrayList<>();
                for (int i = 0; i < 10; i++) { // Check up to 10 services
                    String service = request.getParameter("selectedServices[" + i + "]");
                    if (service != null) {
                        servicesList.add(service);
                    }
                }
                if (!servicesList.isEmpty()) {
                    selectedServices = servicesList.toArray(new String[0]);
                }
            }

            String totalAmountStr = request.getParameter("totalAmount");
            String paymentAmountStr = request.getParameter("paymentAmount");

            if (totalAmountStr == null || paymentAmountStr == null) {
                sendJsonResponse(response, false, "Thiếu thông tin số tiền", null);
                return;
            }

            double totalAmount = Double.parseDouble(totalAmountStr);
            double paymentAmount = Double.parseDouble(paymentAmountStr);

            System.out.println("📋 DEBUG - All Parameters:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println("  - " + key + " = " + java.util.Arrays.toString(values));
            });

            System.out.println("📋 Bill Info:");
            System.out.println("  - Customer: " + customerName);
            System.out.println("  - Phone: " + customerPhone);
            System.out.println("  - Payment Method: " + paymentMethod);
            System.out.println("  - Total Amount: " + totalAmount);
            System.out.println("  - Payment Amount: " + paymentAmount);
            System.out.println("  - Selected Services: " + (selectedServices != null ? java.util.Arrays.toString(selectedServices) : "null"));

            // Validate dữ liệu đầu vào
            if (customerName == null || customerName.trim().isEmpty()) {
                sendJsonResponse(response, false, "Tên bệnh nhân không được để trống", null);
                return;
            }

            if (customerPhone == null || customerPhone.trim().isEmpty()) {
                sendJsonResponse(response, false, "Số điện thoại không được để trống", null);
                return;
            }
            
            // Validate phone number format
            if (!customerPhone.matches("^[0-9+\\-\\s]{9,15}$")) {
                sendJsonResponse(response, false, "Số điện thoại không hợp lệ (9-15 ký tự số)", null);
                return;
            }

            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                sendJsonResponse(response, false, "Vui lòng chọn phương thức thanh toán", null);
                return;
            }

            if (selectedServices == null || selectedServices.length == 0) {
                sendJsonResponse(response, false, "Vui lòng chọn ít nhất một dịch vụ", null);
                return;
            }
            
            // Validate amount ranges
            if (totalAmount <= 0 || totalAmount > 1000000000) { // Max 1 billion VND
                sendJsonResponse(response, false, "Số tiền không hợp lệ (phải từ 1 đến 1 tỷ VNĐ)", null);
                return;
            }
            
            if (paymentAmount < 0 || paymentAmount > totalAmount) {
                sendJsonResponse(response, false, "Số tiền thanh toán không hợp lệ", null);
                return;
            }

            // Tạo bill ID với format BILL_ (8 ký tự hexa)
            String billId = "BILL_" + String.format("%08X", (int) (System.currentTimeMillis() % 0x100000000L));

            // Xử lý theo phương thức thanh toán
            if ("installment".equals(paymentMethod)) {
                // Trả góp
                String downPaymentStr = request.getParameter("downPayment");
                String installmentMonthsStr = request.getParameter("installmentMonths");

                if (downPaymentStr == null || installmentMonthsStr == null) {
                    sendJsonResponse(response, false, "Thông tin trả góp không đầy đủ", null);
                    return;
                }

                double downPayment = Double.parseDouble(downPaymentStr);
                int installmentMonths = Integer.parseInt(installmentMonthsStr);

                // Validate trả góp
                double minDownPayment = totalAmount * 0.3;
                if (downPayment < minDownPayment) {
                    sendJsonResponse(response, false,
                            "Số tiền đặt cọc phải tối thiểu 30% = " + String.format("%,.0f", minDownPayment) + " VNĐ",
                            null);
                    return;
                }

                // Status for installment is always 'INSTALLMENT'
                String paymentStatus = "INSTALLMENT";

                System.out.println("💎 Creating INSTALLMENT bill with status: " + paymentStatus);

                Bill newBill = createBillObject(billId, customerName, customerPhone, totalAmount, paymentStatus, paymentMethod, notes, selectedServices[0]);
                String orderId = "ORDER_" + System.currentTimeMillis();
                newBill.setOrderId(orderId);

                BillDAO billDAO = new BillDAO();
                Bill createdBill = billDAO.createBill(newBill);

                if (createdBill != null) {
                    PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
                    boolean installmentPlanSuccess = installmentDAO.createInstallmentPlan(billId, totalAmount, downPayment, installmentMonths);
                    if (installmentPlanSuccess) {
                        sendJsonResponse(response, true, "Tạo hóa đơn và kế hoạch trả góp thành công!", createdBill);
                    } else {
                        // Critical error: Bill created but installment plan failed.
                        // Consider deleting the bill or marking it as errored.
                        try {
                            billDAO.updatePaymentStatus(billId, "ERROR");
                        } catch (Exception e) {
                            System.err.println("❌ Failed to mark bill as error: " + e.getMessage());
                        }
                        sendJsonResponse(response, false, "Không thể tạo các kỳ trả góp.", null);
                    }
                } else {
                    sendJsonResponse(response, false, "Không thể tạo hóa đơn trong CSDL.", null);
                }

            } else if ("bank_transfer".equals(paymentMethod)) {
                // Chuyển khoản: luôn tạo bill với trạng thái PENDING
                String paymentStatus = "PENDING";
                System.out.println("🏦 Creating BANK TRANSFER bill with status: " + paymentStatus);
                Bill newBill = createBillObject(billId, customerName, customerPhone, totalAmount, paymentStatus, paymentMethod, notes, selectedServices[0]);
                String orderId = "ORDER_" + System.currentTimeMillis();
                newBill.setOrderId(orderId);
                BillDAO billDAO = new BillDAO();
                Bill createdBill = billDAO.createBill(newBill);
                if (createdBill != null) {
                    try {
                        ServiceDAO serviceDAO = new ServiceDAO();
                        if (selectedServices != null && selectedServices.length > 0) {
                            int serviceId = Integer.parseInt(selectedServices[0]);
                            Service service = serviceDAO.getServiceById(serviceId);
                            if (service != null) {
                                // Lấy tên dịch vụ và giá từ DB, set vào bill
                                createdBill.setServiceName(service.getServiceName());
                                createdBill.setAmount(new java.math.BigDecimal(service.getPrice()));
                                // Chuẩn bị danh sách dịch vụ đã chọn (nhiều dịch vụ)
                                java.util.List<java.util.Map<String, Object>> billDetails = new java.util.ArrayList<>();
                                for (String selectedId : selectedServices) {
                                    try {
                                        int sid = Integer.parseInt(selectedId);
                                        Service s = serviceDAO.getServiceById(sid);
                                        if (s != null) {
                                            java.util.Map<String, Object> detail = new java.util.HashMap<>();
                                            detail.put("serviceName", s.getServiceName());
                                            detail.put("quantity", 1); // mặc định 1
                                            detail.put("unitPrice", s.getPrice());
                                            detail.put("totalPrice", s.getPrice());
                                            billDetails.add(detail);
                                        }
                                    } catch (Exception ex) {
                                        System.err.println("[DEBUG] Lỗi parse serviceId: " + selectedId + " - " + ex.getMessage());
                                    }
                                }
                                request.setAttribute("billDetails", billDetails);
                                // Tạo QR chuyển khoản
                                String qrUrl = utils.PayOSUtil.createPayOSPaymentRequestForStaff(createdBill, service.getServiceName());
                                if (qrUrl == null || qrUrl.isEmpty()) {
                                    qrUrl = "https://img.vietqr.io/image/MB-5529062004-print.png?amount=" + service.getPrice() + "&addInfo=Thanh%20toan%20hoa%20don%20" + billId;
                                }
                                // Log chi tiết thông tin hóa đơn (không còn thuốc mẫu)
                                System.out.println("========== [DEBUG][StaffPaymentServlet] THÔNG TIN HÓA ĐƠN STAFF ==========");
                                System.out.println("Mã HĐ: " + createdBill.getBillId());
                                System.out.println("Khách hàng: " + createdBill.getCustomerName());
                                System.out.println("SĐT: " + createdBill.getCustomerPhone());
                                System.out.println("Phương thức thanh toán: " + createdBill.getPaymentMethod());
                                System.out.println("Số tiền: " + createdBill.getAmount() + " VNĐ");
                                System.out.println("Dịch vụ: " + service.getServiceName());
                                System.out.println("QR chuyển khoản: " + qrUrl);
                                System.out.println("====================================================================");
                                // Trả về JSON cho frontend (bao gồm billDetails)
                                java.util.Map<String, Object> data = new java.util.HashMap<>();
                                data.put("bill", createdBill);
                                data.put("qrUrl", qrUrl);
                                data.put("billDetails", billDetails); // truyền billDetails về frontend
                                System.out.println("[DEBUG][AJAX-RESPONSE] Sắp gửi JSON cho frontend (bank_transfer)...");
                                System.out.println("[DEBUG][AJAX-RESPONSE] billId: " + createdBill.getBillId());
                                System.out.println("[DEBUG][AJAX-RESPONSE] qrUrl: " + qrUrl);
                                sendJsonResponse(response, true, "Tạo hóa đơn chuyển khoản thành công!", data);
                                System.out.println("[DEBUG][AJAX-RESPONSE] ĐÃ GỬI JSON RESPONSE thành công cho frontend!");
                                return;
                            } else {
                                System.err.println("[DEBUG] Không tìm thấy dịch vụ với ID: " + serviceId);
                            }
                        }
                    } catch (Exception e) {
                        System.err.println("❌ Error getting service name: " + e.getMessage());
                    }
                    // Nếu không lấy được dịch vụ, fallback như cũ
                    createdBill.setServiceName("Dịch vụ nha khoa");
                    createdBill.setAmount(new java.math.BigDecimal(totalAmount));
                    String qrUrl = utils.PayOSUtil.createPayOSPaymentRequestForStaff(createdBill, "Dịch vụ nha khoa");
                    if (qrUrl == null || qrUrl.isEmpty()) {
                        qrUrl = "https://img.vietqr.io/image/MB-5529062004-print.png?amount=" + totalAmount + "&addInfo=Thanh%20toan%20hoa%20don%20" + billId;
                    }
                    // Log fallback
                    System.out.println("========== [DEBUG][StaffPaymentServlet] THÔNG TIN HÓA ĐƠN STAFF (FALLBACK) ==========");
                    System.out.println("Mã HĐ: " + createdBill.getBillId());
                    System.out.println("Khách hàng: " + createdBill.getCustomerName());
                    System.out.println("SĐT: " + createdBill.getCustomerPhone());
                    System.out.println("Phương thức thanh toán: " + createdBill.getPaymentMethod());
                    System.out.println("Số tiền: " + createdBill.getAmount() + " VNĐ");
                    System.out.println("Dịch vụ: Dịch vụ nha khoa");
                    System.out.println("QR chuyển khoản: " + qrUrl);
                    System.out.println("====================================================================");
                    java.util.Map<String, Object> data = new java.util.HashMap<>();
                    data.put("bill", createdBill);
                    data.put("qrUrl", qrUrl);
                    System.out.println("[DEBUG][AJAX-RESPONSE] Sắp gửi JSON cho frontend (bank_transfer fallback)...");
                    System.out.println("[DEBUG][AJAX-RESPONSE] billId: " + createdBill.getBillId());
                    System.out.println("[DEBUG][AJAX-RESPONSE] qrUrl: " + qrUrl);
                    sendJsonResponse(response, true, "Tạo hóa đơn chuyển khoản thành công!", data);
                    System.out.println("[DEBUG][AJAX-RESPONSE] ĐÃ GỬI JSON RESPONSE thành công cho frontend!");
                    return;
                } else {
                    sendJsonResponse(response, false, "Không thể tạo hóa đơn chuyển khoản trong CSDL.", null);
                }
            } else {
                // Standard Payment
                String paymentStatus;
                if (paymentAmount >= totalAmount) {
                    paymentStatus = "PAID";
                } else {
                    paymentStatus = "PENDING"; // Default status for standard payment
                }
                System.out.println("💵 Creating STANDARD bill with status: " + paymentStatus);
                Bill newBill = createBillObject(billId, customerName, customerPhone, totalAmount, paymentStatus, paymentMethod, notes, selectedServices[0]);
                String orderId = "ORDER_" + System.currentTimeMillis();
                newBill.setOrderId(orderId);
                BillDAO billDAO = new BillDAO();
                Bill createdBill = billDAO.createBill(newBill);
                if (createdBill != null) {
                    // Nếu là thanh toán tiền mặt (cash) và đã thanh toán đủ, trả về JSON có redirectToBills
                    if ("cash".equals(paymentMethod) && paymentAmount >= totalAmount) {
                        java.util.Map<String, Object> data = new java.util.HashMap<>();
                        data.put("bill", createdBill);
                        data.put("redirectToBills", true);
                        sendJsonResponse(response, true, "Tạo hóa đơn thành công!", data);
                        return;
                    } else {
                        sendJsonResponse(response, true, "Tạo hóa đơn thành công!", createdBill);
                    }
                } else {
                    sendJsonResponse(response, false, "Không thể tạo hóa đơn trong CSDL.", null);
                }
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Number format error in handleCreateBillFromModal: " + e.getMessage());
            e.printStackTrace();
            if (!response.isCommitted()) {
                sendJsonResponse(response, false, "Dữ liệu số không hợp lệ: " + e.getMessage(), null);
            } else {
                System.err.println("❌ Cannot send NumberFormatException response - already committed");
            }
        } catch (SQLException e) {
            System.err.println("❌ Database error in handleCreateBillFromModal: " + e.getMessage());
            System.err.println("❌ SQL State: " + e.getSQLState());
            System.err.println("❌ Error Code: " + e.getErrorCode());
            e.printStackTrace();
            if (!response.isCommitted()) {
                sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
            } else {
                System.err.println("❌ Cannot send SQLException response - already committed");
            }
        } catch (Exception e) {
            System.err.println("❌ Unexpected error in handleCreateBillFromModal: " + e.getMessage());
            System.err.println("❌ Exception type: " + e.getClass().getSimpleName());
            e.printStackTrace();
            if (!response.isCommitted()) {
                sendJsonResponse(response, false, "Có lỗi không mong muốn: " + e.getMessage(), null);
            } else {
                System.err.println("❌ Cannot send Exception response - already committed");
            }
        }

        System.out.println("🏁 CREATE BILL FROM MODAL - END");
    }

    /**
     * Tạo đối tượng Bill - KHỚP VỚI DATABASE STRUCTURE THỰC TẾ
     */
    private Bill createBillObject(String billId, String customerName, String customerPhone,
            double totalAmount, String paymentStatus, String paymentMethod,
            String notes, String primaryServiceId) {
        Bill bill = new Bill();

        bill.setBillId(billId);
        bill.setOrderId("ORDER_" + System.currentTimeMillis());
        bill.setCustomerName(customerName);
        bill.setCustomerPhone(customerPhone);
        bill.setAmount(new java.math.BigDecimal(totalAmount));
        bill.setOriginalPrice(new java.math.BigDecimal(totalAmount));
        bill.setDiscountAmount(java.math.BigDecimal.ZERO);
        bill.setTaxAmount(java.math.BigDecimal.ZERO);
        bill.setPaymentStatus(paymentStatus);
        bill.setPaymentMethod(paymentMethod);
        bill.setNotes(notes);

        // Set default values
        bill.setPatientId(1); // Default patient ID - có thể lookup theo customerPhone sau
        bill.setUserId(1); // Default user ID

        // Set service ID
        try {
            if (primaryServiceId != null && !primaryServiceId.trim().isEmpty()) {
                bill.setServiceId(Integer.parseInt(primaryServiceId));
            } else {
                bill.setServiceId(1); // Default service ID
            }
        } catch (NumberFormatException e) {
            bill.setServiceId(1); // Default service ID
        }

        // Sanitize inputs for security
        bill.sanitizeInputs();
        
        // Validate bill data
        if (!bill.isValid()) {
            System.err.println("❌ Bill validation failed:");
            for (String error : bill.getValidationErrors()) {
                System.err.println("   - " + error);
            }
        }

        System.out.println("📋 Created Bill object:");
        System.out.println("  - Bill ID: " + bill.getBillId());
        System.out.println("  - Customer: " + bill.getCustomerName());
        System.out.println("  - Amount: " + bill.getAmount());
        System.out.println("  - Payment Status: " + bill.getPaymentStatus());
        System.out.println("  - Payment Method: " + bill.getPaymentMethod());
        System.out.println("  - Valid: " + bill.isValid());

        return bill;
    }

    /**
     * Gửi JSON response cho AJAX call
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success,
            String message, Object data) throws IOException {

        System.out.println("📤 ========== SENDING JSON RESPONSE ==========");
        System.out.println("📤 Success: " + success);
        System.out.println("📤 Message: " + message);
        System.out.println("📤 Data: " + data);
        System.out.println("📤 Response committed before: " + response.isCommitted());
        System.out.println("📤 Response buffer size: " + response.getBufferSize());

        if (response.isCommitted()) {
            System.err.println("❌ Cannot send JSON - response already committed!");
            System.err.println("❌ This should not happen - check your code flow");
            return;
        }

        try {
            // Reset any previous content (if possible)
            try {
                response.reset();
                System.out.println("📤 Response reset successfully");
            } catch (IllegalStateException e) {
                System.out.println("📤 Could not reset response (may be already committed): " + e.getMessage());
            }

            // Set headers
            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            System.out.println("📤 Headers set successfully");

            // Build JSON using Gson
            Gson gson = new Gson();
            java.util.Map<String, Object> jsonMap = new java.util.LinkedHashMap<>();
            jsonMap.put("success", success);
            jsonMap.put("message", message);
            if (data != null) {
                jsonMap.put("data", data);
            }
            jsonMap.put("timestamp", new java.util.Date().toString());
            jsonMap.put("server", "StaffPaymentServlet");

            String jsonString = gson.toJson(jsonMap);
            System.out.println("📤 JSON String (" + jsonString.length() + " chars): " + jsonString);

            // Write response
            PrintWriter writer = response.getWriter();
            writer.write(jsonString);
            writer.flush();

            System.out.println("📤 Response committed after: " + response.isCommitted());
            System.out.println("✅ JSON response sent successfully");
            System.out.println("📤 ==========================================");

        } catch (Exception e) {
            System.err.println("❌ CRITICAL ERROR sending JSON response: " + e.getMessage());
            System.err.println("❌ Exception type: " + e.getClass().getSimpleName());
            e.printStackTrace();

            // Final fallback - try to send simple JSON
            if (!response.isCommitted()) {
                try {
                    response.reset();
                    response.setContentType("application/json;charset=UTF-8");
                    String fallbackJson = "{\"success\":false,\"message\":\"Server error\",\"error\":\"" + escapeJson(e.getMessage()) + "\"}";
                    response.getWriter().write(fallbackJson);
                    response.getWriter().flush();
                    System.out.println("📤 Fallback JSON sent: " + fallbackJson);
                } catch (Exception ex) {
                    System.err.println("❌ Even fallback response failed: " + ex.getMessage());
                    // Final resort - try to send error status
                    try {
                        response.sendError(500, "JSON response generation failed");
                    } catch (Exception finalEx) {
                        System.err.println("❌ Could not even send error status: " + finalEx.getMessage());
                    }
                }
            }
        }
    }

    /**
     * Escape JSON special characters
     */
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private void handlePayOffInstallment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            String billId = request.getParameter("billId");
            String paymentMethod = request.getParameter("paymentMethod");
            String transactionId = request.getParameter("transactionId");

            if (billId == null || paymentMethod == null || paymentMethod.isEmpty()) {
                sendJsonResponse(response, false, "Thiếu thông tin đầu vào.", null);
                return;
            }

            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            boolean success = installmentDAO.payOffFullInstallment(billId, paymentMethod, transactionId);

            if (success) {
                // Also update the main bill status to 'PAID'
                BillDAO billDAO = new BillDAO();
                billDAO.updatePaymentStatus(billId, "PAID");
                sendJsonResponse(response, true, "Thanh toán toàn bộ thành công!", null);
            } else {
                sendJsonResponse(response, false, "Không có kỳ nợ nào để thanh toán hoặc đã có lỗi xảy ra.", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi server: " + e.getMessage(), null);
        }
    }
}
