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

@WebServlet(name = "CompletedAppointmentsServlet", urlPatterns = {"/completedAppointments"})
public class CompletedAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CompletedAppointmentsServlet - doGet ===");
        
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
            
            // Lọc chỉ lấy các cuộc hẹn đã hoàn thành
            List<Appointment> completedAppointments = null;
            if (allAppointments != null) {
                completedAppointments = allAppointments.stream()
                    .filter(appointment -> "Hoàn tất".equalsIgnoreCase(appointment.getStatus()))
                    .collect(Collectors.toList());
            }
            
            System.out.println("Found " + (completedAppointments != null ? completedAppointments.size() : 0) + " completed appointments");
            
            // Đặt danh sách cuộc hẹn đã hoàn thành vào request attribute
            request.setAttribute("completedAppointments", completedAppointments);
            
            // Chuyển tiếp đến JSP để hiển thị
            request.getRequestDispatcher("doctor_ketqua.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            
            // Đặt thông báo lỗi vào request attribute
            request.setAttribute("error", "Lỗi khi lấy danh sách kết quả khám: " + e.getMessage());
            request.setAttribute("completedAppointments", null);
            
            // Vẫn forward tới JSP để hiển thị lỗi
            request.getRequestDispatcher("doctor_ketqua.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("completedAppointments", null);
            
            request.getRequestDispatcher("doctor_ketqua.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý các action khác ở đây
        doGet(request, response);
    }
} 