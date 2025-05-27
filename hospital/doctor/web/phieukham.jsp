<%-- 
    Document   : phieukham
    Created on : May 24, 2025, 2:59:29 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;

            }
            .container-1 {
                max-width: 1100px;
                margin: 15px auto;
                background: #f8f9fb;
                border-radius: 10px;
                padding: 20px;


            }
            .form, .section, .buttons, .summary {
                margin-bottom: 20px;
            }
            .form {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .back-btn {

                border: 1px solid #ccc;
                color: #333;
                padding: 8px 16px;
                font-size: 14px;
                border-radius: 7px;
                cursor: pointer;
                transition: background-color 0.2s ease;
                background-color: #f0f0f0;
            }
            .back-btn a{
                color: #555;
                text-decoration: none;
            }
            .back-btn:hover {
                background-color: #e0e0e0;
            }
            .profile {
                display: flex;
                gap:5px;
                align-items: center;
                padding-bottom: 60px;
            }
            .profile img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
            }
            .profile .middle,
            .profile .right {
                flex: 1;
            }

            .profile .edit-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
            }

           
            .form-group {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }
            .form-group input, textarea {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 6px;
                flex: 1;
                min-width: 220px;
            }
            textarea {
                width: 100%;
                height: 80px;
            }
            .buttons button {
                padding: 10px 16px;
                border: none;
                border-radius: 6px;
                margin-right: 10px;
                font-weight: bold;
                cursor: pointer;
            }
            .btn-blue {
                background-color: #2196f3;
                color: white;
            }
            .btn-green {
                background-color: #4caf50;
                color: white;
            }
            .summary {
                font-size: 14px;
            }

        </style>
    </head>
    <body>
        <div class="container-1">
            <div class="form">
                <h2>Tạo phiếu khám</h2>
                <button class="back-btn">
                    <a href="doctor_trongngay.jsp">← Quay lại</a>
                </button>
            </div>

            <div class="profile">
                <div class="left">
                    <img src="images/benhnhan.jpg" alt="Avatar">
                </div>
                <div class="middle">
                    <p><strong>Họ và tên:</strong> Nguyễn Văn Quốc Đạt</p>
                    <p><strong>Ngày sinh:</strong> 01/02/2004 - 20 tuổi</p>
                </div>
                <div class="right">
                    <p><strong>Địa chỉ:</strong> Nam Kỳ Khởi Nghĩa</p>
                    <p><strong>Giới tính:</strong> Nam</p>
                    <p><strong>Số điện thoại:</strong> 0356611341</p>
                    <button class="edit-btn">Chỉnh sửa</button>
                </div>
            </div>

            <div class="section">
                <p><strong>Mã phiếu khám:</strong> 123</p>
                <p><strong>Thời gian khám:</strong> 10:50 23/10/2024</p>
                <div class="form-group">
                    <input type="text" placeholder="* Tiền sử bệnh án">
                    <input type="text" placeholder="* Tổng trạng chung">
                    <input type="text" placeholder="* Chiều cao">
                    <input type="text" placeholder="* Cân nặng">
                    <input type="text" placeholder="Mạch">
                    <input type="text" placeholder="Nhiệt">
                    <input type="text" placeholder="Huyết áp">
                </div>
                <br>
                <textarea placeholder="Chuẩn đoán"></textarea>
            </div>

            <div class="buttons">
                <button class="btn-blue">Thêm dịch vụ khám</button>
                <button class="btn-green">Cập nhật kết quả</button>
                <button class="btn-blue">Tạo đơn thuốc</button>
            </div>

            <div class="summary">
                <p>Tổng số xét nghiệm: 6</p>
                <p>Tổng phí xét nghiệm: 840.000 đ</p>
                <p>Đã trừ chi phí khám: 200.000đ</p>
                <p><strong>Tổng cộng: 640.000 đ</strong></p>
            </div>
        </div>
    </body>
</html>
