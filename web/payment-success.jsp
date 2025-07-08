<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công - Phòng khám nha khoa</title>
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
        
        .success-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            max-width: 900px;
            margin: 0 auto;
            border: 1px solid var(--border-color);
        }
        
        .success-header {
            background-color: var(--success-color);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .success-icon {
            font-size: 3.5rem;
            margin-bottom: 1rem;
            animation: fadeIn 0.5s ease-out;
        }
        
        .success-content {
            padding: 2rem;
        }
        
        .info-box {
            background: var(--light-gray);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--success-color);
        }
        
        .appointment-box {
            background: #e7f3ff;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border-left: 4px solid #007bff;
        }
        
        .receipt-box {
            background: #f8fff8;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border: 2px dashed var(--success-color);
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #212529;
            text-align: right;
        }
        
        .amount-highlight {
            font-size: 1.25rem;
            font-weight: bold;
            color: var(--success-color);
        }
        
        .status-badge {
            background: var(--success-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .appointment-badge {
            background: #007bff;
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
        
        .next-steps {
            background: #e7f3ff;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border: 1px solid #b8daff;
        }
        
        .step-item {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #b8daff;
        }
        
        .step-item:last-child {
            border-bottom: none;
        }
        
        .step-number {
            background: #007bff;
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 0.75rem;
            font-size: 0.8rem;
        }
        
        .qr-code {
            width: 120px;
            height: 120px;
            border: 3px solid var(--success-color);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            margin: 0 auto;
        }
        
        /* Animation for icon */
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1); }
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        
        /* Confetti effect */
        .confetti {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1000;
        }
        
        .confetti-piece {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #f0c040;
            animation: confetti-fall 3s linear infinite;
        }
        
        @keyframes confetti-fall {
            0% {
                transform: translateY(-100vh) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(360deg);
                opacity: 0;
            }
        }
        
        /* Responsive adjustments */
        @media (max-width: 576px) {
            .success-header {
                padding: 1.5rem;
            }
            
            .success-content {
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
    <!-- Confetti effect -->
    <div class="confetti" id="confetti"></div>

    <div class="container">
        <div class="success-container">
            <!-- Success Header -->
            <div class="success-header">
                <div class="success-icon fade-in">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2 class="mb-2">Thanh toán thành công</h2>
                <p class="mb-0">Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi</p>
            </div>

            <!-- Success Content -->
            <div class="success-content">
                <!-- Payment Information -->
                <div class="info-box">
                    <h5 class="mb-3">
                        <i class="fas fa-receipt me-2"></i>
                        Thông tin thanh toán
                    </h5>

                    <div class="info-row mb-2">
                        <span class="info-label">Trạng thái:</span>
                        <span class="info-value">
                            <span class="status-badge">
                                <i class="fas fa-check me-1"></i>Đã thanh toán
                            </span>
                        </span>
                    </div>

                    <div class="info-row mb-2">
                        <span class="info-label">Mã hóa đơn:</span>
                        <span class="info-value">
                            <code>${paymentInfo != null ? paymentInfo.billId : 'BILL_A5F6E8C5'}</code>
                        </span>
                    </div>

                    <div class="info-row mb-2">
                        <span class="info-label">Dịch vụ:</span>
                        <span class="info-value">${paymentInfo != null ? paymentInfo.serviceName : 'Bọc răng sứ'}</span>
                    </div>

                    <div class="info-row mb-2">
                        <span class="info-label">Khách hàng:</span>
                        <span class="info-value">${paymentInfo != null ? paymentInfo.customerName : 'PhuocTHDev'}</span>
                    </div>

                    <div class="info-row mb-2">
                        <span class="info-label">Số tiền:</span>
                        <span class="info-value amount-highlight">
                            ${paymentInfo != null ? paymentInfo.formattedAmount : '2,000 VNĐ'}
                        </span>
                    </div>

                    <div class="info-row mb-2">
                        <span class="info-label">Phương thức:</span>
                        <span class="info-value">
                            <i class="fas fa-university me-1"></i>
                            MB Bank - VietQR
                        </span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Thời gian:</span>
                        <span class="info-value">
                            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm:ss" />
                        </span>
                    </div>
                </div>

                <!-- Appointment Information -->
                <c:if test="${not empty paymentInfo.doctorId}">
                    <div class="appointment-box">
                        <h5 class="mb-3">
                            <i class="fas fa-calendar-check me-2"></i>
                            Thông tin cuộc hẹn
                        </h5>

                        <div class="info-row mb-2">
                            <span class="info-label">Bác sĩ:</span>
                            <span class="info-value">Bác sĩ ID: ${paymentInfo.doctorId}</span>
                        </div>

                        <div class="info-row mb-2">
                            <span class="info-label">Ngày khám:</span>
                            <span class="info-value"><strong>${paymentInfo.workDate}</strong></span>
                        </div>

                        <div class="info-row mb-2">
                            <span class="info-label">Ca khám:</span>
                            <span class="info-value">Slot ${paymentInfo.slotId}</span>
                        </div>

                        <c:if test="${not empty paymentInfo.reason}">
                            <div class="info-row mb-2">
                                <span class="info-label">Lý do khám:</span>
                                <span class="info-value">${paymentInfo.reason}</span>
                            </div>
                        </c:if>

                        <div class="info-row">
                            <span class="info-label">Trạng thái:</span>
                            <span class="info-value">
                                <span class="appointment-badge">
                                    <i class="fas fa-calendar-check"></i>
                                    <c:choose>
                                        <c:when test="${appointmentCreated}">Đã xác nhận</c:when>
                                        <c:otherwise>Đang xử lý</c:otherwise>
                                    </c:choose>
                                </span>
                            </span>
                        </div>
                    </div>
                </c:if>

                <!-- Receipt Section -->
                <div class="receipt-box">
                    <h5 class="text-center mb-3">
                        <i class="fas fa-file-invoice me-2"></i>
                        Biên lai thanh toán
                    </h5>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="small text-muted">
                                <strong>🏥 PHÒNG KHÁM NHA KHOA</strong><br>
                                📍 Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM<br>
                                📞 Hotline: 1900-xxx-xxx<br>
                                📧 Email: info@dental.clinic<br><br>
                                
                                <strong>📋 CHI TIẾT GIAO DỊCH:</strong><br>
                                • Mã GD: ${paymentInfo != null ? paymentInfo.billId : 'BILL_A5F6E8C5'}<br>
                                • Ngân hàng: MB Bank (970422)<br>
                                • STK: 5529062004<br>
                                • Chủ TK: TRAN HONG PHUOC<br>
                                • Nội dung: Thanh toan ${paymentInfo != null ? paymentInfo.billId : 'BILL_A5F6E8C5'}
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-center">
                                <div class="qr-code mb-2">
                                    <div class="text-center">
                                        <i class="fas fa-check-circle" style="font-size: 2rem; color: var(--success-color);"></i>
                                        <div class="small mt-1" style="color: var(--success-color); font-weight: bold;">THANH TOÁN</div>
                                        <div class="small" style="color: #6c757d;">THÀNH CÔNG</div>
                                    </div>
                                </div>
                                <div class="small text-muted">Biên lai điện tử</div>
                                <div class="small text-success">✅ Đã xác thực</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Next Steps -->
                <div class="next-steps">
                    <h5 class="mb-3">
                        <i class="fas fa-forward me-2"></i>
                        Các bước tiếp theo
                    </h5>

                    <c:choose>
                        <c:when test="${not empty paymentInfo.doctorId}">
                            <!-- Có appointment -->
                            <div class="step-item">
                                <div class="step-number">1</div>
                                <div>Bạn sẽ nhận được SMS/Email xác nhận cuộc hẹn</div>
                            </div>
                            <div class="step-item">
                                <div class="step-number">2</div>
                                <div>Vui lòng có mặt tại phòng khám trước 15 phút</div>
                            </div>
                            <div class="step-item">
                                <div class="step-number">3</div>
                                <div>Mang theo CMND/CCCD và hóa đơn thanh toán</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Chỉ có dịch vụ -->
                            <div class="step-item">
                                <div class="step-number">1</div>
                                <div>Bạn có thể sử dụng dịch vụ ngay tại phòng khám</div>
                            </div>
                            <div class="step-item">
                                <div class="step-number">2</div>
                                <div>Xuất trình hóa đơn thanh toán khi sử dụng dịch vụ</div>
                            </div>
                        </c:otherwise>
                    </c:choose>HÓA ĐƠN THANH TOÁN
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="button" class="btn btn-warning btn-action" onclick="printReceipt()">
                        <i class="fas fa-print me-2"></i>In hóa đơn 
                    </button>
                    <a href="${pageContext.request.contextPath}/BookingPageServlet" class="btn btn-success btn-action">
                        <i class="fas fa-plus me-2"></i>Đặt lịch khác
                    </a>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary btn-action">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </div>

                <!-- Help Section -->
                <div class="alert alert-light">
                    <h6 class="mb-3"><i class="fas fa-headset me-2"></i>Cần hỗ trợ?</h6>
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
                    Thông tin của bạn được bảo mật an toàn. Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Confetti celebration effect
        function createConfetti() {
            const confetti = document.getElementById('confetti');
            const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#f0932b', '#eb4d4b', '#6c5ce7'];
            
            for (let i = 0; i < 30; i++) {
                const piece = document.createElement('div');
                piece.className = 'confetti-piece';
                piece.style.left = Math.random() * 100 + '%';
                piece.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                piece.style.animationDelay = Math.random() * 2 + 's';
                piece.style.animationDuration = (Math.random() * 3 + 2) + 's';
                confetti.appendChild(piece);
            }

            // Remove confetti after animation
            setTimeout(() => {
                confetti.innerHTML = '';
            }, 5000);
        }

        // Print receipt function
        function printReceipt() {
            const billId = '${paymentInfo != null ? paymentInfo.billId : "BILL_A5F6E8C5"}';
            const orderId = '${paymentInfo != null ? paymentInfo.orderId : "ORDER_1749721289553"}';
            const serviceName = '${paymentInfo != null ? paymentInfo.serviceName : "Bọc răng sứ"}';
            const customerName = '${paymentInfo != null ? paymentInfo.customerName : "PhuocTHDev"}';
            const amount = '${paymentInfo != null ? paymentInfo.formattedAmount : "2,000 VNĐ"}';
            const currentDate = new Date().toLocaleString('vi-VN');
            
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <html>
                    <head>
                        <title>Hóa đơn thanh toán - ${billId}</title>
                        <meta charset="UTF-8">
                        <style>
                            body { font-family: Arial, sans-serif; padding: 20px; }
                            .invoice-container { max-width: 600px; margin: 0 auto; }
                            .invoice-header { text-align: center; margin-bottom: 20px; }
                            .info-table { width: 100%; border-collapse: collapse; margin: 15px 0; }
                            .info-table td { padding: 8px; border-bottom: 1px solid #eee; }
                            .amount-highlight { font-size: 1.5rem; color: #28a745; font-weight: bold; }
                            .status-badge { background: #28a745; color: white; padding: 5px 10px; border-radius: 20px; }
                            .receipt-details { background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 15px 0; }
                            .qr-code { width: 100px; height: 100px; border: 2px solid #28a745; border-radius: 8px; 
                                      display: flex; align-items: center; justify-content: center; margin: 10px auto; }
                            @media print { body { padding: 0; } }
                        </style>
                    </head>
                    <body>
                        <div class="invoice-container">
                            <div class="invoice-header">
                                <h2>HÓA ĐƠN THANH TOÁN</h2>
                                <p>Phòng khám nha khoa chuyên nghiệp</p>
                            </div>
                            
                            <table class="info-table">
                                <tr>
                                    <td>Mã hóa đơn:</td>
                                    <td><strong>${billId}</strong></td>
                                </tr>
                                <tr>
                                    <td>Khách hàng:</td>
                                    <td>${customerName}</td>
                                </tr>
                                <tr>
                                    <td>Dịch vụ:</td>
                                    <td>${serviceName}</td>
                                </tr>
                                <tr>
                                    <td>Số tiền:</td>
                                    <td class="amount-highlight">${amount}</td>
                                </tr>
                                <tr>
                                    <td>Ngày thanh toán:</td>
                                    <td>${currentDate}</td>
                                </tr>
                                <tr>
                                    <td>Trạng thái:</td>
                                    <td><span class="status-badge">Đã thanh toán</span></td>
                                </tr>
                            </table>
                            
                            <div class="receipt-details">
                                <h5>Biên lai thanh toán</h5>
                                <div class="small">
                                    <strong>🏥 PHÒNG KHÁM NHA KHOA</strong><br>
                                    📍 Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM<br>
                                    📞 Hotline: 1900-xxx-xxx<br><br>
                                    
                                    <strong>📋 CHI TIẾT GIAO DỊCH:</strong><br>
                                    • Mã GD: ${billId}<br>
                                    • Ngân hàng: MB Bank (970422)<br>
                                    • STK: 5529062004<br>
                                    • Chủ TK: TRAN HONG PHUOC<br>
                                    • Nội dung: Thanh toan ${billId}
                                </div>
                                
                                <div class="text-center mt-3">
                                    <div class="qr-code">
                                        <i class="fas fa-check-circle" style="font-size: 1.5rem; color: #28a745;"></i>
                                    </div>
                                    <div class="small">Biên lai điện tử đã xác thực</div>
                                </div>
                            </div>
                            
                            <p style="text-align: center; margin-top: 30px;">
                                Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!
                            </p>
                        </div>
                    </body>
                </html>
            `);
            
            printWindow.document.close();
            setTimeout(() => {
                printWindow.print();
                setTimeout(() => printWindow.close(), 1000);
            }, 500);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Show confetti effect
            createConfetti();
            
            // Show success notification
            const notification = document.createElement('div');
            notification.className = 'alert alert-success position-fixed fade-in';
            notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 300px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);';
            notification.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fas fa-check-circle me-2"></i>
                    <div>
                        <strong>Thành công!</strong>
                        <div class="small">Thanh toán của bạn đã được xử lý.</div>
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
            
            // Auto redirect after 60 seconds
            function startRedirectCountdown() {
                let timeLeft = 60;
                const countdownElement = document.createElement('div');
                countdownElement.className = 'text-center mt-3 small text-muted';
                countdownElement.innerHTML = `
                    <i class="fas fa-clock me-1"></i>
                    Tự động chuyển về trang chủ sau <span id="countdown">${timeLeft}</span> giây
                    <button class="btn btn-sm btn-link p-0 ms-2" onclick="clearAutoRedirect()">Hủy</button>
                `;

                document.querySelector('.success-content').appendChild(countdownElement);

                const interval = setInterval(() => {
                    timeLeft--;
                    const countdownSpan = document.getElementById('countdown');
                    if (countdownSpan) {
                        countdownSpan.textContent = timeLeft;
                    }

                    if (timeLeft <= 0) {
                        clearInterval(interval);
                        window.location.href = '${pageContext.request.contextPath}/home.jsp';
                    }
                }, 1000);

                window.autoRedirectInterval = interval;
            }

            setTimeout(startRedirectCountdown, 3000);
        });

        function clearAutoRedirect() {
            if (window.autoRedirectInterval) {
                clearInterval(window.autoRedirectInterval);
                document.querySelector('.success-content').lastElementChild.remove();
            }
        }
    </script>
</body>

</html>