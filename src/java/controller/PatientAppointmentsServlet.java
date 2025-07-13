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
            
            // Lấy danh sách cuộc hẹn cá nhân từ database
            int patientId = patient.getPatientId();
            List<Appointment> appointments = AppointmentDAO.getAppointmentsByPatientId(patientId);
            
            // Load tên bác sĩ thật cho các cuộc hẹn cá nhân
            if (appointments != null && !appointments.isEmpty()) {
                for (Appointment apt : appointments) {
                    if (apt.getDoctorId() > 0) {
                        Doctors doctor = DoctorDAO.getDoctorById((int)apt.getDoctorId());
                        if (doctor != null) {
                            apt.setDoctorName(doctor.getFull_name());
                        } else {
                            apt.setDoctorName("Bác sĩ " + apt.getDoctorId());
                        }
                    }
                    // Load tên bệnh nhân nếu cần
                    if (apt.getPatientName() == null || apt.getPatientName().isEmpty()) {
                        apt.setPatientName(patient.getFullName());
                    }
                }
            }
            
            // Lấy danh sách cuộc hẹn của người thân (appointments được đặt bởi user này cho người khác)
            List<Appointment> relativeAppointments = AppointmentDAO.getRelativeAppointments(user.getId());
            System.out.println("DEBUG: ===== RELATIVE APPOINTMENTS DEBUG =====");
            System.out.println("DEBUG: Checking relative appointments for user ID: " + user.getId());
            System.out.println("DEBUG: User email: " + user.getEmail());
            System.out.println("DEBUG: Found " + (relativeAppointments != null ? relativeAppointments.size() : 0) + " relative appointments");
            
            // Load tên bác sĩ và bệnh nhân cho các cuộc hẹn người thân
            if (relativeAppointments != null && !relativeAppointments.isEmpty()) {
                System.out.println("DEBUG: Processing relative appointments...");
                for (Appointment apt : relativeAppointments) {
                    System.out.println("DEBUG: Processing appointment ID: " + apt.getAppointmentId());
                    System.out.println("DEBUG: Patient ID: " + apt.getPatientId() + ", Doctor ID: " + apt.getDoctorId());
                    
                    // Load tên bác sĩ
                    if (apt.getDoctorId() > 0) {
                        Doctors doctor = DoctorDAO.getDoctorById((int)apt.getDoctorId());
                        if (doctor != null) {
                            apt.setDoctorName(doctor.getFull_name());
                            System.out.println("DEBUG: Doctor name set: " + doctor.getFull_name());
                        } else {
                            apt.setDoctorName("Bác sĩ " + apt.getDoctorId());
                            System.out.println("DEBUG: Doctor not found, using fallback");
                        }
                    }
                    
                    // Load tên bệnh nhân (người thân)
                    if (apt.getPatientId() > 0) {
                        Patients relativePatient = PatientDAO.getPatientById(apt.getPatientId());
                        if (relativePatient != null) {
                            apt.setPatientName(relativePatient.getFullName());
                            System.out.println("DEBUG: Patient name set: " + relativePatient.getFullName());
                        } else {
                            apt.setPatientName("Bệnh nhân " + apt.getPatientId());
                            System.out.println("DEBUG: Patient not found, using fallback");
                        }
                    }
                    
                    System.out.println("DEBUG: Final appointment - Patient: " + apt.getPatientName() + 
                                     ", Doctor: " + apt.getDoctorName() + ", Date: " + apt.getFormattedWorkDate());
                }
            } else {
                System.out.println("DEBUG: No relative appointments found for user ID: " + user.getId());
            }
            
            // Debug log
            System.out.println("User ID: " + user.getId());
            System.out.println("Patient ID: " + patientId);
            System.out.println("Personal Appointments found: " + (appointments != null ? appointments.size() : 0));
            System.out.println("Relative Appointments found: " + (relativeAppointments != null ? relativeAppointments.size() : 0));
            
            // Lấy danh sách bác sĩ với tìm kiếm và lọc
            String keyword = request.getParameter("keyword");
            String specialty = request.getParameter("specialty");
            
            List<Doctors> doctors = DoctorDAO.filterDoctors(keyword, specialty);
            List<String> specialties = DoctorDAO.getAllSpecialties();
            
            // Set attributes cho JSP
            request.setAttribute("appointment", appointments);
            request.setAttribute("relativeAppointments", relativeAppointments);
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