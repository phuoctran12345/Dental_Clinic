package controller;

import dao.NotificationDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import model.Notification;
import java.util.List;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Lấy user từ session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        NotificationDAO notifDAO = new NotificationDAO();
        
        if ("markAsRead".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("id"));
            boolean success = notifDAO.markAsRead(notificationId);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": " + success + "}");
            return;
        }
        
        // Lấy danh sách thông báo chưa đọc
        List<Notification> unreadNotifs = notifDAO.getUnreadNotifications(user.getUserId());
        request.setAttribute("unreadNotifs", unreadNotifs);
        
        // Lấy 10 thông báo gần nhất
        List<Notification> notifications = notifDAO.getRecentNotifications(user.getUserId(), 10);
        request.setAttribute("notifications", notifications);
        
        // Forward tới JSP tương ứng (nếu cần)
        String viewPath = request.getParameter("view");
        if (viewPath != null) {
            request.getRequestDispatcher(viewPath).forward(request, response);
        }
    }
} 