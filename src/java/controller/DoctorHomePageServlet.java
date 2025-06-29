package controller;

import dao.DoctorDAO;
import dao.AppointmentDAO;
import dao.PatientDAO;
import model.Doctors;
import model.User;
import model.Appointment;
import model.Patients;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet để xử lý trang chủ của bác sĩ
 * @author tranhongphuoc
 */
public class DoctorHomePageServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== DoctorHomePageServlet - doGet ===");
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("❌ No session found, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy thông tin user và doctor từ session
        User user = (User) session.getAttribute("user");
        Doctors doctor = (Doctors) session.getAttribute("doctor");
        
        if (user == null) {
            System.out.println("❌ No user in session, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        System.out.println("✅ User found: " + user.getEmail() + " (Role: " + user.getRole() + ")");
        
        // Nếu không có doctor object trong session, lấy từ database
        if (doctor == null) {
            System.out.println("🔍 Doctor not in session, fetching from database...");
            doctor = DoctorDAO.getDoctorByUserId(user.getId());
            if (doctor != null) {
                session.setAttribute("doctor", doctor);
                session.setAttribute("doctor_id", doctor.getDoctor_id());
                System.out.println("✅ Doctor loaded: " + doctor.getFullName());
            } else {
                System.out.println("❌ No doctor found for user: " + user.getId());
                request.setAttribute("error", "Không tìm thấy thông tin bác sĩ.");
                request.getRequestDispatcher("/jsp/error/404.jsp").forward(request, response);
                return;
            }
        }
        
        try {
            // Lấy dữ liệu dashboard
            loadDashboardData(request, doctor, user);
            
            // Forward đến JSP
            request.getRequestDispatcher("/jsp/doctor/doctor_tongquan.jsp").forward(request, response);
            
        } catch (SQLException e) {
            Logger.getLogger(DoctorHomePageServlet.class.getName()).log(Level.SEVERE, null, e);
            request.setAttribute("error", "Lỗi database: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error/404.jsp").forward(request, response);
        }
    }
    
    /**
     * Lấy tất cả dữ liệu cần thiết cho dashboard của bác sĩ
     */
    private void loadDashboardData(HttpServletRequest request, Doctors doctor, User user) throws SQLException {
        System.out.println("🔄 Loading dashboard data for doctor: " + doctor.getDoctor_id());
        
        long doctorId = doctor.getDoctor_id();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());
        
        // 1. Lấy danh sách bệnh nhân đang chờ khám hôm nay
        List<Map<String, Object>> waitingPatients = getWaitingPatients(doctorId, today);
        request.setAttribute("waitingPatients", waitingPatients);
        System.out.println("✅ Waiting patients: " + waitingPatients.size());
        
        // 2. Lấy lịch hẹn hôm nay
        List<Appointment> todayAppointments = getTodayAppointments(doctorId, today);
        request.setAttribute("todayAppointments", todayAppointments);
        System.out.println("✅ Today appointments: " + todayAppointments.size());
        
        // 3. Lấy lịch hẹn gần đây (7 ngày gần nhất)
        List<Map<String, Object>> recentBookings = getRecentBookings(doctorId);
        request.setAttribute("recentBookings", recentBookings);
        System.out.println("✅ Recent bookings: " + recentBookings.size());
        
        // 4. Thống kê tổng quan
        Map<String, Object> stats = getDoctorStats(doctorId);
        request.setAttribute("doctorStats", stats);
        System.out.println("✅ Doctor stats loaded");
        
        // 5. Set thông tin doctor
        request.setAttribute("doctor", doctor);
        request.setAttribute("user", user);
    } 

    
    /**
     * Lấy danh sách bệnh nhân đang chờ khám hôm nay
     */
    private List<Map<String, Object>> getWaitingPatients(long doctorId, String today) throws SQLException {
        List<Map<String, Object>> waitingPatients = new ArrayList<>();
        
        List<Appointment> appointments = AppointmentDAO.getAppointmentsByDoctorAndDate(doctorId, today);
        
        for (Appointment appointment : appointments) {
            if ("CONFIRMED".equals(appointment.getStatus()) || "PENDING".equals(appointment.getStatus())) {
                Patients patient = PatientDAO.getPatientById(appointment.getPatientId());
                
                if (patient != null) {
                    Map<String, Object> patientData = new HashMap<>();
                    patientData.put("appointment", appointment);
                    patientData.put("patient", patient);
                    patientData.put("name", patient.getFullName());
                    patientData.put("gender", patient.getGender());
                    patientData.put("age", calculateAge(patient.getDateOfBirth()));
                    patientData.put("status", appointment.getStatus());
                    waitingPatients.add(patientData);
                }
            }
        }
        
        return waitingPatients;
    }
    
    /**
     * Lấy lịch hẹn hôm nay
     */
    private List<Appointment> getTodayAppointments(long doctorId, String today) throws SQLException {
        return AppointmentDAO.getAppointmentsByDoctorAndDate(doctorId, today);
    }
    
    /**
     * Lấy lịch hẹn gần đây (7 ngày)
     */
    private List<Map<String, Object>> getRecentBookings(long doctorId) throws SQLException {
        List<Map<String, Object>> recentBookings = new ArrayList<>();
        
        List<Appointment> recentAppointments = AppointmentDAO.getRecentAppointmentsByDoctor(doctorId, 7);
        
        for (Appointment appointment : recentAppointments) {
            Patients patient = PatientDAO.getPatientById(appointment.getPatientId());
            
            if (patient != null) {
                Map<String, Object> bookingData = new HashMap<>();
                bookingData.put("appointment", appointment);
                bookingData.put("patient", patient);
                bookingData.put("name", patient.getFullName());
                bookingData.put("appointmentDate", appointment.getWorkDateAsSqlDate());
                bookingData.put("status", appointment.getStatus());
                recentBookings.add(bookingData);
            }
        }
        
        return recentBookings;
    }
    
    /**
     * Lấy thống kê của bác sĩ
     */
    private Map<String, Object> getDoctorStats(long doctorId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Tổng số lịch hẹn trong tháng
        int monthlyAppointments = AppointmentDAO.getMonthlyAppointmentCount(doctorId);
        stats.put("monthlyAppointments", monthlyAppointments);
        
        // Số lịch hẹn hôm nay
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());
        int todayAppointments = AppointmentDAO.getAppointmentsByDoctorAndDate(doctorId, today).size();
        stats.put("todayAppointments", todayAppointments);
        
        // Số bệnh nhân đang chờ
        int waitingCount = AppointmentDAO.getWaitingPatientsCount(doctorId, today);
        stats.put("waitingPatients", waitingCount);
        
        return stats;
    }
    
    /**
     * Tính tuổi từ ngày sinh
     */
    private int calculateAge(Date birthDate) {
        if (birthDate == null) return 0;
        
        long currentTime = System.currentTimeMillis();
        long birthTime = birthDate.getTime();
        long ageInMillis = currentTime - birthTime;
        
        return (int) (ageInMillis / (365.25 * 24 * 60 * 60 * 1000));
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Doctor Homepage Servlet - Handles doctor dashboard data";
    }

}
