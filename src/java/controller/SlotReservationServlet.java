package controller;

import dao.AppointmentDAO;
import model.SlotReservation;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet demo cho SlotReservation
 * Sử dụng AppointmentDAO đã tích hợp - KHÔNG cần tạo bảng mới
 */
@WebServlet(name = "SlotReservationServlet", urlPatterns = {"/slot-reservation"})
public class SlotReservationServlet extends HttpServlet {

    private Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .setPrettyPrinting()
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            switch (action != null ? action : "") {
                case "check-availability":
                    checkSlotAvailability(request, response);
                    break;
                case "get-active":
                    getActiveReservation(request, response);
                    break;
                case "get-by-status":
                    getReservationsByStatus(request, response);
                    break;
                case "cleanup":
                    cleanupExpiredReservations(request, response);
                    break;
                case "get-booked-slots":
                    getBookedSlots(request, response);
                    break;
                default:
                    showDemo(request, response);
                    break;
            }
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            switch (action != null ? action : "") {
                case "create-reservation":
                    createReservation(request, response);
                    break;
                case "confirm":
                    confirmReservation(request, response);
                    break;
                case "complete":
                    completeReservation(request, response);
                    break;
                case "cancel":
                    cancelReservation(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Action không hợp lệ");
                    break;
            }
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Tạo reservation mới - tạm khóa slot trong 5 phút
     */
    private void createReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDateStr = request.getParameter("workDate");
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            int patientId = getPatientIdFromSession(request);
            String reason = request.getParameter("reason");
            
            LocalDate workDate = LocalDate.parse(workDateStr);
            
            // Kiểm tra có reservation active không
            SlotReservation existing = AppointmentDAO.getActiveReservationByPatient(patientId);
            if (existing != null) {
                sendErrorResponse(response, "Bạn đã có một reservation đang active. " +
                    "Thời gian còn lại: " + existing.getRemainingTime());
                return;
            }
            
            SlotReservation reservation = AppointmentDAO.createReservation(
                doctorId, workDate, slotId, patientId, reason);
            
            if (reservation != null) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Đã tạm khóa slot thành công!");
                result.put("reservation", reservation);
                result.put("remainingTime", reservation.getRemainingTime());
                result.put("expiresAt", reservation.getExpiresAt().toString());
                
                response.getWriter().write(gson.toJson(result));
            } else {
                sendErrorResponse(response, "Không thể tạo reservation. Slot có thể đã được đặt.");
            }
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Tham số không hợp lệ");
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Kiểm tra slot có available không
     */
    private void checkSlotAvailability(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDateStr = request.getParameter("workDate");
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            
            LocalDate workDate = LocalDate.parse(workDateStr);
            
            boolean available = AppointmentDAO.isSlotAvailable(doctorId, workDate, slotId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("available", available);
            result.put("message", available ? "Slot có thể đặt" : "Slot đã được đặt");
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Lấy reservation đang active của patient
     */
    private void getActiveReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int patientId = getPatientIdFromSession(request);
            
            SlotReservation reservation = AppointmentDAO.getActiveReservationByPatient(patientId);
            
            Map<String, Object> result = new HashMap<>();
            if (reservation != null) {
                result.put("hasActive", true);
                result.put("reservation", reservation);
                result.put("remainingTime", reservation.getRemainingTime());
                result.put("isExpired", reservation.isExpired());
            } else {
                result.put("hasActive", false);
                result.put("message", "Không có reservation đang active");
            }
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Confirm reservation - chuyển sang chờ thanh toán
     */
    private void confirmReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String payosOrderId = request.getParameter("payosOrderId");
            
            boolean success = AppointmentDAO.confirmReservation(appointmentId, payosOrderId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? 
                "Đã confirm reservation, chờ thanh toán PayOS" : 
                "Không thể confirm reservation");
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Complete reservation - hoàn thành sau khi thanh toán
     */
    private void completeReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            
            boolean success = AppointmentDAO.completeReservation(appointmentId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? 
                "Đã hoàn thành reservation thành công!" : 
                "Không thể hoàn thành reservation");
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Cancel reservation
     */
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            
            boolean success = AppointmentDAO.cancelReservation(appointmentId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? 
                "Đã hủy reservation thành công" : 
                "Không thể hủy reservation");
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Lấy reservations theo status
     */
    private void getReservationsByStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            String status = request.getParameter("status");
            if (status == null) status = AppointmentDAO.STATUS_RESERVED;
            
            List<SlotReservation> reservations = AppointmentDAO.getReservationsByStatus(status);
            
            Map<String, Object> result = new HashMap<>();
            result.put("status", status);
            result.put("count", reservations.size());
            result.put("reservations", reservations);
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Dọn dẹp reservations hết hạn
     */
    private void cleanupExpiredReservations(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int cleaned = AppointmentDAO.cleanupExpiredReservations();
            
            Map<String, Object> result = new HashMap<>();
            result.put("cleaned", cleaned);
            result.put("message", "Đã dọn dẹp " + cleaned + " reservations hết hạn");
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Lấy danh sách slots đã được đặt để disable trên UI
     */
    private void getBookedSlots(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDateStr = request.getParameter("workDate");
            LocalDate workDate = LocalDate.parse(workDateStr);
            
            List<Integer> bookedSlots = AppointmentDAO.getBookedSlots(doctorId, workDate);
            
            Map<String, Object> result = new HashMap<>();
            result.put("doctorId", doctorId);
            result.put("workDate", workDateStr);
            result.put("bookedSlots", bookedSlots);
            result.put("count", bookedSlots.size());
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            sendErrorResponse(response, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Demo page với hướng dẫn sử dụng
     */
    private void showDemo(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().write("""
            <!DOCTYPE html>
            <html>
            <head>
                <title>SlotReservation Demo - Tích hợp vào AppointmentDAO</title>
                <meta charset="UTF-8">
                <style>
                    body { font-family: Arial; padding: 20px; }
                    .demo-box { border: 1px solid #ddd; padding: 15px; margin: 10px 0; }
                    .success { color: green; }
                    .error { color: red; }
                    button { padding: 8px 15px; margin: 5px; }
                </style>
            </head>
            <body>
                <h1>🎯 SlotReservation Demo - Đã tích hợp vào AppointmentDAO</h1>
                <p><strong>✅ ĐÃ TÍCH HỢP</strong> - Sử dụng AppointmentDAO thống nhất, không cần bảng mới</p>
                
                <div class="demo-box">
                    <h3>📋 Cách hoạt động:</h3>
                    <ul>
                        <li><strong>Tạm khóa slot:</strong> Tạo record trong Appointment với status "ĐANG GIỮ CHỖ"</li>
                        <li><strong>Hết hạn 5 phút:</strong> Tự động chuyển status thành "HẾT HẠN"</li>
                        <li><strong>Confirm:</strong> Chuyển status thành "CHờ THANH TOÁN"</li>
                        <li><strong>Hoàn thành:</strong> Chuyển status thành "ĐÃ ĐẶT"</li>
                        <li><strong>Bôi xám slot:</strong> API getBookedSlots để disable UI</li>
                    </ul>
                </div>

                <div class="demo-box">
                    <h3>🧪 Test APIs:</h3>
                    
                    <h4>1. Tạo Reservation (POST)</h4>
                    <button onclick="testCreateReservation()">Tạo Reservation Demo</button>
                    <div id="create-result"></div>
                    
                    <h4>2. Kiểm tra Active Reservation (GET)</h4>
                    <button onclick="testGetActive()">Lấy Active Reservation</button>
                    <div id="active-result"></div>
                    
                    <h4>3. Lấy Booked Slots (GET) - Để bôi xám UI</h4>
                    <button onclick="testGetBookedSlots()">Lấy Slots Đã Đặt</button>
                    <div id="booked-result"></div>
                    
                    <h4>4. Complete Reservation (POST) - Sau thanh toán</h4>
                    <button onclick="testComplete()">Complete Demo</button>
                    <div id="complete-result"></div>
                    
                    <h4>5. Dọn dẹp Expired (GET)</h4>
                    <button onclick="testCleanup()">Cleanup Expired</button>
                    <div id="cleanup-result"></div>
                </div>

                <div class="demo-box">
                    <h3>📊 Status Constants (AppointmentDAO):</h3>
                    <ul>
                        <li><code>ĐANG GIỮ CHỖ</code> - Slot đang tạm khóa 5 phút</li>
                        <li><code>CHờ THANH TOÁN</code> - Đã confirm, chờ PayOS</li>
                        <li><code>ĐÃ ĐẶT</code> - Hoàn thành thành công (bôi xám)</li>
                        <li><code>HẾT HẠN</code> - Quá 5 phút không confirm</li>
                        <li><code>ĐÃ HỦY</code> - Bị hủy bởi user</li>
                    </ul>
                </div>

                <script>
                    async function testCreateReservation() {
                        try {
                            const response = await fetch('/RoleStaff/slot-reservation', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'action=create-reservation&doctorId=1&workDate=2024-12-25&slotId=1&reason=Test reservation'
                            });
                            const result = await response.json();
                            document.getElementById('create-result').innerHTML = 
                                '<pre class="' + (result.success ? 'success' : 'error') + '">' + 
                                JSON.stringify(result, null, 2) + '</pre>';
                        } catch (e) {
                            document.getElementById('create-result').innerHTML = 
                                '<div class="error">Error: ' + e.message + '</div>';
                        }
                    }

                    async function testGetActive() {
                        try {
                            const response = await fetch('/RoleStaff/slot-reservation?action=get-active');
                            const result = await response.json();
                            document.getElementById('active-result').innerHTML = 
                                '<pre>' + JSON.stringify(result, null, 2) + '</pre>';
                        } catch (e) {
                            document.getElementById('active-result').innerHTML = 
                                '<div class="error">Error: ' + e.message + '</div>';
                        }
                    }

                    async function testGetBookedSlots() {
                        try {
                            const response = await fetch('/RoleStaff/slot-reservation?action=get-booked-slots&doctorId=1&workDate=2024-12-25');
                            const result = await response.json();
                            document.getElementById('booked-result').innerHTML = 
                                '<pre class="success">' + JSON.stringify(result, null, 2) + '</pre>';
                        } catch (e) {
                            document.getElementById('booked-result').innerHTML = 
                                '<div class="error">Error: ' + e.message + '</div>';
                        }
                    }

                    async function testComplete() {
                        try {
                            const response = await fetch('/RoleStaff/slot-reservation', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'action=complete&appointmentId=1'
                            });
                            const result = await response.json();
                            document.getElementById('complete-result').innerHTML = 
                                '<pre class="' + (result.success ? 'success' : 'error') + '">' + 
                                JSON.stringify(result, null, 2) + '</pre>';
                        } catch (e) {
                            document.getElementById('complete-result').innerHTML = 
                                '<div class="error">Error: ' + e.message + '</div>';
                        }
                    }

                    async function testCleanup() {
                        try {
                            const response = await fetch('/RoleStaff/slot-reservation?action=cleanup');
                            const result = await response.json();
                            document.getElementById('cleanup-result').innerHTML = 
                                '<pre class="success">' + JSON.stringify(result, null, 2) + '</pre>';
                        } catch (e) {
                            document.getElementById('cleanup-result').innerHTML = 
                                '<div class="error">Error: ' + e.message + '</div>';
                        }
                    }
                </script>
            </body>
            </html>
        """);
    }

    /**
     * Lấy patientId từ session
     */
    private int getPatientIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user != null && "PATIENT".equals(user.getRole())) {
            // Giả sử có patientId trong session hoặc lấy từ database
            Object patientId = session.getAttribute("patientId");
            if (patientId != null) {
                return (Integer) patientId;
            }
        }
        
        // Default patient ID cho demo
        return 1;
    }

    /**
     * Gửi error response
     */
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        response.getWriter().write(gson.toJson(error));
    }

    /**
     * LocalDate adapter cho Gson
     */
    private static class LocalDateAdapter implements com.google.gson.JsonSerializer<LocalDate>, 
                                                    com.google.gson.JsonDeserializer<LocalDate> {
        @Override
        public com.google.gson.JsonElement serialize(LocalDate date, java.lang.reflect.Type type, 
                                                    com.google.gson.JsonSerializationContext context) {
            return new com.google.gson.JsonPrimitive(date.toString());
        }

        @Override
        public LocalDate deserialize(com.google.gson.JsonElement json, java.lang.reflect.Type type, 
                                   com.google.gson.JsonDeserializationContext context) {
            return LocalDate.parse(json.getAsString());
        }
    }
} 