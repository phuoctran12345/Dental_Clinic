package controller;

import dao.DoctorDAO;
import model.Doctors;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.io.PrintWriter;

@WebServlet("/updateDoctorStatus")
public class UpdateDoctorStatusServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();
        
        try {
            // Kiểm tra session
            if (session == null) {
                out.print("{\"success\": false, \"message\": \"Phiên đăng nhập đã hết hạn\"}");
                return;
            }
            
            // Lấy thông tin bác sĩ từ session
            Doctors doctor = (Doctors) session.getAttribute("doctor");
            User user = (User) session.getAttribute("user");
            
            if (doctor == null || user == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy thông tin bác sĩ\"}");
                return;
            }
            
            // Lấy trạng thái mới từ request
            String newStatus = request.getParameter("status");
            
            if (newStatus == null || newStatus.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Trạng thái không hợp lệ\"}");
                return;
            }
            
            // Validate status values - hỗ trợ cả hai định dạng
            if (!"Active".equals(newStatus) && !"Inactive".equals(newStatus)) {
                out.print("{\"success\": false, \"message\": \"Trạng thái không hợp lệ\"}");
                return;
            }
            
            // Chuyển đổi sang định dạng database nếu cần
            String currentDbStatus = doctor.getStatus();
            String dbStatus = newStatus; // Mặc định giữ nguyên
            
            System.out.println("DEBUG: Current DB status: '" + currentDbStatus + "'");
            System.out.println("DEBUG: Requested new status: '" + newStatus + "'");
            
            
            // Cập nhật trạng thái trong database
            boolean updateResult = DoctorDAO.updateDoctorStatus(doctor.getDoctorId(), dbStatus);
            
            if (updateResult) {
                // Cập nhật trạng thái trong session
                doctor.setStatus(dbStatus);
                session.setAttribute("doctor", doctor);
                
                String statusText = "active".equals(newStatus) ? "active" : "inactive";
                
                out.print("{\"success\": true, \"message\": \"Cập nhật trạng thái thành công\", \"newStatus\": \"" + newStatus + "\", \"statusText\": \"" + statusText + "\"}");
                
                System.out.println("DEBUG: Doctor status updated successfully to: " + dbStatus);
            } else {
                out.print("{\"success\": false, \"message\": \"Lỗi khi cập nhật trạng thái\"}");
                System.err.println("ERROR: Failed to update doctor status in database");
            }
            
        } catch (SQLException e) {
            System.err.println("Database error in UpdateDoctorStatusServlet: " + e.getMessage());
            e.printStackTrace();
            
            out.print("{\"success\": false, \"message\": \"Lỗi kết nối cơ sở dữ liệu\"}");
            
        } catch (Exception e) {
            System.err.println("Unexpected error in UpdateDoctorStatusServlet: " + e.getMessage());
            e.printStackTrace();
            
            out.print("{\"success\": false, \"message\": \"Đã xảy ra lỗi không mong muốn\"}");
        }
        
        out.flush();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
} 