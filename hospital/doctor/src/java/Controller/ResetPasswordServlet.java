package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.User;
import Model.UserDAO;
import utils.EmailService;

import utils.OTPService;
import utils.OTPService.OTPData;

import java.io.IOException;

/**
 * Servlet xử lý reset password với OTP
 * @author ASUS
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("forgot-password".equals(action)) {
            // Hiển thị form nhập email
            request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
            
        } else if ("verify-otp".equals(action)) {
            // Hiển thị form nhập OTP
            HttpSession session = request.getSession();
            OTPData otpData = (OTPData) session.getAttribute("resetOTPData");
            
            if (otpData == null || OTPService.isExpired(otpData)) {
                request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thực hiện lại.");
                request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
                return;
            }
            
            long remainingSeconds = OTPService.getRemainingSeconds(otpData);
            request.setAttribute("remainingSeconds", remainingSeconds);
            request.setAttribute("email", otpData.getEmail());
            request.getRequestDispatcher("/jsp/doctor/verify-otp.jsp").forward(request, response);
            
        } else if ("reset-password".equals(action)) {
            // Hiển thị form đặt lại mật khẩu
            HttpSession session = request.getSession();
            Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
            
            if (otpVerified == null || !otpVerified) {
                request.setAttribute("error", "Bạn cần xác thực OTP trước.");
                request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
                return;
            }
            
            request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
            
        } else {
            // Mặc định hiển thị form forgot password
            request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("send-otp".equals(action)) {
            handleSendOTP(request, response);
            
        } else if ("verify-otp".equals(action)) {
            handleVerifyOTP(request, response);
            
        } else if ("reset-password".equals(action)) {
            handleResetPassword(request, response);
            
        } else {
            response.sendRedirect("ResetPasswordServlet");
        }
    }
    
    /**
     * Xử lý gửi OTP qua email
     */
    private void handleSendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
            return;
        }
        
        email = email.trim().toLowerCase();
        
        // Kiểm tra email có tồn tại trong hệ thống không
        User user = UserDAO.getUserByEmail(email);
        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Tạo OTP
            String otp = OTPService.generateOTP();
            OTPData otpData = OTPService.createOTPData(otp);
            otpData.setEmail(email);
            
            boolean emailSent = false;
            String successMessage = "";
            
            // Thử gửi email thật trước với multiple configs
            if (EmailService.isConfigured()) {
                System.out.println("🔄 Đang thử gửi email thật với fallback configs...");
                emailSent = EmailService.sendOTPEmailWithFallback(email, otp);
                
                if (emailSent) {
                    successMessage = "Mã OTP đã được gửi đến email " + email + ". Vui lòng kiểm tra hộp thư của bạn.";
                    System.out.println("✅ Gửi email thật thành công!");
                } else {
                    System.out.println("❌ Không thể gửi email qua tất cả phương thức.");
                }
            } else {
                System.out.println("❌ Email chưa được cấu hình đúng!");
            }
            
            // Tạm comment development mode để focus vào email thật
            /*
            // Nếu email thật thất bại, thử development mode
            if (!emailSent && EmailService.isDevelopmentMode()) {
                System.out.println("🔄 Chuyển sang Development Mode...");
                emailSent = EmailService.sendOTPEmailDevelopmentMode(email, otp);
                
                if (emailSent) {
                    successMessage = "🧪 DEVELOPMENT MODE: Mã OTP đã được tạo (kiểm tra console). OTP: " + otp;
                    System.out.println("✅ Development mode thành công!");
                }
            }
            */
            
            if (emailSent) {
                // Lưu OTP vào session
                HttpSession session = request.getSession();
                session.setAttribute("resetOTPData", otpData);
                session.removeAttribute("otpVerified"); // Reset trạng thái xác thực
                
                // Thông báo thành công
                session.setAttribute("otpSentMessage", successMessage);
                
                // Chuyển đến trang nhập OTP
                response.sendRedirect("/doctor/ResetPasswordServlet?action=verify-otp");
                
            } else {
                request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau hoặc liên hệ quản trị viên.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi gửi OTP: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý xác thực OTP
     */
    private void handleVerifyOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String inputOTP = request.getParameter("otp");
        HttpSession session = request.getSession();
        OTPData otpData = (OTPData) session.getAttribute("resetOTPData");
        
        // Validate input
        if (inputOTP == null || inputOTP.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã OTP.");
            if (otpData != null) {
                long remainingSeconds = OTPService.getRemainingSeconds(otpData);
                request.setAttribute("remainingSeconds", remainingSeconds);
                request.setAttribute("email", otpData.getEmail());
            }
            request.getRequestDispatcher("/jsp/doctor/verify-otp.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra OTP có tồn tại trong session không
        if (otpData == null) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thực hiện lại.");
            request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Xác thực OTP
        if (OTPService.verifyOTP(otpData, inputOTP.trim())) {
            // OTP đúng
            session.setAttribute("otpVerified", true);
            session.setAttribute("resetEmail", otpData.getEmail());
            session.removeAttribute("otpSentMessage"); // Xóa message
            
            // Chuyển đến trang đặt lại mật khẩu
            response.sendRedirect("/doctor/ResetPasswordServlet?action=reset-password");
            
        } else {
            // OTP sai hoặc hết hạn
            if (OTPService.isExpired(otpData)) {
                request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
                session.removeAttribute("resetOTPData");
                request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Mã OTP không đúng. Vui lòng thử lại.");
                long remainingSeconds = OTPService.getRemainingSeconds(otpData);
                request.setAttribute("remainingSeconds", remainingSeconds);
                request.setAttribute("email", otpData.getEmail());
                request.getRequestDispatcher("/jsp/doctor/verify-otp.jsp").forward(request, response);
            }
        }
    }
    
    /**
     * Xử lý đặt lại mật khẩu
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String email = (String) session.getAttribute("resetEmail");
        
        System.out.println("🔄 Bắt đầu xử lý reset password...");
        System.out.println("📧 Email: " + email);
        System.out.println("✅ OTP verified: " + otpVerified);
        
        // Kiểm tra đã xác thực OTP chưa
        if (otpVerified == null || !otpVerified || email == null) {
            System.err.println("❌ Phiên làm việc không hợp lệ");
            request.setAttribute("error", "Session không hợp lệ. Vui lòng thử lại từ đầu.");
            response.sendRedirect("/doctor/ResetPasswordServlet");
            return;
        }
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("🔍 Kiểm tra input parameters:");
        System.out.println("   - newPassword: " + (newPassword != null ? "[HIDDEN]" : "null"));
        System.out.println("   - confirmPassword: " + (confirmPassword != null ? "[HIDDEN]" : "null"));
        
        // Validate input
        if (newPassword == null || newPassword.trim().isEmpty()) {
            System.err.println("❌ Mật khẩu mới trống");
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới.");
            request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            System.err.println("❌ Mật khẩu xác nhận không khớp");
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            System.err.println("❌ Mật khẩu quá ngắn: " + newPassword.length() + " ký tự");
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu có chữ cái và số
        if (!newPassword.matches(".*[a-zA-Z].*") || !newPassword.matches(".*\\d.*")) {
            System.err.println("❌ Mật khẩu không đáp ứng yêu cầu");
            request.setAttribute("error", "Mật khẩu phải bao gồm cả chữ cái và số.");
            request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ Validation thành công, bắt đầu cập nhật database...");
        
        try {
            // Kiểm tra email tồn tại trước khi cập nhật
            User existingUser = UserDAO.getUserByEmail(email);
            if (existingUser == null) {
                System.err.println("❌ Email không tồn tại trong database: " + email);
                request.setAttribute("error", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("/jsp/doctor/forgot-password.jsp").forward(request, response);
                return;
            }
            
            System.out.println("✅ Email tồn tại, UserID: " + existingUser.getUserId());
            
            // Test database connection trước
            System.out.println("🧪 Test database connection...");
            UserDAO.testDatabaseConnection();
            
            // Cập nhật mật khẩu trong database - sử dụng method chính đã được cải thiện
            System.out.println("🔄 Đang gọi UserDAO.updatePasswordByEmail...");
            boolean updated = UserDAO.updatePasswordByEmail(email, newPassword);
            
            if (updated) {
                System.out.println("✅ Cập nhật mật khẩu thành công trong database!");
                
                // Verify update bằng cách thử đăng nhập
                System.out.println("🔍 Xác minh bằng cách test đăng nhập...");
                User testLogin = UserDAO.loginUser(email, newPassword);
                
                if (testLogin != null) {
                    System.out.println("✅ Xác minh thành công - có thể đăng nhập với mật khẩu mới!");
                    
                    // Xóa session data
                    session.removeAttribute("resetOTPData");
                    session.removeAttribute("otpVerified");
                    session.removeAttribute("resetEmail");
                    
                    System.out.println("🧹 Đã xóa session data");
                    
                    // Thông báo thành công
                    request.setAttribute("success", "Mã OTP mới đã được gửi đến email của bạn.");
                    response.sendRedirect("/doctor/ResetPasswordServlet?action=reset-password");
                    return;
                    
                } else {
                    System.err.println("❌ Không thể đăng nhập với mật khẩu mới - có lỗi xảy ra");
                    request.setAttribute("error", "Có lỗi xảy ra khi cập nhật mật khẩu. Vui lòng thử lại.");
                    request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
                }
                
            } else {
                System.err.println("❌ Cập nhật mật khẩu thất bại trong database");
                request.setAttribute("error", "Không thể cập nhật mật khẩu trong database. Vui lòng thử lại.");
                request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Exception trong quá trình reset password:");
            System.err.println("   - Message: " + e.getMessage());
            System.err.println("   - Class: " + e.getClass().getName());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi hệ thống xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/reset-password.jsp").forward(request, response);
        }
    }
} 