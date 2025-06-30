<%-- 
    Document   : doctor_homepage
    Created on : May 18, 2025, 1:50:41 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="doctor_header.jsp" %>
<%@ include file="doctor_menu.jsp" %>
<%@ page import="Model.Doctors" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Appointment" %>
<%@ page import="Model.DoctorDB" %>
<%@ page import="Controller.DoctorTongQuanServlet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>

<%
    // Lấy dữ liệu từ servlet thông qua request attributes
    String doctorName = (String) request.getAttribute("doctorName");
    String doctorGender = (String) request.getAttribute("doctorGender");
    String doctorSpecialty = (String) request.getAttribute("doctorSpecialty");
    String doctorPhone = (String) request.getAttribute("doctorPhone");
    String avatarPath = (String) request.getAttribute("avatarPath");
    Boolean isActiveObj = (Boolean) request.getAttribute("isActive");
    boolean isActive = isActiveObj != null ? isActiveObj : false;
    
    // Kiểm tra xem có dữ liệu từ servlet không
    if (doctorName == null) {
        // Nếu không có dữ liệu từ servlet, redirect về servlet
        response.sendRedirect("DoctorTongQuanServlet");
        return;
    }
    
    // Lấy dữ liệu thống kê
    List<Appointment> waitingAppointments = (List<Appointment>) request.getAttribute("waitingAppointments");
    Integer waitingCountObj = (Integer) request.getAttribute("waitingCount");
    int waitingCount = waitingCountObj != null ? waitingCountObj : 0;
    
    List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");
    Integer cancelledCountObj = (Integer) request.getAttribute("cancelledCount");
    int cancelledCount = cancelledCountObj != null ? cancelledCountObj : 0;
    
    // Khởi tạo list rỗng nếu null để tránh lỗi
    if (waitingAppointments == null) {
        waitingAppointments = new ArrayList<>();
    }
    if (cancelledAppointments == null) {
        cancelledAppointments = new ArrayList<>();
    }
    
    // Debug log
    System.out.println("=== DEBUG: JSP Data from Servlet ===");
    System.out.println("Doctor Name: " + doctorName);
    System.out.println("Is Active: " + isActive);
    System.out.println("Waiting Count: " + waitingCount);
    System.out.println("Cancelled Count: " + cancelledCount);
    System.out.println("===================================");
%>

<%!
    // Helper function để lấy time slot - sử dụng method từ servlet
    public String getTimeSlot(int slotId) {
        return Controller.DoctorTongQuanServlet.getTimeSlot(slotId);
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>

            body {
                margin-left: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;
            }


            .dashboard {
                padding-left: 282px;
                padding-top: 15px;
                display: grid;
                grid-template-columns: 1.1fr 1fr 0.9fr;
                grid-template-rows: 310px 300px;
                gap: 10px;
                padding-right: 10px;
                padding-bottom: 50px;
                box-sizing: border-box;
                min-height: 100vh;

            }

            .dashboard > div {
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 0 10px #ddd;
                background-color: #fff;
            }

            /* Vị trí các khung */
            .calendar {
                grid-column:  1/ 2;
                grid-row: 1 / 2;
            }

            .visit-count {
                grid-column: 2 / 3;
                grid-row: 1 / 2;
            }

            .on-duty {
                grid-column: 3 / 4;
                grid-row: 1 / 2;
            }

            .user-info {
                grid-column: 1 / 2;
                grid-row: 2 / 3;
            }

            .consultations {
                grid-column: 2 / 3;
                grid-row: 2 / 3;
            }

            .recent-visits {
                grid-column: 3 / 4;
                grid-row: 2 / 3;
            }

            #menu-toggle:checked ~.dashboard {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .dashboard {
                transition: transform 0.3s ease;
            }


            /*----------------------------------------lich----------------------------------------*/





            .calendar-header {
                text-align: center;
                font-weight: bold;
                margin-top: -5px;
                font-size: 18px;
            }

            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 8px;
            }

            .day, .date {
                text-align: center;
                padding: 10px 0;
            }

            .day {
                font-weight: 600;
                color: #6b7280;
            }

            .date {
                background-color: #e5f0ff;
                border-radius: 8px;
                cursor: pointer;
            }

            .today {
                background-color: #2b72f9;
                color: white;
                font-weight: bold;
            }

            .calendar-wrapper {
                width: 330px;
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                padding: 20px;
            }

            .calendar-header {
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                margin-bottom: -5px;
            }

            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 1px;
            }

            .calendar-day {
                font-size: 14px;
                font-weight: 500;
                color: #94a3b8;
                text-align: center;
            }

            .calendar-date {
                height: 36px;
                border-radius: 8px;
                background-color: #e2ecfa;
                color: #1e293b;
                font-weight: 500;
                text-align: center;
                line-height: 36px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            .calendar-date.today {
                background-color: #2563eb;
                color: white;
            }

            .calendar-date:hover {
                background-color: #bfdbfe;
            }

            .calendar-empty {
                height: 36px;
            }

            .time-now {
                margin-top: 12px;
                text-align: center;
                font-size: 14px;
                color: #475569;
            }

            /*-----------------đang chờ khám-----------------------------------*/



            .visit-count {
                text-align: center;
                margin: 0 0 0px;
                font-size: 18px;
                color: #0f172a;
                font-weight: bold;
            }

            .patient {
                display: flex;
                align-items: center;
                margin-top: 10px;
                border-bottom: 1px solid #e2e8f0;
                padding-bottom: 12px;
            }

            .patient:last-child {
                border-bottom: none;
                margin-bottom: 8px;
                padding-bottom: 0;
            }

            .avatar {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 12px;
            }

            .info {
                flex-grow: 1;
            }

            .info .name {
                font-weight: 600;
                color: #1e293b;
            }

            .info .details {
                font-size: 13px;
                color: #64748b;
            }

            .status-btn {
                background-color: #2563eb;
                color: white;
                border: none;
                border-radius: 999px;
                padding: 6px 12px;
                font-size: 13px;
                font-weight: 500;
                cursor: default;
            }

            .view-all {
                display: block;
                text-align: center;
                color: #2563eb;
                font-size: 14px;
                font-weight: 500;
                margin-top: 10px;
                text-decoration: none;
            }

            .view-all:hover {
                text-decoration: underline;
            }
            
            
            
            
            /*trạng thái*/





            .status-card h4 {
                text-align: center;
                font-size: 18px;
                color: #0f172a;
                margin-bottom: 8px;
            }

            .status-card p {
                font-size: 13px;
                color: #64748b;
                margin-bottom: 30px;
            }

            .toggle-container {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
            }

            .toggle-switch {
                position: relative;
                width: 50px;
                height: 28px;
            }

            .toggle-switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: 0.4s;
                border-radius: 34px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: 0.4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #2563eb;
            }

            input:checked + .slider:before {
                transform: translateX(22px);
            }

            .status-label {
                font-weight: 600;
                color: #0f172a;
                font-size: 14px;
                transition: color 0.3s ease;
            }

            .status-label.updating {
                color: #6b7280;
                font-style: italic;
            }

            .toggle-switch input:disabled + .slider {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .note {
                font-size: 12px;
                color: #64748b;
                line-height: 1.5;
            }

            /*thong tin bac si*/

            

            .card-header {
                background: url('header-bg.png') no-repeat center/cover;
                padding: 16px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .doctor-avatar {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                border: 2px solid #fff;
                object-fit: cover;
            }

            .settings-btn {
                background-color: #e0f0ff;
                border: none;
                border-radius: 8px;
                padding: 8px 12px;
                font-size: 14px;
                cursor: pointer;
            }

            .card-body {
                padding: 16px;
            }

            .doctor-name {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .card-body p {
                font-size: 14px;
                margin: 6px 0;
                color: #333;
            }

            .card-body i {
                margin-right: 8px;
                color: #0066cc;
            }


            /*cho tu van*/





            .consultation-title {
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                color: #0f172a;
                margin-bottom: 16px;
            }

            .consultation-item {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
            }

            .consultation-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 12px;
            }

            .consultation-content {
                flex-grow: 1;
                overflow: hidden;
            }

            .consultation-name {
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 2px;
            }

            .consultation-message {
                font-size: 14px;
                color: #64748b;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }


            /*            lich su kham           */







            .booking-title {
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                color: #0f172a;
                margin-bottom: 16px;
            }

            .booking-item {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding-top: 15px;
                margin-bottom: 12px;
                border-bottom: 1px solid #f1f5f9;
                gap: 8px;
            }

            .booking-avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 8px;
                flex-shrink: 0; /* Ngăn avatar bị co nhỏ */
            }

            .booking-info {
                flex-grow: 1;
                margin-left: 12px;
                min-width: 0; /* Cho phép shrink */
                overflow: hidden;
            }

            .booking-name {
                font-weight: 600;
                color: #1e293b;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 100%;
            }

            .booking-time {
                font-size: 12px;
                color: #64748b;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 100%;
                margin-top: 2px;
            }

            .booking-slot {
                display: flex;
                align-items: center;
                gap: 6px;
                background-color: #2563eb;
                padding: 4px 8px;
                border-radius: 16px;
                color: white;
                font-size: 11px;
                white-space: nowrap;
                min-width: 0;
                max-width: 140px;
            }

            .booking-time-slot {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 100%;
            }

            .booking-status-icon {
                width: 20px;
                height: 20px;
            }

            /* CSS cho status badge */
            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
            }

            .status-active {
                background-color: #dcfce7;
                color: #166534;
            }

            .status-inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }

        </style>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <div class="dashboard">

            <!-----------lich------------->
            <div class="calendar-container">
                <div class="calendar-header" id="calendarHeader"></div>
                <div class="calendar-grid" id="calendarDays">
                    <!-- Ngày trong tuần -->
                    <div class="day">T2</div>
                    <div class="day">T3</div>
                    <div class="day">T4</div>
                    <div class="day">T5</div>
                    <div class="day">T6</div>
                    <div class="day">T7</div>
                    <div class="day">CN</div>

                </div>

            </div>
            <!--lượt khám-->


            <div class="waiting-card">
                <div class="visit-count">Đang chờ khám (<%= waitingCount %>)</div>

                <% if (waitingAppointments.size() > 0) { 
                    int displayCount = Math.min(3, waitingAppointments.size()); // Hiển thị tối đa 3 bệnh nhân
                    for (int i = 0; i < displayCount; i++) {
                        Appointment appointment = waitingAppointments.get(i);
                        String timeSlot = getTimeSlot(appointment.getSlotId());
                        String patientName = appointment.getPatientName() != null ? appointment.getPatientName() : "Bệnh nhân #" + appointment.getPatientId();
                        String patientGender = "";
                        if ("male".equals(appointment.getPatientGender())) {
                            patientGender = "Nam";
                        } else if ("female".equals(appointment.getPatientGender())) {
                            patientGender = "Nữ";
                        }
                        
                        // Tính tuổi
                        String ageInfo = "";
                        if (appointment.getPatientDateOfBirth() != null) {
                            Calendar now = Calendar.getInstance();
                            Calendar birth = Calendar.getInstance();
                            birth.setTime(appointment.getPatientDateOfBirth());
                            int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
                            if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
                                age--;
                            }
                            ageInfo = patientGender + " • " + age + " Tuổi";
                        } else {
                            ageInfo = patientGender.isEmpty() ? "Thông tin chưa cập nhật" : patientGender;
                        }
                %>

                <div class="patient">
                    <img src="images/default-avatar.png" alt="<%= patientName %>" class="avatar" 
                         onerror="this.src='images/logo.png'">
                    <div class="info">
                        <div class="name"><%= patientName %></div>
                        <div class="details"><%= ageInfo %></div>
                    </div>
                    <button class="status-btn" onclick="window.location.href='phieukham.jsp?appointmentId=<%= appointment.getAppointmentId() %>'">
                        <%= timeSlot %>
                    </button>
                </div>

                <% } 
                } else { %>
                
                <div class="patient" style="text-align: center; padding: 20px; color: #64748b;">
                    <i class="fas fa-clock" style="font-size: 24px; margin-bottom: 10px;"></i>
                    <div class="info">
                        <div class="name">Không có bệnh nhân đang chờ</div>
                        <div class="details">Hôm nay chưa có lịch hẹn nào</div>
                    </div>
                </div>

                <% } %>

                <a href="/doctor/DoctorAppointmentsServlet" class="view-all">Xem tất cả</a>
            </div>


            <!--trang thái-->


            <div class="status-card">
                <h4>Cập nhật trạng thái</h4>
                <p>Cho người khác biết là bạn hiện đang có mặt tại phòng khám.</p>

                <div class="toggle-container">
                    <label class="toggle-switch">
                        <input type="checkbox" id="statusToggle" <%= isActive ? "checked" : "" %>>
                        <span class="slider"></span>
                    </label>
                    <span class="status-label" id="statusLabel"><%= isActive ? "Hiện đang trực" : "Hiện không trực" %></span>
                </div>

                <div class="note">
                    <strong>Lưu ý</strong><br>
                    Người sử dụng hệ thống sẽ dễ dàng đặt lịch khám hoặc yêu cầu tư vấn hơn khi có bác sĩ đang trực!
                </div>
            </div>


            <!--thong tin bac si-->



            <!-- Doctor Info Card -->
            <div class="doctor-card">
                <div class="card-header">
                    <img src="<%= avatarPath %>" alt="Doctor Avatar" class="doctor-avatar" onerror="this.src='images/logo.png'">
                    <button class="settings-btn" onclick="window.location.href='jsp/doctor/doctor_caidat.jsp'">Cài đặt ⚙️</button>
                </div>
                <div class="card-body">
                    <h2 class="doctor-name"><%= doctorName %></h2>
                    <p><i class="fa-solid fa-venus-mars"></i> Giới tính: <%= doctorGender %></p>
                    <p><i class="fa-solid fa-user-doctor"></i> Chức vụ: Bác sĩ</p>
                    <p><i class="fa-solid fa-stethoscope"></i> Chuyên khoa: <%= doctorSpecialty %></p>
                    <p><i class="fa-solid fa-phone"></i> Số điện thoại: <%= doctorPhone %></p>
                </div>
            </div>




            <!--chờ tư vấn-->





            <div class="consultations">
                <h4 class="consultation-title">Yêu cầu tư vấn</h4>

                <div class="consultation-item">
                    <img src="" alt="Nguyễn Mai Phương" class="consultation-avatar">
                    <div class="consultation-content">
                        <div class="consultation-name">Nguyễn Mai Phương</div>
                        <div class="consultation-message">Hiện tại em đang muốn khám tổng quát, bác sĩ có thể...</div>
                    </div>
                </div>

                <div class="consultation-item">
                    <img src="" alt="Nguyễn Mai Phương" class="consultation-avatar">
                    <div class="consultation-content">
                        <div class="consultation-name">Nguyễn Mai Phương</div>
                        <div class="consultation-message">Hiện tại em đang muốn khám tổng quát, bác sĩ có thể...</div>
                    </div>
                </div>


                <div class="consultation-item">
                    <img src="" alt="Lê Đại Hoàng" class="consultation-avatar">
                    <div class="consultation-content">
                        <div class="consultation-name">Lê Đại Hoàng</div>
                        <div class="consultation-message">Tư vấn giúp em về tình hình sức khỏe hiện tại của em...</div>
                    </div>
                </div>
            </div>

            <!--lich su kham-->




            <div class="recent-bookings">
                <h4 class="booking-title">Lịch đã được hủy</h4>

                <% if (cancelledAppointments.size() > 0) { 
                    int displayCancelledCount = Math.min(3, cancelledAppointments.size()); // Hiển thị tối đa 3 lịch đã hủy
                    for (int i = 0; i < displayCancelledCount; i++) {
                        Appointment cancelledApp = cancelledAppointments.get(i);
                        String timeSlot = getTimeSlot(cancelledApp.getSlotId());
                        String patientName = cancelledApp.getPatientName() != null ? cancelledApp.getPatientName() : "Bệnh nhân #" + cancelledApp.getPatientId();
                        
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                        String workDateString = (cancelledApp.getWorkDate() != null) ? 
                            dateFormat.format(cancelledApp.getWorkDate()) : "N/A";
                %>

                <div class="booking-item">
                    <img src="images/default-avatar.png" alt="<%= patientName %>" class="booking-avatar" 
                         onerror="this.src='images/logo.png'">
                    <div class="booking-info">
                        <div class="booking-name"><%= patientName %></div>
                        <div class="booking-time">Lý do: <%= cancelledApp.getReason() != null ? cancelledApp.getReason() : "Không rõ" %></div>
                    </div>
                    <div class="booking-slot" style="background-color: #ef4444;">
                        <span class="booking-time-slot"><%= timeSlot %> | <%= workDateString %></span>
                        <i class="fas fa-times-circle" style="color: white;"></i>
                    </div>
                </div>

                <% } 
                } else { %>

                <div class="booking-item" style="text-align: center; padding: 20px; color: #64748b;">
                    <i class="fas fa-calendar-times" style="font-size: 24px; margin-bottom: 10px;"></i>
                    <div class="booking-info">
                        <div class="booking-name">Không có lịch hẹn bị hủy</div>
                        <div class="booking-time">Tất cả lịch hẹn đều diễn ra bình thường</div>
                    </div>
                </div>
                
                <% } %>

                <!-- Link xem tất cả lịch đã hủy -->
                <% if (cancelledAppointments.size() > 2) { %>
                    <div style="text-align: center; margin-top: 10px;">
                        <a href="/doctor/cancelledAppointments" style="color: #ef4444; text-decoration: none; font-size: 14px;">
                            Xem tất cả (<%= cancelledCount %> lịch đã hủy) →
                        </a>
                    </div>
                <% } %>
                 <a href="/doctor/cancelledAppointments" class="view-all">Xem tất cả</a>
            </div>
        </div>



    </body>
</html>
<script src="js/calendar.js"></script>
<script>
// JavaScript để xử lý toggle switch
document.addEventListener('DOMContentLoaded', function() {
    const statusToggle = document.getElementById('statusToggle');
    const statusLabel = document.getElementById('statusLabel');
    
    if (statusToggle && statusLabel) {
        statusToggle.addEventListener('change', function() {
            const isChecked = this.checked;
            const newStatus = isChecked ? 'Active' : 'Inactive';
            const newLabel = isChecked ? 'Hiện đang trực' : 'Hiện không trực';
            
            // Hiển thị loading
            statusLabel.textContent = 'Đang cập nhật...';
            statusLabel.classList.add('updating');
            statusToggle.disabled = true;
            
            // Gửi AJAX request
            fetch('updateDoctorStatus', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'status=' + encodeURIComponent(newStatus)
            })
            .then(response => response.json())
            .then(data => {
                console.log('Response:', data);
                
                if (data.success) {
                    // Cập nhật thành công
                    statusLabel.textContent = newLabel;
                    statusLabel.classList.remove('updating');
                    
                    // Hiển thị thông báo thành công
                    showNotification('Cập nhật trạng thái thành công!', 'success');
                    
                } else {
                    // Cập nhật thất bại, revert toggle
                    statusToggle.checked = !isChecked;
                    statusLabel.textContent = !isChecked ? 'Hiện đang trực' : 'Hiện không trực';
                    statusLabel.classList.remove('updating');
                    
                    // Hiển thị thông báo lỗi
                    showNotification(data.message || 'Cập nhật trạng thái thất bại!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                
                // Cập nhật thất bại, revert toggle
                statusToggle.checked = !isChecked;
                statusLabel.textContent = !isChecked ? 'Hiện đang trực' : 'Hiện không trực';
                statusLabel.classList.remove('updating');
                
                // Hiển thị thông báo lỗi
                showNotification('Lỗi kết nối. Vui lòng thử lại!', 'error');
            })
            .finally(() => {
                // Re-enable toggle
                statusToggle.disabled = false;
            });
        });
    }
});

// Function để hiển thị notification
function showNotification(message, type) {
    // Tạo element notification
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        border-radius: 8px;
        color: white;
        font-weight: 500;
        z-index: 10000;
        max-width: 300px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        transform: translateX(100%);
        transition: transform 0.3s ease;
    `;
    
    // Set màu theo loại
    if (type === 'success') {
        notification.style.backgroundColor = '#10b981';
    } else {
        notification.style.backgroundColor = '#ef4444';
    }
    
    notification.textContent = message;
    
    // Thêm vào body
    document.body.appendChild(notification);
    
    // Animate in
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // Tự động ẩn sau 3 giây
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 3000);
}
</script>
