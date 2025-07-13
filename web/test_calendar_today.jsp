<%@ page contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Test Google Calendar - TODAY</title>
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
        <h1>🧪 Test Google Calendar - HÔM NAY (10/01/2025)</h1>

        <button class="test-button" onclick="testTodayCalendar()">
            📅 Test Calendar HÔM NAY
        </button>

        <div id="result" class="result" style="display: none;"></div>

        <script>
            function showResult(message, isSuccess = true) {
                const resultDiv = document.getElementById('result');
                resultDiv.className = 'result ' + (isSuccess ? 'success' : 'error');
                resultDiv.innerHTML = message;
                resultDiv.style.display = 'block';
            }

            async function testTodayCalendar() {
                showResult('🔄 Đang test Calendar HÔM NAY...', true);

                const now = new Date();
                const today = now.toISOString().split('T')[0]; // 2025-01-10
                const currentHour = now.getHours();
                const startHour = currentHour + 1; // 1 giờ sau
                const endHour = currentHour + 2;   // 2 giờ sau

                const testData = {
                    type: "payment_success",
                    userEmail: "phuocthde180577@fpt.edu.vn",
                    doctorEmail: "de180577tranhongphuoc@gmail.com",
                    userName: "Test User TODAY",
                    doctorName: "Test Doctor",
                    appointmentDate: today,
                    appointmentTime: `${startHour.toString().padStart(2, '0')}:00 - ${endHour.toString().padStart(2, '0')}:00`,
                    serviceName: "Test Service TODAY",
                    billId: "BILL_TODAY_" + Date.now(),
                    startDateTime: `${today}T${startHour.toString().padStart(2, '0')}:00:00`,
                    endDateTime: `${today}T${endHour.toString().padStart(2, '0')}:00:00`,
                    eventTitle: "🧪 Test Calendar HÔM NAY",
                    eventDescription: "Test event được tạo HÔM NAY " + now.toLocaleString('vi-VN'),
                    attendees: [
                        { "email": "phuocthde180577@fpt.edu.vn" },
                        { "email": "de180577tranhongphuoc@gmail.com" }
                    ]
                };

                console.log('📤 SENDING DATA:', testData);

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
                        ✅ Test Calendar HÔM NAY thành công!<br>
                        📅 Date: ${today}<br>
                        ⏰ Time: ${startHour}:00 - ${endHour}:00<br>
                        🌐 N8N Response: ${response.status}<br>
                        📧 Check Google Calendar bây giờ!<br>
                        🔗 <a href="https://calendar.google.com" target="_blank">Mở Google Calendar</a>
                    `, true);
                    } else {
                        showResult(`❌ N8N response error: ${response.status}`, false);
                    }

                } catch (error) {
                    showResult(`❌ Network error: ${error.message}`, false);
                }
            }

            // Auto show current time
            window.onload = function () {
                const now = new Date();
                const today = now.toISOString().split('T')[0];
                const currentTime = now.toLocaleString('vi-VN');
                showResult(`
                📋 Ready to test Calendar HÔM NAY!<br>
                📅 Date: ${today}<br>
                ⏰ Current time: ${currentTime}<br>
                🎯 Test sẽ tạo event 1-2 giờ sau
            `, true);
            };
        </script>
    </body>

    </html>