<%-- 
    Document   : doctor_schedule
    Created on : Jun 2, 2025, 3:06:06 PM
    Author     : Home
--%>

<%@page import="Model.Appointment"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
<head>
    <title>Lịch khám của bác sĩ</title>
</head>
<body>
    <h2>Lịch hẹn của bác sĩ</h2>

   <table border="1">
    <tr>
        <th>ID Lịch</th>
        <th>Ngày</th>
        <th>Ca</th>
        <th>Nhập báo cáo</th>
    </tr>
<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments != null) {
        for (Appointment a : appointments) {
%>
    <tr>
        <td><%= a.getAppointmentId() %></td>
        <td><%= a.getWorkDate() %></td>
        <td><%= a.getSlotId() %></td>
        <td>
            <form action="doctor/doctor_homepage.jsp" method="get">
                <input type="hidden" name="appointment_id" value="<%= a.getAppointmentId() %>">
                <input type="hidden" name="patient_id" value="<%= a.getPatientId() %>">
                <button type="submit">Nhập báo cáo</button>
            </form>
        </td>
    </tr>
<%
        }
    }
%>
</table>

</body>
</html>