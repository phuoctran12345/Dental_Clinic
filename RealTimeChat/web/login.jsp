<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Chat</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f4f4f4; }
        .login-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        input[type="email"], input[type="password"] { width: calc(100% - 22px); padding: 10px; margin: 8px 0; border: 1px solid #ddd; border-radius: 4px; }
        button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background-color: #0056b3; }
        .error-message { color: red; text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập để Chat</h2>
        <form action="<%= request.getContextPath() %>/LoginServlet3" method="post">
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password_hash" placeholder="Mật khẩu" required>
    <button type="submit">Đăng nhập</button>
</form>

<% if ("1".equals(request.getParameter("error"))) { %>
    <p style="color:red;">Sai tài khoản hoặc mật khẩu!</p>
<% } %>

</body>
</html>