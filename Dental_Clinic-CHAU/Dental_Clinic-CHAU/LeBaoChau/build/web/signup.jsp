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
            justify-content: flex-start; /* Đẩy form về phía bên trái */
            align-items: center; /* Căn giữa theo chiều dọc */
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }

        .login-container {
            /* Ghi chú: Đặt chiều rộng tối đa và căn chỉnh lề trái */
            max-width: 700px;
            margin-left: 150px; /* Khoảng cách từ lề trái, giảm từ 150px xuống 50px để gần lề hơn */
            padding: 17px;
            /* Ghi chú: Bỏ nền trắng và shadow để giữ giao diện trong suốt */
        }

        .login-container h3 {
            /* Ghi chú: Định dạng tiêu đề với màu xanh, căn giữa, và kích thước chữ */
            color: #3b82f6;
            font-size: 31px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 25px;
        }

        .form-control {
            /* Ghi chú: Bo góc trường nhập liệu, thêm viền và hiệu ứng chuyển đổi */
            border-radius: 15px;
            border: 1px solid #ced4da;
            padding: 12px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-control:focus {
            /* Ghi chú: Hiệu ứng khi focus vào trường nhập liệu */
            border-color: #3b82f6;
            box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
        }

        .btn-primary {
            /* Ghi chú: Định dạng nút đăng nhập với màu xanh đậm và bo góc */
            border-radius: 5px;
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
    </style>
    </head>
    <body class="container-fluid">
        <div class="login-container">
            <h3 class="text-center">Vui lòng tạo tài khoản mới</h3>
            <h3 class="text-center">Đăng Ký</h3>

            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">Email đã tồn tại!</div>
            <% } %>
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                Đăng ký thành công!
                <form action="information.jsp" method="post" class="mt-2">
                    <button type="submit" class="btn btn-success w-100">Tiếp tục hoàn tất thông tin</button>
                </form>
            </div>
            <% } %>

            <form action="SignUpServlet" method="post">
                <div class="mb-3">
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

            <p class="text-center mt-3">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
            <p class="text-center mt-4">
                <a href="<%= request.getContextPath()%>/user_homepage.jsp" style="color: blue;">Trang Chủ</a>
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