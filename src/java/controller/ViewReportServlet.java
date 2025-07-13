package controller;

import dao.DoctorDAO;
import dao.PatientDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * ViewReportServlet - Xử lý việc xem báo cáo y tế
 * @author ASUS
 */
@WebServlet("/ViewReportServlet")
public class ViewReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tham số từ request
            String reportIdParam = request.getParameter("reportId");
            String appointmentIdParam = request.getParameter("appointmentId");
            
            if (reportIdParam == null && appointmentIdParam == null) {
                String contextPath = request.getContextPath();
                response.sendRedirect(contextPath +"/jsp/doctor/doctor_trongngay.jsp?error=missing_params");
                return;
            }
            
            MedicalReport report = null;
            Integer appointmentId = null;
            
            // Xử lý trường hợp có reportId
            if (reportIdParam != null) {
                int reportId = Integer.parseInt(reportIdParam);
                report = DoctorDAO.getMedicalReportById(reportId);
            }
            
            // Xử lý trường hợp có appointmentId
            if (appointmentIdParam != null) {
                appointmentId = Integer.parseInt(appointmentIdParam);
                report = DoctorDAO.getMedicalReportByAppointmentId(appointmentId);
            }
            
            // Kiểm tra báo cáo có tồn tại không
            if (report == null) {
                // Redirect đến trang "không có báo cáo" với appointmentId
                String contextPath = request.getContextPath();
                String redirectUrl = contextPath +"/jsp/doctor/doctor_no_report_found.jsp";
                if (appointmentId != null) {
                    redirectUrl += "?appointmentId=" + appointmentId;
                } else if (appointmentIdParam != null) {
                    redirectUrl += "?appointmentId=" + appointmentIdParam;
                }
                response.sendRedirect(redirectUrl);
                return;
            }
            
            // Lấy thông tin bệnh nhân từ patient_id trong report với đúng method name
            Patients patient = PatientDAO.getPatientById(report.getPatientId());
            
            // Lấy thông tin bác sĩ với đúng method name
            Doctors doctor = DoctorDAO.getDoctorById((int) report.getDoctorId());
            
            // Lấy danh sách đơn thuốc với đúng method name
            List<PrescriptionDetail> prescriptions = (List<PrescriptionDetail>) DoctorDAO.getPrescriptionsByReportId(report.getReportId());
            
            // Lấy thông tin time slot với đúng method name
            String timeSlot = DoctorDAO.getTimeSlotByAppointmentId(report.getAppointmentId());
            
            // Set attributes cho JSP
            request.setAttribute("report", report);
            request.setAttribute("patient", patient);
            request.setAttribute("doctor", doctor);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("appointmentId", report.getAppointmentId());
            request.setAttribute("timeSlot", timeSlot);
            
            // Forward đến JSP
             String contextPath = request.getContextPath();
            request.getRequestDispatcher("/jsp/doctor/doctor_viewMedicalReport.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Lỗi parse số - redirect đến trang lỗi
            String contextPath = request.getContextPath();
            response.sendRedirect(contextPath +"/jsp/doctor/error_page.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi hệ thống - redirect đến trang lỗi với thông tin chi tiết
             String contextPath = request.getContextPath();
            response.sendRedirect("/jsp/doctor/error_page.jsp?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ViewReportServlet - Xử lý việc xem báo cáo y tế";
    }
} 