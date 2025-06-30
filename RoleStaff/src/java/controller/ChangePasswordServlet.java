package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import model.User;

public class ChangePasswordServlet extends HttpServlet {
    private static final String EMAIL_USERNAME = "your-email@gmail.com"; // Thay bằng email của bạn
    private static final String EMAIL_PASSWORD = "your-app-password"; // Thay bằng mật khẩu ứng dụng của bạn

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("request-otp".equals(action)) {
            handleRequestOTP(request, response);
        } else if ("verify-otp".equals(action)) {
            handleVerifyOTP(request, response);
        }
    }
    
    private void handleRequestOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            // Tạo mã OTP ngẫu nhiên 6 chữ số
            String otp = String.format("%06d", new Random().nextInt(1000000));
            session.setAttribute("otp", otp);
            session.setAttribute("otpTime", System.currentTimeMillis());
            
            // Gửi email chứa mã OTP
            sendOTPEmail(user.getEmail(), otp);
            
            response.sendRedirect("staff_taikhoan.jsp?otp_sent=true");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
    
    private void handleVerifyOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String submittedOTP = request.getParameter("otp");
        String storedOTP = (String) session.getAttribute("otp");
        long otpTime = (long) session.getAttribute("otpTime");
        
        // Kiểm tra OTP có hợp lệ và chưa hết hạn (5 phút)
        if (storedOTP != null && storedOTP.equals(submittedOTP) && 
            (System.currentTimeMillis() - otpTime) < 300000) {
            
            String currentPassword = request.getParameter("current-password");
            String newPassword = request.getParameter("new-password");
            String confirmPassword = request.getParameter("confirm-password");
            
            User user = (User) session.getAttribute("user");
            
            if (user != null && newPassword.equals(confirmPassword)) {
                // Cập nhật mật khẩu mới
                UserDAO userDAO = new UserDAO();
                if (userDAO.updatePassword(user.getId(), newPassword)) {
                    session.removeAttribute("otp");
                    session.removeAttribute("otpTime");
                    response.sendRedirect("staff_taikhoan.jsp?password_changed=true");
                } else {
                    response.sendRedirect("staff_taikhoan.jsp?error=update_failed");
                }
            } else {
                response.sendRedirect("staff_taikhoan.jsp?error=password_mismatch");
            }
        } else {
            response.sendRedirect("staff_taikhoan.jsp?error=invalid_otp");
        }
    }
    
    private void sendOTPEmail(String toEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực đổi mật khẩu");
            message.setText("Mã OTP của bạn là: " + otp + "\nMã này có hiệu lực trong 5 phút.");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
} 