package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.DoctorScheduleDAO;
import dao.PatientDAO;
import dao.ServiceDAO;
import dao.TimeSlotDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.Doctors;
import model.Patients;
import model.Service;
import model.TimeSlot;
import model.User;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "StaffBookingServlet", urlPatterns = {"/StaffBookingServlet"})
public class StaffBookingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        try {
            if ("search_patient".equals(action)) {
                handleSearchPatient(request, response);
            } else if ("get_timeslots".equals(action)) {
                handleGetTimeSlots(request, response);
            } else if ("get_detail".equals(action)) {
                handleGetAppointmentDetail(request, response);
            } else {
                // Hiển thị trang chính
                loadInitialData(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_datlich.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            if ("book_appointment".equals(action)) {
                handleBookAppointment(request, response);
            } else if ("update_status".equals(action)) {
                handleUpdateAppointmentStatus(request, response);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi đặt lịch: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Tải dữ liệu ban đầu cho trang
     */
    private void loadInitialData(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách bác sĩ với error handling
            List<Doctors> doctors = new ArrayList<>();
            try {
                doctors = DoctorDAO.getAllDoctors();
                System.out.println("DEBUG: Loaded " + doctors.size() + " doctors");
            } catch (Exception e) {
                System.err.println("ERROR loading doctors: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("doctors", doctors);
            
            // Lấy danh sách dịch vụ với improved error handling
            List<Service> services = new ArrayList<>();
            try {
                System.out.println("DEBUG: Attempting to load services...");
                ServiceDAO serviceDAO = new ServiceDAO();
                services = serviceDAO.getAllServices();
                System.out.println("DEBUG: Successfully loaded " + services.size() + " services");
                
                // Thử cách khác nếu không có services
                if (services.isEmpty()) {
                    System.out.println("DEBUG: Services list is empty, trying alternative method...");
                    // Thử lấy services theo status
                    services = serviceDAO.getServicesByStatus("active");
                    System.out.println("DEBUG: Alternative method returned " + services.size() + " services");
                }
                
                // Debug: In ra 3 dịch vụ đầu
                if (!services.isEmpty()) {
                    System.out.println("DEBUG: First 3 services:");
                    for (int i = 0; i < Math.min(3, services.size()); i++) {
                        Service s = services.get(i);
                        System.out.println("  - " + s.getServiceId() + ": " + s.getServiceName() + " (" + s.getStatus() + ")");
                    }
                } else {
                    System.out.println("DEBUG: No services found at all!");
                }
            } catch (Exception e) {
                System.err.println("ERROR loading services: " + e.getMessage());
                e.printStackTrace();
                services = new ArrayList<>(); // Đảm bảo không null
            }
            request.setAttribute("services", services);
            System.out.println("DEBUG: Set services attribute with " + services.size() + " items");
            
            // Lấy danh sách chuyên khoa với error handling
            List<String> specialties = new ArrayList<>();
            try {
                specialties = DoctorDAO.getAllSpecialties();
            } catch (Exception e) {
                System.err.println("ERROR loading specialties: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("specialties", specialties);
            
            // Lấy lịch hẹn hôm nay với error handling
            List<Appointment> todayAppointments = new ArrayList<>();
            try {
                Date today = new Date(System.currentTimeMillis());
                AppointmentDAO appointmentDAO = new AppointmentDAO();
                todayAppointments = appointmentDAO.getAppointmentsByDate(today);
            } catch (Exception e) {
                System.err.println("Error loading today appointments: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("todayAppointments", todayAppointments);
            
            // Forward to JSP
            request.getRequestDispatcher("/jsp/staff/staff_datlich.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in loadInitialData: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_datlich.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý tìm kiếm bệnh nhân
     */
    private void handleSearchPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String phone = request.getParameter("phone");
        String name = request.getParameter("name");
        String format = request.getParameter("format");
        
        PatientDAO patientDAO = new PatientDAO();
        List<Patients> patients = new ArrayList<>();
        
        try {
            if (phone != null && !phone.trim().isEmpty()) {
                patients = patientDAO.searchByPhone(phone.trim());
            } else if (name != null && !name.trim().isEmpty()) {
                patients = patientDAO.searchByName(name.trim());
            }
            
            // Nếu yêu cầu JSON format
            if ("json".equals(format)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder();
                json.append("[");
                for (int i = 0; i < patients.size(); i++) {
                    Patients patient = patients.get(i);
                    if (i > 0) json.append(",");
                    json.append("{");
                    json.append("\"patientId\":").append(patient.getPatientId()).append(",");
                    json.append("\"fullName\":\"").append(patient.getFullName() != null ? patient.getFullName() : "").append("\",");
                    json.append("\"phone\":\"").append(patient.getPhone() != null ? patient.getPhone() : "").append("\",");
                    json.append("\"dateOfBirth\":\"").append(patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "").append("\",");
                    json.append("\"gender\":\"").append(patient.getGender() != null ? patient.getGender() : "").append("\"");
                    json.append("}");
                }
                json.append("]");
                
                response.getWriter().write(json.toString());
                return;
            } else {
                // Trả về HTML với dữ liệu JSON embedded
                request.setAttribute("patients", patients);
                
                // Tạo JSON data để embed vào HTML
                StringBuilder jsonData = new StringBuilder();
                jsonData.append("[");
                for (int i = 0; i < patients.size(); i++) {
                    Patients patient = patients.get(i);
                    if (i > 0) jsonData.append(",");
                    jsonData.append("{");
                    jsonData.append("\"patientId\":").append(patient.getPatientId()).append(",");
                    jsonData.append("\"fullName\":\"").append(patient.getFullName() != null ? patient.getFullName().replace("\"", "\\\"") : "").append("\",");
                    jsonData.append("\"phone\":\"").append(patient.getPhone() != null ? patient.getPhone() : "").append("\",");
                    jsonData.append("\"dateOfBirth\":\"").append(patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "").append("\",");
                    jsonData.append("\"gender\":\"").append(patient.getGender() != null ? patient.getGender() : "").append("\"");
                    jsonData.append("}");
                }
                jsonData.append("]");
                
                request.setAttribute("patientsJson", jsonData.toString());
                loadInitialData(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if ("json".equals(format)) {
                response.setContentType("application/json");
                response.getWriter().write("[]");
            } else {
                request.setAttribute("error", "Lỗi tìm kiếm: " + e.getMessage());
                loadInitialData(request, response);
            }
        }
    }
    
    /**
     * Lấy danh sách khung giờ trống của bác sĩ
     */
    private void handleGetTimeSlots(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDate = request.getParameter("workDate");
            
            System.out.println("Getting timeslots for doctorId: " + doctorId + ", workDate: " + workDate);
            
            // Lấy danh sách slot có thể đặt lịch
            List<Integer> approvedSlotIds = DoctorScheduleDAO.getAvailableSlotIdsByDoctorAndDate(doctorId, workDate);
            System.out.println("✅ Available slot IDs (NEW LOGIC): " + approvedSlotIds);
            
            // Convert doctor schedule slot IDs to actual time slot IDs
            //slot ID: 1 thì hãy list ra từ slot ID: 3002 -> 3009 ,  slot ID: 2 thì hãy list ra từ slot ID: 3010 -> 3019  ,  slot ID: 3 thì hãy list ra từ slot ID: 3002 -> 3019 
            List<Integer> actualTimeSlotIds = new ArrayList<>();
            for (Integer slotId : approvedSlotIds) {
                switch (slotId) {
                    case 1: // Ca sáng (8:00-12:00)
                        for (int i = 3002; i <= 3009; i++) {
                            actualTimeSlotIds.add(i);
                        }
                        break;
                    case 2: // Ca chiều (13:00-17:00)
                        for (int i = 3010; i <= 3019; i++) {
                            actualTimeSlotIds.add(i);
                        }
                        break;
                    case 3: // Cả ngày (8:00-17:00)
                        for (int i = 3002; i <= 3019; i++) {
                            actualTimeSlotIds.add(i);
                        }
                        break;
                    default:
                        System.out.println("Unknown slot ID: " + slotId);
                        break;
                }
            }
            
            System.out.println("Converted to actual time slot IDs: " + actualTimeSlotIds);
            
            // Lấy thông tin TimeSlot từ các slot_id thực tế
            List<TimeSlot> availableSlots = TimeSlotDAO.getTimeSlotsByIds(actualTimeSlotIds);
            System.out.println("Available time slots: " + availableSlots.size());
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < availableSlots.size(); i++) {
                TimeSlot slot = availableSlots.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"slotId\":").append(slot.getSlotId()).append(",");
                json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
                json.append("\"endTime\":\"").append(slot.getEndTime()).append("\"");
                json.append("}");
            }
            json.append("]");
            
            System.out.println("JSON response: " + json.toString());
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            System.err.println("Error in handleGetTimeSlots: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
    
    /**
     * Xử lý đặt lịch hẹn mới
     */
    private void handleBookAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            request.setAttribute("error", "Phiên đăng nhập đã hết hạn");
            doGet(request, response);
            return;
        }
        try {
            // Lấy thông tin từ form
            String bookingFor = request.getParameter("bookingFor");
            if ("relative".equals(bookingFor)) {
                // Gọi DAO riêng cho người thân (RelativesAppointmentDAO)
                // ... logic đặt lịch cho người thân ...
            } else {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            Date workDate = Date.valueOf(request.getParameter("workDate"));
            String reason = request.getParameter("reason");
            Appointment appointment = new Appointment();
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setSlotId(slotId);
                appointment.setWorkDate(workDate.toLocalDate());
            appointment.setReason(reason);
                appointment.setStatus(AppointmentDAO.STATUS_BOOKED);
            AppointmentDAO appointmentDAO = new AppointmentDAO();
                int appointmentId = appointmentDAO.createAppointment(appointment);
                // ... xử lý tiếp ...
            }
        } catch (Exception e) {
            // ... xử lý lỗi ...
        }
        doGet(request, response);
    }
    
    /**
     * Lấy chi tiết appointment
     */
    private void handleGetAppointmentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing appointmentId\"}");
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Lấy chi tiết appointment từ database
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Appointment not found\"}");
                return;
            }
            
            // Tạo JSON response
            StringBuilder json = new StringBuilder();
            json.append("{\"success\": true, \"appointment\": {");
            json.append("\"appointmentId\": ").append(appointment.getAppointmentId()).append(",");
            json.append("\"patientName\": \"").append(appointment.getPatientName() != null ? appointment.getPatientName() : "").append("\",");
            json.append("\"patientPhone\": \"").append(appointment.getPatientPhone() != null ? appointment.getPatientPhone() : "").append("\",");
            json.append("\"doctorName\": \"").append(appointment.getDoctorName() != null ? appointment.getDoctorName() : "").append("\",");
            json.append("\"serviceName\": \"").append(appointment.getServiceName() != null ? appointment.getServiceName() : "Chưa có").append("\",");
            json.append("\"workDate\": \"").append(appointment.getWorkDate() != null ? appointment.getWorkDate().toString() : "").append("\",");
            json.append("\"startTime\": \"").append(appointment.getFormattedStartTime()).append("\",");
            json.append("\"endTime\": \"").append(appointment.getFormattedEndTime()).append("\",");
            json.append("\"status\": \"").append(appointment.getStatus() != null ? appointment.getStatus() : "").append("\",");
            json.append("\"reason\": \"").append(appointment.getReason() != null ? appointment.getReason().replace("\"", "\\\"") : "").append("\"");
            json.append("}}");
            
            response.getWriter().write(json.toString());
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid appointmentId format\"}");
        } catch (Exception e) {
            System.err.println("Error getting appointment detail: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Internal server error\"}");
        }
    }
    
    /**
     * Cập nhật trạng thái appointment
     */
    private void handleUpdateAppointmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String appointmentIdStr = request.getParameter("appointmentId");
            String newStatus = request.getParameter("status");
            
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing appointmentId\"}");
                return;
            }
            
            if (newStatus == null || newStatus.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing status\"}");
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Cập nhật trạng thái trong database
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, newStatus);
            
            if (success) {
                System.out.println("✅ CẬP NHẬT TRẠNG THÁI THÀNH CÔNG: Appointment " + appointmentId + " → " + newStatus);
                response.getWriter().write("{\"success\": true, \"message\": \"Status updated successfully\"}");
            } else {
                System.err.println("❌ THẤT BẠI: Không thể cập nhật trạng thái cho appointment " + appointmentId);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update status\"}");
            }
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid appointmentId format\"}");
        } catch (Exception e) {
            System.err.println("Error updating appointment status: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Internal server error: " + e.getMessage() + "\"}");
        }
    }
} 