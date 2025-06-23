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
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "StaffPaymentServlet", urlPatterns = {"/StaffPaymentServlet"})
public class StaffPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
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
                handleInstallmentDetail(request, response);
            } else if ("reminders".equals(action)) {
                handleReminders(request, response);
            } else {
                // Mặc định hiển thị trang quản lý thanh toán
                handlePaymentManagement(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("createBill".equals(action)) {
                handleCreateBillFromModal(request, response);
            } else if ("process_payment".equals(action)) {
                handleProcessPayment(request, response);
            } else if ("create_invoice".equals(action)) {
                handleCreateNewInvoice(request, response);
            } else if ("create_installment".equals(action)) {
                handleCreateInstallment(request, response);
            } else if ("pay_installment".equals(action)) {
                handlePayInstallment(request, response);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi khi xử lý thanh toán: " + e.getMessage());
            doGet(request, response);
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
            
            System.out.println("📋 Step 2: Loaded " + allBills.size() + " bills and " + 
                              activeServices.size() + " services in " + 
                              (System.currentTimeMillis() - startTime) + "ms");
            
            // Log some services info
            if (!activeServices.isEmpty()) {
                System.out.println("🏥 Available services:");
                activeServices.stream().limit(5).forEach(service -> 
                    System.out.println("  - " + service.getServiceName() + ": " + 
                                     String.format("%,.0f", service.getPrice()) + " VNĐ (" + service.getCategory() + ")")
                );
                if (activeServices.size() > 5) {
                    System.out.println("  ... and " + (activeServices.size() - 5) + " more services");
                }
            }
            
            // Tối ưu hóa: Sử dụng thông tin có sẵn thay vì query từng bill
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
                } else if ("PENDING".equals(status) || "pending".equals(status) || "Chờ thanh toán".equals(status)) {
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
            request.setAttribute("error", "Có lỗi khi tải dữ liệu thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
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
        // TODO: Implement create invoice page
        request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
    }

    private void handleViewInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Implement view invoice details
        request.getRequestDispatcher("/jsp/staff/staff_thanhtoan.jsp").forward(request, response);
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
            
            // Generate bill ID
            String billId = "HD" + System.currentTimeMillis();
            
            BillDAO billDAO = new BillDAO();
            
            if ("installment".equals(paymentMethod)) {
                // Handle installment payment
                String downPaymentStr = request.getParameter("downPayment");
                String installmentCountStr = request.getParameter("installmentCount");
                String downPaymentMethod = request.getParameter("downPaymentMethod");
                
                if (downPaymentStr == null || downPaymentStr.trim().isEmpty() || 
                    installmentCountStr == null || installmentCountStr.trim().isEmpty()) {
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
        
        try {
            System.out.println("💳 LOADING INSTALLMENT MANAGEMENT PAGE...");
            
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            
            // Cập nhật trạng thái quá hạn trước
            int overdueCount = installmentDAO.updateOverdueInstallments();
            System.out.println("📅 Updated " + overdueCount + " overdue installments");
            
            // Lấy danh sách cần nhắc nợ
            List<PaymentInstallment> reminders = installmentDAO.getRemindersNeeded();
            System.out.println("🔔 Found " + reminders.size() + " installments needing reminders");
            
            // Gửi dữ liệu cho JSP
            request.setAttribute("reminders", reminders);
            request.setAttribute("overdueCount", overdueCount);
            
            // Forward đến trang trả góp
            request.getRequestDispatcher("/jsp/staff/staff_tragop.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi khi tải dữ liệu trả góp: " + e.getMessage());
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
            request.setAttribute("error", "Có lỗi khi tải dữ liệu nhắc nợ: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_nhacno.jsp").forward(request, response);
        }
    }
    
    /**
     * Tạo kế hoạch trả góp mới
     */
    private void handleCreateInstallment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String billId = request.getParameter("billId");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            double downPayment = Double.parseDouble(request.getParameter("downPayment"));
            int installmentCount = Integer.parseInt(request.getParameter("installmentCount"));
            
            System.out.println("💳 CREATING INSTALLMENT PLAN:");
            System.out.println("  - Bill ID: " + billId);
            System.out.println("  - Total: " + totalAmount + " VNĐ");
            System.out.println("  - Down Payment: " + downPayment + " VNĐ");
            System.out.println("  - Installments: " + installmentCount + " months");
            
            // Validate input
            if (downPayment < totalAmount * 0.3) {
                request.setAttribute("errorMessage", "Tiền đặt cọc phải tối thiểu 30% tổng số tiền!");
                doGet(request, response);
                return;
            }
            
            if (installmentCount < 3 || installmentCount > 12) {
                request.setAttribute("errorMessage", "Số kỳ trả góp phải từ 3-12 tháng!");
                doGet(request, response);
                return;
            }
            
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            boolean success = installmentDAO.createInstallmentPlan(billId, totalAmount, downPayment, installmentCount);
            
            if (success) {
                // Cập nhật trạng thái Bills thành INSTALLMENT
                BillDAO billDAO = new BillDAO();
                billDAO.updatePaymentStatus(billId, "INSTALLMENT");
                
                request.setAttribute("successMessage", "Tạo kế hoạch trả góp thành công!");
                System.out.println("✅ Installment plan created successfully for bill " + billId);
            } else {
                request.setAttribute("errorMessage", "Có lỗi khi tạo kế hoạch trả góp!");
                System.err.println("❌ Failed to create installment plan for bill " + billId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi khi tạo kế hoạch trả góp: " + e.getMessage());
        }
        
        doGet(request, response);
    }
    
    /**
     * Thanh toán một kỳ trả góp
     */
    private void handlePayInstallment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int installmentId = Integer.parseInt(request.getParameter("installmentId"));
            double amountPaid = Double.parseDouble(request.getParameter("amountPaid"));
            String paymentMethod = request.getParameter("paymentMethod");
            String transactionId = request.getParameter("transactionId");
            
            System.out.println("💰 PAYING INSTALLMENT:");
            System.out.println("  - Installment ID: " + installmentId);
            System.out.println("  - Amount Paid: " + amountPaid + " VNĐ");
            System.out.println("  - Payment Method: " + paymentMethod);
            
            PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
            boolean success = installmentDAO.payInstallment(installmentId, amountPaid, paymentMethod, transactionId);
            
            if (success) {
                request.setAttribute("successMessage", "Thanh toán kỳ trả góp thành công!");
                System.out.println("✅ Installment payment successful for ID " + installmentId);
            } else {
                request.setAttribute("errorMessage", "Có lỗi khi thanh toán kỳ trả góp!");
                System.err.println("❌ Failed to pay installment ID " + installmentId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi khi thanh toán: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    /**
     * Xử lý tạo hóa đơn từ modal (AJAX)
     */
    private void handleCreateBillFromModal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            System.out.println("🚀 CREATE BILL FROM MODAL - START");
            
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
            
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            double paymentAmount = Double.parseDouble(request.getParameter("paymentAmount"));
            
            System.out.println("📋 Bill Info:");
            System.out.println("  - Customer: " + customerName);
            System.out.println("  - Phone: " + customerPhone);
            System.out.println("  - Payment Method: " + paymentMethod);
            System.out.println("  - Total Amount: " + totalAmount);
            System.out.println("  - Payment Amount: " + paymentAmount);
            System.out.println("  - Selected Services: " + (selectedServices != null ? selectedServices.length : 0));
            
            // Validate dữ liệu
            if (customerName == null || customerName.trim().isEmpty()) {
                sendJsonResponse(response, false, "Tên bệnh nhân không được để trống", null);
                return;
            }
            
            if (customerPhone == null || customerPhone.trim().isEmpty()) {
                sendJsonResponse(response, false, "Số điện thoại không được để trống", null);
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
            
            // Tạo bill ID
            String billId = "HD" + System.currentTimeMillis();
            
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
                
                // Tạo hóa đơn với trạng thái INSTALLMENT
                Bill bill = createBillObject(billId, customerName, customerPhone, totalAmount, 
                                           "INSTALLMENT", paymentMethod, notes, selectedServices[0]);
                
                BillDAO billDAO = new BillDAO();
                Bill createdBill = billDAO.createBill(bill);
                
                if (createdBill != null) {
                    // Tạo kế hoạch trả góp
                    PaymentInstallmentDAO installmentDAO = new PaymentInstallmentDAO();
                    boolean installmentSuccess = installmentDAO.createInstallmentPlan(
                        billId, totalAmount, downPayment, installmentMonths);
                    
                    if (installmentSuccess) {
                        System.out.println("✅ Created bill with installment plan: " + billId);
                        sendJsonResponse(response, true, 
                            "Tạo hóa đơn và kế hoạch trả góp thành công!", billId);
                    } else {
                        System.err.println("❌ Failed to create installment plan for: " + billId);
                        sendJsonResponse(response, false, 
                            "Tạo hóa đơn thành công nhưng lỗi khi tạo kế hoạch trả góp", billId);
                    }
                } else {
                    sendJsonResponse(response, false, "Có lỗi khi tạo hóa đơn trong database", null);
                }
                
            } else {
                // Thanh toán thường (không trả góp)
                String paymentStatus;
                if (paymentAmount >= totalAmount) {
                    paymentStatus = "PAID";
                } else if (paymentAmount > 0) {
                    paymentStatus = "PARTIAL";
                } else {
                    paymentStatus = "PENDING";
                }
                
                // Tạo hóa đơn
                Bill bill = createBillObject(billId, customerName, customerPhone, totalAmount, 
                                           paymentStatus, paymentMethod, notes, selectedServices[0]);
                
                BillDAO billDAO = new BillDAO();
                Bill createdBill = billDAO.createBill(bill);
                
                if (createdBill != null) {
                    System.out.println("✅ Created bill with " + paymentStatus + " status: " + billId);
                    String message = "Tạo hóa đơn thành công!";
                    if ("PAID".equals(paymentStatus)) {
                        message += " Đã thanh toán đầy đủ.";
                    } else if ("PARTIAL".equals(paymentStatus)) {
                        message += " Thanh toán một phần.";
                    } else {
                        message += " Chờ thanh toán.";
                    }
                    sendJsonResponse(response, true, message, billId);
                } else {
                    sendJsonResponse(response, false, "Có lỗi khi tạo hóa đơn trong database", null);
                }
            }
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Number format error: " + e.getMessage());
            sendJsonResponse(response, false, "Dữ liệu số không hợp lệ", null);
        } catch (Exception e) {
            System.err.println("❌ Error creating bill from modal: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        }
    }
    
    /**
     * Tạo đối tượng Bill
     */
    private Bill createBillObject(String billId, String customerName, String customerPhone, 
                                double totalAmount, String paymentStatus, String paymentMethod, 
                                String notes, String primaryServiceId) {
        Bill bill = new Bill();
        bill.setBillId(billId);
        bill.setOrderId("ORD" + System.currentTimeMillis());
        bill.setCustomerName(customerName);
        bill.setCustomerPhone(customerPhone);
        bill.setAmount(new java.math.BigDecimal(totalAmount));
        bill.setOriginalPrice(new java.math.BigDecimal(totalAmount));
        bill.setPaymentStatus(paymentStatus);
        bill.setPaymentMethod(paymentMethod);
        bill.setNotes(notes);
        
        // Set service ID nếu có
        try {
            if (primaryServiceId != null && !primaryServiceId.trim().isEmpty()) {
                bill.setServiceId(Integer.parseInt(primaryServiceId));
            } else {
                bill.setServiceId(1); // Default service ID
            }
        } catch (NumberFormatException e) {
            bill.setServiceId(1); // Default service ID
        }
        
        return bill;
    }
    
    /**
     * Gửi JSON response cho AJAX call
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, 
                                 String message, String billId) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": ").append(success).append(",");
        json.append("\"message\": \"").append(message.replace("\"", "\\\"")).append("\"");
        
        if (billId != null) {
            json.append(",\"billId\": \"").append(billId).append("\"");
        }
        
        json.append("}");
        
        response.getWriter().write(json.toString());
        response.getWriter().flush();
        
        System.out.println("📤 JSON Response: " + json.toString());
    }
}
