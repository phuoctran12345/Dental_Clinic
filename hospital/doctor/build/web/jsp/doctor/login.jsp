<%-- 
    Document   : login
    Created on : May 28, 2025, 1:59:50 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #eef1f5;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .login-form {
                background: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 360px;
            }
            .login-form h2 {
                text-align: center;
                margin-bottom: 20px;
                color: #333;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 6px;
                color: #555;
            }
            input[type="text"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
            button {
                width: 100%;
                padding: 12px;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
            }
            button:hover {
                background-color: #218838;
            }
            .login-form .extra {
                text-align: center;
                margin-top: 10px;
            }
            .login-form .extra a {
                color: #007bff;
                text-decoration: none;
            }
            .login-form .extra a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <form class="login-form" action="/doctor/LoginServlet" method="post">
            <h2>Đăng Nhập</h2>

            <div class="form-group">
                <label for="username">Tên đăng nhập / Email</label>
                <input type="text" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password_hash" required>
            </div>
            <button type="submit">Đăng Nhập</button>

            <div class="extra">
                <p>Chưa có tài khoản? <a href="#">Đăng ký ngay</a></p>
                <p><a href="/doctor/ResetPasswordServlet?action=forgot-password">Quên mật khẩu?</a></p>
            </div>

        </form>

    </body>
</html>
