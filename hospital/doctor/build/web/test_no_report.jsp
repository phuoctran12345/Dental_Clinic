<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Test - Không Có Báo Cáo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        .test-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .test-title {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .test-link {
            display: block;
            padding: 15px;
            margin: 10px 0;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            text-align: center;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .test-link:hover {
            background-color: #0056b3;
        }
        .test-description {
            background-color: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            color: #004085;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <h1 class="test-title">🧪 Test Chức Năng "Không Có Báo Cáo"</h1>
        
        <div class="test-description">
            <h3>📋 Mô tả chức năng:</h3>
            <p>Khi người dùng truy cập vào một cuộc hẹn chưa có báo cáo y tế, hệ thống sẽ hiển thị trang thông báo thân thiện với các tùy chọn hành động phù hợp.</p>
        </div>

        <h3>🔗 Các link test:</h3>
        
        <a href="ViewReportServlet?appointmentId=999" class="test-link">
            📋 Test với appointmentId không tồn tại (999)
        </a>
        
        <a href="ViewReportServlet?reportId=999" class="test-link">
            📋 Test với reportId không tồn tại (999)
        </a>
        
        <a href="no_report_found.jsp?appointmentId=123" class="test-link">
            📋 Xem trực tiếp trang "Không có báo cáo" với appointmentId=123
        </a>
        
        <a href="no_report_found.jsp" class="test-link">
            📋 Xem trực tiếp trang "Không có báo cáo" (không có appointmentId)
        </a>

        <h3>🔧 Test các trang lỗi:</h3>
        
        <a href="error_page.jsp?error=invalid_id" class="test-link">
            ❌ Test trang lỗi - ID không hợp lệ
        </a>
        
        <a href="error_page.jsp?error=system_error" class="test-link">
            ❌ Test trang lỗi - Lỗi hệ thống
        </a>
        
        <a href="error_page.jsp?error=missing_params" class="test-link">
            ❌ Test trang lỗi - Thiếu thông tin
        </a>

        <hr style="margin: 30px 0;">
        
        <div style="text-align: center;">
            <a href="DoctorAppointmentsServlet" class="test-link">
                🏠 Quay về Trang Chính
            </a>
        </div>
    </div>
</body>
</html> 