<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lịch trình hệ thống</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }

        .container {
            margin-left: 250px;
            padding: 20px;
        }

        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .header h1 {
            color: #333;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
        }

        .filters {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-row {
            display: flex;
            gap: 20px;
            align-items: center;
            margin-bottom: 15px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }

        .filter-group select, .filter-group input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            background-color: #007bff;
            color: white;
        }

        .btn:hover {
            opacity: 0.8;
        }

        .schedule-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .schedule-tabs {
            display: flex;
            border-bottom: 1px solid #eee;
        }

        .tab {
            padding: 15px 20px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.3s;
        }

        .tab.active {
            border-bottom-color: #007bff;
            color: #007bff;
            font-weight: 600;
        }

        .tab:hover {
            background-color: #f8f9fa;
        }

        .tab-content {
            display: none;
            padding: 20px;
        }

        .tab-content.active {
            display: block;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-booked {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-waiting {
            background-color: #cce5ff;
            color: #004085;
        }

        .status-pending {
            background-color: #ffeaa7;
            color: #6c5ce7;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .calendar-view {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background-color: #ddd;
        }

        .calendar-day {
            background: white;
            padding: 10px;
            min-height: 100px;
        }

        .calendar-day.today {
            background-color: #e3f2fd;
        }

        .calendar-day.other-month {
            background-color: #f8f9fa;
            color: #999;
        }

        .day-number {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .appointment-item {
            font-size: 11px;
            padding: 2px 4px;
            margin: 1px 0;
            border-radius: 3px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }

        .appointment-item:hover {
            opacity: 0.8;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-number {
            font-size: 1.5em;
            font-weight: bold;
            color: #007bff;
        }

        .stat-label {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="manager_menu.jsp" />
    
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-calendar-alt"></i> Quản lý lịch trình hệ thống</h1>
            <p>Xem toàn bộ lịch trình của bệnh viện bao gồm lịch hẹn, lịch bác sĩ và lịch nhân viên</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalAppointments}</div>
                <div class="stat-label">Tổng lịch hẹn</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${todayAppointments}</div>
                <div class="stat-label">Lịch hẹn hôm nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${pendingSchedules}</div>
                <div class="stat-label">Lịch chờ duyệt</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${activeDoctors}</div>
                <div class="stat-label">Bác sĩ hoạt động</div>
            </div>
        </div>

        <div class="filters">
            <div class="filter-row">
                <div class="filter-group">
                    <label>Loại lịch trình:</label>
                    <select id="scheduleType" onchange="filterSchedule()">
                        <option value="all">Tất cả</option>
                        <option value="appointments">Lịch hẹn</option>
                        <option value="doctor">Lịch bác sĩ</option>
                        <option value="staff">Lịch nhân viên</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Từ ngày:</label>
                    <input type="date" id="startDate" onchange="filterSchedule()">
                </div>
                <div class="filter-group">
                    <label>Đến ngày:</label>
                    <input type="date" id="endDate" onchange="filterSchedule()">
                </div>
                <div class="filter-group">
                    <label>Trạng thái:</label>
                    <select id="status" onchange="filterSchedule()">
                        <option value="all">Tất cả</option>
                        <option value="BOOKED">Đã đặt</option>
                        <option value="COMPLETED">Hoàn thành</option>
                        <option value="CANCELLED">Đã hủy</option>
                        <option value="WAITING_PAYMENT">Chờ thanh toán</option>
                        <option value="pending">Chờ duyệt</option>
                        <option value="approved">Đã duyệt</option>
                        <option value="rejected">Từ chối</option>
                    </select>
                </div>
                <button class="btn" onclick="resetFilters()">
                    <i class="fas fa-refresh"></i> Làm mới
                </button>
            </div>
        </div>

        <div class="schedule-container">
            <div class="schedule-tabs">
                <div class="tab active" onclick="showTab('list')">Danh sách</div>
                <div class="tab" onclick="showTab('calendar')">Lịch</div>
            </div>

            <div id="list-tab" class="tab-content active">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Loại</th>
                            <th>Người liên quan</th>
                            <th>Ngày</th>
                            <th>Giờ</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Lịch hẹn -->
                        <c:forEach var="appointment" items="${appointmentList}">
                            <tr>
                                <td>${appointment.appointmentId}</td>
                                <td><i class="fas fa-calendar-check"></i> Lịch hẹn</td>
                                <td>
                                    <strong>Bệnh nhân:</strong> ${appointment.patientName}<br>
                                    <strong>Bác sĩ:</strong> ${appointment.doctorName}
                                </td>
                                <td>${appointment.workDate}</td>
                                <td>${appointment.timeSlot}</td>
                                <td>
                                    <span class="status-badge status-${appointment.status.toLowerCase()}">
                                        ${appointment.status}
                                    </span>
                                </td>
                                <td>${appointment.reason}</td>
                            </tr>
                        </c:forEach>

                        <!-- Lịch bác sĩ -->
                        <c:forEach var="doctorSchedule" items="${doctorScheduleList}">
                            <tr>
                                <td>${doctorSchedule.scheduleId}</td>
                                <td><i class="fas fa-user-md"></i> Lịch bác sĩ</td>
                                <td>
                                    <strong>Bác sĩ:</strong> ${doctorSchedule.doctorName}
                                </td>
                                <td>${doctorSchedule.workDate}</td>
                                <td>${doctorSchedule.timeSlot}</td>
                                <td>
                                    <span class="status-badge status-${doctorSchedule.status}">
                                        ${doctorSchedule.status}
                                    </span>
                                </td>
                                <td>Lịch làm việc bác sĩ</td>
                            </tr>
                        </c:forEach>

                        <!-- Lịch nhân viên -->
                        <c:forEach var="staffSchedule" items="${staffScheduleList}">
                            <tr>
                                <td>${staffSchedule.scheduleId}</td>
                                <td><i class="fas fa-user-tie"></i> Lịch nhân viên</td>
                                <td>
                                    <strong>Nhân viên:</strong> ${staffSchedule.staffName}
                                </td>
                                <td>${staffSchedule.workDate}</td>
                                <td>${staffSchedule.timeSlot}</td>
                                <td>
                                    <span class="status-badge status-${staffSchedule.status}">
                                        ${staffSchedule.status}
                                    </span>
                                </td>
                                <td>Lịch làm việc nhân viên</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div id="calendar-tab" class="tab-content">
                <div class="calendar-view" id="calendarView">
                    <!-- Calendar sẽ được tạo bằng JavaScript -->
                </div>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabName) {
            // Ẩn tất cả tab content
            var tabContents = document.getElementsByClassName('tab-content');
            for (var i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove('active');
            }

            // Bỏ active tất cả tab
            var tabs = document.getElementsByClassName('tab');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }

            // Hiển thị tab được chọn
            document.getElementById(tabName + '-tab').classList.add('active');
            event.target.classList.add('active');

            if (tabName === 'calendar') {
                generateCalendar();
            }
        }

        function filterSchedule() {
            var type = document.getElementById('scheduleType').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;
            var status = document.getElementById('status').value;

            // Gửi request AJAX để lọc dữ liệu
            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'ManagerScheduleServlet?type=' + type + '&startDate=' + startDate + '&endDate=' + endDate + '&status=' + status, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // Cập nhật bảng với dữ liệu mới
                    document.getElementById('list-tab').innerHTML = xhr.responseText;
                }
            };
            xhr.send();
        }

        function resetFilters() {
            document.getElementById('scheduleType').value = 'all';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('status').value = 'all';
            filterSchedule();
        }

        function generateCalendar() {
            var calendarView = document.getElementById('calendarView');
            var currentDate = new Date();
            var year = currentDate.getFullYear();
            var month = currentDate.getMonth();

            // Tạo lịch cho tháng hiện tại
            var firstDay = new Date(year, month, 1);
            var lastDay = new Date(year, month + 1, 0);
            var startDate = new Date(firstDay);
            startDate.setDate(startDate.getDate() - firstDay.getDay());

            calendarView.innerHTML = '';

            // Tạo header cho các ngày trong tuần
            var daysOfWeek = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
            for (var i = 0; i < 7; i++) {
                var dayHeader = document.createElement('div');
                dayHeader.className = 'calendar-day';
                dayHeader.style.backgroundColor = '#f8f9fa';
                dayHeader.style.fontWeight = 'bold';
                dayHeader.textContent = daysOfWeek[i];
                calendarView.appendChild(dayHeader);
            }

            // Tạo các ngày trong tháng
            for (var i = 0; i < 42; i++) {
                var dayDiv = document.createElement('div');
                dayDiv.className = 'calendar-day';
                
                var currentDay = new Date(startDate);
                currentDay.setDate(startDate.getDate() + i);
                
                var dayNumber = document.createElement('div');
                dayNumber.className = 'day-number';
                dayNumber.textContent = currentDay.getDate();
                dayDiv.appendChild(dayNumber);

                // Đánh dấu ngày hiện tại
                if (currentDay.toDateString() === new Date().toDateString()) {
                    dayDiv.classList.add('today');
                }

                // Đánh dấu ngày không thuộc tháng hiện tại
                if (currentDay.getMonth() !== month) {
                    dayDiv.classList.add('other-month');
                }

                // Thêm các lịch hẹn cho ngày này
                addAppointmentsToDay(dayDiv, currentDay);

                calendarView.appendChild(dayDiv);
            }
        }

        function addAppointmentsToDay(dayDiv, date) {
            // Lấy các lịch hẹn cho ngày này từ dữ liệu
            var appointments = getAppointmentsForDate(date);
            
            appointments.forEach(function(appointment) {
                var appointmentDiv = document.createElement('div');
                appointmentDiv.className = 'appointment-item';
                appointmentDiv.textContent = appointment.title;
                appointmentDiv.title = appointment.description;
                dayDiv.appendChild(appointmentDiv);
            });
        }

        function getAppointmentsForDate(date) {
            // Hàm này sẽ lấy dữ liệu từ server
            // Tạm thời trả về mảng rỗng
            return [];
        }

        // Khởi tạo trang
        document.addEventListener('DOMContentLoaded', function() {
            // Set ngày hiện tại cho filter
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').value = today;
            document.getElementById('endDate').value = today;
        });
    </script>
</body>
</html> 