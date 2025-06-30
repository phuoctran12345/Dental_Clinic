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
        :root {
            --primary-color: #4E80EE;
            --primary-light: #EFF4FF;
            --border-color: #E2E8F0;
            --text-color: #2D3748;
            --text-light: #718096;
        }
        
        body {
            background: #F8FAFF;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
            margin: 0;
        }
        
        .reset-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(78, 128, 238, 0.1);
            width: 100%;
            max-width: 1000px;
            overflow: hidden;
        }
        
        .card-header {
            background: var(--primary-color);
            color: white;
            text-align: center;
            padding: 1.5rem;
            border-bottom: none;
        }
        
        .feature-icon {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 24px;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 12px 15px;
            font-size: 15px;
            transition: all 0.2s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(78, 128, 238, 0.1);
        }
        
        .input-group-text {
            background: var(--primary-light);
            border: 1px solid var(--border-color);
            border-right: none;
            border-radius: 8px 0 0 8px;
            color: var(--primary-color);
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 8px 8px 0;
        }
        
        .btn-primary {
            background: var(--primary-color);
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .btn-primary:hover {
            background: #3A6BD9;
            transform: translateY(-1px);
        }
        
        .btn-outline-secondary {
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
        }
        
        .requirements-box {
            background: var(--primary-light);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-left: 3px solid var(--primary-color);
        }
        
        .requirements-box ul {
            margin: 0.5rem 0 0 1rem;
            padding: 0;
        }
        
        .requirements-box li {
            font-size: 14px;
            color: var(--text-color);
            margin-bottom: 0.3rem;
        }
        
        .alert {
            border-radius: 8px;
            padding: 1rem;
            font-size: 15px;
        }
        
        .alert-success {
            background: #F0FFF4;
            color: #2F855A;
            border-left: 3px solid #38A169;
        }
        
        .alert-danger {
            background: #FFF5F5;
            color: #C53030;
            border-left: 3px solid #E53E3E;
        }
        
        .form-label {
            font-weight: 600;
            font-size: 15px;
            color: var(--text-color);
            margin-bottom: 0.5rem;
        }
        
        h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .card-header p {
            font-size: 0.95rem;
            opacity: 0.9;
        }
        
        @media (max-width: 768px) {
            .card-body {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="reset-card">
        <div class="card-header">
            <div class="feature-icon">
                <i class="fas fa-key"></i>
            </div>
            <h3>Đặt lại mật khẩu</h3>
            <p>Tạo mật khẩu mới cho tài khoản</p>
        </div>
        
        <div class="card-body">
            <!-- Hiển thị thông báo thành công -->
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success d-flex align-items-center mb-4">
                    <i class="fas fa-check-circle me-2"></i>
                    <div><%= request.getAttribute("success") %></div>
                </div>
            <% } %>
            
            <!-- Hiển thị thông báo lỗi -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center mb-4">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
            <% } %>
            
            <form method="post" action="UpdatePasswordServlet">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="newPassword" class="form-label">
                            <i class="fas fa-lock me-2" style="color: var(--primary-color);"></i>Mật khẩu mới
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-key"></i>
                            </span>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                   placeholder="Nhập mật khẩu mới" required>
                        </div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="confirmPassword" class="form-label">
                            <i class="fas fa-lock me-2" style="color: var(--primary-color);"></i>Xác nhận mật khẩu
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-shield-alt"></i>
                            </span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu mới" required>
                        </div>
                    </div>
                </div>
                
                <div class="requirements-box mb-4">
                    <h6 class="mb-2" style="color: var(--primary-color);">
                        <i class="fas fa-info-circle me-2"></i>Yêu cầu mật khẩu:
                    </h6>
                    <ul>
                        <li>Ít nhất 6 ký tự</li>
                        <li>Bao gồm cả chữ cái và số</li>
                        <li>Không chứa khoảng trắng</li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-key me-2"></i>Đặt lại mật khẩu
                        </button>
                    </div>
                    <div class="col-md-6 mb-2">
                        <a href="login.jsp" class="btn btn-outline-secondary w-100">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>