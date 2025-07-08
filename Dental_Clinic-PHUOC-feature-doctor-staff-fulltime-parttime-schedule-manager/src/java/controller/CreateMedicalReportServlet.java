package controller;

import dao.DoctorDAO;
import dao.AppointmentDAO;
import dao.PatientDAO;
import model.Doctors;
import model.Patients;
import model.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet để hiển thị form tạo phiếu khám
 * @author ASUS
 */
public class CreateMedicalReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        model.User user = (model.User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("/login.jsp?error=session_expired");
            return;
        }

        // Lấy doctor từ user_id
        Doctors doctor = DoctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor == null) {
            response.sendRedirect("/login.jsp?error=doctor_not_found");
            return;
        }

        try {
            // Lấy appointmentId từ parameter
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu ID cuộc hẹn");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr.trim());
            
            // ✅ FIX: Tạo object AppointmentDAO trước khi gọi method non-static
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                System.err.println("ERROR - No appointment found with ID: " + appointmentId);
                request.setAttribute("error", "Không tìm thấy cuộc hẹn với ID: " + appointmentId);
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }
            
            // Debug logging
            System.out.println("DEBUG - Appointment found:");
            System.out.println("  - appointment_id: " + appointment.getAppointmentId());
            System.out.println("  - patient_id: " + appointment.getPatientId());
            System.out.println("  - doctor_id: " + appointment.getDoctorId());
            System.out.println("  - status: " + appointment.getStatus());
            
            // Kiểm tra appointment có hợp lệ không
            if (appointment.getPatientId() <= 0) {
                System.err.println("ERROR - Invalid patient_id in appointment: " + appointment.getPatientId());
                request.setAttribute("error", "Appointment không có patient_id hợp lệ");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }
            
            // ✅ FIX: Lấy thông tin bệnh nhân từ appointment đã có sẵn
            Patients patient = PatientDAO.getPatientById(appointment.getPatientId());
            if (patient == null) {
                System.err.println("ERROR - No patient found with patient_id: " + appointment.getPatientId());
                request.setAttribute("error", "Không tìm thấy bệnh nhân với patient_id: " + appointment.getPatientId() + 
                                           ". Có thể dữ liệu bị không nhất quán trong database.");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }
            
            // Debug logging
            System.out.println("DEBUG - Patient found:");
            System.out.println("  - patient_id: " + patient.getPatientId());
            System.out.println("  - full_name: " + patient.getFullName());
            
            // Set thông tin vào session và request
            session.setAttribute("currentPatient", patient);
            request.setAttribute("appointment", appointment);
            request.setAttribute("patient", patient);
            request.setAttribute("doctor", doctor);
            
            // Forward đến trang phiếu khám
            request.getRequestDispatcher("/jsp/doctor/phieukham.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID cuộc hẹn không hợp lệ");
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị form tạo phiếu khám";
    }
} 