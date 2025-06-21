<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="Model.Patients" %>

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
                min-height: 100vh;

            }
        </style>
    </head>
    <body>
        <div class="dashboard">
            <h2>Thông Tin Cá Nhân</h2>

            <%    Patients patient = (Patients) session.getAttribute("patient");
                if (patient != null) {
            %>
            <p><strong>Họ tên:</strong> <%= patient.getFullName()%></p>
            <p><strong>Điện thoại:</strong> <%= patient.getPhone()%></p>
            <%
                Date dob = patient.getDateOfBirth(); // có thể là java.sql.Date
                String formattedDob = "--";
                if (dob != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                    formattedDob = sdf.format(dob);
                }
            %>
            <p><strong>Ngày sinh:</strong> <%= formattedDob%></p>
            <p><strong>Giới tính:</strong> <%= patient.getGender()%></p>
            <%
            } else {
            %>
            <p>Không tìm thấy hồ sơ bệnh nhân.</p>
            <%
                }
            %>            
        </div>
    </body>
</html>

