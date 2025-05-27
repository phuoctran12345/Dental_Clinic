

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/menu.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lượt khám hôm nay</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;
            }
            .container {
                font-family: Arial, sans-serif;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 10px;
                min-height: 100vh;
            }
            #menu-toggle:checked ~.container {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .title{
                display: flex;
                margin-bottom: 10px;
            }
            
            .title-2{
                padding-left: 965px;
            }
            .content {
                margin-bottom: 15px;  
            }
            
            .content p {
                color: #3b82f6;
            }
            .status-filter {
                margin-top: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }
            .card {
                background-color: #fff;
                padding: 16px;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }
            .badge.waiting {
                background-color: #dbeafe;
                color: #2563eb;
            }
            .badge.done {
                background-color: #bbf7d0;
                color: #15803d;
            }
            .info {
                display: flex;
                margin-top: 12px;
                gap: 12px;
            }
            .info img {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                object-fit: cover;
            }
            .info-details {
                flex: 1;
            }
            .info-details p {
                margin: 4px 0;
                font-size: 14px;
            }
            .actions {
                margin-top: 12px;
                display: flex;
                gap: 8px;
            }
            .actions button {
                padding: 6px 12px;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                cursor: pointer;
            }
            .btn-blue {
                background-color: #2563eb;
                color: white;
            }
            .btn-green {
                background-color: #16a34a;
                color: white;
            }
            .btn-gray {
                background-color: #e5e7eb;
                color: #111827;
            }

        </style>
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <div class="container">
            <div class="content">
                <h2>Lượt khám hôm nay</h2>
                <p>Ngày 22/09/2024</p>
            </div>
            <div class="title">
                <div class="title-1">
                    <h3>Đang chờ khám</h3>
                </div>
                <div class="title-2">
                    <h3>Đã khám xong</h3>
                </div>
            </div>
            <div class="cards">
                <!-- Card Đang chờ -->

                <div class="card">

                    <div class="card-header">
                        <p><strong>09:30 - 10:30</strong></p>
                        <span class="badge waiting">Đang chờ</span>
                    </div>
                    <div class="info">
                        <img src="" alt="avatar">
                        <div class="info-details">
                            <p><strong>Nguyễn Văn A</strong></p>
                            <p>Số điện thoại: 0785771092</p>
                            <p>Giới tính: Nam &nbsp;&nbsp; Tuổi: 29</p>
                            <p>Mô tả: Bệnh nhân đăng ký khám tổng quát nhằm kiểm tra toàn diện về sức khỏe...</p>
                        </div>
                    </div>
                    <div class="actions">
                        <button class="btn-blue" onclick="window.location.href='phieukham.jsp'">Tạo phiếu khám</button>

                        <button class="btn-gray">⚙️</button>
                    </div>
                </div>

                <!-- Card Khám xong -->

                <div class="card">
                    <div class="card-header">
                        <p><strong>09:30 - 10:30</strong></p>
                        <span class="badge done">Khám xong</span>
                    </div>
                    <div class="info">
                        <img src="" alt="avatar">
                        <div class="info-details">
                            <p><strong>Nguyễn Văn A</strong></p>
                            <p>Số điện thoại: 0785771092</p>
                            <p>Giới tính: Nam &nbsp;&nbsp; Tuổi: 29</p>
                            <p>Mô tả: Bệnh nhân đăng ký khám tổng quát nhằm kiểm tra toàn diện về sức khỏe...</p>
                        </div>
                    </div>
                    <div class="actions">
                        <button class="btn-gray">Xem phiếu khám</button>
                        <button class="btn-green">Khám xong</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
