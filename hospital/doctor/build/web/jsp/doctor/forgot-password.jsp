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
        
        .btn-secondary {
            border-radius: 12px;
            padding: 12px 30px;
            font-weight: 600;
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
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            margin: 0 auto 1rem;
        }
        
        .back-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .back-link:hover {
            color: #764ba2;
            transform: translateX(-5px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6 col-lg-5">
                <!-- Back Link -->
                <div class="mb-3">
                    <a href="/doctor/jsp/doctor/login.jsp" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập
                    </a>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <div class="feature-icon">
                            <i class="fas fa-key"></i>
                        </div>
                        <h3 class="mb-0">Quên Mật Khẩu</h3>
                        <p class="mb-0 opacity-90">Nhập email để nhận mã OTP</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <!-- Hiển thị thông báo lỗi -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <!-- Hiển thị thông báo thành công -->
                        <% if (request.getAttribute("success") != null) { %>
                            <div class="alert alert-success d-flex align-items-center" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <%= request.getAttribute("success") %>
                            </div>
                        <% } %>
                        
                        <form method="post" action="/doctor/ResetPasswordServlet" novalidate>
                            <input type="hidden" name="action" value="send-otp">
                            
                            <div class="mb-4">
                                <label for="email" class="form-label fw-bold">
                                    <i class="fas fa-envelope me-2 text-primary"></i>Email
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-at text-muted"></i>
                                    </span>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="Nhập địa chỉ email của bạn"
                                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                                           required>
                                </div>
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Chúng tôi sẽ gửi mã OTP đến email này để xác thực
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-2"></i>Gửi Mã OTP
                                </button>
                            </div>
                        </form>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <h6 class="text-muted mb-3">Hướng dẫn:</h6>
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="d-flex align-items-center">
                                        <div class="me-3">
                                            <div style="width: 40px; height: 40px; border-radius: 50%; background: #e3f2fd; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-envelope text-primary"></i>
                                            </div>
                                        </div>
                                        <div class="text-start">
                                            <small class="fw-bold">Bước 1</small><br>
                                            <small class="text-muted">Nhập email đã đăng ký</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex align-items-center">
                                        <div class="me-3">
                                            <div style="width: 40px; height: 40px; border-radius: 50%; background: #f3e5f5; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-shield-alt text-primary"></i>
                                            </div>
                                        </div>
                                        <div class="text-start">
                                            <small class="fw-bold">Bước 2</small><br>
                                            <small class="text-muted">Nhập mã OTP từ email</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex align-items-center">
                                        <div class="me-3">
                                            <div style="width: 40px; height: 40px; border-radius: 50%; background: #e8f5e8; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-key text-primary"></i>
                                            </div>
                                        </div>
                                        <div class="text-start">
                                            <small class="fw-bold">Bước 3</small><br>
                                            <small class="text-muted">Đặt mật khẩu mới</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <small class="text-white-50">
                        <i class="fas fa-lock me-1"></i>
                        Thông tin của bạn được bảo mật hoàn toàn
                    </small>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
