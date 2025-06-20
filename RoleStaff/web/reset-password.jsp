
<%-- 
    Document   : reset-password.jsp
    Created on : Reset Password Page
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Hệ thống Quản lý Bệnh viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95);
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px 20px 0 0 !important;
            border: none;
            color: white;
            text-align: center;
            padding: 2rem;
        }
        
        .form-control {
            border-radius: 12px;
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .alert {
            border-radius: 12px;
            border: none;
        }
        
        .input-group-text {
            border: 2px solid #e9ecef;
            border-right: none;
            border-radius: 12px 0 0 12px;
            background: #f8f9fa;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 12px 12px 0;
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            margin: 0 auto 1rem;
        }
        
        .forgot-password-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .forgot-password-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .requirements-box {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .requirements-box ul {
            margin: 0;
            padding-left: 1.5rem;
        }
        
        .requirements-box li {
            font-size: 0.875rem;
            color: #6c757d;
            margin-bottom: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6 col-lg-5">
                <div class="card">
                    <div class="card-header">
                        <div class="feature-icon">
                            <i class="fas fa-key"></i>
                        </div>
                        <h3 class="mb-0">Đặt lại mật khẩu</h3>
                        <p class="mb-0 opacity-90">Tạo mật khẩu mới cho tài khoản</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <!-- Hiển thị thông báo thành công -->
                        <% if (request.getAttribute("success") != null) { %>
                            <div class="alert alert-success d-flex align-items-center" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <%= request.getAttribute("success") %>
                            </div>
                        <% } %>
                        
                        <!-- Hiển thị thông báo lỗi -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <form method="post" action="UpdatePasswordServlet">
                            <div class="mb-3">
                                <label for="newPassword" class="form-label fw-bold">
                                    <i class="fas fa-lock me-2 text-primary"></i>Mật khẩu mới
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-key text-muted"></i>
                                    </span>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                           placeholder="Nhập mật khẩu mới" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label fw-bold">
                                    <i class="fas fa-lock me-2 text-primary"></i>Xác nhận mật khẩu
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-shield-alt text-muted"></i>
                                    </span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="Nhập lại mật khẩu mới" required>
                                </div>
                            </div>
                            
                            <div class="requirements-box">
                                <h6 class="mb-2">
                                    <i class="fas fa-info-circle text-primary me-2"></i>Yêu cầu mật khẩu:
                                </h6>
                                <ul>
                                    <li>Ít nhất 6 ký tự</li>
                                    <li>Bao gồm cả chữ cái và số</li>
                                    <li>Không chứa khoảng trắng</li>
                                </ul>
                            </div>
                            
                            <div class="d-grid gap-2 mb-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-key me-2"></i>Đặt lại mật khẩu
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center">
                            <a href="login.jsp" class="forgot-password-link">
                                <i class="fas fa-arrow-left me-1"></i>
                                Quay lại đăng nhập
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <small class="text-white-50">
                        <i class="fas fa-shield-alt me-1"></i>
                        Dữ liệu được bảo mật với mã hóa SSL
                    </small>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
