<%@page import="Model.Customer"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("customer") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    Customer customer = (Customer) session.getAttribute("customer");

    // Hiển thị thông báo lỗi nếu có
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu - 76 Billiards</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Reset mặc định và thiết lập font */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Montserrat', 'Arial', sans-serif;
        }

        /* Thiết lập nền cho body với tông xanh biển */
        body {
            background: linear-gradient(135deg, #e0f7fa, #0288d1); /* Gradient xanh biển mềm mại */
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        /* Hiệu ứng nền động nhẹ (dùng pseudo-element) */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
            opacity: 0.5;
            z-index: 0;
        }

        /* Container chính */
        .container {
            max-width: 550px;
            width: 90%;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 30px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 1;
            border: 1px solid rgba(2, 136, 209, 0.2); /* Viền xanh biển nhạt */
            overflow: hidden;
        }

        /* Hiệu ứng viền sáng bên trong */
        .container::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, #0288d1, #e0f7fa, #0288d1);
            z-index: -1;
            filter: blur(20px);
            opacity: 0.7;
            transition: opacity 0.4s ease;
        }

        .container:hover::before {
            opacity: 1;
        }

        /* Tiêu đề */
        h2 {
            text-align: center;
            margin-bottom: 40px;
            color: #01579b; /* Xanh biển đậm */
            font-size: 34px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            position: relative;
            transition: color 0.3s ease, transform 0.3s ease;
        }

        .container:hover h2 {
            color: #0288d1; /* Xanh biển sáng hơn khi hover */
            transform: scale(1.05);
        }

        /* Hiệu ứng gạch chân cho tiêu đề */
        h2::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 90px;
            height: 6px;
            background: linear-gradient(90deg, #0288d1, #4fc3f7);
            border-radius: 3px;
            transition: width 0.4s ease, background 0.4s ease;
        }

        .container:hover h2::after {
            width: 120px;
            background: linear-gradient(90deg, #4fc3f7, #0288d1);
        }

        /* Form label */
        .form-label {
            font-weight: 600;
            color: #01579b; /* Xanh biển đậm */
            font-size: 16px;
            margin-bottom: 12px;
            display: block;
            letter-spacing: 0.8px;
            position: relative;
            transition: color 0.3s ease, transform 0.3s ease;
        }

        .form-label:hover {
            color: #0288d1;
            transform: translateX(5px);
        }

        .form-label::before {
            content: '➤';
            position: absolute;
            left: -25px;
            top: 50%;
            transform: translateY(-50%);
            color: #4fc3f7;
            font-size: 14px;
            opacity: 0;
            transition: opacity 0.3s ease, left 0.3s ease;
        }

        .form-label:hover::before {
            opacity: 1;
            left: -15px;
        }

        /* Form input */
        .form-control {
            border-radius: 15px;
            border: 1px solid #b3e5fc; /* Viền xanh biển nhạt */
            padding: 15px;
            font-size: 16px;
            background: #e0f7fa; /* Nền input xanh nhạt */
            transition: border-color 0.3s ease, box-shadow 0.3s ease, transform 0.3s ease;
            box-shadow: inset 0 3px 6px rgba(0, 0, 0, 0.05);
            position: relative;
        }

        .form-control:focus {
            border-color: #0288d1; /* Xanh biển đậm khi focus */
            box-shadow: 0 0 12px rgba(2, 136, 209, 0.4);
            transform: translateY(-4px);
            outline: none;
        }

        /* Nút */
        .btn {
            padding: 14px 40px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 50px;
            transition: background 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            position: relative;
            overflow: hidden;
            display: block;
            margin: 0 auto;
            margin-top: 25px;
        }

        .btn-success {
            background: linear-gradient(135deg, #0288d1, #4fc3f7); /* Gradient xanh biển */
            border: none;
            box-shadow: 0 5px 15px rgba(2, 136, 209, 0.4);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #4fc3f7, #0288d1);
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(2, 136, 209, 0.6);
        }

        /* Responsive cho màn hình nhỏ */
        @media (max-width: 576px) {
            .container {
                padding: 30px;
            }
            h2 {
                font-size: 28px;
            }
            .form-label {
                font-size: 14px;
            }
            .form-control {
                font-size: 14px;
                padding: 12px;
            }
            .alert {
                font-size: 14px;
                padding: 12px;
            }
            .btn {
                font-size: 14px;
                padding: 12px 30px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="my-4">Đổi Mật Khẩu</h2>
        <%-- Hiển thị thông báo lỗi nếu mật khẩu cũ không đúng --%>
        <% if ("wrongCurrentPassword".equals(error)) { %>
            <div class="alert alert-danger">Mật khẩu hiện tại không đúng. Vui lòng kiểm tra lại!</div>
        <% } %>

        <%-- Hiển thị thông báo lỗi nếu mật khẩu mới không khớp với xác nhận --%>
        <% if ("passwordMismatch".equals(error)) { %>
            <div class="alert alert-danger">Mật khẩu mới và xác nhận mật khẩu không khớp. Vui lòng kiểm tra lại!</div>
        <% } %>

        <%-- Hiển thị thông báo lỗi nếu có vấn đề với cơ sở dữ liệu --%>
        <% if ("databaseError".equals(error)) { %>
            <div class="alert alert-danger">Đã xảy ra lỗi trong quá trình cập nhật mật khẩu. Vui lòng thử lại sau!</div>
        <% } %>

        <form action="change_password" method="post">
            <div class="mb-3">
                <label class="form-label"><strong>Mật khẩu hiện tại</strong></label>
                <input type="password" class="form-control" name="currentPassword" required>
            </div>
            <div class="mb-3">
                <label class="form-label"><strong>Mật khẩu mới</strong></label>
                <input type="password" class="form-control" name="newPassword" required>
            </div>
            <div class="mb-3">
                <label class="form-label"><strong>Xác nhận mật khẩu mới</strong></label>
                <input type="password" class="form-control" name="confirmPassword" required>
            </div>
            <button type="submit" class="btn btn-success">Đổi mật khẩu</button>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
