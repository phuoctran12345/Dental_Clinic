<%-- 
    Document   : doctor_homepage
    Created on : May 18, 2025, 1:50:41 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<%@ page import="dao.DoctorDAO" %>
<%@ page import="model.Doctors" %>

<%
    session.setAttribute("user_id", 1);
    // Lấy userId từ session
    Integer userId = (Integer) session.getAttribute("user_id");
    Doctors doctor = null;
    if (userId != null) {
        doctor = DoctorDAO.getDoctorInfo(userId);
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>

            body {
                margin-left: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;
            }


            .dashboard {
                padding-left: 282px;
                padding-top: 15px;
                display: grid;
                grid-template-columns: 1.1fr 1fr 0.9fr;
                grid-template-rows: 310px 300px;
                gap: 10px;
                padding-right: 10px;
                padding-bottom: 50px;
                box-sizing: border-box;
                min-height: 100vh;

            }

            .dashboard > div {
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 0 10px #ddd;
                background-color: #fff;
            }

            /* Vị trí các khung */
            .calendar {
                grid-column:  1/ 2;
                grid-row: 1 / 2;
            }

            .visit-count {
                grid-column: 2 / 3;
                grid-row: 1 / 2;
            }

            .on-duty {
                grid-column: 3 / 4;
                grid-row: 1 / 2;
            }

            .user-info {
                grid-column: 1 / 2;
                grid-row: 2 / 3;
            }

            .consultations {
                grid-column: 2 / 3;
                grid-row: 2 / 3;
            }

            .recent-visits {
                grid-column: 3 / 4;
                grid-row: 2 / 3;
            }

            #menu-toggle:checked ~.dashboard {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .dashboard {
                transition: transform 0.3s ease;
            }


            /*----------------------------------------lich----------------------------------------*/





            .calendar-header {
                text-align: center;
                font-weight: bold;
                margin-top: -5px;
                font-size: 18px;
            }

            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 8px;
            }

            .day, .date {
                text-align: center;
                padding: 10px 0;
            }

            .day {
                font-weight: 600;
                color: #6b7280;
            }

            .date {
                background-color: #e5f0ff;
                border-radius: 8px;
                cursor: pointer;
            }

            .today {
                background-color: #2b72f9;
                color: white;
                font-weight: bold;
            }

            .calendar-wrapper {
                width: 330px;
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                padding: 20px;
            }

            .calendar-header {
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                margin-bottom: -5px;
            }

            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 1px;
            }

            .calendar-day {
                font-size: 14px;
                font-weight: 500;
                color: #94a3b8;
                text-align: center;
            }

            .calendar-date {
                height: 36px;
                border-radius: 8px;
                background-color: #e2ecfa;
                color: #1e293b;
                font-weight: 500;
                text-align: center;
                line-height: 36px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            .calendar-date.today {
                background-color: #2563eb;
                color: white;
            }

            .calendar-date:hover {
                background-color: #bfdbfe;
            }

            .calendar-empty {
                height: 36px;
            }

            .time-now {
                margin-top: 12px;
                text-align: center;
                font-size: 14px;
                color: #475569;
            }

            /*-----------------đang chờ khám-----------------------------------*/



            .visit-count {
                text-align: center;
                margin: 0 0 0px;
                font-size: 18px;
                color: #0f172a;
                font-weight: bold;
            }

            .patient {
                display: flex;
                align-items: center;
                margin-top: 10px;
                border-bottom: 1px solid #e2e8f0;
                padding-bottom: 12px;
            }

            .patient:last-child {
                border-bottom: none;
                margin-bottom: 8px;
                padding-bottom: 0;
            }

            .avatar {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 12px;
            }

            .info {
                flex-grow: 1;
            }

            .info .name {
                font-weight: 600;
                color: #1e293b;
            }

            .info .details {
                font-size: 13px;
                color: #64748b;
            }

            .status-btn {
                background-color: #2563eb;
                color: white;
                border: none;
                border-radius: 999px;
                padding: 6px 12px;
                font-size: 13px;
                font-weight: 500;
                cursor: default;
            }

            .view-all {
                display: block;
                text-align: center;
                color: #2563eb;
                font-size: 14px;
                font-weight: 500;
                margin-top: 10px;
                text-decoration: none;
            }

            .view-all:hover {
                text-decoration: underline;
            }
            
            
            
            
            /*trạng thái*/





            .status-card h4 {
                text-align: center;
                font-size: 18px;
                color: #0f172a;
                margin-bottom: 8px;
            }

            .status-card p {
                font-size: 13px;
                color: #64748b;
                margin-bottom: 30px;
            }

            .toggle-container {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
            }

            .toggle-switch {
                position: relative;
                width: 50px;
                height: 28px;
            }

            .toggle-switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: 0.4s;
                border-radius: 34px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: 0.4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #2563eb;
            }

            input:checked + .slider:before {
                transform: translateX(22px);
            }

            .status-label {
                font-weight: 600;
                color: #0f172a;
                font-size: 14px;
            }

            .note {
                font-size: 12px;
                color: #64748b;
                line-height: 1.5;
            }

            /*thong tin bac si*/

            

            .card-header {
                background: url('header-bg.png') no-repeat center/cover;
                padding: 16px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .doctor-avatar {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                border: 2px solid #fff;
                object-fit: cover;
            }

            .settings-btn {
                background-color: #e0f0ff;
                border: none;
                border-radius: 8px;
                padding: 8px 12px;
                font-size: 14px;
                cursor: pointer;
            }

            .card-body {
                padding: 16px;
            }

            .doctor-name {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .card-body p {
                font-size: 14px;
                margin: 6px 0;
                color: #333;
            }

            .card-body i {
                margin-right: 8px;
                color: #0066cc;
            }


            /*cho tu van*/





            .consultation-title {
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                color: #0f172a;
                margin-bottom: 16px;
            }

            .consultation-item {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
            }

            .consultation-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 12px;
            }

            .consultation-content {
                flex-grow: 1;
                overflow: hidden;
            }

            .consultation-name {
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 2px;
            }

            .consultation-message {
                font-size: 14px;
                color: #64748b;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }


            /*            lich su kham           */







            .booking-title {
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                color: #0f172a;
                margin-bottom: 16px;
            }

            .booking-item {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding-top: 25px;
                margin-bottom: 12px;
                border-bottom: 1px solid #f1f5f9;
            }

            .booking-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 12px;
            }

            .booking-info {
                flex-grow: 1;
                margin-left: 12px;
            }

            .booking-name {
                font-weight: 600;
                color: #1e293b;
            }

            .booking-time {
                font-size: 14px;
                color: #64748b;
            }

            .booking-slot {
                display: flex;
                align-items: center;
                gap: 8px;
                background-color: #2563eb;
                padding: 6px 12px;
                border-radius: 20px;
                color: white;
                font-size: 13px;
                white-space: nowrap;
            }

            .booking-status-icon {
                width: 20px;
                height: 20px;
            }

        </style>

    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <div class="dashboard">

            <!-----------lich------------->
            <div class="calendar-container">
                <div class="calendar-header" id="calendarHeader"></div>
                <div class="calendar-grid" id="calendarDays">
                    <!-- Ngày trong tuần -->
                    <div class="day">T2</div>
                    <div class="day">T3</div>
                    <div class="day">T4</div>
                    <div class="day">T5</div>
                    <div class="day">T6</div>
                    <div class="day">T7</div>
                    <div class="day">CN</div>

                </div>

            </div>
            <!--lượt khám-->


            <div class="waiting-card">
                <div class="visit-count">Đang chờ khám</div>

                <div class="patient">
                    <img src="" alt="Nguyễn Hòa An" class="avatar">
                    <div class="info">
                        <div class="name">Nguyễn Hòa An</div>
                        <div class="details">Nữ • 32 Tuổi</div>
                    </div>
                    <button class="status-btn">Đang chờ</button>
                </div>

                <div class="patient">
                    <img src="" alt="Nguyễn Hoàng Anh" class="avatar">
                    <div class="info">
                        <div class="name">Nguyễn Hoàng Anh</div>
                        <div class="details">Nữ • 32 Tuổi</div>
                    </div>
                    <button class="status-btn">Đang chờ</button>
                </div>

                <div class="patient">
                    <img src="" alt="Nguyễn Hoàng Anh" class="avatar">
                    <div class="info">
                        <div class="name">Nguyễn Hoàng Anh</div>
                        <div class="details">Nữ • 32 Tuổi</div>
                    </div>
                    <button class="status-btn">Đang chờ</button>
                </div>

                <a href="#" class="view-all">Xem tất cả</a>
            </div>


            <!--trang thái-->


            <div class="status-card">
                <h4>Cập nhật trạng thái</h4>
                <p>Cho người khác biết là bạn hiện đang có mặt tại phòng khám.</p>

                <div class="toggle-container">
                    <label class="toggle-switch">
                        <input type="checkbox" checked>
                        <span class="slider"></span>
                    </label>
                    <span class="status-label">Hiện đang trực</span>
                </div>

                <div class="note">
                    <strong>Lưu ý</strong><br>
                    Người sử dụng hệ thống sẽ dễ dàng đặt lịch khám hoặc yêu cầu tư vấn hơn khi có bác sĩ đang trực!
                </div>
            </div>


            <!--thong tin bac si-->



            <!-- Doctor Info Card -->
            <div class="doctor-card">
                <div class="card-header">
                    <img src="doctor.jpg" alt="Doctor Avatar" class="doctor-avatar">
                    <button class="settings-btn">Cài đặt ⚙️</button>
                </div>
                <div class="card-body">
                    <% if (doctor != null) { %>
                        <h2 class="doctor-name"><%= doctor.getFull_name() %></h2>
                        <p><i class="fa-solid fa-venus-mars"></i> Giới tính: <%= doctor.getGender() %></p>
                        <p><i class="fa-solid fa-user-doctor"></i> Chức vụ: Thạc Sĩ - Bác sĩ</p>
                        <p><i class="fa-solid fa-stethoscope"></i> Chuyên khoa: <%= doctor.getSpecialty() %></p>
                        <p><i class="fa-solid fa-phone"></i> Số điện thoại: <%= doctor.getPhone() %></p>
                    <% } else { %>
                        <h2 class="doctor-name">Không tìm thấy thông tin bác sĩ</h2>
                    <% } %>
                </div>
            </div>




            <!--chờ tư vấn-->





            <div class="consultations">
                <h4 class="consultation-title">Yêu cầu tư vấn</h4>

                <div class="consultation-item">
                    <img src="" alt="Nguyễn Mai Phương" class="consultation-avatar">
                    <div class="consultation-content">
                        <div class="consultation-name">Nguyễn Mai Phương</div>
                        <div class="consultation-message">Hiện tại em đang muốn khám tổng quát, bác sĩ có thể...</div>
                    </div>
                </div>

                <div class="consultation-item">
                    <img src="" alt="Nguyễn Mai Phương" class="consultation-avatar">
                    <div class="consultation-content">
                        <div class="consultation-name">Nguyễn Mai Phương</div>
                        <div class="consultation-message">Hiện tại em đang muốn khám tổng quát, bác sĩ có thể...</div>
                    </div>
                </div>


                <div class="consultation-item">
                    <img src="" alt="Lê Đại Hoàng" class="consultation-avatar">
                    <div class="consultation-content">
                        <div class="consultation-name">Lê Đại Hoàng</div>
                        <div class="consultation-message">Tư vấn giúp em về tình hình sức khỏe hiện tại của em...</div>
                    </div>
                </div>
            </div>

            <!--lich su kham-->




            <div class="recent-bookings">
                <h4 class="booking-title">Lịch đã được đặt gần đây</h4>

                <div class="booking-item">
                    <img src="images/avatar3.jpg" alt="Nguyễn Quang Quý" class="booking-avatar">
                    <div class="booking-info">
                        <div class="booking-name">Nguyễn Quang Quý</div>
                        <div class="booking-time"></div>
                    </div>
                    <div class="booking-slot">
                        <span class="booking-time-slot">08:30 - 9:30 | T4 • 02/11/2024</span>
                        <img src="images/icon-check.png" alt="icon" class="booking-status-icon">
                    </div>
                </div>

                <div class="booking-item">
                    <img src="images/avatar3.jpg" alt="Nguyễn Quang Quý" class="booking-avatar">
                    <div class="booking-info">
                        <div class="booking-name">Nguyễn Quang Quý</div>
                        <div class="booking-time"></div>
                    </div>
                    <div class="booking-slot">
                        <span class="booking-time-slot">08:30 - 9:30 | T4 • 02/11/2024</span>
                        <img src="images/icon-check.png" alt="icon" class="booking-status-icon">
                    </div>
                </div>
            </div>
        </div>



    </body>
</html>
<script src="js/calendar.js"></script>
