<%@page import="Model.TimeSlot"%>
<%@page import="Model.DoctorSchedule"%>
<%@page import="java.util.List"%>
<%@page import="Model.Doctors"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/patient/header.jsp" %>
<%@ include file="/patient/sidebars.jsp" %>

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
                gap: 100px;
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
            .confirm {
                display: flex;
                gap: 10px;
            }

            .relative-form {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background-color: rgba(0, 0, 0, 0.5);
                justify-content: center;
                align-items: center;
                z-index: 999;
            }

            .relative-form-content {
                background-color: white;
                padding: 30px;
                border-radius: 12px;
                width: 400px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            }

            .relative-form-content h3 {
                margin-bottom: 15px;
                color: #00796b;
            }

            .relative-form-content input,
            .relative-form-content select {
                width: 100%;
                margin-bottom: 12px;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
            }

            .form-buttons {
                display: flex;
                justify-content: space-between;
                gap: 10px;
            }

            .form-buttons button {
                flex: 1;
                padding: 10px;
                border: none;
                background-color: #00796b;
                color: white;
                border-radius: 6px;
                cursor: pointer;
            }

            .form-buttons button:hover {
                background-color: #00695c;
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
            <div class="confirm"> 
                <button class="apointment" id="confirmBtn">Xác nhận đặt lịch</button>
                <button class="apointment" id="confirmBtn2">Đặt lịch cho người thân</button>
            </div>
        </div>

        <!-- Form ẩn gửi dữ liệu đặt lịch -->
        <form id="appointmentForm" action="ConfirmServlet" method="post" style="display:none;">
            <input type="hidden" name="doctor_id" id="doctor_id" value="<%= doctor != null ? doctor.getDoctorId() : ""%>" />

            <input type="hidden" name="schedule_id" id="schedule_id" />
            <input type="hidden" name="work_date" id="work_date" />
            <input type="hidden" name="start_time" id="start_time" />
        </form>
        <!-- Popup form nhập người thân -->
        <div class="relative-form" id="relativeForm">
            <div class="relative-form-content">
                <h3>Thông tin người thân</h3>
                <form action="ConfirmRelativeServlet" method="post">
                    <input type="hidden" name="schedule_id" id="rel_schedule_id">
                    <input type="hidden" name="work_date" id="rel_work_date">
                    <input type="hidden" name="start_time" id="rel_start_time">

                    <label class="form-label">Họ tên</label>
                    <input type="text" name="full_name" class="form-control" required>

                    

                    
                    <label class="form-label">Ngày sinh</label>
                    <input type="date" name="date_of_birth" class="form-control">

                    

                    <label>Giới tính:</label>
                    <select name="gender" class="form-select">
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>

                    <div class="form-buttons">
                        <button type="submit">Xác nhận</button>
                        <button type="button" onclick="closeRelativeForm()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Các biến DOM
            const calendar = document.getElementById("calendar");
            const timeAvailable = document.getElementById("time-available");
            const timePicker = document.getElementById("timePicker");
            const confirmBtn = document.getElementById("confirmBtn");
            const confirmBtn2 = document.getElementById("confirmBtn2");

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
                    confirmBtn2.style.display = "none";

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
                    confirmBtn2.style.display = "block";

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
            confirmBtn2.addEventListener("click", () => {
                if (!selectedDay || !selectedTime) {
                    alert("Vui lòng chọn ngày và giờ!");
                    return;
                }

                const selectedSlot = document.querySelector(".time-slot.selected");
                if (!selectedSlot) {
                    alert("Vui lòng chọn khung giờ!");
                    return;
                }

                // Đổ dữ liệu vào hidden input trong form người thân
                document.getElementById("rel_schedule_id").value = selectedSlot.getAttribute("data-schedule-id");
                document.getElementById("rel_work_date").value = selectedSlot.getAttribute("data-work-date");
                document.getElementById("rel_start_time").value = selectedSlot.getAttribute("data-start-time");

                // Hiện popup
                document.getElementById("relativeForm").style.display = "flex";
            });

// Hàm đóng popup
            function closeRelativeForm() {
                document.getElementById("relativeForm").style.display = "none";
            }
        </script>


    </body>
</html>
