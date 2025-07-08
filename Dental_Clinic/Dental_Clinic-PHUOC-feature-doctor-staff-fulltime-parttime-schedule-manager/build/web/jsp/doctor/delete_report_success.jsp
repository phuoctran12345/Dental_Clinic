<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Xóa Báo Cáo Thành Công</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .success-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
        }
        .success-icon {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }
        .success-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .warning-text {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
    <script>
        // Tự động redirect sau 10 giây
        let countdown = 10;
        function updateCountdown() {
            document.getElementById('countdown').textContent = countdown;
            if (countdown <= 0) {
                window.location.href = '/doctor/DoctorAppointmentsServlet';
            }
            countdown--;
        }
        
        // Bắt đầu đếm ngược
        setInterval(updateCountdown, 1000);
        updateCountdown();
    </script>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✅</div>
        <div class="success-title">Xóa Báo Cáo Thành Công!</div>
        
        <div class="warning-text">
            <strong>⚠️ Lưu ý:</strong> Báo cáo y tế và tất cả đơn thuốc liên quan đã được xóa vĩnh viễn khỏi hệ thống.
        </div>
        
        <div class="success-message">
            Báo cáo y tế đã được xóa thành công khỏi hệ thống.<br>
            Tất cả thông tin liên quan (đơn thuốc, chẩn đoán, ghi chú) đã được loại bỏ.<br><br>
            
            <small>Tự động chuyển về trang chính sau <span id="countdown">10</span> giây...</small>
        </div>
        
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="btn btn-primary">
                🏠 Về Trang Chính
            </a>
            <a href="${pageContext.request.contextPath}/DoctorHomePageServlet" class="btn btn-secondary">
                📊 Dashboard
            </a>
        </div>
    </div>
</body>
</html> 
