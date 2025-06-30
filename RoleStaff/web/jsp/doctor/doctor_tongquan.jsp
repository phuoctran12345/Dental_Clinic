<%-- Document : doctor_tongquan Created on : [Insert Date], Author : [Your Name] --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<%@ page import="dao.DoctorDAO" %>
<%@ page import="model.Doctors" %>

<%
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan bác sĩ</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        /* General body styling */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7fc;
            overflow-x: hidden;
        }

        /* Content wrapper to handle menu toggle */
        .content-wrapper {
            width: 100%;
        }

        /* Main container with padding to avoid menu overlap */
        .container {
            padding: 80px 20px 20px 280px; /* Space for fixed menu */
            min-height: 100vh;
            max-width: 1400px; /* Consistent with other pages */
            margin: 0 auto;
            transition: padding 0.3s ease;
        }

        /* Outer frame for all content */
        .outer-frame {
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            border: 1px solid #e2e8f0;
            padding: 32px;
            margin-bottom: 32px;
        }

        /* Dashboard grid */
        .dashboard {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            grid-template-rows: auto auto;
            gap: 24px;
        }

        /* Card styling */
        .card {
            background: #f9fafb;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            padding: 24px;
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-4px);
        }

        /* Card header */
        .card-header {
            background: #3b82f6;
            color: #ffffff;
            padding: 16px;
            border-radius: 5px 5px 0 0;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: -24px -24px 16px -24px; /* Extend to card edges */
        }

        /* Calendar card */
        .calendar-card {
            grid-column: 1 / 2;
            grid-row: 1 / 2;
        }

        .calendar-header {
            text-align: center;
            font-size: 16px;
            font-weight: 600;
            color: #3b82f6;
            margin-bottom: 12px;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
        }

        .day {
            text-align: center;
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            padding: 8px;
        }

        .date {
            text-align: center;
            padding: 10px;
            border-radius: 5px;
            background: #e0f2fe;
            font-size: 13px;
            color: #1f2937;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
        }

        .date:hover {
            background: #3b82f6;
            color: #ffffff;
        }

        .today {
            background: #3b82f6;
            color: #ffffff;
            font-weight: 600;
        }

        .calendar-empty {
            min-height: 36px;
        }

        .time-now {
            text-align: center;
            font-size: 13px;
            color: #6b7280;
            margin-top: 12px;
        }

        /* Waiting card */
        .waiting-card {
            grid-column: 2 / 3;
            grid-row: 1 / 2;
        }

        .visit-count {
            font-size: 18px;
            font-weight: 600;
            color: #3b82f6;
            text-align: center;
            margin-bottom: 16px;
        }

        .patient {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .patient:last-child {
            border-bottom: none;
        }

        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e0f2fe;
            margin-right: 12px;
        }

        .info .name {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
        }

        .info .details {
            font-size: 12px;
            color: #6b7280;
        }

        .status-btn {
            background: #3b82f6;
            color: #ffffff;
            border: none;
            border-radius: 20px;
            padding: 6px 12px;
            font-size: 12px;
            font-weight: 500;
            cursor: default;
        }

        .view-all {
            display: block;
            text-align: center;
            color: #3b82f6;
            font-size: 13px;
            text-decoration: none;
            margin-top: 12px;
            transition: color 0.2s;
        }

        .view-all:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        /* Status card */
        .status-card {
            grid-column: 3 / 4;
            grid-row: 1 / 2;
        }

        .status-title {
            font-size: 18px;
            font-weight: 600;
            color: #3b82f6;
            text-align: center;
            margin-bottom: 12px;
        }

        .status-text {
            font-size: 13px;
            color: #6b7280;
            text-align: center;
            margin-bottom: 16px;
        }

        .toggle-container {
            display: flex;
            align-items: center;
            gap: 12px;
            justify-content: center;
            margin-bottom: 16px;
        }

        .toggle-switch {
            position: relative;
            width: 48px;
            height: 24px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: #d1d5db;
            border-radius: 24px;
            transition: background 0.3s;
        }

        .slider:before {
            content: "";
            position: absolute;
            width: 18px;
            height: 18px;
            background: #ffffff;
            border-radius: 50%;
            left: 3px;
            bottom: 3px;
            transition: transform 0.3s;
        }

        input:checked + .slider {
            background: #3b82f6;
        }

        input:checked + .slider:before {
            transform: translateX(24px);
        }

        .status-label {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
        }

        .note {
            font-size: 12px;
            color: #6b7280;
            text-align: center;
            line-height: 1.5;
        }

        /* Doctor info card */
        .doctor-card {
            grid-column: 1 / 2;
            grid-row: 2 / 3;
        }

        .doctor-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: -24px -24px 16px -24px;
        }

        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: 2px solid #ffffff;
            background: #e0f2fe;
        }

        .settings-btn {
            background: #ffffff;
            color: #3b82f6;
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
        }

        .settings-btn:hover {
            background: #f3f4f6;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .doctor-name {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 12px;
        }

        .doctor-info p {
            font-size: 14px;
            color: #1f2937;
            margin: 8px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .doctor-info i {
            color: #3b82f6;
            font-size: 16px;
        }

        /* Consultations card */
        .consultations {
            grid-column: 2 / 3;
            grid-row: 2 / 3;
        }

        .consultation-title {
            font-size: 18px;
            font-weight: 600;
            color: #3b82f6;
            text-align: center;
            margin-bottom: 16px;
        }

        .consultation-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .consultation-item:last-child {
            border-bottom: none;
        }

        .consultation-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #e0f2fe;
            margin-right: 12px;
        }

        .consultation-content {
            flex-grow: 1;
        }

        .consultation-name {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
        }

        .consultation-message {
            font-size: 12px;
            color: #6b7280;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* Recent bookings card */
        .recent-bookings {
            grid-column: 3 / 4;
            grid-row: 2 / 3;
        }

        .booking-title {
            font-size: 18px;
            font-weight: 600;
            color: #3b82f6;
            text-align: center;
            margin-bottom: 16px;
        }

        .booking-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .booking-item:last-child {
            border-bottom: none;
        }

        .booking-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #e0f2fe;
            margin-right: 12px;
        }

        .booking-info {
            flex-grow: 1;
        }

        .booking-name {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
        }

        .booking-time {
            font-size: 12px;
            color: #6b7280;
        }

        .booking-slot {
            background: #3b82f6;
            color: #ffffff;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .booking-status-icon {
            width: 16px;
            height: 16px;
        }

        /* Responsive adjustments */
        @media (max-width: 1200px) {
            .container {
                padding-left: 250px;
            }
        }

        @media (max-width: 992px) {
            .container {
                padding-left: 20px;
                padding-right: 20px;
            }
            .dashboard {
                grid-template-columns: repeat(2, 1fr);
                grid-template-rows: auto;
            }
            .calendar-card { grid-column: 1 / 2; grid-row: 1 / 2; }
            .waiting-card { grid-column: 2 / 3; grid-row: 1 / 2; }
            .status-card { grid-column: 1 / 2; grid-row: 2 / 3; }
            .doctor-card { grid-column: 2 / 3; grid-row: 2 / 3; }
            .consultations { grid-column: 1 / 2; grid-row: 3 / 4; }
            .recent-bookings { grid-column: 2 / 3; grid-row: 3 / 4; }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .outer-frame {
                padding: 16px;
            }
            .dashboard {
                grid-template-columns: 1fr;
            }
            .calendar-card, .waiting-card, .status-card, .doctor-card, .consultations, .recent-bookings {
                grid-column: 1 / 2;
            }
            .calendar-card { grid-row: 1 / 2; }
            .waiting-card { grid-row: 2 / 3; }
            .status-card { grid-row: 3 / 4; }
            .doctor-card { grid-row: 4 / 5; }
            .consultations { grid-row: 5 / 6; }
            .recent-bookings { grid-row: 6 / 7; }
            .card {
                padding: 16px;
            }
        }

        @media (max-width: 576px) {
            .outer-frame {
                padding: 12px;
            }
            .card {
                padding: 12px;
            }
            .calendar-grid {
                gap: 2px;
            }
            .date, .day {
                font-size: 11px;
                padding: 6px;
            }
            .patient, .consultation-item, .booking-item {
                font-size: 12px;
            }
            .status-btn, .booking-slot {
                font-size: 11px;
                padding: 5px 10px;
            }
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="container">
            <!-- Outer frame wrapping all content -->
            <div class="outer-frame">
                <div class="dashboard">
                    <!-- Calendar Card -->
                    <div class="card calendar-card">
                        <div class="calendar-header" id="calendarHeader">Lịch tuần này</div>
                        <div class="calendar-grid" id="calendarDays">
                            <div class="day">T2</div>
                            <div class="day">T3</div>
                            <div class="day">T4</div>
                            <div class="day">T5</div>
                            <div class="day">T6</div>
                            <div class="day">T7</div>
                            <div class="day">CN</div>
                            <!-- Dates populated by JavaScript -->
                        </div>
                        <div class="time-now" id="currentTime"></div>
                    </div>

                    <!-- Waiting Card -->
                    <div class="card waiting-card">
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

                    <!-- Status Card -->
                    <div class="card status-card">
                        <div class="status-title">Cập nhật trạng thái</div>
                        <p class="status-text">Cho người khác biết bạn hiện đang có mặt tại phòng khám.</p>
                        <div class="toggle-container">
                            <label class="toggle-switch">
                                <input type="checkbox" checked>
                                <span class="slider"></span>
                            </label>
                            <span class="status-label">Hiện đang trực</span>
                        </div>
                        <div class="note">
                            <strong>Lưu ý:</strong> Người dùng hệ thống sẽ dễ dàng đặt lịch khám hoặc yêu cầu tư vấn hơn khi có bác sĩ đang trực!
                        </div>
                    </div>

                    <!-- Doctor Info Card -->
                    <div class="card doctor-card">
                        <div class="card-header">
                            <img src="doctor.jpg" alt="Doctor Avatar" class="doctor-avatar">
                            <button class="settings-btn"><i class="fas fa-cog"></i> Cài đặt</button>
                        </div>
                        <div class="doctor-info">
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

                    <!-- Consultations Card -->
                    <div class="card consultations">
                        <div class="consultation-title">Yêu cầu tư vấn</div>
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

                    <!-- Recent Bookings Card -->
                    <div class="card recent-bookings">
                        <div class="booking-title">Lịch đã được đặt gần đây</div>
                        <div class="booking-item">
                            <img src="images/avatar3.jpg" alt="Nguyễn Quang Quý" class="booking-avatar">
                            <div class="booking-info">
                                <div class="booking-name">Nguyễn Quang Quý</div>
                                <div class="booking-time">08:30 - 9:30 | T4 • 02/11/2024</div>
                            </div>
                            <div class="booking-slot">
                                <span class="booking-time-slot">Đã xác nhận</span>
                                <img src="images/icon-check.png" alt="icon" class="booking-status-icon">
                            </div>
                        </div>
                        <div class="booking-item">
                            <img src="images/avatar3.jpg" alt="Nguyễn Quang Quý" class="booking-avatar">
                            <div class="booking-info">
                                <div class="booking-name">Nguyễn Quang Quý</div>
                                <div class="booking-time">08:30 - 9:30 | T4 • 02/11/2024</div>
                            </div>
                            <div class="booking-slot">
                                <span class="booking-time-slot">Đã xác nhận</span>
                                <img src="images/icon-check.png" alt="icon" class="booking-status-icon">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for Calendar -->
    <script>
        // Simple calendar rendering
        const calendarDays = document.getElementById('calendarDays');
        const calendarHeader = document.getElementById('calendarHeader');
        const currentTime = document.getElementById('currentTime');

        function renderCalendar() {
            const today = new Date();
            const startOfWeek = new Date(today);
            startOfWeek.setDate(today.getDate() - today.getDay() + 1); // Monday
            const days = [];

            for (let i = 0; i < 7; i++) {
                const day = new Date(startOfWeek);
                day.setDate(startOfWeek.getDate() + i);
                const dateNum = day.getDate();
                const isToday = day.toDateString() === today.toDateString();
                days.push(`<div class="date ${isToday ? 'today' : ''}">${dateNum}</div>`);
            }

            calendarDays.innerHTML = `
                <div class="day">T2</div>
                <div class="day">T3</div>
                <div class="day">T4</div>
                <div class="day">T5</div>
                <div class="day">T6</div>
                <div class="day">T7</div>
                <div class="day">CN</div>
                ${days.join('')}
            `;

            const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                                'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
            calendarHeader.textContent = `${monthNames[today.getMonth()]} ${today.getFullYear()}`;

            currentTime.textContent = `Hôm nay: ${today.toLocaleDateString('vi-VN')} ${today.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}`;
        }

        document.addEventListener('DOMContentLoaded', renderCalendar);
    </script>
</body>
</html>