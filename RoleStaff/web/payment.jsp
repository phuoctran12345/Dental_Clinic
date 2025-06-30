<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán dịch vụ - Phòng khám nha khoa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1a237e;
            --primary-light: #534bae;
            --primary-dark: #000051;
            --secondary-color: #f5f5f5;
            --accent-color: #00bcd4;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
            color: #333;
            line-height: 1.6;
        }
        
        .payment-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            max-width: 1200px;
            margin: 2rem auto;
            border: 1px solid #e0e0e0;
        }
        
        .payment-header {
            background-color: var(--primary-color);
            color: white;
            padding: 1.5rem;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .payment-header h1 {
            font-weight: 600;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }
        
        .payment-header p {
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        .service-info {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--primary-color);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .qr-container {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 1.5rem;
            border: 1px solid #e0e0e0;
        }
        
        .qr-code {
            width: 220px;
            height: 220px;
            margin: 1rem auto;
            padding: 0.5rem;
            background: white;
            border-radius: 4px;
            border: 1px solid #e0e0e0;
        }
        
        .payment-amount {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-color);
            text-align: center;
            margin: 1.5rem 0;
        }
        
        .info-row {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 500;
            color: #666;
        }
        
        .info-value {
            font-weight: 500;
            color: #333;
            text-align: right;
        }
        
        .countdown {
            background: #fff8e1;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            margin: 1.5rem 0;
            border: 1px solid #ffe0b2;
        }
        
        .step-indicator {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 2rem 0 1rem;
        }
        
        .step {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #e0e0e0;
            color: #9e9e9e;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            position: relative;
        }
        
        .step.active {
            background: var(--primary-color);
            color: white;
        }
        
        .step.completed {
            background: var(--accent-color);
            color: white;
        }
        
        .step-line {
            width: 60px;
            height: 2px;
            background: #e0e0e0;
        }
        
        .step-line.active {
            background: var(--primary-color);
        }
        
        .btn-payment {
            border-radius: 6px;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.2s;
            border: none;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-light);
        }
        
        .status-indicator {
            padding: 1.5rem;
            text-align: center;
            border-radius: 8px;
            margin: 1.5rem 0;
            background: #f5f5f5;
            border: 1px solid #e0e0e0;
        }
        
        .payment-methods {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin: 1.5rem 0;
        }
        
        .payment-method {
            padding: 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid #e0e0e0;
            background: white;
            flex: 1;
            max-width: 200px;
        }
        
        .payment-method.active {
            border-color: var(--primary-color);
            background: #f5f5ff;
        }
        
        .payment-method:hover {
            border-color: var(--primary-color);
        }
        
        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .fade-in {
            animation: fadeIn 0.3s ease-out;
        }
        
        /* Toast notification */
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            animation: fadeIn 0.3s ease-out;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border: none;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .payment-methods {
                flex-direction: column;
                align-items: center;
            }
            
            .payment-method {
                max-width: 100%;
                width: 100%;
            }
            
            .qr-code {
                width: 180px;
                height: 180px;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <!-- Payment Header -->
        <div class="payment-container">
            <div class="payment-header">
                <h1 class="mb-2">
                    <i class="fas fa-credit-card me-2"></i>
                    Thanh toán dịch vụ
                </h1>
                <p>Hoàn tất thanh toán để xác nhận lịch khám</p>
            </div>

            <div class="container-fluid p-4">
                <!-- Step Indicator -->
                <div class="step-indicator">
                    <div class="step completed">1</div>
                    <div class="step-line active"></div>
                    <div class="step active">2</div>
                    <div class="step-line"></div>
                    <div class="step">3</div>
                </div>
                <div class="row text-center mb-4">
                    <div class="col-4"><small>Chọn dịch vụ</small></div>
                    <div class="col-4"><small><strong>Thanh toán</strong></small></div>
                    <div class="col-4"><small>Hoàn thành</small></div>
                </div>

                <div class="row">
                    <!-- Service Information -->
                    <div class="col-md-6">
                        <div class="service-info">
                            <h4 class="mb-3">
                                <i class="fas fa-tooth me-2" style="color: var(--primary-color);"></i>
                                Thông tin dịch vụ
                            </h4>
                            <div class="info-row">
                                <span class="info-label">Dịch vụ:</span>
                                <span class="info-value"><strong>${service.serviceName}</strong></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Danh mục:</span>
                                <span class="badge bg-primary">${service.category}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Mô tả:</span>
                                <span class="info-value">${service.description}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Bệnh nhân:</span>
                                <span class="info-value">${patient.fullName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">${patient.phone}</span>
                            </div>
                            <c:if test="${not empty paymentInfo.workDate}">
                                <div class="info-row">
                                    <span class="info-label">Ngày khám:</span>
                                    <span class="info-value">${paymentInfo.workDate}</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Payment Information -->
                        <div class="payment-info">
                            <h5 class="mb-3">
                                <i class="fas fa-file-invoice-dollar me-2" style="color: var(--primary-color);"></i>
                                Chi tiết thanh toán
                            </h5>
                            <div class="info-row">
                                <span class="info-label">Mã đơn hàng:</span>
                                <span class="info-value"><code>${paymentInfo.orderId}</code></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Mã hóa đơn:</span>
                                <span class="info-value"><code>${paymentInfo.billId}</code></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Thời gian tạo:</span>
                                <span class="info-value">${paymentInfo.createdAt}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Phương thức:</span>
                                <span class="badge bg-info">PayOS QR Code</span>
                            </div>
                        </div>
                    </div>

                    <!-- QR Code Payment -->
                    <div class="col-md-6">
                        <div class="qr-container">
                            <h4 class="mb-3">
                                <i class="fas fa-qrcode me-2" style="color: var(--primary-color);"></i>
                                Quét mã QR để thanh toán
                            </h4>

                            <!-- Multi-bank support notice -->
                            <div class="alert alert-primary mb-3">
                                <i class="fas fa-university me-2"></i>
                                <strong>Hỗ trợ TẤT CẢ ngân hàng Việt Nam</strong>
                                <div class="mt-1">
                                    <small>Vietcombank, BIDV, Agribank, VietinBank, Techcombank, ACB, SHB, VPBank, TPBank, Sacombank, HDBank, v.v...</small>
                                </div>
                            </div>

                            <!-- Payment Amount -->
                            <div class="payment-amount">
                                ${paymentInfo.formattedAmount}
                            </div>

                            <!-- QR Code -->
                            <div class="qr-code">
                                <img src="${paymentInfo.qrCode}" alt="VietQR Banking Code" class="img-fluid"
                                    onerror="this.src='https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=${paymentInfo.qrCode}'">
                            </div>

                            <!-- Payment Timeout Warning -->
                            <div class="alert alert-warning mb-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <i class="fas fa-clock me-2"></i>
                                        <strong>Thời gian thanh toán còn lại:</strong>
                                    </div>
                                    <div class="text-end">
                                        <span id="payment-countdown" class="badge bg-warning text-dark">5:00</span>
                                    </div>
                                </div>
                                <small class="text-muted d-block mt-1">
                                    Vui lòng hoàn tất thanh toán trong thời gian này
                                </small>
                            </div>

                            <!-- Status -->
                            <div class="status-indicator">
                                <i class="fas fa-search me-2"></i>
                                <strong>Đang chờ thanh toán</strong>
                                <div class="mt-2">
                                    <small>1. Quét QR bằng app ngân hàng</small><br>
                                    <small>2. Chuyển khoản với số tiền chính xác</small><br>
                                    <small>3. Hệ thống sẽ tự động phát hiện</small>
                                </div>
                                <div class="mt-3">
                                    <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
                                    <small class="text-muted">Đang kiểm tra thanh toán</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="row mt-4">
                    <div class="col-12 text-center">
                        <button type="button" class="btn btn-primary btn-payment me-2" onclick="checkPaymentStatus()">
                            <i class="fas fa-sync-alt me-1"></i>Kiểm tra thanh toán
                        </button>
                        <button type="button" class="btn btn-success btn-payment me-2" onclick="confirmRealPayment()">
                            <i class="fas fa-check-circle me-1"></i>Đã chuyển khoản
                        </button>
                        <a href="#" onclick="cancelPaymentAndGoHome()" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>

                <!-- Help Section -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="alert alert-info">
                            <h6><i class="fas fa-info-circle me-2"></i>Hướng dẫn thanh toán</h6>
                            <ol class="mb-0">
                                <li><strong>Bước 1:</strong> Mở app ngân hàng của bạn</li>
                                <li><strong>Bước 2:</strong> Chọn "Chuyển khoản QR" hoặc "Quét mã QR"</li>
                                <li><strong>Bước 3:</strong> Quét mã QR hiển thị trên màn hình</li>
                                <li><strong>Bước 4:</strong> Kiểm tra thông tin và xác nhận chuyển khoản</li>
                                <li><strong>Bước 5:</strong> Hệ thống sẽ tự động xác nhận thanh toán</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Countdown timer
        let timeLeft = 5 * 60; // 5 minutes in seconds

        function updateCountdown() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            document.getElementById('countdown').textContent =
                minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');

            if (timeLeft <= 0) {
                alert('Thời gian thanh toán đã hết hạn');
                window.location.href = 'payment?action=cancel';
                return;
            }

            timeLeft--;
        }

        // Update countdown every second
        setInterval(updateCountdown, 1000);

        // Check payment status
        function checkPaymentStatus() {
            const btn = event.target;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang kiểm tra...';
            btn.disabled = true;

            const orderId = '${paymentInfo.orderId}';

            fetch('payment?action=checkStatus&orderId=' + orderId)
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success' || data.status === 'SUCCESS') {
                        btn.innerHTML = '<i class="fas fa-check me-2"></i>Thanh toán thành công!';
                        btn.className = 'btn btn-success btn-payment';

                        showToast('Thanh toán thành công! Đang chuyển trang...', 'success');

                        setTimeout(() => {
                            window.location.href = 'payment?action=success';
                        }, 1500);

                    } else if (data.status === 'pending') {
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                        showToast('Vui lòng hoàn tất thanh toán và thử lại', 'warning');
                    } else {
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                        showToast('Chưa có giao dịch nào. Vui lòng thanh toán', 'info');
                    }
                })
                .catch(error => {
                    console.error('Error checking payment:', error);
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    showToast('Lỗi kiểm tra. Vui lòng thử lại', 'danger');
                });
        }

        // Show toast notification
        function showToast(message, type = 'info') {
            const toast = document.createElement('div');
            toast.className = `toast alert alert-${type} fade-in`;
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';

            let iconClass = 'info-circle';
            if (type === 'success') iconClass = 'check-circle';
            else if (type === 'warning') iconClass = 'exclamation-triangle';
            else if (type === 'danger') iconClass = 'times-circle';

            toast.innerHTML = `
                <i class="fas fa-${iconClass} me-2"></i>
                ${message}
                <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
            `;

            document.body.appendChild(toast);

            setTimeout(() => {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 5000);
        }

        // User confirms actual payment completed
        function confirmRealPayment() {
            if (!confirm('Bạn đã hoàn tất chuyển khoản bằng app ngân hàng?\n\n' +
                '- Số tiền: ${paymentInfo.formattedAmount}\n' +
                '- Nội dung: ${paymentInfo.billId}\n\n' +
                'Chỉ xác nhận khi đã thực sự chuyển khoản thành công!')) {
                return;
            }

            const orderId = '${paymentInfo.orderId}';
            const billId = '${paymentInfo.billId}';

            showToast('Đang xác nhận thanh toán...', 'info');

            fetch('checkBill?action=autoUpdate&orderId=' + orderId + '&paymentRef=REAL_PAYMENT')
                .then(response => response.json())
                .then(data => {
                    if (data.success || data.status === 'success') {
                        showToast('Thanh toán đã được xác nhận!', 'success');

                        setTimeout(() => {
                            window.location.href = 'payment?action=success';
                        }, 2000);

                    } else {
                        showToast('Không thể xác nhận: ' + (data.message || 'Lỗi hệ thống'), 'danger');
                    }
                })
                .catch(error => {
                    console.error('Real payment confirmation error:', error);
                    showToast('Lỗi xác nhận thanh toán', 'danger');
                });
        }

        function cancelPaymentAndGoHome() {
            if (confirm('Bạn có chắc chắn muốn hủy giao dịch và quay lại trang chủ?')) {
                showToast('Đang hủy giao dịch...', 'info');
                setTimeout(() => {
                    window.location.href = 'payment?action=cancel';
                }, 1000);
            }
        }

        // Auto-cancel current payment after 5 minutes
        const PAYMENT_TIMEOUT = 5 * 60 * 1000; // 5 minutes
        const paymentStartTime = Date.now();

        const autoTimeoutCheck = setInterval(() => {
            const elapsed = Date.now() - paymentStartTime;
            const remaining = Math.max(0, PAYMENT_TIMEOUT - elapsed);

            if (remaining <= 0) {
                clearInterval(autoTimeoutCheck);
                showToast('Thời gian thanh toán đã hết!', 'warning');
                setTimeout(() => {
                    window.location.href = 'payment?action=cancel';
                }, 3000);
            } else {
                const countdownEl = document.getElementById('payment-countdown');
                if (countdownEl) {
                    const minutes = Math.floor(remaining / 60000);
                    const seconds = Math.floor((remaining % 60000) / 1000);
                    const timeText = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                    countdownEl.textContent = timeText;

                    if (remaining <= 60000) {
                        countdownEl.className = 'badge bg-danger text-white';
                    } else if (remaining <= 120000) {
                        countdownEl.className = 'badge bg-warning text-dark';
                    } else {
                        countdownEl.className = 'badge bg-success text-white';
                    }
                }
            }
        }, 1000);
    </script>
</body>

</html>