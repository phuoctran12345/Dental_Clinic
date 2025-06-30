package Controller;

import Model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * ViewReportServlet - Xử lý việc xem báo cáo y tế
 * @author ASUS
 */
public class ViewReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tham số từ request
            String reportIdParam = request.getParameter("reportId");
            String appointmentIdParam = request.getParameter("appointmentId");
            
            if (reportIdParam == null && appointmentIdParam == null) {
                response.sendRedirect("/doctor/jsp/doctor/doctor_trongngay.jsp?error=missing_params");
                return;
            }
            
            MedicalReport report = null;
            Integer appointmentId = null;
            
            // Xử lý trường hợp có reportId
            if (reportIdParam != null) {
                int reportId = Integer.parseInt(reportIdParam);
                report = DoctorDB.getMedicalReportById(reportId);
            }
            
            // Xử lý trường hợp có appointmentId
            if (appointmentIdParam != null) {
                appointmentId = Integer.parseInt(appointmentIdParam);
                report = DoctorDB.getMedicalReportByAppointmentId(appointmentId);
            }
            
            // Kiểm tra báo cáo có tồn tại không
            if (report == null) {
                // Redirect đến trang "không có báo cáo" với appointmentId
                String redirectUrl = "/doctor/jsp/doctor/no_report_found.jsp";
                if (appointmentId != null) {
                    redirectUrl += "?appointmentId=" + appointmentId;
                } else if (appointmentIdParam != null) {
                    redirectUrl += "?appointmentId=" + appointmentIdParam;
                }
                response.sendRedirect(redirectUrl);
                return;
            }
            
            // Lấy thông tin bệnh nhân từ patient_id trong report
            Patients patient = DoctorDB.getPatientByPatientId(report.getPatientId());
            
            // Lấy thông tin bác sĩ
            Doctors doctor = DoctorDB.getDoctorById(report.getDoctorId());
            
            // Lấy danh sách đơn thuốc
            List<PrescriptionDetail> prescriptions = DoctorDB.getPrescriptionsByReportId(report.getReportId());
            
            // Lấy thông tin time slot
            String timeSlot = DoctorDB.getTimeSlotByAppointmentId(report.getAppointmentId());
            
            // Set attributes cho JSP
            request.setAttribute("report", report);
            request.setAttribute("patient", patient);
            request.setAttribute("doctor", doctor);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("appointmentId", report.getAppointmentId());
            request.setAttribute("timeSlot", timeSlot);
            
            // Forward đến JSP
            request.getRequestDispatcher("/jsp/doctor/viewMedicalReport.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Lỗi parse số - redirect đến trang lỗi
            response.sendRedirect("/doctor/jsp/doctor/error_page.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi hệ thống - redirect đến trang lỗi với thông tin chi tiết
            response.sendRedirect("/doctor/jsp/doctor/error_page.jsp?error=system_error");
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