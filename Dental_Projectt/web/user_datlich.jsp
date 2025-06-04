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
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <style>
            /* 
            GHI CHÚ QUAN TRỌNG:
            1. Màu chủ đạo: #4E80EE (xanh dương tươi sáng)
            2. Màu nền chính: #FFFFFF (trắng)
            3. Màu phụ trợ: 
               - #E8F0FE (xanh nhạt cho hover)
               - #3A5FCD (xanh đậm cho button hover)
            4. Màu chữ:
               - #2D3748 (xám đậm cho chữ chính)
               - #718096 (xám nhạt cho chữ phụ)
            5. Hiệu ứng: shadow sử dụng màu xanh nhẹ (rgba(78, 128, 238, 0.15))
            */

            :root {
                --primary-color: #4E80EE; /* Màu xanh chính */
                --primary-light: #E8F0FE; /* Màu xanh nhạt cho hover */
                --primary-dark: #3A5FCD; /* Màu xanh đậm cho button hover */
                --text-primary: #2D3748; /* Màu chữ chính - xám đậm */
                --text-secondary: #718096; /* Màu chữ phụ - xám nhạt */
                --background: #FFFFFF; /* Màu nền trắng */
                --border-radius: 5px; /* Bo góc */
                --box-shadow: 0 4px 12px rgba(78, 128, 238, 0.15); /* Shadow với màu xanh nhẹ */
                --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); /* Hiệu ứng mượt */
            }

            body {
                margin: 0;
                font-family: 'Roboto', sans-serif;
                background-color: #F5F9FF; /* Màu nền xanh rất nhạt */
                color: var(--text-primary);
            }

            .scheduler-container {
                width: calc(100vw - 300px);
                min-height: 100vh;
                margin-left: 280px;
                padding: 40px;
                box-sizing: border-box;
            }

            .scheduler-card {
                background: var(--background);
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                padding: 36px;
                max-width: 2000px;
                margin: 0 auto;
            }

            .scheduler-header {
                text-align: center;
                margin-bottom: 32px;
                color: var(--primary-dark); /* Sử dụng màu xanh đậm */
            }

            .scheduler-header h2 {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
            }

            .scheduler-header .doctor-name {
                color: #218838; /* Màu xanh chính */
                font-weight: 900;
                font-size: 30px;
            }

            .section-title {
                font-size: 18px;
                font-weight: 500;
                color: var(--primary-dark); /* Màu xanh đậm */
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .calendar {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 12px;
                margin-bottom: 24px;
            }

            .day {
                padding: 16px 8px;
                background-color: var(--background);
                text-align: center;
                border-radius: var(--border-radius);
                cursor: pointer;
                font-weight: 500;
                color: var(--text-primary);
                border: 1px solid #E0E0E0;
                transition: var(--transition);
                position: relative;
                overflow: hidden;
            }

            .day:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 16px rgba(78, 128, 238, 0.15); /* Shadow xanh */
                border-color: var(--primary-color);
            }

            .day.selected {
                background-color: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
            }

            .day.today {
                border: 1px solid var(--primary-color);
            }

            .day.today::after {
                content: 'Hôm nay';
                position: absolute;
                top: 4px;
                right: 4px;
                font-size: 10px;
                background: var(--primary-color);
                color: white;
                padding: 2px 4px;
                border-radius: 4px;
            }

            .time-picker-container {
                display: none;
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid #E0E0E0;
            }

            .time-slots {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                margin-bottom: 24px;
            }

            .time-slot {
                padding: 12px 20px;
                background-color: var(--background);
                border-radius: var(--border-radius);
                cursor: pointer;
                font-weight: 500;
                color: var(--text-primary);
                border: 1px solid #E0E0E0;
                transition: var(--transition);
                min-width: 100px;
                text-align: center;
            }

            .time-slot:hover {
                background-color: var(--primary-light); /* Màu xanh nhạt khi hover */
                border-color: var(--primary-color);
            }

            .time-slot.selected {
                background-color: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
            }

            .time-slot.booked {
                background-color: #EEEEEE;
                color: #9E9E9E;
                cursor: not-allowed;
                text-decoration: line-through;
            }

            .confirm-btn {
                width: 100%;
                padding: 16px;
                background-color: var(--primary-color);
                color: white;
                font-weight: 600;
                border: none;
                border-radius: var(--border-radius);
                cursor: pointer;
                font-size: 16px;
                display: none;
                transition: var(--transition);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-top: 24px;
            }

            .confirm-btn:hover {
                background-color: var(--primary-dark); /* Màu xanh đậm khi hover */
                box-shadow: 0 6px 16px rgba(78, 128, 238, 0.3); /* Shadow xanh đậm */
            }

            .no-schedule {
                text-align: center;
                color: #F44336;
                font-weight: 500;
                margin: 24px 0;
                padding: 16px;
                background-color: #FFEBEE;
                border-radius: var(--border-radius);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .selected-info {
                background-color: var(--primary-light); /* Màu xanh nhạt */
                padding: 16px;
                border-radius: var(--border-radius);
                margin-bottom: 24px;
                display: none;
            }

            .selected-info p {
                margin: 0;
                font-weight: 500;
                color: var(--primary-dark); /* Màu xanh đậm */
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .selected-info p span {
                font-weight: 400;
                color: var(--text-primary);
            }

            /* Phần ghi chú */
            .notes-container {
                display: none;
                margin-top: 24px;
            }

            .notes-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: var(--primary-dark); /* Màu xanh đậm */
            }

            .notes-textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #E0E0E0;
                border-radius: var(--border-radius);
                font-family: 'Roboto', sans-serif;
                font-size: 16px;
                min-height: 120px;
                resize: vertical;
                transition: var(--transition);
            }

            .notes-textarea:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(78, 128, 238, 0.2); /* Hiệu ứng focus màu xanh */
                outline: none;
            }

            @media (max-width: 768px) {
                .scheduler-container {
                    width: 100%;
                    margin-left: 0;
                    padding: 20px;
                }

                .calendar {
                    grid-template-columns: repeat(4, 1fr);
                }

                .time-slot {
                    min-width: 80px;
                    padding: 10px 12px;
                }
            }
        </style>
    </head>
    <body>
        <!-- GHI CHÚ: Cấu trúc HTML giữ nguyên, chỉ thay đổi CSS -->

        <div class="scheduler-container">
            <div class="scheduler-card">
                <div class="scheduler-header">
                    <h2>
                        <i class="fas fa-calendar-plus" style="color: var(--primary-color);"></i> 
                        Đặt lịch khám với bác sĩ 
                        <span class="doctor-name">
                            <% Doctors doctor = (Doctors) request.getAttribute("doctor");
                                if (doctor != null) {
                                    out.print(doctor.getFullName());
                                } %>
                        </span>
                    </h2>
                    <p>Vui lòng chọn ngày và giờ khám phù hợp với bạn</p>
                </div>

                <div class="calendar-container">
                    <h3 class="section-title">
                        <i class="far fa-calendar-alt"></i> Chọn ngày khám
                    </h3>
                    <div class="calendar" id="calendar"></div>
                </div>

                <div class="time-picker-container" id="timePickerContainer">
                    <h3 class="section-title">
                        <i class="far fa-clock"></i> Chọn giờ khám
                    </h3>

                    <div class="selected-info" id="selectedDateInfo">
                        <p><i class="fas fa-calendar-day"></i> Ngày đã chọn: <span id="selectedDate"></span></p>
                    </div>

                    <div class="time-slots" id="timePicker">
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
                        <div class="no-schedule">
                            <i class="fas fa-calendar-times"></i> Hiện không có lịch khám trống.
                        </div>
                        <% }%>
                    </div>
                </div>

                <div class="notes-container" id="notesContainer">
                    <label for="patientNotes" class="notes-label">
                        <i class="fas fa-edit"></i> Ghi chú cho bác sĩ (nếu có)
                    </label>
                    <textarea id="patientNotes" class="notes-textarea" 
                              placeholder="Vui lòng mô tả ngắn gọn tình trạng hoặc triệu chứng của bạn..."></textarea>
                </div>

                <button class="confirm-btn" id="confirmBtn">
                    <i class="fas fa-check-circle"></i> Xác nhận đặt lịch
                </button>
            </div>
        </div>

        <form id="appointmentForm" action="ConfirmServlet" method="post" style="display:none;">
            <input type="hidden" name="doctor_id" id="doctor_id" value="<%= doctor != null ? doctor.getDoctorId() : ""%>" />
            <input type="hidden" name="schedule_id" id="schedule_id" />
            <input type="hidden" name="work_date" id="work_date" />
            <input type="hidden" name="start_time" id="start_time" />
            <input type="hidden" name="patient_notes" id="patient_notes" />
        </form>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // DOM Elements
                const calendarEl = document.getElementById("calendar");
                const timePickerContainer = document.getElementById("timePickerContainer");
                const timePicker = document.getElementById("timePicker");
                const confirmBtn = document.getElementById("confirmBtn");
                const appointmentForm = document.getElementById("appointmentForm");
                const selectedDateInfo = document.getElementById("selectedDateInfo");
                const selectedDateEl = document.getElementById("selectedDate");
                const notesContainer = document.getElementById("notesContainer");
                const patientNotes = document.getElementById("patientNotes");

                let selectedDay = null;
                let selectedTime = null;

                // Format date to display
                const formatDisplayDate = (dateStr) => {
                    const date = new Date(dateStr);
                    const options = {weekday: 'long', day: 'numeric', month: 'numeric', year: 'numeric'};
                    return date.toLocaleDateString('vi-VN', options);
                };

                // Function to normalize date format for comparison
                const normalizeDate = (dateStr) => {
                    const date = new Date(dateStr);
                    return date.toISOString().split('T')[0];
                };

                // Generate calendar for next 30 days
                const today = new Date();
                today.setHours(0, 0, 0, 0); // Normalize time
                const todayStr = today.toISOString().split('T')[0];
                const currentMonth = today.getMonth();

                // Create calendar days
                for (let i = 0; i < 30; i++) {
                    const date = new Date(today);
                    date.setDate(today.getDate() + i);
                    const dateStr = date.toISOString().split('T')[0];
                    const dayOfMonth = date.getDate();
                    const month = date.getMonth() + 1;
                    const dayOfWeek = date.getDay();

                    const dayEl = document.createElement("div");
                    dayEl.className = "day" + (i === 0 ? " today" : "");

                    // Display day number
                    dayEl.textContent = dayOfMonth;

                    // Mark days not in current month
                    if (date.getMonth() !== currentMonth) {
                        dayEl.classList.add("disabled");
                    }

                    dayEl.dataset.date = dateStr;
                    calendarEl.appendChild(dayEl);
                }

                // Handle day selection
                calendarEl.addEventListener("click", function (e) {
                    const target = e.target.closest('.day');
                    if (target && !target.classList.contains("disabled")) {
                        // Reset previous selections
                        document.querySelectorAll(".day.selected").forEach(d => d.classList.remove("selected"));
                        target.classList.add("selected");

                        selectedDay = normalizeDate(target.dataset.date);
                        selectedTime = null;

                        // Show selected date info
                        selectedDateEl.textContent = formatDisplayDate(selectedDay);
                        selectedDateInfo.style.display = "block";

                        // Show time picker container
                        timePickerContainer.style.display = "block";
                        notesContainer.style.display = "block";
                        confirmBtn.style.display = "none";

                        // Hide all time slots first
                        timePicker.querySelectorAll(".time-slot").forEach(slot => {
                            slot.style.display = "none";
                            slot.classList.remove("selected", "booked");
                        });

                        // Show only time slots for selected day
                        let hasAvailableSlots = false;
                        const slots = timePicker.querySelectorAll(".time-slot:not(.no-schedule)");

                        for (let slot of slots) {
                            const slotDate = normalizeDate(slot.getAttribute("data-work-date"));
                            if (slotDate === selectedDay) {
                                slot.style.display = "block";
                                hasAvailableSlots = true;
                            }
                        }

                        // Handle case when no slots available
                        const noSlotsMsg = timePicker.querySelector(".no-slots-msg");
                        if (!hasAvailableSlots) {
                            if (!noSlotsMsg) {
                                const msg = document.createElement("div");
                                msg.className = "no-schedule no-slots-msg";
                                msg.innerHTML = `<i class="fas fa-calendar-times"></i> Không có khung giờ trống cho ngày này`;
                                timePicker.appendChild(msg);
                            } else {
                                noSlotsMsg.style.display = "flex";
                            }
                        } else if (noSlotsMsg) {
                            noSlotsMsg.style.display = "none";
                        }
                    }
                });

                // Handle time slot selection
                timePicker.addEventListener("click", (e) => {
                    const target = e.target.closest('.time-slot');
                    if (target && target.style.display !== "none" && !target.classList.contains("booked")) {
                        timePicker.querySelectorAll(".time-slot.selected").forEach(s => s.classList.remove("selected"));
                        target.classList.add("selected");
                        selectedTime = target.textContent.trim();
                        confirmBtn.style.display = "block";
                    }
                });

                // Handle confirm button click
                confirmBtn.addEventListener("click", () => {
                    if (!selectedDay) {
                        alert("Vui lòng chọn ngày khám!");
                        return;
                    }

                    const selectedSlot = document.querySelector(".time-slot.selected");
                    if (!selectedSlot) {
                        alert("Vui lòng chọn khung giờ khám!");
                        return;
                    }

                    // Set form values
                    document.getElementById("schedule_id").value = selectedSlot.getAttribute("data-schedule-id");
                    document.getElementById("work_date").value = selectedSlot.getAttribute("data-work-date");
                    document.getElementById("start_time").value = selectedSlot.getAttribute("data-start-time");
                    document.getElementById("patient_notes").value = patientNotes.value;

                    // Submit form
                    appointmentForm.submit();
                });
            });
        </script>
    </body>
</html>