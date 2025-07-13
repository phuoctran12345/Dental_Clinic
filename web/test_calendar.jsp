<%@ page contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Test Google Calendar Integration</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
            }

            .test-button {
                background: #4285f4;
                color: white;
                padding: 15px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin: 10px;
                font-size: 16px;
            }

            .test-button:hover {
                background: #3367d6;
            }

            .result {
                margin-top: 20px;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background: #f9f9f9;
            }

            .success {
                border-color: #4caf50;
                background: #e8f5e9;
            }

            .error {
                border-color: #f44336;
                background: #ffebee;
            }
        </style>
    </head>

    <body>
        <h1>🧪 Test Google Calendar Integration</h1>

        <h2>📋 Hướng dẫn test:</h2>
        <ol>
            <li>Chọn loại test bên dưới</li>
            <li>Kiểm tra console log để xem data được gửi</li>
            <li>Kiểm tra N8N workflow có nhận được data không</li>
            <li>Kiểm tra Google Calendar có tạo event không</li>
        </ol>

        <h2>🚀 Test Actions:</h2>

        <!-- Test 1: Basic Calendar Event -->
        <button class="test-button" onclick="testBasicCalendar()">
            📅 Test Basic Calendar Event
        </button>

        <!-- Test 2: Full Payment Calendar -->
        <button class="test-button" onclick="testPaymentCalendar()">
            💰 Test Payment + Calendar
        </button>

        <!-- Test 3: N8N Direct Test -->
        <button class="test-button" onclick="testN8NDirect()">
            🌐 Test N8N Direct
        </button>

        <div id="result" class="result" style="display: none;"></div>

        <script>
            function showResult(message, isSuccess = true) {
                const resultDiv = document.getElementById('result');
                resultDiv.className = 'result ' + (isSuccess ? 'success' : 'error');
                resultDiv.innerHTML = message;
                resultDiv.style.display = 'block';
            }

            async function testBasicCalendar() {
                showResult('🔄 Đang test Basic Calendar Event...', true);

                try {
                    const response = await fetch('/TestFull/payment?action=testPayment', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'billId=BILL_TEST_CALENDAR&relativeId='
                    });

                    const result = await response.json();

                    if (result.success) {
                        showResult(`
                        ✅ Test Basic Calendar thành công!<br>
                        📧 Email sent: ${result.emailSent}<br>
                        📅 Appointment created: ${result.appointmentCreated}<br>
                        💬 Message: ${result.message}
                    `, true);
                    } else {
                        showResult(`❌ Test thất bại: ${result.message}`, false);
                    }

                } catch (error) {
                    showResult(`❌ Lỗi: ${error.message}`, false);
                }
            }

            async function testPaymentCalendar() {
                showResult('🔄 Đang test Payment + Calendar...', true);

                // Simulate full payment flow
                try {
                    const response = await fetch('/TestFull/payment?action=testPayment', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'billId=BILL_TEST_PAYMENT&orderId=ORDER_TEST_PAYMENT'
                    });

                    const result = await response.json();

                    if (result.success) {
                        showResult(`
                        ✅ Test Payment Calendar thành công!<br>
                        📧 Email sent: ${result.emailSent}<br>
                        📅 Calendar created: true<br>
                        💰 Payment processed: true<br>
                        💬 Message: ${result.message}
                    `, true);
                    } else {
                        showResult(`❌ Test thất bại: ${result.message}`, false);
                    }

                } catch (error) {
                    showResult(`❌ Lỗi: ${error.message}`, false);
                }
            }

            async function testN8NDirect() {
                showResult('🔄 Đang test N8N Direct...', true);

                // Test direct N8N webhook
                const testData = {
                    type: "payment_success",
                    userEmail: "phuocthde180577@fpt.edu.vn",
                    doctorEmail: "de180577tranhongphuoc@gmail.com",
                    userName: "Test User",
                    doctorName: "Test Doctor",
                    appointmentDate: "2025-07-12",
                    appointmentTime: "08:00 - 09:00",
                    serviceName: "Test Service",
                    billId: "BILL_TEST_DIRECT",
                    startDateTime: "2025-07-12T08:00:00",
                    endDateTime: "2025-07-12T09:00:00",
                    eventTitle: "Test Calendar Event",
                    attendees: [
                        { "email": "phuocthde180577@fpt.edu.vn" },
                        { "email": "de180577tranhongphuoc@gmail.com" }
                    ]
                };

                try {
                    const response = await fetch('https://kinggg123.app.n8n.cloud/webhook/send-appointment-email', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify(testData)
                    });

                    if (response.ok) {
                        showResult(`
                        ✅ Test N8N Direct thành công!<br>
                        🌐 Response status: ${response.status}<br>
                        📧 Data sent to N8N successfully<br>
                        📅 Calendar should be created now
                    `, true);
                    } else {
                        showResult(`❌ N8N response error: ${response.status}`, false);
                    }

                } catch (error) {
                    showResult(`❌ Network error: ${error.message}`, false);
                }
            }

            // Auto-run status check
            window.onload = function () {
                const currentTime = new Date().toLocaleString('vi-VN');
                showResult(
                    `📋 Test Calendar Integration sẵn sàng!<br>
                🔗 N8N Webhook: https://kinggg123.app.n8n.cloud/webhook/send-appointment-email<br>
                📧 Test emails: phuocthde180577@fpt.edu.vn ↔ de180577tranhongphuoc@gmail.com<br>
                ⏰ Current time: ` + currentTime
                    , true);
            };
        </script>
    </body>

    </html>