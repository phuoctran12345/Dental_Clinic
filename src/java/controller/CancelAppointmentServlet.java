/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.DoctorScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.EmailService;
import model.Doctors;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author tranhongphuoc
 */
@WebServlet(name="CancelAppointmentServlet", urlPatterns={"/CancelAppointmentServlet"})
public class CancelAppointmentServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet CancelAppointmentServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CancelAppointmentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                //call ra để xử lý render lịch hẹn
        String action = request.getParameter("action");
        if ("getSlots".equals(action)) {
            handleGetTimeSlotsForStaff(request, response);
            return;
        }
        try {
            // Lấy danh sách lịch hẹn từ DAO với thông tin chi tiết
            List<model.Appointment> appointments = new dao.AppointmentDAO().getAllAppointmentsWithDetails();
            System.out.println("[DEBUG] appointments size: " + (appointments != null ? appointments.size() : "null"));
            if (appointments != null) {
                for (model.Appointment ap : appointments) {
                    System.out.println("[DEBUG] Appointment: id=" + ap.getAppointmentId() + ", status=" + ap.getStatus() + ", doctorId=" + ap.getDoctorId());
                }
            }
            // Lấy danh sách bác sĩ
            List<Doctors> doctors = DoctorDAO.getAllDoctors();
            System.out.println("[DEBUG] Số lượng bác sĩ: " + doctors.size());
            
            // Lấy ngày làm việc của từng bác sĩ
            Map<Long, List<String>> workDates = new HashMap<>();
            for (Doctors doctor : doctors) {
                List<String> days = DoctorScheduleDAO.getWorkDatesByDoctorId((int) doctor.getDoctor_id());
                workDates.put(doctor.getDoctor_id(), days);
                System.out.println("[DEBUG] DoctorId: " + doctor.getDoctor_id() + 
                                 " - Số ngày làm việc: " + (days != null ? days.size() : 0));
            }
            
            // Set attributes cho JSP
            request.setAttribute("appointments", appointments);
            request.setAttribute("doctors", doctors);
            request.setAttribute("workDates", workDates);
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi lấy danh sách lịch hẹn: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Forward sang JSP
        request.getRequestDispatcher("/jsp/staff/staff_quanlylichhen.jsp").forward(request, response);
    } 

    /**
     * Endpoint lấy danh sách slot cho staff đổi lịch (có logic che slot đã qua giờ bắt đầu + 10 phút)
     */
    private void handleGetTimeSlotsForStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            String doctorIdParam = request.getParameter("doctorId");
            String workDate = request.getParameter("workDate");
            System.out.println("[DEBUG] getSlots doctorIdParam: " + doctorIdParam + ", workDate: " + workDate);
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty() || workDate == null || workDate.trim().isEmpty()) {
                System.out.println("[DEBUG] getSlots thiếu doctorId hoặc workDate");
                response.getWriter().write("[]");
                return;
            }
            int doctorId = Integer.parseInt(doctorIdParam);
            java.time.LocalDate localDate = java.time.LocalDate.parse(workDate);
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalTime now = java.time.LocalTime.now();
            // Lấy slot trống bằng TimeSlotDAO (tái sử dụng code)
            java.util.List<model.TimeSlot> availableSlots = dao.TimeSlotDAO.getAvailableSlotsByDoctorAndDate(doctorId, workDate);
            System.out.println("[DEBUG] availableSlots: " + (availableSlots != null ? availableSlots.size() : "null"));
            java.util.List<Integer> bookedSlotIds = dao.AppointmentDAO.getBookedSlots(doctorId, localDate);
            System.out.println("[DEBUG] bookedSlotIds: " + bookedSlotIds);
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < availableSlots.size(); i++) {
                model.TimeSlot slot = availableSlots.get(i);
                boolean isBooked = bookedSlotIds.contains(slot.getSlotId());
                boolean isPast = localDate.equals(today) && slot.getStartTime().plusMinutes(10).isBefore(now); // xử lý thêm + thêm 10p để render ra lịch 
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"slotId\":").append(slot.getSlotId()).append(",");
                json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
                json.append("\"endTime\":\"").append(slot.getEndTime()).append("\",");
                json.append("\"isBooked\":").append(isBooked).append(",");
                json.append("\"isPast\":").append(isPast);
                json.append("}");
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception in getSlots: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("appointmentId");
        String rescheduleFlag = request.getParameter("reschedule");
        String message = "";
        boolean success = false;

        if (idStr != null) {
            try {
                int appointmentId = Integer.parseInt(idStr);
                if (rescheduleFlag != null) {
                    String slotIdStr = request.getParameter("slotId");
                    String workDate = request.getParameter("workDate");
//                    boolean success = false;
                    if (slotIdStr != null && workDate != null) {
                        int slotId = Integer.parseInt(slotIdStr);
                        success = dao.AppointmentDAO.updateAppointmentForReschedule(appointmentId, workDate, slotId);
                    }
                    if (success) {
                        message = "Đổi lịch thành công.";
                    } else {
                        message = "Không thể đổi lịch. Vui lòng thử lại.";
                    }
                } else {
                    // HUỶ LỊCH như cũ
                    String cancelReason = request.getParameter("cancelReason");
                    String cancelNote = request.getParameter("cancelNote");
                    success = dao.AppointmentDAO.updateAppointmentStatusStatic(appointmentId, dao.AppointmentDAO.STATUS_CANCELLED);
                    if (success) {
                        model.Appointment ap = dao.AppointmentDAO.getAppointmentWithPatientInfo(appointmentId);
                        String[] emails = dao.AppointmentDAO.getEmailsFromAppointment(appointmentId);
                        String patientEmail = emails[0];
                        String patientName = ap != null && ap.getPatientName() != null ? ap.getPatientName() : "Khách hàng";
                        String dateTime = ap != null && ap.getWorkDate() != null ? ap.getWorkDate().toString() : "";
                        if (ap != null && ap.getStartTime() != null) dateTime += " " + ap.getStartTime().toString();
                        String service = ap != null && ap.getServiceName() != null ? ap.getServiceName() : "";
                        utils.EmailService.sendCancelAppointmentEmail(patientEmail, patientName, dateTime, service, cancelReason, cancelNote);
                        message = "Huỷ lịch thành công và đã gửi thông báo cho bệnh nhân.";
                    } else {
                        message = "Không thể huỷ lịch. Vui lòng thử lại.";
                    }
                }
            } catch (Exception e) {
                message = "Lỗi: " + e.getMessage();
                e.printStackTrace();
            }
        } else {
            message = "Thiếu thông tin appointmentId.";
        }
        // Redirect lại trang với thông báo
        response.sendRedirect("CancelAppointmentServlet?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
