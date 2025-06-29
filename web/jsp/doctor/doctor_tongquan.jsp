<%-- Document : doctor_homepage Created on : May 18, 2025, 1:50:41 PM Author : ASUS --%>

    <%@page pageEncoding="UTF-8" %>
        <%@ include file="/jsp/doctor/doctor_header.jsp" %>
            <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
                <%@ page import="dao.DoctorDAO" %>
                    <%@ page import="model.Doctors" %>
                        <%@ page import="model.User" %>
                            <%@ page import="java.util.List" %>
                                <%@ page import="java.util.Map" %>
                                    <%@ page import="java.text.SimpleDateFormat" %>
                                        <%@ page import="java.util.Date" %>

                                            <% // Lấy dữ liệu từ servlet
                                                Doctors doctor=(Doctors)
                                                request.getAttribute("doctor"); User user=(User)
                                                request.getAttribute("user"); List<Map<String, Object>> waitingPatients
                                                = (List<Map<String, Object>>) request.getAttribute("waitingPatients");
                                                    List<Map<String, Object>> recentBookings = (List<Map<String, Object>
                                                            >) request.getAttribute("recentBookings");
                                                            Map<String, Object> doctorStats = (Map<String, Object>)
                                                                    request.getAttribute("doctorStats");

                                                                    // Fallback nếu không có dữ liệu từ servlet
                                                                    if (doctor == null && user != null) {
                                                                    doctor = DoctorDAO.getDoctorByUserId(user.getId());
                                                                    }
                                                                    %>
                                                                    <!DOCTYPE html>
                                                                    <html>

                                                                    <head>
                                                                        <meta http-equiv="Content-Type"
                                                                            content="text/html; charset=UTF-8">
                                                                        <title>Doctor Dashboard</title>
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

                                                                            .dashboard>div {
                                                                                border-radius: 12px;
                                                                                padding: 20px;
                                                                                box-shadow: 0 0 10px #ddd;
                                                                                background-color: #fff;
                                                                            }

                                                                            /* Grid positions */
                                                                            .calendar {
                                                                                grid-column: 1/ 2;
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

                                                                            #menu-toggle:checked~.dashboard {
                                                                                transform: translateX(-125px);
                                                                                transition: transform 0.3s ease;
                                                                            }

                                                                            .dashboard {
                                                                                transition: transform 0.3s ease;
                                                                            }

                                                                            /* Calendar styles */
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

                                                                            .day,
                                                                            .date {
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
                                                                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                                                                                padding: 20px;
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

                                                                            /* Patient waiting styles */
                                                                            .visit-count {
                                                                                max-height: 300px;
                                                                                overflow-y: auto;
                                                                                padding-right: 5px;
                                                                            }

                                                                            .patient-list {
                                                                                max-height: 200px;
                                                                                overflow-y: auto;
                                                                                padding-right: 5px;
                                                                                margin-bottom: 15px;
                                                                            }

                                                                            .patient {
                                                                                display: flex;
                                                                                align-items: center;
                                                                                padding: 10px;
                                                                                margin: 5px 0;
                                                                                border-radius: 8px;
                                                                                background: #f8f9fa;
                                                                            }

                                                                            .patient .avatar {
                                                                                width: 40px;
                                                                                height: 40px;
                                                                                border-radius: 50%;
                                                                                margin-right: 10px;
                                                                            }

                                                                            .patient .info {
                                                                                flex: 1;
                                                                            }

                                                                            .patient .name {
                                                                                font-weight: bold;
                                                                                margin-bottom: 5px;
                                                                            }

                                                                            .patient .details {
                                                                                font-size: 12px;
                                                                                color: #666;
                                                                            }

                                                                            .status-btn {
                                                                                padding: 5px 10px;
                                                                                border: none;
                                                                                border-radius: 4px;
                                                                                background: #28a745;
                                                                                color: white;
                                                                                font-size: 12px;
                                                                            }

                                                                            /* Doctor card styles */
                                                                            .doctor-card {
                                                                                background: white;
                                                                                border-radius: 12px;
                                                                                padding: 20px;
                                                                                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                                                            }

                                                                            .card-header {
                                                                                display: flex;
                                                                                justify-content: space-between;
                                                                                align-items: center;
                                                                                margin-bottom: 20px;
                                                                            }

                                                                            .doctor-avatar {
                                                                                width: 60px;
                                                                                height: 60px;
                                                                                border-radius: 50%;
                                                                            }

                                                                            .settings-btn {
                                                                                background: #f8f9fa;
                                                                                border: none;
                                                                                padding: 8px 12px;
                                                                                border-radius: 6px;
                                                                                cursor: pointer;
                                                                            }

                                                                            .doctor-name {
                                                                                color: #2c3e50;
                                                                                margin-bottom: 15px;
                                                                            }

                                                                            .card-body p {
                                                                                margin: 10px 0;
                                                                                color: #5a6c7d;
                                                                            }

                                                                            .card-body i {
                                                                                margin-right: 8px;
                                                                                color: #3498db;
                                                                            }

                                                                            /* Status card styles */
                                                                            .status-card {
                                                                                background: white;
                                                                                border-radius: 12px;
                                                                                padding: 20px;
                                                                            }

                                                                            .toggle-container {
                                                                                display: flex;
                                                                                align-items: center;
                                                                                margin: 15px 0;
                                                                            }

                                                                            .toggle-switch {
                                                                                position: relative;
                                                                                display: inline-block;
                                                                                width: 60px;
                                                                                height: 34px;
                                                                                margin-right: 15px;
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
                                                                                transition: .4s;
                                                                                border-radius: 34px;
                                                                            }

                                                                            .slider:before {
                                                                                position: absolute;
                                                                                content: "";
                                                                                height: 26px;
                                                                                width: 26px;
                                                                                left: 4px;
                                                                                bottom: 4px;
                                                                                background-color: white;
                                                                                transition: .4s;
                                                                                border-radius: 50%;
                                                                            }

                                                                            input:checked+.slider {
                                                                                background-color: #2196F3;
                                                                            }

                                                                            input:checked+.slider:before {
                                                                                transform: translateX(26px);
                                                                            }

                                                                            .status-label {
                                                                                font-weight: bold;
                                                                                color: #2c3e50;
                                                                            }

                                                                            .note {
                                                                                background: #e3f2fd;
                                                                                padding: 15px;
                                                                                border-radius: 8px;
                                                                                margin-top: 15px;
                                                                                font-size: 14px;
                                                                                color: #1565c0;
                                                                            }

                                                                            /* Consultation styles */
                                                                            .consultations {
                                                                                background: white;
                                                                                border-radius: 12px;
                                                                                padding: 20px;
                                                                                max-height: 300px;
                                                                                overflow-y: auto;
                                                                            }

                                                                            .consultation-list {
                                                                                max-height: 220px;
                                                                                overflow-y: auto;
                                                                                padding-right: 5px;
                                                                            }

                                                                            .consultation-title {
                                                                                color: #2c3e50;
                                                                                margin-bottom: 20px;
                                                                            }

                                                                            .consultation-item {
                                                                                display: flex;
                                                                                align-items: center;
                                                                                padding: 10px;
                                                                                margin: 10px 0;
                                                                                border-radius: 8px;
                                                                                background: #f8f9fa;
                                                                            }

                                                                            .consultation-avatar {
                                                                                width: 40px;
                                                                                height: 40px;
                                                                                border-radius: 50%;
                                                                                margin-right: 15px;
                                                                            }

                                                                            .consultation-content {
                                                                                flex: 1;
                                                                            }

                                                                            .consultation-name {
                                                                                font-weight: bold;
                                                                                margin-bottom: 5px;
                                                                                color: #2c3e50;
                                                                            }

                                                                            .consultation-message {
                                                                                font-size: 13px;
                                                                                color: #666;
                                                                                line-height: 1.4;
                                                                            }

                                                                            /* Recent bookings styles */
                                                                            .recent-bookings {
                                                                                background: white;
                                                                                border-radius: 12px;
                                                                                padding: 20px;
                                                                                max-height: 300px;
                                                                                overflow-y: auto;
                                                                            }

                                                                            .booking-list {
                                                                                max-height: 200px;
                                                                                overflow-y: auto;
                                                                                padding-right: 5px;
                                                                                margin-bottom: 15px;
                                                                            }

                                                                            .booking-title {
                                                                                color: #2c3e50;
                                                                                margin-bottom: 20px;
                                                                            }

                                                                            .booking-item {
                                                                                display: flex;
                                                                                align-items: center;
                                                                                padding: 12px;
                                                                                margin: 10px 0;
                                                                                border-radius: 8px;
                                                                                background: #f8f9fa;
                                                                            }

                                                                            .booking-avatar {
                                                                                width: 45px;
                                                                                height: 45px;
                                                                                border-radius: 50%;
                                                                                margin-right: 15px;
                                                                            }

                                                                            .booking-info {
                                                                                flex: 1;
                                                                            }

                                                                            .booking-name {
                                                                                font-weight: bold;
                                                                                margin-bottom: 5px;
                                                                                color: #2c3e50;
                                                                            }

                                                                            .booking-time {
                                                                                font-size: 12px;
                                                                                color: #666;
                                                                            }

                                                                            .booking-slot {
                                                                                text-align: right;
                                                                            }

                                                                            .booking-time-slot {
                                                                                background: #28a745;
                                                                                color: white;
                                                                                padding: 4px 8px;
                                                                                border-radius: 4px;
                                                                                font-size: 11px;
                                                                                display: block;
                                                                                margin-bottom: 5px;
                                                                            }

                                                                            .view-all {
                                                                                display: inline-block;
                                                                                margin-top: 15px;
                                                                                padding: 8px 15px;
                                                                                background: #007bff;
                                                                                color: white;
                                                                                text-decoration: none;
                                                                                border-radius: 6px;
                                                                                font-size: 14px;
                                                                            }

                                                                            .view-all:hover {
                                                                                background: #0056b3;
                                                                            }

                                                                            /* Custom Scrollbar Styles */
                                                                            .patient-list::-webkit-scrollbar,
                                                                            .consultation-list::-webkit-scrollbar,
                                                                            .booking-list::-webkit-scrollbar,
                                                                            .visit-count::-webkit-scrollbar,
                                                                            .consultations::-webkit-scrollbar,
                                                                            .recent-bookings::-webkit-scrollbar {
                                                                                width: 6px;
                                                                            }

                                                                            .patient-list::-webkit-scrollbar-track,
                                                                            .consultation-list::-webkit-scrollbar-track,
                                                                            .booking-list::-webkit-scrollbar-track,
                                                                            .visit-count::-webkit-scrollbar-track,
                                                                            .consultations::-webkit-scrollbar-track,
                                                                            .recent-bookings::-webkit-scrollbar-track {
                                                                                background: #f1f1f1;
                                                                                border-radius: 10px;
                                                                            }

                                                                            .patient-list::-webkit-scrollbar-thumb,
                                                                            .consultation-list::-webkit-scrollbar-thumb,
                                                                            .booking-list::-webkit-scrollbar-thumb,
                                                                            .visit-count::-webkit-scrollbar-thumb,
                                                                            .consultations::-webkit-scrollbar-thumb,
                                                                            .recent-bookings::-webkit-scrollbar-thumb {
                                                                                background: #c1c1c1;
                                                                                border-radius: 10px;
                                                                            }

                                                                            .patient-list::-webkit-scrollbar-thumb:hover,
                                                                            .consultation-list::-webkit-scrollbar-thumb:hover,
                                                                            .booking-list::-webkit-scrollbar-thumb:hover,
                                                                            .visit-count::-webkit-scrollbar-thumb:hover,
                                                                            .consultations::-webkit-scrollbar-thumb:hover,
                                                                            .recent-bookings::-webkit-scrollbar-thumb:hover {
                                                                                background: #a8a8a8;
                                                                            }
                                                                        </style>
                                                                    </head>

                                                                    <body>
                                                                        <div class="dashboard">
                                                                            <!-- Calendar Section -->
                                                                            <div class="calendar">
                                                                                <div class="calendar-header">Tháng 6
                                                                                    2025</div>
                                                                                <div class="calendar-grid">
                                                                                    <div class="day">CN</div>
                                                                                    <div class="day">T2</div>
                                                                                    <div class="day">T3</div>
                                                                                    <div class="day">T4</div>
                                                                                    <div class="day">T5</div>
                                                                                    <div class="day">T6</div>
                                                                                    <div class="day">T7</div>

                                                                                    <div class="calendar-empty"></div>
                                                                                    <div class="calendar-empty"></div>
                                                                                    <div class="calendar-empty"></div>
                                                                                    <div class="calendar-empty"></div>
                                                                                    <div class="calendar-empty"></div>
                                                                                    <div class="calendar-empty"></div>
                                                                                    <div class="date">1</div>

                                                                                    <div class="date">2</div>
                                                                                    <div class="date">3</div>
                                                                                    <div class="date">4</div>
                                                                                    <div class="date">5</div>
                                                                                    <div class="date">6</div>
                                                                                    <div class="date">7</div>
                                                                                    <div class="date">8</div>

                                                                                    <div class="date">9</div>
                                                                                    <div class="date">10</div>
                                                                                    <div class="date">11</div>
                                                                                    <div class="date">12</div>
                                                                                    <div class="date">13</div>
                                                                                    <div class="date">14</div>
                                                                                    <div class="date">15</div>

                                                                                    <div class="date">16</div>
                                                                                    <div class="date">17</div>
                                                                                    <div class="date">18</div>
                                                                                    <div class="date">19</div>
                                                                                    <div class="date">20</div>
                                                                                    <div class="date">21</div>
                                                                                    <div class="date">22</div>

                                                                                    <div class="date">23</div>
                                                                                    <div class="date">24</div>
                                                                                    <div class="date today">25</div>
                                                                                    <div class="date">26</div>
                                                                                    <div class="date">27</div>
                                                                                    <div class="date">28</div>
                                                                                    <div class="date">29</div>

                                                                                    <div class="date">30</div>
                                                                                </div>
                                                                                <div class="time-now">Hôm nay:
                                                                                    25/06/2025 - 20:12</div>
                                                                            </div>

                                                                            <!-- Waiting Patients Section -->
                                                                            <div class="visit-count">
                                                                                <h4>Danh sách bệnh nhân đang chờ khám (
                                                                                    <%= waitingPatients !=null ?
                                                                                        waitingPatients.size() : 0 %>)
                                                                                </h4>

                                                                                <div class="patient-list">
                                                                                    <% if (waitingPatients !=null &&
                                                                                        !waitingPatients.isEmpty()) {
                                                                                        for (Map<String, Object>
                                                                                        patientData : waitingPatients) {
                                                                                        %>
                                                                                        <div class="patient">
                                                                                            <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                                alt="<%=patientData.get("name")%>"
                                                                                            class="avatar">
                                                                                            <div class="info">
                                                                                                <div class="name">
                                                                                                    <%=patientData.get("name")%>
                                                                                                </div>
                                                                                                <div class="details">
                                                                                                    <%=patientData.get("gender")%>
                                                                                                        •
                                                                                                        <%=patientData.get("age")%>
                                                                                                            Tuổi
                                                                                                </div>
                                                                                            </div>
                                                                                            <button class="status-btn">
                                                                                                <%=patientData.get("status")%>
                                                                                            </button>
                                                                                        </div>
                                                                                        <% } } else { %>
                                                                                            <div class="patient">
                                                                                                <div class="info">
                                                                                                    <div class="name">
                                                                                                        Không
                                                                                                        có bệnh nhân
                                                                                                        đang
                                                                                                        chờ</div>
                                                                                                    <div
                                                                                                        class="details">
                                                                                                        Hôm
                                                                                                        nay chưa có lịch
                                                                                                        hẹn
                                                                                                        nào</div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } %>
                                                                                </div>

                                                                                <a href="<%=request.getContextPath()%>/DoctorAppointmentsToanServlet"
                                                                                    class="view-all">Xem tất
                                                                                    cả</a>
                                                                            </div>

                                                                            <!-- Status Card Section -->
                                                                            <div class="on-duty">
                                                                                <div class="status-card">
                                                                                    <h4>Cập nhật trạng thái</h4>
                                                                                    <p>Cho người khác biết là bạn hiện
                                                                                        đang có mặt tại phòng khám.</p>

                                                                                    <div class="toggle-container">
                                                                                        <label class="toggle-switch">
                                                                                            <input type="checkbox"
                                                                                                checked>
                                                                                            <span class="slider"></span>
                                                                                        </label>
                                                                                        <span class="status-label">Hiện
                                                                                            đang trực</span>
                                                                                    </div>

                                                                                    <div class="note">
                                                                                        <strong>Lưu ý</strong><br>
                                                                                        Người sử dụng hệ thống sẽ dễ
                                                                                        dàng đặt lịch khám hoặc yêu cầu
                                                                                        tư vấn hơn khi có bác sĩ đang
                                                                                        trực!
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <!-- Doctor Info Section -->
                                                                            <div class="user-info">
                                                                                <div class="doctor-card">
                                                                                    <div class="card-header">
                                                                                        <img src="doctor.jpg"
                                                                                            alt="Doctor Avatar"
                                                                                            class="doctor-avatar">
                                                                                        <button class="settings-btn">Cài
                                                                                            đặt ⚙️</button>
                                                                                    </div>
                                                                                    <div class="card-body">
                                                                                        <% if (doctor !=null) { %>
                                                                                            <h2 class="doctor-name">
                                                                                                <%= doctor.getFullName()
                                                                                                    %>
                                                                                            </h2>
                                                                                            <p><i
                                                                                                    class="fa-solid fa-venus-mars"></i>Giới
                                                                                                tính: <%=
                                                                                                    doctor.getGender()
                                                                                                    %>
                                                                                            </p>
                                                                                            <p><i
                                                                                                    class="fa-solid fa-user-doctor"></i>Chức
                                                                                                vụ: Thạc Sĩ - Bác sĩ</p>
                                                                                            <p><i
                                                                                                    class="fa-solid fa-stethoscope"></i>Chuyên
                                                                                                khoa: <%=
                                                                                                    doctor.getSpecialty()
                                                                                                    %>
                                                                                            </p>
                                                                                            <p><i
                                                                                                    class="fa-solid fa-phone"></i>Số
                                                                                                điện thoại: <%=
                                                                                                    doctor.getPhone() %>
                                                                                            </p>
                                                                                            <% } else { %>
                                                                                                <h2 class="doctor-name">
                                                                                                    Không tìm thấy thông
                                                                                                    tin bác sĩ</h2>
                                                                                                <% } %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <!-- Consultations Section -->
                                                                            <div class="consultations">
                                                                                <h4 class="consultation-title">Yêu cầu
                                                                                    tư vấn</h4>

                                                                                <div class="consultation-list">
                                                                                    <div class="consultation-item">
                                                                                        <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                            alt="Nguyễn Mai Phương"
                                                                                            class="consultation-avatar">
                                                                                        <div
                                                                                            class="consultation-content">
                                                                                            <div
                                                                                                class="consultation-name">
                                                                                                Nguyễn Mai Phương</div>
                                                                                            <div
                                                                                                class="consultation-message">
                                                                                                Hiện tại em đang muốn
                                                                                                khám
                                                                                                tổng quát, bác sĩ có
                                                                                                thể...
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>

                                                                                    <div class="consultation-item">
                                                                                        <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                            alt="Nguyễn Mai Phương"
                                                                                            class="consultation-avatar">
                                                                                        <div
                                                                                            class="consultation-content">
                                                                                            <div
                                                                                                class="consultation-name">
                                                                                                Nguyễn Mai Phương</div>
                                                                                            <div
                                                                                                class="consultation-message">
                                                                                                Hiện tại em đang muốn
                                                                                                khám
                                                                                                tổng quát, bác sĩ có
                                                                                                thể...
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>

                                                                                    <div class="consultation-item">
                                                                                        <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                            alt="Lê Đại Hoàng"
                                                                                            class="consultation-avatar">
                                                                                        <div
                                                                                            class="consultation-content">
                                                                                            <div
                                                                                                class="consultation-name">
                                                                                                Lê Đại Hoàng</div>
                                                                                            <div
                                                                                                class="consultation-message">
                                                                                                Tư vấn giúp em về tình
                                                                                                hình
                                                                                                sức khỏe hiện tại của
                                                                                                em...
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- Thêm các mục khác để test scroll -->
                                                                                    <div class="consultation-item">
                                                                                        <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                            alt="Trần Văn An"
                                                                                            class="consultation-avatar">
                                                                                        <div
                                                                                            class="consultation-content">
                                                                                            <div
                                                                                                class="consultation-name">
                                                                                                Trần Văn An</div>
                                                                                            <div
                                                                                                class="consultation-message">
                                                                                                Cần tư vấn về phương
                                                                                                pháp điều trị...
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>

                                                                                    <div class="consultation-item">
                                                                                        <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                            alt="Phạm Thị Lan"
                                                                                            class="consultation-avatar">
                                                                                        <div
                                                                                            class="consultation-content">
                                                                                            <div
                                                                                                class="consultation-name">
                                                                                                Phạm Thị Lan</div>
                                                                                            <div
                                                                                                class="consultation-message">
                                                                                                Muốn hỏi về lịch khám...
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <!-- Recent Bookings Section -->
                                                                            <div class="recent-visits">
                                                                                <div class="recent-bookings">
                                                                                    <h4 class="booking-title">Lịch đã
                                                                                        được đặt gần đây</h4>

                                                                                    <div class="booking-list">
                                                                                        <% if (recentBookings !=null &&
                                                                                            !recentBookings.isEmpty()) {
                                                                                            for (Map<String, Object>
                                                                                            booking :
                                                                                            recentBookings) {
                                                                                            SimpleDateFormat sdf = new
                                                                                            SimpleDateFormat("dd/MM/yyyy");
                                                                                            %>
                                                                                            <div class="booking-item">
                                                                                                <img src="<%=request.getContextPath()%>/img/bacsi.png"
                                                                                                    alt="<%=booking.get("name")%>"
                                                                                                class="booking-avatar">
                                                                                                <div
                                                                                                    class="booking-info">
                                                                                                    <div
                                                                                                        class="booking-name">
                                                                                                        <%=booking.get("name")%>
                                                                                                    </div>
                                                                                                    <div
                                                                                                        class="booking-time">
                                                                                                    </div>
                                                                                                </div>
                                                                                                <div
                                                                                                    class="booking-slot">
                                                                                                    <span
                                                                                                        class="booking-time-slot">
                                                                                                        Slot
                                                                                                        <%=booking.get("appointment")
                                                                                                            !=null ?
                                                                                                            ((model.Appointment)booking.get("appointment")).getSlotId()
                                                                                                            : "N/A" %> |
                                                                                                            <%=booking.get("appointmentDate")
                                                                                                                !=null ?
                                                                                                                sdf.format(booking.get("appointmentDate"))
                                                                                                                : "N/A"
                                                                                                                %>
                                                                                                    </span>
                                                                                                    <div
                                                                                                        style="color: white; font-size: 12px;">
                                                                                                        <%=booking.get("status")%>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } } else { %>
                                                                                                <div
                                                                                                    class="booking-item">
                                                                                                    <div
                                                                                                        class="booking-info">
                                                                                                        <div
                                                                                                            class="booking-name">
                                                                                                            Chưa có lịch
                                                                                                            hẹn
                                                                                                            gần đây
                                                                                                        </div>
                                                                                                        <div
                                                                                                            class="booking-time">
                                                                                                            Không có dữ
                                                                                                            liệu
                                                                                                            trong 7 ngày
                                                                                                            qua
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                                <% } %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <script src="js/calendar.js"></script>
                                                                    </body>

                                                                    </html>