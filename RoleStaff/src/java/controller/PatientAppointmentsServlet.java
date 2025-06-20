package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctors;
import model.Patients;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PatientAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy session và user
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Lấy patient_id từ bảng Patients dựa vào user_id
            Patients patient = PatientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân!");
                request.getRequestDispatcher("/jsp/patient/user_datlich_bacsi.jsp").forward(request, response);
                return;
            }
            
            // Lấy danh sách cuộc hẹn từ database
            int patientId = patient.getPatientId();
            List<Appointment> appointments = AppointmentDAO.getAppointmentsByPatientId(patientId);
            
            // Debug log
            System.out.println("User ID: " + user.getId());
            System.out.println("Patient ID: " + patientId);
            System.out.println("Appointments found: " + (appointments != null ? appointments.size() : 0));
            
            // Lấy danh sách bác sĩ với tìm kiếm và lọc
            String keyword = request.getParameter("keyword");
            String specialty = request.getParameter("specialty");
            
            List<Doctors> doctors = DoctorDAO.filterDoctors(keyword, specialty);
            List<String> specialties = DoctorDAO.getAllSpecialties();
            
            // Set attributes cho JSP
            request.setAttribute("appointment", appointments);
            request.setAttribute("doctors", doctors);
            request.setAttribute("specialties", specialties);
            
            // Forward đến JSP
            request.getRequestDispatcher("/jsp/patient/user_datlich_bacsi.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/jsp/patient/user_datlich_bacsi.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Chuyển về GET để xử lý
        doGet(request, response);
    }
} 