<%@page import="Model.Customer"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("customer") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    Customer customer = (Customer) session.getAttribute("customer");

    // Hiển thị thông báo thành công hoặc thất bại
    String updateSuccess = request.getParameter("updateSuccess");
    String updateError = request.getParameter("updateError");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Tin Cá Nhân - 76 Billiards</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="CSS/style.css">
    <style>
        /* Reset mặc định và thiết lập font */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', 'Arial', sans-serif;
        }

        /* Thiết lập nền cho body với tông xanh biển */
        body {
            background: linear-gradient(135deg, #e1f5fe, #42a5f5); /* Gradient xanh biển mềm mại */
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
            background: radial-gradient(circle, rgba(255, 255, 255, 0.3) 0%, transparent 70%);
            opacity: 0.4;
            z-index: 0;
        }

        /* Container chính */
        .profile-card {
            max-width: 600px;
            width: 90%;
            padding: 40px;
            background: rgba(255, 255, 255, 0.97);
            border-radius: 25px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
            position: relative;
            z-index: 1;
            border: 2px solid rgba(66, 165, 245, 0.3); /* Viền xanh biển nhạt */
            overflow: hidden;
        }

        /* Hiệu ứng viền sáng bên trong */
        .profile-card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, #42a5f5, #e3f2fd, #42a5f5);
            z-index: -1;
            filter: blur(15px);
            opacity: 0.6;
            transition: opacity 0.3s ease;
        }

        .profile-card:hover::before {
            opacity: 0.8;
        }

        /* Tiêu đề */
        .profile-card h2 {
            text-align: center;
            margin-bottom: 35px;
            color: #1565c0; /* Xanh biển đậm */
            font-size: 32px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            position: relative;
            transition: color 0.3s ease;
        }

        .profile-card:hover h2 {
            color: #0d47a1; /* Xanh biển đậm hơn khi hover */
        }

        /* Hiệu ứng gạch chân cho tiêu đề */
        .profile-card h2::after {
            content: '';
            position: absolute;
            bottom: -12px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 5px;
            background: linear-gradient(90deg, #42a5f5, #1976d2);
            border-radius: 3px;
            transition: width 0.3s ease;
        }

        .profile-card:hover h2::after {
            width: 100px;
        }

        /* Form label */
        .form-label {
            font-weight: 600;
            color: #0d47a1; /* Xanh biển đậm */
            font-size: 16px;
            margin-bottom: 10px;
            display: block;
            letter-spacing: 0.5px;
            position: relative;
            transition: color 0.3s ease;
        }

        .form-label::before {
            content: '✦';
            position: absolute;
            left: -20px;
            top: 50%;
            transform: translateY(-50%);
            color: #42a5f5;
            font-size: 12px;
            opacity: 0;
            transition: opacity 0.3s ease, left 0.3s ease;
        }

        .form-label:hover::before {
            opacity: 1;
            left: -15px;
        }

        /* Form input */
        .form-control {
            border-radius: 12px;
            border: 1px solid #bbdefb; /* Viền xanh biển nhạt */
            padding: 14px;
            font-size: 16px;
            background: #e3f2fd; /* Nền input xanh nhạt */
            transition: border-color 0.3s ease, box-shadow 0.3s ease, transform 0.3s ease;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
            position: relative;
        }

        .form-control:focus {
            border-color: #1976d2; /* Xanh biển đậm khi focus */
            box-shadow: 0 0 10px rgba(25, 118, 210, 0.3);
            transform: translateY(-3px);
            outline: none;
        }

        /* Hiệu ứng sáng bóng cho input khi focus */
        .form-control:focus::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            animation: shine 1s ease;
        }

        /* Thông báo */
        .alert {
            margin-top: 20px;
            border-radius: 12px;
            font-size: 16px;
            padding: 15px;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .alert:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .alert-success {
            background: linear-gradient(135deg, #e1f5fe, #90caf9); /* Gradient xanh biển nhạt */
            color: #0d47a1; /* Chữ xanh biển đậm */
        }

        .alert-danger {
            background: linear-gradient(135deg, #ffebee, #ef9a9a);
            color: #b71c1c;
        }

        /* Hiệu ứng viền sáng cho thông báo */
        .alert::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 12px;
            border: 2px solid;
            border-color: rgba(66, 165, 245, 0.3);
            opacity: 0.5;
            z-index: -1;
            transition: border-color 0.3s ease;
        }

        .alert:hover::before {
            border-color: rgba(66, 165, 245, 0.6);
        }

        /* Nút */
        .profile-btns {
            text-align: center;
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .btn {
            padding: 12px 35px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 50px;
            transition: background 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
        }

        .btn-success {
            background: linear-gradient(135deg, #42a5f5, #1976d2); /* Gradient xanh biển */
            border: none;
            box-shadow: 0 5px 15px rgba(66, 165, 245, 0.4);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #1976d2, #0d47a1);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(66, 165, 245, 0.6);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ffca28, #ff8f00); /* Gradient vàng cam */
            border: none;
            box-shadow: 0 5px 15px rgba(255, 202, 40, 0.4);
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #ff8f00, #f57c00);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 202, 40, 0.6);
        }

        /* Nút Trang chủ nổi bật */
        .home-btn-container {
            margin-top: 40px;
            text-align: center;
            position: relative;
        }

        .btn-home {
            background: linear-gradient(135deg, #00c853, #009624); /* Gradient xanh lá */
            color: white;
            font-weight: 600;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 200, 83, 0.4);
            transform: scale(1.05);
            padding: 14px 40px;
        }

        .btn-home:hover {
            background: linear-gradient(135deg, #00e676, #00c853);
            transform: translateY(-3px) scale(1.1);
            box-shadow: 0 8px 20px rgba(0, 200, 83, 0.6);
        }

        .btn-home::before {
            content: '🏠';
            margin-right: 10px;
        }

        /* Separator */
        .separator {
            height: 2px;
            background: linear-gradient(90deg, transparent, rgba(66, 165, 245, 0.5), transparent);
            margin: 20px 0 30px;
            position: relative;
        }

        .separator::before {
            content: '';
            position: absolute;
            top: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 16px;
            height: 16px;
            background: #42a5f5;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        /* Responsive cho màn hình nhỏ */
        @media (max-width: 576px) {
            .profile-card {
                padding: 30px;
            }
            .profile-card h2 {
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
                padding: 10px 25px;
            }
            .profile-btns {
                flex-direction: column;
                gap: 15px;
            }
            .btn-home {
                padding: 12px 30px;
            }
        }
    </style>
</head>
<body>
    <div class="profile-card">
        <h2>Thông Tin Cá Nhân</h2>

        <%-- Hiển thị thông báo thành công --%>
        <% if (updateSuccess != null && updateSuccess.equals("true")) { %>
            <div class="alert alert-success">Thông tin đã được cập nhật thành công!</div>
        <% } %>

        <%-- Hiển thị thông báo lỗi --%>
        <% if (updateError != null && updateError.equals("true")) { %>
            <div class="alert alert-danger">Đã xảy ra lỗi trong quá trình cập nhật!</div>
        <% }%>

        <form action="update_profile" method="post">
            <div class="mb-3">
                <label class="form-label"><strong>Tên</strong></label>
                <input type="text" class="form-control" name="name" value="<%= customer.getName()%>" required>
            </div>
            <div class="mb-3">
                <label class="form-label"><strong>Email</strong></label>
                <input type="text" class="form-control" name="email" value="<%= customer.getEmail()%>" required>
            </div>
            <div class="mb-3">
                <label class="form-label"><strong>Số điện thoại</strong></label>
                <input type="text" class="form-control" name="phone" value="<%= customer.getPhoneNumber()%>" required>
            </div>
            <div class="profile-btns">
                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                <a href="change_password.jsp" class="btn btn-warning">Đổi mật khẩu</a>
            </div>
        </form>
        
        <!-- Separator line -->
        <div class="separator"></div>
        
        <!-- Nút Trang chủ nổi bật -->
        <div class="home-btn-container">
            <a href="BidaShop" class="btn btn-home">Trang chủ</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>