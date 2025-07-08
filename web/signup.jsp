<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                /* Ghi chú: Đặt nền ảnh, căn giữa, cố định và phủ toàn màn hình */
                background: url('img/nen1.jpg') no-repeat center center fixed;
                background-size: cover;
                margin: 0;
                padding: 0;
                min-height: 100vh;
                /* Ghi chú: Sử dụng flex để căn chỉnh container sang bên trái */
                display: flex;
                justify-content: flex-start;
                /* Đẩy form về phía bên trái */
                align-items: center;
                /* Căn giữa theo chiều dọc */
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            }

            .login-container {
                /* Ghi chú: Đặt chiều rộng tối đa và căn chỉnh lề trái trên màn hình lớn */
                width: 500px;
                /* Thay max-width bằng width để cố định kích thước */
                margin-left: 130px;
                /* Khoảng cách từ lề trái trên màn hình lớn */
                padding: 30px;
                /* Tăng padding để form rộng hơn */
                background-color: rgba(255, 255, 255, 0.9);
                /* Thêm nền trắng mờ để dễ đọc */
                border-radius: 10px;
                /* Bo góc container */
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                /* Thêm bóng đổ nhẹ */
            }

            .login-container h3 {
                /* Ghi chú: Định dạng tiêu đề với màu xanh, căn giữa, và kích thước chữ */
                color: #4E80EE;
                font-size: 31px;
                font-weight: 600;
                text-align: center;
                margin-bottom: 15px;
            }

            .form-control {
                /* Ghi chú: Bo góc trường nhập liệu, thêm viền và hiệu ứng chuyển đổi */
                border-radius: 10px;
                /* Đã thay đổi từ 15px xuống 10px */
                border: 1px solid #ced4da;
                padding: 12px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 15px;
            }

            .form-control:focus {
                /* Ghi chú: Hiệu ứng khi focus vào trường nhập liệu */
                border-color: #3b82f6;
                box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
            }

            .btn-primary {
                /* Ghi chú: Định dạng nút đăng nhập với màu xanh đậm và bo góc */
                border-radius: 10px;
                /* Đã thay đổi từ 5px lên 10px */
                background-color: #0432b5;
                border: none;
                padding: 13px;
                font-weight: 500;
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
                font-weight: 500;
                color: #1f2937;
            }

            .google-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #fff;
                color: #1f2937;
                border: 1px solid #ced4da;
                border-radius: 10px;
                /* Đã thay đổi từ 15px xuống 10px */
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
        </style>
    </head>

    <body class="container-fluid">
        <div class="login-container">
            <h3 class="text-center">Vui lòng tạo tài khoản mới</h3>

            <% if (request.getParameter("error") !=null) { %>
                <div class="alert alert-danger">Email đã tồn tại!</div>
                <% } %>
                    <% if (request.getParameter("success") !=null) { %>
                        <div class="alert alert-success">
                            Đăng ký thành công!
                            <form action="information.jsp" method="post" class="mt-2">
                                <button type="submit" class="btn btn-success w-100">Tiếp tục hoàn tất thông tin</button>
                            </form>
                        </div>
                        <% }%>

                            <form action="SignUpServlet" method="post">
                                <div class="mb-3">
                                    <label class="form-label">Tên đăng nhập</label>
                                    <input type="text" name="username" class="form-control" required>
                                    <label class="form-label">Email</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu</label>
                                    <input type="password" name="passwordHash" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Xác nhận mật khẩu</label>
                                    <input type="password" name="confirmPassword" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">Đăng Ký</button>
                            </form>

                            <div style="margin-top: 20px">
                                <a class="google-btn w-100 text-decoration-none"
                                    href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/TestFull/LoginGG/LoginGoogleHandler&response_type=code&client_id=560611814939-bfr1rtiahhq41h0d6fd3lcg876lc3ve.apps.googleusercontent.com&approval_prompt=force">
                                    <img src="https://www.google.com/favicon.ico" alt="Google">
                                    Sign in with Google
                                </a>
                            </div>

                            <p class="text-center mt-3">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
                            <p class="text-center mt-4">
                                <a href="<%= request.getContextPath()%>/home.jsp" style="color: blue;">Trang Chủ</a>
                            </p>
        </div>
    </body>

    <script>
        document.querySelector("form").addEventListener("submit", function (e) {
            const password = document.querySelector("input[name='passwordHash']").value;
            const confirmPassword = document.querySelector("input[name='confirmPassword']").value;

            if (password !== confirmPassword) {
                alert("Mật khẩu và xác nhận mật khẩu không khớp!");
                e.preventDefault(); // Ngăn form gửi đi
            }
        });
    </script>

    </html>