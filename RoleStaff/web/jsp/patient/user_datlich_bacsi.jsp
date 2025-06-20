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
                                        body {

                                            padding-top: 10px;
                                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                            background: #f8f9fb;
                                            margin: 0;
                                            width: 100%;



                                        }

                                        .dashboard {
                                            padding-left: 270px;
                                            padding-top: 15px;
                                            display: grid;

                                            gap: 20px;
                                            padding-right: 10px;
                                            padding-bottom: 50px;
                                            box-sizing: border-box;

                                        }

                                        .list-docter {
                                            display: flex;
                                            flex-wrap: wrap;
                                            /* Cho phép tự xuống hàng khi hết chiều ngang */
                                            gap: 20px;
                                            /* Khoảng cách giữa các thẻ bác sĩ */
                                        }

                                        .doctor-card {}
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