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
                body {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    padding: 20px 0;
                }

                .cancel-container {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                    overflow: hidden;
                    max-width: 600px;
                    margin: 0 auto;
                }

                .cancel-header {
                    background: linear-gradient(45deg, #dc3545, #e74c3c);
                    color: white;
                    padding: 40px 30px;
                    text-align: center;
                    position: relative;
                }

                .cancel-icon {
                    font-size: 4rem;
                    margin-bottom: 20px;
                    animation: shake 1s ease-in-out;
                }

                @keyframes shake {

                    0%,
                    100% {
                        transform: translateX(0);
                    }

                    25% {
                        transform: translateX(-5px);
                    }

                    75% {
                        transform: translateX(5px);
                    }
                }

                .cancel-content {
                    padding: 40px 30px;
                }

                .info-box {
                    background: #f8f9fa;
                    border-radius: 15px;
                    padding: 25px;
                    margin: 20px 0;
                    border-left: 5px solid #dc3545;
                }

                .reasons-list {
                    background: #fff3cd;
                    border: 1px solid #ffeaa7;
                    border-radius: 10px;
                    padding: 20px;
                    margin: 20px 0;
                }

                .reason-item {
                    display: flex;
                    align-items: center;
                    margin: 10px 0;
                    padding: 8px 0;
                    border-bottom: 1px solid #f1c40f;
                }

                .reason-item:last-child {
                    border-bottom: none;
                }

                .reason-icon {
                    color: #f39c12;
                    margin-right: 10px;
                    width: 20px;
                    text-align: center;
                }

                .action-buttons {
                    text-align: center;
                    margin: 30px 0;
                }

                .btn-action {
                    margin: 10px;
                    padding: 12px 30px;
                    border-radius: 25px;
                    font-weight: 600;
                    transition: all 0.3s;
                }

                .btn-action:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                }

                .next-steps {
                    background: #e7f3ff;
                    border: 1px solid #b8daff;
                    border-radius: 10px;
                    padding: 20px;
                    margin: 20px 0;
                }

                .floating-elements {
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    overflow: hidden;
                    pointer-events: none;
                }

                .floating-icon {
                    position: absolute;
                    color: rgba(255, 255, 255, 0.1);
                    font-size: 2rem;
                    animation: float 6s ease-in-out infinite;
                }

                .floating-icon:nth-child(1) {
                    top: 10%;
                    left: 10%;
                    animation-delay: 0s;
                }

                .floating-icon:nth-child(2) {
                    top: 20%;
                    right: 10%;
                    animation-delay: 2s;
                }

                .floating-icon:nth-child(3) {
                    bottom: 20%;
                    left: 15%;
                    animation-delay: 4s;
                }

                @keyframes float {

                    0%,
                    100% {
                        transform: translateY(0px);
                    }

                    50% {
                        transform: translateY(-20px);
                    }
                }

                .status-badge {
                    background: #dc3545;
                    color: white;
                    padding: 8px 16px;
                    border-radius: 20px;
                    font-weight: 600;
                    display: inline-block;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="cancel-container">
                    <!-- Cancel Header -->
                    <div class="cancel-header">
                        <div class="floating-elements">
                            <i class="fas fa-times floating-icon"></i>
                            <i class="fas fa-exclamation floating-icon"></i>
                            <i class="fas fa-question floating-icon"></i>
                        </div>

                        <div class="cancel-icon">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <h1 class="mb-3">❌ THANH TOÁN ĐÃ HỦY</h1>
                        <p class="lead mb-0">Giao dịch của bạn đã được hủy bỏ</p>
                    </div>

                    <!-- Cancel Content -->
                    <div class="cancel-content">
                        <!-- Status Information -->
                        <div class="info-box">
                            <h4 class="mb-3">
                                <i class="fas fa-info-circle text-danger me-2"></i>
                                Thông tin giao dịch
                            </h4>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="fw-bold">Trạng thái:</span>
                                <span class="status-badge">
                                    <i class="fas fa-times me-1"></i>Đã hủy
                                </span>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="fw-bold">Thời gian hủy:</span>
                                <span>
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new
                                        java.util.Date()) %>
                                </span>
                            </div>

                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold">Lý do:</span>
                                <span>Người dùng hủy giao dịch</span>
                            </div>

                            <!-- Thông báo slot đã được trả về -->
                            <c:if test="${slotReleased}">
                                <div class="alert alert-success mt-3">
                                    <h6><i class="fas fa-calendar-check me-2"></i>Thông báo về lịch hẹn</h6>
                                    <p class="mb-1">✅ <strong>Slot đã được trả về hàng đợi</strong></p>
                                    <p class="mb-1">📅 Ca khám có thể được đặt bởi người khác</p>
                                    <c:if test="${not empty reservationInfo}">
                                        <small class="text-muted">
                                            🩺 Bác sĩ ID: ${reservationInfo.doctorId} |
                                            📅 Ngày: ${reservationInfo.workDate} |
                                            ⏰ Slot: ${reservationInfo.slotId}
                                        </small>
                                    </c:if>
                                </div>
                            </c:if>
                        </div>

                        <!-- Possible Reasons -->
                        <div class="reasons-list">
                            <h5 class="text-warning mb-3">
                                <i class="fas fa-lightbulb me-2"></i>
                                Có thể bạn đã hủy vì:
                            </h5>

                            <div class="reason-item">
                                <i class="fas fa-clock reason-icon"></i>
                                <span>Quá trình thanh toán mất quá nhiều thời gian</span>
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

                            <div class="reason-item">
                                <i class="fas fa-question-circle reason-icon"></i>
                                <span>Cần tư vấn thêm về dịch vụ</span>
                            </div>
                        </div>

                        <!-- Next Steps -->
                        <div class="next-steps">
                            <h5 class="text-primary mb-3">
                                <i class="fas fa-forward me-2"></i>
                                Bạn có thể làm gì tiếp theo?
                            </h5>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <strong>🔄 Thử lại thanh toán:</strong><br>
                                        <small class="text-muted">Quay lại trang thanh toán và thử phương thức
                                            khác</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <strong>📞 Liên hệ hỗ trợ:</strong><br>
                                        <small class="text-muted">Gọi hotline để được tư vấn trực tiếp</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <strong>🏥 Đến trực tiếp:</strong><br>
                                        <small class="text-muted">Thanh toán tại quầy khi đến khám</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <strong>💬 Chat hỗ trợ:</strong><br>
                                        <small class="text-muted">Nhắn tin để được hỗ trợ nhanh chóng</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="services" class="btn btn-primary btn-action">
                                <i class="fas fa-redo me-2"></i>Thử lại thanh toán
                            </a>
                            <a href="0936929381" class="btn btn-success btn-action">
                                <i class="fas fa-phone me-2"></i>Gọi hotline
                            </a>
                            <a href="UserHompageServlet" class="btn btn-outline-secondary btn-action">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                        </div>

                        <!-- Help Section -->
                        <div class="alert alert-warning">
                            <h6><i class="fas fa-headset me-2"></i>Cần hỗ trợ ngay?</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>📞 Hotline:</strong> 0936929381</p>
                                    <p class="mb-1"><strong>⏰ Thời gian:</strong> 8:00 - 17:00 (T2-T7)</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>📧 Email:</strong> phuocthde180577@fpt.edu.vn</p>
                                    <p class="mb-1"><strong>💬 Zalo:</strong> 0936929381</p>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="text-center mt-4">
                            <small class="text-muted">
                                <i class="fas fa-shield-alt me-1"></i>
                                Thông tin của bạn được bảo mật an toàn.
                                Không có khoản tiền nào bị trừ từ tài khoản.
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Show notification about cancellation
                function showCancelNotification() {
                    const notification = document.createElement('div');
                    notification.className = 'alert alert-warning position-fixed';
                    notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                    notification.innerHTML = `
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Đã hủy!</strong> Giao dịch của bạn đã được hủy bỏ an toàn.
                <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
            `;
                    document.body.appendChild(notification);

                    setTimeout(() => {
                        if (notification.parentElement) {
                            notification.remove();
                        }
                    }, 5000);
                }

                // Auto redirect after time
                function startRedirectCountdown() {
                    let timeLeft = 60; // 60 seconds
                    const countdownElement = document.createElement('div');
                    countdownElement.className = 'text-center mt-3';
                    countdownElement.innerHTML = `
                <small class="text-muted">
                    <i class="fas fa-clock me-1"></i>
                    Tự động chuyển về trang chủ sau <span id="countdown">${timeLeft}</span> giây
                    <button class="btn btn-sm btn-link" onclick="clearAutoRedirect()">Hủy</button>
                </small>
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

                    // Add keyboard shortcuts
                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') {
                            window.location.href = 'index.jsp';
                        } else if (e.key === 'Enter') {
                            window.location.href = 'services';
                        }
                    });
                });
            </script>
        </body>

        </html>