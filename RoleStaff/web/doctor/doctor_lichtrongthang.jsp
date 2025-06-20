<%-- Document : doctor_capnhatlich Created on : May 24, 2025, 4:46:50 PM Author : ASUS --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ include file="/includes/doctor_header.jsp" %>
            <%@ include file="/includes/doctor_menu.jsp" %>
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
                            /*                background: #ffffff;*/
                            border-radius: 10px;


                        }

                        #menu-toggle:checked~.calendar-container {
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
                        }

                        .view-buttons {
                            text-align: right;
                            padding-right: 25px;
                        }

                        .view-buttons button {
                            padding: 6px 12px;
                            margin-left: 10px;
                            border: none;
                            background-color: #ddd;
                            border-radius: 4px;
                            cursor: pointer;
                        }

                        .view-buttons button a {
                            color: black;
                            text-decoration: none;
                        }

                        .view-buttons button.active {
                            background-color: #333;
                            color: white;
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
                    </style>
                </head>

                <body>
                    <div class="calendar-container">
                        <div class="calendar-header" id="calendarHeader">
                            <!-- JS sẽ điền nội dung -->
                        </div>
                        <div class="view-buttons">
                            <button>
                                <a href="doctor_trongtuan.jsp">Tuần</a>
                            </button>
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
                    </div>

                    <!-- Gọi file JS ngoài -->
                    <script src="js/calendar_detail.js"></script>
                </body>

                </html>