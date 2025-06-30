<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kiểm tra Session User ID</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Kiểm tra Session User ID</h2>
        <%
            // Lấy session
            HttpSession sessionUser = request.getSession(false);
            User user = (sessionUser != null) ? (User) sessionUser.getAttribute("user") : null;
            
            if (user != null) {
                // Nếu user tồn tại trong session, hiển thị userId
                out.println("<p class='success'>User ID trong session: " + user.getUserId() + "</p>");
            } else {
                // Nếu không có user trong session, thông báo lỗi
                out.println("<p class='error'>Không tìm thấy thông tin user trong session. Vui lòng đăng nhập lại.</p>");
                out.println("<a href='login.jsp'>Quay lại trang đăng nhập</a>");
            }
        %>
    </div>
</body>
</html>
