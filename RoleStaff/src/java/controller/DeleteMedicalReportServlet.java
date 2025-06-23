package controller;


import dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class DeleteMedicalReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy reportId từ parameter
            String reportIdParam = request.getParameter("reportId");
            
            if (reportIdParam == null || reportIdParam.trim().isEmpty()) {
                request.setAttribute("error", "ID báo cáo không hợp lệ");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            int reportId = Integer.parseInt(reportIdParam);
            
            // Gọi method xóa báo cáo (đã có sẵn trong DoctorDB)
            boolean success = DoctorDAO.deleteMedicalReport(reportId);
            
            if (success) {
                // Xóa thành công - redirect về trang thông báo
                response.sendRedirect("delete_report_success.jsp");
            } else {
                // Xóa thất bại - hiển thị lỗi
                request.setAttribute("error", "Không thể xóa báo cáo. Báo cáo có thể đã được xóa hoặc không tồn tại.");
                request.setAttribute("errorTitle", "Lỗi Xóa Báo Cáo");
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
            }
            
        }catch (NumberFormatException e) {
            // Lỗi parse số
            request.setAttribute("error", "ID báo cáo không hợp lệ: " + request.getParameter("reportId"));
            request.setAttribute("errorTitle", "Lỗi Dữ Liệu");
            request.getRequestDispatcher("error_page.jsp").forward(request, response);
        }
        // Lỗi cơ sở dữ liệu
         catch (Exception e) {
            // Lỗi khác
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.setAttribute("errorTitle", "Lỗi Hệ Thống");
            request.getRequestDispatcher("error_page.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST cũng xử lý giống GET
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for deleting medical reports";
    }
} 