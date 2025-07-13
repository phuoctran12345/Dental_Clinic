<%-- 
    Document   : doctor_capnhatlich
    Created on : May 24, 2025, 4:46:50 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="doctor_header.jsp" %>
<%@ include file="doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch làm việc trong tháng</title>
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
            
            #menu-toggle:checked ~.calendar-container {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            
            .calendar-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-weight: bold;
                font-size: 20px;
                margin-bottom: 20px;
                padding: 15px 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .calendar-header button {
                background: rgba(255,255,255,0.2);
                border: 1px solid rgba(255,255,255,0.3);
                color: white;
                font-size: 18px;
                cursor: pointer;
                padding: 8px 12px;
                border-radius: 5px;
                transition: all 0.2s;
                min-width: 40px;
            }

            .calendar-header button:hover {
                background: rgba(255,255,255,0.3);
                transform: translateY(-1px);
            }

            .calendar-header span {
                flex-grow: 1;
                text-align: center;
                font-size: 24px;
            }
            
            .view-buttons{
                text-align: right;
                padding-right: 25px;
                margin-bottom: 15px;
            }
            .view-buttons button {
                padding: 8px 16px;
                margin-left: 10px;
                border: none;
                background-color: #f8f9fa;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.2s;
                font-weight: 500;
            }
            .view-buttons button a{
                color: #495057;
                text-decoration: none;
            }
            .view-buttons button:hover {
                background-color: #e9ecef;
                transform: translateY(-1px);
            }
            .view-buttons button.active {
                background-color: #007bff;
                color: white;
            }
            .view-buttons button.active a {
                color: white;
            }
            
            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                text-align: center;
                gap: 12px;
                padding: 20px;
                background: #ffffff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .day-header {
                font-weight: bold;
                color: #495057;
                padding: 12px;
                background: #f8f9fa;
                border-radius: 8px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .date {
                height: 55px;
                display: flex;
                justify-content: center;
                align-items: center;
                border-radius: 8px;
                background-color: #ffffff;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s;
                border: 2px solid #e9ecef;
                font-size: 16px;
                position: relative;
            }

            .date:hover {
                background-color: #e3f2fd;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .today {
                background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%) !important;
                color: white !important;
                font-weight: bold;
                box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4) !important;
                border: 3px solid #4CAF50 !important;
                animation: pulseToday 2s ease-in-out infinite;
                position: relative;
                overflow: visible;
            }

            .today::before {
                
                position: absolute;
                top: -8px;
                right: -8px;
                font-size: 12px;
                background: #FF5722;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                animation: rotateIcon 3s linear infinite;
                box-shadow: 0 2px 8px rgba(255, 87, 34, 0.3);
            }

            

            /* Hiệu ứng hover đặc biệt cho ngày hiện tại */
            .today:hover {
                background: linear-gradient(135deg, #66BB6A 0%, #4CAF50 100%) !important;
                transform: scale(1.1) !important;
                box-shadow: 0 10px 30px rgba(76, 175, 80, 0.6) !important;
                animation: none;
            }

            .highlight {
                background-color: #ff9800 !important;
                color: white !important;
                font-weight: bold;
                box-shadow: 0 4px 12px rgba(255,152,0,0.4);
                border-color: #f57c00 !important;
            }
            .highlight:hover {
                
                transform: scale(1.1) !important;
                box-shadow: 0 10px 30px rgba(76, 175, 80, 0.6) !important;
                animation: none;
            }

            .highlight::after {
                content: "📅";
                position: absolute;
                top: 2px;
                right: 4px;
                font-size: 10px;
            }

            .empty-date {
                background: transparent;
                border: none;
                cursor: default;
            }

            .empty-date:hover {
                background: transparent;
                transform: none;
                box-shadow: none;
            }

            

           

            /* Responsive */
            @media (max-width: 768px) {
                .calendar-container {
                    padding-left: 20px;
                    padding-right: 20px;
                }
                
                .calendar-grid {
                    gap: 8px;
                    padding: 15px;
                }
                
                .date {
                    height: 40px;
                    font-size: 14px;
                }
                
                .calendar-header {
                    font-size: 18px;
                    padding: 10px 15px;
                }
            }

        </style>
    </head>
    <body>
        <div class="calendar-container">
            <!-- Input hidden chứa doctorId - Lấy từ session -->
            <input type="hidden" id="doctorId" value="${sessionScope.user != null ? sessionScope.user.user_id : 1}">
            
            <div class="calendar-header" id="calendarHeader">
                <button onclick="changeMonth(-1)" title="Tháng trước">&lt;</button>
                <span>Đang tải...</span>
                <button onclick="changeMonth(1)" title="Tháng sau">&gt;</button>
            </div>
            
            <div class="view-buttons">
                <button class="active">
                    <a href="/doctor/doctor-schedule?action=list">Tuần</a>
                </button>
                
            </div>

            <div class="calendar-grid" id="calendarDays">
                <!-- Header các thứ -->
                <div class="day-header">T2</div>
                <div class="day-header">T3</div>
                <div class="day-header">T4</div>
                <div class="day-header">T5</div>
                <div class="day-header">T6</div>
                <div class="day-header">T7</div>
                <div class="day-header">CN</div>
                
            </div>
        </div>

        <!-- Gọi file JS ngoài -->
        <script src="js/calendar_detail.js"></script>
        
        
        
    </body>
</html>
