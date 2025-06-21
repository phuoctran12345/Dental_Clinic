/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.User;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Home
 */
public class ListUsersServlet extends HttpServlet {

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
            out.println("<title>Servlet ListUsersServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListUsersServlet at " + request.getContextPath() + "</h1>");
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

    int currentUserId = (int) request.getSession().getAttribute("user_id");
    String currentUserRole = (String) request.getSession().getAttribute("role");
    List<User> userList = new ArrayList<>();

    try (Connection conn = DBUtil.getConnection()) {
        String sql = "";

        if ("PATIENT".equalsIgnoreCase(currentUserRole)) {
            sql = """
                SELECT u.user_id, u.email, u.role, d.full_name
                FROM Users u
                JOIN Doctors d ON u.user_id = d.user_id
                WHERE u.role = 'DOCTOR'
            """;
        } else if ("DOCTOR".equalsIgnoreCase(currentUserRole)) {
            sql = """
                SELECT u.user_id, u.email, u.role,
                       COALESCE(p.full_name, d.full_name) AS full_name
                FROM Users u
                LEFT JOIN Patients p ON u.user_id = p.user_id
                LEFT JOIN Doctors d ON u.user_id = d.user_id
                WHERE u.user_id <> ?
            """;
        } else if ("ADMIN".equalsIgnoreCase(currentUserRole)) {
            sql = """
                SELECT u.user_id, u.email, u.role,
                       COALESCE(p.full_name, d.full_name) AS full_name
                FROM Users u
                LEFT JOIN Patients p ON u.user_id = p.user_id
                LEFT JOIN Doctors d ON u.user_id = d.user_id
                WHERE u.user_id <> ?
            """;
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        PreparedStatement stmt = conn.prepareStatement(sql);
        if ("ADMIN".equalsIgnoreCase(currentUserRole) || "DOCTOR".equalsIgnoreCase(currentUserRole)) {
            stmt.setInt(1, currentUserId);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getString("role"));
            user.setFullName(rs.getString("full_name"));
            userList.add(user);
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("[");
        for (int i = 0; i < userList.size(); i++) {
            User u = userList.get(i);
            out.print("{\"user_id\":" + u.getUserId()
                    + ",\"email\":\"" + u.getEmail()
                    + "\",\"role\":\"" + u.getRole()
                    + "\",\"full_name\":\"" + (u.getFullName() != null ? u.getFullName() : "") + "\"}");
            if (i < userList.size() - 1) {
                out.print(",");
            }
        }
        out.print("]");

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
