package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

/**
 * Service để gửi email qua SMTP Gmail
 * @author ASUS
 */
public class EmailService {
    
    // Cấu hình email gửi (lấy từ biến môi trường)
    private static final String FROM_EMAIL = System.getenv("EMAIL_FROM"); // Email của bạn
    private static final String FROM_PASSWORD = System.getenv("EMAIL_PASSWORD"); // App password
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    /**
     * Gửi email OTP
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     * @return true nếu gửi thành công
     */
    public static boolean sendOTPEmail(String toEmail, String otp) {
        System.out.println("📧 Bắt đầu gửi email OTP...");
        System.out.println("From: " + FROM_EMAIL);
        System.out.println("To: " + toEmail);
        
        try {
            // Cấu hình properties cho SMTP với STARTTLS (chuẩn Gmail hiện tại)
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true"); // Sử dụng STARTTLS thay vì SSL
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT); // Port 587 cho STARTTLS
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", SMTP_HOST); // Trust Gmail server
            props.put("mail.smtp.localhost", "localhost"); // Fix hostname issue
            props.put("mail.smtp.localhost.address", "127.0.0.1"); // Set valid hostname for HELO
            props.put("mail.debug", "true"); // Bật debug để xem lỗi chi tiết
            
            System.out.println("🔧 Cấu hình SMTP STARTTLS: " + SMTP_HOST + ":" + SMTP_PORT);
            System.out.println("🔐 Email: " + FROM_EMAIL);
            System.out.println("🔑 Password length: " + FROM_PASSWORD.trim().length());
            System.out.println("🔑 Password preview: " + FROM_PASSWORD.substring(0, Math.min(4, FROM_PASSWORD.length())) + "****");
            
            // Tạo session
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    System.out.println("🔐 Đang xác thực với Gmail (STARTTLS)...");
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD.trim());
                }
            });
            
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện");
            
            // Nội dung email
            String emailContent = createOTPEmailContent(otp);
            message.setContent(emailContent, "text/html; charset=utf-8");
            
            System.out.println("📤 Đang gửi email qua STARTTLS...");
            
            // Gửi email
            Transport.send(message);
            
            System.out.println("✅ OTP email sent successfully to: " + toEmail);
            return true;
            
        } catch (jakarta.mail.AuthenticationFailedException e) {
            System.err.println("❌ Lỗi xác thực Gmail: " + e.getMessage());
            System.err.println("💡 Giải pháp:");
            System.err.println("   1. Kiểm tra email: " + FROM_EMAIL);
            System.err.println("   2. Tạo lại App Password tại: https://myaccount.google.com/apppasswords");
            System.err.println("   3. Đảm bảo 2-Factor Authentication đã được bật");
            System.err.println("   4. App Password hiện tại: " + FROM_PASSWORD.substring(0, 4) + "****");
            e.printStackTrace();
            return false;
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi gửi email: " + e.getMessage());
            System.err.println("💡 Chi tiết lỗi:");
            if (e.getMessage().contains("Connection")) {
                System.err.println("   - Kiểm tra kết nối internet");
                System.err.println("   - Kiểm tra firewall/antivirus chặn port 587");
            }
            if (e.getMessage().contains("Authentication")) {
                System.err.println("   - App Password có thể đã hết hạn");
                System.err.println("   - Tạo App Password mới tại Google Account");
            }
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("❌ Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Tạo nội dung email OTP
     * @param otp Mã OTP
     * @return HTML content
     */
    private static String createOTPEmailContent(String otp) {
        return "<!DOCTYPE html>" +
               "<html lang='vi'>" +
               "<head>" +
               "    <meta charset='UTF-8'>" +
               "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
               "    <title>Mã OTP đặt lại mật khẩu</title>" +
               "    <style>" +
               "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
               "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
               "        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
               "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
               "        .otp-box { background: white; border: 2px dashed #667eea; border-radius: 10px; padding: 20px; text-align: center; margin: 20px 0; }" +
               "        .otp-code { font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 5px; }" +
               "        .warning { background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 15px; margin: 20px 0; }" +
               "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }" +
               "    </style>" +
               "</head>" +
               "<body>" +
               "    <div class='container'>" +
               "        <div class='header'>" +
               "            <h1>🏥 Hệ thống Quản lý Bệnh viện</h1>" +
               "            <p>Mã OTP đặt lại mật khẩu</p>" +
               "        </div>" +
               "        <div class='content'>" +
               "            <h2>Xin chào!</h2>" +
               "            <p>Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản của mình. Vui lòng sử dụng mã OTP bên dưới để tiếp tục:</p>" +
               "            <div class='otp-box'>" +
               "                <p>Mã OTP của bạn là:</p>" +
               "                <div class='otp-code'>" + otp + "</div>" +
               "            </div>" +
               "            <div class='warning'>" +
               "                <strong>⚠️ Lưu ý quan trọng:</strong>" +
               "                <ul>" +
               "                    <li>Mã OTP này có hiệu lực trong <strong>5 phút</strong></li>" +
               "                    <li>Không chia sẻ mã này với bất kỳ ai</li>" +
               "                    <li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>" +
               "                </ul>" +
               "            </div>" +
               "            <p>Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>" +
               "            <p>Trân trọng,<br><strong>Đội ngũ Hệ thống Quản lý Bệnh viện</strong></p>" +
               "        </div>" +
               "        <div class='footer'>" +
               "            <p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
               "        </div>" +
               "    </div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Kiểm tra cấu hình email
     * @return true nếu đã cấu hình
     */
    public static boolean isConfigured() {
        return !FROM_EMAIL.equals("your-email@gmail.com") && 
               !FROM_PASSWORD.equals("your-app-password");
    }
    
    /**
     * Gửi email OTP với fallback configs
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     * @return true nếu gửi thành công
     */
    public static boolean sendOTPEmailWithFallback(String toEmail, String otp) {
        // Thử STARTTLS port 587 trước (chuẩn Gmail hiện tại)
        System.out.println("🔄 Thử gửi qua STARTTLS (port 587) - Gmail standard...");
        if (sendOTPEmailSTARTTLS(toEmail, otp)) {
            return true;
        }
        
        System.out.println("⚠️ STARTTLS thất bại, thử SSL fallback...");
        
        // Fallback: thử SSL port 465
        if (sendOTPEmailSSL(toEmail, otp)) {
            return true;
        }
        
        System.out.println("❌ Cả 2 phương thức đều thất bại");
        System.out.println("💡 Hướng dẫn khắc phục:");
        System.out.println("   1. Kiểm tra App Password Gmail tại: https://myaccount.google.com/apppasswords");
        System.out.println("   2. Tạo App Password mới nếu cũ đã hết hạn");
        System.out.println("   3. Đảm bảo 2FA đã được bật cho tài khoản Gmail");
        System.out.println("   4. Kiểm tra firewall/antivirus có chặn port 587, 465 không");
        
        return false;
    }
    
    /**
     * Gửi email qua SSL (port 465)
     */
    private static boolean sendOTPEmailSSL(String toEmail, String otp) {
        System.out.println("🔄 Thử gửi qua SSL (port 465)...");
        System.out.println("📧 From: " + FROM_EMAIL);
        System.out.println("📧 To: " + toEmail);
        System.out.println("🔑 Password length: " + FROM_PASSWORD.trim().length());
        
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.localhost", "localhost"); // Fix hostname issue
            props.put("mail.smtp.localhost.address", "127.0.0.1"); // Set valid hostname for HELO
            props.put("mail.debug", "true"); // Bật debug để xem chi tiết
            
            System.out.println("🔧 Properties configured for SSL");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    System.out.println("🔐 Authenticating with Gmail...");
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD.trim());
                }
            });
            
            session.setDebug(true); // Bật debug session
            
            System.out.println("📝 Creating message...");
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện");
            message.setContent(createOTPEmailContent(otp), "text/html; charset=utf-8");
            
            System.out.println("📤 Sending message via SSL...");
            Transport.send(message);
            System.out.println("✅ SSL thành công!");
            return true;
            
        } catch (Exception e) {
            System.out.println("❌ SSL thất bại: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email qua STARTTLS (port 587)
     */
    private static boolean sendOTPEmailSTARTTLS(String toEmail, String otp) {
        System.out.println("🔄 Thử gửi qua STARTTLS (port 587)...");
        System.out.println("📧 From: " + FROM_EMAIL);
        System.out.println("📧 To: " + toEmail);
        
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true"); // Bắt buộc STARTTLS
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", SMTP_HOST); // Trust Gmail
            props.put("mail.smtp.localhost", "localhost"); // Fix hostname issue
            props.put("mail.smtp.localhost.address", "127.0.0.1"); // Set valid hostname for HELO
            props.put("mail.debug", "false"); // Tắt debug để clean log
            
            System.out.println("🔧 Properties configured for STARTTLS");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    System.out.println("🔐 Authenticating with Gmail (STARTTLS)...");
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD.trim());
                }
            });
            
            System.out.println("📝 Creating message...");
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện");
            message.setContent(createOTPEmailContent(otp), "text/html; charset=utf-8");
            
            System.out.println("📤 Sending message via STARTTLS...");
            Transport.send(message);
            System.out.println("✅ STARTTLS thành công!");
            return true;
            
        } catch (jakarta.mail.AuthenticationFailedException e) {
            System.out.println("❌ STARTTLS Authentication thất bại: " + e.getMessage());
            System.out.println("💡 App Password có thể cần cập nhật");
            return false;
        } catch (Exception e) {
            System.out.println("❌ STARTTLS thất bại: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            if (e.getMessage().contains("Connection")) {
                System.out.println("💡 Kiểm tra firewall có chặn port 587 không");
            }
            return false;
        }
    }
    
    /**
     * Development mode - chỉ log OTP ra console cho việc test
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     * @return luôn trả về true
     */
    public static boolean sendOTPEmailDevelopmentMode(String toEmail, String otp) {
        System.out.println("🧪 =================================");
        System.out.println("🧪 DEVELOPMENT MODE - OTP EMAIL");
        System.out.println("🧪 =================================");
        System.out.println("📧 To: " + toEmail);
        System.out.println("🔢 OTP: " + otp);
        System.out.println("⏰ Valid for: 5 minutes");
        System.out.println("🧪 =================================");
        System.out.println("💡 Copy OTP này để test: " + otp);
        System.out.println("🧪 =================================");
        
        return true;
    }
    
    /**
     * Kiểm tra có phải development mode không
     * @return true nếu là development mode
     */
    public static boolean isDevelopmentMode() {
        // Có thể check environment variable hoặc config
        // Ở đây tôi dùng cách đơn giản: kiểm tra email config
        return FROM_EMAIL.contains("lechitrung1810") || FROM_EMAIL.equals("test@example.com");
    }
} 
