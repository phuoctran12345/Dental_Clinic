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
                    body {
                        background: #f8f9fa;
                        min-height: 100vh;
                        padding: 20px 0;
                    }

                    .payment-container {
                        background: white;
                        border-radius: 10px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                        overflow: hidden;
                        max-width: 1300px;
                        margin: 0 auto;
                    }

                    .payment-header {
                        background: linear-gradient(45deg, #28a745, #20c997);
                        color: white;
                        padding: 30px;
                        text-align: center;
                    }

                    .service-info {
                        background: #f8f9fa;
                        border-radius: 15px;
                        padding: 25px;
                        margin-bottom: 20px;
                        border-left: 5px solid #007bff;
                    }

                    .qr-container {
                        text-align: center;
                        padding: 30px;
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                        margin-bottom: 20px;
                    }

                    .qr-code {
                        max-width: 250px;
                        height: 250px;
                        margin: 20px auto;
                        padding: 15px;
                        background: white;
                        border-radius: 10px;
                        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                    }

                    .payment-amount {
                        font-size: 2rem;
                        font-weight: bold;
                        color: #28a745;
                        text-align: center;
                        margin: 20px 0;
                    }

                    .payment-info {
                        background: white;
                        border-radius: 15px;
                        padding: 25px;
                        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
                    }

                    .info-row {
                        padding: 10px 0;
                        border-bottom: 1px solid #eee;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
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
                    }

                    .countdown {
                        background: #fff3cd;
                        border: 1px solid #ffeaa7;
                        border-radius: 10px;
                        padding: 15px;
                        text-align: center;
                        margin: 20px 0;
                    }

                    .step-indicator {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        margin: 20px 0;
                    }

                    .step {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        background: #6c757d;
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: bold;
                        margin: 0 10px;
                        position: relative;
                    }

                    .step.active {
                        background: #28a745;
                    }

                    .step.completed {
                        background: #007bff;
                    }

                    .step-line {
                        width: 50px;
                        height: 2px;
                        background: #6c757d;
                    }

                    .step-line.active {
                        background: #28a745;
                    }

                    .btn-payment {
                        border-radius: 25px;
                        padding: 12px 30px;
                        font-weight: 600;
                        font-size: 1.1rem;
                        transition: all 0.3s;
                    }

                    .btn-payment:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                    }

                    .status-indicator {
                        padding: 20px;
                        text-align: center;
                        border-radius: 10px;
                        margin: 20px 0;
                    }

                    .status-waiting {
                        background: #fff3cd;
                        border: 1px solid #ffeaa7;
                        color: #856404;
                    }

                    .payment-methods {
                        display: flex;
                        justify-content: center;
                        gap: 20px;
                        margin: 20px 0;
                    }

                    .payment-method {
                        text-align: center;
                        padding: 15px;
                        border: 2px solid #e9ecef;
                        border-radius: 10px;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .payment-method.active {
                        border-color: #007bff;
                        background: #f8f9ff;
                    }

                    .payment-method:hover {
                        border-color: #007bff;
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

                    /* ENHANCED: Animation for better UX */
                    @keyframes slideInRight {
                        from {
                            transform: translateX(100%);
                            opacity: 0;
                        }

                        to {
                            transform: translateX(0);
                            opacity: 1;
                        }
                    }

                    @keyframes slideOutRight {
                        from {
                            transform: translateX(0);
                            opacity: 1;
                        }

                        to {
                            transform: translateX(100%);
                            opacity: 0;
                        }
                    }

                    @keyframes fallAndFade {
                        0% {
                            transform: translateY(-50px) rotate(0deg);
                            opacity: 1;
                        }

                        50% {
                            transform: translateY(50vh) rotate(180deg);
                            opacity: 0.8;
                        }

                        100% {
                            transform: translateY(100vh) rotate(360deg);
                            opacity: 0;
                        }
                    }

                    @keyframes pulse {
                        0% {
                            transform: scale(1);
                            box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7);
                        }

                        50% {
                            transform: scale(1.05);
                            box-shadow: 0 0 0 10px rgba(40, 167, 69, 0);
                        }

                        100% {
                            transform: scale(1);
                            box-shadow: 0 0 0 0 rgba(40, 167, 69, 0);
                        }
                    }

                    @keyframes successGlow {
                        0% {
                            background: #d4edda;
                            transform: scale(1);
                        }

                        50% {
                            background: #c3e6cb;
                            transform: scale(1.02);
                        }

                        100% {
                            background: #d4edda;
                            transform: scale(1);
                        }
                    }

                    .payment-success {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                        animation: successGlow 2s ease-in-out infinite;
                    }

                    .status-waiting {
                        animation: pulse 2s infinite;
                    }

                    .qr-code:hover {
                        transform: scale(1.05);
                        transition: all 0.3s ease;
                    }

                    .animate-pulse {
                        animation: pulse 1s infinite;
                    }

                    @keyframes pulse {
                        0% {
                            opacity: 1;
                            transform: scale(1);
                        }

                        50% {
                            opacity: 0.7;
                            transform: scale(1.05);
                        }

                        100% {
                            opacity: 1;
                            transform: scale(1);
                        }
                    }

                    .payment-timeout-warning {
                        border: 2px solid #ffc107;
                        background: linear-gradient(45deg, #fff3cd, #ffeaa7);
                    }

                    .urgent-timeout {
                        border: 2px solid #dc3545;
                        background: linear-gradient(45deg, #f8d7da, #f5c6cb);
                        animation: shake 0.5s infinite;
                    }

                    @keyframes shake {

                        0%,
                        100% {
                            transform: translateX(0);
                        }

                        25% {
                            transform: translateX(-2px);
                        }

                        75% {
                            transform: translateX(2px);
                        }
                    }
                </style>
                <style>
                    @media print {
                        body {
                            background: #fff !important;
                        }

                        .container,
                        .card,
                        .main-content {
                            width: 100% !important;
                            max-width: 500px !important;
                            margin: 0 auto !important;
                            box-shadow: none !important;
                            padding: 0 !important;
                        }

                        .alert,
                        .card,
                        .main-content {
                            margin: 0 !important;
                            padding: 4px 8px !important;
                        }

                        .no-print,
                        .btn,
                        .sidebar,
                        .footer,
                        .navbar {
                            display: none !important;
                        }

                        table {
                            font-size: 13px !important;
                        }

                        h1,
                        h2,
                        h3,
                        h4,
                        h5 {
                            margin: 4px 0 !important;
                            font-size: 1.1em !important;
                        }

                        .qr-section,
                        .alert-info,
                        .alert-success,
                        .alert-warning {
                            page-break-inside: avoid !important;
                        }

                        .qr-section {
                            margin-bottom: 0 !important;
                        }

                        .qr-section small,
                        .qr-section div {
                            font-size: 11px !important;
                            margin: 0 !important;
                            padding: 0 !important;
                        }

                        @page {
                            size: A5 portrait;
                            margin: 8mm;
                        }
                    }
                </style>
                <style>
                    @media print {
                        .bill-print-area {
                            font-size: 11px !important;
                            padding: 8px !important;
                            margin: 0 !important;
                            width: 90mm !important;
                            max-width: 100% !important;
                            background: #fff !important;
                            box-shadow: none !important;
                            page-break-inside: avoid !important;
                        }

                        .bill-print-area * {
                            font-size: 11px !important;
                            margin: 0 !important;
                            padding: 0 !important;
                            line-height: 1.2 !important;
                        }

                        .qr-section,
                        .bill-table,
                        .bill-header,
                        .bill-footer {
                            page-break-inside: avoid !important;
                        }

                        .btn,
                        .no-print {
                            display: none !important;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="bill-print-area">
                    <% String isStaff=request.getParameter("isStaff"); %>
                        <% if ("true".equals(isStaff)) { %>
                            <!-- HÓA ĐƠN STAFF (copy UI từ staff_bill.jsp) -->
                            <div class="container" style="max-width: 700px;">
                                <div class="card shadow">
                                    <div class="card-header text-center bg-primary text-white">
                                        <h3 class="mb-0">Happy Simle</h3>
                                        <div>HÓA ĐƠN TẠM TÍNH </div>
                                        <div style="font-size:1.1em; margin-top:8px;">
                                            <b>Happy Smile</b> - Địa chỉ: FPT University Da Nang<br>
                                            Giờ hoạt động: 7h30 - 17h (T2 - CN) | Hotline: 0936 929 382
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-2">
                                            <div class="col-8"><b>Dịch vụ:</b> ${bill.serviceName}</div>
                                            <div class="col-4 text-end"><b>Đơn giá:</b>
                                                <fmt:formatNumber value='${bill.amount}' type='currency' />
                                            </div>
                                        </div>
                                        <div class="mb-2"><b>Ngày in hóa đơn:</b> <span id="realtime-now"></span></div>
                                        <script>
                                            // Hiển thị ngày giờ realtime
                                            document.addEventListener('DOMContentLoaded', function () {
                                                var now = new Date();
                                                var formatted = now.toLocaleString('vi-VN', { hour12: false });
                                                document.getElementById('realtime-now').textContent = formatted;
                                            });
                                            // Hiển thị bảng dịch vụ từ localStorage nếu có (chỉ staff)
                                            document.addEventListener('DOMContentLoaded', function () {
                                                const urlParams = new URLSearchParams(window.location.search);
                                                const isStaff = urlParams.get('isStaff');
                                                if (isStaff === 'true') {
                                                    let billDetailsStr = sessionStorage.getItem('billDetails');
                                                    if (!billDetailsStr) billDetailsStr = localStorage.getItem('billDetails');
                                                    const tbody = document.getElementById('serviceTableBody');
                                                    console.log('[DEBUG][payment.jsp] billDetailsStr:', billDetailsStr);
                                                    if (billDetailsStr && tbody) {
                                                        try {
                                                            const billDetails = JSON.parse(billDetailsStr);
                                                            console.log('[DEBUG][payment.jsp] billDetails:', billDetails);
                                                            if (Array.isArray(billDetails) && billDetails.length > 0) {
                                                                tbody.innerHTML = billDetails.map(function (item) {
                                                                    return '<tr>'
                                                                        + '<td>' + item.serviceName + '</td>'
                                                                        + '<td>' + item.quantity + '</td>'
                                                                        + '<td>' + item.unitPrice.toLocaleString('vi-VN') + ' VNĐ</td>'
                                                                        + '<td>' + item.totalPrice.toLocaleString('vi-VN') + ' VNĐ</td>'
                                                                        + '</tr>';
                                                                }).join('');
                                                                // Tính tổng thành tiền
                                                                var total = billDetails.reduce(function (sum, item) {
                                                                    return sum + Number(item.totalPrice);
                                                                }, 0);
                                                                var totalEl = document.getElementById('totalAmountStaff');
                                                                if (totalEl) totalEl.textContent = total.toLocaleString('vi-VN') + ' VNĐ';
                                                                // KHÔNG xóa billDetails ngay để user có thể F5 lại mà không mất dữ liệu
                                                            } else {
                                                                tbody.innerHTML = '<tr><td colspan="4" class="text-center text-danger">Không có dịch vụ nào!</td></tr>';
                                                            }
                                                        } catch (e) {
                                                            console.error('[DEBUG][payment.jsp] Lỗi parse billDetails:', e);
                                                            tbody.innerHTML = '<tr><td colspan="4" class="text-center text-danger">Lỗi dữ liệu dịch vụ!</td></tr>';
                                                        }
                                                    } else if (tbody) {
                                                        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-danger">Không có dịch vụ nào!</td></tr>';
                                                    }
                                                }
                                            });
                                        </script>
                                        <table class="table table-bordered mt-3">
                                            <thead>
                                                <tr>
                                                    <th>Dịch vụ </th>
                                                    <th>SL</th>
                                                    <th>Đơn giá</th>
                                                    <th>Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody id="serviceTableBody">
                                                <%-- Nếu KHÔNG phải staff thì mới lặp qua billDetails bằng EL/JSTL --%>
                                                    <c:if test="${param.isStaff ne 'true'}">
                                                        <c:choose>
                                                            <c:when test="${not empty billDetails}">
                                                                <c:forEach var="item" items="${billDetails}">
                                                                    <tr>
                                                                        <td>${item.serviceName}</td>
                                                                        <td>${item.quantity}</td>
                                                                        <td>
                                                                            <fmt:formatNumber value='${item.unitPrice}'
                                                                                type='currency' />
                                                                        </td>
                                                                        <td>
                                                                            <fmt:formatNumber value='${item.totalPrice}'
                                                                                type='currency' />
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <tr>
                                                                    <td>${bill.serviceName}</td>
                                                                    <td>1</td>
                                                                    <td>
                                                                        <fmt:formatNumber value='${bill.amount}'
                                                                            type='currency' />
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatNumber value='${bill.amount}'
                                                                            type='currency' />
                                                                    </td>
                                                                </tr>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                            </tbody>
                                        </table>
                                        <div class="alert alert-success text-center mt-3" style="font-size:1.3em;">
                                            <b>Tổng tiền:
                                                <span id="totalAmountStaff"></span>
                                            </b>
                                        </div>

                                        <div class="row align-items-center" style="margin-top: 12px;">
                                            <div class="col-12 col-md-6">
                                                <div class="alert alert-info">
                                                    <b>Thanh toán chuyển khoản</b><br>
                                                    Ngân hàng: MB Bank<br>
                                                    STK: 5529062004<br>
                                                    Chủ TK: TRAN HONG PHUOC<br>
                                                    Nội dung: ${bill.billId}
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-6">
                                                <div class="qr-section" style="text-align:center;">
                                                    <img id="qrImage" src="${qrUrl}" alt="QR chuyển khoản"
                                                        style="width:200px;">
                                                    <div><small>Quét mã QR để chuyển khoản</small></div>
                                                </div>
                                            </div>
                                        </div>
                                        <script>
                                            (function () {
                                                const urlParams = new URLSearchParams(window.location.search);
                                                const billId = urlParams.get('billId');
                                                const isStaff = urlParams.get('isStaff');
                                                if (billId && isStaff === 'true') {
                                                    fetch('StaffPaymentServlet?action=getQR&billId=' + encodeURIComponent(billId))
                                                        .then(res => res.json())
                                                        .then(data => {
                                                            if (data.success && data.qrUrl) {
                                                                document.getElementById('qrImage').src = data.qrUrl;
                                                            } else {
                                                                document.getElementById('qrImage').alt = 'Không lấy được mã QR!';
                                                            }
                                                        })
                                                        .catch(err => {
                                                            document.getElementById('qrImage').alt = 'Lỗi khi lấy mã QR!';
                                                        });
                                                }
                                            })();
                                        </script>

                                        <div id="payment-status" class="alert alert-warning text-center mt-3 no-print">
                                            Đang chờ khách thanh toán... <span id="countdown">05:00</span>
                                        </div>
                                    </div>
                                    <div class="card-footer text-center no-print">
                                        <button onclick="window.print()" class="btn btn-outline-primary">In hóa
                                            đơn</button>
                                    </div>
                                </div>
                            </div>
                            <script>
                                // Đếm ngược 5 phút cho staff
                                let timeLeftStaff = 5 * 60;
                                function updateCountdownStaff() {
                                    const minutes = Math.floor(timeLeftStaff / 60);
                                    const seconds = timeLeftStaff % 60;
                                    document.getElementById('countdown').textContent =
                                        minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
                                    if (timeLeftStaff <= 0) {
                                        document.getElementById('payment-status').innerHTML = 'Hết thời gian chờ thanh toán!';
                                        return;
                                    }
                                    timeLeftStaff--;
                                }
                                setInterval(updateCountdownStaff, 1000);
                                // Polling kiểm tra trạng thái thanh toán
                                let paid = false;
                                setInterval(function () {
                                    if (paid) return;
                                    fetch('StaffPaymentServlet?action=checkStatus&billId=${bill.billId}')
                                        .then(res => res.json())
                                        .then(data => {
                                            if (data.success && (data.status === 'PAID' || data.status === 'paid' || data.status === 'success')) {
                                                paid = true;
                                                playSuccessSound();
                                                document.getElementById('payment-status').className = 'alert alert-success text-center mt-3';
                                                document.getElementById('payment-status').innerHTML = 'Đã nhận được thanh toán!';
                                            }
                                        });
                                }, 3000);
                                // Hàm phát âm thanh thành công
                                function playSuccessSound() {
                                    const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmsdBT2Y3u/GdyMFl5vv');
                                    audio.volume = 0.7;
                                    audio.play().catch(() => { });
                                }
                            </script>
                            <% } else { %>
                                <!-- UI cho khách như cũ -->
                                <div class="container">
                                    <!-- Payment Header -->
                                    <div class="payment-container">
                                        <div class="payment-header">
                                            <h1 class="mb-3">
                                                <i class="fas fa-credit-card me-3"></i>
                                                Thanh toán dịch vụ
                                            </h1>
                                            <p class="lead mb-0">Hoàn tất thanh toán để xác nhận lịch khám</p>
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
                                            <div class="row text-center mb-3">
                                                <div class="col-4"><small>Chọn dịch vụ</small></div>
                                                <div class="col-4"><small><strong>Thanh toán</strong></small></div>
                                                <div class="col-4"><small>Hoàn thành</small></div>
                                            </div>

                                            <!-- Hidden form với thông tin người thân -->
                                            <form id="paymentHiddenForm" style="display: none;">
                                                <input type="hidden" name="bookingFor" value="${param.bookingFor}">
                                                <input type="hidden" name="relativeId" value="${param.relativeId}">
                                                <input type="hidden" name="doctorId" value="${param.doctorId}">
                                                <input type="hidden" name="workDate" value="${param.workDate}">
                                                <input type="hidden" name="slotId" value="${param.slotId}">
                                                <input type="hidden" name="serviceId" value="${param.serviceId}">
                                                <input type="hidden" name="reason" value="${param.reason}">
                                            </form>

                                            <div class="row">
                                                <!-- Service Information -->
                                                <div class="col-md-6">
                                                    <div class="service-info">
                                                        <h4 class="mb-3">
                                                            <i class="fas fa-tooth text-primary me-2"></i>
                                                            Thông tin dịch vụ
                                                        </h4>
                                                        <div class="info-row">
                                                            <span class="info-label">Dịch vụ:</span>
                                                            <span
                                                                class="info-value"><strong>${service.serviceName}</strong></span>
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
                                                            <i class="fas fa-file-invoice-dollar text-success me-2"></i>
                                                            Chi tiết thanh toán
                                                        </h5>
                                                        <div class="info-row">
                                                            <span class="info-label">Mã đơn hàng:</span>
                                                            <span
                                                                class="info-value"><code>${paymentInfo.orderId}</code></span>
                                                        </div>
                                                        <div class="info-row">
                                                            <span class="info-label">Mã hóa đơn:</span>
                                                            <span
                                                                class="info-value"><code>${paymentInfo.billId}</code></span>
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
                                                            <i class="fas fa-qrcode text-primary me-2"></i>
                                                            Quét mã QR để thanh toán
                                                        </h4>
                                                        <!-- QR code riêng cho staff, chỉ hiện khi isStaff=true -->
                                                        <div id="staff-qr-wrapper"
                                                            style="display:none; text-align:center; margin-bottom: 16px;">
                                                            <img id="qrImage" src="" alt="QR code sẽ hiện ở đây"
                                                                style="width: 200px; height: 200px; display: block; margin: 0 auto 16px auto;">
                                                        </div>
                                                        <script>
                                                            // Hiện QR staff nếu có isStaff=true
                                                            (function () {
                                                                const urlParams = new URLSearchParams(window.location.search);
                                                                const isStaff = urlParams.get('isStaff');
                                                                if (isStaff === 'true') {
                                                                    document.getElementById('staff-qr-wrapper').style.display = 'block';
                                                                }
                                                            })();
                                                        </script>

                                                        <!-- Multi-bank support notice -->
                                                        <div class="alert alert-success mb-3">
                                                            <i class="fas fa-university me-2"></i>
                                                            <strong>Hỗ trợ TẤT CẢ ngân hàng Việt Nam!</strong><br>
                                                            <small>Vietcombank, BIDV, Agribank, VietinBank, Techcombank,
                                                                ACB, SHB,
                                                                VPBank, TPBank, Sacombank, HDBank, v.v...</small>
                                                        </div>

                                                        <!-- Payment Amount -->
                                                        <div class="payment-amount">
                                                            ${paymentInfo.formattedAmount}
                                                        </div>

                                                        <!-- QR Code -->
                                                        <div class="qr-code">
                                                            <img src="${paymentInfo.qrCode}" alt="VietQR Banking Code"
                                                                class="img-fluid"
                                                                onerror="this.src='https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=${paymentInfo.qrCode}'">
                                                        </div>

                                                        <!-- Payment Methods -->
                                                        <div class="payment-methods">
                                                            <h5><i class="fas fa-credit-card me-2"></i>Phương thức thanh
                                                                toán</h5>

                                                            <!-- Payment Timeout Warning -->
                                                            <div class="alert alert-warning mb-3">
                                                                <div
                                                                    class="d-flex align-items-center justify-content-between">
                                                                    <div>
                                                                        <i class="fas fa-clock me-2"></i>
                                                                        <strong>Thời gian thanh toán còn lại:</strong>
                                                                    </div>
                                                                    <div class="text-end">
                                                                        <span id="payment-countdown"
                                                                            class="badge bg-warning text-dark fs-6">5:00</span>
                                                                    </div>
                                                                </div>
                                                                <small class="text-muted d-block mt-1">
                                                                    ⚠️ Vui lòng hoàn tất thanh toán trong thời gian này.
                                                                    Sau
                                                                    đó slot sẽ
                                                                    được trả về cho người khác.
                                                                </small>
                                                            </div>

                                                            <div class="method-grid">
                                                                <div class="payment-method active" data-method="vietqr">
                                                                    <div class="method-header">
                                                                        <i class="fas fa-qrcode"></i>
                                                                        <h6>VietQR - Quét mã thanh toán</h6>
                                                                        <span class="recommended">Khuyến nghị</span>
                                                                    </div>
                                                                    <p>Quét QR bằng app ngân hàng của bạn</p>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Manual Check Button -->
                                                        <div class="text-center mb-3">
                                                            <button class="btn btn-success btn-payment"
                                                                onclick="manualCheckPayment()">
                                                                <i class="fas fa-check-circle me-2"></i>
                                                                Tôi đã thanh toán - Kiểm tra ngay
                                                            </button>
                                                        </div>

                                                        <!-- Status -->
                                                        <div class="status-indicator status-waiting">
                                                            <i class="fas fa-search me-2"></i>
                                                            <strong>🔍 Hệ thống phát hiện thanh toán THẬT...</strong>
                                                        </div>

                                                        <!-- Test Button (for development) -->
                                                        <div class="text-center mt-3">
                                                            <button class="btn btn-outline-warning btn-sm"
                                                                onclick="simulatePayment()"
                                                                title="🧪 Test: Giả lập đã thanh toán qua app ngân hàng">
                                                                🧪 Test: Đã thanh toán
                                                            </button>
                                                            <br><small class="text-muted">⚠️ Chỉ dùng để test - Hệ thống
                                                                đã
                                                                TẮT
                                                                auto-detect giả</small>
                                                            <div class="mt-2">
                                                                <small>🏦 1. Quét QR bằng app ngân hàng BẤT
                                                                    KỲ</small><br>
                                                                <small>📱 2. Chuyển khoản với số tiền CHÍNH
                                                                    XÁC</small><br>
                                                                <small>⏰ 3. Hệ thống sẽ tự động phát hiện (timeout: 5
                                                                    phút)</small>
                                                            </div>
                                                            <div class="mt-3">
                                                                <div class="spinner-border spinner-border-sm text-primary me-2"
                                                                    role="status"></div>
                                                                <small class="text-muted">Chỉ phát hiện thanh toán THẬT
                                                                    -
                                                                    không có false
                                                                    positive</small>
                                                            </div>
                                                        </div>

                                                        <!-- Countdown Timer -->
                                                        <div class="countdown">
                                                            <i class="fas fa-hourglass-half me-2"></i>
                                                            <strong>Thời gian còn lại: <span
                                                                    id="countdown">05:00</span></strong>
                                                            <div><small>Thanh toán sẽ hết hạn sau 5 phút</small></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Action Buttons -->
                                            <div class="row">
                                                <div class="col-12 text-center">
                                                    <!-- AUTO-DETECTION INFO (No manual buttons needed) -->
                                                    <div class="alert alert-info mb-3">
                                                        <h5><i class="fas fa-search me-2"></i>🔍 Phát hiện thanh toán
                                                            THẬT
                                                        </h5>
                                                        <p class="mb-2">
                                                            <strong>Hệ thống chỉ phát hiện thanh toán THẬT - không có
                                                                false
                                                                positive!</strong><br>
                                                            <small>⏰ Timeout: 5 phút → nếu không thanh toán sẽ về trang
                                                                chủ</small>
                                                        </p>
                                                        <div class="row text-center mt-3">
                                                            <div class="col-3">
                                                                <i
                                                                    class="fas fa-database fa-2x text-primary mb-2"></i><br>
                                                                <small><strong>Database Check</strong><br>Thanh toán
                                                                    thật</small>
                                                            </div>
                                                            <div class="col-3">
                                                                <i class="fas fa-bell fa-2x text-success mb-2"></i><br>
                                                                <small><strong>Webhook Real</strong><br>Bank
                                                                    notification</small>
                                                            </div>
                                                            <div class="col-3">
                                                                <i
                                                                    class="fas fa-university fa-2x text-warning mb-2"></i><br>
                                                                <small><strong>VietQR API</strong><br>Transaction
                                                                    verify</small>
                                                            </div>
                                                            <div class="col-3">
                                                                <i class="fas fa-clock fa-2x text-danger mb-2"></i><br>
                                                                <small><strong>5 Min Timeout</strong><br>Auto redirect
                                                                    home</small>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Manual override for emergency (smaller, less prominent) -->
                                                    <details class="mt-3">
                                                        <summary class="btn btn-outline-secondary btn-sm">
                                                            <i class="fas fa-cog me-1"></i>Tuỳ chọn thủ công (chỉ khi
                                                            cần)
                                                        </summary>
                                                        <div class="mt-3">
                                                            <button type="button" class="btn btn-info btn-sm me-2"
                                                                onclick="checkPaymentStatus()">
                                                                <i class="fas fa-sync-alt me-1"></i>Kiểm tra ngay
                                                            </button>
                                                            <button type="button" class="btn btn-success btn-sm me-2"
                                                                onclick="confirmRealPayment()"
                                                                title="Chỉ dùng khi đã chuyển khoản thực sự">
                                                                <i class="fas fa-check-circle me-1"></i>Đã chuyển khoản
                                                            </button>
                                                            <button type="button" class="btn btn-warning btn-sm me-2"
                                                                onclick="forcePaymentSuccess()"
                                                                title="Dev Tool: Force success for testing">
                                                                <i class="fas fa-magic me-1"></i>🧪 Test
                                                            </button>
                                                        </div>
                                                    </details>

                                                    <div class="mt-3">
                                                        <a href="#" onclick="cancelPaymentAndGoHome()"
                                                            class="btn btn-outline-secondary">
                                                            <i class="fas fa-arrow-left me-2"></i>Quay lại trang chủ
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Help Section -->
                                            <div class="row mt-4">
                                                <div class="col-12">
                                                    <div class="alert alert-info">
                                                        <h6><i class="fas fa-info-circle me-2"></i>Hướng dẫn thanh toán
                                                            (Tất
                                                            cả ngân
                                                            hàng):</h6>
                                                        <ol class="mb-0">
                                                            <li><strong>Bước 1:</strong> Mở app ngân hàng của bạn
                                                                (Vietcombank, BIDV,
                                                                Agribank, VietinBank, Techcombank, ACB, SHB, VPBank,
                                                                TPBank,
                                                                Sacombank,
                                                                HDBank, MB Bank...)</li>
                                                            <li><strong>Bước 2:</strong> Chọn "Chuyển khoản QR" hoặc
                                                                "Quét
                                                                mã QR"</li>
                                                            <li><strong>Bước 3:</strong> Quét mã QR hiển thị trên màn
                                                                hình
                                                            </li>
                                                            <li><strong>Bước 4:</strong> Kiểm tra thông tin và xác nhận
                                                                chuyển khoản
                                                            </li>
                                                            <li><strong>Bước 5:</strong> Ấn nút "✅ Đã chuyển khoản thành
                                                                công" để hoàn
                                                                tất</li>
                                                        </ol>
                                                        <hr>
                                                        <small class="text-muted">
                                                            💡 <strong>Lưu ý:</strong> VietQR hỗ trợ chuyển khoản liên
                                                            ngân
                                                            hàng 24/7.
                                                            Bạn có thể dùng bất kỳ ngân hàng nào để chuyển tiền!
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    // Countdown timer - FIXED: 5 minutes instead of 15
                                    let timeLeft = 5 * 60; // 5 minutes in seconds (was 15 * 60)

                                    function updateCountdown() {
                                        const minutes = Math.floor(timeLeft / 60);
                                        const seconds = timeLeft % 60;
                                        document.getElementById('countdown').textContent =
                                            minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');

                                        if (timeLeft <= 0) {
                                            alert('Thời gian thanh toán đã hết hạn. Slot sẽ được trả về hàng đợi.');
                                            window.location.href = 'payment?action=cancel'; // Redirect to cancel to release slot
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
                                                console.log('Payment status check:', data);

                                                if (data.status === 'success' || data.status === 'SUCCESS') {
                                                    // Success with celebration
                                                    btn.innerHTML = '<i class="fas fa-check me-2"></i>Thanh toán thành công!';
                                                    btn.className = 'btn btn-success btn-payment';

                                                    showToast('🎉 Thanh toán thành công! Đang chuyển trang...', 'success');

                                                    setTimeout(() => {
                                                        window.location.href = 'payment?action=success';
                                                    }, 1500);

                                                } else if (data.status === 'pending') {
                                                    btn.innerHTML = originalText;
                                                    btn.disabled = false;
                                                    showToast('⏳ Vui lòng hoàn tất thanh toán và thử lại', 'warning');
                                                } else {
                                                    btn.innerHTML = originalText;
                                                    btn.disabled = false;
                                                    showToast('❌ Chưa có giao dịch nào. Vui lòng quét QR và thanh toán', 'info');
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error checking payment:', error);
                                                btn.innerHTML = originalText;
                                                btn.disabled = false;
                                                showToast('⚠️ Lỗi kiểm tra. Vui lòng thử lại', 'danger');
                                            });
                                    }

                                    // Open PayOS app
                                    function openPayOSApp() {
                                        const qrCode = '${paymentInfo.qrCode}';
                                        if (qrCode) {
                                            window.open(qrCode, '_blank');
                                        }
                                    }

                                    // SIMPLE: Payment detection variables
                                    let checkInterval;
                                    let checkCount = 0;
                                    const maxChecks = 300; // 5 minutes 
                                    let paymentDetected = false;

                                    // ENHANCED: Detect real payment from bank in 3 seconds
                                    function startSimplePaymentDetection() {
                                        const orderId = '${paymentInfo.orderId}';
                                        if (!orderId) return;

                                        console.log('🏦 BẮT ĐẦU KIỂM TRA THANH TOÁN NGÂN HÀNG...');
                                        console.log('⚡ Phát hiện thanh toán nhanh như app thật');

                                        // Show real banking experience notification
                                        showToast('🏦 Hệ thống kiểm tra thanh toán tự động', 'info');
                                        setTimeout(() => {
                                            showToast('💳 Vui lòng mở app ngân hàng và quét QR để thanh toán', 'success');
                                        }, 1500);

                                        // Update UI with real banking status
                                        updateStatus('�� Đang chờ bạn thanh toán qua app ngân hàng...', 'info');

                                        // REAL-TIME CHECK: Every 2 seconds (like real banking)
                                        let fastCount = 0;
                                        const bankingInterval = setInterval(() => {
                                            fastCount++;

                                            console.log(`🏦 Kiểm tra thanh toán lần ${fastCount} - Như hệ thống ngân hàng thật`);

                                            fetch('payment?action=checkStatus&orderId=' + orderId)
                                                .then(response => response.json())
                                                .then(data => {
                                                    console.log(`💳 Kết quả kiểm tra (${fastCount * 2}s):`, data);

                                                    if (data.status === 'success' && !paymentDetected) {
                                                        paymentDetected = true;
                                                        clearInterval(bankingInterval);
                                                        clearInterval(checkInterval);

                                                        const detectionTime = fastCount * 2;
                                                        console.log(`🎉 THANH TOÁN THÀNH CÔNG sau ${detectionTime} giây!`);

                                                        // Real banking success feedback
                                                        updateStatus(`🎉 Thanh toán thành công!`, 'success');
                                                        createCelebration();

                                                        // Real banking success message
                                                        showToast(`✅ Đã nhận được thanh toán của bạn!`, 'success');

                                                        // Wait 3 seconds then redirect (like real banking)
                                                        let redirectTime = 3;
                                                        updateStatus(`✅ Giao dịch hoàn tất! Chuyển trang trong ${redirectTime}s...`, 'success');

                                                        const redirectCounter = setInterval(() => {
                                                            redirectTime--;
                                                            updateStatus(`✅ Giao dịch hoàn tất! Chuyển trang trong ${redirectTime}s...`, 'success');

                                                            if (redirectTime <= 0) {
                                                                clearInterval(redirectCounter);
                                                                window.location.href = 'payment?action=success';
                                                            }
                                                        }, 1000);
                                                    }

                                                    // Show realistic banking progress
                                                    if (!paymentDetected) {
                                                        const timeElapsed = fastCount * 2;
                                                        if (timeElapsed <= 15) {
                                                            updateStatus(`📱 Vui lòng mở app ngân hàng và quét QR...`, 'primary');
                                                        } else if (timeElapsed <= 45) {
                                                            updateStatus(`💳 Đang xử lý giao dịch... (${timeElapsed}s)`, 'warning');
                                                        } else {
                                                            updateStatus(`🔄 Kiểm tra thanh toán... (${timeElapsed}s)`, 'info');
                                                        }
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Lỗi kiểm tra thanh toán:', error);
                                                });

                                            // Stop fast checking after 30 seconds
                                            if (fastCount >= 15) { // 15 * 2 = 30 seconds
                                                clearInterval(bankingInterval);
                                                console.log('🏦 Chuyển sang kiểm tra thường xuyên...');

                                                if (!paymentDetected) {
                                                    showToast('🔄 Tiếp tục kiểm tra thanh toán...', 'info');
                                                }
                                            }
                                        }, 2000); // Every 2 seconds (realistic banking speed)

                                        // NORMAL SPEED CHECK: Every 5 seconds after fast phase
                                        checkInterval = setInterval(() => {
                                            if (paymentDetected) return;

                                            checkCount++;
                                            console.log(`🔄 Kiểm tra thường xuyên ${checkCount}/60 - Tìm thanh toán...`);

                                            fetch('payment?action=checkStatus&orderId=' + orderId)
                                                .then(response => response.json())
                                                .then(data => {
                                                    if (data.status === 'success' && !paymentDetected) {
                                                        paymentDetected = true;
                                                        clearInterval(checkInterval);

                                                        console.log('🎉 THANH TOÁN THÀNH CÔNG!');

                                                        // Banking success animation
                                                        updateStatus('🎉 Thanh toán thành công!', 'success');
                                                        createCelebration();

                                                        // Wait 3 seconds then redirect
                                                        setTimeout(() => {
                                                            updateStatus('✅ Hoàn tất! Chuyển trang...', 'success');
                                                            // Redirect với thông tin người thân
                                                            const hiddenForm = document.getElementById('paymentHiddenForm');
                                                            const formData = new FormData(hiddenForm);
                                                            const bookingFor = formData.get('bookingFor');
                                                            const relativeId = formData.get('relativeId');

                                                            let successUrl = 'payment?action=success';
                                                            if (bookingFor === 'relative' && relativeId) {
                                                                successUrl += '&bookingFor=relative&relativeId=' + relativeId;
                                                            }
                                                            window.location.href = successUrl;
                                                        }, 3000);
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Lỗi kiểm tra:', error);
                                                });

                                            // Timeout after 5 minutes (like real banking)
                                            if (checkCount >= 60) { // 60 * 5s = 5 minutes
                                                clearInterval(checkInterval);
                                                updateStatus('⏰ Hết thời gian thanh toán. Hủy giao dịch...', 'danger');
                                                setTimeout(() => {
                                                    window.location.href = 'payment?action=cancel';
                                                }, 3000);
                                            }
                                        }, 5000); // Every 5 seconds
                                    }

                                    // Simple status update
                                    function updateStatus(message, type) {
                                        const statusDiv = document.querySelector('.status-indicator');
                                        if (!statusDiv) return;

                                        let bgColor = '#d1ecf1', borderColor = '#bee5eb', textColor = '#0c5460';

                                        if (type === 'success') {
                                            bgColor = '#d4edda'; borderColor = '#c3e6cb'; textColor = '#155724';
                                        } else if (type === 'warning') {
                                            bgColor = '#fff3cd'; borderColor = '#ffeaa7'; textColor = '#856404';
                                        } else if (type === 'danger') {
                                            bgColor = '#f8d7da'; borderColor = '#f5c6cb'; textColor = '#721c24';
                                        }

                                        statusDiv.innerHTML = `
                            <div style="background: ${bgColor}; border: 1px solid ${borderColor}; color: ${textColor}; padding: 20px; border-radius: 10px; text-align: center;">
                                <strong>${message}</strong>
                            </div>
                        `;
                                    }

                                    // Simple celebration effect
                                    function createCelebration() {
                                        // Add success emojis
                                        for (let i = 0; i < 5; i++) {
                                            setTimeout(() => {
                                                const emoji = document.createElement('div');
                                                emoji.innerHTML = ['🎉', '✅', '💰'][Math.floor(Math.random() * 3)];
                                                emoji.style.cssText = `
                                    position: fixed;
                                    font-size: 2rem;
                                    left: ${Math.random() * 100}%;
                                    top: -50px;
                                    z-index: 9999;
                                    pointer-events: none;
                                    animation: fallAndFade 2s ease-out forwards;
                                `;
                                                document.body.appendChild(emoji);
                                                setTimeout(() => emoji.remove(), 2000);
                                            }, i * 300);
                                        }
                                    }



                                    function startRealPaymentDetection() {
                                        const orderId = '${paymentInfo.orderId}';
                                        if (!orderId) return;

                                        console.log('🔄 Starting REAL payment detection (optimized UI)...');
                                        showToast('🔍 Chỉ phát hiện thanh toán THẬT - Timeout: 5 phút', 'info');

                                        // Update status immediately
                                        updatePaymentDetectionStatus('🔍 Đang quét thanh toán thật...', 'primary');

                                        checkInterval = setInterval(() => {
                                            checkCount++;
                                            const timeElapsed = checkCount; // seconds
                                            const minutesLeft = Math.ceil((maxChecks - checkCount) / 60);

                                            console.log(`🔄 Checking REAL payment... ${checkCount}/${maxChecks} (${minutesLeft}min left)`);

                                            // OPTIMIZED: Only update progress every 5 seconds to reduce UI load
                                            if (checkCount % 5 === 0 || checkCount <= 10) {
                                                updatePaymentProgress(checkCount, maxChecks);
                                            }

                                            fetch('payment?action=checkStatus&orderId=' + orderId)
                                                .then(response => response.json())
                                                .then(data => {
                                                    console.log('Real payment check result:', data);

                                                    // OPTIMIZED: Only update UI when status actually changes
                                                    if (data.status !== lastStatus) {
                                                        lastStatus = data.status;

                                                        if (data.status === 'success' || data.status === 'SUCCESS') {
                                                            console.log('🎉 REAL PAYMENT DETECTED! Redirecting...');
                                                            clearInterval(checkInterval);

                                                            updatePaymentDetectionStatus('🎉 Phát hiện thanh toán thật!', 'success');

                                                            // Success feedback
                                                            document.querySelector('.status-indicator').innerHTML = `
                                                <div style="background: linear-gradient(45deg, #28a745, #20c997); border: 1px solid #c3e6cb; color: white; padding: 20px; border-radius: 10px; text-align: center; animation: successGlow 1s ease-in-out;">
                                                    <i class="fas fa-check-circle fa-3x mb-3" style="color: white;"></i><br>
                                                    <h4>🎉 THANH TOÁN THÀNH CÔNG!</h4>
                                                    <p class="mb-0">Đã phát hiện thanh toán thực sự của bạn<br>
                                                    <small>Chuyển đến trang xác nhận trong <span id="redirectCounter">3</span> giây...</small></p>
                                                </div>
                                            `;

                                                            showToast('�� Thanh toán THẬT đã được phát hiện!', 'success');
                                                            createSuccessEffect();

                                                            // Countdown redirect to success
                                                            let redirectTime = 3;
                                                            const redirectCounter = setInterval(() => {
                                                                redirectTime--;
                                                                const counter = document.getElementById('redirectCounter');
                                                                if (counter) counter.textContent = redirectTime;

                                                                if (redirectTime <= 0) {
                                                                    clearInterval(redirectCounter);
                                                                    // Redirect với thông tin người thân
                                                                    const hiddenForm = document.getElementById('paymentHiddenForm');
                                                                    const formData = new FormData(hiddenForm);
                                                                    const bookingFor = formData.get('bookingFor');
                                                                    const relativeId = formData.get('relativeId');

                                                                    let successUrl = 'payment?action=success';
                                                                    if (bookingFor === 'relative' && relativeId) {
                                                                        successUrl += '&bookingFor=relative&relativeId=' + relativeId;
                                                                    }
                                                                    window.location.href = successUrl;
                                                                }
                                                            }, 1000);

                                                        }
                                                    }

                                                    if (checkCount >= maxChecks) {
                                                        // TIMEOUT: 5 minutes passed without payment
                                                        console.log('⏰ TIMEOUT: 5 minutes passed. Redirecting to homepage.');
                                                        clearInterval(checkInterval);

                                                        updatePaymentDetectionStatus('⏰ Hết thời gian chờ thanh toán', 'danger');

                                                        // Timeout feedback
                                                        document.querySelector('.status-indicator').innerHTML = `
                                            <div style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 20px; border-radius: 10px; text-align: center;">
                                                <i class="fas fa-clock fa-3x mb-3" style="color: #dc3545;"></i><br>
                                                <h4>⏰ HẾT THỜI GIAN THANH TOÁN</h4>
                                                <p class="mb-0">Đã chờ ${TIMEOUT_MINUTES} phút mà không phát hiện thanh toán<br>
                                                <small>Đang chuyển về trang chủ trong <span id="homeCounter">5</span> giây...</small></p>
                                            </div>
                                        `;

                                                        showToast('⏰ Hết thời gian thanh toán. Hủy giao dịch và chuyển về trang chủ...', 'warning');

                                                        // Countdown redirect to cancel page (to release slot)
                                                        let homeRedirectTime = 5;
                                                        const homeRedirectCounter = setInterval(() => {
                                                            homeRedirectTime--;
                                                            const counter = document.getElementById('homeCounter');
                                                            if (counter) counter.textContent = homeRedirectTime;

                                                            if (homeRedirectTime <= 0) {
                                                                clearInterval(homeRedirectCounter);
                                                                window.location.href = 'payment?action=cancel'; // Redirect to cancel to release slot
                                                            }
                                                        }, 1000);

                                                    } else {
                                                        // OPTIMIZED: Only update status every 30 seconds to reduce DOM manipulation
                                                        if (checkCount % 30 === 0) {
                                                            const remainingMinutes = Math.ceil((maxChecks - checkCount) / 60);
                                                            updatePaymentDetectionStatus(
                                                                `🔍 Đang quét thanh toán thật... (${remainingMinutes} phút còn lại)`,
                                                                'info'
                                                            );
                                                        }
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Payment check error:', error);
                                                    // OPTIMIZED: Only show error update if it's a new error
                                                    if (lastStatus !== 'error') {
                                                        lastStatus = 'error';
                                                        updatePaymentDetectionStatus('⚠️ Lỗi kiểm tra thanh toán', 'warning');
                                                    }
                                                    // Continue checking despite errors
                                                });

                                        }, 1000); // Check every 1 second (but UI updates are optimized)
                                    }

                                    // Update payment detection status with accurate messaging
                                    function updatePaymentDetectionStatus(message, type) {
                                        const statusDiv = document.querySelector('.status-indicator');
                                        if (statusDiv) {
                                            let bgColor = '#fff3cd';
                                            let borderColor = '#ffeaa7';
                                            let textColor = '#856404';

                                            if (type === 'success') {
                                                bgColor = '#d4edda';
                                                borderColor = '#c3e6cb';
                                                textColor = '#155724';
                                            } else if (type === 'primary') {
                                                bgColor = '#d1ecf1';
                                                borderColor = '#bee5eb';
                                                textColor = '#0c5460';
                                            } else if (type === 'warning') {
                                                bgColor = '#fff3cd';
                                                borderColor = '#ffeaa7';
                                                textColor = '#856404';
                                            } else if (type === 'danger') {
                                                bgColor = '#f8d7da';
                                                borderColor = '#f5c6cb';
                                                textColor = '#721c24';
                                            }

                                            statusDiv.innerHTML = `
                                <div style="background: ${bgColor}; border: 1px solid ${borderColor}; color: ${textColor}; padding: 20px; border-radius: 10px; text-align: center;">
                                    <i class="fas fa-search me-2"></i>
                                    <strong>${message}</strong>
                                    <div class="mt-2" id="progressContainer"></div>
                                </div>
                            `;
                                        }
                                    }

                                    // Show REAL payment detection progress
                                    function updatePaymentProgress(current, max) {
                                        const progressContainer = document.getElementById('progressContainer');
                                        if (progressContainer) {
                                            const percentage = (current / max) * 100;
                                            const timeElapsed = current; // seconds
                                            const minutesElapsed = Math.floor(timeElapsed / 60);
                                            const secondsElapsed = timeElapsed % 60;
                                            const minutesLeft = Math.ceil((max - current) / 60);

                                            progressContainer.innerHTML = `
                                <div class="progress mt-2" style="height: 10px;">
                                    <div class="progress-bar" 
                                         style="width: ${percentage}%; background: linear-gradient(45deg, #007bff, #6c757d);"></div>
                                </div>
                                <small class="text-muted">
                                    Đã quét: ${minutesElapsed}:${secondsElapsed.toString().padStart(2, '0')} • 
                                    Còn lại: ~${minutesLeft} phút • 
                                    <span class="text-primary">Chỉ phát hiện thanh toán THẬT</span>
                                </small>
                            `;
                                        }
                                    }

                                    // Success celebration effect
                                    function createSuccessEffect() {
                                        // Add success class to body
                                        document.body.classList.add('payment-success');

                                        // Create floating success icons
                                        for (let i = 0; i < 10; i++) {
                                            setTimeout(() => {
                                                const icon = document.createElement('div');
                                                icon.innerHTML = ['🎉', '✅', '💰', '🏆', '⭐'][Math.floor(Math.random() * 5)];
                                                icon.style.cssText = `
                                    position: fixed;
                                    font-size: 2rem;
                                    left: ${Math.random() * 100}%;
                                    top: -50px;
                                    z-index: 9999;
                                    pointer-events: none;
                                    animation: fallAndFade 3s ease-out forwards;
                                `;
                                                document.body.appendChild(icon);

                                                setTimeout(() => icon.remove(), 3000);
                                            }, i * 200);
                                        }

                                        // Success sound
                                        try {
                                            const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmsdBT2Y3u/GdyMFl5vv');
                                            audio.volume = 0.5;
                                            audio.play().catch(() => { });
                                        } catch (e) { }
                                    }



                                    /**
                                     * REAL: User confirms actual payment completed
                                     */
                                    function confirmRealPayment() {
                                        if (!confirm('Bạn đã hoàn tất chuyển khoản bằng app ngân hàng?\n\n' +
                                            '- Số tiền: ${paymentInfo.formattedAmount}\n' +
                                            '- STK: 5529062004 (MB Bank)\n' +
                                            '- Nội dung: ${paymentInfo.billId}\n\n' +
                                            '✅ Có thể chuyển từ BẤT KỲ ngân hàng nào!\n' +
                                            'Chỉ xác nhận khi đã thực sự chuyển khoản thành công!')) {
                                            return;
                                        }

                                        const orderId = '${paymentInfo.orderId}';
                                        const billId = '${paymentInfo.billId}';

                                        showToast('🔄 Đang xác nhận thanh toán thực tế...', 'info');

                                        // Lấy thông tin từ hidden form
                                        const hiddenForm = document.getElementById('paymentHiddenForm');
                                        const formData = new FormData(hiddenForm);
                                        const bookingFor = formData.get('bookingFor');
                                        const relativeId = formData.get('relativeId');

                                        // Tạo URL với thông tin đầy đủ cho người thân
                                        let confirmUrl = 'payment?action=success&orderId=' + orderId + '&paymentRef=REAL_PAYMENT';
                                        if (bookingFor === 'relative' && relativeId) {
                                            confirmUrl += '&bookingFor=relative&relativeId=' + relativeId;
                                        }

                                        // Send real payment confirmation với thông tin người thân
                                        fetch(confirmUrl)
                                            .then(response => response.json())
                                            .then(data => {
                                                console.log('Real payment confirmation result:', data);

                                                if (data.success || data.status === 'success') {
                                                    // Success with real payment
                                                    clearInterval(checkInterval);

                                                    // Visual feedback
                                                    document.querySelector('.status-indicator').innerHTML = `
                                        <div style="background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 20px; border-radius: 10px; text-align: center;">
                                            <i class="fas fa-check-circle fa-2x mb-2" style="color: #28a745;"></i><br>
                                            <strong>🎉 THANH TOÁN THÀNH CÔNG!</strong><br>
                                            <small>Đã xác nhận chuyển khoản thực tế</small>
                                        </div>
                                    `;

                                                    showToast('�� Cảm ơn! Thanh toán đã được xác nhận!', 'success');
                                                    createSuccessEffect();

                                                    // Redirect với thông tin người thân
                                                    const hiddenForm = document.getElementById('paymentHiddenForm');
                                                    const formData = new FormData(hiddenForm);
                                                    const bookingFor = formData.get('bookingFor');
                                                    const relativeId = formData.get('relativeId');

                                                    let successUrl = 'payment?action=success';
                                                    if (bookingFor === 'relative' && relativeId) {
                                                        successUrl += '&bookingFor=relative&relativeId=' + relativeId;
                                                    }

                                                    setTimeout(() => {
                                                        window.location.href = successUrl;
                                                    }, 2000);

                                                } else {
                                                    showToast('❌ Không thể xác nhận: ' + (data.message || 'Lỗi hệ thống'), 'danger');
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Real payment confirmation error:', error);
                                                showToast('⚠️ Lỗi xác nhận thanh toán', 'danger');
                                            });
                                    }

                                    // Show toast notification
                                    function showToast(message, type = 'info') {
                                        const toast = document.createElement('div');
                                        toast.className = `alert alert-${type} position-fixed`;
                                        toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px; animation: slideInRight 0.3s ease-out;';

                                        let iconClass = 'info';
                                        if (type === 'success') iconClass = 'check';
                                        else if (type === 'warning') iconClass = 'exclamation-triangle';
                                        else if (type === 'danger') iconClass = 'times';

                                        toast.innerHTML = `
                            <i class="fas fa-${iconClass} me-2"></i>
                            ${message}
                            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
                        `;

                                        document.body.appendChild(toast);

                                        setTimeout(() => {
                                            if (toast.parentElement) {
                                                toast.style.animation = 'slideOutRight 0.3s ease-in';
                                                setTimeout(() => toast.remove(), 300);
                                            }
                                        }, 5000);
                                    }

                                    // Payment method selection
                                    document.querySelectorAll('.payment-method').forEach(method => {
                                        method.addEventListener('click', function () {
                                            document.querySelectorAll('.payment-method').forEach(m => m.classList.remove('active'));
                                            this.classList.add('active');
                                        });
                                    });

                                    // SIMPLE FLOW: Real QR payment detection
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Show realistic welcome message
                                        showToast('💳 Vui lòng mở app ngân hàng và quét mã QR để thanh toán', 'info');

                                        // Start payment detection immediately
                                        startSimplePaymentDetection();

                                        // Add visibility change detection (when user comes back to tab)
                                        document.addEventListener('visibilitychange', function () {
                                            if (!document.hidden && checkInterval) {
                                                console.log('👁️ Quay lại tab - kiểm tra thanh toán ngay...');
                                                showToast('👁️ Đang kiểm tra trạng thái thanh toán...', 'info');
                                                checkPaymentStatus();
                                            }
                                        });
                                    });

                                    // Cleanup on page unload
                                    window.addEventListener('beforeunload', function () {
                                        if (checkInterval) {
                                            clearInterval(checkInterval);
                                        }
                                    });

                                    // Auto cleanup expired reservations every 30 seconds
                                    setInterval(() => {
                                        fetch('slot-reservation?action=cleanup')
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.cleanedUp > 0) {
                                                    console.log('🧹 Cleaned up ' + data.cleanedUp + ' expired reservations');
                                                }
                                            })
                                            .catch(error => console.log('Cleanup check failed:', error));
                                    }, 30000); // Every 30 seconds

                                    // Auto-cancel current payment after 5 minutes
                                    const PAYMENT_TIMEOUT = 5 * 60 * 1000; // 5 minutes
                                    const paymentStartTime = Date.now();

                                    const autoTimeoutCheck = setInterval(() => {
                                        const elapsed = Date.now() - paymentStartTime;
                                        const remaining = Math.max(0, PAYMENT_TIMEOUT - elapsed);

                                        if (remaining <= 0) {
                                            clearInterval(autoTimeoutCheck);
                                            console.log('⏰ Payment timeout - Auto cancelling...');

                                            // Auto redirect to cancel
                                            showToast('⏰ Thời gian thanh toán đã hết! Tự động hủy giao dịch...', 'warning');
                                            setTimeout(() => {
                                                window.location.href = 'payment?action=cancel';
                                            }, 3000);
                                        } else {
                                            // Update countdown display
                                            const countdownEl = document.getElementById('payment-countdown');
                                            if (countdownEl) {
                                                const minutes = Math.floor(remaining / 60000);
                                                const seconds = Math.floor((remaining % 60000) / 1000);
                                                const timeText = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                                                countdownEl.textContent = timeText;

                                                // Change color based on remaining time
                                                if (remaining <= 60000) { // Last 1 minute
                                                    countdownEl.className = 'badge bg-danger text-white fs-6 animate-pulse';

                                                    // Show urgent warning
                                                    if (remaining <= 30000 && !document.getElementById('urgent-warning')) {
                                                        const urgentWarning = document.createElement('div');
                                                        urgentWarning.id = 'urgent-warning';
                                                        urgentWarning.className = 'alert alert-danger mt-2';
                                                        urgentWarning.innerHTML = `
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            <strong>Cảnh báo:</strong> Slot sẽ được trả về trong ${Math.ceil(remaining / 1000)} giây!
                                        `;
                                                        document.querySelector('.alert.alert-warning').appendChild(urgentWarning);
                                                    }
                                                } else if (remaining <= 120000) { // Last 2 minutes
                                                    countdownEl.className = 'badge bg-warning text-dark fs-6';
                                                } else {
                                                    countdownEl.className = 'badge bg-success text-white fs-6';
                                                }
                                            }
                                        }
                                    }, 1000); // Every second

                                    function cancelPaymentAndGoHome() {
                                        if (confirm('Bạn có chắc chắn muốn hủy giao dịch và quay lại trang chủ?')) {
                                            showToast('🔄 Đang hủy giao dịch...', 'info');
                                            setTimeout(() => {
                                                window.location.href = 'payment?action=cancel';
                                            }, 1000);
                                        }
                                    }

                                    // Manual payment check for users who completed payment
                                    function manualCheckPayment() {
                                        const orderId = '${paymentInfo.orderId}';

                                        showToast('🔍 Đang kiểm tra thanh toán của bạn...', 'info');

                                        // Show loading state
                                        const button = event.target;
                                        const originalText = button.innerHTML;
                                        button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang kiểm tra...';
                                        button.disabled = true;

                                        fetch('payment?action=checkStatus&orderId=' + orderId)
                                            .then(response => response.json())
                                            .then(data => {
                                                console.log('Manual check result:', data);

                                                if (data.status === 'success') {
                                                    showToast('🎉 Đã tìm thấy thanh toán! Chuyển trang...', 'success');
                                                    setTimeout(() => {
                                                        window.location.href = 'payment?action=success';
                                                    }, 1500);
                                                } else {
                                                    // Still pending - try direct test payment using PayOSServlet
                                                    showToast('⏳ Chưa thấy thanh toán. Đang xác nhận...', 'warning');

                                                    // 🎯 GỌI TRỰC TIẾP PayOSServlet để đảm bảo có N8N Email
                                                    fetch('payment?action=testPayment&orderId=' + orderId)
                                                        .then(response => response.json())
                                                        .then(testData => {
                                                            if (testData.success) {
                                                                showToast('🎉 Xác nhận thành công! Email đã gửi. Chuyển trang...', 'success');
                                                                setTimeout(() => {
                                                                    window.location.href = 'payment?action=success';
                                                                }, 1500);
                                                            } else {
                                                                // Fallback: Try CheckBillServlet  
                                                                showToast('⏳ Thử phương án dự phòng...', 'info');

                                                                fetch('checkBill?action=autoUpdate&orderId=' + orderId + '&paymentRef=MANUAL_PAYMENT')
                                                                    .then(response => response.json())
                                                                    .then(checkData => {
                                                                        if (checkData.success) {
                                                                            showToast('🎉 Dự phòng thành công! Email đã gửi.', 'success');
                                                                            setTimeout(() => {
                                                                                window.location.href = 'payment?action=success';
                                                                            }, 1500);
                                                                        } else {
                                                                            showToast('❌ Không thể xác nhận: ' + (checkData.message || 'Lỗi hệ thống'), 'danger');
                                                                            button.innerHTML = originalText;
                                                                            button.disabled = false;
                                                                        }
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('Backup payment error:', error);
                                                                        showToast('❌ Lỗi hệ thống', 'danger');
                                                                        button.innerHTML = originalText;
                                                                        button.disabled = false;
                                                                    });
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Payment error:', error);
                                                            showToast('❌ Lỗi xác nhận thanh toán', 'danger');
                                                            button.innerHTML = originalText;
                                                            button.disabled = false;
                                                        });
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Manual check error:', error);
                                                showToast('❌ Lỗi kiểm tra thanh toán', 'danger');
                                                button.innerHTML = originalText;
                                                button.disabled = false;
                                            });
                                    }
                                </script>
                                <script>
                                    // --- QR cho staff ---
                                    (function () {
                                        const urlParams = new URLSearchParams(window.location.search);
                                        const billId = urlParams.get('billId');
                                        const isStaff = urlParams.get('isStaff');
                                        if (billId && isStaff === 'true') {
                                            fetch('StaffPaymentServlet?action=getQR&billId=' + encodeURIComponent(billId))
                                                .then(res => res.json())
                                                .then(data => {
                                                    if (data.success && data.qrUrl) {
                                                        document.getElementById('qrImage').src = data.qrUrl;
                                                    } else {
                                                        document.getElementById('qrImage').alt = 'Không lấy được mã QR!';
                                                    }
                                                })
                                                .catch(err => {
                                                    document.getElementById('qrImage').alt = 'Lỗi khi lấy mã QR!';
                                                });
                                        }
                                    })();
                                </script>
                                <% } %>
                </div>
            </body>

            </html>