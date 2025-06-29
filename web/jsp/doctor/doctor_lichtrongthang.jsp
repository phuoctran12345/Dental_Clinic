<%-- Document : doctor_lichtrongthang Created on : May 24, 2025, 4:46:50 PM Author : ASUS --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/includes/doctor_header.jsp" %>
<%@ include file="/includes/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Lịch Làm Việc - Bác Sĩ</title>

                        <!-- Bootstrap CSS -->
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <!-- Font Awesome -->
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                        <!-- Custom CSS -->
        <style>
            body {
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                background-color: #f8f9fa;
            }

            .calendar-container {
                min-height: 100vh;
                padding-left: 282px;
                                padding-top: 20px;
                                padding-right: 20px;
                                transition: all 0.3s ease;
                            }

                            #menu-toggle:checked~.calendar-container {
                                padding-left: 40px;
                                transition: all 0.3s ease;
            }

                            .header-section {
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                padding: 2rem;
                                border-radius: 15px;
                                margin-bottom: 2rem;
                                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                            }

                            .calendar-card {
                                background: white;
                                border-radius: 15px;
                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                                overflow: hidden;
                                margin-bottom: 2rem;
            }

                            .calendar-header {
                                background: linear-gradient(45deg, #4facfe, #00f2fe);
                color: white;
                                padding: 1.5rem;
                                text-align: center;
            }

            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                                gap: 1px;
                                background-color: #e9ecef;
            }

            .day-header {
                                background: #6c757d !important;
                                color: white !important;
                                padding: 1rem 0.5rem;
                                text-align: center;
                                font-weight: 600;
                                font-size: 0.9rem;
                display: flex;
                                flex-direction: column;
                                gap: 4px;
                justify-content: center;
                align-items: center;
                                min-height: 50px;
                                border: 1px solid #495057;
                            }

                            .day-text {
                                color: white !important;
                                font-size: 1rem !important;
                                font-weight: 700 !important;
                                display: block !important;
                                line-height: 1.2;
                                text-shadow: none !important;
                                opacity: 1 !important;
                                visibility: visible !important;
                                background: none !important;
                                border: none !important;
                                margin: 0 !important;
                                padding: 0 !important;
                            }

                            .day-name {
                                font-size: 0.85rem;
                                opacity: 0.9;
                            }

                            .day-short {
                                font-size: 1.1rem;
                                font-weight: 700;
                            }

                            .calendar-day {
                                background: white;
                                min-height: 100px;
                                padding: 8px;
                                position: relative;
                cursor: pointer;
                                transition: all 0.3s ease;
                                border: 1px solid #dee2e6;
                                display: flex;
                                flex-direction: column;
            }

                            .calendar-day:hover {
                                background-color: #f8f9fa;
                                transform: translateY(-2px);
                                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                            }

                            .day-number {
                                font-weight: 600;
                                margin-bottom: 5px;
                                color: #495057;
                                font-size: 1.1rem;
                            }

                            .day-date {
                                font-size: 0.75rem;
                                color: #6c757d;
                                margin-bottom: 8px;
            }

            .today {
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                            }

                            .today .day-number {
                                color: white;
                            }

                            .has-schedule {
                                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                color: white;
            }

                            .has-schedule .day-number,
                            .has-schedule .schedule-badge {
                color: white;
            }

                            .schedule-badge {
                                background: rgba(255, 255, 255, 0.9);
                                color: #495057;
                                font-size: 0.7rem;
                                padding: 3px 6px;
                                border-radius: 10px;
                                margin: 2px 0;
                                display: block;
                                text-align: center;
                                font-weight: 600;
                                border: 1px solid rgba(0, 0, 0, 0.1);
                                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                            }

                            .has-schedule .schedule-badge {
                                background: rgba(255, 255, 255, 0.95);
                                color: #2c3e50;
                                font-weight: 700;
                            }

                            .schedule-badge.badge-morning {
                                background: linear-gradient(45deg, #ffecd2, #fcb69f);
                                color: #8b4513;
                                border-color: #fcb69f;
                            }

                            .schedule-badge.badge-afternoon {
                                background: linear-gradient(45deg, #a8edea, #fed6e3);
                                color: #2c5aa0;
                                border-color: #a8edea;
                            }

                            .schedule-badge.badge-fullday {
                                background: linear-gradient(45deg, #d299c2, #fef9d7);
                                color: #6a4c93;
                                border-color: #d299c2;
                            }

                            .approved-schedule-section {
                                background: white;
                                border-radius: 15px;
                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                                overflow: hidden;
                            }

                            .section-header {
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                padding: 1.5rem;
                                margin: 0;
                            }

                            .table-responsive {
                                max-height: 400px;
                            }

                            .table th {
                                background: #f8f9fa;
                                border-top: none;
                                font-weight: 600;
                                color: #495057;
                            }

                            .badge-shift {
                                font-size: 0.85rem;
                                padding: 0.5rem 1rem;
                            }

                            .badge-morning {
                                background: linear-gradient(45deg, #ffecd2, #fcb69f);
                                color: #8b4513;
                            }

                            .badge-afternoon {
                                background: linear-gradient(45deg, #a8edea, #fed6e3);
                                color: #2c5aa0;
                            }

                            .badge-fullday {
                                background: linear-gradient(45deg, #d299c2, #fef9d7);
                                color: #6a4c93;
                            }

                            .status-approved {
                                background: linear-gradient(45deg, #56ab2f, #a8e6cf);
                                color: white;
                                padding: 0.5rem 1rem;
                                border-radius: 20px;
                                font-size: 0.85rem;
                            }

                            .stats-card {
                                background: white;
                                border-radius: 15px;
                                padding: 1.5rem;
                                margin-bottom: 1rem;
                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                                text-align: center;
                            }

                            .stats-number {
                                font-size: 2rem;
                                font-weight: 700;
                                color: #667eea;
                            }

                            .stats-label {
                                color: #6c757d;
                                font-size: 0.9rem;
                                margin-top: 0.5rem;
                            }

                            .view-toggle {
                                margin-bottom: 2rem;
                            }

                            .btn-view {
                                background: white;
                                border: 2px solid #667eea;
                                color: #667eea;
                                padding: 0.75rem 1.5rem;
                                border-radius: 25px;
                                font-weight: 600;
                                transition: all 0.3s ease;
                            }

                            .btn-view:hover,
                            .btn-view.active {
                                background: #667eea;
                                color: white;
                                transform: translateY(-2px);
                                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
                            }

                            @media (max-width: 768px) {
                                .calendar-container {
                                    padding-left: 20px;
                                    padding-right: 10px;
                                }

                                .calendar-grid {
                                    grid-template-columns: repeat(7, 1fr);
                                    gap: 1px;
                                }

                                .calendar-day {
                                    min-height: 60px;
                                    padding: 4px;
                                }

                                .day-header {
                                    padding: 0.5rem 0.2rem;
                                }

                                .day-name {
                                    display: none;
                                }

                                .day-short {
                                    font-size: 0.9rem;
                                }

                                .day-number {
                                    font-size: 0.9rem;
                                }

                                .day-date {
                                    font-size: 0.65rem;
                                }

                                .schedule-badge {
                                    font-size: 0.6rem;
                                    padding: 1px 4px;
                                }
                            }

                            .calendar-day.has-schedule:hover {
                                background-color: #e8f5e8;
                                transform: translateY(-3px);
                                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
                                cursor: pointer;
                            }

                            .calendar-day.has-schedule .day-number {
                                color: #2c5aa0;
                                font-weight: 700;
                            }

                            .schedule-badge i {
                                font-size: 0.6rem;
                            }

                            /* Tooltip cho ngày có lịch */
                            .calendar-day.has-schedule {
                                position: relative;
                            }

                            .calendar-day.has-schedule::after {
                                content: 'Có lịch làm việc';
                                position: absolute;
                                bottom: -30px;
                                left: 50%;
                                transform: translateX(-50%);
                                background: #333;
                                color: white;
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.7rem;
                                white-space: nowrap;
                                opacity: 0;
                                visibility: hidden;
                                transition: all 0.3s ease;
                                z-index: 1000;
                            }

                            .calendar-day.has-schedule:hover::after {
                                opacity: 1;
                                visibility: visible;
                                bottom: -25px;
                            }
        </style>
    </head>

    <body>
        <div class="calendar-container">
                            <!-- Header Section -->
                            <div class="header-section">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h2><i class="fas fa-calendar-alt me-3"></i>Lịch Làm Việc</h2>
                                        <p class="mb-0">Quản lý và xem lịch làm việc đã được xác nhận</p>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="stats-card">
                                            <div class="stats-number">${approvedSchedules.size()}</div>
                                            <div class="stats-label">Lịch đã xác nhận</div>
                                        </div>
                                    </div>
                                </div>
            </div>

                            <!-- View Toggle -->
                            <div class="view-toggle text-center">
                                <button class="btn btn-view active me-2">
                                    <i class="fas fa-calendar me-2"></i>Tháng
                                </button>
                                <button class="btn btn-view">
                                    <i class="fas fa-calendar-week me-2"></i>Tuần
                </button>
            </div>

                            <!-- Calendar Section -->
                            <div class="calendar-card">
                                <div class="calendar-header">
                                    <h4 id="calendarTitle" class="mb-0">
                                        <i class="fas fa-chevron-left me-3" style="cursor: pointer;"
                                            onclick="changeMonth(-1)"></i>
                                        <span id="monthYear"></span>
                                        <i class="fas fa-chevron-right ms-3" style="cursor: pointer;"
                                            onclick="changeMonth(1)"></i>
                                    </h4>
                                </div>

                                <div class="calendar-grid" id="calendar">
                                    <!-- Header sẽ được render động bằng JS -->
                                </div>
                            </div>

                            <!-- Approved Schedules Section -->
                            <div class="approved-schedule-section">
                                <h3 class="section-header">
                                    <i class="fas fa-check-circle me-2"></i>Lịch Đã Được Xác Nhận
                                </h3>

                                <div class="table-responsive">
                                    <c:choose>
                                        <c:when test="${not empty approvedSchedules}">
                                            <table class="table table-hover mb-0">
                                                <thead>
                                                    <tr>
                                                        <th><i class="fas fa-calendar-day me-2"></i>Ngày</th>
                                                        <th><i class="fas fa-clock me-2"></i>Ca Làm Việc</th>
                                                        <th><i class="fas fa-info-circle me-2"></i>Trạng Thái</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${approvedSchedules}" var="schedule">
                                                        <tr>
                                                            <td>
                                                                <strong>${schedule.workDate}</strong>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <c:set var="dayOfWeek" value="" />
                                                                    <c:choose>
                                                                        <c:when test="${schedule.workDate.day == 1}">Thứ
                                                                            2
                                                                        </c:when>
                                                                        <c:when test="${schedule.workDate.day == 2}">Thứ
                                                                            3
                                                                        </c:when>
                                                                        <c:when test="${schedule.workDate.day == 3}">Thứ
                                                                            4
                                                                        </c:when>
                                                                        <c:when test="${schedule.workDate.day == 4}">Thứ
                                                                            5
                                                                        </c:when>
                                                                        <c:when test="${schedule.workDate.day == 5}">Thứ
                                                                            6
                                                                        </c:when>
                                                                        <c:when test="${schedule.workDate.day == 6}">Thứ
                                                                            7
                                                                        </c:when>
                                                                        <c:when test="${schedule.workDate.day == 0}">Chủ
                                                                            nhật</c:when>
                                                                    </c:choose>
                                                                </small>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${schedule.slotId == 1}">
                                                                        <span class="badge badge-morning badge-shift">
                                                                            <i class="fas fa-sun me-1"></i>Sáng (8h-12h)
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${schedule.slotId == 2}">
                                                                        <span class="badge badge-afternoon badge-shift">
                                                                            <i class="fas fa-cloud-sun me-1"></i>Chiều
                                                                            (13h-17h)
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${schedule.slotId == 3}">
                                                                        <span class="badge badge-fullday badge-shift">
                                                                            <i class="fas fa-clock me-1"></i>Cả ngày
                                                                            (8h-17h)
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">Khác</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <span class="status-approved">
                                                                    <i class="fas fa-check me-1"></i>Đã xác nhận
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                                <h5 class="text-muted">Chưa có lịch làm việc nào được xác nhận</h5>
                                                <p class="text-muted">Hãy đăng ký lịch làm việc để hiển thị tại đây</p>
                                                <a href="${pageContext.request.contextPath}/DoctorScheduleServlet"
                                                    class="btn btn-primary">
                                                    <i class="fas fa-plus me-2"></i>Đăng ký lịch
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
            </div>
        </div>

                        <!-- Bootstrap JS -->
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                        <!-- Custom Calendar JavaScript -->
                        <script>
                            let currentDate = new Date();
                            let approvedSchedules = [];

                            // Lấy dữ liệu lịch đã xác nhận từ server
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

                            console.log('Approved schedules loaded:', approvedSchedules);

                            function getCurrentWeekDates(baseDate) {
                                let weekDates = [];
                                let dayOfWeek = (baseDate.getDay() + 6) % 7; // 0=Monday, 1=Tuesday, ..., 6=Sunday
                                let mondayDate = baseDate.getDate() - dayOfWeek;

                                for (let i = 0; i < 7; i++) {
                                    let d = new Date(baseDate.getFullYear(), baseDate.getMonth(), mondayDate + i);
                                    weekDates.push(d);
                                }
                                return weekDates;
                            }

                            function getSchedulesForDate(dateString) {
                                return approvedSchedules.filter(schedule => {
                                    // Chuyển đổi date format để so sánh
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
                                    badgesHTML += '<i class="' + icon + ' me-1"></i>' + schedule.slotName;
                                    badgesHTML += '</div>';
                                });

                                return badgesHTML;
                            }

                            function generateCalendar() {
                                console.log('Generating calendar...');

                                const calendar = document.getElementById('calendar');
                                const monthYear = document.getElementById('monthYear');

                                if (!calendar) {
                                    console.error('Calendar element not found!');
                                    return;
                                }

                                if (!monthYear) {
                                    console.error('MonthYear element not found!');
                                    return;
                                }

                                // Set month/year display
                                const monthNames = [
                                    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                                    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
                                ];
                                monthYear.innerHTML = monthNames[currentDate.getMonth()] + ' ' + currentDate.getFullYear();

                                // Lấy tuần hiện tại
                                const today = new Date();
                                const weekDates = getCurrentWeekDates(today);
                                const dayShorts = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

                                // Tạo HTML cho header với format "T2,ngày"
                                let headerHTML = '';
                                for (let i = 0; i < 7; i++) {
                                    const d = weekDates[i];
                                    let dayNum = d.getDate();
                                    headerHTML += '<div class="day-header"><span class="day-text">' + dayShorts[i] + ',' + dayNum + '</span></div>';
                                }

                                // Tạo HTML cho các ngày trong tháng
                                let calendarDaysHTML = '';
                                const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
                                const lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
                                const startDay = (firstDay.getDay() + 6) % 7;

                                // Empty days before month starts
                                for (let i = 0; i < startDay; i++) {
                                    calendarDaysHTML += '<div class="calendar-day"></div>';
                                }

                                // Days of the month
                                for (let day = 1; day <= lastDay.getDate(); day++) {
                                    let dayClasses = 'calendar-day';
                                    let currentDateForDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), day);
                                    let dateString = currentDateForDay.getFullYear() + '-' +
                                        String(currentDateForDay.getMonth() + 1).padStart(2, '0') + '-' +
                                        String(day).padStart(2, '0');

                                    // Kiểm tra có lịch làm việc không
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

                                    // Thêm badges cho các ca làm việc
                                    if (schedulesForDay.length > 0) {
                                        calendarDaysHTML += generateScheduleBadges(schedulesForDay);
                                    }

                                    calendarDaysHTML += '</div>';
                                }

                                // Set toàn bộ HTML
                                calendar.innerHTML = headerHTML + calendarDaysHTML;

                                console.log('Calendar HTML set successfully!');
                                console.log('Headers in calendar:', calendar.querySelectorAll('.day-header').length);
                                console.log('Days with schedules:', calendar.querySelectorAll('.has-schedule').length);

                                // Test hiển thị text
                                const headers = calendar.querySelectorAll('.day-text');
                                console.log('Day-text elements found:', headers.length);
                                if (headers.length > 0) {
                                    console.log('First header text:', headers[0].textContent);
                                }
                            }

                            function changeMonth(direction) {
                                currentDate.setMonth(currentDate.getMonth() + direction);
                                generateCalendar();
                            }

                            // Đảm bảo DOM đã load xong
                            if (document.readyState === 'loading') {
                                document.addEventListener('DOMContentLoaded', function () {
                                    console.log('DOM loaded via addEventListener');
                                    generateCalendar();
                                });
                            } else {
                                // DOM đã sẵn sàng
                                console.log('DOM already ready');
                                generateCalendar();
                            }
                        </script>
    </body>

</html>