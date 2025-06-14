<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, Model.Appointment"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách cuộc hẹn</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            .message {
                color: blue;
            }
            .error {
                color: red;
            }
            .debug {
                color: green;
            }
            a {
                text-decoration: none;
                color: #007bff;
            }
            a:hover {
                text-decoration: underline;
            }
            select, input[type="submit"] {
                padding: 5px;
            }
        </style>
    </head>
    <body>
        <h1>Danh sách cuộc hẹn</h1>

        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <p class="error"><%= error %></p>
        <% 
            }
        %>

        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
        <p class="message"><%= message %></p>
        <% 
            }
        %>

        <% 
            List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
            out.println("<p class='debug'>Debug: Số cuộc hẹn = " + (appointments != null ? appointments.size() : "null") + "</p>");
        
            if (appointments != null && !appointments.isEmpty()) {
        %>
        <table>
            <tr>
                <th>ID Cuộc hẹn</th>
                <th>ID Bệnh nhân</th>
                <th>Ngày</th>
                <th>Khung giờ</th>
                <th>Trạng thái</th>
                <th>Lý do</th>
                <th>Hành động</th>
            </tr>
            <% 
                    for (Appointment appt : appointments) {
            %>
            <tr>
                <td><%= appt.getAppointmentId() %></td>
                <td><%= appt.getPatientId() %></td>
                <td><%= appt.getWorkDate() %></td>
                <td><%= appt.getSlotId() %></td>
                <td><%= appt.getStatus() %></td>
                <td><%= appt.getReason() %></td>
                <td>
                    <form method="post" action="DoctorAppointmentsServlet">
                        <input type="hidden" name="appointmentId" value="<%= appt.getAppointmentId() %>">
                        <select name="status">
                            <option value="Đã đặt" <%= appt.getStatus().equals("Đã đặt") ? "selected" : "" %>>Đã đặt</option>
                            <option value="Hoàn tất" <%= appt.getStatus().equals("Hoàn tất") ? "selected" : "" %>>Hoàn tất</option>
                            <option value="Đã hủy" <%= appt.getStatus().equals("Đã hủy") ? "selected" : "" %>>Đã hủy</option>
                        </select>
                        <input type="submit" value="Cập nhật">
                    </form>
                </td>
            </tr>
            <% 
                    }
            %>
        </table>
        <% 
            }
        %>

        <p><a href="logout.jsp">Đăng xuất</a></p>
    </body>
</html>