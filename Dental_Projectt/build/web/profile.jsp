<%-- 
    Document   : profile
    Created on : May 26, 2025, 8:38:07 AM
    Author     : lebao
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ page import="Model.Patients" %>

<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebars.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông Tin Cá Nhân</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 20px;
            }

            .profile-container {
                max-width: 600px;
                margin: auto;
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            td {
                padding: 12px 10px;
                border-bottom: 1px solid #ddd;
            }

            td.label {
                font-weight: bold;
                color: #34495e;
                width: 30%;
            }

            .no-data {
                text-align: center;
                color: #e74c3c;
                font-weight: bold;
                margin-top: 30px;
            }
        </style>
    </head>
    <body>

        <div class="profile-container">
            <h2>Thông Tin Cá Nhân</h2>

            <%
                Patients patient = (Patients) session.getAttribute("patient");
                if (patient != null) {
            %>
            <table>
                <tr>
                    <td class="label">Họ tên:</td>
                    <td><%= (patient.getFullName() != null ? patient.getFullName() : "Chưa có") %></td>
                </tr>
                <tr>
                    <td class="label">Điện thoại:</td>
                    <td><%= (patient.getPhone() != null ? patient.getPhone() : "Chưa có") %></td>
                </tr>
                <tr>
                    <td class="label">Ngày sinh:</td>
                    <td><%= (patient.getDateOfBirth() != null ? patient.getDateOfBirth() : "Chưa có") %></td>
                </tr>
                <tr>
                    <td class="label">Giới tính:</td>
                    <td><%= (patient.getGender() != null ? patient.getGender() : "Chưa có") %></td>
                </tr>
            </table>
            <%
                } else {
            %>
            <p class="no-data">Không tìm thấy hồ sơ bệnh nhân.</p>
            <%
                }
            %>
        </div>

    </body>
</html>
