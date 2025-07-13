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
            --light-bg: #F5F7FA;
            --text-dark: #1A2A44;
            --text-muted: #6B7280;
            --shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
        }
        
        body {
            background: var(--light-bg);
            min-height: 100vh;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            display: flex;
            align-items: center;
            margin: 0;
            color: var(--text-dark);
        }
        
        .main-container {
            width: 100%;
            max-width: 1150px;
            margin: 0 auto;
            padding: 0;
        }
        
        .card {
            border: none;
            border-radius: 8px;
            background: #FFFFFF;
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        
        .card-header {
            background: #4E80EE;
            color: white;
            text-align: center;
            padding: 17px;
        }
        
        .card-body {
            padding: 28px;
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 35px;
            margin: 0 auto 14px;
            transition: transform 0.3s ease;
        }

        
        .back-link {
            display: inline-flex;
            align-items: center;
            padding: 12px 24px;
            background: #FFFFFF;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            color: var(--primary-color);
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
            transition: all 0.3s ease;
            margin-bottom: 32px;
        }
        
        .back-link:hover {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 6px 16px rgba(78, 128, 238, 0.3);
            transform: translateY(-2px);
        }
        
        .back-link i {
            margin-right: 8px;
            font-size: 18px;
        }
        
        /* Form styles */
        .form-control {
            border-radius: 8px;
            padding: 16px 24px;
            border: 2px solid #E5E7EB;
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            letter-spacing: 8px;
            height: 64px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        
        
        .btn-primary {
            background: #4E80EE;
            border: none;
            border-radius: 8px;
            padding: 16px;
            font-weight: 600;
            font-size: 18px;
            width: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(78, 128, 238, 0.3);
        }
        
        /* Notification boxes */
        .alert-box {
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            border-left: 8px solid;
            background: #FFFFFF;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            font-size: 16px;
            display: flex;
            align-items: center;
        }
        
        .alert-success {
            border-left-color: #22C55E;
        }
        
        .alert-danger {
            border-left-color: #EF4444;
        }
        
        .alert-warning {
            border-left-color: #F59E0B;
        }
        
        .alert-info {
            border-left-color: var(--primary-color);
        }
        
        .alert-box i {
            font-size: 24px;
            margin-right: 16px;
        }
        
        /* Timer */
        .timer-container {
            background: #FFF7ED;
            border-radius: 8px;
            padding: 24px;
            margin: 24px 0;
            text-align: center;
            border-left: 8px solid #F97316;
            font-size: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        
        .timer {
            font-size: 24px;
            font-weight: 600;
            color: #C2410C;
        }
        
        /* Typography */
        .card-header h3 {
            font-size: 27px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .card-header p {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .form-label {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 9px;
        }
        
        .form-text {
            font-size: 14px;
            color: var(--text-muted);
            margin-top: 8px;
        }
        
        /* Resend OTP and Footer */
        .resend-section {
            margin-top: 32px;
            text-align: center;
        }
        
        .resend-section p {
            font-size: 16px;
            color: var(--text-muted);
            margin-bottom: 16px;
        }
        
        .btn-outline-primary {
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-outline-primary:hover {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 6px 16px rgba(78, 128, 238, 0.3);
        }
        
        .security-text {
            margin-top: 24px;
            font-size: 14px;
            color: var(--text-muted);
            text-align: center;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 24px;
            }
            
            .card-header, .card-body {
                padding: 32px;
            }
            
            .feature-icon {
                width: 64px;
                height: 64px;
                font-size: 28px;
            }
            
            .form-control {
                font-size: 24px;
                height: 56px;
            }
            
            .btn-primary {
                font-size: 16px;
                padding: 14px;
            }
            
            .alert-box, .timer-container {
                font-size: 14px;
                padding: 16px;
            }
            
            .timer {
                font-size: 20px;
            }
            
            .card-header h3 {
                font-size: 28px;
            }
            
            .back-link {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
        
        @media (max-width: 576px) {
            .card-header, .card-body {
                padding: 24px;
            }
            
            .feature-icon {
                width: 56px;
                height: 56px;
                font-size: 24px;
            }
            
            .form-control {
                font-size: 20px;
                height: 48px;
            }
            
            .btn-primary {
                font-size: 14px;
                padding: 12px;
            }
            
            .back-link {
                padding: 8px 16px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Back Link -->
        <a href="ResetPasswordServlet?action=forgot-password" class="back-link">
            <i class="fas fa-arrow-left"></i>Quay lại
        </a>
        
        <div class="card">
            <div class="card-header">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Xác Thực OTP</h3>
                <p>Nhập mã OTP từ email của bạn</p>
            </div>
            
            <div class="card-body">
                <!-- Hiển thị thông báo gửi email -->
                <% if (session.getAttribute("otpSentMessage") != null) { %>
                    <% String message = (String) session.getAttribute("otpSentMessage"); %>
                    <% if (message.contains("TEST MODE")) { %>
                        <div class="alert-box alert-warning">
                            <i class="fas fa-info-circle"></i>
                            <div>
                                <strong>Test Mode:</strong><br>
                                <%= message %>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="alert-box alert-success">
                            <i class="fas fa-check-circle"></i>
                            <div>
                                <%= message %>
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
                            <i class="fas fa-clock"></i>
                            <span>Mã OTP hết hạn sau:  </span>
                            <span class="timer" id="countdown"> <%= remainingSeconds %> </span>
                            <span>  giây</span>
                        </div>
                    </div>
                <% } %>
                
                <!-- Hiển thị thông báo lỗi -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert-box alert-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                        <div>
                            <%= request.getAttribute("error") %>
                        </div>
                    </div>
                <% } %>
                
                <!-- Form OTP -->
                <form method="post" action="ResetPasswordServlet" novalidate>
                    <input type="hidden" name="action" value="verify-otp">
                    
                    <div class="mb-3">
                        <label for="otp" class="form-label">
                            <i class="fas fa-key" style=" color: var(--primary-color);" ></i> Mã OTP
                        </label>
                        <input type="text" class="form-control" id="otp" name="otp" 
                               placeholder="000000" maxlength="6" 
                               pattern="[0-9]{6}" title="Vui lòng nhập 6 chữ số"
                               required autocomplete="off">
                        <div class="form-text">
                            <i class="fas fa-info-circle"></i> Nhập mã OTP 6 chữ số từ email
                        </div>
                    </div>
                    
                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check-circle"></i> Xác Thực
                        </button>
                    </div>
                </form>
                
                <!-- Resend OTP -->
                <div class="resend-section">
                    <p>
                        <i class="fas fa-question-circle"></i> Không nhận được mã OTP?
                    </p>
                    <a href="ResetPasswordServlet?action=forgot-password" class="btn btn-outline-primary">
                        <i class="fas fa-redo"></i> Gửi lại mã
                    </a>
                </div>
                
                <div class="security-text">
                    <i class="fas fa-lock"></i> Kết nối được mã hóa và bảo mật
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