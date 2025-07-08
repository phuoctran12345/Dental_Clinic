package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.PatientDAO;
import model.User;
import model.Patients;


public class UserRegisterWhenTheyNotRegisterInformation extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Lấy user_id từ session hoặc hidden field
        HttpSession session = request.getSession();
        Integer userId = null;
        
        // Thử lấy từ hidden field trước
        String userIdStr = request.getParameter("user_id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                System.err.println("❌ Lỗi parse user_id từ form: " + e.getMessage());
            }
        }
        
        // Nếu không có trong form, lấy từ session
        if (userId == null) {
            userId = (Integer) session.getAttribute("user_id_for_patient");
        }
        
        // Nếu vẫn không có, chuyển về login
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String dateOfBirth = request.getParameter("date_of_birth");
        String gender = request.getParameter("gender");

        System.out.println("=== ĐĂNG KÝ THÔNG TIN BỆNH NHÂN ===");
        System.out.println("User ID: " + userId);
        System.out.println("Họ tên: " + fullName);
        System.out.println("SĐT: " + phone);
        System.out.println("Ngày sinh: " + dateOfBirth);
        System.out.println("Giới tính: " + gender);

        // Gọi DAO để lưu thông tin bệnh nhân
        boolean success = UserDAO.savePatientInfo(userId, fullName, phone, dateOfBirth, gender);

        if (success) {
            // Xóa thông tin tạm khỏi session
            session.removeAttribute("user_id_for_patient");
            session.removeAttribute("email_for_patient");
            
            // Chuyển về trang đặt lịch
            response.sendRedirect("BookingPage");
        } else {
            request.setAttribute("error", "Không thể lưu thông tin. Vui lòng thử lại!");
            request.getRequestDispatcher("information.jsp").forward(request, response);
        }    
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng ký thông tin bệnh nhân khi chưa có thông tin";
    }

    public static boolean checkAndRedirectIfNeeded(User user, HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Kiểm tra thông tin bệnh nhân
            Patients patientInfo = PatientDAO.getPatientByUserId(user.getId());
            if (patientInfo == null) {
                // Lưu thông tin user_id vào session để điền form
                request.getSession().setAttribute("user_id_for_patient", user.getId());
                request.getSession().setAttribute("email_for_patient", user.getEmail());
                
                // Chuyển hướng đến trang điền thông tin với thông báo
                request.setAttribute("message", "Vui lòng điền thông tin cá nhân để tiếp tục đặt lịch");
                response.sendRedirect("information.jsp");
                return true; // Đã chuyển hướng
            }
            return false; // Không cần chuyển hướng
        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra thông tin bệnh nhân: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean isPatientInfoMissing(int userId) {
        try {
            Patients patientInfo = PatientDAO.getPatientByUserId(userId);
            return patientInfo == null;
        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra thông tin bệnh nhân: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
