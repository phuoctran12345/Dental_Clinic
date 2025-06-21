/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Appointment;
import Model.Doctors;
import Model.HospitalDB;
import Model.Patients;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Home
 */
public class BookingPageServlet extends HttpServlet {

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

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("patient") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Patients patient = (Patients) session.getAttribute("patient");

    // Lấy danh sách lịch hẹn của bệnh nhân
    List<Appointment> appointment = HospitalDB.getAppointmentsByPatientId(patient.getPatientId());
    request.setAttribute("appointment", appointment);

    // Lấy từ khóa tìm kiếm (nếu có)
    String keyword = request.getParameter("keyword");
    String specialty = request.getParameter("specialty");

    List<Doctors> doctors;
    if ((keyword != null && !keyword.isEmpty()) || (specialty != null && !specialty.isEmpty())) {
        // Nếu có keyword hoặc chuyên khoa => lọc
        doctors = HospitalDB.filterDoctors(keyword, specialty);
    } else {
        // Nếu không lọc gì => lấy toàn bộ
        doctors = HospitalDB.getAllDoctors();
    }

    request.setAttribute("doctors", doctors);

    // Lấy danh sách chuyên khoa để đổ dropdown
    List<String> specialties = HospitalDB.getAllSpecialties();
    request.setAttribute("specialties", specialties);

    request.getRequestDispatcher("user_datlich_bacsi.jsp").forward(request, response);
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
        processRequest(request, response);
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
