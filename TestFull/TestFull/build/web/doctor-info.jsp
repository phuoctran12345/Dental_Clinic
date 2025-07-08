<%@page import="model.Doctors"%>
<%@page import="model.User"%>
<%@page import="dao.DoctorDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
%>
        <p>Bạn chưa đăng nhập.</p>
<%
    } else {
        Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
        if (doctor != null) {
%>
            <h2>Thông tin Bác sĩ</h2>
            <p><strong>User ID:</strong> <%= user.getId() %></p>
            <p><strong>Doctor ID:</strong> <%= doctor.getDoctor_id() %></p>
            <p><strong>Tên bác sĩ:</strong> <%= doctor.getFullName() %></p>
<%
        } else {
%>
            <p>Tài khoản của bạn không được liên kết với hồ sơ bác sĩ.</p>
<%
        }
    }
%>
