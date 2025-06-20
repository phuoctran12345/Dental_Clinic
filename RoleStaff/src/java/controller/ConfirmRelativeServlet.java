/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;


import dao.AppointmentDAO;
import dao.PatientDAO;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Home
 *  Đặt lịch cho người thân 
 */
public class ConfirmRelativeServlet extends HttpServlet {

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
            out.println("<title>Servlet ConfirmRelativeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ConfirmRelativeServlet at " + request.getContextPath() + "</h1>");
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

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu người thân từ form
        String fullName = request.getParameter("full_name");
        String dateOfBirth = request.getParameter("date_of_birth");
        String gender = request.getParameter("gender");

        // Lấy thông tin lịch hẹn
        String scheduleIdStr = request.getParameter("schedule_id");
        String workDate = request.getParameter("work_date");
        String startTime = request.getParameter("start_time");

        System.out.println("=== FORM DATA ===");
        System.out.println("Full name: " + fullName);
        System.out.println("Date of birth: " + dateOfBirth);
        System.out.println("Gender: " + gender);
        System.out.println("Schedule ID: " + scheduleIdStr);
        System.out.println("Work Date: " + workDate);
        System.out.println("Start Time: " + startTime);

        int scheduleId = Integer.parseInt(scheduleIdStr);

        // Lấy user hiện tại từ session (người đặt hộ)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // hoặc Patients nếu bạn gộp

        if (user == null) {
            System.out.println("❌ User chưa đăng nhập. Chuyển về login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();
        
        System.out.println("Current userId: " + userId);

        // Lưu người thân mới vào bảng Patients
        int newPatientId = PatientDAO.findOrInsertRelativePatient(fullName, dateOfBirth, gender);

        System.out.println(">>> insertRelativePatientAndReturnId result: " + newPatientId);

        if (newPatientId == -1) {
            System.out.println("❌ Lưu thông tin người thân thất bại.");
            request.setAttribute("message", "Lưu thông tin người thân thất bại.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        boolean success = AppointmentDAO.insertAppointmentForRelative(scheduleId, newPatientId, workDate, startTime, userId);
        if (success) {
            System.out.println("✅ Đặt lịch thành công cho người thân.");
            request.setAttribute("message", "Đặt lịch cho người thân thành công!");
        } else {
            System.out.println("❌ Đặt lịch thất bại.");
            request.setAttribute("message", "Đặt lịch thất bại.");
        }

        System.out.println("✅ Chuyển hướng đến datlich-thanhcong.jsp");
        request.getRequestDispatcher("datlich-thanhcong.jsp").forward(request, response);
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
