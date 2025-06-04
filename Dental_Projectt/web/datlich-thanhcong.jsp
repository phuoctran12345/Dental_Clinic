<%-- 
    Document   : datlich-thanhcong
    Created on : May 27, 2025, 5:14:09 PM
    Author     : Home
--%>

<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebars.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đặt lịch</title>
    <style>
        :root {
            --primary-color: #2196F3;
            --primary-dark: #1976D2;
            --light-bg: #f8fbfe;
            --white: #ffffff;
        }
        
        body {
            font-family: 'Segoe UI', 'Roboto', sans-serif;
            background: var(--light-bg);
            margin: 0;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            margin-left: 300px;
            padding: 40px 30px;
            min-height: calc(100vh - 80px);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .message-box {
            max-width: 600px;
            width: 100%;
            background-color: var(--white);
            padding: 50px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(33, 150, 243, 0.15);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .message-box:hover {
            transform: translateY(-5px);
        }
        
        .message-icon {
            font-size: 72px;
            color: var(--primary-color);
            margin-bottom: 20px;
            animation: bounce 1s ease;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
            40% {transform: translateY(-20px);}
            60% {transform: translateY(-10px);}
        }
        
        .message-box h2 {
            color: var(--primary-dark);
            margin-bottom: 20px;
            font-size: 28px;
            font-weight: 600;
        }
        
        .message-content {
            font-size: 18px;
            margin: 25px 0;
            color: #555;
        }
        
        .btn-back {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 30px;
            background-color: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
        }
        
        .btn-back:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4);
        }
        
        .countdown {
            margin-top: 15px;
            font-size: 16px;
            color: #666;
        }
        
        .countdown-number {
            font-weight: bold;
            color: var(--primary-dark);
        }
        
        @media (max-width: 768px) {
            .container {
                margin-left: 0;
                padding: 30px 15px;
            }
            
            .message-box {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="message-box">
        <div class="message-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <h2>Thông báo</h2>
        <div class="message-content">
            <p><%= request.getAttribute("message") %></p>
        </div>
        <a href="UserHompageServlet" class="btn-back">
            <i class="fa-solid fa-arrow-left" style="margin-right: 8px;"></i>
            Quay về trang chủ
        </a>
        <div class="countdown">
            Tự động quay về trang chủ sau <span class="countdown-number" id="countdown">5</span> giây...
        </div>
    </div>
</div>

<script>
    // Đếm ngược tự động
    let seconds = 5;
    const countdownElement = document.getElementById('countdown');
    const countdownInterval = setInterval(() => {
        seconds--;
        countdownElement.textContent = seconds;
        
        if (seconds <= 0) {
            clearInterval(countdownInterval);
            window.location.href = "UserHompageServlet";
        }
    }, 1000);
    
    // Dừng đếm ngược nếu người dùng click nút
    document.querySelector('.btn-back').addEventListener('click', () => {
        clearInterval(countdownInterval);
    });
</script>

</body>
</html>