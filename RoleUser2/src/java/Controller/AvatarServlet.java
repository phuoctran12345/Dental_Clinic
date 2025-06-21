/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DBConnection;
import Model.HospitalDB;
import Model.Patients;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.util.Base64;


import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author Home
 */
@MultipartConfig
public class AvatarServlet extends HttpServlet {

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
            out.println("<title>Servlet AvatarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AvatarServlet at " + request.getContextPath() + "</h1>");
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

    String idParam = request.getParameter("userId");
    if (idParam == null || idParam.isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing user ID");
        return;
    }

    int userId = Integer.parseInt(idParam);

    Part filePart = request.getPart("avatar");
    if (filePart == null || filePart.getSize() == 0) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing avatar image");
        return;
    }

    InputStream inputStream = filePart.getInputStream();
    byte[] imageBytes = inputStream.readAllBytes();
    String base64 = Base64.getEncoder().encodeToString(imageBytes);
    String contentType = filePart.getContentType();
    String base64WithHeader = "data:" + contentType + ";base64," + base64;

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "UPDATE Patients SET avatar = ? WHERE user_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, base64WithHeader);
        stmt.setInt(2, userId);
        stmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        return;
    }

    // ✅ Cập nhật avatar mới vào session
     HttpSession session = request.getSession(false);
    if (session != null) {
        // Load lại Patients từ DB
        Patients updatedPatient = HospitalDB.getPatientByUserId(userId);
        if (updatedPatient != null) {
            session.setAttribute("patient", updatedPatient);
        }
    }

    // Quay về trang chủ
    response.sendRedirect("patient/user_homepage.jsp");
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
