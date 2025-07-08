package utils;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class N8nWebhookService {
    // URL webhook production của bạn
    private static final String WEBHOOK_URL = "https://kinggg123.app.n8n.cloud/webhook-test/send-appointment-email";

    public static void sendAppointmentToN8n(
            String userEmail,
            String doctorEmail,
            String appointmentDate,
            String appointmentTime,
            String doctorName,
            String serviceName
    ) {
        try {
            // Kiểm tra email hợp lệ
            if (userEmail == null || userEmail.trim().isEmpty() || !isValidEmail(userEmail)) {
                System.out.println("❌ User email không hợp lệ: " + userEmail);
                return;
            }
            if (doctorEmail == null || doctorEmail.trim().isEmpty() || !isValidEmail(doctorEmail)) {
                System.out.println("❌ Doctor email không hợp lệ: " + doctorEmail);
                return;
            }

            URL url = new URL(WEBHOOK_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            // Format JSON theo đúng cấu hình n8n
            String jsonInputString = String.format(
                "{\"to\":\"%s\",\"from\":\"%s\",\"date\":\"%s\",\"time\":\"%s\",\"doctor\":\"%s\",\"service\":\"%s\"}",
                userEmail.trim(),
                doctorEmail.trim(),
                appointmentDate,
                appointmentTime,
                doctorName,
                serviceName
            );

            System.out.println("📤 === GỬI DỮ LIỆU ĐẾN N8N ===");
            System.out.println("📧 Email nhận: " + userEmail);
            System.out.println("📧 Email gửi: " + doctorEmail);
            System.out.println("📅 Ngày khám: " + appointmentDate);
            System.out.println("⏰ Giờ khám: " + appointmentTime);
            System.out.println("👨‍⚕️ Bác sĩ: " + doctorName);
            System.out.println("🏥 Dịch vụ: " + serviceName);
            System.out.println("📤 JSON payload: " + jsonInputString);
            System.out.println("🔗 Webhook URL: " + WEBHOOK_URL);

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = con.getResponseCode();
            System.out.println("📨 n8n webhook response code: " + code);

        } catch (Exception e) {
            System.out.println("❌ Error sending to n8n webhook: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Xử lý n8n
    // Kiểm tra email hợp lệ với regex chặt chẽ hơn
    private static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        // RFC 5322 Official Standard
        String emailRegex = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$";
        return email.matches(emailRegex);
    }
}