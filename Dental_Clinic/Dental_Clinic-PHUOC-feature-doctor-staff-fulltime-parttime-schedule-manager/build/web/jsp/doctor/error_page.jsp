<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi - Hệ thống Quản lý Bác sĩ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 48px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        h1 {
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border: 1px solid #f5c6cb;
        }
        .back-button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            display: inline-block;
        }
        .back-button:hover {
            background-color: #0056b3;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1>Đã xảy ra lỗi</h1>
        
        <div class="error-message">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "Lỗi không xác định" %>
        </div>
        
        <a href="/doctor/DoctorAppointmentsServlet" class="back-button">← Quay lại danh sách cuộc hẹn</a>
    </div>
</body>
</html> 
