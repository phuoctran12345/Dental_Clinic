<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực OTP - Hệ thống Quản lý Bệnh viện</title>
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
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 8px;
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
        
        .timer-container {
            background: linear-gradient(135deg, #fff3cd 0%, #fff8dc 100%);
            border-radius: 12px;
            padding: 1rem;
            margin: 1rem 0;
            text-align: center;
            border: 2px solid #ffc107;
        }
        
        .timer {
            font-size: 24px;
            font-weight: bold;
            color: #856404;
        }
        
        .email-info {
            background: #e3f2fd;
            border-radius: 12px;
            padding: 1rem;
            margin: 1rem 0;
            border-left: 4px solid #2196f3;
        }
        
        .resend-info {
            background: #f5f5f5;
            border-radius: 12px;
            padding: 1rem;
            margin: 1rem 0;
            text-align: center;
        }
        
        .test-info {
            background: #fff3cd;
            border-radius: 12px;
            padding: 1rem;
            margin: 1rem 0;
            border-left: 4px solid #ffc107;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6 col-lg-5">
                <!-- Back Link -->
                <div class="mb-3">
                    <a href="ResetPasswordServlet?action=forgot-password" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3 class="mb-0">Xác Thực OTP</h3>
                        <p class="mb-0 opacity-90">Nhập mã OTP từ email</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <!-- Hiển thị thông báo gửi email -->
                        <% if (session.getAttribute("otpSentMessage") != null) { %>
                            <% String message = (String) session.getAttribute("otpSentMessage"); %>
                            <% if (message.contains("TEST MODE")) { %>
                                <div class="test-info">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-info-circle text-warning me-2"></i>
                                        <div>
                                            <strong>Test Mode:</strong><br>
                                            <%= message %>
                                        </div>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="alert alert-success" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        <div>
                                            <%= message %>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        <% } %>
                        
                        <!-- Hiển thị email -->
                        <% if (request.getAttribute("email") != null) { %>
                            <div class="email-info">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-envelope text-primary me-2"></i>
                                    <div>
                                        <small class="text-muted">Mã OTP đã được gửi đến:</small><br>
                                        <strong><%= request.getAttribute("email") %></strong>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        
                        <!-- Timer -->
                        <% 
                        Long remainingSeconds = (Long) request.getAttribute("remainingSeconds");
                        if (remainingSeconds != null) { 
                        %>
                            <div class="timer-container">
                                <div class="d-flex align-items-center justify-content-center">
                                    <i class="fas fa-clock me-2"></i>
                                    <span>Mã OTP sẽ hết hạn sau: </span>
                                    <span class="timer ms-2" id="countdown"><%= remainingSeconds %></span>
                                    <span class="ms-1">giây</span>
                                </div>
                            </div>
                        <% } %>
                        
                        <!-- Hiển thị thông báo lỗi -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <form method="post" action="ResetPasswordServlet" novalidate>
                            <input type="hidden" name="action" value="verify-otp">
                            
                            <div class="mb-4">
                                <label for="otp" class="form-label fw-bold">
                                    <i class="fas fa-key me-2 text-primary"></i>Mã OTP
                                </label>
                                <input type="text" class="form-control" id="otp" name="otp" 
                                       placeholder="000000" maxlength="6" 
                                       pattern="[0-9]{6}" title="Vui lòng nhập 6 chữ số"
                                       required autocomplete="off">
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Nhập mã OTP gồm 6 chữ số từ email
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-check-circle me-2"></i>Xác Thực
                                </button>
                            </div>
                        </form>
                        
                        <div class="resend-info">
                            <p class="mb-2">
                                <i class="fas fa-question-circle me-1"></i>
                                Không nhận được mã OTP?
                            </p>
                            <a href="ResetPasswordServlet?action=forgot-password" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-redo me-1"></i>Gửi lại mã
                            </a>
                        </div>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="d-flex align-items-center justify-content-center">
                                        <div class="me-3">
                                            <div style="width: 40px; height: 40px; border-radius: 50%; background: #fff3e0; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-clock text-warning"></i>
                                            </div>
                                        </div>
                                        <div class="text-start">
                                            <small class="fw-bold">Lưu ý thời gian</small><br>
                                            <small class="text-muted">Mã OTP có hiệu lực trong 5 phút</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex align-items-center justify-content-center">
                                        <div class="me-3">
                                            <div style="width: 40px; height: 40px; border-radius: 50%; background: #ffebee; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-eye-slash text-danger"></i>
                                            </div>
                                        </div>
                                        <div class="text-start">
                                            <small class="fw-bold">Bảo mật</small><br>
                                            <small class="text-muted">Không chia sẻ mã OTP với ai</small>
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
                        Kết nối được mã hóa và bảo mật
                    </small>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Hidden input để truyền remainingSeconds cho JavaScript -->
    <% if (remainingSeconds != null) { %>
        <input type="hidden" id="remainingSeconds" value="<%= remainingSeconds.longValue() %>">
    <% } %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Countdown timer
        const remainingSecondsInput = document.getElementById('remainingSeconds');
        if (remainingSecondsInput) {
            let timeLeft = parseInt(remainingSecondsInput.value);
            const countdownElement = document.getElementById('countdown');
            
            if (countdownElement && timeLeft > 0) {
                const timer = setInterval(function() {
                    if (timeLeft <= 0) {
                        clearInterval(timer);
                        countdownElement.textContent = '0';
                        // Redirect to forgot password page when time expires
                        setTimeout(function() {
                            window.location.href = 'ResetPasswordServlet?action=forgot-password';
                        }, 2000);
                    } else {
                        countdownElement.textContent = timeLeft;
                        timeLeft--;
                    }
                }, 1000);
            }
        }
        
        // Auto format OTP input
        document.getElementById('otp').addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^0-9]/g, '');
            if (value.length > 6) {
                value = value.substring(0, 6);
            }
            e.target.value = value;
        });
        
        // Auto focus on OTP input
        document.getElementById('otp').focus();
    </script>
</body>
</html> 