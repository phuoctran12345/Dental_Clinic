<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - Hệ thống Quản lý Bệnh viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #F8FAFF;
            background-size: cover; /* Nền phủ toàn màn hình trên màn hình lớn */
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .main-container {
            display: flex;
            width: 100%;
            max-width: 1000px;
            gap: 30px;
        }
        
        .form-section {
            flex: 1;
            padding: 40px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }
        
        .steps-section {
            flex: 1;
            padding: 40px;
            background-color: #fff;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .forgot-container h3 {
            color: #3b82f6;
            font-size: 34px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-control {
            border-radius: 12px;
            border: 1px solid #ced4da;
            padding: 15px 20px;
            font-size: 16px;
            height: 55px;
            transition: all 0.3s ease;
            margin-bottom: 10px;
        }
        
        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 0.3rem rgba(59, 130, 246, 0.25);
        }
        
        .btn-primary {
            background-color: #0432b5;
            border: none;
            border-radius: 12px;
            padding: 16px;
            font-weight: 500;
            font-size: 17px;
            transition: all 0.3s ease;
            height: 55px;
            width: 100%;
        }
        
        .btn-primary:hover {
            background-color: #022a8c;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(4, 50, 181, 0.3);
        }
        
        .alert {
            border-radius: 12px;
            padding: 15px 20px;
            font-size: 15px;
        }
        
        .back-link {
            color: #1f2937;
            font-weight: 500;
            font-size: 16px;
            text-decoration: none;
            transition: color 0.2s ease;
            display: inline-block;
            margin-bottom: 25px;
        }
        
        .back-link:hover {
            color: #3b82f6;
            text-decoration: underline;
            transform: translateX(-3px);
        }
        
        .feature-icon {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            margin: 0 auto 30px;
            box-shadow: 0 5px 20px rgba(59, 130, 246, 0.3);
        }
        
        .step-item {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            padding: 20px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .step-number {
            width: 40px;
            height: 40px;
            min-width: 40px;
            border-radius: 50%;
            background-color: #3b82f6;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-weight: bold;
            font-size: 18px;
        }
        
        .step-text {
            flex: 1;
        }
        
        .step-text small {
            display: block;
            line-height: 1.5;
            font-size: 15px;
        }
        
        .step-title {
            font-weight: 600;
            color: #1f2937;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .step-desc {
            color: #6b7280;
        }
        
        .form-label {
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 10px;
            display: block;
        }
        
        .form-text {
            font-size: 14px;
            margin-top: 8px;
        }
        
        .text-muted {
            font-size: 16px;
            color: #6b7280 !important;
        }
        
        .steps-title {
            font-size: 24px;
            font-weight: 600;
            color: #3b82f6;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .security-note {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            color: #6b7280;
        }
        
        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }
            
            .form-section, .steps-section {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Phần form quên mật khẩu -->
        <div class="form-section">
            <a href="login.jsp" class="back-link">
                <i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập
            </a>
            
            <div class="text-center mb-4">
                <div class="feature-icon">
                    <i class="fas fa-key"></i>
                </div>
                <h3 class="forgot-container h3">Quên Mật Khẩu</h3>
                <p class="text-muted">Nhập email để nhận mã OTP khôi phục</p>
            </div>
            
            <!-- Hiển thị thông báo lỗi -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center">
                    <i class="fas fa-exclamation-circle me-3" style="font-size: 20px;"></i>
                    <div style="font-size: 15px;"><%= request.getAttribute("error") %></div>
                </div>
            <% } %>
            
            <!-- Hiển thị thông báo thành công -->
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success d-flex align-items-center">
                    <i class="fas fa-check-circle me-3" style="font-size: 20px;"></i>
                    <div style="font-size: 15px;"><%= request.getAttribute("success") %></div>
                </div>
            <% } %>
            
            <form method="post" action="ResetPasswordServlet" novalidate>
                <input type="hidden" name="action" value="send-otp">
                
                <div class="mb-4">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="Nhập địa chỉ email của bạn"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                           required>
                    <div class="form-text">
                        <i class="fas fa-info-circle me-1"></i>
                        Chúng tôi sẽ gửi mã OTP đến email này để xác thực
                    </div>
                </div>
                
                <div class="d-grid gap-3">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-2"></i>Gửi Mã OTP
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Phần hướng dẫn các bước -->
        <div class="steps-section">
            <h4 class="steps-title">Quy trình khôi phục mật khẩu</h4>
            
            <div class="step-item">
                <div class="step-number">1</div>
                <div class="step-text">
                    <small class="step-title">Nhập email đã đăng ký</small>
                    <small class="step-desc">Hệ thống sẽ kiểm tra email của bạn</small>
                </div>
            </div>
            
            <div class="step-item">
                <div class="step-number">2</div>
                <div class="step-text">
                    <small class="step-title">Nhập mã OTP từ email</small>
                    <small class="step-desc">Mã OTP sẽ được gửi đến hộp thư của bạn</small>
                </div>
            </div>
            
            <div class="step-item">
                <div class="step-number">3</div>
                <div class="step-text">
                    <small class="step-title">Đặt mật khẩu mới</small>
                    <small class="step-desc">Tạo mật khẩu mới cho tài khoản</small>
                </div>
            </div>
            
            <div class="security-note">
                <i class="fas fa-lock me-1"></i>
                Thông tin của bạn được bảo mật hoàn toàn
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>