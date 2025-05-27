<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật lịch</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .calendar-container {
            min-height: 100vh;
            padding-left: 282px;
            padding-top: 15px;
            margin-right: 10px;
            border-radius: 10px;
        }

        #menu-toggle:checked ~ .calendar-container {
            transform: translateX(-125px);
            transition: transform 0.3s ease;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 10px;
            padding: 0 20px;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            gap: 10px;
            padding: 20px;
        }

        .day-header {
            font-weight: bold;
            color: #0a2540;
        }

        .date {
            height: 50px;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 10px;
            background-color: #ffffff;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .date:hover {
            background-color: #e0f0ff;
        }

        .today {
            background-color: #5da8ef;
            color: white;
        }

        .highlight {
            background-color: #8ec9ff;
            color: white;
        }

        #timeSlotForm {
            display: none;
            margin: 20px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #f9f9f9;
        }

        #timeSlotForm h3 {
            margin-top: 0;
        }

        #timeSlotForm label {
            margin-right: 15px;
        }

        #timeSlotForm input {
            margin-left: 5px;
        }

        #timeSlotForm button {
            margin-top: 10px;
            margin-right: 10px;
        }

        #timeSlotsResult div {
            padding: 5px 10px;
            background-color: #e0f0ff;
            border-radius: 5px;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="calendar-container">
        <div class="calendar-header" id="calendarHeader">
            <!-- JS sẽ điền nội dung -->
        </div>

        <div class="calendar-grid" id="calendarDays">
            <!-- Header các thứ -->
            
            <div class="day-header">Hai</div>
            <div class="day-header">Ba</div>
            <div class="day-header">Tư</div>
            <div class="day-header">Năm</div>
            <div class="day-header">Sáu</div>
            <div class="day-header">Bảy</div>
            <div class="day-header">CN</div>
            <!-- JS sẽ điền các ngày -->
        </div>

        <!-- Form Thêm khung giờ -->
        <div id="timeSlotForm">
            <h3>Thêm khung giờ cho <span id="selectedDateLabel"></span></h3>
            <label>Bắt đầu: <input type="time" id="startTime"></label>
            <label>Kết thúc: <input type="time" id="endTime"></label>
            <label>Khoảng giữa (phút): <input type="number" id="interval" value="30" min="5"></label>
            <button onclick="generateTimeSlots()">Tạo</button>
            <button onclick="closeTimeForm()">Hủy</button>

            <div id="timeSlotsResult" style="margin-top:15px;"></div>
        </div>
    </div>

    <!-- Gọi file JS -->
    <script src="js/calendar_detail_1.js"></script>
</body>
</html>
