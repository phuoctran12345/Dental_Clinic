<%-- Document : doctor_lichtrongthang Created on : May 24, 2025, 4:46:50 PM Author : ASUS --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc - Bác Sĩ</title>
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
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12); /* Prominent shadow */
            border: 1px solid #e2e8f0;
            padding: 32px;
            margin-bottom: 32px;
        }

        /* Header section */
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            background: #f9fafb;
            border-radius: 5px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .header-section h2 {
            color: #3b82f6; /* Vibrant blue */
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-section p {
            color: #6b7280;
            font-size: 14px;
            margin: 4px 0 0;
        }

        /* Stats card */
        .stats-card {
            background: #ffffff;
            border-radius: 5px;
            padding: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            text-align: center;
            min-width: 120px;
        }

        .stats-number {
            font-size: 28px;
            font-weight: 700;
            color: #3b82f6;
            margin-bottom: 4px;
        }

        .stats-label {
            color: #9ca3af;
            font-size: 13px;
            font-weight: 500;
        }

        /* View toggle buttons */
        .view-toggle {
            text-align: center;
            margin-bottom: 24px;
        }

        .btn-view {
            background: #f3f4f6;
            border: 2px solid #3b82f6;
            color: #3b82f6;
            padding: 10px 24px;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s ease;
            margin: 0 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-view:hover, .btn-view.active {
            background: #3b82f6;
            color: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        /* Calendar card */
        .calendar-card {
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            overflow: hidden;
            margin-bottom: 32px;
        }

        /* Calendar header */
        .calendar-header {
            background: #3b82f6;
            color: #ffffff;
            padding: 20px;
            text-align: center;
            font-size: 18px;
            font-weight: 600;
            border-radius: 5px 5px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .calendar-header i {
            cursor: pointer;
            font-size: 18px;
            padding: 8px;
            transition: background 0.2s ease;
        }

        .calendar-header i:hover {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
        }

        /* Calendar grid */
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e2e8f0;
        }

        /* Day header */
        .day-header {
            background: #3b82f6;
            color: #ffffff;
            padding: 12px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            min-height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-right: 1px solid rgba(255, 255, 255, 0.3);
        }

        .day-header:last-child {
            border-right: none;
        }

        /* Calendar day */
        .calendar-day {
            background: #ffffff;
            min-height: 100px; /* Increased for balance */
            padding: 8px;
            border-right: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            transition: background 0.2s ease;
        }

        .calendar-day:nth-child(7n) {
            border-right: none;
        }

        .day-number {
            font-weight: 400;
            color: #1f2937;
            font-size: 18px;
            text-align: left;
            margin-bottom: 8px;
        }

        /* Highlight for today */
        .today {
            background: #e0f2fe;
            border: 2px solid #3b82f6;
        }

        .today .day-number {
            color: #3b82f6;
            font-weight: 700;
        }

        /* Highlight for scheduled days */
        .has-schedule {
            background: #ecfdf5;
        }

        /* Schedule badge */
        .schedule-badge {
            font-size: 12px;
            padding: 6px 8px;
            border-radius: 5px;
            margin: 2px 0;
            font-weight: 500;
            text-align: center;
            background: #dbeafe;
            color: #1e40af;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: transform 0.2s ease;
        }

        .schedule-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        /* Approved schedules section */
        .approved-schedule-section {
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .section-header {
            background: #3b82f6;
            color: #ffffff;
            padding: 16px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 5px 5px 0 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Table styling */
        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f9fafb;
            padding: 12px 16px;
            text-align: left;
            font-size: 14px;
            font-weight: 600;
            color: #4a5568;
            border-bottom: 1px solid #e2e8f0;
        }

        .table td {
            padding: 12px 16px;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
            font-size: 14px;
            color: #1f2937;
        }

        .table tr:last-child td {
            border-bottom: none;
        }

        /* Shift badge */
        .badge-shift {
            font-size: 13px;
            padding: 6px 12px;
            border-radius: 5px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-morning { background: #fefcbf; color: #b45309; }
        .badge-afternoon { background: #bfdbfe; color: #1e40af; }
        .badge-fullday { background: #d1fae5; color: #047857; }

        /* Approved status badge */
        .status-approved {
            background: #10b981;
            color: #ffffff;
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        /* Empty state */
        .text-center {
            text-align: center;
            padding: 40px;
            background: #f9fafb;
            border-radius: 5px;
            margin-top: 16px;
        }

        .text-muted {
            color: #9ca3af;
            font-size: 14px;
        }

        /* Primary button */
        .btn-primary {
            background: #3b82f6;
            color: #ffffff;
            border: none;
            padding: 12px 24px;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background: #2563eb;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
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
            .header-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .calendar-day {
                min-height: 80px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .outer-frame {
                padding: 16px;
            }
            .calendar-day {
                min-height: 60px;
                padding: 6px;
            }
            .day-header {
                min-height: 40px;
                font-size: 12px;
                padding: 8px;
            }
            .day-number {
                font-size: 12px;
            }
            .schedule-badge {
                font-size: 10px;
                padding: 4px 6px;
            }
            .header-section h2 {
                font-size: 20px;
            }
            .stats-number {
                font-size: 24px;
            }
        }

        @media (max-width: 576px) {
            .calendar-grid {
                grid-template-columns: repeat(7, 1fr);
            }
            .calendar-day {
                min-height: 50px;
                padding: 4px;
            }
            .day-header {
                min-height: 32px;
                font-size: 10px;
            }
            .day-number {
                font-size: 11px;
            }
            .table th, .table td {
                font-size: 12px;
                padding: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="container">
            <!-- Outer frame wrapping all content -->
            <div class="outer-frame">
                <!-- Header Section -->
                <div class="header-section">
                    <div>
                        <h2><i class="fas fa-calendar-alt"></i> Lịch Làm Việc</h2>
                        <p>Quản lý và xem lịch làm việc đã được xác nhận</p>
                    </div>
                    <div class="stats-card">
                        <div class="stats-number">${approvedSchedules.size()}</div>
                        <div class="stats-label">Lịch đã xác nhận</div>
                    </div>
                </div>

                <!-- View Toggle -->
                <div class="view-toggle">
                    <button class="btn-view active" onclick="setActiveButton(this)">
                        <i class="fas fa-calendar"></i> Tháng
                    </button>
                    <button class="btn-view" onclick="redirectToWeekView(this)">
                        <i class="fas fa-calendar-week"></i> Tuần
                    </button>
                </div>

                <!-- Calendar Section -->
                <div class="calendar-card">
                    <div class="calendar-header">
                        <i class="fas fa-chevron-left" onclick="changeMonth(-1)"></i>
                        <span id="monthYear"></span>
                        <i class="fas fa-chevron-right" onclick="changeMonth(1)"></i>
                    </div>
                    <div class="calendar-grid" id="calendar"></div>
                </div>

                <!-- Approved Schedules Section -->
                <div class="approved-schedule-section">
                    <h3 class="section-header">
                        <i class="fas fa-check-circle"></i> Lịch Đã Được Xác Nhận
                    </h3>
                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${not empty approvedSchedules}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-calendar-day"></i> Ngày</th>
                                            <th><i class="fas fa-clock"></i> Ca Làm Việc</th>
                                            <th><i class="fas fa-info-circle"></i> Trạng Thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${approvedSchedules}" var="schedule">
                                            <tr>
                                                <td>
                                                    <strong>${schedule.workDate}</strong>
                                                    <br>
                                                    <small class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${schedule.workDate.day == 1}">Thứ 2</c:when>
                                                            <c:when test="${schedule.workDate.day == 2}">Thứ 3</c:when>
                                                            <c:when test="${schedule.workDate.day == 3}">Thứ 4</c:when>
                                                            <c:when test="${schedule.workDate.day == 4}">Thứ 5</c:when>
                                                            <c:when test="${schedule.workDate.day == 5}">Thứ 6</c:when>
                                                            <c:when test="${schedule.workDate.day == 6}">Thứ 7</c:when>
                                                            <c:when test="${schedule.workDate.day == 0}">Chủ nhật</c:when>
                                                        </c:choose>
                                                    </small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${schedule.slotId == 1}">
                                                            <span class="badge badge-morning badge-shift">
                                                                <i class="fas fa-sun"></i> Sáng (8h-12h)
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${schedule.slotId == 2}">
                                                            <span class="badge badge-afternoon badge-shift">
                                                                <i class="fas fa-cloud-sun"></i> Chiều (13h-17h)
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${schedule.slotId == 3}">
                                                            <span class="badge badge-fullday badge-shift">
                                                                <i class="fas fa-clock"></i> Cả ngày (8h-17h)
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Khác</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-approved">
                                                        <i class="fas fa-check"></i> Đã xác nhận
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center">
                                    <i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 16px;"></i>
                                    <h5 class="text-muted">Chưa có lịch làm việc nào được xác nhận</h5>
                                    <p class="text-muted">Hãy đăng ký lịch làm việc để hiển thị tại đây</p>
                                    <a href="${pageContext.request.contextPath}/DoctorScheduleServlet" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Đăng ký lịch
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for Calendar Functionality -->
    <script>
        let currentDate = new Date();
        let approvedSchedules = [];

        // Load approved schedules from server
        <c:if test="${not empty approvedSchedules}">
            approvedSchedules = [
                <c:forEach items="${approvedSchedules}" var="schedule" varStatus="status">
                    {
                        workDate: '${schedule.workDate}',
                        slotId: ${schedule.slotId},
                        slotName: '<c:choose><c:when test="${schedule.slotId == 1}">Sáng</c:when><c:when test="${schedule.slotId == 2}">Chiều</c:when><c:when test="${schedule.slotId == 3}">Cả ngày</c:when></c:choose>'
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
        </c:if>

        function setActiveButton(button) {
            document.querySelectorAll('.btn-view').forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
        }

        function redirectToWeekView(button) {
            window.location.href = "${pageContext.request.contextPath}/jsp/doctor/doctor_trongtuan.jsp";
            setActiveButton(button);
        }

        function getCurrentWeekDates(baseDate) {
            let weekDates = [];
            let dayOfWeek = (baseDate.getDay() + 6) % 7;
            let mondayDate = baseDate.getDate() - dayOfWeek;
            for (let i = 0; i < 7; i++) {
                let d = new Date(baseDate.getFullYear(), baseDate.getMonth(), mondayDate + i);
                weekDates.push(d);
            }
            return weekDates;
        }

        function getSchedulesForDate(dateString) {
            return approvedSchedules.filter(schedule => {
                let scheduleDate = new Date(schedule.workDate);
                let targetDate = new Date(dateString);
                return scheduleDate.getTime() === targetDate.getTime();
            });
        }

        function generateScheduleBadges(schedules) {
            if (!schedules || schedules.length === 0) return '';
            let badgesHTML = '';
            schedules.forEach(schedule => {
                let badgeClass = '';
                let icon = '';
                switch (schedule.slotId) {
                    case 1:
                        badgeClass = 'badge-morning';
                        icon = 'fas fa-sun';
                        break;
                    case 2:
                        badgeClass = 'badge-afternoon';
                        icon = 'fas fa-cloud-sun';
                        break;
                    case 3:
                        badgeClass = 'badge-fullday';
                        icon = 'fas fa-clock';
                        break;
                }
                badgesHTML += '<div class="schedule-badge ' + badgeClass + '">';
                badgesHTML += '<i class="' + icon + '"></i> ' + schedule.slotName;
                badgesHTML += '</div>';
            });
            return badgesHTML;
        }

        function generateCalendar() {
            const calendar = document.getElementById('calendar');
            const monthYear = document.getElementById('monthYear');
            if (!calendar || !monthYear) return;

            const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                                'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
            monthYear.innerHTML = monthNames[currentDate.getMonth()] + ' ' + currentDate.getFullYear();

            const today = new Date();
            const weekDates = getCurrentWeekDates(today);
            const dayShorts = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

            let headerHTML = '';
            for (let i = 0; i < 7; i++) {
                const d = weekDates[i];
                let dayNum = d.getDate();
                headerHTML += '<div class="day-header"><span class="day-text">' + dayShorts[i] + '</span></div>';
            }

            let calendarDaysHTML = '';
            const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
            const lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
            const startDay = (firstDay.getDay() + 6) % 7;

            for (let i = 0; i < startDay; i++) {
                calendarDaysHTML += '<div class="calendar-day"></div>';
            }

            for (let day = 1; day <= lastDay.getDate(); day++) {
                let dayClasses = 'calendar-day';
                let currentDateForDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), day);
                let dateString = currentDateForDay.getFullYear() + '-' +
                                 String(currentDateForDay.getMonth() + 1).padStart(2, '0') + '-' +
                                 String(day).padStart(2, '0');

                let schedulesForDay = getSchedulesForDate(dateString);
                if (today.getFullYear() === currentDate.getFullYear() &&
                    today.getMonth() === currentDate.getMonth() &&
                    today.getDate() === day) {
                    dayClasses += ' today';
                }
                if (schedulesForDay.length > 0) {
                    dayClasses += ' has-schedule';
                }

                calendarDaysHTML += '<div class="' + dayClasses + '">';
                calendarDaysHTML += '<div class="day-number">' + day + '</div>';
                if (schedulesForDay.length > 0) {
                    calendarDaysHTML += generateScheduleBadges(schedulesForDay);
                }
                calendarDaysHTML += '</div>';
            }

            calendar.innerHTML = headerHTML + calendarDaysHTML;
        }

        function changeMonth(direction) {
            currentDate.setMonth(currentDate.getMonth() + direction);
            generateCalendar();
        }

        document.addEventListener('DOMContentLoaded', generateCalendar);
    </script>
</body>
</html>