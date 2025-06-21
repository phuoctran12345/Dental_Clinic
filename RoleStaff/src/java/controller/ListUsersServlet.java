package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/list-users")
public class ListUsersServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("👥 ListUsersServlet - Loading users list for chat");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Get current user ID from session 
        Integer currentUserId = (Integer) request.getSession().getAttribute("user_id");
        System.out.println("🔍 Current user ID from session: " + currentUserId);
        
        try {
            // Get all users except current user
            List<User> users = UserDAO.getAllUsersExcept(currentUserId != null ? currentUserId : -1);
            System.out.println("👨‍👩‍👧‍👦 Found " + users.size() + " other users for chat");
            
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(users);
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            System.out.println("❌ Error loading users list: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
} 