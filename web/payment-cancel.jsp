<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán đã hủy - Phòng khám nha khoa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1a237e;
            --danger-color: #dc3545;
            --warning-color: #ff9800;
            --success-color: #28a745;
            --light-gray: #f8f9fa;
            --border-color: #e0e0e0;
        }
        
        body {
            background-color: #f5f5f5;
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .cancel-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            max-width: 900px;
            margin: 0 auto;
            border: 1px solid var(--border-color);
        }
        
        .cancel-header {
            background-color: var(--danger-color);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .cancel-icon {
            font-size: 3.5rem;
            margin-bottom: 1rem;
        }
        
        .cancel-content {
            padding: 2rem;
        }
        
        .info-box {
            background: var(--light-gray);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--danger-color);
        }
        
        .reasons-list {
            background: #fff8e1;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border: 1px solid #ffe0b2;
        }
        
        .reason-item {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #ffe0b2;
        }
        
        .reason-item:last-child {
            border-bottom: none;
        }
        
        .reason-icon {
            color: var(--warning-color);
            margin-right: 0.75rem;
            width: 20px;
        }
        
        .next-steps {
            background: #e7f3ff;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border: 1px solid #b8daff;
        }
        
        .status-badge {
            background: var(--danger-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .action-buttons {
            text-align: center;
            margin: 2rem 0;
        }
        
        .btn-action {
            margin: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-weight: 500;
            min-width: 180px;
        }
        
        /* Animation for icon */
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1); }
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        
        /* Responsive adjustments */
        @media (max-width: 576px) {
            .cancel-header {
                padding: 1.5rem;
            }
            
            .cancel-content {
                padding: 1.5rem;
            }
            
            .btn-action {
                width: 100%;
                margin: 0.5rem 0;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="cancel-container">
            <!-- Cancel Header -->
            <div class="cancel-header">
                <div class="cancel-icon fade-in">
                    <i class="fas fa-times-circle"></i>
                </div>
                <h2 class="mb-2">Thanh toán đã hủy</h2>
                <p class="mb-0">Giao dịch của bạn đã được hủy bỏ</p>
            </div>

            <!-- Cancel Content -->
            <div class="cancel-content">
                <!-- Status Information -->
                <div class="info-box">
                    <h5 class="mb-3">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông tin giao dịch
                    </h5>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="fw-bold">Trạng thái:</span>
                        <span class="status-badge">
                            <i class="fas fa-times me-1"></i>Đã hủy
                        </span>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="fw-bold">Thời gian hủy:</span>
                        <span>
                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()) %>
                        </span>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fw-bold">Lý do:</span>
                        <span>Người dùng hủy giao dịch</span>
                    </div>

                    <!-- Thông báo slot đã được trả về -->
                    <c:if test="${slotReleased}">
                        <div class="alert alert-success mt-3">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle me-2"></i>
                                <div>
                                    <strong>Slot đã được trả về hàng đợi</strong>
                                    <div class="small">
                                        Ca khám có thể được đặt bởi người khác
                                        <c:if test="${not empty reservationInfo}">
                                            <div class="mt-1">
                                                <span class="badge bg-secondary me-1">Bác sĩ: ${reservationInfo.doctorId}</span>
                                                <span class="badge bg-secondary me-1">Ngày: ${reservationInfo.workDate}</span>
                                                <span class="badge bg-secondary">Slot: ${reservationInfo.slotId}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Possible Reasons -->
                <div class="reasons-list">
                    <h5 class="mb-3">
                        <i class="fas fa-lightbulb me-2"></i>
                        Có thể bạn đã hủy vì:
                    </h5>

                    <div class="reason-item">
                        <i class="fas fa-clock reason-icon"></i>
                        <span>Quá trình thanh toán mất nhiều thời gian</span>
                    </div>

                    <div class="reason-item">
                        <i class="fas fa-mobile-alt reason-icon"></i>
                        <span>Gặp khó khăn với ứng dụng ngân hàng</span>
                    </div>

                    <div class="reason-item">
                        <i class="fas fa-credit-card reason-icon"></i>
                        <span>Muốn thay đổi phương thức thanh toán</span>
                    </div>

                    <div class="reason-item">
                        <i class="fas fa-calendar-times reason-icon"></i>
                        <span>Cần thay đổi thời gian đặt lịch</span>
                    </div>
                </div>

                <!-- Next Steps -->
                <div class="next-steps">
                    <h5 class="mb-3">
                        <i class="fas fa-forward me-2"></i>
                        Bạn có thể làm gì tiếp theo?
                    </h5>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="d-flex align-items-start">
                                <i class="fas fa-redo mt-1 me-2 text-primary"></i>
                                <div>
                                    <strong>Thử lại thanh toán</strong>
                                    <div class="small text-muted">Quay lại trang thanh toán</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="d-flex align-items-start">
                                <i class="fas fa-phone mt-1 me-2 text-success"></i>
                                <div>
                                    <strong>Liên hệ hỗ trợ</strong>
                                    <div class="small text-muted">Gọi hotline để được tư vấn</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="d-flex align-items-start">
                                <i class="fas fa-hospital mt-1 me-2 text-info"></i>
                                <div>
                                    <strong>Đến trực tiếp</strong>
                                    <div class="small text-muted">Thanh toán tại quầy khi đến khám</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="d-flex align-items-start">
                                <i class="fas fa-comment-dots mt-1 me-2 text-warning"></i>
                                <div>
                                    <strong>Chat hỗ trợ</strong>
                                    <div class="small text-muted">Nhắn tin để được hỗ trợ nhanh</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="services" class="btn btn-primary btn-action">
                        <i class="fas fa-redo me-2"></i>Thử lại thanh toán
                    </a>
                    <a href="tel:1900-xxx-xxx" class="btn btn-success btn-action">
                        <i class="fas fa-phone me-2"></i>Gọi hotline
                    </a>
                    <a href="UserHompageServlet" class="btn btn-outline-secondary btn-action">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </div>

                <!-- Help Section -->
                <div class="alert alert-light">
                    <h6 class="mb-3"><i class="fas fa-headset me-2"></i>Cần hỗ trợ ngay?</h6>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-phone-alt me-2 text-muted"></i>
                                <div>
                                    <div class="small">Hotline</div>
                                    <strong>1900-xxx-xxx</strong>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-envelope me-2 text-muted"></i>
                                <div>
                                    <div class="small">Email</div>
                                    <strong>support@dental.clinic</strong>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-clock me-2 text-muted"></i>
                                <div>
                                    <div class="small">Thời gian</div>
                                    <strong>8:00 - 17:00 (T2-T7)</strong>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="d-flex align-items-center">
                                <i class="fab fa-zalo me-2 text-muted"></i>
                                <div>
                                    <div class="small">Zalo</div>
                                    <strong>0900-xxx-xxx</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Security Notice -->
                <div class="text-center small text-muted mt-3">
                    <i class="fas fa-shield-alt me-1"></i>
                    Thông tin của bạn được bảo mật an toàn. Không có khoản tiền nào bị trừ từ tài khoản.
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Show notification about cancellation
        function showCancelNotification() {
            const notification = document.createElement('div');
            notification.className = 'alert alert-warning position-fixed fade-in';
            notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 300px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);';
            notification.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <div>
                        <strong>Đã hủy!</strong>
                        <div class="small">Giao dịch của bạn đã được hủy bỏ an toàn.</div>
                    </div>
                    <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()"></button>
                </div>
            `;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (notification.parentElement) {
                    notification.style.opacity = '0';
                    setTimeout(() => notification.remove(), 300);
                }
            }, 5000);
        }

        // Auto redirect after time
        function startRedirectCountdown() {
            let timeLeft = 60; // 60 seconds
            const countdownElement = document.createElement('div');
            countdownElement.className = 'text-center mt-3 small text-muted';
            countdownElement.innerHTML = `
                <i class="fas fa-clock me-1"></i>
                Tự động chuyển về trang chủ sau <span id="countdown">${timeLeft}</span> giây
                <button class="btn btn-sm btn-link p-0 ms-2" onclick="clearAutoRedirect()">Hủy</button>
            `;

            document.querySelector('.cancel-content').appendChild(countdownElement);

            const interval = setInterval(() => {
                timeLeft--;
                const countdownSpan = document.getElementById('countdown');
                if (countdownSpan) {
                    countdownSpan.textContent = timeLeft;
                }

                if (timeLeft <= 0) {
                    clearInterval(interval);
                    window.location.href = 'index.jsp';
                }
            }, 1000);

            // Store interval globally to clear if needed
            window.autoRedirectInterval = interval;
        }

        function clearAutoRedirect() {
            if (window.autoRedirectInterval) {
                clearInterval(window.autoRedirectInterval);
                document.querySelector('.cancel-content').lastElementChild.remove();
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            showCancelNotification();
            setTimeout(startRedirectCountdown, 3000); // Start countdown after 3 seconds
        });
    </script>
</body>

</html>