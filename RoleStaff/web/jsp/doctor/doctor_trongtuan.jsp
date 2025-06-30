<%-- Document : doctor_trongtuan Created on : May 24, 2025, 4:45:33 PM Author : ASUS --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Tuần</title>
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

        /* Calendar header */
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .calendar-header h2 {
            color: #3b82f6; /* Vibrant blue */
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* View toggle buttons */
        .view-buttons {
            display: flex;
            gap: 12px;
        }

        .view-buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background: #e5e7eb;
            color: #1f2937;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease, transform 0.1s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .view-buttons button.active {
            background: #3b82f6;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        .view-buttons button:hover {
            background: #d1d5db;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .view-buttons button a {
            color: inherit;
            text-decoration: none;
        }

        /* Calendar table */
        .calendar-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .calendar-table th, .calendar-table td {
            border: 1px solid #e2e8f0;
            padding: 12px;
            vertical-align: top;
            height: 80px; /* Fixed height for uniformity */
            text-align: center;
            font-size: 14px;
            position: relative;
        }

        .calendar-table th {
            background: #3b82f6;
            color: #ffffff;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .time-col {
            background: #f9fafb;
            width: 80px;
            font-weight: 600;
            color: #1f2937;
            text-align: right;
            padding-right: 16px;
        }

        .calendar-cell {
            background: #ffffff;
            transition: background 0.2s ease;
        }

        .calendar-cell:hover {
            background: #f3f4f6; /* Subtle hover effect */
        }

        /* Event styling */
        .event {
            background: #3b82f6;
            color: #ffffff;
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 500;
            display: block; /* Full-width for consistency */
            margin: 4px auto;
            text-align: left;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
            max-width: 90%; /* Prevent overflow */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .event:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        /* Empty state for no events */
        .empty-state {
            text-align: center;
            padding: 32px;
            color: #6b7280;
            font-size: 14px;
            background: #f9fafb;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            margin-top: 24px;
        }

        .empty-state i {
            font-size: 24px;
            margin-bottom: 8px;
            color: #9ca3af;
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
            .calendar-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .calendar-table th, .calendar-table td {
                font-size: 12px;
                height: 60px;
            }
            .time-col {
                width: 60px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .outer-frame {
                padding: 16px;
            }
            .calendar-table th, .calendar-table td {
                padding: 8px;
                height: 50px;
            }
            .event {
                font-size: 10px;
                padding: 4px 8px;
                margin: 2px auto;
            }
            .calendar-header h2 {
                font-size: 20px;
            }
            .view-buttons button {
                padding: 8px 16px;
                font-size: 12px;
            }
            .time-col {
                width: 50px;
                padding-right: 8px;
            }
        }

        @media (max-width: 576px) {
            .calendar-table th, .calendar-table td {
                font-size: 10px;
                padding: 6px;
                height: 40px;
            }
            .event {
                font-size: 9px;
                padding: 3px 6px;
            }
            .time-col {
                width: 40px;
            }
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="container">
            <!-- Outer frame wrapping all content -->
            <div class="outer-frame">
                <!-- Calendar Header -->
                <div class="calendar-header">
                    <h2><i class="fas fa-calendar-week"></i> 21 – 27 tháng 10, 2024</h2>
                    <div class="view-buttons">
                        <button><a href="doctor_lichtrongthang.jsp"><i class="fas fa-calendar"></i> Tháng</a></button>
                        <button class="active"><i class="fas fa-calendar-week"></i> Tuần</button>
                    </div>
                </div>

                <!-- Calendar Table -->
                <table class="calendar-table">
                    <thead>
                        <tr>
                            <th class="time-col"></th>
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
                                String hourLabel = hour < 10 ? "0" + hour + ":00" : hour + ":00";
                        %>
                        <tr>
                            <td class="time-col"><%= hourLabel %></td>
                            <% for (int day = 1; day <= 7; day++) { %>
                            <td class="calendar-cell">
                                <%
                                    // Demo event data (corrected for duplicates and consistency)
                                    if (hour == 8 && day == 2) { // Thứ Ba
                                %>
                                <div class="event">8:30 - 9:30</div>
                                <% } else if (hour == 9 && day == 3) { // Thứ Tư
                                %>
                                <div class="event">9:30 - 10:10</div>
                                <% } else if (hour == 10 && day == 3) { %>
                                <div class="event">10:50 - 11:30</div>
                                <% } else if (hour == 14 && day == 3) { %>
                                <div class="event">14:30 - 15:00</div>
                                <% } else if (hour == 15 && day == 3) { %>
                                <div class="event">15:30 - 16:00</div>
                                <% } else if (hour == 9 && day == 5) { // Thứ Sáu
                                %>
                                <div class="event">9:00 - 9:30</div>
                                <div class="event">9:30 - 10:00</div>
                                <% } else if (hour == 10 && day == 5) { %>
                                <div class="event">10:00 - 10:30</div>
                                <div class="event">10:30 - 11:00</div>
                                <% } %>
                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>