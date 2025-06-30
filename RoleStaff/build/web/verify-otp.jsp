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
        :root {
            --primary-color: #4E80EE;
            --primary-dark: #3A6BD9;
            --light-bg: #F8FAFF;
        }
        
        body {
            background: var(--light-bg);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 0;
        }
        
        .main-container {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            padding: 0;
        }
        
        .card {
            border: none;
            border-radius: 5px;
            box-shadow: 0 5px 20px rgba(78, 128, 238, 0.1);
            overflow: hidden;
            height: auto;
        }
        
        .card-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            border-radius: 0 !important;
            border: none;
            color: white;
            text-align: center;
            padding: 1.5rem;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        .feature-icon {
            width: 70px;
            height: 70px;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 28px;
            margin: 0 auto 1rem;
        }
        
        .back-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 14px;
        }
        
        /* Form styles */
        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            letter-spacing: 5px;
            height: 50px;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(78, 128, 238, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 500;
            font-size: 15px;
        }
        
        /* Notification boxes */
        .alert-box {
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            border-left: 4px solid;
            font-size: 14px;
        }
        
        .alert-success {
            background-color: #E8F5E9;
            border-left-color: #4CAF50;
        }
        
        .alert-danger {
            background-color: #FFEBEE;
            border-left-color: #F44336;
        }
        
        .alert-warning {
            background-color: #FFF8E1;
            border-left-color: #FFC107;
        }
        
        .alert-info {
            background-color: #E3F2FD;
            border-left-color: var(--primary-color);
        }
        
        /* Timer */
        .timer-container {
            background: #FFF3E0;
            border-radius: 10px;
            padding: 0.8rem;
            margin: 1rem 0;
            text-align: center;
            border-left: 4px solid #FFA000;
            font-size: 14px;
        }
        
        .timer {
            font-size: 18px;
            font-weight: bold;
            color: #E65100;
        }
        
        /* Responsive */
        @media (max-width: 576px) {
            .card-header, .card-body {
                padding: 1rem;
            }
            
            .feature-icon {
                width: 60px;
                height: 60px;
                font-size: 24px;
            }
            
            .form-control {
                font-size: 18px;
                height: 45px;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Back Link -->
        <a href="ResetPasswordServlet?action=forgot-password" class="back-link">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
        
        <div class="card">
            <div class="card-header">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3 class="mb-1" style="font-size: 1.5rem;">Xác Thực OTP</h3>
                <p class="mb-0" style="font-size: 0.9rem;">Nhập mã OTP từ email</p>
            </div>
            
            <div class="card-body">
                <!-- Hiển thị thông báo gửi email -->
                <% if (session.getAttribute("otpSentMessage") != null) { %>
                    <% String message = (String) session.getAttribute("otpSentMessage"); %>
                    <% if (message.contains("TEST MODE")) { %>
                        <div class="alert-box alert-warning">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-info-circle me-2"></i>
                                <div>
                                    <strong>Test Mode:</strong><br>
                                    <%= message %>
                                </div>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="alert-box alert-success">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle me-2"></i>
                                <div>
                                    <%= message %>
                                </div>
                            </div>
                        </div>
                    <% } %>
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
                            <span class="timer ms-1" id="countdown"><%= remainingSeconds %></span>
                            <span class="ms-1">giây</span>
                        </div>
                    </div>
                <% } %>
                
                <!-- Hiển thị thông báo lỗi -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert-box alert-danger">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <div>
                                <%= request.getAttribute("error") %>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <!-- Form OTP -->
                <form method="post" action="ResetPasswordServlet" novalidate>
                    <input type="hidden" name="action" value="verify-otp">
                    
                    <div class="mb-3">
                        <label for="otp" class="form-label fw-bold mb-2" style="font-size: 0.9rem;">
                            <i class="fas fa-key me-1" style="color: var(--primary-color);"></i>Mã OTP
                        </label>
                        <input type="text" class="form-control" id="otp" name="otp" 
                               placeholder="000000" maxlength="6" 
                               pattern="[0-9]{6}" title="Vui lòng nhập 6 chữ số"
                               required autocomplete="off">
                        <div class="form-text mt-1" style="font-size: 0.8rem;">
                            <i class="fas fa-info-circle me-1"></i>
                            Nhập mã OTP gồm 6 chữ số từ email
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 mt-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check-circle me-1"></i>Xác Thực
                        </button>
                    </div>
                </form>
                
                <!-- Resend OTP -->
                <div class="text-center mt-3">
                    <p class="mb-2 text-muted" style="font-size: 0.9rem;">
                        <i class="fas fa-question-circle me-1"></i>
                        Không nhận được mã OTP?
                    </p>
                    <a href="ResetPasswordServlet?action=forgot-password" class="btn btn-outline-primary btn-sm">
                        <i class="fas fa-redo me-1"></i>Gửi lại mã
                    </a>
                </div>
                
                <div class="text-center mt-3">
                    <small class="text-muted" style="font-size: 0.8rem;">
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