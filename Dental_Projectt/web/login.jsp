<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập</title>
        <!-- Ghi chú: Liên kết tới Bootstrap 5.3 để giữ giao diện giống bản gốc -->
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
                max-width: 600px;
                margin-left: 150px; /* Khoảng cách từ lề trái trên màn hình lớn */
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
                border-color: #3b82f6; /* Màu viền xanh để rõ ràng */
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
                font-weight: 700;
                color: #1f2937;
            }

            /* Ghi chú: Media query để điều chỉnh giao diện và nền cho màn hình nhỏ (dưới 576px, như điện thoại) */
            @media (max-width: 576px) {
                body {
                    /* Ghi chú: Căn giữa form và điều chỉnh nền */
                    justify-content: center;
                    background-size: contain; /* Nền thu nhỏ để vừa với màn hình */
                    background-position: top center; /* Đặt nền ở phía trên để tránh cắt xén */
                }

                .login-container {
                    /* Ghi chú: Thu nhỏ chiều rộng và căn giữa form */
                    max-width: 90%; /* Chiếm 90% chiều rộng màn hình để tránh tràn */
                    margin: 0 auto; /* Căn giữa */
                    padding: 15px; /* Giảm padding để gọn hơn */
                }

                .login-container h3 {
                    /* Ghi chú: Giảm kích thước chữ tiêu đề cho phù hợp */
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .form-control {
                    /* Ghi chú: Giảm kích thước trường nhập liệu */
                    padding: 10px;
                    font-size: 14px; /* Giảm cỡ chữ */
                }

                .btn-primary {
                    /* Ghi chú: Giảm kích thước nút */
                    padding: 10px;
                    font-size: 14px;
                }

                .form-label {
                    /* Ghi chú: Giảm cỡ chữ nhãn */
                    font-size: 14px;
                }

                .error-message {
                    /* Ghi chú: Giảm cỡ chữ thông báo lỗi */
                    font-size: 0.75rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Ghi chú: Container chứa form đăng nhập, căn trái trên màn hình lớn và căn giữa trên màn hình nhỏ -->
        <div class="login-container">
            <h3>Welcome!</h3>
            <h3>Please login to your account</h3>
            <!-- Ghi chú: Form gửi yêu cầu đăng nhập tới LoginServlet -->
            <form action="LoginServlet" method="post">
                <!-- Ghi chú: Trường nhập email -->
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="Email của bạn" required>
                </div>
                <!-- Ghi chú: Trường nhập mật khẩu -->
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password_hash" class="form-control" placeholder="Mật khẩu của bạn" required>
                </div>
                <!-- Ghi chú: Hiển thị thông báo lỗi nếu đăng nhập thất bại -->
                <% if (request.getParameter("error") != null) { %>
                <p class="error-message">Email hoặc mật khẩu không đúng!</p>
                <% }%>
                
                <!-- Ghi chú: Nút gửi form đăng nhập -->
                <button type="submit" class="btn btn-primary w-100">Login</button>
                
                <!-- Ghi chú: Liên kết đăng ký and quên mật khẩu -->
                <p class="text-center mt-3">
                    <a href="signup.jsp">Đăng ký</a> | <a href="#">Quên mật khẩu?</a>
                </p>
                <!-- Ghi chú: Liên kết quay về trang chủ -->
                <p class="text-center mt-3">
                    <a href="<%= request.getContextPath()%>/index.jsp" style="color: #3b82f6;">Trang chủ</a>
                </p>
            </form>
        </div>
        <!-- Ghi chú: Script kiểm tra form trước khi gửi -->
        <script>
            document.querySelector("form").addEventListener("submit", function (e) {
                const password = document.querySelector("input[name='password_hash']").value;
                // Ghi chú: Có thể thêm logic kiểm tra mật khẩu nếu cần
            });
        </script>  
        <!-- Ghi chú: Tải script Bootstrap để hỗ trợ các tính năng tương tác -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>