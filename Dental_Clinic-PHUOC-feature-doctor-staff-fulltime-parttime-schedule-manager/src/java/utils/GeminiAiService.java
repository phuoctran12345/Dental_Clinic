package utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;


/**
 *
 * @author tranhongphuoc
 */

public class GeminiAiService {
        private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
    private static final String API_KEY= "abc";

    
    
    public static String getAIResponse(String userMessage) throws IOException {
        System.out.println("Starting getAIResponse with message: " + userMessage);
        
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(GEMINI_API_URL + "?key=" + API_KEY);
            httpPost.setHeader("Content-Type", "application/json");

            // Prompt ngắn gọn, yêu cầu trả lời súc tích, luôn hướng đến phòng khám
            String prompt = "Bạn là trợ lý y tế. Trả lời ngắn gọn, súc tích, dễ hiểu, bôi đậm từ khoá y tế. "
                + "Luôn nhắc bệnh nhân nên đến phòng khám để được bác sĩ kiểm tra trực tiếp. "
                + "Câu hỏi: " + userMessage;

            String requestBody = String.format(
                "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}", prompt);
            
            System.out.println("Request body: " + requestBody);

            httpPost.setEntity(new StringEntity(requestBody, "UTF-8"));

            System.out.println("Sending request to Gemini API...");
            try (CloseableHttpResponse response = client.execute(httpPost)) {
                HttpEntity entity = response.getEntity();
                String responseString = EntityUtils.toString(entity, "UTF-8");
                System.out.println("Gemini raw response: " + responseString);

                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(responseString);

                try {
                    String result = root.path("candidates")
                               .get(0)
                               .path("content")
                               .path("parts")
                               .get(0)
                               .path("text")
                               .asText();
                    System.out.println("Extracted text: " + result);
                    
                    if (result != null && !result.trim().isEmpty()) {
                        return result;
                    } else {
                        System.out.println("Extracted text is null or empty");
                        return "Xin lỗi, tôi không thể xử lý câu trả lời. Vui lòng thử lại sau.";
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing JSON: " + e.getMessage());
                    e.printStackTrace();
                    return "Xin lỗi, tôi không thể xử lý câu trả lời. Vui lòng thử lại sau.";
                }
            }
        } catch (Exception e) {
            System.out.println("Exception in getAIResponse: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Error calling Gemini API", e);
        }
    }
    
    /**
     * Method chuyên biệt để tạo ghi chú y tế dựa trên thông tin khám bệnh xử lý chỗ MedicalNoteAiServlet
     */
    public static String getMedicalNoteResponse(String medicalPrompt) throws IOException {
        System.out.println("Starting getMedicalNoteResponse with prompt: " + medicalPrompt);
        
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(GEMINI_API_URL + "?key=" + API_KEY);
            httpPost.setHeader("Content-Type", "application/json");

            String requestBody = String.format(
                "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}", 
                medicalPrompt.replace("\"", "\\\"").replace("\n", "\\n"));
            
            System.out.println("Medical note request body: " + requestBody);

            httpPost.setEntity(new StringEntity(requestBody, "UTF-8"));

            System.out.println("Sending medical note request to Gemini API...");
            try (CloseableHttpResponse response = client.execute(httpPost)) {
                HttpEntity entity = response.getEntity();
                String responseString = EntityUtils.toString(entity, "UTF-8");
                System.out.println("Gemini medical note raw response: " + responseString);

                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(responseString);

                try {
                    String result = root.path("candidates")
                               .get(0)
                               .path("content")
                               .path("parts")
                               .get(0)
                               .path("text")
                               .asText();
                    System.out.println("Extracted medical note: " + result);
                    
                    if (result != null && !result.trim().isEmpty()) {
                        // Làm sạch và format ghi chú y tế
                        return formatMedicalNote(result);
                    } else {
                        System.out.println("Extracted medical note is null or empty");
                        return "Bệnh nhân nên tuân thủ theo hướng dẫn điều trị và tái khám theo lịch hẹn.";
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing medical note JSON: " + e.getMessage());
                    e.printStackTrace();
                    return "Bệnh nhân nên tuân thủ theo hướng dẫn điều trị và tái khám theo lịch hẹn.";
                }
            }
        } catch (Exception e) {
            System.out.println("Exception in getMedicalNoteResponse: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Error calling Gemini API for medical note", e);
        }
    }
    
    /**
     * Format ghi chú y tế để phù hợp với form
     */
    private static String formatMedicalNote(String note) {
        System.out.println("Formatting medical note: " + note);
        
        // Loại bỏ các ký tự không mong muốn và header
        note = note.trim();
        note = note.replaceAll("\\*+", ""); // Loại bỏ dấu *
        note = note.replaceAll("#+", ""); // Loại bỏ dấu #
        note = note.replaceAll("═+", ""); // Loại bỏ ký tự box drawing
        note = note.replaceAll("📋|📝|🔍|⚕️|💊|💬|✅|⚠️", ""); // Loại bỏ emoji
        
        // Loại bỏ các header không cần thiết
        note = note.replaceAll("(?i).*Hãy\\s+viết\\s+ghi\\s+chú.*", "");
        note = note.replaceAll("(?i).*THÔNG\\s+TIN\\s+KHÁM.*", "");
        note = note.replaceAll("(?i).*YÊU\\s+CẦU\\s+VIẾT.*", "");
        note = note.replaceAll("(?i).*PHONG\\s+CÁCH\\s+VIẾT.*", "");
        
        // Loại bỏ các dòng trống thừa
        note = note.replaceAll("\n{3,}", "\n\n");
        note = note.trim();
        
        // Đảm bảo bắt đầu bằng "Ghi chú nha khoa" nếu chưa có
        if (!note.toLowerCase().startsWith("ghi chú nha khoa")) {
            if (note.length() > 20) {
                note = "Ghi chú nha khoa\n\n" + note;
            }
        }
        
        // Đảm bảo ghi chú có độ dài phù hợp (tối đa 600 ký tự cho ghi chú chi tiết)
        if (note.length() > 600) {
            // Tìm điểm cắt hợp lý (cuối câu)
            int cutPoint = note.lastIndexOf(".", 597);
            if (cutPoint > 200) {
                note = note.substring(0, cutPoint + 1);
            } else {
                note = note.substring(0, 597) + "...";
            }
        }
        
        // Nếu ghi chú rỗng hoặc quá ngắn, trả về ghi chú mặc định chuyên nghiệp
        if (note.isEmpty() || note.length() < 30) {
            note = "Ghi chú nha khoa\n\n" +
                   "Bệnh nhân đã được khám và điều trị theo đúng chỉ định y khoa. " +
                   "Vui lòng tuân thủ đúng liều lượng thuốc đã được kê và theo dõi sức khỏe thường xuyên. " +
                   "Nếu có bất kỳ triệu chứng bất thường nào, xin vui lòng liên hệ với bác sĩ để được tư vấn kịp thời. " +
                   "Chúc bạn sớm hồi phục sức khỏe!";
        }
        
        // Đảm bảo ghi chú kết thúc đúng cách
        if (!note.endsWith(".") && !note.endsWith("!") && !note.endsWith("?")) {
            note += ".";
        }
        
        // Làm sạch format cuối cùng
        note = note.replaceAll("(?m)^\\s*$", ""); // Loại bỏ dòng trống
        note = note.replaceAll("\n{2,}", "\n\n"); // Chuẩn hóa xuống dòng
        
        System.out.println("Formatted medical note: " + note);
        return note;
    }
    
    public static String formatAIResponse(String answer) {
        System.out.println("Starting formatAIResponse with: " + answer);
        
        // Danh sách từ khoá y tế cần bôi đậm
        String[] keywords = {
            "đau răng", "sốt", "viêm", "bác sĩ", "phòng khám", "điều trị", "thuốc", "triệu chứng",
            "nguy hiểm", "cấp cứu", "khám", "chẩn đoán", "huyết áp", "nhiễm trùng", "kháng sinh",
            "Happy Smile", "sức khỏe"
        };
        for (String kw : keywords) {
            answer = answer.replaceAll("(?i)\\b(" + kw + ")\\b",
                "<b style='color:#e74c3c;background:#fffbe6;padding:2px 4px;border-radius:4px;'>$1</b>");
        }
        // Xuống dòng cho dễ đọc
        answer = answer.replaceAll("\\*\\*", "<b>").replaceAll("\\*", "</b>");
        answer = answer.replaceAll("\n", "<br>");
        // Luôn nhắc đến phòng khám
        if (!answer.toLowerCase().contains("phòng khám")) {
            answer += "<br><b style='color:#1976d2;'>Bạn nên đến phòng khám <span style='color:#e67e22;'>Happy Smile</span> để được bác sĩ kiểm tra và tư vấn kịp thời!</b>";
        }
        
        System.out.println("Formatted response: " + answer);
        return answer;
    }
}