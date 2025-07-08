package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctors;
import model.Patients;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "ReexaminationServlet", urlPatterns = {"/doctor/reexamination"})
public class ReexaminationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        try {
            // Lấy thông tin từ parameters
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu thông tin cuộc hẹn");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Lấy thông tin cuộc hẹn gốc
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment originalAppointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (originalAppointment == null) {
                request.setAttribute("error", "Không tìm thấy cuộc hẹn");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin bệnh nhân
            Patients patient = PatientDAO.getPatientById(originalAppointment.getPatientId());
            
            // Lấy thông tin bác sĩ
            Doctors doctor = DoctorDAO.getDoctorByUserId(user.getUserId());

            // Set attributes cho form tái khám
            request.setAttribute("originalAppointment", originalAppointment);
            request.setAttribute("patient", patient);
            request.setAttribute("doctor", doctor);

            // Forward đến trang tạo lịch tái khám
            request.getRequestDispatcher("/jsp/doctor/doctor_taikham.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("SQL Error in ReexaminationServlet: " + e.getMessage());
            request.setAttribute("error", "Lỗi database: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in ReexaminationServlet: " + e.getMessage());
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            long doctorId = Long.parseLong(request.getParameter("doctorId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            String workDateStr = request.getParameter("workDate");
            String reason = request.getParameter("reason");

            // Parse ngày tái khám
            LocalDate workDate = LocalDate.parse(workDateStr, DateTimeFormatter.ISO_DATE);

            // Tạo appointment mới cho tái khám
            Appointment reexamination = new Appointment();
            reexamination.setPatientId(patientId);
            reexamination.setDoctorId(doctorId);
            reexamination.setSlotId(slotId);
            reexamination.setWorkDate(workDate);
            reexamination.setReason("Tái khám: " + reason);
            reexamination.setStatus(AppointmentDAO.STATUS_BOOKED);

            // Lưu lịch tái khám
            int newAppointmentId = AppointmentDAO.createAppointmentStatic(reexamination);

            if (newAppointmentId > 0) {
                // Thành công - redirect về trang chi tiết cuộc hẹn mới
                response.sendRedirect("/doctor/appointment?id=" + newAppointmentId);
            } else {
                // Thất bại
                request.setAttribute("error", "Không thể tạo lịch tái khám");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error creating reexamination: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tạo lịch tái khám: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        }
    }
} 