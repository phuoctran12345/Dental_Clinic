<%-- 
    Document   : doctor_trongtuan
    Created on : May 24, 2025, 4:45:33 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>

<!DOCTYPE html>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch Tuần</title>


        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;

            }
            .calendar-container {

                max-width: 90%;
                margin: 0 auto;
                background: #ffffff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 20px;
               
            }





            .calendar-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
               
            }

            .calendar-header h2 {
                margin: 0;
            }



            .calendar-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .view-buttons{
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
            .view-buttons button a{
                color: white;
                text-decoration:none;
            }

            .view-buttons button.active {
                background-color: #333;
                color: white;
            }

            .calendar-table th,
            .calendar-table td {
                border: 1px solid #ddd;
                padding: 10px;
                vertical-align: top;
                height: 60px;
                position: relative;
            }

            .time-col {
                background-color: #f0f0f0;
                width: 80px;
                text-align: center;
                font-weight: bold;
            }

            .calendar-cell {
                background-color: white;
            }

            .event {
                background-color: #3b82f6;
                color: white;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 14px;
                display: inline-block;
                margin: 2px 0;
            }

        </style>
    </head>
    <body>
        <div class="calendar-container">
            <div class="calendar-header">
                <h2>21 – 27 tháng 10, 2024</h2>
                <div class="view-buttons">
                    <button class="active">
                        <a href="doctor_lichtrongthang.jsp">Tháng</a>
                    </button>

                </div>
            </div>
            <table class="calendar-table">
                <thead>
                    <tr>
                        <th></th>
                        <th>Thứ Hai</th>
                        <th>Thứ Ba</th>
                        <th>Thứ Tư</th>
                        <th>Thứ Năm</th>
                        <th>Thứ Sáu</th>
                        <th>Thứ Bảy</th>
                        <th>Chủ Nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int hour = 5; hour <= 16; hour++) {
                            String hourLabel = hour < 10 ? "0" + hour + " giờ" : hour + " giờ";
                    %>
                    <tr>
                        <td class="time-col"><%= hourLabel %></td>
                        <% for (int day = 1; day <= 7; day++) { %>
                        <td class="calendar-cell">
                            <%
                                // Ví dụ demo lịch hẹn
                                if (hour == 8 && day == 2) { // Thứ Ba 8:30 - 9:30
                            %>
                            <div class="event">8:30 - 9:30</div>
                            <% } else if (hour == 9 && day == 3) { %>
                            <div class="event">9:30 - 10:10</div>
                            <% } else if (hour == 10 && day == 3) { %>
                            <div class="event">10:50 - 11:30</div>
                            <% } else if (hour == 14 && day == 3) { %>
                            <div class="event">14:30 - 15:00</div>
                            <% } else if (hour == 15 && day == 3) { %>
                            <div class="event">15:30 - 16:00</div>
                            <% } else if (hour == 9 && day == 5) { %>
                            <div class="event">9:00 - 9:30</div>
                            <% } else if (hour == 9 && day == 5) { %>
                            <div class="event">9:30 - 10:00</div>
                            <% } else if (hour == 10 && day == 5) { %>
                            <div class="event">10:00 - 10:30</div>
                            <% } else if (hour == 10 && day == 5) { %>
                            <div class="event">10:30 - 11:00</div>
                            <% } %>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </body>
    <script src="js/calendar.js"></script>
</html>
