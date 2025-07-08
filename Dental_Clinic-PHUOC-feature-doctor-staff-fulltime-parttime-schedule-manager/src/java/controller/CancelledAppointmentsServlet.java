package controller;

import dao.AppointmentDAO;
import model.Appointment;
import model.Doctors;
import model.User;
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
        
        // Lấy session và kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("No session found, redirecting to login");
            response.sendRedirect("/login.jsp");
            return;
        }
        
        // Lấy thông tin user và doctor từ session
        User user = (User) session.getAttribute("user");
        Doctors doctor = (Doctors) session.getAttribute("doctor");
        
        if (user == null || doctor == null) {
            System.out.println("User or Doctor object not found in session");
            response.sendRedirect("/login.jsp");
            return;
        }
        
        System.out.println("Found user: " + user.getEmail() + ", doctor: " + doctor.getFullName());
        System.out.println("Doctor ID: " + doctor.getDoctorId());

        try {
            
            System.out.println("Fetching all appointments for doctor ID: " + doctor.getDoctorId());
            
            // Sử dụng method mới: getAllAppointmentsByDoctorId
            List<Appointment> allAppointments = AppointmentDAO.getAllAppointmentsByDoctorId(doctor.getDoctorId());
            System.out.println("Found " + (allAppointments != null ? allAppointments.size() : 0) + " total appointments");
            
            // Lọc chỉ lấy các cuộc hẹn đã hủy
            List<Appointment> cancelledAppointments = null;
            if (allAppointments != null) {
                System.out.println("DEBUG - Filtering cancelled appointments from " + allAppointments.size() + " total appointments");
                
                // Debug: In ra status của tất cả appointments
                for (Appointment app : allAppointments) {
                    System.out.println("DEBUG - Appointment ID: " + app.getAppointmentId() + 
                                     ", Status: '" + app.getStatus() + "'" +
                                     ", Patient: " + app.getPatientName());
                }
                
                cancelledAppointments = allAppointments.stream()
                    .filter(appointment -> {
                        String status = appointment.getStatus();
                        if (status == null) return false;
                        
                        // Kiểm tra tất cả các trường hợp có thể của status "cancelled"
                        boolean isCancelled = "cancelled".equalsIgnoreCase(status) || 
                                            "canceled".equalsIgnoreCase(status) ||
                                            "CANCELLED".equalsIgnoreCase(status) ||
                                            "CANCELED".equalsIgnoreCase(status) ||
                                            "Đã hủy".equalsIgnoreCase(status) ||
                                            AppointmentDAO.STATUS_CANCELLED.equalsIgnoreCase(status);
                        
                        System.out.println("DEBUG - Appointment " + appointment.getAppointmentId() + 
                                         " status '" + status + "' is cancelled: " + isCancelled);
                        
                        return isCancelled;
                    })
                    .collect(Collectors.toList());
            }
            
            System.out.println("Found " + (cancelledAppointments != null ? cancelledAppointments.size() : 0) + " cancelled appointments");
            
            // Set attributes cho JSP
            request.setAttribute("cancelledAppointments", cancelledAppointments);
            request.setAttribute("doctorId", doctor.getDoctorId());
            request.setAttribute("doctorName", doctor.getFullName());
            request.setAttribute("userId", user.getUserId());
            
            // Forward đến JSP để hiển thị
            request.getRequestDispatcher("/jsp/doctor/doctor_bihuy.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            
            // Set error attributes
            request.setAttribute("error", "Lỗi khi lấy danh sách cuộc hẹn đã hủy: " + e.getMessage());
            request.setAttribute("cancelledAppointments", null);
            
            // Forward tới JSP để hiển thị lỗi
            request.getRequestDispatcher("/jsp/doctor/doctor_bihuy.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("cancelledAppointments", null);
            
            request.getRequestDispatcher("/jsp/doctor/doctor_bihuy.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý các action như gửi thông báo ở đây
        doGet(request, response);
    }
    
    
} 