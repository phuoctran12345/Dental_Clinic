package controller;

import dao.AppointmentDAO;
import model.Appointment;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBContext;

@WebServlet(name = "ViewAllAppointmentsServlet", urlPatterns = {"/ViewAllAppointments"})
public class ViewAllAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<AppointmentDetail> allAppointments = getAllAppointmentsWithDetails();
        
        request.setAttribute("allAppointments", allAppointments);
        request.getRequestDispatcher("/jsp/admin/view_all_appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Lấy tất cả lịch hẹn với thông tin chi tiết
     */
    private List<AppointmentDetail> getAllAppointmentsWithDetails() {
        List<AppointmentDetail> appointments = new ArrayList<>();
        
        String sql = """
            SELECT 
                a.appointment_id,
                a.patient_id,
                a.doctor_id,
                a.work_date,
                a.slot_id,
                a.status,
                a.reason,
                a.doctor_name,
                p.full_name AS patient_name,
                p.phone AS patient_phone,
                d.full_name AS actual_doctor_name,
                d.specialization,
                ts.start_time,
                ts.end_time,
                u.email AS patient_email
            FROM Appointment a
            LEFT JOIN Patients p ON a.patient_id = p.patient_id
            LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
            LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
            LEFT JOIN users u ON p.user_id = u.user_id
            ORDER BY a.work_date DESC, ts.start_time ASC
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                AppointmentDetail detail = new AppointmentDetail();
                
                // Thông tin appointment
                detail.appointmentId = rs.getInt("appointment_id");
                detail.patientId = rs.getInt("patient_id");
                detail.doctorId = rs.getLong("doctor_id");
                detail.workDate = rs.getDate("work_date") != null ? 
                    rs.getDate("work_date").toLocalDate() : null;
                detail.slotId = rs.getInt("slot_id");
                detail.status = rs.getString("status");
                detail.reason = rs.getString("reason");
                
                // Thông tin bệnh nhân
                detail.patientName = rs.getString("patient_name");
                detail.patientPhone = rs.getString("patient_phone");
                detail.patientEmail = rs.getString("patient_email");
                
                // Thông tin bác sĩ
                detail.doctorName = rs.getString("actual_doctor_name");
                detail.specialization = rs.getString("specialization");
                
                // Thông tin thời gian
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                if (startTime != null) {
                    detail.startTime = startTime.toLocalTime();
                }
                if (endTime != null) {
                    detail.endTime = endTime.toLocalTime();
                }
                
                appointments.add(detail);
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách lịch hẹn: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    /**
     * Class inner để chứa thông tin chi tiết của appointment
     */
    public static class AppointmentDetail {
        public int appointmentId;
        public int patientId;
        public long doctorId;
        public java.time.LocalDate workDate;
        public int slotId;
        public String status;
        public String reason;
        
        // Thông tin bệnh nhân
        public String patientName;
        public String patientPhone;
        public String patientEmail;
        
        // Thông tin bác sĩ
        public String doctorName;
        public String specialization;
        
        // Thông tin thời gian
        public java.time.LocalTime startTime;
        public java.time.LocalTime endTime;
        
        public String getFormattedDate() {
            if (workDate != null) {
                return workDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }
            return "";
        }
        
        public String getFormattedTime() {
            if (startTime != null && endTime != null) {
                return String.format("%s - %s", 
                    startTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm")),
                    endTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm")));
            }
            return "";
        }
        
        public String getStatusColor() {
            if (status == null) return "secondary";
            
            switch (status.toUpperCase()) {
                case "BOOKED":
                    return "success";
                case "CANCELLED":
                    return "danger";
                case "COMPLETED":
                    return "primary";
                case "WAITING_PAYMENT":
                    return "warning";
                default:
                    return "secondary";
            }
        }
    }
} 