<%@page import="Model.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="Model.Doctors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>

<%@ include file="/includes/header.jsp" %>

<%@ include file="/includes/sidebars.jsp" %>






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
            <h3>Lịch hẹn đã khám</h3>
            <%    List<Appointment> visited = (List<Appointment>) request.getAttribute("visitedAppointments");
                if (visited != null && !visited.isEmpty()) {
            %>
            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <th>Bác sĩ</th>
                    <th>Ngày</th>
                    <th>Giờ</th>
                    <th>Trạng thái</th>
                    <th>Lý do</th>
                    <th>Xem báo cáo</th>
                </tr>
                <%
                    for (Appointment ap : visited) {
                %>
                <tr>
                    <td><%= ap.getDoctorName()%></td>
                    <td><%= ap.getWorkDate()%></td>
                    <td><%= ap.getStartTime()%> - <%= ap.getEndTime()%></td>
                    <td><%= ap.getStatus()%></td>
                    <td><%= ap.getReason()%></td>
                    <td><a href="medical_report_detail?appointmentId=<%= ap.getAppointmentId()%>" target="_blank">Xem báo cáo</a></td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
            } else {
            %>
            <p>Bạn chưa có lịch hẹn nào đã khám.</p>
            <%
                }
            %>



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

