package Controller;

import Model.Appointment;
import Model.DoctorDB;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CancelledAppointmentsServlet", urlPatterns = {"/cancelledAppointments"})
public class CancelledAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CancelledAppointmentsServlet - doGet ===");
        
        // Lấy session và User object
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        Integer userId = null;
        
        if (user != null) {
            userId = user.getUserId();
            System.out.println("Session exists, User object found, userId: " + userId);
            System.out.println("User details: " + user.getEmail() + ", Role: " + user.getRole());
        } else {
            System.out.println("No user object found in session");
            
            // Thử cách cũ làm fallback
            if (session != null) {
                Object userIdObj = session.getAttribute("userId");
                if (userIdObj != null) {
                    userId = (Integer) userIdObj;
                    System.out.println("Found userId directly in session: " + userId);
                }
            }
        }
        
        // Kiểm tra nếu không có session hoặc userId
        if (userId == null) {
            System.out.println("No valid session/userId found, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("userId", userId);

        DoctorDB doctorDB = new DoctorDB();

        try {
            System.out.println("Fetching all appointments for userId: " + userId);
            // Lấy tất cả cuộc hẹn
            List<Appointment> allAppointments = doctorDB.getAppointmentsByUserId(userId);
            System.out.println("Found " + (allAppointments != null ? allAppointments.size() : 0) + " total appointments");
            
            // Lọc chỉ lấy các cuộc hẹn đã hủy
            List<Appointment> cancelledAppointments = null;
            if (allAppointments != null) {
                cancelledAppointments = allAppointments.stream()
                    .filter(appointment -> "Đã hủy".equalsIgnoreCase(appointment.getStatus()))
                    .collect(Collectors.toList());
            }
            
            System.out.println("Found " + (cancelledAppointments != null ? cancelledAppointments.size() : 0) + " cancelled appointments");
            
            // Đặt danh sách cuộc hẹn đã hủy vào request attribute
            request.setAttribute("cancelledAppointments", cancelledAppointments);
            
            // Chuyển tiếp đến JSP để hiển thị
            request.getRequestDispatcher("doctor_bihuy.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            
            // Đặt thông báo lỗi vào request attribute
            request.setAttribute("error", "Lỗi khi lấy danh sách cuộc hẹn đã hủy: " + e.getMessage());
            request.setAttribute("cancelledAppointments", null);
            
            // Vẫn forward tới JSP để hiển thị lỗi
            request.getRequestDispatcher("doctor_bihuy.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("cancelledAppointments", null);
            
            request.getRequestDispatcher("doctor_bihuy.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý các action như gửi thông báo ở đây
        doGet(request, response);
    }
} 