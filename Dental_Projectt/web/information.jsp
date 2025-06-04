<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    Integer id = (session != null) ? (Integer) session.getAttribute("id") : null;
    if (id == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông Tin Bệnh Nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            /* Body với nền ảnh nền full màn hình, căn trái, căn giữa chiều dọc */
            body {
                background: url('img/nen2.jpg') no-repeat center center fixed;
                background-size: cover;
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                justify-content: center; /* Căn giữa ngang */
                align-items: center;     /* Căn giữa dọc */
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            }

            .card {
                max-width: 600px; /* hoặc width: 600px; */
                padding: 25px 30px;
                background: rgba(255, 255, 255, 0.85);
                border-radius: 20px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            }


            h4.text-center {
                color: #3b82f6;
                font-weight: 600;
                font-size: 30px;
                margin-bottom: 30px;
            }

            .form-label {
                font-weight: 500;
                color: #1f2937;
                margin-bottom: 6px;
            }

            .form-control, .form-select {
                border-radius: 15px;
                border: 1px solid #ced4da;
                padding: 12px 15px;
                font-size: 15px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 8px rgba(59, 130, 246, 0.4);
                outline: none;
            }

            .btn-primary {
                border-radius: 8px;
                background-color: #0432b5;
                border: none;
                padding: 14px;
                font-weight: 600;
                font-size: 18px;
                transition: background-color 0.3s ease, transform 0.2s ease;
                width: 100%; /* Đảm bảo nút rộng 100% */
            }

            .btn-primary:hover {
                background-color: #022a8c;
                transform: translateY(-2px);
            }
        </style>
    </head>


    <body class="d-flex justify-content-center align-items-center vh-100 bg-light">
        <div class="card p-4">
            <h4 class="text-center mb-3">Xin hãy hoàn tất thông tin cá nhân</h4>

            <form action="RegisterInformation" method="post">
                <div class="mb-3">
                    <label class="form-label">Họ tên</label>
                    <input type="text" name="full_name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" name="phone" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Ngày sinh</label>
                    <input type="date" name="date_of_birth" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <select name="gender" class="form-select">
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100">Hoàn tất đăng ký</button>
            </form>
        </div>
    </body>
</html>


