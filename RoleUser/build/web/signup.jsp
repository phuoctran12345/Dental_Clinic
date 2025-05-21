<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background: url('images/hinhnen.jpg ') no-repeat center center fixed;
                background-color: #FAEBD7;
                background-size: cover;



            }
            .login-container {
                width: 420px; /* Tăng kích thước */
                padding: 40px; /* Tăng khoảng cách bên trong */
                background: rgba(255, 255, 255, 0.3); /* Điều chỉnh độ đục */
                backdrop-filter: blur(10px); /* Hiệu ứng mờ nền */
                border-radius: 10px; /* Bo góc */
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            }

            .form-control {
                border-radius: 8px;
            }
            .btn-primary {
                border-radius: 8px;
                background-color: #E09956;
                border-color: #E09956;


            }
            .btn-primary:hover {
                background-color: moccasin !important; /* Nền trắng khi hover */
                border-color: moccasin !important; /* Viền giữ màu cũ */
                color: black !important; /* Đổi chữ thành cam */
            }
            .text-center a{
                color: black;
            }
        </style>
    </head>
    <body class="d-flex justify-content-center align-items-center vh-100 container-fluid">

        <div  class="login-container">
            <h3 class="text-center">Đăng Ký</h3>

            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">Email hoặc số điện thoại đã tồn tại!</div>
            <% } %>
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">Đăng ký thành công! <a href="login.jsp">Đăng nhập ngay</a></div>
            <% }%>

            <form action="SignUpServlet" method="post">
                
                <div class="mb-3">
                    <label class="form-label">Họ Tên</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số Điện Thoại</label>
                    <input type="text" name="phone" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="passwordHash" class="form-control" required>
                </div>              
                <button type="submit" class="btn btn-primary w-100">Đăng Ký</button>
            </form>

            <p class=" text-center mt-3">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
            <p class="text-center mt-4">
                    <a href="<%= request.getContextPath()%>/user_homepage.jsp" style="color: blue;">Trang Chủ</a>
                </p>
        </div>

    </body><!--         
           <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>-->

</html>

