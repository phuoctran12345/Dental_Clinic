package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.User;

import java.io.IOException;

/**
 * Servlet chuyên dụng để cập nhật mật khẩu bằng email
 * @author ASUS
 */

public class UpdatePasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        
        // Lấy email từ session (đã được xác thực OTP)
        String email = (String) session.getAttribute("resetEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        // Kiểm tra phiên làm việc
        if (email == null || otpVerified == null || !otpVerified) {
            request.setAttribute("error", "Phiên làm việc không hợp lệ. Vui lòng thực hiện lại quá trình reset mật khẩu.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Lấy thông tin mật khẩu từ form
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }
        
        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu có chữ cái và số
        if (!newPassword.matches(".*[a-zA-Z].*") || !newPassword.matches(".*\\d.*")) {
            request.setAttribute("error", "Mật khẩu phải bao gồm cả chữ cái và số.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra email tồn tại
            User user = UserDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // ⚠️ CẢNH BÁO: Cập nhật mật khẩu KHÔNG mã hóa - CHỈ DÙNG ĐỂ TEST!
            boolean updated = UserDAO.updatePasswordPlainText(email, newPassword);
            
            if (updated) {
                // Xóa thông tin session
                session.removeAttribute("resetEmail");
                session.removeAttribute("otpVerified");
                session.removeAttribute("resetOTPData");
                
                // Thông báo thành công
                request.setAttribute("success", "🎉 Đặt lại mật khẩu thành công! Bạn có thể đăng nhập với mật khẩu mới.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                
            } else {
                request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi trong UpdatePasswordServlet: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Chuyển hướng về trang reset password
        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        if (otpVerified == null || !otpVerified) {
            request.setAttribute("error", "Bạn cần xác thực OTP trước khi đặt lại mật khẩu.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }
} 