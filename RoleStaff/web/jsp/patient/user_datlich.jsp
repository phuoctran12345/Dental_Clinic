<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/jsp/common/taglib.jsp" %>
<%@page import="model.Appointment" %>
<%@page import="java.util.List" %>
<%@page import="model.Doctors" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>

<%@ include file="/jsp/patient/user_header.jsp" %>
<%@ include file="/jsp/patient/user_menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8" />
        <title>Đặt lịch khám</title>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link
            href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap&subset=vietnamese"
            rel="stylesheet">
        <style>
            body {
                margin: 0;
                font-family: 'Roboto', 'Segoe UI', Arial, 'Helvetica Neue', sans-serif;
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
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
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
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
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
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
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

            .schedule-table th,
            .schedule-table td {
                text-align: center;
                vertical-align: middle;
            }

            .schedule-table th {
                background: #4facfe;
                color: white;
            }

            .schedule-table tr:nth-child(even) {
                background: #f2f6fc;
            }

            .schedule-table tr:hover {
                background: #e3f2fd;
            }

            .doctor-info {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 2rem;
            }
        </style>
    </head>

    <body>

        <div class="container py-4">
            <div class="doctor-info mb-4">
                <h2><i class="fas fa-user-md me-2"></i>Bác sĩ:
                    <span>${doctor.full_name}</span>
                </h2>
                <p class="mb-0"><i class="fas fa-hospital me-2"></i>Chuyên khoa:
                    <span>${doctor.specialty}</span>
                </p>
            </div>
            <div class="card shadow mb-4">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="fas fa-calendar-check me-2"></i>Lịch làm
                        việc đã đăng ký</h4>
                </div>
                <div class="card-body p-0">
                    <table class="table table-bordered schedule-table mb-0">
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Ca làm việc</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${availableSchedules}" var="schedule">
                                <tr>
                                    <td>${schedule.workDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${schedule.slotId == 1}">
                                                <span class="badge bg-warning text-dark"><i
                                                        class="fas fa-sun me-1"></i>Sáng
                                                    (8h-12h)</span>
                                                </c:when>
                                                <c:when test="${schedule.slotId == 2}">
                                                <span class="badge bg-info text-dark"><i
                                                        class="fas fa-cloud-sun me-1"></i>Chiều
                                                    (13h-17h)</span>
                                                </c:when>
                                                <c:when test="${schedule.slotId == 3}">
                                                <span class="badge bg-purple text-white"
                                                      style="background: linear-gradient(45deg, #d299c2, #fef9d7); color: #6a4c93;">
                                                    <i class="fas fa-clock me-1"></i>Cả
                                                    ngày (8h-17h)
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty availableSchedules}">
                                <tr>
                                    <td colspan="2" class="text-center text-muted">Chưa
                                        có lịch làm việc nào được đăng ký.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="/RoleStaff" class="btn btn-secondary"><i
                        class="fas fa-arrow-left me-2"></i>Quay lại</a>
            </div>
        </div>

        <!-- Form ẩn gửi dữ liệu đặt lịch -->
        <form id="appointmentForm" action="ConfirmServlet" method="post"
              style="display:none;">
            <input type="hidden" name="doctor_id" id="doctor_id"
                   value="${doctor.doctorId}" />

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

        <!-- Font Awesome -->

    </body>

</html>