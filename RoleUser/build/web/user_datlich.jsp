<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/includes/header.jsp" %>

<%@ include file="/includes/sidebars.jsp" %>







<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đặt lịch khám</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                background: linear-gradient(to right, #e0f7fa, #f1f5f9);
                height: 100vh;
                width: 100vw;
            }

            .scheduler {
                width: 100vw;
                height: 100vh;
                box-sizing: border-box;
                padding: 40px;
                background-color: #f8f9fb;
                border-radius: 0; /* bỏ bo góc nếu muốn full */
                box-shadow: none;
                padding-left: 300px;
            }


            .scheduler:hover {
                transform: scale(1.01);
            }

            .scheduler h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #00796b;
                font-size: 24px;
            }

            .calendar {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 10px;
                margin-bottom: 25px;
            }

            .day {
                padding: 12px;
                background-color: #e0f2f1;
                text-align: center;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                color: #00796b;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                transition: all 0.2s ease-in-out;
            }

            .day:hover {
                background-color: #26a69a;
                color: white;
                transform: scale(1.05);
            }

            .day.selected {
                background-color: #00796b;
                color: white;
            }

            .time-picker {
                display: none;
                flex-wrap: wrap;
                gap: 10px;
                margin-bottom: 20px;
                justify-content: center;
            }

            .time-slot {
                padding: 10px 18px;
                background-color: #f0f0f0;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                color: #444;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                transition: all 0.2s ease-in-out;
            }

            .time-slot:hover {
                background-color: #4caf50;
                color: white;
                transform: scale(1.05);
            }

            .time-slot.selected {
                background-color: #388e3c;
                color: white;
            }

            button {
                width: 100%;
                padding: 14px;
                background-color: #00796b;
                color: white;
                font-weight: bold;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-size: 16px;
                display: none;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                transition: background-color 0.3s ease;
            }

            button:hover {
                background-color: #00695c;
            }
            .time{
                display:none;

            }

        </style>
    </head>
    <body>

        <div class="scheduler">
            <h2><i class="fa-solid fa-calendar-plus"></i> Đặt lịch khám</h2>

            <!-- Chọn ngày -->
            <div class="calendar" id="calendar"></div>

            <!-- Chọn giờ -->
            <div class="centered">
                <h2 class="time" id="time-available">Đặt giờ khám</h2>
            </div>
            <div class="time-picker" id="timePicker">
                <div class="time-slot">08:00</div>
                <div class="time-slot">09:00</div>
                <div class="time-slot">10:00</div>
                <div class="time-slot">11:00</div>
                <div class="time-slot">14:00</div>
                <div class="time-slot">15:00</div>
                <div class="time-slot">16:00</div>
            </div>

            <button id="confirmBtn">Xác nhận đặt lịch</button>
        </div>

        <script>
            // Render lịch 30 ngày tới
            const calendar = document.getElementById("calendar");
            const today = new Date();
            for (let i = 0; i < 30; i++) {
                const date = new Date(today);
                date.setDate(today.getDate() + i);
                const day = document.createElement("div");
                day.className = "day";
                day.textContent = date.getDate() + '/' + (date.getMonth() + 1);
                day.dataset.date = date.toISOString().split('T')[0]; // format YYYY-MM-DD
                calendar.appendChild(day);
            }

            let selectedDay = null;
            let selectedTime = null;


            const timeAvailable = document.getElementById("time-available");
            const timePicker = document.getElementById("timePicker");
            const timeSlots = timePicker.querySelectorAll(".time-slot");
            const confirmBtn = document.getElementById("confirmBtn");

            calendar.addEventListener("click", function (e) {
                if (e.target.classList.contains("day")) {
                    calendar.querySelectorAll(".day").forEach(d => d.classList.remove("selected"));
                    e.target.classList.add("selected");
                    selectedDay = e.target.dataset.date;
                    timePicker.style.display = "flex";
                    timeAvailable.style.display = "flex";
                    timeAvailable.style.justifyContent = "center";  // căn giữa ngang
                    confirmBtn.style.display = "none";
                    selectedTime = null;
                    timeSlots.forEach(slot => slot.classList.remove("selected"));
                }
            });

            timeSlots.forEach(slot => {
                slot.addEventListener("click", () => {
                    timeSlots.forEach(s => s.classList.remove("selected"));
                    slot.classList.add("selected");
                    selectedTime = slot.textContent;
                    confirmBtn.style.display = "block";
                });
            });

            confirmBtn.addEventListener("click", () => {
                if (selectedDay && selectedTime) {
                    alert(`Đã đặt lịch vào ngày ${selectedDay} lúc ${selectedTime}`);
                    // TODO: Gửi dữ liệu đến Servlet/Controller xử lý lưu lịch hẹn
                }
            });
        </script>

    </body>
</html>
