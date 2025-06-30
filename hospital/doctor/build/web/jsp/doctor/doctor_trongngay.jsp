<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Appointment"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ include file="doctor_header.jsp" %>
<%@ include file="doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lượt khám hôm nay</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: auto;
            }
            .container {
                font-family: Arial, sans-serif;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 50px;
                min-height: 100vh;
            }
            #menu-toggle:checked ~.container {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .title{
                display: flex;
                margin-bottom: 10px;
                justify-content: space-between;
                align-items: center;
                gap: 20px;
            }

            .title-1, .title-2{
                flex: 1;
                text-align: center;
            }

            .title-1 h3, .title-2 h3 {
                margin: 0;
                padding: 10px;
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                color: white;
                border-radius: 8px;
                font-size: 16px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .title-1 h3 {
                background: linear-gradient(135deg, #f59e0b, #d97706);
            }

            .title-2 h3 {
                background: linear-gradient(135deg, #10b981, #059669);
            }
            .content {
                margin-bottom: 15px;
            }

            .content p {
                color: #3b82f6;
            }

            /* Debug info styles */
            .debug-info {
                background-color: #e3f2fd;
                border: 1px solid #2196f3;
                border-radius: 8px;
                padding: 10px;
                margin-bottom: 20px;
                font-size: 12px;
            }

            .debug-info h5 {
                color: #1976d2;
                margin: 0 0 10px 0;
            }

            .alert {
                padding: 12px;
                margin-bottom: 20px;
                border-radius: 4px;
                border: 1px solid transparent;
            }

            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }

            .alert-info {
                color: #0c5460;
                background-color: #d1ecf1;
                border-color: #bee5eb;
            }

            .badge-test {
                background-color: #ffc107;
                color: #212529;
                padding: 2px 6px;
                border-radius: 4px;
                font-size: 10px;
                font-weight: bold;
                margin-left: 5px;
            }

            .status-filter {
                margin-top: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .cards {
                display: flex;
                gap: 20px;
                min-height: 400px;
                align-items: stretch;
            }

            .cards-column {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 20px;
                min-height: 400px;
                max-width: calc(50% - 10px);
            }

            .single-card {
                background-color: #fff;
                padding: 16px;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                transition: transform 0.2s ease;
                height: fit-content;
                min-height: 200px;
            }

            .single-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }
            .badge.waiting {
                background-color: #dbeafe;
                color: #2563eb;
            }
            .badge.done {
                background-color: #bbf7d0;
                color: #15803d;
            }
            .badge.cancelled {
                background-color: #fecaca;
                color: #dc2626;
            }
            .info {
                display: flex;
                margin-top: 12px;
                gap: 12px;
            }
            .info img {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                object-fit: cover;
            }
            .info-details {
                flex: 1;
            }
            .info-details p {
                margin: 4px 0;
                font-size: 14px;
            }
            .actions {
                margin-top: 12px;
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }
            .actions button, .actions a {
                padding: 6px 12px;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.2s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }
            .btn-blue {
                background-color: #2563eb;
                color: white;
            }
            .btn-blue:hover {
                background-color: #1d4ed8;
            }
            .btn-green {
                background-color: #16a34a;
                color: white;
            }
            .btn-green:hover {
                background-color: #15803d;
            }
            .btn-red {
                background-color: #dc2626;
                color: white;
            }
            .btn-red:hover {
                background-color: #b91c1c;
            }
            .btn-gray {
                background-color: #e5e7eb;
                color: #111827;
            }
            .btn-gray:hover {
                background-color: #d1d5db;
            }

            .no-appointments {
                text-align: center;
                padding: 40px;
                color: #6b7280;
                background-color: #f9fafb;
                border-radius: 12px;
                border: 2px dashed #e5e7eb;
                min-height: 150px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }

            .no-appointments i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #d1d5db;
            }

            .no-appointments h4 {
                margin: 0 0 8px 0;
                color: #6b7280;
            }

            .no-appointments p {
                margin: 0;
                font-size: 14px;
                color: #9ca3af;
            }

            .stats {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
            }

            .stat-card {
                background: white;
                padding: 16px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                flex: 1;
                text-align: center;
                cursor: pointer;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .stat-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .stat-card.clickable {
                cursor: pointer;
            }

            .stat-card.completed {
                border-left: 4px solid #10b981;
                position: relative;
            }

            .stat-card.completed::after {
                content: "👆 Click để xem kết quả";
                position: absolute;
                bottom: -5px;
                left: 50%;
                transform: translateX(-50%);
                font-size: 10px;
                color: #10b981;
                opacity: 0;
                transition: opacity 0.2s ease;
            }

            .stat-card.completed:hover::after {
                opacity: 1;
            }

            .stat-number {
                font-size: 24px;
                font-weight: bold;
                color: #2563eb;
            }

            .stat-label {
                font-size: 14px;
                color: #6b7280;
                margin-top: 4px;
            }

        </style>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <div class="container">

            <%
                // Lấy dữ liệu từ servlet
                List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                String error = (String) request.getAttribute("error");
                Boolean testMode = (Boolean) request.getAttribute("testMode");
                String testReason = (String) request.getAttribute("testReason");
                Integer userId = (Integer) request.getAttribute("userId");
                
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                Date today = new Date();
                
                // Thống kê
                int totalAppointments = appointments != null ? appointments.size() : 0;
                int waitingCount = 0;
                int completedCount = 0;
                int cancelledCount = 0;
                int todayCount = 0;
                
                if (appointments != null) {
                    for (Appointment app : appointments) {
                        if ("booked".equalsIgnoreCase(app.getStatus())) {
                            waitingCount++;
                        } else if ("completed".equalsIgnoreCase(app.getStatus())) {
                            completedCount++;
                        } else if ("cancelled".equalsIgnoreCase(app.getStatus())) {
                            cancelledCount++;
                        }
                        
                        // Kiểm tra appointment hôm nay
                        if (app.getWorkDate() != null) {
                            Calendar appCal = Calendar.getInstance();
                            appCal.setTime(app.getWorkDate());
                            Calendar todayCal = Calendar.getInstance();
                            todayCal.setTime(today);
                            
                            if (appCal.get(Calendar.YEAR) == todayCal.get(Calendar.YEAR) &&
                                appCal.get(Calendar.DAY_OF_YEAR) == todayCal.get(Calendar.DAY_OF_YEAR)) {
                                todayCount++;
                            }
                        }
                    }
                }
            %>

            <!-- Debug Info -->


            <div class="content">
                <h2>Lượt khám hôm nay</h2>
                <p><%=dateFormat.format(today)%></p>
            </div>

            <!-- Statistics -->
            <div class="stats">
                <div class="stat-card">
                    <div class="stat-number"><%=todayCount%></div>
                    <div class="stat-label">Hôm nay</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%=waitingCount%></div>
                    <div class="stat-label">Đang chờ</div>
                </div>
                <div class="stat-card clickable completed" onclick="viewCompletedAppointments()">
                    <div class="stat-number"><%=completedCount%></div>
                    <div class="stat-label">Đã khám</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%=cancelledCount%></div>
                    <div class="stat-label">Đã hủy</div>
                </div>
            </div>

            <div class="title">
                <div class="title-1">
                    <h3>Đang chờ khám (<%=waitingCount%>)</h3>
                </div>
                <div class="title-2">
                    <h3>Đã khám xong (<%=completedCount%>)</h3>
                </div>
            </div>

            <div class="cards">
                <!-- Cột Đang chờ khám -->
                <div class="cards-column">
                    <%
                        boolean hasWaitingAppointments = false;
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment appointment : appointments) {
                                String status = appointment.getStatus();
                                
                                // Chỉ hiển thị appointments đang chờ (Đã đặt)
                                if ("booked".equalsIgnoreCase(status)) {
                                    hasWaitingAppointments = true;
                                    String badgeClass = "waiting";
                                    String statusText = "Đang chờ";
                                    
                                    // Tạo thời gian dựa trên slot_id
                                    String timeSlot = "";
                                    switch (appointment.getSlotId()) {
                                        case 1: timeSlot = "08:00 - 08:30"; break;
                                        case 2: timeSlot = "08:30 - 09:00"; break;
                                        case 3: timeSlot = "09:00 - 09:30"; break;
                                        case 4: timeSlot = "09:30 - 10:00"; break;
                                        case 5: timeSlot = "10:00 - 10:30"; break;
                                        default: timeSlot = "N/A"; break;
                                    }
                    %>

                    <div class="single-card">
                        <div class="card-header">
                            <p><strong><%=timeSlot%></strong></p>
                            <span class="badge <%=badgeClass%>"><%=statusText%></span>
                        </div>
                        <div class="info">
                            <img src="images/default-avatar.png" alt="avatar" onerror="this.src='data:image/svg+xml,<svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;64&quot; height=&quot;64&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;%23ccc&quot;><path d=&quot;M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z&quot;/></svg>'">
                            <div class="info-details">
                                <p><strong>Bệnh nhân: <%=appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên"%></strong></p>
                                <p>Mã cuộc hẹn: #<%=appointment.getAppointmentId()%></p>
                                <p>Ngày khám: <%=appointment.getWorkDate() != null ? dateFormat.format(appointment.getWorkDate()) : "N/A"%></p>
                                <p>Lý do: <%=appointment.getReason() != null ? appointment.getReason() : "Không có ghi chú"%></p>
                            </div>
                        </div>
                        <div class="actions">
                            <a href="/doctor/jsp/doctor/phieukham.jsp?appointmentId=<%=appointment.getAppointmentId()%>" class="btn-blue">
                                <i class="fas fa-file-medical"></i> Tạo phiếu khám
                            </a>
                            <form method="post" action="/doctor/updateAppointmentStatus" style="display: inline;">
                                <input type="hidden" name="appointmentId" value="<%=appointment.getAppointmentId()%>">
                                <input type="hidden" name="status" value="completed">
                                <button type="submit" class="btn-red" onclick="return confirm('Xác nhận hoàn tất cuộc hẹn #<%=appointment.getAppointmentId()%>?')">
                                    Đang chờ Khám
                                </button>
                            </form>
                            <button class="btn-gray" onclick="viewDetails(<%=appointment.getAppointmentId()%>)" title="Chi tiết">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </div>
                    </div>

                    <%
                                }
                            }
                        }
                        
                        // Nếu không có appointments đang chờ
                        if (!hasWaitingAppointments) {
                    %>
                    <div class="no-appointments">
                        <i class="fas fa-clock"></i>
                        <h4>Không có lịch hẹn đang chờ</h4>

                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Cột Đã khám xong -->
                <div class="cards-column">
                    <%
                        boolean hasCompletedAppointments = false;
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment appointment : appointments) {
                                String status = appointment.getStatus();
                                
                                // Chỉ hiển thị appointments đã hoàn tất
                                if ("completed".equalsIgnoreCase(status)) {
                                    hasCompletedAppointments = true;
                                    String badgeClass = "done";
                                    String statusText = "Khám xong";
                                    
                                    // Tạo thời gian dựa trên slot_id
                                    String timeSlot = "";
                                    switch (appointment.getSlotId()) {
                                        case 1: timeSlot = "08:00 - 08:30"; break;
                                        case 2: timeSlot = "08:30 - 09:00"; break;
                                        case 3: timeSlot = "09:00 - 09:30"; break;
                                        case 4: timeSlot = "09:30 - 10:00"; break;
                                        case 5: timeSlot = "10:00 - 10:30"; break;
                                        default: timeSlot = "N/A"; break;
                                    }
                    %>

                    <div class="single-card">
                        <div class="card-header">
                            <p><strong><%=timeSlot%></strong></p>
                            <span class="badge <%=badgeClass%>"><%=statusText%></span>
                        </div>
                        <div class="info">
                            <img src="images/default-avatar.png" alt="avatar" onerror="this.src='data:image/svg+xml,<svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;64&quot; height=&quot;64&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;%23ccc&quot;><path d=&quot;M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z&quot;/></svg>'">
                            <div class="info-details">
                                <p><strong>Bệnh nhân: <%=appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên"%></strong></p>
                                <p>Mã cuộc hẹn: #<%=appointment.getAppointmentId()%></p>
                                <p>Ngày khám: <%=appointment.getWorkDate() != null ? dateFormat.format(appointment.getWorkDate()) : "N/A"%></p>
                                <p>Lý do: <%=appointment.getReason() != null ? appointment.getReason() : "Không có ghi chú"%></p>
                            </div>
                        </div>
                        <div class="actions">
                            <a href="/doctor/ViewReportServlet?appointmentId=<%=appointment.getAppointmentId()%>" class="btn-gray">
                                <i class="fas fa-eye"></i> Xem phiếu khám
                            </a>
                            <button class="btn-gray" onclick="viewDetails(<%=appointment.getAppointmentId()%>)" title="Chi tiết">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </div>
                    </div>

                    <%
                                }
                            }
                        }
                        
                        // Nếu không có appointments đã hoàn tất
                        if (!hasCompletedAppointments) {
                    %>
                    <div class="no-appointments">
                        <i class="fas fa-check-circle"></i>
                        <h4>Chưa có ca khám hoàn tất</h4>

                    </div>
                    <%
                        }
                    %>
                </div>                          
            </div>
        </div>

        <script>
            // Auto refresh every 5 minutes để cập nhật dữ liệu mới
            setTimeout(function () {
                location.reload();
            }, 300000);
            
            function viewCompletedAppointments() {
                // Chuyển tới trang xem kết quả khám
                window.location.href = '/doctor/completedAppointments';
            }
            
            // Simple hover effects (optional)
            document.addEventListener('DOMContentLoaded', function() {
                // Add any simple effects here if needed
            });
        </script>
    </body>
</html>
