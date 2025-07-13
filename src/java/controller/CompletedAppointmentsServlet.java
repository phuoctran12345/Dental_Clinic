package controller;

import model.Appointment;
import dao.AppointmentDAO;
import dao.DoctorDAO;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "CompletedAppointmentsServlet", urlPatterns = {"/completedAppointments"})
public class CompletedAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CompletedAppointmentsServlet - doGet ===");
        // Lấy session và kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("No session found, redirecting to login");
            response.sendRedirect("/login.jsp");
            return;
        }
        // Lấy thông tin user từ session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.out.println("User object not found in session");
            response.sendRedirect("/login.jsp");
            return;
        }
        System.out.println("Found user: " + user.getEmail());
        System.out.println("User ID: " + user.getId());
        // Lấy thông tin doctor từ user_id
        Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
        if (doctor == null) {
            System.out.println("❌ Không tìm thấy doctor cho userId: " + user.getId());
            request.setAttribute("error", "Không tìm thấy thông tin bác sĩ");
            request.getRequestDispatcher("/jsp/doctor/doctor_ketqua.jsp").forward(request, response);
            return;
        }
        System.out.println("Found doctor: " + doctor.getFull_name());
        System.out.println("Doctor ID: " + doctor.getDoctor_id());
        try {
            System.out.println("Fetching all appointments for doctor ID: " + doctor.getDoctor_id());
            
            // Sử dụng AppointmentDAO để lấy appointments của bác sĩ
            List<Appointment> allAppointments = AppointmentDAO.getAllAppointmentsByDoctorId(doctor.getDoctor_id());
            System.out.println("Found " + (allAppointments != null ? allAppointments.size() : 0) + " total appointments");
            
            // Lọc chỉ lấy các cuộc hẹn đã hoàn thành
            List<Appointment> completedAppointments = null;
            if (allAppointments != null) {
                completedAppointments = allAppointments.stream()
                        .filter(appointment -> "COMPLETED".equalsIgnoreCase(appointment.getStatus()) ||
                                "FINISHED".equalsIgnoreCase(appointment.getStatus()))
                        .collect(Collectors.toList());
            }
            
            System.out.println("Found " + (completedAppointments != null ? completedAppointments.size() : 0) + " completed appointments");
            
            // Set attributes cho JSP
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("doctorId", doctor.getDoctor_id());
            request.setAttribute("doctorName", doctor.getFull_name());
            request.setAttribute("userId", user.getId());
            
            // Forward đến JSP để hiển thị
            request.getRequestDispatcher("/jsp/doctor/doctor_ketqua.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            
            // Set error attributes
            request.setAttribute("error", "Lỗi khi lấy danh sách kết quả khám: " + e.getMessage());
            request.setAttribute("completedAppointments", null);
            request.setAttribute("doctorId", doctor != null ? doctor.getDoctor_id() : null);
            request.setAttribute("doctorName", doctor != null ? doctor.getFull_name() : null);
            request.setAttribute("userId", user.getId());
            
            // Forward tới JSP để hiển thị lỗi
            request.getRequestDispatcher("/jsp/doctor/doctor_ketqua.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý các action khác ở đây
        doGet(request, response);
    }
} 