package utils;

import java.io.OutputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class N8nWebhookService {
    // URL webhook production của bạn - ✅ SỬA LỖII 500
    // 🔧 URL ĐÚNG TỪ N8N WORKFLOW HOẠT ĐỘNG
    private static final String WEBHOOK_URL = "https://kinggg123.app.n8n.cloud/webhook/send-appointment-email";
    
    // 🆕 WEBHOOK CHO GOOGLE CALENDAR - WORKFLOW RIÊNG BIỆT
    private static final String CALENDAR_WEBHOOK_URL = "https://kinggg123.app.n8n.cloud/webhook/create-google-calendar-event";

    // 🚫 ANTI-SPAM: Cache để tránh gửi email duplicate
    private static final Set<String> sentEmails = ConcurrentHashMap.newKeySet();
    
    // 🆕 ANTI-SPAM CHO CALENDAR: Cache để tránh tạo lịch duplicate
    private static final Set<String> createdEvents = ConcurrentHashMap.newKeySet();

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

    // 🆕 METHOD MỚI: Tạo lịch hẹn Google Calendar cho cả User và Doctor
    public static void createGoogleCalendarEvent(
            String userEmail,
            String userName,
            String userPhone,
            String doctorEmail,
            String doctorName,
            String appointmentDate,
            String appointmentTime,
            String serviceName,
            String billId,
            String clinicName,
            String clinicAddress,
            String reason
    ) {
        try {
            // 🚫 KIỂM TRA ANTI-SPAM: Không tạo event duplicate cho cùng billId
            String eventKey = billId + "_calendar";
            if (createdEvents.contains(eventKey)) {
                System.out.println("🚫 ANTI-SPAM: Calendar event đã được tạo cho " + billId);
                return;
            }

            // Kiểm tra email hợp lệ
            if ((userEmail == null || userEmail.trim().isEmpty() || !isValidEmail(userEmail)) &&
                (doctorEmail == null || doctorEmail.trim().isEmpty() || !isValidEmail(doctorEmail))) {
                System.out.println("❌ Không có email hợp lệ để tạo calendar event");
                return;
            }

            URL url = new URL(CALENDAR_WEBHOOK_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            // Tách thời gian bắt đầu và kết thúc từ appointmentTime (ví dụ: "08:00 - 08:30")
            String[] timeParts = appointmentTime.split(" - ");
            String startTime = timeParts.length > 0 ? timeParts[0].trim() : "08:00";
            String endTime = timeParts.length > 1 ? timeParts[1].trim() : "08:30";

            // Tạo datetime ISO format cho Google Calendar với timezone VN
            String startDateTime = appointmentDate + "T" + startTime + ":00+07:00";
            String endDateTime = appointmentDate + "T" + endTime + ":00+07:00";
            
            System.out.println("🕐 DATETIME DEBUG:");
            System.out.println("   appointmentDate: " + appointmentDate);
            System.out.println("   startTime: " + startTime);
            System.out.println("   endTime: " + endTime);
            System.out.println("   startDateTime: " + startDateTime);
            System.out.println("   endDateTime: " + endDateTime);

            // JSON payload cho Google Calendar
            String jsonInputString = String.format(
                "{" +
                "\"type\":\"calendar_event\"," +
                "\"userEmail\":\"%s\"," +
                "\"userName\":\"%s\"," +
                "\"userPhone\":\"%s\"," +
                "\"doctorEmail\":\"%s\"," +
                "\"doctorName\":\"%s\"," +
                "\"eventTitle\":\"Lịch khám - %s\"," +
                "\"eventDescription\":\"🏥 Dịch vụ: %s\\n👤 Bệnh nhân: %s\\n📞 SĐT: %s\\n👨‍⚕️ Bác sĩ: %s\\n📍 Địa điểm: %s\\n📝 Lý do: %s\\n💼 Mã hóa đơn: %s\"," +
                "\"startDateTime\":\"%s\"," +
                "\"endDateTime\":\"%s\"," +
                "\"location\":\"%s\"," +
                "\"attendees\":[{\"email\":\"%s\"},{\"email\":\"%s\"}]," +
                "\"appointmentDate\":\"%s\"," +
                "\"appointmentTime\":\"%s\"," +
                "\"serviceName\":\"%s\"," +
                "\"billId\":\"%s\"," +
                "\"clinicName\":\"%s\"," +
                "\"reason\":\"%s\"," +
                "\"timestamp\":\"%s\"" +
                "}",
                userEmail.trim(),
                escapeJson(userName),
                escapeJson(userPhone),
                doctorEmail != null ? doctorEmail.trim() : "",
                escapeJson(doctorName),
                escapeJson(serviceName),
                escapeJson(serviceName),
                escapeJson(userName),
                escapeJson(userPhone),
                escapeJson(doctorName),
                escapeJson(clinicAddress != null ? clinicAddress : "Phòng khám Nha khoa"),
                escapeJson(reason != null ? reason : "Khám tổng quát"),
                billId,
                startDateTime,
                endDateTime,
                escapeJson(clinicAddress != null ? clinicAddress : "Phòng khám Nha khoa"),
                userEmail.trim(),
                doctorEmail != null ? doctorEmail.trim() : "",
                appointmentDate,
                appointmentTime,
                escapeJson(serviceName),
                billId,
                escapeJson(clinicName != null ? clinicName : "Phòng khám Nha khoa"),
                escapeJson(reason != null ? reason : "Khám tổng quát"),
                java.time.LocalDateTime.now().toString()
            );

            System.out.println("📅 === TẠO LỊCH GOOGLE CALENDAR THÔNG QUA N8N ===");
            System.out.println("📧 Email khách hàng: " + userEmail);
            System.out.println("📧 Email bác sĩ: " + doctorEmail);
            System.out.println("👤 Tên khách hàng: " + userName);
            System.out.println("👨‍⚕️ Bác sĩ: " + doctorName);
            System.out.println("📅 Ngày: " + appointmentDate);
            System.out.println("⏰ Thời gian: " + appointmentTime);
            System.out.println("🏥 Dịch vụ: " + serviceName);
            System.out.println("📍 Địa điểm: " + clinicAddress);
            System.out.println("💼 Mã hóa đơn: " + billId);
            System.out.println("📤 Calendar JSON payload: " + jsonInputString);
            System.out.println("🔗 Calendar Webhook URL: " + CALENDAR_WEBHOOK_URL);

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = con.getResponseCode();
            System.out.println("📨 N8N calendar webhook response: " + code);
            
            if (code == 200) {
                System.out.println("✅ Đã gửi yêu cầu tạo Google Calendar event tới N8N!");
                // Thêm vào cache sau khi gửi thành công
                createdEvents.add(eventKey);
                
                // Log chi tiết
                System.out.println("📅 CALENDAR EVENT DETAILS:");
                System.out.println("   📅 Start: " + startDateTime);
                System.out.println("   📅 End: " + endDateTime);
                System.out.println("   👥 Attendees (object array): [{\"email\":\"" + userEmail + "\"},{\"email\":\"" + doctorEmail + "\"}]");
                System.out.println("   📍 Location: " + clinicAddress);
            } else {
                System.out.println("⚠️ N8N calendar webhook trả về code: " + code);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi gửi calendar webhook N8N: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 🆕 METHOD ĐƠN GIẢN HÓA CHO CALENDAR
    public static void createGoogleCalendarEventSimple(
            String userEmail,
            String userName,
            String doctorEmail,
            String doctorName,
            String appointmentDate,
            String appointmentTime,
            String serviceName,
            String billId
    ) {
        createGoogleCalendarEvent(
            userEmail,
            userName,
            "Chưa cập nhật", // Default phone
            doctorEmail,
            doctorName,
            appointmentDate,
            appointmentTime,
            serviceName,
            billId,
            "Phòng khám Nha khoa DentalClinic",
            "FPT University Đà Nẵng",
            "Khám tổng quát"
        );
    }

    // 🆕 METHOD RIÊNG: Chỉ tạo Google Calendar Event
    public static void createGoogleCalendarEventDirect(
            String userEmail,
            String userName,
            String userPhone,
            String doctorEmail,
            String doctorName,
            String appointmentDate,
            String appointmentTime,
            String serviceName,
            String billId,
            double billAmount,
            String location
    ) {
        try {
            // Tách thời gian để tạo startDateTime và endDateTime
            String[] timeParts = appointmentTime.split(" - ");
            String startTime = timeParts.length > 0 ? timeParts[0].trim() : "08:00";
            String endTime = timeParts.length > 1 ? timeParts[1].trim() : "09:00";
            
            String startDateTime = appointmentDate + "T" + startTime + ":00+07:00";
            String endDateTime = appointmentDate + "T" + endTime + ":00+07:00";
            
            // Format số tiền
            String formattedAmount = String.format("%,.0f", billAmount);
            
            URL url = new URL(CALENDAR_WEBHOOK_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            // JSON payload đơn giản cho calendar
            String jsonInputString = String.format(
                "{" +
                "\"userEmail\":\"%s\"," +
                "\"userName\":\"%s\"," +
                "\"userPhone\":\"%s\"," +
                "\"doctorEmail\":\"%s\"," +
                "\"doctorName\":\"%s\"," +
                "\"appointmentDate\":\"%s\"," +
                "\"appointmentTime\":\"%s\"," +
                "\"serviceName\":\"%s\"," +
                "\"billId\":\"%s\"," +
                "\"formattedAmount\":\"%s VNĐ\"," +
                "\"startDateTime\":\"%s\"," +
                "\"endDateTime\":\"%s\"," +
                "\"eventTitle\":\"🦷 %s - %s\"," +
                "\"location\":\"%s\"," +
                "\"attendees\":[{\"email\":\"%s\"},{\"email\":\"%s\"}]" +
                "}",
                userEmail, escapeJson(userName), escapeJson(userPhone),
                doctorEmail, escapeJson(doctorName),
                appointmentDate, appointmentTime,
                escapeJson(serviceName), billId, formattedAmount,
                startDateTime, endDateTime,
                escapeJson(serviceName), escapeJson(userName),
                escapeJson(location), userEmail, doctorEmail
            );

            System.out.println("📅 === TẠO GOOGLE CALENDAR RIÊNG BIỆT ===");
            System.out.println("🔗 Calendar URL: " + CALENDAR_WEBHOOK_URL);
            System.out.println("📅 Start: " + startDateTime);
            System.out.println("📅 End: " + endDateTime);
            System.out.println("📧 Attendees: " + userEmail + ", " + doctorEmail);
            System.out.println("📤 JSON: " + jsonInputString);

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = con.getResponseCode();
            System.out.println("📨 Calendar webhook response: " + code);
            
            if (code == 200) {
                System.out.println("✅ ĐÃ TẠO GOOGLE CALENDAR EVENT THÀNH CÔNG!");
            } else {
                System.out.println("⚠️ Calendar webhook trả về code: " + code);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi tạo calendar event: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 🆕 METHOD ALL-IN-ONE: Gửi cả Email + Calendar trong 1 workflow
    public static void sendPaymentSuccessWithCalendar(
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
            String clinicPhone,
            String reason
    ) {
        try {
            // 🚫 KIỂM TRA ANTI-SPAM
            String requestKey = billId + "_complete";
            if (sentEmails.contains(requestKey)) {
                System.out.println("🚫 ANTI-SPAM: Email + Calendar đã được gửi cho " + billId);
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

            // Tách thời gian để tạo startDateTime và endDateTime với timezone VN
            String[] timeParts = appointmentTime.split(" - ");
            String startTime = timeParts.length > 0 ? timeParts[0].trim() : "08:00";
            String endTime = timeParts.length > 1 ? timeParts[1].trim() : "09:00";
            
            String startDateTime = appointmentDate + "T" + startTime + ":00+07:00";
            String endDateTime = appointmentDate + "T" + endTime + ":00+07:00";
            
            System.out.println("📅 PAYMENT CALENDAR DEBUG:");
            System.out.println("   appointmentDate: " + appointmentDate);
            System.out.println("   appointmentTime: " + appointmentTime);
            System.out.println("   startTime: " + startTime);
            System.out.println("   endTime: " + endTime);
            System.out.println("   startDateTime FINAL: " + startDateTime);
            System.out.println("   endDateTime FINAL: " + endDateTime);

            // JSON payload ALL-IN-ONE cho cả Email và Calendar - FIXED FORMAT
            String jsonInputString = String.format(
                "{" +
                "\"type\":\"payment_success\"," +
                "\"to\":\"%s\"," +
                "\"userEmail\":\"%s\"," +
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
                "\"startDateTime\":\"%s\"," +
                "\"endDateTime\":\"%s\"," +
                "\"eventTitle\":\"Lịch khám - %s\"," +
                "\"eventDescription\":\"🏥 Dịch vụ: %s\\n👤 Bệnh nhân: %s\\n📞 SĐT: %s\\n👨‍⚕️ Bác sĩ: %s\\n📍 Địa điểm: %s\\n📝 Lý do: %s\\n💼 Mã hóa đơn: %s\"," +
                "\"location\":\"%s\"," +
                "\"attendees\":[{\"email\":\"%s\"},{\"email\":\"%s\"}]," +
                "\"reason\":\"%s\"," +
                "\"timestamp\":\"%s\"" +
                "}",
                userEmail.trim(),
                userEmail.trim(), // userEmail field thêm
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
                escapeJson(clinicName != null ? clinicName : "Phòng khám Nha khoa DentalClinic"),
                escapeJson(clinicAddress != null ? clinicAddress : "FPT University Đà Nẵng"),
                escapeJson(clinicPhone != null ? clinicPhone : "0936929382"),
                startDateTime,
                endDateTime,
                escapeJson(serviceName),
                escapeJson(serviceName),
                escapeJson(userName),
                escapeJson(userPhone),
                escapeJson(doctorName),
                escapeJson(clinicAddress != null ? clinicAddress : "FPT University Đà Nẵng"),
                escapeJson(reason != null ? reason : "Khám tổng quát"),
                billId,
                escapeJson(clinicAddress != null ? clinicAddress : "FPT University Đà Nẵng"),
                userEmail.trim(), // attendees email 1
                doctorEmail != null ? doctorEmail.trim() : "contact@dentalclinic.vn", // attendees email 2
                escapeJson(reason != null ? reason : "Khám tổng quát"),
                java.time.LocalDateTime.now().toString()
            );

            System.out.println("🚀 === GỬI EMAIL + CALENDAR THÔNG QUA N8N WORKFLOW ===");
            System.out.println("📧 Email khách hàng: " + userEmail);
            System.out.println("📧 Email bác sĩ: " + doctorEmail);
            System.out.println("👤 Tên khách hàng: " + userName);
            System.out.println("👨‍⚕️ Bác sĩ: " + doctorName);
            System.out.println("📅 Ngày khám: " + appointmentDate);
            System.out.println("⏰ Thời gian: " + appointmentTime);
            System.out.println("🏥 Dịch vụ: " + serviceName);
            System.out.println("💰 Số tiền: " + formattedAmount);
            System.out.println("📄 Mã hóa đơn: " + billId);
            System.out.println("📅 Start: " + startDateTime);
            System.out.println("📅 End: " + endDateTime);
            System.out.println("🔗 N8N Webhook URL: " + WEBHOOK_URL);

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = con.getResponseCode();
            System.out.println("📨 N8N All-in-One response: " + code);
            
            // 📖 ĐỌC RESPONSE BODY ĐỂ KIỂM TRA CHI TIẾT
            String responseBody = "";
            try {
                if (code == 200) {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"))) {
                        StringBuilder response = new StringBuilder();
                        String responseLine;
                        while ((responseLine = br.readLine()) != null) {
                            response.append(responseLine.trim());
                        }
                        responseBody = response.toString();
                    }
                } else {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "utf-8"))) {
                        StringBuilder response = new StringBuilder();
                        String responseLine;
                        while ((responseLine = br.readLine()) != null) {
                            response.append(responseLine.trim());
                        }
                        responseBody = response.toString();
                    }
                }
            } catch (Exception e) {
                responseBody = "Unable to read response: " + e.getMessage();
            }
            
            if (code == 200) {
                System.out.println("✅ ĐÃ GỬI THÀNH CÔNG: Email xác nhận + Google Calendar event!");
                System.out.println("📧 Email sẽ được gửi đến: " + userEmail);
                System.out.println("📅 Calendar event sẽ được tạo cho: " + userEmail + " và " + doctorEmail);
                System.out.println("📝 N8N Response Body: " + responseBody);
                
                // 🔍 KIỂM TRA XEM CÓ THÔNG TIN CALENDAR TRONG RESPONSE KHÔNG
                if (responseBody.toLowerCase().contains("calendar") || responseBody.toLowerCase().contains("event")) {
                    System.out.println("🎉 CALENDAR EVENT DETECTED IN RESPONSE!");
                } else {
                    System.out.println("⚠️ NO CALENDAR MENTION IN RESPONSE");
                }
                
                // 📊 LOG CHI TIẾT DATA ĐÃ GỬI CHO GOOGLE CALENDAR
                System.out.println("🗓️ === GOOGLE CALENDAR DATA SENT ===");
                System.out.println("   📅 Event Title: " + escapeJson(serviceName));
                System.out.println("   🕐 Start DateTime: " + startDateTime);
                System.out.println("   🕐 End DateTime: " + endDateTime);
                System.out.println("   📍 Location: " + escapeJson(clinicAddress != null ? clinicAddress : "FPT University Đà Nẵng"));
                System.out.println("   👥 Attendees (object array): [{\"email\":\"" + userEmail.trim() + "\"},{\"email\":\"" + (doctorEmail != null ? doctorEmail.trim() : "contact@dentalclinic.vn") + "\"}]");
                System.out.println("   📧 Patient Email: " + userEmail.trim());
                System.out.println("   📧 Doctor Email: " + (doctorEmail != null ? doctorEmail.trim() : "contact@dentalclinic.vn"));
                System.out.println("   📝 Description Length: " + ("🏥 Dịch vụ: " + escapeJson(serviceName)).length() + " chars");
                System.out.println("=========================================");
                
                // Thêm vào cache sau khi thành công
                sentEmails.add(requestKey);
            } else {
                System.out.println("⚠️ N8N All-in-One webhook trả về code: " + code);
                System.out.println("❌ Error Response Body: " + responseBody);
                
                // 🔍 PHÂN TÍCH LỖI CHI TIẾT
                if (responseBody.toLowerCase().contains("calendar")) {
                    System.out.println("🔍 CALENDAR ERROR DETECTED - Check N8N Google Calendar node configuration!");
                }
                if (responseBody.toLowerCase().contains("authentication")) {
                    System.out.println("🔍 AUTHENTICATION ERROR - Check Google Calendar API credentials!");
                }
                if (responseBody.toLowerCase().contains("permission")) {
                    System.out.println("🔍 PERMISSION ERROR - Check Google Calendar permissions!");
                }
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi gửi All-in-One webhook N8N: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 🔄 UTILITY: Reset cache anti-spam (dùng cho testing)
    public static void resetAntiSpamCache() {
        sentEmails.clear();
        createdEvents.clear(); // Thêm reset cho calendar cache
        System.out.println("🔄 ĐÃ RESET CACHE ANTI-SPAM (EMAIL + CALENDAR)");
    }

    // 📊 UTILITY: Kiểm tra số email đã gửi
    public static int getSentEmailCount() {
        return sentEmails.size();
    }
    
    // 📊 UTILITY: Kiểm tra số calendar event đã tạo
    public static int getCreatedEventCount() {
        return createdEvents.size();
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

    // 🆕 METHOD SỬ DỤNG APPOINTMENT_ID ĐỂ LẤY EMAIL TỪ DATABASE
    public static void createGoogleCalendarEventFromAppointmentId(
            int appointmentId,
            String appointmentDate,
            String appointmentTime,
            String serviceName,
            String billId,
            String clinicName,
            String clinicAddress,
            String reason
    ) {
        try {
            // Lấy email từ appointment_id
            String[] emails = dao.AppointmentDAO.getEmailsFromAppointment(appointmentId);
            String patientEmail = emails[0];
            String doctorEmail = emails[1];
            
            if (patientEmail == null || doctorEmail == null) {
                System.out.println("❌ Không thể lấy email từ appointment_id: " + appointmentId);
                return;
            }
            
            // Gọi method tạo calendar với email đã lấy
            createGoogleCalendarEvent(
                patientEmail,
                "Khách hàng", // Default name - có thể lấy từ DB nếu cần
                "Chưa cập nhật", // Default phone
                doctorEmail,
                "Bác sĩ", // Default name - có thể lấy từ DB nếu cần
                appointmentDate,
                appointmentTime,
                serviceName,
                billId,
                clinicName != null ? clinicName : "Phòng khám Nha khoa DentalClinic",
                clinicAddress != null ? clinicAddress : "FPT University Đà Nẵng",
                reason != null ? reason : "Khám tổng quát"
            );
            
            System.out.println("✅ Đã gửi calendar event với emails từ appointment_id: " + appointmentId);
            System.out.println("📧 Patient email: " + patientEmail);
            System.out.println("📧 Doctor email: " + doctorEmail);
            
        } catch (Exception e) {
            System.out.println("❌ Lỗi gửi calendar từ appointment_id: " + e.getMessage());
            e.printStackTrace();
        }
    }
}