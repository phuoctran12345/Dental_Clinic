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
                /* Ghi chú: Đặt nền ảnh, căn giữa, cố định và phủ toàn màn hình trên màn hình lớn */
                background: url('img/nen1.jpg') no-repeat center center fixed;
                background-size: cover; /* Nền phủ toàn màn hình trên màn hình lớn */
                margin: 0;
                padding: 0;
                min-height: 100vh;
                /* Ghi chú: Sử dụng flex để căn chỉnh container sang bên trái trên màn hình lớn */
                display: flex;
                justify-content: flex-start;
                align-items: center;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            }

            .login-container {
                /* Ghi chú: Đặt chiều rộng tối đa và căn chỉnh lề trái trên màn hình lớn */
                width: 500px; /* Thay max-width bằng width để cố định kích thước */
                margin-left: 130px; /* Khoảng cách từ lề trái trên màn hình lớn */
                padding: 30px; /* Tăng padding để form rộng hơn */
                background-color: rgba(255, 255, 255, 0.9); /* Thêm nền trắng mờ để dễ đọc */
                border-radius: 15px; /* Bo góc container */
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Thêm bóng đổ nhẹ */
            }

            .login-container h3 {
                /* Ghi chú: Định dạng tiêu đề với màu xanh, căn giữa, và kích thước chữ */
                color: #4E80EE;
                font-size: 31px;
                font-weight: 600;
                text-align: center;
                margin-bottom: 30px; /* Tăng khoảng cách dưới tiêu đề */
            }

            .form-control {
                /* Ghi chú: Bo góc trường nhập liệu, thêm viền và hiệu ứng chuyển đổi */
                border-radius: 15px;
                border: 1px solid #ced4da;
                padding: 15px; /* Tăng padding cho input */
                height: 45px; /* Cố định chiều cao input */
                font-size: 16px; /* Tăng kích thước chữ */
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 15px; /* Tăng khoảng cách giữa các input */
            }

            .form-control:focus {
                /* Ghi chú: Hiệu ứng khi focus vào trường nhập liệu */
                border-color: #3b82f6; /* Màu viền xanh để rõ ràng */
                box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
            }

            .btn-primary {
                /* Ghi chú: Định dạng nút đăng nhập với màu xanh đậm và bo góc */
                border-radius: 15px; /* Bo góc nhiều hơn */
                background-color: #0432b5;
                border: none;
                padding: 15px; /* Tăng padding cho nút */
                font-weight: 500;
                font-size: 16px; /* Tăng kích thước chữ */
                height: 50px; /* Cố định chiều cao nút */
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .btn-primary:hover {
                /* Ghi chú: Hiệu ứng hover cho nút đăng nhập */
                background-color: #022a8c;
                transform: translateY(-2px);
            }

            .text-center a {
                /* Ghi chú: Định dạng liên kết với màu đen và hiệu ứng hover */
                color: #1f2937;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.2s ease;
                font-size: 15px; /* Tăng kích thước chữ */
            }

            .text-center a:hover {
                /* Ghi chú: Đổi màu liên kết khi hover */
                color: #3b82f6;
                text-decoration: underline;
            }

            .error-message {
                /* Ghi chú: Định dạng thông báo lỗi với màu đỏ, căn giữa */
                color: #dc2626;
                font-size: 0.875rem;
                text-align: center;
                margin-bottom: 1rem;
            }

            .form-label {
                /* Ghi chú: Đảm bảo nhãn trường nhập liệu căn chỉnh đều */
                font-weight: 700;
                color: #1f2937;
                font-size: 16px; /* Tăng kích thước chữ nhãn */
                margin-bottom: 8px; /* Tăng khoảng cách dưới nhãn */
            }

            /* Thêm style cho nút Google */
            .google-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #fff;
                color: #1f2937;
                border: 1px solid #ced4da;
                border-radius: 15px;
                padding: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
                margin-bottom: 20px;
            }

            .google-btn:hover {
                background-color: #f8f9fa;
                transform: translateY(-2px);
            }

            .google-btn img {
                width: 20px;
                margin-right: 10px;
            }

            /* Điều chỉnh khoảng cách giữa các phần tử */
            .mb-3 {
                margin-bottom: 20px !important;
            }

            .mt-3 {
                margin-top: 5px !important;
            }

            .mt-4 {
                margin-top: 5px !important;
            }

            /* RESPONSIVE CSS CHO MOBILE */
            @media (max-width: 768px) {
                body {
                    /* Căn giữa container trên mobile */
                    justify-content: center;
                    padding: 15px;
                    /* Điều chỉnh background cho mobile */
                    background-attachment: scroll;
                    background-size: cover;
                    background-position: center;
                }

                .login-container {
                    /* Container responsive trên mobile */
                    width: 100%;
                    max-width: 400px;
                    margin-left: 0; /* Bỏ margin trái */
                    margin: 0 auto; /* Căn giữa */
                    padding: 20px;
                    /* Giảm bo góc trên mobile */
                    border-radius: 10px;
                }

                .login-container h3 {
                    /* Giảm kích thước tiêu đề trên mobile */
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .form-control {
                    /* Điều chỉnh input cho mobile */
                    padding: 12px;
                    height: 40px;
                    font-size: 14px;
                    margin-bottom: 12px;
                    border-radius: 10px;
                }

                .btn-primary {
                    /* Điều chỉnh nút cho mobile */
                    padding: 12px;
                    height: 45px;
                    font-size: 14px;
                    border-radius: 10px;
                }

                .form-label {
                    /* Giảm kích thước nhãn trên mobile */
                    font-size: 14px;
                    margin-bottom: 6px;
                }

                .google-btn {
                    /* Điều chỉnh nút Google cho mobile */
                    padding: 10px;
                    border-radius: 10px;
                    font-size: 14px;
                }

                .google-btn img {
                    width: 18px;
                    margin-right: 8px;
                }

                .text-center a {
                    /* Giảm kích thước link trên mobile */
                    font-size: 13px;
                }

                /* Điều chỉnh khoảng cách trên mobile */
                .mb-3 {
                    margin-bottom: 15px !important;
                }

                .mt-3 {
                    margin-top: 10px !important;
                }

                .mt-4 {
                    margin-top: 10px !important;
                }
            }

            /* CSS cho màn hình rất nhỏ (dưới 480px) */
            @media (max-width: 480px) {
                body {
                    padding: 10px;
                }

                .login-container {
                    padding: 15px;
                    border-radius: 8px;
                }

                .login-container h3 {
                    font-size: 20px;
                    margin-bottom: 15px;
                }

                .form-control {
                    padding: 10px;
                    height: 38px;
                    font-size: 13px;
                    border-radius: 8px;
                }

                .btn-primary {
                    padding: 10px;
                    height: 40px;
                    font-size: 13px;
                    border-radius: 8px;
                }

                .form-label {
                    font-size: 13px;
                }

                .google-btn {
                    padding: 8px;
                    border-radius: 8px;
                    font-size: 13px;
                }

                .text-center a {
                    font-size: 12px;
                }
            }
        </style>
    </head>

    <body>

        <div class="login-container">
            <h3 class="text-center">Please login to use the service</h3>
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
                <% if (request.getParameter("error") != null) {
                        String error = request.getParameter("error");
                        String errorMessage = "";
                        switch (error) {
                            case "empty_fields":
                                errorMessage = "Vui lòng điền đầy đủ thông tin!";
                                break;
                            case "invalid_credentials":
                                errorMessage = "Email hoặc mật khẩu không đúng!";
                                break;
                            case "account_locked":
                                errorMessage = "Tài khoản đã bị khóa!";
                                break;
                            case "system_error":
                                errorMessage = "Có lỗi xảy ra, vui lòng thử lại!";
                                break;
                            default:
                                errorMessage = "Đăng nhập thất bại!";
                        }%>
                <div class="alert alert-danger">
                    <%= errorMessage%>
                </div>
                <% }%>
                <button type="submit" class="btn btn-primary w-100">Login</button>
                <div style="margin-top: 20px">
                                <a class="google-btn w-100 text-decoration-none"
                                    href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/TestFull/LoginGG/LoginGoogleHandler&response_type=code&client_id=560611814939-bfrj1rtiahhq41h0d6fd3lcg876ic3ve.apps.googleusercontent.com&approval_prompt=force">
                                    <img src="https://www.google.com/favicon.ico" alt="Google">
                                    Sign in with Google
                                </a>
                            </div>
                <p class="text-center mt-3">
                    <a href="<%= request.getContextPath()%>/signup.jsp">Sign up</a> |  <a href="ResetPasswordServlet?action=forgot-password">Quên mật khẩu?</a>
                </p>

                <div class="text-center mt-3">
                    <span>Hoặc</span>
                </div>

                <p class="text-center mt-4">
                    <a href="<%= request.getContextPath()%>/" style="color: blue;">Trang Chủ</a>
                </p>
            </form>

        </div>
                
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <!-- Ghi chú: Script kiểm tra form trước khi gửi -->
        <script>
            document.querySelector("form").addEventListener("submit", function (e) {
                const password = document.querySelector("input[name='password_hash']").value;
                // Ghi chú: Có thể thêm logic kiểm tra mật khẩu nếu cần
            });
        </script>  
    
    </body>

</html>