/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.ServiceDAO;
import model.Appointment;
import model.Doctors;
import model.Service;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import com.google.gson.Gson;
import dao.DoctorScheduleDAO;
import model.DoctorSchedule;
import model.User;
import java.time.LocalDate;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Home & TranHongPhuoc
 */

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
            
            // Xử lý request AJAX
            if (request.getParameter("ajax") != null) {
                String doctorId = request.getParameter("doctorId");
                String workDate = request.getParameter("workDate");
                
                if (doctorId != null && workDate != null) {
                    Connection conn = utils.DBContext.getConnection();
                    // Trước tiên kiểm tra bác sĩ có làm việc ngày này không
                    String checkSql = "SELECT slot_id FROM DoctorSchedule WHERE doctor_id = ? AND work_date = ? AND status IN (N'approved', N'Đã xác nhận đăng kí lịch hẹn với bác sĩ')";
                    java.util.List<java.util.Map<String, Object>> slots = new java.util.ArrayList<>();
                    try {
                        PreparedStatement checkPs = conn.prepareStatement(checkSql);
                        checkPs.setInt(1, Integer.parseInt(doctorId));
                        checkPs.setDate(2, java.sql.Date.valueOf(workDate));
                        ResultSet checkRs = checkPs.executeQuery();
                        
                        boolean hasFullDaySchedule = false;
                        while (checkRs.next()) {
                            int slotId = checkRs.getInt("slot_id");
                            if (slotId == 3) { // Cả ngày (08:00-17:00)
                                hasFullDaySchedule = true;
                                break;
                            }
                        }
                        checkRs.close();
                        checkPs.close();
                        
                        // Nếu bác sĩ làm cả ngày, lấy tất cả slot 30 phút trong khoảng 08:00-17:00
                        if (hasFullDaySchedule) {
                            String slotsSql = "SELECT slot_id, start_time, end_time FROM TimeSlot " +
                                            "WHERE start_time >= '08:00:00' AND end_time <= '17:00:00' " +
                                            "AND slot_id >= 3002 AND slot_id <= 3019 ORDER BY start_time";
                            PreparedStatement slotsPs = conn.prepareStatement(slotsSql);
                            ResultSet slotsRs = slotsPs.executeQuery();
                            while (slotsRs.next()) {
                                java.util.Map<String, Object> slot = new java.util.HashMap<>();
                                slot.put("slotId", slotsRs.getInt("slot_id"));
                                slot.put("startTime", slotsRs.getTime("start_time").toString().substring(0,5));
                                slot.put("endTime", slotsRs.getTime("end_time").toString().substring(0,5));
                                slots.add(slot);
                            }
                            slotsRs.close();
                            slotsPs.close();
                        }
                        
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        System.out.println("Error in AJAX: " + e.getMessage());
                    }
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    System.out.println("Returning " + slots.size() + " slots for doctor " + doctorId + " on " + workDate);
                    response.getWriter().write(new Gson().toJson(slots));
                    response.getWriter().flush();
                    return;
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Thiếu tham số\"}");
                    response.getWriter().flush();
                    return;
                }
            }
            
            // Xử lý request thông thường
            List<Appointment> appointments = AppointmentDAO.getAppointmentsByPatientId(patient.getId());
            request.setAttribute("appointments", appointments);
            System.out.println("Appointments: " + appointments);
            
            // Lấy danh sách bác sĩ
            List<Doctors> doctors = DoctorDAO.getAllDoctors();
            if (doctors != null) {
                DoctorScheduleDAO dsDAO = new DoctorScheduleDAO();
                for (Doctors doctor : doctors) {
                    List<DoctorSchedule> schedules = dsDAO.getSchedulesByDoctorId(doctor.getDoctor_id());
                    doctor.setSchedules(schedules);

                    Set<String> workDates = schedules.stream()
                        .map(sch -> sch.getWorkDate().toString())
                        .collect(Collectors.toSet());
                    doctor.setWorkDates(new ArrayList<>(workDates));
                }
            }
            request.setAttribute("doctors", doctors);
            System.out.println("Doctors: " + doctors);
            
            // Lấy danh sách chuyên khoa
            List<String> specialties = DoctorDAO.getAllSpecialties();
            request.setAttribute("specialties", specialties);
            System.out.println("Specialties: " + specialties);
            
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
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
