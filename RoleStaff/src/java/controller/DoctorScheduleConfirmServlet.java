/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.DoctorDAO;
import dao.DoctorScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DoctorSchedule;
import model.Doctors;

/**
 *
 * @author tranhongphuoc
 */
public class DoctorScheduleConfirmServlet extends HttpServlet {
   
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
            out.println("<title>Servlet DoctorScheduleConfirmServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DoctorScheduleConfirmServlet at " + request.getContextPath() + "</h1>");
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

    try {
        int doctorId = Integer.parseInt(request.getParameter("doctor_id"));
        
        // Lấy danh sách lịch làm việc còn trống của bác sĩ
        List<DoctorSchedule> availableSchedules = DoctorScheduleDAO.getAvailableSchedulesByDoctor(doctorId);
        request.setAttribute("availableSchedules", availableSchedules);

        // Lấy thông tin bác sĩ
        Doctors doctor = DoctorDAO.getDoctorById(doctorId);
        request.setAttribute("doctor", doctor);

        // Forward sang trang JSP hiển thị lịch
        request.getRequestDispatcher("/jsp/patient/user_datlich.jsp").forward(request, response);
        
    }catch (NumberFormatException e) {
        // Trường hợp doctor_id không hợp lệ
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID không hợp lệ");
    }   catch (SQLException ex) {
            Logger.getLogger(DoctorScheduleConfirmServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        // Bọc SQLException trong ServletException
        
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
        processRequest(request, response);
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
