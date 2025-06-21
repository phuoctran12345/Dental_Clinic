<%@page import="Model.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="Model.Doctors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>

<%@ include file="/patient/header.jsp" %>

<%@ include file="/patient/sidebars.jsp" %>






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
                flex-wrap: wrap; /* Cho phép tự xuống hàng khi hết chiều ngang */
                gap: 20px;        /* Khoảng cách giữa các thẻ bác sĩ */
            }
            .doctor-card{

            }
        </style>
    </head>
    <body>
        <div class="dashboard">
            <h2>Danh sách lịch hẹn của bạn</h2>

            <%    List<Appointment> appointment = (List<Appointment>) request.getAttribute("appointment");
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
                    <%
                        for (Appointment ap : appointment) {
                    %>
                    <tr>
                        <td><%= ap.getDoctorName()%></td>
                        <td><%= ap.getWorkDate()%></td>
                        <td><%= ap.getStartTime().toString()%> - <%= ap.getEndTime().toString()%></td>
                        <td><%= ap.getStatus()%></td>
                        <td><%= ap.getReason()%></td>
                        <td><a href="MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId()%>" >Xem báo cáo</a></td>

                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
            } else {
            %>
            <p>Bạn chưa có lịch hẹn nào.</p>
            <%
                }
            %>

            <div class="recent-visits mt-5">
                <h3>Lịch khám của người thân</h3>

                <%
                    List<Appointment> relativeAppointments = (List<Appointment>) request.getAttribute("relativeAppointments");
                %>

                <% if (relativeAppointments != null && !relativeAppointments.isEmpty()) { %>
                <table class="table table-bordered" style="width: 100%; text-align: left;">
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
                        <% for (Appointment ap : relativeAppointments) {%>
                        <tr>
                            <td><%= ap.getPatientName()%></td>
                            <td><%= ap.getDoctorName()%></td>
                            <td><%= ap.getWorkDate().format(java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"))%></td>
                            <td><%= ap.getStartTime()%> - <%= ap.getEndTime()%></td>
                            <td><%= ap.getStatus()%></td>
                            <td><a href="MedicalReportDetailServlet?appointmentId=<%= ap.getAppointmentId()%>" >Xem báo cáo</a></td>

                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p>Hiện bạn chưa có lịch khám cho người thân.</p>
                <% } %>
            </div>


            <h2>Danh sách Bác sĩ</h2>
            <form method="get" action="BookingPageServlet">
                Tên bác sĩ:
                <input type="text" name="keyword" value="${param.keyword}" />

                Chuyên khoa:
                <select name="specialty">
                    <option value="">-- Tất cả --</option>
                    <%
                        List<String> specialties = (List<String>) request.getAttribute("specialties");
                        String selectedSpecialty = request.getParameter("specialty");
                        if (specialties != null) {
                            for (String spec : specialties) {
                    %>
                    <option value="<%= spec%>" <%= spec.equals(selectedSpecialty) ? "selected" : ""%>>
                        <%= spec%>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
                <button type="submit">Lọc</button>
            </form>
            <div class="list-docter">
                <%        List<Doctors> doctors = (List<Doctors>) request.getAttribute("doctors");
                    if (doctors != null && !doctors.isEmpty()) {
                        for (Doctors doc : doctors) {
                %>
                <div class="doctor-card">
                    <h3><%= doc.getFullName()%></h3>
                    <p>Chuyên môn: <%= doc.getSpecialty()%></p>
                    <p>Số điện thoại: <%= doc.getPhone()%></p>
                    <p>
                        <span>Trạng thái:</span>
                        <% if ("Active".equalsIgnoreCase(doc.getStatus())) { %>
                        <i style="color:green;" class="fa-solid fa-circle fa-fade"></i>
                        <span style="color: green;">Đang trực</span>
                        <% } else { %>
                        <i style="color:gray;" class="fa-solid fa-circle"></i>
                        <span style="color: gray;">Ngoại tuyến</span>
                        <% }%>
                    </p>

                    <form action="DocterScheduleServlet" method="get">
                        <input type="hidden" name="doctor_id" value="<%= doc.getDoctorId()%>" />
                        <button type="submit">Đặt lịch với bác sĩ này</button>
                    </form>
                </div>
                <%
                    }
                } else {
                %>
                <p>Không có bác sĩ nào để hiển thị.</p>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>

