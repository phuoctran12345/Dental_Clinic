/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AppointmentDAO;
import model.Patients;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Home
 */
public class ConfirmServlet extends HttpServlet {

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
            out.println("<title>Servlet ConfirmServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ConfirmServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        try {
            
            System.out.println("=== DEBUG ConfirmServlet doPost ===");
            
            // Lấy dữ liệu từ form (sửa tên parameters cho khớp với JSP)
            String slotIdStr = request.getParameter("slotId");
            String workDate = request.getParameter("workDate");
            String reason = request.getParameter("reason");
            String doctorIdStr = request.getParameter("doctorId");
            
            // Debug: In ra tất cả parameters
            System.out.println("Parameters received:");
            System.out.println("- slotId: " + slotIdStr);
            System.out.println("- workDate: " + workDate);
            System.out.println("- reason: " + reason);
            System.out.println("- doctorId: " + doctorIdStr);
            
            // Kiểm tra dữ liệu đầu vào
            if (slotIdStr == null || slotIdStr.isEmpty() ||
                    workDate == null || workDate.isEmpty() ||
                    doctorIdStr == null || doctorIdStr.isEmpty()) {
                System.out.println("ERROR: Missing required parameters!");
                request.setAttribute("message", "Vui lòng điền đầy đủ thông tin!");
                request.getRequestDispatcher("/jsp/patient/datlich-thanhcong.jsp").forward(request, response);
                return;
            }
            
            int slotId = Integer.parseInt(slotIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            System.out.println("Parsed values - slotId: " + slotId + ", doctorId: " + doctorId);
            
            // Lấy thông tin bệnh nhân từ session (sửa để dùng User object)
            HttpSession session = request.getSession();
            System.out.println("Session ID tại servlet: " + session.getId());
            model.User user = (model.User) session.getAttribute("user");
            if (user == null) {
                System.out.println("ERROR: Không tìm thấy user trong session");
                request.setAttribute("message", "Vui lòng đăng nhập để đặt lịch!");
                request.getRequestDispatcher("/jsp/patient/datlich-thanhcong.jsp").forward(request, response);
                return;
            }
            
            System.out.println("User found - ID: " + user.getId() + ", Username: " + user.getUsername());
            
            // Lấy patient_id từ bảng Patients dựa vào user_id
            dao.PatientDAO patientDAO = new dao.PatientDAO();
            model.Patients patient = dao.PatientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                System.out.println("ERROR: Không tìm thấy patient record cho user_id: " + user.getId());
                request.setAttribute("message", "Không tìm thấy thông tin bệnh nhân. Vui lòng cập nhật thông tin cá nhân!");
                request.getRequestDispatcher("/jsp/patient/datlich-thanhcong.jsp").forward(request, response);
                return;
            }
            
            int patientId = patient.getPatientId();
            System.out.println("Patient found - patient_id: " + patientId + ", user_id: " + patient.getId());
            
            try {
                LocalDate parsedWorkDate = LocalDate.parse(workDate);
                System.out.println("Parsed work date: " + parsedWorkDate);
                
                // Lấy thông tin thời gian từ TimeSlot dựa vào slotId
                dao.TimeSlotDAO timeSlotDAO = new dao.TimeSlotDAO();
                model.TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(slotId);
                if (timeSlot == null) {
                    System.out.println("ERROR: TimeSlot not found for slotId: " + slotId);
                    request.setAttribute("message", "Ca khám không hợp lệ!");
                    request.getRequestDispatcher("/jsp/patient/datlich-thanhcong.jsp").forward(request, response);
                    return;
                }
                LocalTime startTime = timeSlot.getStartTime();
                System.out.println("TimeSlot found - Start: " + startTime + ", End: " + timeSlot.getEndTime());
                
                // Kiểm tra xem lịch đã được đặt chưa
                System.out.println("Checking if appointment exists...");
                if (AppointmentDAO.checkAppointmentExistsBySlotId(slotId, parsedWorkDate, startTime)) {
                    System.out.println("ERROR: Appointment already exists!");
                    request.setAttribute("message", "Lịch này đã được đặt. Vui lòng chọn lịch khác!");
                    request.getRequestDispatcher("/jsp/patient/datlich-thanhcong.jsp").forward(request, response);
                    return;
                }
                
                // Gọi DAO để lưu vào bảng Appointment
                System.out.println("Attempting to insert appointment...");
                System.out.println("Data to insert:");
                System.out.println("- slotId: " + slotId);
                System.out.println("- patientId: " + patientId);
                System.out.println("- doctorId: " + doctorId);
                System.out.println("- workDate: " + parsedWorkDate);
                System.out.println("- startTime: " + startTime);
                System.out.println("- reason: " + reason);
                
                boolean success = AppointmentDAO.insertAppointmentBySlotId(
                        slotId,
                        patientId,
                        doctorId,
                        parsedWorkDate,
                        startTime,
                        reason
                );
                
                System.out.println("Insert result: " + success);
                if (success) {
                    System.out.println("SUCCESS: Appointment inserted successfully!");
                    request.setAttribute("message", "Đặt lịch thành công!");
                } else {
                    System.out.println("ERROR: Failed to insert appointment!");
                    request.setAttribute("message", "Đặt lịch thất bại. Vui lòng thử lại.");
                }
            } catch (Exception e) {
                System.err.println("EXCEPTION in ConfirmServlet: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("message", "Có lỗi xảy ra khi đặt lịch. Vui lòng thử lại!");
            }
            
            request.getRequestDispatcher("/jsp/patient/datlich-thanhcong.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ConfirmServlet.class.getName()).log(Level.SEVERE, null, ex);
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
