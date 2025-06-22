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

@WebServlet(name = "DoctorAppointmentsServlet")
public class DoctorAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== DoctorAppointmentsServlet - doGet ===");
        
        // Lấy session và User object (giống như check_session.jsp)
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
        
        
        

        DoctorDB doctorDB = new DoctorDB();

        try {
            System.out.println("Fetching appointments for userId: " + userId);
            // Lấy danh sách cuộc hẹn
            List<Appointment> appointments = doctorDB.getAppointmentsByUserId(userId);
            System.out.println("Found " + (appointments != null ? appointments.size() : 0) + " appointments");
            
            // Đặt danh sách cuộc hẹn vào request attribute để JSP sử dụng
            request.setAttribute("appointments", appointments);
            
            // Chuyển tiếp đến JSP để hiển thị (cập nhật đường dẫn)
            request.getRequestDispatcher("doctor_trongngay.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            
            // Đặt thông báo lỗi vào request attribute
            request.setAttribute("error", "Lỗi khi lấy danh sách cuộc hẹn: " + e.getMessage());
            request.setAttribute("userId", userId);
            request.setAttribute("appointments", null);
            
            // Vẫn forward tới JSP để hiển thị lỗi
            request.getRequestDispatcher("doctor_trongngay.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("userId", userId);
            request.setAttribute("appointments", null);
            
            request.getRequestDispatcher("doctor_trongngay.jsp").forward(request, response);
        }
    }
}