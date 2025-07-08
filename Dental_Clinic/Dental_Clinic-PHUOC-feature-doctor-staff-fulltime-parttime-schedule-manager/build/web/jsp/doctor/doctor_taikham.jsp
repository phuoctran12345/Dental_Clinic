<%-- 
    Document   : doctor_taikham
    Created on : May 24, 2025, 4:49:29 PM
    Author     : ASUS
--%>

<%@page import="model.Appointment"%>
<%@page import="model.TimeSlot"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ include file="doctor_header.jsp" %>
<%@ include file="doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh Sách Tái Khám</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                background-color: #f8f9fa;
            }
            .taikham_container {
                font-family: Arial, sans-serif;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 10px;
                min-height: 100vh;
            }
            #menu-toggle:checked ~.taikham_container {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }

            .taikham-header {
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #2c3e50;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .taikham-search {
                margin-bottom: 25px;
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .taikham-search input {
                width: 300px;
                padding: 12px;
                border-radius: 8px;
                border: 2px solid #e0e0e0;
                font-size: 14px;
            }

            .patient-card-container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                display: flex;
                align-items: center;
                padding: 20px;
                margin-bottom: 20px;
                justify-content: space-between;
                transition: transform 0.2s, box-shadow 0.2s;
                border-left: 5px solid #007bff;
            }

            .patient-card-container:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            }

            .patient-info {
                display: flex;
                align-items: center;
                flex-grow: 1;
            }

            .patient-avatar {
                border-radius: 50%;
                width: 70px;
                height: 70px;
                margin-right: 20px;
                object-fit: cover;
                border: 3px solid #e0e0e0;
            }

            .patient-details {
                font-size: 14px;
                line-height: 1.6;
            }

            .patient-details .patient-name {
                font-size: 18px;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 8px;
                display: block;
            }

            .patient-details .detail-row {
                margin-bottom: 4px;
                color: #666;
            }

            .patient-details .detail-row strong {
                color: #333;
                margin-right: 8px;
            }

            .appointment-info {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-left: 20px;
                min-width: 200px;
            }

            .appointment-info .last-visit {
                font-size: 12px;
                color: #666;
                margin-bottom: 5px;
            }

            .appointment-info .visit-date {
                font-size: 14px;
                font-weight: bold;
                color: #007bff;
            }

            .btn-reexam {
                background: linear-gradient(45deg, #007bff, #0056b3);
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
                margin-left: 15px;
            }

            .btn-reexam:hover {
                background: linear-gradient(45deg, #0056b3, #004085);
                transform: scale(1.05);
            }

            .reexam-popup {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                border: none;
                padding: 25px;
                border-radius: 15px;
                width: 450px;
                display: none;
                z-index: 1000;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }

            .popup-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 999;
                display: none;
            }

            .popup-header {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #2c3e50;
                text-align: center;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 600;
                color: #555;
            }

            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 2px solid #e0e0e0;
                font-size: 14px;
                box-sizing: border-box;
            }

            .popup-button-group {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }

            .popup-button-group button {
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                flex: 1;
                margin: 0 5px;
            }

            .btn-cancel {
                background: #dc3545;
                color: white;
            }

            .btn-cancel:hover {
                background: #c82333;
            }

            .btn-create {
                background: #28a745;
                color: white;
            }

            .btn-create:hover {
                background: #218838;
            }

            .alert {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-danger {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .no-patients {
                text-align: center;
                padding: 60px 20px;
                color: #666;
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .no-patients i {
                font-size: 64px;
                color: #ddd;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="popup-overlay" id="popupOverlay" onclick="hidePopup()"></div>
        
        <div class="taikham_container">
            <div class="taikham-header">
                <i class="fas fa-redo-alt"></i> Danh sách Tái khám
            </div>

            <!-- Hiển thị thông báo -->
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> <%= error %>
                </div>
            <% } %>
            
            <% String success = (String) request.getAttribute("success"); %>
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= success %>
                </div>
            <% } %>

            <div class="taikham-search">
                <input type="text" placeholder="Tìm kiếm bệnh nhân theo tên" id="searchInput"/>
                <span style="color: #666; font-size: 14px;">
                    <i class="fas fa-info-circle"></i> Hiển thị danh sách các cuộc hẹn tái khám
                </span>
            </div>

            <div id="patientList">
                <%
                    List<Appointment> completedAppointments = (List<Appointment>) request.getAttribute("completedAppointments");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    
                    if (completedAppointments != null && !completedAppointments.isEmpty()) {
                        for (Appointment appointment : completedAppointments) {
                            String patientGender = appointment.getPatientGender();
                            String avatarUrl = "male".equals(patientGender) ? 
                                "https://randomuser.me/api/portraits/men/32.jpg" : 
                                "https://randomuser.me/api/portraits/women/32.jpg";
                            
                            // Tính tuổi
                            int age = 0;
                            if (appointment.getPatientDateOfBirth() != null) {
                                Calendar birth = Calendar.getInstance();
                                birth.setTime(appointment.getPatientDateOfBirth());
                                Calendar now = Calendar.getInstance();
                                age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
                                if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
                                    age--;
                                }
                            }
                            
                            // Format time safely
                            String timeSlotDisplay = "";
                            if (appointment.getStartTime() != null && appointment.getEndTime() != null) {
                                timeSlotDisplay = timeFormat.format(appointment.getStartTime()) + " - " + timeFormat.format(appointment.getEndTime());
                            } else {
                                timeSlotDisplay = "N/A";
                            }
                %>
                    <div class="patient-card-container" data-patient-name="<%= appointment.getPatientName() %>">
                        <div class="patient-info">
                            <img class="patient-avatar" src="<%= avatarUrl %>" alt="avatar"/>
                            <div class="patient-details">
                                <span class="patient-name"><%= appointment.getPatientName() %></span>
                                <div class="detail-row">
                                    <strong>Điện thoại:</strong> <%= appointment.getPatientPhone() != null ? appointment.getPatientPhone() : "Không có" %>
                                </div>
                                <div class="detail-row">
                                    <strong>Giới tính:</strong> <%= "male".equals(patientGender) ? "Nam" : "Nữ" %>
                                    &nbsp;&nbsp;&nbsp;&nbsp; 
                                    <strong>Tuổi:</strong> <%= age > 0 ? age : "N/A" %>
                                </div>
                                <div class="detail-row">
                                    <strong>Lý do khám trước:</strong> <%= appointment.getReason() %>
                                </div>
                            </div>
                        </div>
                        
                        <div class="appointment-info">
                            <div class="last-visit">Lần khám cuối:</div>
                            <div class="visit-date">
                                <%= dateFormat.format(appointment.getWorkDate()) %>
                                <br>
                                <small>
                                    <%= timeSlotDisplay %>
                                </small>
                            </div>
                        </div>
                        
                        <button class="btn-reexam" onclick="showPopup(<%= appointment.getAppointmentId() %>, <%= appointment.getPatientId() %>, '<%= appointment.getPatientName() %>')">
                            <i class="fas fa-calendar-plus"></i> Tái khám
                        </button>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="no-patients">
                        <i class="fas fa-user-slash"></i>
                        <h4>Không có cuộc hẹn tái khám nào</h4>
                        <p>Hiện tại chưa có cuộc hẹn tái khám nào trong hệ thống.</p>
                    </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Popup tái khám -->
        <div class="reexam-popup" id="reexamPopup">
            <div class="popup-header">
                <i class="fas fa-calendar-plus"></i> Đặt lịch tái khám
            </div>
            
            <form action="/doctor/ReexaminationServlet" method="post" id="reexamForm">
                <input type="hidden" id="previousAppointmentId" name="previousAppointmentId">
                <input type="hidden" id="patientId" name="patientId">
                
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Bệnh nhân:</label>
                    <input type="text" id="patientName" readonly>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Ngày tái khám:</label>
                    <input type="date" id="reexamDate" name="reexamDate" required min="<%= new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-clock"></i> Khung giờ:</label>
                    <select id="slotId" name="slotId" required>
                        <option value="">-- Chọn khung giờ --</option>
                        <%
                            List<TimeSlot> timeSlots = (List<TimeSlot>) request.getAttribute("timeSlots");
                            if (timeSlots != null) {
                                for (TimeSlot slot : timeSlots) {
                        %>
                            <option value="<%= slot.getSlotId() %>">
                                <%= slot.getStartTime() %> - <%= slot.getEndTime() %>
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-comment"></i> Lý do tái khám:</label>
                    <textarea name="reason" rows="3" placeholder="Nhập lý do tái khám (tùy chọn)"></textarea>
                </div>
                
                <div class="popup-button-group">
                    <button type="button" class="btn-cancel" onclick="hidePopup()">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" class="btn-create">
                        <i class="fas fa-check"></i> Tạo lịch
                    </button>
                </div>
            </form>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            function showPopup(appointmentId, patientId, patientName) {
                document.getElementById("previousAppointmentId").value = appointmentId;
                document.getElementById("patientId").value = patientId;
                document.getElementById("patientName").value = patientName;
                
                document.getElementById("popupOverlay").style.display = "block";
                document.getElementById("reexamPopup").style.display = "block";
            }

            function hidePopup() {
                document.getElementById("popupOverlay").style.display = "none";
                document.getElementById("reexamPopup").style.display = "none";
                
                // Reset form
                document.getElementById("reexamForm").reset();
            }

            // Tìm kiếm bệnh nhân
            $('#searchInput').on('input', function () {
                const keyword = $(this).val().toLowerCase();
                $('.patient-card-container').each(function () {
                    const name = $(this).attr('data-patient-name').toLowerCase();
                    $(this).toggle(name.includes(keyword));
                });
            });

            // Đóng popup khi nhấn ESC
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    hidePopup();
                }
            });
        </script>

    </body>
</html>
