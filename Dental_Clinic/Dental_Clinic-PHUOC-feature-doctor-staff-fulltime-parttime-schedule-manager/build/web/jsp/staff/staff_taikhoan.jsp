<%@ page import="model.Staff" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Thông tin tài khoản Staff</title>
</head>
<body>
    <h1>Thông tin tài khoản Staff</h1>
    <%
        if (staff != null) {
    %>
        <ul>
            <li>ID: <%= staff.getStaff_id() %></li>
            <li>Họ tên: <%= staff.getFull_name() %></li>
            <li>Số điện thoại: <%= staff.getPhone() %></li>
            <li>Địa chỉ: <%= staff.getAddress() %></li>
            <li>Ngày sinh: <%= staff.getDate_of_birth() %></li>
            <li>Giới tính: <%= staff.getGender() %></li>
            <li>Chức vụ: <%= staff.getPosition() %></li>
        </ul>
    <%
        } else {
    %>
        <p>Không tìm thấy thông tin staff trong session!</p>
    <%
        }
    %>
</body>
</html>