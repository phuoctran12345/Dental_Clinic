<%@page import="Model.TimeSlot"%>
<%@page import="Model.DoctorSchedule"%>
<%@page import="java.util.List"%>
<%@page import="Model.Doctors"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebars.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
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
                padding-left: 300px;
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

            .apointment {
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

            .apointment:hover {
                background-color: #00695c;
            }

            .time {
                display: none;
            }

            /* Ẩn hiện slot */
            .hidden {
                display: none !important;
            }

            /* Thông báo không có lịch */
            .no-schedule {
                text-align: center;
                color: #b71c1c;
                font-weight: 600;
                margin-top: 30px;
            }
        </style>
    </head>
    <body>

        <div class="scheduler">
            <h2><i class="fa-solid fa-calendar-plus"></i> Đặt lịch khám với bác sĩ 
                <%            Doctors doctor = (Doctors) request.getAttribute("doctor");
                    if (doctor != null) {
                        out.print(doctor.getFullName());
                    }
                %>
            </h2>

            <!-- Chọn ngày (hiển thị 30 ngày tới) -->
            <div class="calendar" id="calendar"></div>

            <!-- Tiêu đề chọn giờ -->
            <div class="centered">
                <h2 class="time" id="time-available">Chọn giờ khám</h2>
            </div>

            <!-- Chọn giờ làm việc (dữ liệu từ server, ẩn ban đầu) -->
            <div class="time-picker" id="timePicker">
                <%
                    List<DoctorSchedule> schedules = (List<DoctorSchedule>) request.getAttribute("availableSchedules");
                    if (schedules != null && !schedules.isEmpty()) {
                        for (DoctorSchedule ds : schedules) {
                            TimeSlot ts = ds.getTimeSlot();
                            String start = ts.getStartTime().toString();
                            String workDate = ds.getWorkDate().toString();
                %>
                <div class="time-slot" 
                     data-schedule-id="<%= ds.getScheduleId()%>" 
                     data-work-date="<%= workDate%>" 
                     data-start-time="<%= start%>">
                    <%= start%>
                </div>
                <%  }
        } else { %>
                <p class="no-schedule">Hiện không có lịch khám trống.</p>
                <% }%>
            </div>

            <button class="apointment" id="confirmBtn">Xác nhận đặt lịch</button>
        </div>

        <!-- Form ẩn gửi dữ liệu đặt lịch -->
        <form id="appointmentForm" action="ConfirmServlet" method="post" style="display:none;">
            <input type="hidden" name="doctor_id" id="doctor_id" value="<%= doctor != null ? doctor.getDoctorId() : ""%>" />

            <input type="hidden" name="schedule_id" id="schedule_id" />
            <input type="hidden" name="work_date" id="work_date" />
            <input type="hidden" name="start_time" id="start_time" />
        </form>

       <script>
    // Các biến DOM
    const calendar = document.getElementById("calendar");
    const timeAvailable = document.getElementById("time-available");
    const timePicker = document.getElementById("timePicker");
    const confirmBtn = document.getElementById("confirmBtn");
    const appointmentForm = document.getElementById("appointmentForm");

    let selectedDay = null;
    let selectedTime = null;

    // Tạo lịch 30 ngày tới
    const today = new Date();
    for (let i = 0; i < 30; i++) {
        const date = new Date(today);
        date.setDate(today.getDate() + i);
        const day = document.createElement("div");
        day.className = "day";
        day.textContent = date.getDate() + '/' + (date.getMonth() + 1);
        day.dataset.date = date.toISOString().split('T')[0]; // YYYY-MM-DD
        calendar.appendChild(day);
    }

    // Xử lý chọn ngày
    calendar.addEventListener("click", function (e) {
        if (e.target.classList.contains("day")) {
            // Bỏ chọn tất cả ngày
            calendar.querySelectorAll(".day").forEach(d => d.classList.remove("selected"));
            e.target.classList.add("selected");

            selectedDay = e.target.dataset.date;
            selectedTime = null;

            // Hiển thị time picker và tiêu đề
            timePicker.style.display = "flex";
            timeAvailable.style.display = "flex";
            confirmBtn.style.display = "none";

            // Ẩn tất cả khung giờ
            timePicker.querySelectorAll(".time-slot").forEach(slot => {
                slot.style.display = "none";
                slot.classList.remove("selected");
            });

            // Hiển thị những khung giờ phù hợp với ngày được chọn
            timePicker.querySelectorAll(".time-slot").forEach(slot => {
                if (slot.getAttribute("data-work-date") === selectedDay) {
                    slot.style.display = "inline-block";
                }
            });
        }
    });

    // Xử lý chọn giờ
    timePicker.querySelectorAll(".time-slot").forEach(slot => {
        slot.addEventListener("click", () => {
            timePicker.querySelectorAll(".time-slot").forEach(s => s.classList.remove("selected"));
            slot.classList.add("selected");
            selectedTime = slot.textContent;
            confirmBtn.style.display = "block";
        });
    });

    // Xử lý submit form khi bấm nút xác nhận
    confirmBtn.addEventListener("click", () => {
        if (!selectedDay) {
            alert("Vui lòng chọn ngày!");
            return;
        }
        if (!selectedTime) {
            alert("Vui lòng chọn giờ!");
            return;
        }

        // Lấy time slot được chọn
        const selectedSlot = document.querySelector(".time-slot.selected");
        if (!selectedSlot) {
            alert("Vui lòng chọn khung giờ!");
            return;
        }

        // Đổ dữ liệu vào form ẩn
        document.getElementById("schedule_id").value = selectedSlot.getAttribute("data-schedule-id");
        document.getElementById("work_date").value = selectedSlot.getAttribute("data-work-date");
        document.getElementById("start_time").value = selectedSlot.getAttribute("data-start-time");

        // Gửi form
        appointmentForm.submit();
    });
</script>


    </body>
</html>
