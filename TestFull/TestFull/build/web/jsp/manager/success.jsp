<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="manager_menu.jsp" %>
<%@ include file="manager_header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thành công</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            overflow-y: auto;
        }
        .container {
            font-family: Arial, sans-serif;
            padding-left: 282px;
            padding-top: 15px;
            margin-right: 50px;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        #menu-toggle:checked ~.container {
            transform: translateX(-125px);
            transition: transform 0.3s ease;
        }
        
        .success-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        
        .success-icon {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }
        
        .success-title {
            font-size: 24px;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 15px;
        }
        
        .success-message {
            color: #6c757d;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #0056b3;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #545b62;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-card">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2 class="success-title">Thêm nhân viên thành công!</h2>
            <p class="success-message">
                Tài khoản nhân viên đã được tạo và lưu vào hệ thống thành công.
            </p>
            <div class="btn-group">
                <a href="manager_danhsach.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Quay lại 
                </a>
            </div>
        </div>
    </div>
</body>
</html>