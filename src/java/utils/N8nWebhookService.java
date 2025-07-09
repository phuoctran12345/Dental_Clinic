package utils;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class N8nWebhookService {
    // URL webhook production của bạn  
    // 🔧 CẬP NHẬT URL N8N WEBHOOK - KIỂM TRA URL ENDPOINT ĐÚNG
    private static final String WEBHOOK_URL = "https://kinggg123.app.n8n.cloud/webhook/send-appointment-email";

    // 🚫 ANTI-SPAM: Cache để tránh gửi email duplicate
    private static final Set<String> sentEmails = ConcurrentHashMap.newKeySet();

    // ENHANCED: Method với đầy đủ thông tin thanh toán
    public static void sendPaymentSuccessToN8n(
            String userEmail,
            String userName, 
            String userPhone,
            String doctorEmail,
            String doctorName,
            String appointmentDate,
            String appointmentTime,
            String serviceName,
            String billId,
            String orderId,
            double billAmount,
            String clinicName,
            String clinicAddress,
            String clinicPhone
    ) {
        try {
            // 🚫 KIỂM TRA ANTI-SPAM: Không gửi email duplicate cho cùng billId
            String emailKey = billId + "_" + userEmail;
            if (sentEmails.contains(emailKey)) {
                System.out.println("🚫 ANTI-SPAM: Email đã được gửi cho " + billId + " → " + userEmail);
                return;
            }

            // Kiểm tra email hợp lệ
            if (userEmail == null || userEmail.trim().isEmpty() || !isValidEmail(userEmail)) {
                System.out.println("❌ User email không hợp lệ: " + userEmail);
                return;
            }

            URL url = new URL(WEBHOOK_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            // Format tiền tệ VNĐ
            NumberFormat vndFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedAmount = vndFormat.format(billAmount);

            // JSON payload đầy đủ thông tin
            String jsonInputString = String.format(
                "{" +
                "\"type\":\"payment_success\"," +
                "\"to\":\"%s\"," +
                "\"userName\":\"%s\"," +
                "\"userPhone\":\"%s\"," +
                "\"doctorEmail\":\"%s\"," +
                "\"doctorName\":\"%s\"," +
                "\"appointmentDate\":\"%s\"," +
                "\"appointmentTime\":\"%s\"," +
                "\"serviceName\":\"%s\"," +
                "\"billId\":\"%s\"," +
                "\"orderId\":\"%s\"," +
                "\"billAmount\":%.0f," +
                "\"formattedAmount\":\"%s\"," +
                "\"clinicName\":\"%s\"," +
                "\"clinicAddress\":\"%s\"," +
                "\"clinicPhone\":\"%s\"," +
                "\"timestamp\":\"%s\"" +
                "}",
                userEmail.trim(),
                escapeJson(userName),
                escapeJson(userPhone),
                doctorEmail != null ? doctorEmail.trim() : "contact@dentalclinic.vn",
                escapeJson(doctorName),
                appointmentDate,
                appointmentTime,
                escapeJson(serviceName),
                billId,
                orderId,
                billAmount,
                escapeJson(formattedAmount),
                escapeJson(clinicName != null ? clinicName : "Phòng khám Nha khoa"),
                escapeJson(clinicAddress != null ? clinicAddress : "123 Đường ABC, Quận 1, TP.HCM"),
                escapeJson(clinicPhone != null ? clinicPhone : "028-1234-5678"),
                java.time.LocalDateTime.now().toString()
            );

            System.out.println("📤 === GỬI THÔNG BÁO THANH TOÁN THÀNH CÔNG ĐẾN N8N ===");
            System.out.println("📧 Email khách hàng: " + userEmail);
            System.out.println("👤 Tên khách hàng: " + userName);
            System.out.println("📞 SĐT khách hàng: " + userPhone);
            System.out.println("👨‍⚕️ Bác sĩ: " + doctorName);
            System.out.println("📅 Ngày khám: " + appointmentDate);
            System.out.println("⏰ Giờ khám: " + appointmentTime);
            System.out.println("🏥 Dịch vụ: " + serviceName);
            System.out.println("💰 Số tiền: " + formattedAmount);
            System.out.println("📄 Mã hóa đơn: " + billId);
            System.out.println("📤 JSON payload: " + jsonInputString);
            System.out.println("🔗 Webhook URL: " + WEBHOOK_URL);

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = con.getResponseCode();
            System.out.println("📨 N8N webhook response: " + code);
            
            if (code == 200) {
                System.out.println("✅ Đã gửi thông báo thanh toán thành công tới N8N!");
                // Thêm email vào cache sau khi gửi thành công
                sentEmails.add(emailKey);
            } else {
                System.out.println("⚠️ N8N webhook trả về code: " + code);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi gửi webhook N8N: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // LEGACY: Method cũ để backward compatibility
    public static void sendAppointmentToN8n(
            String userEmail,
            String doctorEmail,
            String appointmentDate,
            String appointmentTime,
            String doctorName,
            String serviceName
    ) {
        // Gọi method mới với thông tin cơ bản
        sendPaymentSuccessToN8n(
            userEmail,
            "Khách hàng", // Default name
            "Chưa cập nhật", // Default phone
            doctorEmail,
            doctorName,
            appointmentDate,
            appointmentTime,
            serviceName,
            "N/A", // No bill ID
            "N/A", // No order ID
            0.0, // No amount
            "Phòng khám Nha khoa", // Default clinic
            "123 Đường ABC, Quận 1, TP.HCM", // Default address
            "028-1234-5678" // Default phone
        );
    }

    // Helper method để escape JSON strings
    private static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }

    // Kiểm tra email hợp lệ với regex chặt chẽ hơn
    private static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        // RFC 5322 Official Standard
        String emailRegex = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$";
        return email.matches(emailRegex);
    }

    // 🔄 UTILITY: Reset cache anti-spam (dùng cho testing)
    public static void resetAntiSpamCache() {
        sentEmails.clear();
        System.out.println("🔄 ĐÃ RESET CACHE ANTI-SPAM");
    }

    // 📊 UTILITY: Kiểm tra số email đã gửi
    public static int getSentEmailCount() {
        return sentEmails.size();
    }

    // ENHANCED: Method riêng cho thông báo lịch hẹn (không phải thanh toán)
    public static void sendAppointmentReminderToN8n(
            String userEmail,
            String userName,
            String doctorName,
            String appointmentDate,
            String appointmentTime,
            String serviceName,
            String reminderType // "24h_before", "2h_before", "now"
    ) {
        try {
            if (userEmail == null || userEmail.trim().isEmpty() || !isValidEmail(userEmail)) {
                System.out.println("❌ User email không hợp lệ: " + userEmail);
                return;
            }

            URL url = new URL(WEBHOOK_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            String jsonInputString = String.format(
                "{" +
                "\"type\":\"appointment_reminder\"," +
                "\"to\":\"%s\"," +
                "\"userName\":\"%s\"," +
                "\"doctorName\":\"%s\"," +
                "\"appointmentDate\":\"%s\"," +
                "\"appointmentTime\":\"%s\"," +
                "\"serviceName\":\"%s\"," +
                "\"reminderType\":\"%s\"," +
                "\"timestamp\":\"%s\"" +
                "}",
                userEmail.trim(),
                escapeJson(userName),
                escapeJson(doctorName),
                appointmentDate,
                appointmentTime,
                escapeJson(serviceName),
                reminderType,
                java.time.LocalDateTime.now().toString()
            );

            System.out.println("⏰ === GỬI NHẮC NHỞ LỊCH HẸN ĐẾN N8N ===");
            System.out.println("📧 Email: " + userEmail);
            System.out.println("👤 Khách hàng: " + userName);
            System.out.println("🔔 Loại nhắc nhở: " + reminderType);

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = con.getResponseCode();
            System.out.println("📨 N8N reminder response: " + code);

        } catch (Exception e) {
            System.out.println("❌ Lỗi gửi reminder N8N: " + e.getMessage());
            e.printStackTrace();
        }
    }
}