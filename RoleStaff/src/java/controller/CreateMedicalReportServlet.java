package controller;

import dao.DoctorDAO;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.DBContext;

/**
 * Servlet để hiển thị form tạo phiếu khám
 * @author ASUS
 */
public class CreateMedicalReportServlet extends HttpServlet {

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
            // Lấy appointmentId từ parameter
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu ID cuộc hẹn");
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr.trim());
            
            // Lấy thông tin appointment để có patientId
            Appointment appointment = DoctorDAO.getAppointmentWithPatientInfo(appointmentId);
            if (appointment == null) {
                System.err.println("ERROR - No appointment found with ID: " + appointmentId);
                request.setAttribute("error", "Không tìm thấy cuộc hẹn với ID: " + appointmentId);
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
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
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
                return;
            }
            
            // Lấy thông tin bệnh nhân
            Patients patient = DoctorDAO.getPatientByPatientId(appointment.getPatientId());
            if (patient == null) {
                System.err.println("ERROR - No patient found with patient_id: " + appointment.getPatientId());
                
                // Thử debug với SQL query trực tiếp
                System.out.println("DEBUG - Trying to find patient manually...");
                java.sql.Connection conn = null;
                try {
                    conn = DBContext.getConnection();
                    java.sql.PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) as count FROM Patients WHERE patient_id = ?");
                    ps.setInt(1, appointment.getPatientId());
                    java.sql.ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        System.out.println("DEBUG - Patient count in database: " + rs.getInt("count"));
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    System.err.println("DEBUG query failed: " + e.getMessage());
                }
                
                request.setAttribute("error", "Không tìm thấy bệnh nhân với patient_id: " + appointment.getPatientId() + 
                                           ". Có thể dữ liệu bị không nhất quán trong database.");
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
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
            
            // Forward đến trang phiếu khám
            request.getRequestDispatcher("phieukham.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID cuộc hẹn không hợp lệ");
            request.getRequestDispatcher("error_page.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(CreateMedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị form tạo phiếu khám";
    }
} 