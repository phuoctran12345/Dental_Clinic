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
                body {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    padding: 20px 0;
                }

                .success-container {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                    overflow: hidden;
                    max-width: 800px;
                    margin: 0 auto;
                }

                .success-header {
                    background: linear-gradient(45deg, #28a745, #20c997);
                    color: white;
                        padding: 40px 30px;
                    text-align: center;
                        position: relative;
                }

                .success-icon {
                    font-size: 4rem;
                    margin-bottom: 20px;
                        animation: bounceIn 1s ease-out;
                    }

                    @keyframes bounceIn {
                        0% {
                            transform: scale(0);
                            opacity: 0;
                        }

                        50% {
                            transform: scale(1.1);
                            opacity: 1;
                        }

                        100% {
                            transform: scale(1);
                            opacity: 1;
                        }
                    }

                    .success-content {
                        padding: 40px 30px;
                }

                    .bill-info,
                    .appointment-info {
                    background: #f8f9fa;
                    border-radius: 15px;
                    padding: 25px;
                    margin: 20px 0;
                    border-left: 5px solid #28a745;
                }

                    .appointment-info {
                        border-left-color: #007bff;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                        padding: 12px 0;
                        border-bottom: 1px solid #eee;
                }

                .info-row:last-child {
                    border-bottom: none;
                }

                .info-label {
                    font-weight: 600;
                    color: #495057;
                        flex: 1;
                }

                .info-value {
                        flex: 2;
                        text-align: right;
                    color: #212529;
                }

                    .amount-highlight {
                        font-size: 1.5rem;
                        font-weight: bold;
                        color: #28a745;
                    }

                    .status-badge {
                        background: #28a745;
                        color: white;
                        padding: 8px 16px;
                        border-radius: 20px;
                        font-weight: 600;
                        display: inline-block;
                    }

                    .appointment-badge {
                        background: #007bff;
                        color: white;
                        padding: 8px 16px;
                        border-radius: 20px;
                        font-weight: 600;
                        display: inline-block;
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

                    .step-item {
                        display: flex;
                        align-items: center;
                        margin: 10px 0;
                    }

                    .step-number {
                        background: #007bff;
                        color: white;
                        width: 30px;
                        height: 30px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: bold;
                        margin-right: 15px;
                    }

                    .section-title {
                        font-weight: bold;
                        color: #495057;
                        margin-bottom: 15px;
                        display: flex;
                        align-items: center;
                }

                    .section-title i {
                        margin-right: 10px;
                        color: #007bff;
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

                    .floating-icon:nth-child(4) {
                        bottom: 10%;
                        right: 20%;
                        animation-delay: 1s;
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

                    .celebration {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        pointer-events: none;
                        z-index: 1000;
                }

                .confetti {
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

                    .receipt-section {
                        border: 2px dashed #28a745;
                        border-radius: 10px;
                        padding: 20px;
                        margin: 20px 0;
                        background: #f8fff8;
                    }

                    .qr-receipt {
                        text-align: center;
                        padding: 15px;
                    }

                    .qr-small {
                        width: 150px;
                        height: 150px;
                        margin: 10px auto;
                        border: 3px solid #28a745;
                        border-radius: 10px;
                        padding: 10px;
                        background: white;
                }
            </style>
        </head>

        <body>
                <!-- Celebration Effects -->
                <div class="celebration" id="celebration"></div>

            <div class="container">
                <div class="success-container">
                    <!-- Success Header -->
                    <div class="success-header">
                            <div class="floating-elements">
                                <i class="fas fa-check floating-icon"></i>
                                <i class="fas fa-heart floating-icon"></i>
                                <i class="fas fa-star floating-icon"></i>
                                <i class="fas fa-crown floating-icon"></i>
                            </div>

                        <div class="success-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                            <h1 class="mb-3">🎉 THANH TOÁN THÀNH CÔNG!</h1>
                            <p class="lead mb-0">Cảm ơn bạn đã tin tưởng sử dụng dịch vụ của chúng tôi</p>
                        </div>

                        <!-- Success Content -->
                        <div class="success-content">
                        <!-- Payment Information -->
                            <div class="bill-info">
                            <h4 class="mb-3">
                                <i class="fas fa-receipt text-success me-2"></i>
                                    Thông tin thanh toán
                            </h4>

                                <div class="info-row">
                                    <span class="info-label">Trạng thái:</span>
                                    <span class="info-value">
                                        <span class="status-badge">
                                            <i class="fas fa-check me-1"></i>Đã thanh toán
                                        </span>
                                    </span>
                                </div>

                            <div class="info-row">
                                <span class="info-label">Mã hóa đơn:</span>
                                    <span class="info-value">
                                        <code>${paymentInfo != null ? paymentInfo.billId : 'BILL_A5F6E8C5'}</code>
                                    </span>
                            </div>

                            <div class="info-row">
                                <span class="info-label">Mã đơn hàng:</span>
                                    <span class="info-value">
                                        <code>${paymentInfo != null ? paymentInfo.orderId : 'ORDER_1749721289553'}</code>
                                    </span>
                            </div>

                            <div class="info-row">
                                <span class="info-label">Dịch vụ:</span>
                                    <span class="info-value">${paymentInfo != null ? paymentInfo.serviceName : 'Bọc răng
                                        sứ'}</span>
                            </div>

                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                    <span class="info-value">${paymentInfo != null ? paymentInfo.customerName :
                                        'PhuocTHDev'}</span>
                                </div>

                                <div class="info-row">
                                    <span class="info-label">Số tiền:</span>
                                    <span class="info-value amount-highlight">
                                        ${paymentInfo != null ? paymentInfo.formattedAmount : '2,000 VNĐ'}
                                    </span>
                                </div>

                                <div class="info-row">
                                    <span class="info-label">Phương thức:</span>
                                    <span class="info-value">
                                        <i class="fas fa-university text-primary me-1"></i>
                                        MB Bank - VietQR
                                    </span>
                                </div>

                                <div class="info-row">
                                    <span class="info-label">Thời gian:</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="<%=new java.util.Date()%>"
                                            pattern="dd/MM/yyyy HH:mm:ss" />
                                    </span>
                                </div>
                            </div>

                            <!-- Appointment Information -->
                            <c:if test="${not empty paymentInfo.doctorId}">
                                <div class="appointment-info">
                                    <h4 class="mb-3">
                                        <i class="fas fa-calendar-check text-primary me-2"></i>
                                        Thông tin cuộc hẹn
                                    </h4>

                                    <div class="info-row">
                                        <span class="info-label">Bác sĩ:</span>
                                        <span class="info-value">Bác sĩ ID: ${paymentInfo.doctorId}</span>
                                    </div>

                            <div class="info-row">
                                        <span class="info-label">Ngày khám:</span>
                                        <span class="info-value"><strong>${paymentInfo.workDate}</strong></span>
                            </div>

                            <div class="info-row">
                                        <span class="info-label">Ca khám:</span>
                                        <span class="info-value">Slot ${paymentInfo.slotId}</span>
                            </div>

                                    <c:if test="${not empty paymentInfo.reason}">
                            <div class="info-row">
                                            <span class="info-label">Lý do khám:</span>
                                            <span class="info-value">${paymentInfo.reason}</span>
                            </div>
                                    </c:if>

                            <div class="info-row">
                                        <span class="info-label">Trạng thái cuộc hẹn:</span>
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
                            <div class="receipt-section">
                                <h5 class="text-center mb-3">
                                    <i class="fas fa-file-invoice text-success me-2"></i>
                                    Biên lai thanh toán
                                </h5>

                                <div class="row">
                                    <div class="col-md-8">
                                        <small class="text-muted">
                                            <strong>🏥 PHÒNG KHÁM NHA KHOA</strong><br>
                                            📍 Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM<br>
                                            📞 Hotline: 1900-xxx-xxx<br>
                                            📧 Email: info@dental.clinic<br><br>

                                            <strong>📋 CHI TIẾT GIAO DỊCH:</strong><br>
                                            • Mã GD: ${paymentInfo != null ? paymentInfo.billId : 'BILL_A5F6E8C5'}<br>
                                            • Ngân hàng: MB Bank (970422)<br>
                                            • STK: 5529062004<br>
                                            • Chủ TK: TRAN HONG PHUOC<br>
                                            • Nội dung: Thanh toan ${paymentInfo != null ? paymentInfo.billId :
                                            'BILL_A5F6E8C5'}
                                        </small>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="qr-receipt">
                                            <div class="qr-small">
                                                <!-- QR Code thật cho biên lai -->
                                                <div style="background: white; padding: 10px; border-radius: 8px;">
                                                    <div
                                                        style="width: 120px; height: 120px; margin: 0 auto; border: 2px solid #28a745; border-radius: 8px; display: flex; align-items: center; justify-content: center; background: #f8fff8;">
                                                        <div style="text-align: center;">
                                                            <i class="fas fa-check-circle"
                                                                style="font-size: 2rem; color: #28a745; margin-bottom: 5px;"></i>
                                                            <div
                                                                style="font-size: 0.8rem; color: #28a745; font-weight: bold;">
                                                                THANH TOÁN</div>
                                                            <div style="font-size: 0.7rem; color: #6c757d;">THÀNH CÔNG
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <small class="text-muted d-block mt-2">Biên lai điện tử</small>
                                            <small class="text-success">✅ Đã xác thực</small>
                                        </div>
                                    </div>
                            </div>
                        </div>

                        <!-- Next Steps -->
                        <div class="next-steps">
                                <h5 class="text-primary mb-3">
                                    <i class="fas fa-list-check me-2"></i>
                                Các bước tiếp theo
                            </h5>

                                <c:choose>
                                    <c:when test="${not empty paymentInfo.doctorId}">
                                        <!-- Có appointment -->
                                        <div class="step-item">
                                            <div class="step-number">1</div>
                                            <div>
                                                <strong>Bạn sẽ nhận được SMS/Email xác nhận cuộc hẹn trong vài phút
                                                    tới</strong>
                                            </div>
                                        </div>
                                        <div class="step-item">
                                            <div class="step-number">2</div>
                                            <div>
                                                <strong>Vui lòng có mặt tại phòng khám trước 15 phút</strong>
                                            </div>
                                        </div>
                                        <div class="step-item">
                                            <div class="step-number">3</div>
                                            <div>
                                                <strong>Mang theo CMND/CCCD và hóa đơn thanh toán này</strong>
                                            </div>
                                        </div>
                                        <div class="step-item">
                                            <div class="step-number">4</div>
                                            <div>
                                                <strong>Nếu cần thay đổi lịch hẹn, vui lòng liên hệ hotline:
                                                    <strong>1900-xxx-xxx</strong></strong>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Chỉ có dịch vụ -->
                                        <div class="step-item">
                                            <div class="step-number">1</div>
                                            <div>
                                                <strong>Bạn có thể sử dụng dịch vụ ngay tại phòng khám</strong>
                                            </div>
                                        </div>
                                        <div class="step-item">
                                            <div class="step-number">2</div>
                                            <div>
                                                <strong>Xuất trình hóa đơn thanh toán này khi sử dụng dịch vụ</strong>
                                            </div>
                                        </div>
                                        <div class="step-item">
                                            <div class="step-number">3</div>
                                            <div>
                                                <strong>Liên hệ hotline: <strong>1900-xxx-xxx</strong> nếu cần hỗ
                                                    trợ</strong>
                                </div>
                                </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button type="button" class="btn btn-warning btn-action" onclick="printReceipt()">
                                <i class="fas fa-print me-2"></i>In hóa đơn
                            </button>
                            <a href="${pageContext.request.contextPath}/BookingPageServlet"
                                class="btn btn-success btn-action">
                                <i class="fas fa-plus me-2"></i>Đặt lịch khác
                            </a>
                            <a href="${pageContext.request.contextPath}/patient" class="btn btn-primary btn-action">
                                <i class="fas fa-calendar me-2"></i>Xem lịch hẹn
                            </a>
                            <a href="${pageContext.request.contextPath}/index.jsp"
                                class="btn btn-outline-secondary btn-action">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                        </div>

                        <!-- Support Information -->
                        <div class="alert alert-info">
                            <h6><i class="fas fa-headset me-2"></i>Cần hỗ trợ?</h6>
                            <p class="mb-0">
                                Liên hệ hotline: <strong>1900-xxx-xxx</strong> (8:00 - 17:00) <br>
                                Email: <strong>support@dental.clinic</strong> <br>
                                Hoặc chat trực tiếp với chúng tôi qua website
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                    // Confetti celebration effect
                function createConfetti() {
                        const celebration = document.getElementById('celebration');
                        const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#f0932b', '#eb4d4b', '#6c5ce7'];

                    for (let i = 0; i < 50; i++) {
                        const confetti = document.createElement('div');
                            confetti.className = 'confetti';
                            confetti.style.left = Math.random() * 100 + '%';
                            confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                            confetti.style.animationDelay = Math.random() * 2 + 's';
                            confetti.style.animationDuration = (Math.random() * 3 + 2) + 's';
                            celebration.appendChild(confetti);
                        }

                        // Remove confetti after animation
                        setTimeout(() => {
                            celebration.innerHTML = '';
                        }, 5000);
                }

                    // Auto print receipt function
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
                                        * { box-sizing: border-box; margin: 0; padding: 0; }
                                        body { 
                                            font-family: 'Arial', sans-serif; 
                                            line-height: 1.6; 
                                            color: #333;
                                            background: white;
                                            padding: 20px;
                                        }
                                        .invoice-container {
                                            max-width: 800px;
                                            margin: 0 auto;
                                            border: 2px solid #28a745;
                                            border-radius: 10px;
                                            overflow: hidden;
                                            background: white;
                                        }
                                        .invoice-header {
                                            background: linear-gradient(45deg, #28a745, #20c997);
                                            color: white;
                                            padding: 30px;
                                            text-align: center;
                                        }
                                        .invoice-header h1 {
                                            font-size: 2rem;
                                            margin-bottom: 10px;
                                        }
                                        .invoice-header .subtitle {
                                            font-size: 1.1rem;
                                            opacity: 0.9;
                                        }
                                        .clinic-info {
                                            background: #f8f9fa;
                                            padding: 20px;
                                            border-bottom: 2px dashed #28a745;
                                        }
                                        .clinic-info h3 {
                                            color: #28a745;
                                            margin-bottom: 10px;
                                            font-size: 1.3rem;
                                        }
                                        .clinic-details {
                                            display: grid;
                                            grid-template-columns: 1fr 1fr;
                                            gap: 20px;
                                            margin-top: 15px;
                                        }
                                        .invoice-body {
                                            padding: 30px;
                                        }
                                        .info-section {
                                            margin-bottom: 25px;
                                        }
                                        .info-section h4 {
                                            color: #28a745;
                                            border-bottom: 2px solid #28a745;
                                            padding-bottom: 8px;
                                            margin-bottom: 15px;
                                            font-size: 1.1rem;
                                        }
                                        .info-table {
                                            width: 100%;
                                            border-collapse: collapse;
                                            margin-bottom: 20px;
                                        }
                                        .info-table td {
                                            padding: 8px 12px;
                                            border-bottom: 1px solid #eee;
                                        }
                                        .info-table .label {
                                            font-weight: bold;
                                            color: #495057;
                                            width: 40%;
                                        }
                                        .info-table .value {
                                            color: #212529;
                                        }
                                        .amount-section {
                                            background: #e8f5e8;
                                            padding: 20px;
                                            border-radius: 8px;
                                            text-align: center;
                                            margin: 20px 0;
                                            border: 2px dashed #28a745;
                                        }
                                        .amount-section .amount {
                                            font-size: 2rem;
                                            font-weight: bold;
                                            color: #28a745;
                                            margin-bottom: 5px;
                                        }
                                        .amount-section .amount-text {
                                            font-size: 1rem;
                                            color: #6c757d;
                                        }
                                        .status-section {
                                            text-align: center;
                                            padding: 20px;
                                            background: #d4edda;
                                            border-radius: 8px;
                                            margin: 20px 0;
                                        }
                                        .status-badge {
                                            background: #28a745;
                                            color: white;
                                            padding: 10px 20px;
                                            border-radius: 25px;
                                            font-weight: bold;
                                            display: inline-block;
                                            font-size: 1.1rem;
                                        }
                                        .footer-section {
                                            background: #f8f9fa;
                                            padding: 20px;
                                            text-align: center;
                                            border-top: 2px dashed #28a745;
                                            margin-top: 30px;
                                        }
                                        .footer-section small {
                                            color: #6c757d;
                                            line-height: 1.8;
                                        }
                                        .qr-section {
                                            text-align: center;
                                            margin: 20px 0;
                                        }
                                        .qr-box {
                                            display: inline-block;
                                            width: 100px;
                                            height: 100px;
                                            border: 3px solid #28a745;
                                            border-radius: 8px;
                                            background: #f8fff8;
                                            display: flex;
                                            align-items: center;
                                            justify-content: center;
                                            margin: 10px auto;
                                        }
                                        .print-date {
                                            text-align: right;
                                            margin-top: 20px;
                                            padding-top: 10px;
                                            border-top: 1px solid #eee;
                                            font-size: 0.9rem;
                                            color: #6c757d;
                                        }
                                        @media print {
                                            body { padding: 0; }
                                            .invoice-container { border: none; box-shadow: none; }
                                        }
                                    </style>
                                </head>
                                <body>
                                    <div class="invoice-container">
                                        <!-- Header -->
                                        <div class="invoice-header">
                                            <h1>🏥 HÓA ĐƠN THANH TOÁN</h1>
                                            <div class="subtitle">Phòng khám nha khoa chuyên nghiệp</div>
                                        </div>
                                        
                                        <!-- Clinic Info -->
                                        <div class="clinic-info">
                                            <h3>🏥 PHÒNG KHÁM NHA KHOA</h3>
                                            <div class="clinic-details">
                                                <div>
                                                    <strong>📍 Địa chỉ:</strong> 123 Đường ABC, Quận XYZ, TP.HCM<br>
                                                    <strong>📞 Hotline:</strong> 1900-xxx-xxx<br>
                                                    <strong>📧 Email:</strong> info@dental.clinic
                                                </div>
                                                <div>
                                                    <strong>🆔 Mã số thuế:</strong> 0123456789<br>
                                                    <strong>⏰ Giờ làm việc:</strong> 8:00 - 17:00<br>
                                                    <strong>🌐 Website:</strong> www.dental.clinic
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Invoice Body -->
                                        <div class="invoice-body">
                                            <!-- Status -->
                                            <div class="status-section">
                                                <div class="status-badge">
                                                    ✅ THANH TOÁN THÀNH CÔNG
                                                </div>
                                            </div>
                                            
                                            <!-- Transaction Info -->
                                            <div class="info-section">
                                                <h4>📋 Thông tin giao dịch</h4>
                                                <table class="info-table">
                                                    <tr>
                                                        <td class="label">Mã hóa đơn:</td>
                                                        <td class="value"><strong>${billId}</strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Mã đơn hàng:</td>
                                                        <td class="value">${orderId}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Ngày thanh toán:</td>
                                                        <td class="value">${currentDate}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Phương thức:</td>
                                                        <td class="value">🏦 MB Bank - VietQR</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Customer Info -->
                                            <div class="info-section">
                                                <h4>👤 Thông tin khách hàng</h4>
                                                <table class="info-table">
                                                    <tr>
                                                        <td class="label">Họ và tên:</td>
                                                        <td class="value"><strong>${customerName}</strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Dịch vụ:</td>
                                                        <td class="value">${serviceName}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Amount Section -->
                                            <div class="amount-section">
                                                <div class="amount">${amount}</div>
                                                <div class="amount-text">Tổng số tiền đã thanh toán</div>
                                            </div>
                                            
                                            <!-- Banking Details -->
                                            <div class="info-section">
                                                <h4>🏦 Chi tiết chuyển khoản</h4>
                                                <table class="info-table">
                                                    <tr>
                                                        <td class="label">Ngân hàng:</td>
                                                        <td class="value">MB Bank (970422)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Số tài khoản:</td>
                                                        <td class="value"><strong>5529062004</strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Chủ tài khoản:</td>
                                                        <td class="value">TRAN HONG PHUOC</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Nội dung CK:</td>
                                                        <td class="value">Thanh toan ${billId}</td>
                                                    </tr>
                                                </table>
                </div>
                                            
                                            <!-- QR Section -->
                                            <div class="qr-section">
                                                <div class="qr-box">
                                                    <span style="color: #28a745; font-size: 2rem;">✅</span>
                                                </div>
                                                <div><small>Biên lai điện tử đã xác thực</small></div>
                                            </div>
                                            
                                            <!-- Print Date -->
                                            <div class="print-date">
                                                🖨️ In ngày: ${currentDate}
                                            </div>
                                        </div>
                                        
                                        <!-- Footer -->
                                        <div class="footer-section">
                                            <small>
                                                <strong>🔒 Cam kết bảo mật:</strong> Thông tin của bạn được bảo vệ tuyệt đối<br>
                                                <strong>📞 Hỗ trợ 24/7:</strong> Liên hệ 1900-xxx-xxx nếu cần hỗ trợ<br>
                                                <strong>💡 Lưu ý:</strong> Vui lòng mang theo hóa đơn này khi đến khám<br><br>
                                                <em>Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ của chúng tôi! 🙏</em>
                                            </small>
                                        </div>
                                    </div>
                                </body>
                            </html>
                        `);

                        printWindow.document.close();

                        // Wait for content to load then print
                        setTimeout(() => {
                            printWindow.focus();
                            printWindow.print();

                            // Optional: Close window after printing
                    setTimeout(() => {
                                printWindow.close();
                            }, 1000);
                        }, 500);
                }

                    // Success page interactions
                document.addEventListener('DOMContentLoaded', function () {
                        // Start confetti celebration
                    createConfetti();

                        // Success sound (if browser allows)
                        try {
                            const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmsdBT2Y3u/GdyMFl5vv');
                            audio.volume = 0.3;
                            audio.play().catch(() => { }); // Ignore if autoplay blocked
                        } catch (e) { }

                        // Add print receipt shortcut
                        document.addEventListener('keydown', function (e) {
                            if (e.ctrlKey && e.key === 'p') {
                                e.preventDefault();
                                printReceipt();
                            }
                        });

                        // Auto redirect after 2 minutes (optional)
                    setTimeout(() => {
                            if (confirm('Thanh toán thành công! Bạn có muốn quay về trang chủ không?')) {
                                window.location.href = '${pageContext.request.contextPath}/index.jsp';
                            }
                        }, 5000); // 5 seconds

                        // Show countdown timer
                        let countdown = 5;
                        const countdownEl = document.createElement('div');
                        countdownEl.style.cssText = 'position: fixed; top: 10px; right: 10px; background: #28a745; color: white; padding: 10px 15px; border-radius: 5px; z-index: 9999; font-weight: bold;';
                        countdownEl.innerHTML = `Tự động chuyển về trang chủ sau ${countdown}s`;
                        document.body.appendChild(countdownEl);

                        const countdownInterval = setInterval(() => {
                            countdown--;
                            if (countdown > 0) {
                                countdownEl.innerHTML = `Tự động chuyển về trang chủ sau ${countdown}s`;
                            } else {
                                clearInterval(countdownInterval);
                                countdownEl.remove();
                            }
                        }, 1000);
                });

                    // Add smooth scroll effect for better UX
                    function smoothScrollTo(element) {
                        element.scrollIntoView({ behavior: 'smooth' });
                    }
            </script>
        </body>

        </html>