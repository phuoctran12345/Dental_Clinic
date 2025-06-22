package Controller;

import Model.DoctorDB;
import Model.Doctors;
import Model.Appointment;
import Model.Patients;
import Model.TimeSlot;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Date;

/**
 * Servlet xử lý chức năng tái khám
 * @author ASUS
 */
public class ReexaminationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Doctors doctor = (Doctors) session.getAttribute("doctor");
        
        if (doctor == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        try {
            // Lấy danh sách bệnh nhân cần tái khám (những người đã hoàn tất lịch khám)
            List<Appointment> completedAppointments = DoctorDB.getCompletedAppointmentsByDoctorId(doctor.getDoctorId());
            
            // Lấy danh sách khung giờ để hiển thị trong form đặt lịch
            List<TimeSlot> timeSlots = DoctorDB.getAllTimeSlots();
            
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("timeSlots", timeSlots);
            request.setAttribute("doctor", doctor);
            
            request.getRequestDispatcher("doctor_taikham.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("doctor_taikham.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Doctors doctor = (Doctors) session.getAttribute("doctor");
        
        if (doctor == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        try {
            // Lấy thông tin từ form
            int previousAppointmentId = Integer.parseInt(request.getParameter("previousAppointmentId"));
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String reexamDate = request.getParameter("reexamDate");
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                reason = "Tái khám theo hẹn";
            }
            
            // Kiểm tra xem khung giờ đã được đặt chưa
            boolean isSlotAvailable = DoctorDB.isSlotAvailable(doctor.getDoctorId(), reexamDate, slotId);
            
            if (!isSlotAvailable) {
                request.setAttribute("error", "Khung giờ này đã được đặt. Vui lòng chọn khung giờ khác.");
                doGet(request, response);
                return;
            }
            
            // Tạo lịch tái khám mới
            boolean success = DoctorDB.createReexaminationAppointment(
                patientId, 
                doctor.getDoctorId(), 
                reexamDate, 
                slotId, 
                reason, 
                previousAppointmentId
            );
            
            if (success) {
                request.setAttribute("success", "Đã tạo lịch tái khám thành công!");
            } else {
                request.setAttribute("error", "Không thể tạo lịch tái khám. Vui lòng thử lại.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu nhập vào không hợp lệ.");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Quay lại trang tái khám
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý chức năng tái khám";
    }
} 