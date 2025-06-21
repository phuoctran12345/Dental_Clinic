package controller;

import dao.UserDAO;
import model.ChatMessage;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import utils.DBContext;

@WebServlet("/chat-history")
public class ChatHistoryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("📜 ChatHistoryServlet - Starting to load chat history");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String otherUserIdStr = request.getParameter("otherUserId");
        Integer currentUserId = (Integer) request.getSession().getAttribute("user_id");
        
        System.out.println("🔍 Parameters - currentUserId: " + currentUserId + ", otherUserId: " + otherUserIdStr);
        
        if (currentUserId == null || otherUserIdStr == null) {
            System.out.println("❌ Missing parameters for chat history");
            response.getWriter().write("[]");
            return;
        }
        
        try {
            int otherUserId = Integer.parseInt(otherUserIdStr);
            List<ChatMessage> messages = getChatHistory(currentUserId, otherUserId);
            
            System.out.println("💬 Found " + messages.size() + " messages between users " + currentUserId + " and " + otherUserId);
            
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(messages);
            response.getWriter().write(jsonResponse);
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid otherUserId format: " + otherUserIdStr);
            response.getWriter().write("[]");
        }
    }
    
    private List<ChatMessage> getChatHistory(int userId1, int userId2) {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT sender_id, receiver_id, message, created_at FROM chat_messages " +
                    "WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) " +
                    "ORDER BY created_at ASC";
        
        System.out.println("🗄️ Executing SQL: " + sql);
        System.out.println("🔢 Parameters: userId1=" + userId1 + ", userId2=" + userId2);
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId1);
            ps.setInt(2, userId2);
            ps.setInt(3, userId2);
            ps.setInt(4, userId1);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage message = new ChatMessage();
                    message.setSenderId(rs.getInt("sender_id"));
                    message.setReceiverId(rs.getInt("receiver_id"));
                    message.setMessage(rs.getString("message"));
                    message.setTimestamp(rs.getTimestamp("created_at"));
                    messages.add(message);
                    
                    System.out.println("💌 Message: " + rs.getInt("sender_id") + " -> " + rs.getInt("receiver_id") + ": " + rs.getString("message"));
                }
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Database error loading chat history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
} 