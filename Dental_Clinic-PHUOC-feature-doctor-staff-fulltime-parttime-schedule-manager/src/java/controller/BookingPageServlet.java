/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.ServiceDAO;
import dao.TimeSlotDAO;
import dao.DoctorScheduleDAO;
import model.Appointment;
import model.Doctors;
import model.Service;
import model.TimeSlot;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.DoctorSchedule;
import model.User;
import jakarta.servlet.annotation.WebServlet;
import java.time.LocalDate;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.sql.Date;
import java.util.Map;
import java.util.HashMap;

/**
 *
 * @author Home & TranHongPhuoc
 */
// @WebServlet annotation removed - using web.xml mapping instead
public class BookingPageServlet extends HttpServlet {

    private List<DoctorSchedule> schedules;
    private List<String> workDates;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingPageServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingPageServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("user");
        
        // Kiểm tra session và role
        if (session == null || patient == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Kiểm tra role PATIENT
        if (!"PATIENT".equalsIgnoreCase(patient.getRole())) {
            request.setAttribute("error", "Bạn không có quyền truy cập trang này!");
            request.getRequestDispatcher("/jsp/error/404.jsp").forward(request, response);
            return;
        }
        
        try {
            // XỬ LÝ SERVICEID - Lấy thông tin dịch vụ nếu có
            String serviceIdStr = request.getParameter("serviceId");
            Service selectedService = null;
            if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
                try {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    ServiceDAO serviceDAO = new ServiceDAO();
                    selectedService = serviceDAO.getServiceById(serviceId);
                    request.setAttribute("selectedService", selectedService);
                    System.out.println("🎯 Service được chọn: " + selectedService.getServiceName() + " - " + selectedService.getPrice() + " VNĐ");
                } catch (NumberFormatException e) {
                    System.err.println("ServiceId không hợp lệ: " + serviceIdStr);
                }
            }
            
            // Xử lý request AJAX cho timeslots (giống StaffBookingServlet)
            if (request.getParameter("ajax") != null) {
                handleGetTimeSlots(request, response);
                    return;
            }
            
            // Xử lý request thông thường
            List<Appointment> appointments = AppointmentDAO.getAppointmentsByPatientId(patient.getUserId());
            request.setAttribute("appointments", appointments);
            System.out.println("Appointments: " + appointments);
            
            // Lấy danh sách bác sĩ
            List<Doctors> doctors = DoctorDAO.getAllDoctors();
            if (doctors != null) {
                for (Doctors doctor : doctors) {
                    // ✅ LOGIC MỚI: Lấy ngày làm việc bằng cách loại bỏ ngày nghỉ
                    List<String> workDates = DoctorScheduleDAO.getWorkDatesExcludingLeaves((int) doctor.getDoctor_id(), 14); // 14 ngày tới
                    doctor.setWorkDates(workDates);
                    
                    // Vẫn giữ schedules để hiển thị thông tin nghỉ phép (nếu cần)
                    DoctorScheduleDAO dsDAO = new DoctorScheduleDAO();
                    List<DoctorSchedule> schedules = dsDAO.getSchedulesByDoctorId((long) doctor.getDoctor_id());
                    doctor.setSchedules(schedules);
                    
                    System.out.println("👨‍⚕️ Bác sĩ " + doctor.getFull_name() + " có " + workDates.size() + " ngày làm việc");
                }
            }
            request.setAttribute("doctors", doctors);
            System.out.println("Doctors: " + doctors);
            
            // Lấy danh sách chuyên khoa
            List<String> specialties = DoctorDAO.getAllSpecialties();
            request.setAttribute("specialties", specialties);
            System.out.println("Specialties: " + specialties);
            
            // Lấy danh sách dịch vụ để hiển thị trong popup chọn dịch vụ
            try {
                ServiceDAO serviceDAO = new ServiceDAO();
                List<Service> services = serviceDAO.getAllServices();
                request.setAttribute("services", services);
                System.out.println("Services loaded: " + services.size());
            } catch (Exception e) {
                System.err.println("Error loading services: " + e.getMessage());
                request.setAttribute("services", new ArrayList<>());
            }
            
            // Lấy danh sách ngày làm việc của bác sĩ (nếu có doctorId)
            String doctorIdStr = request.getParameter("doctor_id");
            List<String> workDates = new ArrayList<>();
            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                try {
                    int doctorId = Integer.parseInt(doctorIdStr);
                    workDates = DoctorScheduleDAO.getWorkDatesByDoctorId(doctorId);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu không hợp lệ
                }
            }
            request.setAttribute("workDates", workDates);
            
            request.getRequestDispatcher("/jsp/patient/user_datlich.jsp").forward(request, response);
            
        } catch (ServletException | IOException | NumberFormatException e) {
            if (!response.isCommitted()) {
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/jsp/error/404.jsp").forward(request, response);
            } else {
                System.err.println("Không thể forward vì response đã commit: " + e.getMessage());
            }
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Lấy dữ liệu từ form đặt lịch
        String doctorIdStr = request.getParameter("doctorId");
        String workDate = request.getParameter("workDate");
        String slotIdStr = request.getParameter("slotId");
        String reason = request.getParameter("reason");
        String serviceIdStr = request.getParameter("serviceId"); // Nhận serviceId từ form
        
        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("user");

        // Kiểm tra session
        if (patient == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Kiểm tra dữ liệu đầu vào
        if (doctorIdStr == null || workDate == null || slotIdStr == null) {
            request.setAttribute("error", "Thiếu thông tin đặt lịch!");
            doGet(request, response);
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            int slotId = Integer.parseInt(slotIdStr);
            LocalDate appointmentDate = LocalDate.parse(workDate);
            
            // Kiểm tra slot có available không trước khi chuyển sang thanh toán
            if (!AppointmentDAO.isSlotAvailable(doctorId, appointmentDate, slotId)) {
                request.setAttribute("error", "Slot đã được đặt. Vui lòng chọn slot khác!");
                doGet(request, response);
                return;
            }
            
            // CHUYỂN HƯỚNG ĐẾN PAYOSSERVLET ĐỂ THANH TOÁN
            // Sử dụng serviceId từ form, nếu không có thì dùng mặc định
            String finalServiceId = (serviceIdStr != null && !serviceIdStr.isEmpty()) ? serviceIdStr : "1";
            
            String paymentUrl = String.format(
                "%s/payment?serviceId=%s&doctorId=%s&workDate=%s&slotId=%s&reason=%s",
                request.getContextPath(),
                finalServiceId,
                doctorId,
                workDate,
                slotId,
                reason != null ? java.net.URLEncoder.encode(reason, "UTF-8") : ""
            );
            
            System.out.println("🎯 BOOKING REQUEST -> PAYMENT");
            System.out.println("🏥 Service: " + finalServiceId + " | Doctor: " + doctorId + " | Date: " + workDate + " | Slot: " + slotId);
            System.out.println("🔗 Redirecting to: " + paymentUrl);
            
            response.sendRedirect(paymentUrl);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin không hợp lệ: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("Error in booking: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Lấy danh sách khung giờ của bác sĩ với thông tin đã đặt
     */
    private void handleGetTimeSlots(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String workDate = request.getParameter("workDate");
            LocalDate localDate = LocalDate.parse(workDate);
            
            System.out.println("Getting timeslots for doctorId: " + doctorId + ", workDate: " + workDate);
            
            // Lấy danh sách slot_id mà bác sĩ đã đăng ký và được xác nhận
            List<Integer> approvedSlotIds = DoctorScheduleDAO.getAvailableSlotIdsByDoctorAndDate(doctorId, workDate);
            System.out.println("✅ Available slot IDs (NEW LOGIC): " + approvedSlotIds);
            
            // Lấy danh sách slot đã được đặt
            List<Integer> bookedSlotIds = AppointmentDAO.getBookedSlots(doctorId, localDate);
            System.out.println("Booked slot IDs: " + bookedSlotIds);
            
            // Convert doctor schedule slot IDs to actual time slot IDs
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
                boolean isBooked = bookedSlotIds.contains(slot.getSlotId());
                
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"slotId\":").append(slot.getSlotId()).append(",");
                json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
                json.append("\"endTime\":\"").append(slot.getEndTime()).append("\",");
                json.append("\"isBooked\":").append(isBooked);
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
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
