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
                max-width: 400px;
                margin: 100px auto;
                padding: 30px;
                background: white;
                border-radius: 10px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                background: rgba(255, 255, 255, 0.3); /* Điều chỉnh độ đục */
                backdrop-filter: blur(8px); /* Làm mờ background */
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
    <body>

        <div class="login-container">
            <h3 class="text-center">Login</h3>
            <form action="LoginServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="Your Email" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password_hash" class="form-control" placeholder="Your Password" required>
                </div>
                <% if (request.getParameter("error") != null) { %>
                <p style="color:  red;">Invalid username or password!</p>
                <% }%>
                <button type="submit" class="btn btn-primary w-100">Login</button>

                <p class="text-center mt-3">
                    <a href="signup.jsp">Sign up</a> | <a href="#">Forget password?</a>
                </p>
                <p class="text-center mt-4">
                    <a href="<%= request.getContextPath()%>/Dental_Projectt" style="color: blue;">Trang Chủ</a>
                </p>
            </form>

        </div>

        <!--            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>-->
    </body>
</html>

