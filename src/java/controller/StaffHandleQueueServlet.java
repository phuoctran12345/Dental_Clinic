package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import static dao.AppointmentDAO.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.Appointment;
import model.Doctors;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

// @WebServlet annotation removed - using web.xml mapping instead
public class StaffHandleQueueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        try {
            if ("queue".equals(action)) {
                // Xử lý trang quản lý hàng đợi
                handleQueueManagement(request, response);
            } else {
                // Mặc định cũng hiển thị trang quản lý hàng đợi
                handleQueueManagement(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_quanlyhangdoibenhnhan.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            if ("update_status".equals(action)) {
                handleUpdateStatus(request, response);
            } else if ("call_patient".equals(action)) {
                handleCallPatient(request, response);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi khi cập nhật: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Xử lý trang quản lý hàng đợi bệnh nhân
     */
    private void handleQueueManagement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("🏥 LOADING QUEUE MANAGEMENT PAGE...");
            
            // Lấy danh sách bác sĩ
            List<Doctors> doctors = new ArrayList<>();
            try {
                doctors = DoctorDAO.getAllDoctors();
                System.out.println("📋 Loaded " + doctors.size() + " doctors");
            } catch (Exception e) {
                System.err.println("ERROR loading doctors: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("doctors", doctors);
            
            // Lấy lịch hẹn hôm nay và tính toán statistics với thời gian realtime  
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            
            // Thử lấy appointments theo ngày
            List<Appointment> todayAppointments = appointmentDAO.getAppointmentsByDate(today);
            System.out.println("📅 Today (" + today + "): Loaded " + todayAppointments.size() + " appointments from getAppointmentsByDate()");
            
            // ĐÚNG LOGIC: Chỉ lấy lịch hẹn của ngày hôm nay
            List<Appointment> appointmentsToUse = todayAppointments;
            System.out.println("📅 Using " + appointmentsToUse.size() + " appointments for display (today only)");
            
            // Load thông tin bệnh nhân và bác sĩ thật từ database
            dao.PatientDAO patientDAO = new dao.PatientDAO();
            dao.DoctorDAO doctorDAO = new dao.DoctorDAO();
            
            for (Appointment apt : appointmentsToUse) {
                try {
                    // Lấy tên bệnh nhân thật từ Patients table
                    model.Patients patient = dao.PatientDAO.getPatientById(apt.getPatientId());
                    if (patient != null) {
                        apt.setPatientName(patient.getFullName());
                        // Số điện thoại THẬT của bệnh nhân (để staff gọi đến)
                        String actualPatientPhone = patient.getPhone();
                        if (actualPatientPhone != null && !actualPatientPhone.trim().isEmpty()) {
                            apt.setPatientPhone(actualPatientPhone);
                        } else {
                            // Fallback: số demo nếu bệnh nhân không có số
                            apt.setPatientPhone("0901234567"); // Số demo để test
                        }
                        System.out.println("👤 Patient " + apt.getPatientId() + ": " + patient.getFullName() + " | Phone: " + apt.getPatientPhone());
                    } else {
                        apt.setPatientName("Bệnh nhân " + apt.getPatientId());
                        apt.setPatientPhone("0901234567"); // Số demo
                    }
                    
                    // Lấy tên bác sĩ thật từ Doctors table
                    model.Doctors doctor = doctorDAO.getDoctorById((int)apt.getDoctorId());
                    if (doctor != null) {
                        apt.setDoctorName(doctor.getFull_name());
                        System.out.println("👨‍⚕️ Doctor " + apt.getDoctorId() + ": " + doctor.getFull_name());
                    } else {
                        apt.setDoctorName("Bác sĩ " + apt.getDoctorId());
                    }
                    
                    // Set service name từ reason
                    apt.setServiceName(apt.getReason() != null ? apt.getReason() : "Khám tổng quát");
                    
                } catch (Exception e) {
                    System.err.println("❌ Error loading info for appointment " + apt.getAppointmentId() + ": " + e.getMessage());
                    apt.setPatientName("Bệnh nhân " + apt.getPatientId());
                    apt.setDoctorName("Bác sĩ " + apt.getDoctorId());
                    apt.setPatientPhone("0936929381");
                    apt.setServiceName("Khám tổng quát");
                }
            }
            
            // Tính số lượng theo status THỜI GIAN THỰC sử dụng constants mới (3 trạng thái chính)
            int totalAppointments = appointmentsToUse.size();
            int bookedCount = 0, completedCount = 0, cancelledCount = 0;
            
            System.out.println("📊 REALTIME STATUS COUNT for all appointments:");
            for (Appointment apt : appointmentsToUse) {
                String status = apt.getStatus();
                System.out.println("  - ID:" + apt.getAppointmentId() + " | Status: '" + status + "' | Patient: " + apt.getPatientName());
                
                // Sử dụng constants mới để đếm chính xác (3 trạng thái chính)
                if (AppointmentDAO.STATUS_BOOKED.equals(status) || "Đã đặt".equals(status) || 
                    AppointmentDAO.STATUS_WAITING_PAYMENT.equals(status) || "Chờ thanh toán".equals(status)) {
                    bookedCount++;
                } else if (AppointmentDAO.STATUS_COMPLETED.equals(status) || "Hoàn thành".equals(status)) {
                    completedCount++;
                } else if (AppointmentDAO.STATUS_CANCELLED.equals(status) || "Đã hủy".equals(status)) {
                    cancelledCount++;
                }
            }
            
            System.out.println("📈 FINAL COUNTS: Total=" + totalAppointments + 
                             " | Booked=" + bookedCount + 
                             " | Completed=" + completedCount + 
                             " | Cancelled=" + cancelledCount);
            
            // DEBUG: Kiểm tra appointments trước khi gửi cho JSP
            System.out.println("🔍 DEBUG - Appointments list before sending to JSP:");
            System.out.println("   - Size: " + appointmentsToUse.size());
            System.out.println("   - Is null? " + (appointmentsToUse == null));
            System.out.println("   - Is empty? " + appointmentsToUse.isEmpty());
            
            if (!appointmentsToUse.isEmpty()) {
                for (int i = 0; i < Math.min(3, appointmentsToUse.size()); i++) {
                    Appointment apt = appointmentsToUse.get(i);
                    System.out.println("   [" + i + "] ID:" + apt.getAppointmentId() + 
                                     " | Patient: '" + apt.getPatientName() + "'" +
                                     " | Status: '" + apt.getStatus() + "'");
                }
            }
            
            // Gửi dữ liệu THỜI GIAN THỰC cho JSP
            request.setAttribute("appointments", appointmentsToUse);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("bookedCount", bookedCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("cancelledCount", cancelledCount);
            
            System.out.println("✅ Forwarding to JSP with " + appointmentsToUse.size() + " appointments");
            
            // Forward đến trang quản lý hàng đợi
            request.getRequestDispatcher("/jsp/staff/staff_quanlyhangdoibenhnhan.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi khi tải dữ liệu hàng đợi: " + e.getMessage());
            request.getRequestDispatcher("/jsp/staff/staff_quanlyhangdoibenhnhan.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý cập nhật trạng thái appointment (nếu cần)
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String appointmentId = request.getParameter("appointmentId");
            String newStatus = request.getParameter("newStatus");
            
            if (appointmentId != null && newStatus != null) {
                AppointmentDAO appointmentDAO = new AppointmentDAO();
                
                // Update status
                boolean updated = appointmentDAO.updateAppointmentStatus(
                    Integer.parseInt(appointmentId), newStatus);
                
                if (updated) {
                    request.setAttribute("success", "Cập nhật trạng thái thành công!");
                    System.out.println("✅ Updated appointment " + appointmentId + " to status: " + newStatus);
                } else {
                    request.setAttribute("error", "Không thể cập nhật trạng thái!");
                }
            }
            
            // Reload page
            handleQueueManagement(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
            handleQueueManagement(request, response);
        }
    }

    /**
     * Xử lý chức năng gọi bệnh nhân từ số staff
     */
    private void handleCallPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String staffPhone = request.getParameter("staffPhone");
            String patientPhone = request.getParameter("patientPhone");
            String patientName = request.getParameter("patientName");
            
            if (staffPhone != null && patientPhone != null && patientName != null) {
                // Log cuộc gọi
                System.out.println("📞 CALL LOG:");
                System.out.println("  👨‍💼 Staff phone: " + staffPhone);
                System.out.println("  👤 Patient: " + patientName);
                System.out.println("  📱 Patient phone: " + patientPhone);
                System.out.println("  🕐 Time: " + new java.util.Date());
                
                // Tạo thông tin phản hồi
                String callInfo = String.format(
                    "✅ CUỘC GỌI ĐÃ ĐƯỢC THỰC HIỆN%n%n" +
                    "👨‍💼 Staff: %s%n" +
                    "👤 Bệnh nhân: %s%n" +
                    "📱 Số BN: %s%n" +
                    "🕐 Thời gian: %s",
                    staffPhone,
                    patientName,
                    patientPhone,
                    new java.util.Date().toString()
                );
                
                request.setAttribute("callInfo", callInfo);
                request.setAttribute("success", "Đã ghi nhận cuộc gọi từ " + staffPhone + " đến " + patientName);
                
            } else {
                request.setAttribute("error", "Thiếu thông tin cuộc gọi!");
                System.err.println("❌ Missing call parameters: staffPhone=" + staffPhone + 
                                 ", patientPhone=" + patientPhone + ", patientName=" + patientName);
            }
            
            // Reload page
            handleQueueManagement(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý cuộc gọi: " + e.getMessage());
            handleQueueManagement(request, response);
        }
    }
} 