package Controller;

import Model.DoctorDB;
import Model.MedicalReport;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class UpdateMedicalReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to ViewReportServlet for viewing
        response.sendRedirect("ViewReportServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy parameters từ form
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            String diagnosis = request.getParameter("diagnosis");
            String treatmentPlan = request.getParameter("treatmentPlan");
            String note = request.getParameter("note");
            String sign = request.getParameter("sign");
            
            // Tạo đối tượng MedicalReport để cập nhật
            MedicalReport report = new MedicalReport();
            report.setReportId(reportId);
            report.setDiagnosis(diagnosis);
            report.setTreatmentPlan(treatmentPlan);
            report.setNote(note);
            report.setSign(sign);
            
            // Gọi method cập nhật
            boolean success = DoctorDB.updateMedicalReport(report);
            
            if (success) {
                request.setAttribute("message", "Cập nhật báo cáo thành công!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Cập nhật báo cáo thất bại!");
                request.setAttribute("messageType", "error");
            }
            
            // Redirect về trang xem báo cáo với thông báo
            response.sendRedirect("ViewReportServlet?reportId=" + reportId + "&message=" + 
                                (success ? "success" : "error"));
            
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Lỗi: ID báo cáo không hợp lệ!");
            request.setAttribute("messageType", "error");
            response.sendRedirect("ViewReportServlet?message=error");
        } catch (SQLException e) {
            request.setAttribute("message", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.setAttribute("messageType", "error");
            response.sendRedirect("ViewReportServlet?message=error");
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi không xác định: " + e.getMessage());
            request.setAttribute("messageType", "error");
            response.sendRedirect("ViewReportServlet?message=error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating medical reports";
    }
} 