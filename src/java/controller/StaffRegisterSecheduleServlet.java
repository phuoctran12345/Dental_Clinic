/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.StaffDAO;
import dao.StaffScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.ColoredLogger;
import model.Staff;
import model.User;

/**
 *
 * @author tranhongphuoc
 */
@WebServlet(name="StaffRegisterSecheduleServlet", urlPatterns={"/StaffRegisterSecheduleServlet"})
public class StaffRegisterSecheduleServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(StaffRegisterSecheduleServlet.class.getName());
    private StaffDAO staffDAO;
    private StaffScheduleDAO scheduleDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        staffDAO = new StaffDAO();
        scheduleDAO = new StaffScheduleDAO();
        LOGGER.info("StaffRegisterSecheduleServlet initialized");
    }
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ColoredLogger.logInfo("StaffRegisterSecheduleServlet", "Processing request in StaffRegisterSecheduleServlet");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            ColoredLogger.logWarning("StaffRegisterSecheduleServlet", "User not logged in, redirecting to login page");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String jspPath = "/jsp/staff/staff_dangkilich.jsp"; // Default JSP path
        
        try {
            Staff staff = staffDAO.getStaffByUserId(user.getId());
            if (staff == null) {
                ColoredLogger.logError("StaffRegisterSecheduleServlet", "Staff not found for user ID: " + user.getId());
                request.setAttribute("error", "Không tìm thấy thông tin nhân viên!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            ColoredLogger.logSuccess("StaffRegisterSecheduleServlet", "Staff found: " + staff.getStaffId() + ", Type: " + staff.getEmploymentType());
            request.setAttribute("staff", staff);
            
            // Set common data
            java.time.LocalDate now = java.time.LocalDate.now();
            int currentMonth = now.getMonthValue();
            int currentYear = now.getYear();
            request.setAttribute("currentMonth", currentMonth);
            request.setAttribute("currentYear", currentYear);
            
            // Forward to appropriate page based on employment type
            if ("fulltime".equals(staff.getEmploymentType())) {
                ColoredLogger.logInfo("StaffRegisterSecheduleServlet", "Setting up data for full-time staff");
                jspPath = "/jsp/staff/staff_xinnghi.jsp";
                
                // Tính số ngày nghỉ đã sử dụng trong tháng
                int usedDays = scheduleDAO.getApprovedLeaveDaysInMonth((int) staff.getStaffId(), currentMonth, currentYear);
                int maxDays = 6; // Tối đa 6 ngày/tháng
                int remainingDays = maxDays - usedDays;
                
                // Set attributes cho JSP
                request.setAttribute("usedDays", usedDays);
                request.setAttribute("maxDays", maxDays);
                request.setAttribute("remainingDays", remainingDays);
                
                // Lấy lịch sử yêu cầu nghỉ phép
                java.util.List<model.StaffSchedule> scheduleRequests = scheduleDAO.getStaffSchedulesByMonth((int) staff.getStaffId(), currentMonth, currentYear);
                request.setAttribute("scheduleRequests", scheduleRequests);
                
                ColoredLogger.logInfo("StaffRegisterSecheduleServlet", "Set leave data: used=" + usedDays + ", max=" + maxDays + ", remaining=" + remainingDays);
            } else {
                ColoredLogger.logInfo("StaffRegisterSecheduleServlet", "Setting up data for part-time staff");
                
                // Lấy lịch làm việc đã đăng ký
                java.util.List<model.StaffSchedule> scheduleRequests = scheduleDAO.getStaffSchedulesByMonth((int) staff.getStaffId(), currentMonth, currentYear);
                request.setAttribute("scheduleRequests", scheduleRequests);
                
                // Lấy danh sách 3 ca làm việc chính (slotId 1,2,3) cho parttime
                dao.TimeSlotDAO timeSlotDAO = new dao.TimeSlotDAO();
                // Lấy 3 ca chính
                java.util.List<model.TimeSlot> timeSlots = timeSlotDAO.getMainTimeSlots();
                request.setAttribute("timeSlots", timeSlots);
            }
            
        } catch (SQLException ex) {
            ColoredLogger.logError("StaffRegisterSecheduleServlet", "Database error occurred: " + ex.getMessage());
            request.setAttribute("error", "Lỗi kết nối cơ sở dữ liệu: " + ex.getMessage());
        } catch (Exception ex) {
            ColoredLogger.logError("StaffRegisterSecheduleServlet", "Unexpected error occurred: " + ex.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
        }
        
        // Final forward
        request.getRequestDispatcher(jspPath).forward(request, response);
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
        LOGGER.info("Handling GET request");
        processRequest(request, response);
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
        LOGGER.info("Handling POST request");
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Staff Schedule Registration Servlet";
    }// </editor-fold>

}
