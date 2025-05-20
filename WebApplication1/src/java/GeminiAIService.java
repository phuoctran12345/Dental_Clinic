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

public class GeminiAIService {
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
    
    
    public static String getAIResponse(String userMessage) throws IOException {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(GEMINI_API_URL + "?key=" + API_KEY);
            httpPost.setHeader("Content-Type", "application/json");

            // Prompt ngắn gọn, yêu cầu trả lời súc tích, luôn hướng đến phòng khám
            String prompt = "Bạn là trợ lý y tế. Trả lời ngắn gọn, súc tích, dễ hiểu, bôi đậm từ khoá y tế. "
                + "Luôn nhắc bệnh nhân nên đến phòng khám để được bác sĩ kiểm tra trực tiếp. "
                + "Câu hỏi: " + userMessage;

            String requestBody = String.format(
                "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}", prompt);

            httpPost.setEntity(new StringEntity(requestBody, "UTF-8"));

            try (CloseableHttpResponse response = client.execute(httpPost)) {
                HttpEntity entity = response.getEntity();
                String responseString = EntityUtils.toString(entity, "UTF-8");

                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(responseString);

                try {
                    return root.path("candidates")
                               .get(0)
                               .path("content")
                               .path("parts")
                               .get(0)
                               .path("text")
                               .asText();
                } catch (Exception e) {
                    return "Xin lỗi, tôi không thể xử lý câu trả lời. Vui lòng thử lại sau.";
                }
            }
    }
}
 public static String formatAIResponse(String answer) {
    // Danh sách từ khoá y tế cần bôi đậm
    String[] keywords = {
        "đau răng", "sốt", "viêm", "bác sĩ", "phòng khám", "điều trị", "thuốc", "triệu chứng",
        "nguy hiểm", "cấp cứu", "khám", "chẩn đoán", "huyết áp", "nhiễm trùng", "kháng sinh",
        "Happy Smile"
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
    return answer;
}
}