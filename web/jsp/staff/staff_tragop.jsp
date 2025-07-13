<%@page pageEncoding="UTF-8" %>
    <%@ include file="/jsp/staff/staff_header.jsp" %>
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
            <%@page import="java.util.*, model.*, dao.*" %>
                <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                    <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Quản lý trả góp - Tối ưu</title>
                            <!-- Font Awesome và Bootstrap -->
                            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                                rel="stylesheet">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">

                            <style>
                                :root {
                                    --primary-color: #0d6efd;
                                    --success-color: #198754;
                                    --light-color: #f8f9fa;
                                    --dark-color: #212529;
                                    --warning-color: #ffc107;
                                }

                                body {
                                    background-color: var(--light-color);
                                    font-family: 'Segoe UI', sans-serif;
                                }

                                .main-content {
                                    margin-left: 280px;
                                    padding: 24px;
                                }

                                .page-title {
                                    color: var(--dark-color);
                                }

                                .accordion-button:not(.collapsed) {
                                    background-color: #e7f1ff;
                                    color: var(--dark-color);
                                    box-shadow: none;
                                }

                                .accordion-item {
                                    border-radius: .375rem !important;
                                    margin-bottom: 1rem;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                                    border: 1px solid #dee2e6;
                                }

                                .installment-row {
                                    border-top: 1px solid #e9ecef;
                                    padding: 0.85rem 0.25rem;
                                }

                                .installment-row:first-child {
                                    border-top: none;
                                }

                                .modal-body .form-control-plaintext {
                                    background-color: #e9ecef;
                                    padding: 0.5rem;
                                    border-radius: 5px;
                                }
                            </style>
                        </head>

                        <body>
                            <%@include file="staff_menu.jsp" %>
                                <div class="main-content">
                                    <h1 class="page-title mb-4"><i class="fas fa-list-alt me-2"></i>Quản lý trả góp</h1>

                                    <div class="accordion" id="installmentsAccordion">
                                        <c:if test="${empty installmentBills}">
                                            <div class="alert alert-info">Chưa có kế hoạch trả góp nào.</div>
                                        </c:if>

                                        <c:forEach items="${installmentBills}" var="bill" varStatus="loop">
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="heading${loop.index}">
                                                    <button class="accordion-button collapsed p-3" type="button"
                                                        data-bs-toggle="collapse"
                                                        data-bs-target="#collapse${loop.index}">
                                                        <div
                                                            class="w-100 d-flex justify-content-between align-items-center pe-3 flex-wrap">
                                                            <div class="mb-2 mb-md-0">
                                                                <strong
                                                                    class="text-primary me-3">${bill.billId}</strong>
                                                                <span>${bill.customerName} -
                                                                    ${bill.customerPhone}</span>
                                                            </div>
                                                            <div class="d-flex align-items-center">
                                                                <span class="me-3 text-danger fw-bold">
                                                                    <fmt:formatNumber value="${bill.totalRemaining}"
                                                                        type="currency" currencySymbol="" /> đ còn lại
                                                                </span>
                                                                <span
                                                                    class="badge rounded-pill bg-info text-dark">${bill.installmentSummary.paidInstallments}/${bill.installmentSummary.installmentCount}
                                                                    kỳ</span>
                                                            </div>
                                                        </div>
                                                    </button>
                                                </h2>
                                                <div id="collapse${loop.index}" class="accordion-collapse collapse"
                                                    data-bs-parent="#installmentsAccordion">
                                                    <div class="accordion-body">
                                                        <!-- Installment Details List -->
                                                        <c:forEach items="${bill.installmentDetails}" var="inst">
                                                            <div class="row installment-row align-items-center gx-3">
                                                                <div class="col-md-2"><strong>Kỳ
                                                                        ${inst.installmentNumber}</strong><br><span
                                                                        class="badge bg-light text-dark border">${inst.status}</span>
                                                                </div>
                                                                <div class="col-md-3">Hạn:
                                                                    <fmt:formatDate value="${inst.dueDate}"
                                                                        pattern="dd/MM/yyyy" />
                                                                </div>
                                                                <div class="col-md-4">Phải trả:
                                                                    <fmt:formatNumber value="${inst.amountDue}"
                                                                        type="currency" currencySymbol=""
                                                                        groupingUsed="true" /> đ
                                                                </div>
                                                                <div class="col-md-3 text-end">
                                                                    <c:if test="${inst.status ne 'PAID'}">
                                                                        <button class="btn btn-sm btn-success"
                                                                            onclick="openPayModal('${bill.billId}', ${inst.installmentNumber}, ${inst.amountDue}, ${inst.amountPaid})">
                                                                            <i class="fas fa-hand-holding-dollar"></i>
                                                                            Trả kỳ
                                                                        </button>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Payment Modal -->
                                <div class="modal fade" id="paymentModal" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Thanh toán kỳ trả góp</h5><button type="button"
                                                    class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" id="pay_billId"><input type="hidden"
                                                    id="pay_period">
                                                <p>Hóa đơn: <strong id="pay_billId_display"></strong> - Kỳ: <strong
                                                        id="pay_period_display"></strong></p>
                                                <div class="mb-3"><label class="form-label">Số tiền còn lại của
                                                        kỳ:</label><input type="text" id="pay_remaining_display"
                                                        class="form-control-plaintext" readonly></div>
                                                <div class="mb-3"><label for="pay_amount" class="form-label">Số tiền
                                                        thanh
                                                        toán:</label><input type="number" id="pay_amount"
                                                        class="form-control">
                                                </div>
                                                <div class="mb-3"><label for="pay_method" class="form-label">Phương
                                                        thức:</label><select id="pay_method" class="form-select">
                                                        <option value="CASH">Tiền mặt</option>
                                                        <option value="BANK_TRANSFER">Chuyển khoản</option>
                                                    </select></div>
                                                <div class="mb-3"><label for="pay_notes" class="form-label">Ghi
                                                        chú:</label><textarea id="pay_notes" class="form-control"
                                                        rows="2"></textarea></div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-primary" id="confirmPaymentBtn"
                                                    onclick="submitPayment()">Xác nhận</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    const paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));
                                    const f = (num) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num);

                                    function openPayModal(billId, period, amountDue, amountPaid) {
                                        const remaining = amountDue - amountPaid;
                                        document.getElementById('pay_billId').value = billId;
                                        document.getElementById('pay_period').value = period;
                                        document.getElementById('pay_billId_display').innerText = billId;
                                        document.getElementById('pay_period_display').innerText = period;
                                        document.getElementById('pay_remaining_display').value = f(remaining);
                                        document.getElementById('pay_amount').value = remaining;
                                        paymentModal.show();
                                    }

                                    function submitPayment() {
                                        const btn = document.getElementById('confirmPaymentBtn');
                                        const originalHtml = btn.innerHTML;
                                        btn.disabled = true;
                                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                                        fetch('/TestFull/StaffPaymentServlet?action=payInstallment', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                            body: new URLSearchParams({
                                                billId: document.getElementById('pay_billId').value,
                                                period: document.getElementById('pay_period').value,
                                                amount: document.getElementById('pay_amount').value,
                                                paymentMethod: document.getElementById('pay_method').value,
                                                notes: document.getElementById('pay_notes').value
                                            })
                                        }).then(res => res.json()).then(data => {
                                            if (data.success) {
                                                // Đóng modal và show toast
                                                var modal = bootstrap.Modal.getInstance(document.getElementById('paymentModal'));
                                                if (modal) modal.hide();
                                                showToast('Thanh toán thành công!', 'success');
                                                // Reload lại phần danh sách hóa đơn trả góp bằng AJAX
                                                reloadInstallmentList();
                                                // KHÔNG reload toàn trang nữa
                                                // setTimeout(() => window.location.reload(), 1000);
                                            } else {
                                                alert('Lỗi: ' + (data.message || 'Thanh toán thất bại.'));
                                                btn.disabled = false;
                                                btn.innerHTML = originalHtml;
                                            }
                                        }).catch(err => {
                                            alert('Lỗi kết nối. Vui lòng thử lại.');
                                            console.error('Fetch Error:', err);
                                            btn.disabled = false;
                                            btn.innerHTML = originalHtml;
                                        });
                                    }
                                </script>
                                <script>
                                    function showToast(message, type) {
                                        let toast = document.createElement('div');
                                        toast.className = 'custom-toast ' + (type === 'success' ? 'toast-success' : 'toast-error');
                                        toast.innerText = message;
                                        toast.style.position = 'fixed';
                                        toast.style.top = '24px';
                                        toast.style.right = '24px';
                                        toast.style.zIndex = 9999;
                                        toast.style.background = type === 'success' ? '#4caf50' : '#f44336';
                                        toast.style.color = 'white';
                                        toast.style.padding = '12px 24px';
                                        toast.style.borderRadius = '8px';
                                        toast.style.boxShadow = '0 2px 8px rgba(0,0,0,0.15)';
                                        document.body.appendChild(toast);
                                        setTimeout(() => { toast.remove(); }, 2000);
                                    }
                                </script>
                                <script>
                                    function reloadInstallmentList() {
                                        fetch(window.location.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                                            .then(res => res.text())
                                            .then(html => {
                                                // Tạo DOM ảo để lấy lại phần accordion
                                                const parser = new DOMParser();
                                                const doc = parser.parseFromString(html, 'text/html');
                                                const newAccordion = doc.querySelector('#installmentsAccordion');
                                                if (newAccordion) {
                                                    document.querySelector('#installmentsAccordion').innerHTML = newAccordion.innerHTML;
                                                }
                                            })
                                            .catch(err => {
                                                console.error('❌ Lỗi reload danh sách trả góp:', err);
                                                showToast('Lỗi reload danh sách trả góp!', 'error');
                                            });
                                    }
                                </script>
                        </body>

                        </html>