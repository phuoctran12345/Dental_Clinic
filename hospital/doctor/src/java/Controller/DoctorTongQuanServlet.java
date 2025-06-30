package Controller;

import Model.Appointment;
import Model.DoctorDB;
import Model.Doctors;
import Model.Patients;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Servlet xử lý trang tổng quan cho bác sĩ
 * @author ASUS
 */
public class DoctorTongQuanServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Xử lý request và chuẩn bị dữ liệu cho trang tổng quan
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Kiểm tra đăng nhập
        Doctors loggedInDoctor = (Doctors) session.getAttribute("doctor");
        User loggedInUser = (User) session.getAttribute("user");
        
        if (loggedInDoctor == null || loggedInUser == null) {
            response.sendRedirect("/doctor/jsp/doctor/login.jsp?error=session_expired");
            return;
        }
        
        try {
            // Chuẩn bị thông tin bác sĩ
            prepareDoctorInfo(request, loggedInDoctor);
            
            // Chuẩn bị dữ liệu thống kê
            prepareStatisticsData(request, loggedInDoctor, loggedInUser);
            
            // Forward đến JSP để hiển thị
            request.getRequestDispatcher("/jsp/doctor/doctor_tongquan.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in DoctorTongQuanServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        }
    }
    
    /**
     * Chuẩn bị thông tin cơ bản của bác sĩ
     */
    private void prepareDoctorInfo(HttpServletRequest request, Doctors loggedInDoctor) {
        // Thông tin cơ bản
        String doctorName = loggedInDoctor.getFullName() != null ? loggedInDoctor.getFullName() : "Chưa cập nhật";
        String doctorSpecialty = loggedInDoctor.getSpecialty() != null ? loggedInDoctor.getSpecialty() : "Chưa cập nhật";
        String doctorPhone = loggedInDoctor.getPhone() != null ? loggedInDoctor.getPhone() : "Chưa cập nhật";
        
        // Xử lý giới tính
        String doctorGender;
        if ("male".equals(loggedInDoctor.getGender())) {
            doctorGender = "Nam";
        } else if ("female".equals(loggedInDoctor.getGender())) {
            doctorGender = "Nữ";
        } else {
            doctorGender = "Chưa cập nhật";
        }
        
        // Xử lý avatar
        String avatarPath = "images/logo.png";
        if (loggedInDoctor.getAvatar() != null && !loggedInDoctor.getAvatar().trim().isEmpty()) {
            avatarPath = loggedInDoctor.getAvatar();
        }
        
        // Xử lý trạng thái hoạt động
        String currentStatus = loggedInDoctor.getStatus();
        boolean isActive = "Active".equals(currentStatus) || "Đang hoạt động".equals(currentStatus);
        
        // Set attributes
        request.setAttribute("doctorName", doctorName);
        request.setAttribute("doctorGender", doctorGender);
        request.setAttribute("doctorSpecialty", doctorSpecialty);
        request.setAttribute("doctorPhone", doctorPhone);
        request.setAttribute("avatarPath", avatarPath);
        request.setAttribute("isActive", isActive);
        
        // Debug log
        System.out.println("=== DEBUG: Doctor Info Prepared ===");
        System.out.println("Doctor Name: " + doctorName);
        System.out.println("Doctor Status: " + currentStatus + " -> isActive: " + isActive);
        System.out.println("Avatar Path: " + avatarPath);
    }
    
    /**
     * Chuẩn bị dữ liệu thống kê và danh sách cuộc hẹn
     */
    private void prepareStatisticsData(HttpServletRequest request, Doctors loggedInDoctor, User loggedInUser) throws Exception {
        // Danh sách bệnh nhân đang chờ khám hôm nay
        List<Appointment> waitingAppointments = new ArrayList<>();
        List<Appointment> cancelledAppointments = new ArrayList<>();
        
        try {
            System.out.println("DEBUG: Getting appointments for doctor_id: " + loggedInDoctor.getDoctorId());
            
            Date currentDate = new Date();
            SimpleDateFormat debugDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            System.out.println("DEBUG: Current date is: " + debugDateFormat.format(currentDate));
            
            // Lấy danh sách appointment hôm nay đang chờ khám (đã cải thiện để xử lý multiple status)
            waitingAppointments = DoctorDB.getTodayWaitingAppointmentsByDoctorId(loggedInDoctor.getDoctorId());
            System.out.println("DEBUG: Found " + waitingAppointments.size() + " waiting appointments for today");
            
            // Lấy tất cả appointment để lọc lịch đã hủy
            DoctorDB doctorDB = new DoctorDB();
            List<Appointment> allAppointments = doctorDB.getAppointmentsByUserId(loggedInUser.getUserId());
            
            if (allAppointments != null && !allAppointments.isEmpty()) {
                for (Appointment app : allAppointments) {
                    if (app.getStatus() != null && 
                        (app.getStatus().equalsIgnoreCase("Đã hủy") || 
                         app.getStatus().equalsIgnoreCase("cancelled"))) {
                        
                        // Tạo appointment object với thông tin đầy đủ
                        Appointment cancelledApp = new Appointment();
                        cancelledApp.setAppointmentId(app.getAppointmentId());
                        cancelledApp.setPatientId(app.getPatientId());
                        cancelledApp.setDoctorId(app.getDoctorId());
                        cancelledApp.setWorkDate(app.getWorkDate());
                        cancelledApp.setSlotId(app.getSlotId());
                        cancelledApp.setStatus(app.getStatus());
                        cancelledApp.setReason(app.getReason());
                        
                        // Lấy thông tin bệnh nhân
                        Patients patient = DoctorDB.getPatientByPatientId(app.getPatientId());
                        if (patient != null) {
                            cancelledApp.setPatientName(patient.getFullName());
                            cancelledApp.setPatientGender(patient.getGender());
                            cancelledApp.setPatientDateOfBirth(patient.getDateOfBirth());
                            cancelledApp.setPatientPhone(patient.getPhone());
                        }
                        
                        cancelledAppointments.add(cancelledApp);
                    }
                }
            }
            
            // Nếu vẫn không có waiting appointments, thử fallback với tất cả appointment có status phù hợp
            if (waitingAppointments.isEmpty() && allAppointments != null) {
                System.out.println("DEBUG: No today appointments found, trying fallback with all appointments...");
                
                for (Appointment app : allAppointments) {
                    System.out.println("DEBUG: Checking appointment - ID=" + app.getAppointmentId() + 
                                     ", Status='" + app.getStatus() + 
                                     "', Date=" + app.getWorkDate() + 
                                     ", DoctorId=" + app.getDoctorId());
                    
                    // Kiểm tra status phù hợp cho waiting
                    if (app.getStatus() != null && 
                        app.getStatus().equalsIgnoreCase("booked")) {
                        
                        // Tạo appointment object với thông tin đầy đủ
                        Appointment waitingApp = new Appointment();
                        waitingApp.setAppointmentId(app.getAppointmentId());
                        waitingApp.setPatientId(app.getPatientId());
                        waitingApp.setDoctorId(app.getDoctorId());
                        waitingApp.setWorkDate(app.getWorkDate());
                        waitingApp.setSlotId(app.getSlotId());
                        waitingApp.setStatus(app.getStatus());
                        waitingApp.setReason(app.getReason());
                        
                        // Lấy thông tin bệnh nhân
                        Patients patient = DoctorDB.getPatientByPatientId(app.getPatientId());
                        if (patient != null) {
                            waitingApp.setPatientName(patient.getFullName());
                            waitingApp.setPatientGender(patient.getGender());
                            waitingApp.setPatientDateOfBirth(patient.getDateOfBirth());
                            waitingApp.setPatientPhone(patient.getPhone());
                            
                            System.out.println("DEBUG: Added fallback appointment with patient: " + patient.getFullName());
                        }
                        
                        waitingAppointments.add(waitingApp);
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error getting appointments: " + e.getMessage());
            e.printStackTrace();
            // Khởi tạo list rỗng để tránh null pointer
            waitingAppointments = new ArrayList<>();
            cancelledAppointments = new ArrayList<>();
        }
        
        // Set attributes cho JSP
        request.setAttribute("waitingAppointments", waitingAppointments);
        request.setAttribute("waitingCount", waitingAppointments.size());
        request.setAttribute("cancelledAppointments", cancelledAppointments);
        request.setAttribute("cancelledCount", cancelledAppointments.size());
        
        // Debug log
        System.out.println("DEBUG: Statistics prepared - Final Results:");
        System.out.println("Waiting appointments: " + waitingAppointments.size());
        System.out.println("Cancelled appointments: " + cancelledAppointments.size());
        
        // In ra chi tiết các waiting appointments
        for (int i = 0; i < waitingAppointments.size() && i < 3; i++) {
            Appointment app = waitingAppointments.get(i);
            System.out.println("DEBUG: Waiting App " + (i+1) + ": " + 
                             "ID=" + app.getAppointmentId() + 
                             ", Patient=" + app.getPatientName() + 
                             ", Status=" + app.getStatus() + 
                             ", Date=" + app.getWorkDate());
        }
    }
    
    /**
     * Helper method để lấy time slot string
     */
    public static String getTimeSlot(int slotId) {
        switch (slotId) {
            case 1: return "08:00 - 08:30";
            case 2: return "08:30 - 09:00";
            case 3: return "09:00 - 09:30";
            case 4: return "09:30 - 10:00";
            case 5: return "10:00 - 10:30";
            default: return "N/A";
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet xử lý trang tổng quan cho bác sĩ";
    }
} 