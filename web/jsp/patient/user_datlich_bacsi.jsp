<%@page pageEncoding="utf-8" %>
    <%@page import="model.Appointment" %>
        <%@page import="java.util.List" %>
            <%@page import="model.Doctors" %>
                <%@page import="java.text.SimpleDateFormat" %>
                    <%@page import="java.util.Date" %>


                        <%@ include file="/jsp/patient/user_header.jsp" %>

                            <%@ include file="/jsp/patient/user_menu.jsp" %>






                                <!DOCTYPE html>
                                <html>

                                <head>
                                    <title>Thông Tin Cá Nhân</title>
 <style>
            /* Thiết lập cơ bản */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f7fa;
                margin: 0;
                color: #333;
                font-size: 16px;
                padding-top: 10px;
            }

            /* Khung chính */
            .dashboard {
                padding: 20px 35px 30px 290px;
                max-width: 100%;
                margin: 0 auto;
            }

            /* Tiêu đề */
            h2 {
                color: #2c5282;
            }

            /* Bảng lịch hẹn */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #ffffff;
                box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
                border-radius: 6px;
                overflow: hidden;
                margin-bottom: 25px;
                border: 1px solid #ddd;
            }

            table thead {
                background: #4E80EE;
                color: white;
            }

            table th {
                padding: 15px 14px;
                font-weight: 600;
                text-align: left;
                font-size: 17px;
                border-right: 1px solid rgba(255,255,255,0.3);
            }

            table th:last-child {
                border-right: none;
            }

            table td {
                padding: 14px;
                border-bottom: 1px solid #ddd;
                border-right: 1px solid #ddd;
                font-size: 16px;
            }

            table td:last-child {
                border-right: none;
            }

            table tbody tr:last-child td {
                border-bottom: none;
            }


            /* Status styling */
            .status {
                font-weight: 600;
                padding: 4px 8px;
                border-radius: 3px;
                font-size: 15px;
            }
            
            .status-confirmed {
                color: #276749;
                background-color: #f0fff4;
            }
            
            .status-pending {
                color: #975a16;
                background-color: #fffaf0;
            }
            
            .status-cancelled {
                color: #9b2c2c;
                background-color: #fff5f5;
            }

            /* Form tìm kiếm */
            form[method="get"] {
                display: flex;
                gap: 15px;
                align-items: center;
                margin-bottom: 25px;
                background: white;
                padding: 20px;
                border-radius: 6px;
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.08);
                border: 1px solid #e2e8f0;
            }

            form[method="get"] input[type="text"],
            form[method="get"] select {
                padding: 12px 14px;
                border: 1px solid #cbd5e0;
border-radius: 5px;
                font-size: 16px;
                background: #f8fafc;
            }

            form[method="get"] input[type="text"]:focus,
            form[method="get"] select:focus {
                border-color: #4E80EE;
                outline: none;
                box-shadow: 0 0 0 2px rgba(78, 128, 238, 0.2);
            }

            /* Nút */
            button {
                padding: 14px 28px;
                background: #4E80EE;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            button:hover {
                background: #3a5fcd;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            /* Danh sách bác sĩ */
            .list-docter {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
            }

            .doctor-card {
                background: white;
                border-radius: 6px;
                padding: 20px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
            }

            .doctor-card h3 {
                color: #2c5282;
                margin-top: 0;
                margin-bottom: 12px;
                font-size: 18px;
                font-weight: 700;
            }

            .doctor-card p {
                margin: 10px 0;
                color: #4a5568;
                font-size: 16px;
            }

            .doctor-card form button {
                width: 100%;
                margin-top: 12px;
            }

            /* Thông báo trống */
            p[style*="text-align: center"],
            .empty-message {
                text-align: center;
                padding: 30px;
                color: #718096;
                background: #f8fafc;
                border-radius: 6px;
                font-size: 17px;
                margin: 15px 0;
                border: 1px dashed #cbd5e0;
            }

            /* Responsive adjustments */
            @media (max-width: 1200px) {
                .dashboard {
                    padding-left: 240px;
                }
            }

            @media (max-width: 768px) {
                .dashboard {
                    padding-left: 20px;
                    padding-right: 20px;
                }
                
                form[method="get"] {
                    flex-direction: column;
                    align-items: stretch;
                }
            }
        </style>

                                </head>

                                <body>
                                    <div class="dashboard">
                                        <h2>Danh sách lịch hẹn của bạn</h2>

                                        <% List<Appointment> appointment = (List<Appointment>)
                                                request.getAttribute("appointment");
                                                if (appointment != null && !appointment.isEmpty()) {
                                                %>
                                                <table border="1" cellpadding="5" cellspacing="0">
                                                    <thead>
                                                        <tr>
                                                            <th>Bác sĩ</th>
                                                            <th>Ngày</th>
                                                            <th>Giờ</th>
                                                            <th>Trạng thái</th>
                                                            <th>Lý do</th>
                                                            <th>Xem báo cáo</th>

                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for (Appointment ap : appointment) { %>
                                                            <tr>
                                                                <td>
                                                                    <%= ap.getDoctorName()%>
                                                                </td>
                                                                <td>
                                                                    <%= ap.getFormattedWorkDate()%>
                                                                </td>
                                                                <td>
                                                                    <%= ap.getFormattedTimeRange()%>
                                                                </td>
                                                                <td>
                                                                    <%= ap.getStatus()%>
                                                                </td>
                                                                <td>
                                                                    <%= ap.getReason()%>
                                                                </td>
                                                                <td><a
                                                                        href="MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId()%>">Xem
                                                                        báo cáo</a></td>

                                                            </tr>
                                                            <% } %>
                                                    </tbody>
                                                </table>
                                                <% } else { %>
                                                    <p>Bạn chưa có lịch hẹn nào.</p>
                                                    <% } %>

                                                        <div class="recent-visits mt-5">
                                                            <h3>Lịch khám của người thân</h3>

                                                            <% List<Appointment> relativeAppointments = (List
                                                                <Appointment>)
                                                                    request.getAttribute("relativeAppointments");
                                                                    %>

                                                                    <% if (relativeAppointments !=null &&
                                                                        !relativeAppointments.isEmpty()) { %>
                                                                        <table class="table table-bordered"
                                                                            style="width: 100%; text-align: left;">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>Người khám</th>
                                                                                    <th>Bác sĩ</th>
                                                                                    <th>Ngày khám</th>
                                                                                    <th>Khung giờ</th>
                                                                                    <th>Trạng thái</th>
                                                                                    <th>Xem báo cáo</th>

                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for (Appointment ap :
                                                                                    relativeAppointments) {%>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <%= ap.getPatientName()%>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= ap.getDoctorName()%>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%=
                                                                                                ap.getFormattedWorkDate()%>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%=
                                                                                                ap.getFormattedTimeRange()%>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= ap.getStatus()%>
                                                                                        </td>
                                                                                        <td><a
                                                                                                href="MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId()%>">Xem
                                                                                                báo cáo</a></td>

                                                                                    </tr>
                                                                                    <% } %>
                                                                            </tbody>
                                                                        </table>
                                                                        <% } else { %>
                                                                            <p>Hiện bạn chưa có lịch khám cho người
                                                                                thân.</p>
                                                                            <% } %>
                                                        </div>


                                </body>

                                </html>