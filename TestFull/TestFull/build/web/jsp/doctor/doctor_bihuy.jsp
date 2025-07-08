<%-- 
    Document   : doctor_bihuy
    Created on : May 24, 2025, 4:03:11 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/includes/doctor_header.jsp" %>
<%@ include file="/includes/doctor_menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Các lượt khám bị huỷ</title>
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

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            h2 {
                color: #1e293b;
            }

            .search-input {
                padding: 8px 12px;
                border-radius: 8px;
                border: 1px solid #cbd5e1;
                width: 240px;
            }

            .cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
                gap: 16px;
            }

            .card {
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
                padding: 16px;
            }

            .time {
                font-weight: bold;
                color: #0f172a;
                margin-bottom: 12px;
            }

            .card-body {
                display: flex;
                gap: 16px;
            }

            .avatar {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                object-fit: cover;
            }

            .info {
                flex: 1;
                font-size: 14px;
                color: #334155;
            }

            .info .desc {
                margin-top: 8px;
                color: #64748b;
            }

            .actions {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                align-items: flex-end;
            }

            .status {
                background-color: #ef4444;
                color: white;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: bold;
            }

            .notify-btn {
                background-color: #3b82f6;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 13px;
                cursor: pointer;
            }

            .notify-btn:hover {
                background-color: #2563eb;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h2>Các lượt khám bị huỷ bỏ</h2>
                <input type="text" placeholder="Tìm lượt khám bị huỷ" class="search-input"/>
            </div>

            <div class="cards">
                
                <div class="card">
                    <div class="time">09:30 - 10:30 | 22/2/2024</div>
                    <div class="card-body">
                        <img src="" alt="avatar" class="avatar"/>
                        <div class="info">
                            <strong>Nguyễn Văn A</strong><br />
                            <span>Số điện thoại:</span> 0785771092<br />
                            <span>Giới tính:</span> Nam &nbsp; <span>Tuổi:</span> 29<br />
                            <p class="desc">Mô tả: Bệnh nhân đăng ký khám tổng quát nhằm kiểm tra toàn diện về sức khỏe, bao gồm các xét nghiệm và kiểm tra lâm s...</p>
                        </div>
                        <div class="actions">
                            <span class="status">Vắng mặt</span>
                            <form action="#" method="post">
                                <button type="submit" class="notify-btn">Gửi thông báo</button>
                            </form>
                        </div>
                    </div>
                </div>
               
            </div>
        </div>
    </body>
</html>

