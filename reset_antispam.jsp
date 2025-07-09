<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="utils.N8nWebhookService" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Reset Anti-Spam Cache</title>
            <style>
                body {
                    font-family: Arial;
                    padding: 20px;
                }

                .success {
                    background: #d4edda;
                    padding: 10px;
                    border: 1px solid #c3e6cb;
                    color: #155724;
                }

                .info {
                    background: #d1ecf1;
                    padding: 10px;
                    border: 1px solid #bee5eb;
                    color: #0c5460;
                }
            </style>
        </head>

        <body>
            <h2>🔄 Reset Anti-Spam Cache</h2>

            <% String action=request.getParameter("action"); if ("reset".equals(action)) {
                N8nWebhookService.resetAntiSpamCache(); %>
                <div class="success">
                    ✅ <strong>Cache đã được reset!</strong><br>
                    Bây giờ có thể gửi email test lại.
                </div>
                <% } int emailCount=N8nWebhookService.getSentEmailCount(); %>

                    <div class="info">
                        📊 <strong>Thống kê hiện tại:</strong><br>
                        Số email đã gửi trong cache: <%= emailCount %>
                    </div>

                    <p>
                        <a href="?action=reset"
                            style="background: #dc3545; color: white; padding: 10px 15px; text-decoration: none;">
                            🔄 Reset Cache
                        </a>
                    </p>

                    <p>
                        <a href="/TestFull/payment?serviceId=10"
                            style="background: #007bff; color: white; padding: 10px 15px; text-decoration: none;">
                            🔙 Back to Payment
                        </a>
                    </p>

                    <hr>
                    <h3>🧪 Test N8N sau khi reset:</h3>
                    <p>1. Click "Reset Cache" ở trên</p>
                    <p>2. Thanh toán 1 lần để test</p>
                    <p>3. Kiểm tra email</p>
                    <p>4. Thử thanh toán lại → phải bị chặn anti-spam</p>
        </body>

        </html>