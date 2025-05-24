<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/includes/header.jsp" %>

<%@ include file="/includes/sidebars.jsp" %>



<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard Layout</title>
        <style>

            body {

                padding-top: 10px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f8f9fb;
                margin: 0;
                width: 100%;


            }

            .dashboard {
                padding-left: 270px;
                padding-top: 15px;
                display: grid;
                grid-template-columns: 1.5fr 1fr;
                grid-template-rows: repeat(3, 220px); /* Mỗi hàng cao 220px */
                gap: 20px;
                padding-right: 10px;
                padding-bottom: 50px;
                box-sizing: border-box;
                min-height: 100vh;

            }

            .dashboard > div {
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 0 10px #ddd;
                overflow: auto; /* Nếu nội dung dài thì cuộn */
            }

            .calendar {
                background: linear-gradient(90deg,rgba(33, 24, 217, 1) 0%, rgba(52, 52, 186, 1) 0%, rgba(0, 212, 255, 1) 100%);
                color: white;
            }

            .visit-count {
                font-size: 28px;
                font-weight: bold;
                text-align: center;
            }

            .user-info {
                background: #f0f8ff;
            }

            .calendar h2,
            .doctors-slider h3,
            .user-info h3,
            .recent-visits h3,
            .consultations h3 {
                margin-bottom: 10px;
            }

            .calendar p {
                font-size: 20px;
                line-height: 1.6;
            }
            #menu-toggle:checked ~.dashboard {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .dashboard {
                transition: transform 0.3s ease;
            }
        </style>
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>

        <div class="dashboard">

            <div class="calendar">
                <h2>Lịch khám sắp tới</h2>
                <p><strong>28</strong> Tháng 2 2024<br>07:30 AM</p>
            </div>

            <div class="visit-count">
                <p>Số lần bạn khám tại P-Clinic</p>
                <div>02</div>
            </div>

            <div class="doctors-slider">
                <h3>Bác sĩ đang trực tại phòng khám</h3>
                <p>[Slider ảnh bác sĩ]</p>
            </div>

            <div class="user-info">
                <h3>Namae Wa Nan Desu Ka</h3>
                <p>Giới tính: Nữ</p>
                <p>Ngày sinh: 02/05/2002</p>
                <p>Số điện thoại: 0752789222</p>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...</p>
            </div>

            <div class="recent-visits">
                <h3>Đã khám gần đây</h3>
                <p>Danh sách các lần khám gần nhất</p>
                <p>Khám nội tổng quát - 27/02/2024</p>
                <p>Khám tim mạch - 12/07/2023</p>
            </div>

            <div class="consultations">
                <h3>Đang chờ tư vấn</h3>
                <p>Thông tin tư vấn...</p>
            </div>

        </div>

    </body>
</html>
