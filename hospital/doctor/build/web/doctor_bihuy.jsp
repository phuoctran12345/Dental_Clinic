<%-- 
    Document   : doctor_bihuy
    Created on : May 24, 2025, 4:03:11 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Appointment"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Các lượt khám bị hủy</title>
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

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            h2 {
                color: #1e293b;
            }

            .search-input {
                padding: 8px 12px;
                border-radius: 8px;
                border: 1px solid #cbd5e1;
                width: 240px;
            }

            .cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
                gap: 16px;
            }

            .card {
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
                padding: 16px;
            }

            .time {
                font-weight: bold;
                color: #0f172a;
                margin-bottom: 12px;
            }

            .card-body {
                display: flex;
                gap: 16px;
            }

            .avatar {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                object-fit: cover;
            }

            .info {
                flex: 1;
                font-size: 14px;
                color: #334155;
            }

            .info .desc {
                margin-top: 8px;
                color: #64748b;
            }

            .actions {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                align-items: flex-end;
            }

            .status {
                background-color: #ef4444;
                color: white;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: bold;
            }

            .notify-btn {
                background-color: #3b82f6;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 13px;
                cursor: pointer;
                margin-top: 8px;
            }

            .notify-btn:hover {
                background-color: #2563eb;
            }

            .no-appointments {
                text-align: center;
                padding: 40px;
                color: #6b7280;
            }

            .no-appointments i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #d1d5db;
            }

            .error-message {
                background-color: #fee2e2;
                border: 1px solid #fecaca;
                color: #991b1b;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h2>Các lượt khám bị hủy bỏ</h2>
                <input type="text" placeholder="Tìm lượt khám bị hủy" class="search-input" id="searchInput" onkeyup="searchCancelledAppointments()"/>
            </div>

            <%
                // Lấy dữ liệu từ servlet
                List<Appointment> cancelledAppointments = (List<Appointment>) request.getAttribute("cancelledAppointments");
                String error = (String) request.getAttribute("error");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            %>

            <!-- Hiển thị lỗi nếu có -->
            <% if (error != null) { %>
                <div class="error-message">
                    <strong>Lỗi:</strong> <%= error %>
                </div>
            <% } %>

            <div class="cards" id="appointmentCards">
                <% 
                if (cancelledAppointments != null && !cancelledAppointments.isEmpty()) {
                    for (Appointment appointment : cancelledAppointments) {
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
                        
                        String workDateString = (appointment.getWorkDate() != null) ? 
                            dateFormat.format(appointment.getWorkDate()) : "N/A";
                %>
                
                <div class="card">
                    <div class="time"><%= timeSlot %> | <%= workDateString %></div>
                    <div class="card-body">
                        <img src="images/default-avatar.png" alt="avatar" class="avatar" 
                             onerror="this.src='data:image/svg+xml,<svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;64&quot; height=&quot;64&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;%23ccc&quot;><path d=&quot;M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z&quot;/></svg>'"/>
                        <div class="info">
                            <strong>Bệnh nhân ID: <%= appointment.getPatientId() %></strong><br />
                            <span>Mã cuộc hẹn:</span> #<%= appointment.getAppointmentId() %><br />
                            <span>Ngày khám:</span> <%= workDateString %><br />
                            <p class="desc">Lý do: <%= appointment.getReason() != null ? appointment.getReason() : "Không có ghi chú" %></p>
                        </div>
                        <div class="actions">
                            <span class="status">Đã hủy</span>
                            <form action="sendNotification" method="post">
                                <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>" />
                                <button type="submit" class="notify-btn">Gửi thông báo</button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <% 
                    }
                } else {
                %>
                    <div class="no-appointments">
                        <i class="fas fa-calendar-times"></i>
                        <h4>Không có lượt khám nào bị hủy</h4>
                        <p>Tất cả các cuộc hẹn đều được thực hiện theo kế hoạch.</p>
                    </div>
                <% } %>
            </div>
        </div>

        <script>
            function searchCancelledAppointments() {
                const input = document.getElementById('searchInput');
                const filter = input.value.toLowerCase();
                const cards = document.getElementById('appointmentCards').getElementsByClassName('card');
                
                for (let i = 0; i < cards.length; i++) {
                    const card = cards[i];
                    const text = card.textContent || card.innerText;
                    
                    if (text.toLowerCase().indexOf(filter) > -1) {
                        card.style.display = "";
                    } else {
                        card.style.display = "none";
                    }
                }
            }
        </script>
    </body>
</html>

