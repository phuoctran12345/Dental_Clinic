/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.HospitalDB;
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
 */
public class RegisterInformation extends HttpServlet {

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
            out.println("<title>Servlet RegisterInformation</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterInformation at " + request.getContextPath() + "</h1>");
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

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("signup.jsp?error=session_expired");
            return;
        }

        // Lấy lại thông tin đã lưu ở bước 1
        String email = (String) session.getAttribute("temp_email");
        String password = (String) session.getAttribute("temp_password");

        if (email == null || password == null) {
            response.sendRedirect("signup.jsp?error=session_expired");
            return;
        }

        // Lấy thông tin từ form
        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String dateOfBirth = request.getParameter("date_of_birth");
        String gender = request.getParameter("gender");

        // Tạo tài khoản trước
        int userId = HospitalDB.registerPatient(email, password);

        if (userId > 0) {
            // Lưu thông tin cá nhân
            boolean success = HospitalDB.savePatientInfo(userId, fullName, phone, dateOfBirth, gender);

            if (success) {
                // Xóa session tạm
                session.removeAttribute("temp_email");
                session.removeAttribute("temp_password");

                // Đăng nhập luôn nếu muốn
                session.setAttribute("id", userId);

                // Chuyển sang trang login hoặc homepage
                response.sendRedirect("login.jsp");
            } else {
                // (Tùy chọn) Xóa user nếu lưu info thất bại
                // HospitalDB.deleteUser(userId);

                response.sendRedirect("information.jsp?error=save_failed");
            }
        } else {
            response.sendRedirect("signup.jsp?error=register_failed");
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
