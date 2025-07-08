<%-- 
    Document   : doctor_ketqua
    Created on : May 24, 2025, 4:03:11 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="doctor_header.jsp" %>
<%@ include file="doctor_menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">
   <head>
    <meta charset="UTF-8">
    <title>Kết quả khám</title>
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

        .stats-row {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
            min-width: 120px;
        }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #10b981;
        }

        .stat-label {
            font-size: 14px;
            color: #6b7280;
            margin-top: 5px;
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
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
            background-color: #10b981; /* màu xanh lá cho "hoàn thành" */
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: bold;
        }

        .result-btn {
            background-color: #3b82f6;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 13px;
            cursor: pointer;
            margin-top: 8px;
            text-decoration: none;
            display: inline-block;
        }

        .result-btn:hover {
            background-color: #2563eb;
        }

        .no-appointments {
            text-align: center;
            padding: 40px;
            color: #6b7280;
            grid-column: 1 / -1;
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
        <h2>Kết quả khám bệnh</h2>
        <input type="text" placeholder="Tìm theo mã hẹn, ngày khám..." class="search-input" id="searchInput" onkeyup="searchCompletedAppointments()"/>
    </div>

    <%
        // Lấy dữ liệu từ servlet
        List<Appointment> completedAppointments = (List<Appointment>) request.getAttribute("completedAppointments");
        String error = (String) request.getAttribute("error");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        int totalCompleted = (completedAppointments != null) ? completedAppointments.size() : 0;
        
    %>

    

    <!-- Hiển thị lỗi nếu có -->
    <% if (error != null) { %>
        <div class="error-message">
            <strong>Lỗi:</strong> <%= error %>
        </div>
    <% } %>

    <div class="cards" id="appointmentCards">
        <% 
        System.out.println("=== RENDER CARDS DEBUG ===");
        System.out.println("Starting to render cards...");
        System.out.println("completedAppointments != null: " + (completedAppointments != null));
        if (completedAppointments != null) {
            System.out.println("completedAppointments.isEmpty(): " + completedAppointments.isEmpty());
            System.out.println("completedAppointments.size(): " + completedAppointments.size());
        }
        
        try {
            if (completedAppointments != null && !completedAppointments.isEmpty()) {
                System.out.println("Entering foreach loop...");
                int cardIndex = 0;
                for (Appointment appointment : completedAppointments) {
                    cardIndex++;
                    System.out.println("Rendering card " + cardIndex + " for appointment ID: " + appointment.getAppointmentId());
                    
                    try {
                        // Safely get time slot
                        String timeSlot = "N/A";
                        try {
                            if (appointment.getStartTime() != null && appointment.getEndTime() != null) {
                                timeSlot = appointment.getStartTime() + " - " + appointment.getEndTime();
                            }
                        } catch (Exception e) {
                            System.err.println("Error getting time slot for appointment " + appointment.getAppointmentId() + ": " + e.getMessage());
                            timeSlot = "Error loading time";
                        }
                        
                        // Safely get work date
                        String workDateString = "N/A";
                        try {
                            if (appointment.getWorkDate() != null) {
                                workDateString = appointment.getFormattedDate();
                            }
                        } catch (Exception e) {
                            System.err.println("Error formatting date for appointment " + appointment.getAppointmentId() + ": " + e.getMessage());
                            workDateString = "Error loading date";
                        }
                        
                        System.out.println("Card " + cardIndex + " data: timeSlot=" + timeSlot + ", workDate=" + workDateString + ", patientName=" + appointment.getPatientName());
        %>
        
        <div class="card"">                                 
            <div class="time"><%= timeSlot %> | <%= workDateString %></div>
            <div class="card-body">
                <img src="images/default-avatar.png" alt="avatar" class="avatar" 
                     onerror="this.src='data:image/svg+xml,<svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;64&quot; height=&quot;64&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;%23ccc&quot;><path d=&quot;M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z&quot;/></svg>'"/>
                <div class="info">
                    <strong>Bệnh nhân: <%= appointment.getPatientName() != null ? appointment.getPatientName() : "Không có tên" %></strong><br />
                    <span>Mã cuộc hẹn:</span> <%= appointment.getAppointmentId() %><br />
                    <span>Ngày khám:</span> <%= workDateString %><br />
                    <p class="desc">Lý do khám: <%= appointment.getReason() != null ? appointment.getReason() : "Khám tổng quát" %></p>
                </div>
                <div class="actions">
                    <span class="status">Hoàn thành</span>
                    <a href="${pageContext.request.contextPath}/ViewReportServlet?appointmentId=<%=appointment.getAppointmentId()%>" class="result-btn">
                        Xem kết quả
                    </a>
                </div>
            </div>
        </div>
        
        <% 
                        System.out.println("Finished rendering card " + cardIndex);
                    } catch (Exception e) {
                        System.err.println("❌ Error rendering card " + cardIndex + ": " + e.getMessage());
                        e.printStackTrace();
                        // Hiển thị error card
        %>
                        <div class="card" style="border: 2px solid #dc3545; background: #f8d7da;">
                            <div style="padding: 10px; color: #721c24;">
                                ❌ Error rendering card <%= cardIndex %>: <%= e.getMessage() %>
                            </div>
                        </div>
        <%
                    }
                }
                System.out.println("Finished foreach loop. Total cards rendered: " + cardIndex);
            } else {
                System.out.println("No appointments to render - showing no-appointments message");
        %>
            <div class="no-appointments">
                <i class="fas fa-clipboard-check"></i>
                <h4>Chưa có kết quả khám nào</h4>
                <p>Danh sách kết quả khám sẽ hiển thị sau khi hoàn thành các cuộc hẹn.</p>
                
                <!-- ✅ THÊM DEBUG INFO -->
                <div style="background: #fff3cd; border: 1px solid #ffeeba; padding: 15px; margin: 20px 0; border-radius: 8px; text-align: left;">
                    <strong>🔧 Troubleshooting:</strong>
                    <ul style="margin: 10px 0; text-align: left;">
                        <li>Appointments cần có status: "COMPLETED", "completed", "Hoàn thành", hoặc "Đã khám"</li>
                        <li>Hiện tại filter đang tìm: <%= request.getAttribute("completedAppointments") != null ? "có data" : "null data" %></li>
                        <li>URL hiện tại: <%= request.getRequestURL() %></li>
                    </ul>
                </div>
            </div>
        <% 
            }
        } catch (Exception e) {
            System.err.println("❌ MAJOR ERROR in cards rendering: " + e.getMessage());
            e.printStackTrace();
        %>
            <div class="error-message">
                <strong>❌ Lỗi nghiêm trọng khi hiển thị cards:</strong> <%= e.getMessage() %>
                <br><small>Chi tiết: <%= e.getClass().getSimpleName() %></small>
            </div>
        <% } %>
    </div>
</div>

<script>
    function searchCompletedAppointments() {
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

