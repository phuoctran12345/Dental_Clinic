<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đổi Mật Khẩu - Happy Smile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .profile-card {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                border: none;
                margin-top: 50px;
                margin-bottom: 50px;
            }

            .card-header {
                background: linear-gradient(135deg, #4E80EE 0%, #6c5ce7 100%);
                color: white;
                border-radius: 20px 20px 0 0 !important;
                padding: 30px;
                text-align: center;
                border: none;
            }

            .feature-icon {
                width: 80px;
                height: 80px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                font-size: 35px;
            }

            .card-body {
                padding: 40px;
            }

            .form-control {
                border-radius: 12px;
                border: 2px solid #e9ecef;
                padding: 15px 20px;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: #4E80EE;
                box-shadow: 0 0 0 0.2rem rgba(78, 128, 238, 0.25);
            }

            .input-group-text {
                border-radius: 12px 0 0 12px;
                border: 2px solid #e9ecef;
                border-right: none;
                background: #f8f9fa;
                padding: 15px 20px;
            }

            .btn {
                border-radius: 12px;
                padding: 15px 30px;
                font-weight: 600;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: linear-gradient(135deg, #4E80EE 0%, #6c5ce7 100%);
                border: none;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(78, 128, 238, 0.3);
            }

            .btn-secondary {
                background: #6c757d;
                border: none;
            }

            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-2px);
            }

            .alert {
                border-radius: 12px;
                padding: 20px;
                border: none;
            }

            .form-text {
                color: #6c757d;
                font-size: 14px;
                margin-top: 8px;
            }

            .back-link {
                color: #4E80EE;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .back-link:hover {
                color: #6c5ce7;
                text-decoration: underline;
            }

            .steps-indicator {
                display: flex;
                justify-content: space-between;
                margin-bottom: 30px;
                padding: 0 20px;
            }

            .step {
                flex: 1;
                text-align: center;
                position: relative;
            }

            .step::before {
                content: '';
                position: absolute;
                top: 15px;
                left: 50%;
                width: 100%;
                height: 2px;
                background: #e9ecef;
                transform: translateX(-50%);
                z-index: 1;
            }

            .step:last-child::before {
                display: none;
            }

            .step-circle {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                background: #4E80EE;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 10px;
                font-weight: bold;
                position: relative;
                z-index: 2;
            }

            .step.completed .step-circle {
                background: #28a745;
            }

            .step.active .step-circle {
                background: #4E80EE;
                box-shadow: 0 0 0 4px rgba(78, 128, 238, 0.3);
            }

            .step-label {
                font-size: 12px;
                color: #6c757d;
                font-weight: 600;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card profile-card">
                        <div class="card-header">
                            <div class="feature-icon">
                                <i class="fas fa-user-shield"></i>
                            </div>
                            <h3 class="mb-0">Đổi Mật Khẩu</h3>
                            <p class="mb-0 opacity-90">Xác thực OTP qua email để bảo mật</p>
                        </div>

                        <div class="card-body">
                            <!-- Steps Indicator -->
                            <div class="steps-indicator">
                                <div class="step active">
                                    <div class="step-circle">1</div>
                                    <div class="step-label">Xác thực Email</div>
                                </div>
                                <div class="step">
                                    <div class="step-circle">2</div>
                                    <div class="step-label">Nhập OTP</div>
                                </div>
                                <div class="step">
                                    <div class="step-circle">3</div>
                                    <div class="step-label">Mật khẩu mới</div>
                                </div>
                            </div>

                            <!-- Back to Profile Link -->
                            <div class="text-center mb-4">
                                <a href="user_taikhoan.jsp" class="back-link">
                                    <i class="fas fa-arrow-left me-2"></i>Quay về trang tài khoản
                                </a>
                            </div>

                            <!-- Hiển thị thông báo lỗi -->
                            <% if (request.getAttribute("error") !=null) { %>
                                <div class="alert alert-danger d-flex align-items-center" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <%= request.getAttribute("error") %>
                                </div>
                                <% } %>

                                    <!-- Hiển thị thông báo thành công -->
                                    <% if (request.getAttribute("success") !=null) { %>
                                        <div class="alert alert-success d-flex align-items-center" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>
                                            <%= request.getAttribute("success") %>
                                        </div>
                                        <% } %>

                                            <!-- Form gửi OTP -->
                                            <div class="text-center">
                                                <div class="alert alert-info">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    <strong>Xác thực bảo mật:</strong><br>
                                                    Chúng tôi sẽ gửi mã OTP đến email:
                                                    <strong>
                                                        <%= request.getAttribute("email") !=null ?
                                                            request.getAttribute("email") : "" %>
                                                    </strong>
                                                </div>

                                                <form method="post" action="ResetPasswordServlet">
                                                    <input type="hidden" name="action" value="send-otp-profile">

                                                    <div class="d-grid gap-3">
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="fas fa-paper-plane me-2"></i>Gửi Mã OTP
                                                        </button>

                                                        <a href="user_taikhoan.jsp" class="btn btn-secondary">
                                                            <i class="fas fa-times me-2"></i>Hủy bỏ
                                                        </a>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- Thông tin bổ sung -->
                                            <div class="mt-4">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-shield-alt text-primary me-2"></i>
                                                            <small class="text-muted">Bảo mật cao</small>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-clock text-primary me-2"></i>
                                                            <small class="text-muted">OTP có hiệu lực 5 phút</small>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-envelope text-primary me-2"></i>
                                                            <small class="text-muted">Kiểm tra hộp thư email</small>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-key text-primary me-2"></i>
                                                            <small class="text-muted">Mã OTP 6 chữ số</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <hr class="my-4">

                                            <!-- Footer Note -->
                                            <div class="text-center">
                                                <small class="text-muted">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Nếu bạn không nhận được email, vui lòng kiểm tra thư mục spam hoặc
                                                    <a href="javascript:void(0)" onclick="window.location.reload()"
                                                        class="text-primary">thử lại</a>
                                                </small>
                                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>