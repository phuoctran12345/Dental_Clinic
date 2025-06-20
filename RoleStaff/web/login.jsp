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
                background: rgba(255, 255, 255, 0.3);
                /* Điều chỉnh độ đục */
                backdrop-filter: blur(8px);
                /* Làm mờ background */
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
                background-color: moccasin !important;
                /* Nền trắng khi hover */
                border-color: moccasin !important;
                /* Viền giữ màu cũ */
                color: black !important;
                /* Đổi chữ thành cam */
            }

            .text-center a {
                color: black;
            }

            .google-btn {
                background-color: #fff;
                color: #757575;
                border: 1px solid #ddd;
                padding: 10px 20px;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .google-btn:hover {
                background-color: #f5f5f5;
            }

            .google-btn img {
                margin-right: 10px;
                width: 18px;
                height: 18px;
            }
        </style>
    </head>

    <body>

        <div class="login-container">
            <h3 class="text-center">Login</h3>
            <form action="<%= request.getContextPath()%>/LoginServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="Your Email" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password_hash" name="password_hash" class="form-control" placeholder="Your Password"
                        required>
                </div>
                <% if (request.getParameter("error") !=null) { String error=request.getParameter("error"); String
                    errorMessage="" ; switch(error) { case "empty_fields" :
                    errorMessage="Vui lòng điền đầy đủ thông tin!" ; break; case "invalid_credentials" :
                    errorMessage="Email hoặc mật khẩu không đúng!" ; break; case "account_locked" :
                    errorMessage="Tài khoản đã bị khóa!" ; break; case "system_error" :
                    errorMessage="Có lỗi xảy ra, vui lòng thử lại!" ; break; default: errorMessage="Đăng nhập thất bại!"
                    ; } %>
                    <div class="alert alert-danger">
                        <%= errorMessage %>
                    </div>
                    <% } %>
                        <button type="submit" class="btn btn-primary w-100">Login</button>
                        <div style="margin-top: 20px">
                            <a class="google-btn w-100 text-decoration-none"
                                href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/RoleStaff/login-google&response_type=code&client_id=20308864160-adugjk9b6q5m259igej77ho5lr1lffrq.apps.googleusercontent.com&approval_prompt=force">
                                <img src="https://www.google.com/favicon.ico" alt="Google">
                                Login With Google
                            </a>
                        </div>
                        <p class="text-center mt-3">
                            <a href="<%= request.getContextPath()%>/signup.jsp">Sign up</a> |  <a href="ResetPasswordServlet?action=forgot-password">Quên mật khẩu?</a>
                        </p>
                        <p class="text-center mt-4">
                            <a href="<%= request.getContextPath()%>/" style="color: blue;">Trang Chủ</a>
                        </p>
            </form>

            <div class="text-center mt-3">
                <span>Hoặc</span>
            </div>



        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>