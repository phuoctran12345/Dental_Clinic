package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.OutputStream;

/**
 * Test Servlet để simulate MB Bank webhook calls
 * URL: /webhookTest
 */
@WebServlet("/webhookTest")
public class WebhookTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        String billId = request.getParameter("billId");
        String amount = request.getParameter("amount");
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head>");
        out.println("<title>🧪 MB Bank Webhook Tester</title>");
        out.println("<style>");
        out.println("body { font-family: Arial; padding: 20px; background: #f5f5f5; }");
        out.println(".container { background: white; padding: 30px; border-radius: 10px; max-width: 800px; }");
        out.println(".btn { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px; }");
        out.println(".success { color: #28a745; font-weight: bold; }");
        out.println(".error { color: #dc3545; font-weight: bold; }");
        out.println("textarea { width: 100%; height: 200px; margin: 10px 0; }");
        out.println("</style>");
        out.println("</head><body>");
        
        out.println("<div class='container'>");
        out.println("<h1>🧪 MB Bank Webhook Tester</h1>");
        out.println("<p>Simulate webhook calls để test real-time payment detection</p>");
        
        if ("send".equals(action) && billId != null && amount != null) {
            // Gửi webhook test
            boolean success = sendTestWebhook(billId, amount);
            
            if (success) {
                out.println("<div class='success'>✅ Webhook sent successfully!</div>");
            } else {
                out.println("<div class='error'>❌ Failed to send webhook</div>");
            }
        }
        
        // Form để test webhook
        out.println("<h3>📋 Send Test Webhook</h3>");
        out.println("<form method='get'>");
        out.println("<input type='hidden' name='action' value='send'>");
        
        out.println("<p><strong>Bill ID:</strong></p>");
        out.println("<input type='text' name='billId' placeholder='BILL_XXXXXXXX' style='width: 300px; padding: 8px;'>");
        
        out.println("<p><strong>Amount (VND):</strong></p>");
        out.println("<input type='number' name='amount' placeholder='2000' style='width: 200px; padding: 8px;'>");
        
        out.println("<br><br>");
        out.println("<button type='submit' class='btn'>🚀 Send Webhook</button>");
        out.println("</form>");
        
        // Sample webhook data
        out.println("<h3>📄 Sample Webhook JSON</h3>");
        out.println("<textarea readonly>");
        out.println("{\n");
        out.println("  \"transactionId\": \"MB1749726206435\",\n");
        out.println("  \"amount\": 2000,\n");
        out.println("  \"description\": \"BILL_C5C23B92\",\n");
        out.println("  \"status\": \"SUCCESS\",\n");
        out.println("  \"bankCode\": \"970422\",\n");
        out.println("  \"fromAccount\": \"Customer Account\",\n");
        out.println("  \"toAccount\": \"5529062004\",\n");
        out.println("  \"timestamp\": \"2024-12-06T18:30:00\"\n");
        out.println("}");
        out.println("</textarea>");
        
        // Quick test buttons cho recent bills
        out.println("<h3>⚡ Quick Tests</h3>");
        out.println("<p>Test với bills gần đây:</p>");
        out.println("<a href='?action=send&billId=BILL_C5C23B92&amount=2000' class='btn'>Test BILL_C5C23B92</a>");
        out.println("<a href='?action=send&billId=BILL_8FF18D1F&amount=2000' class='btn'>Test BILL_8FF18D1F</a>");
        
        out.println("<hr>");
        out.println("<p><a href='/RoleStaff/payment?serviceId=10'>🔙 Back to Payment</a></p>");
        out.println("</div>");
        
        out.println("</body></html>");
    }
    
    /**
     * Gửi test webhook tới payment endpoint
     */
    private boolean sendTestWebhook(String billId, String amount) {
        try {
            System.out.println("🧪 === SENDING TEST WEBHOOK ===");
            System.out.println("Bill ID: " + billId);
            System.out.println("Amount: " + amount);
            
            // Tạo webhook JSON
            String webhookJson = String.format(
                "{\n" +
                "  \"transactionId\": \"MB%d\",\n" +
                "  \"amount\": %s,\n" +
                "  \"description\": \"%s\",\n" +
                "  \"status\": \"SUCCESS\",\n" +
                "  \"bankCode\": \"970422\",\n" +
                "  \"fromAccount\": \"Customer Test Account\",\n" +
                "  \"toAccount\": \"5529062004\",\n" +
                "  \"timestamp\": \"%s\"\n" +
                "}",
                System.currentTimeMillis(),
                amount,
                billId,
                java.time.LocalDateTime.now().toString()
            );
            
            System.out.println("Webhook JSON: " + webhookJson);
            
            // Gửi POST request tới payment webhook endpoint
            URL url = new URL("http://localhost:8080/RoleStaff/payment?action=webhook");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            
            // Gửi JSON payload
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = webhookJson.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            
            // Đọc response
            int responseCode = conn.getResponseCode();
            System.out.println("Webhook Response Code: " + responseCode);
            
            if (responseCode == 200) {
                System.out.println("🎉 Webhook sent successfully!");
                return true;
            } else {
                System.err.println("❌ Webhook failed with code: " + responseCode);
                return false;
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error sending webhook: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
} 