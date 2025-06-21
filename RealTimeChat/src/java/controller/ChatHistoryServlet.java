/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import util.DBUtil;

import java.io.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.ChatMessage;

/**
 *
 * @author Home
 */
public class ChatHistoryServlet extends HttpServlet {

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
            out.println("<title>Servlet ChatHistoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChatHistoryServlet at " + request.getContextPath() + "</h1>");
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

    Integer currentUserId = (Integer) request.getSession().getAttribute("user_id");
    String receiverIdParam = request.getParameter("receiverId");

    if (currentUserId == null || receiverIdParam == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }

    int receiverId;
    try {
        receiverId = Integer.parseInt(receiverIdParam);
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }

    List<ChatMessage> messages = new ArrayList<>();

    try (Connection conn = DBUtil.getConnection()) {
        String sql = """
            SELECT user_id, receiver_id, message_content, timestamp 
            FROM ChatMessages
            WHERE (user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)
            ORDER BY timestamp ASC
        """;

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, currentUserId);
        stmt.setInt(2, receiverId);
        stmt.setInt(3, receiverId);
        stmt.setInt(4, currentUserId);

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            ChatMessage msg = new ChatMessage();
            msg.setUserId(rs.getInt("user_id")); // sẽ được đổi thành senderId khi trả JSON
            msg.setReceiverId(rs.getInt("receiver_id"));
            msg.setContent(rs.getString("message_content"));
            msg.setTimestamp(rs.getTimestamp("timestamp"));
            messages.add(msg);
        }

        // Trả JSON về phía client
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        JSONArray jsonArray = new JSONArray();
        for (ChatMessage msg : messages) {
            JSONObject json = new JSONObject();
            json.put("senderId", msg.getUserId()); // đổi tên key ở đây
            json.put("receiverId", msg.getReceiverId());
            json.put("content", msg.getContent());
            json.put("timestamp", msg.getTimestamp().toString());
            jsonArray.put(json);
        }

        out.print(jsonArray.toString());
        out.flush();

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}

    /*
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
    