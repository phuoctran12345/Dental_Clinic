<%@page pageEncoding="UTF-8" %>
    <%@ include file="/jsp/staff/staff_header.jsp" %>
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
            <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Quản lý thanh toán - Dental Clinic</title>

                        <!-- Tailwind CSS -->
                        <script src="https://cdn.tailwindcss.com"></script>
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                        <script>
                            tailwind.config = {
                                theme: {
                                    extend: {
                                        colors: {
                                            blue: {
                                                25: '#f8fafc',
                                                50: '#eff6ff',
                                                100: '#dbeafe',
                                                600: '#2563eb',
                                                700: '#1d4ed8',
                                                900: '#1e3a8a'
                                            }
                                        }
                                    }
                                }
                            }
                        </script>

                        <style>
                            body {
                                background: linear-gradient(135deg, rgba(239, 246, 255, 0.3) 0%, rgba(224, 242, 254, 0.3) 100%);
                                min-height: 100vh;
                            }

                            .card-hover {
                                transition: all 0.2s ease-in-out;
                            }

                            .card-hover:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                            }

                            .payment-item-hover:hover {
                                background-color: rgba(239, 246, 255, 0.5);
                            }
                        </style>
                    </head>

                    <body>
                        <div class="p-6 space-y-6 min-h-screen">
                            <!-- Header -->
                            <div class="flex items-center justify-between">
                                <div>
                                    <h1 class="text-2xl font-bold text-blue-900">Quản lý thanh toán</h1>
                                    <p class="text-blue-600">Theo dõi hóa đơn và thanh toán</p>
                                </div>
                                <button onclick="openCreateModal()" class="bg-gradient-to-r from-blue-600 to-cyan-600 hover:from-blue-700 hover:to-cyan-700 
                                           text-white px-4 py-2 rounded-lg flex items-center space-x-2 transition-all">
                                    <i class="fas fa-plus"></i>
                                    <span>Tạo hóa đơn</span>
                                </button>
                            </div>

                            <!-- Stats Cards -->
                            <div class="grid gap-4 md:grid-cols-4">
                                <!-- Total Revenue -->
                                <div class="card-hover bg-white rounded-lg border border-blue-100 shadow-sm">
                                    <div class="p-4">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-blue-600">Tổng doanh thu</p>
                                                <p class="text-2xl font-bold text-blue-900">
                                                    <fmt:formatNumber value="${totalRevenue / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </p>
                                            </div>
                                            <div class="h-8 w-8 text-blue-500">
                                                <i class="fas fa-dollar-sign text-2xl"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Paid Amount -->
                                <div class="card-hover bg-white rounded-lg border border-green-100 shadow-sm">
                                    <div class="p-4">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-green-600">Đã thu</p>
                                                <p class="text-2xl font-bold text-green-900">
                                                    <fmt:formatNumber value="${paidAmount / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </p>
                                            </div>
                                            <div class="h-8 w-8 text-green-500">
                                                <i class="fas fa-check-circle text-2xl"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pending Amount -->
                                <div class="card-hover bg-white rounded-lg border border-red-100 shadow-sm">
                                    <div class="p-4">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-red-600">Chờ thu</p>
                                                <p class="text-2xl font-bold text-red-900">
                                                    <fmt:formatNumber value="${pendingAmount / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </p>
                                            </div>
                                            <div class="h-8 w-8 text-red-500">
                                                <i class="fas fa-clock text-2xl"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Partial Amount -->
                                <div class="card-hover bg-white rounded-lg border border-orange-100 shadow-sm">
                                    <div class="p-4">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-orange-600">Nợ một phần</p>
                                                <p class="text-2xl font-bold text-orange-900">
                                                    <fmt:formatNumber value="${partialAmount / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </p>
                                            </div>
                                            <div class="h-8 w-8 text-orange-500">
                                                <i class="fas fa-exclamation-triangle text-2xl"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Filters -->
                            <div class="bg-white rounded-lg border border-blue-100 shadow-sm">
                                <div class="p-4">
                                    <div class="flex flex-col md:flex-row gap-4">
                                        <div class="flex-1">
                                            <div class="relative">
                                                <div class="absolute left-3 top-1/2 transform -translate-y-1/2">
                                                    <i class="fas fa-search h-4 w-4 text-blue-400"></i>
                                                </div>
                                                <input type="text"
                                                    class="w-full pl-10 pr-4 py-2 border border-blue-200 rounded-lg focus:border-blue-400 focus:outline-none focus:ring-2 focus:ring-blue-100"
                                                    placeholder="Tìm theo tên, số hóa đơn hoặc SĐT..." id="searchInput"
                                                    onkeyup="filterPayments()">
                                            </div>
                                        </div>
                                        <div class="w-full md:w-48">
                                            <select
                                                class="w-full px-3 py-2 border border-blue-200 rounded-lg focus:border-blue-400 focus:outline-none focus:ring-2 focus:ring-blue-100"
                                                id="statusFilter" onchange="filterPayments()">
                                                <option value="all">Tất cả trạng thái</option>
                                                <option value="paid">Đã thanh toán</option>
                                                <option value="partial">Thanh toán một phần</option>
                                                <option value="pending">Chờ thanh toán</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Bills List -->
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0 text-primary">Danh sách hóa đơn</h5>
                                    <span class="text-muted">Hiển thị <span id="displayCount">${totalBills}</span> hóa
                                        đơn</span>
                                </div>

                                <div class="card-body p-0">
                                    <div id="paymentList">
                                        <c:choose>
                                            <c:when test="${not empty bills}">
                                                <c:forEach var="bill" items="${bills}" varStatus="status">
                                                    <div class="payment-item p-3 border-bottom"
                                                        data-search="${bill.patientName} ${bill.billId} ${bill.patientPhone}"
                                                        data-status="${bill.paymentStatus}">

                                                        <div class="row align-items-center">
                                                            <!-- Invoice Info -->
                                                            <div class="col-md-2 text-center">
                                                                <div
                                                                    class="bg-primary text-white rounded p-2 mb-2 d-inline-block">
                                                                    <i class="fas fa-receipt"></i>
                                                                </div>
                                                                <div><small class="fw-bold">HD${bill.billId}</small>
                                                                </div>
                                                                <div><small class="text-muted">
                                                                        <fmt:formatDate value="${bill.billDate}"
                                                                            pattern="dd/MM/yyyy" />
                                                                    </small></div>
                                                            </div>

                                                            <!-- Patient Info -->
                                                            <div class="col-md-4">
                                                                <h6 class="mb-2 d-flex align-items-center gap-2">
                                                                    ${bill.patientName}
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${bill.paymentStatus == 'PAID' || bill.paymentStatus == 'success' || bill.paymentStatus == 'Đã thanh toán'}">
                                                                            <span class="badge bg-success">
                                                                                <i
                                                                                    class="fas fa-check-circle me-1"></i>Đã
                                                                                thanh toán
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${bill.paymentStatus == 'PARTIAL' || bill.paymentStatus == 'partial'}">
                                                                            <span class="badge bg-warning">
                                                                                <i class="fas fa-clock me-1"></i>Thanh
                                                                                toán một phần
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-danger">
                                                                                <i
                                                                                    class="fas fa-exclamation-triangle me-1"></i>Chờ
                                                                                thanh toán
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </h6>

                                                                <div class="text-muted small">
                                                                    <div>${bill.serviceName != null ? bill.serviceName :
                                                                        'Dịch vụ nha khoa'}</div>
                                                                    <div class="mt-1">
                                                                        <i class="fas fa-user-md me-1"></i>BS. Nguyễn
                                                                        Văn A
                                                                        <span class="ms-2"><i
                                                                                class="fas fa-phone me-1"></i>${bill.patientPhone}</span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Payment Amounts -->
                                                            <div class="col-md-3 text-center">
                                                                <div class="mb-1">
                                                                    <small class="text-muted">Tổng:</small>
                                                                    <div class="fw-bold text-primary">
                                                                        <fmt:formatNumber value="${bill.totalAmount}"
                                                                            type="number" /> VNĐ
                                                                    </div>
                                                                </div>
                                                                <div class="d-flex justify-content-between">
                                                                    <div>
                                                                        <small class="text-muted">Đã thu:</small>
                                                                        <div class="fw-bold text-success">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${bill.status == 'PAID' || bill.status == 'Đã thanh toán'}">
                                                                                    <fmt:formatNumber
                                                                                        value="${bill.totalAmount}"
                                                                                        type="number" />
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${bill.status == 'PARTIAL'}">
                                                                                    <fmt:formatNumber
                                                                                        value="${bill.totalAmount * 0.5}"
                                                                                        type="number" />
                                                                                </c:when>
                                                                                <c:otherwise>0</c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                    <c:if
                                                                        test="${bill.status != 'PAID' && bill.status != 'Đã thanh toán'}">
                                                                        <div>
                                                                            <small class="text-muted">Còn nợ:</small>
                                                                            <div class="fw-bold text-danger">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${bill.status == 'PARTIAL'}">
                                                                                        <fmt:formatNumber
                                                                                            value="${bill.totalAmount * 0.5}"
                                                                                            type="number" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <fmt:formatNumber
                                                                                            value="${bill.totalAmount}"
                                                                                            type="number" />
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </div>

                                                            <!-- Actions -->
                                                            <div class="col-md-3 text-end">
                                                                <div class="btn-group" role="group">
                                                                    <button class="btn btn-outline-primary btn-sm"
                                                                        onclick="viewInvoice(${bill.billId})">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                    <button class="btn btn-outline-secondary btn-sm"
                                                                        onclick="printInvoice(${bill.billId})">
                                                                        <i class="fas fa-print"></i>
                                                                    </button>
                                                                    <button class="btn btn-outline-secondary btn-sm"
                                                                        onclick="downloadInvoice(${bill.billId})">
                                                                        <i class="fas fa-download"></i>
                                                                    </button>
                                                                </div>

                                                                <div class="mt-2">
                                                                    <c:if
                                                                        test="${bill.status == 'PENDING' || bill.status == 'Chờ thanh toán'}">
                                                                        <button class="btn btn-success btn-sm me-1"
                                                                            onclick="processPayment(${bill.billId}, 'full')">
                                                                            <i class="fas fa-credit-card me-1"></i>Thu
                                                                            tiền
                                                                        </button>
                                                                        <button class="btn btn-warning btn-sm"
                                                                            onclick="createInstallment('${bill.billId}', ${bill.totalAmount})">
                                                                            <i class="fas fa-calendar-alt me-1"></i>Trả
                                                                            góp
                                                                        </button>
                                                                    </c:if>

                                                                    <c:if test="${bill.status == 'PARTIAL'}">
                                                                        <button class="btn btn-warning btn-sm"
                                                                            onclick="processPayment(${bill.billId}, 'remaining')">
                                                                            <i class="fas fa-credit-card me-1"></i>Thu
                                                                            nợ
                                                                        </button>
                                                                    </c:if>

                                                                    <c:if test="${bill.status == 'INSTALLMENT'}">
                                                                        <button class="btn btn-info btn-sm"
                                                                            onclick="viewInstallmentDetail('${bill.billId}')">
                                                                            <i class="fas fa-list-alt me-1"></i>Chi tiết
                                                                        </button>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-5">
                                                    <i class="fas fa-receipt fs-1 text-muted mb-3"></i>
                                                    <h5 class="text-muted">Chưa có hóa đơn</h5>
                                                    <p class="text-muted">Hiện tại không có hóa đơn nào trong hệ thống.
                                                    </p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Pagination -->
                                <div class="card-footer bg-light" id="billsPaginationContainer" style="display: none;">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="text-muted small">
                                            Trang <span id="billsCurrentPage">1</span> / <span
                                                id="billsTotalPages">1</span>
                                            <span class="ms-3">
                                                Hiển thị <span id="billsRangeStart">1</span>-<span
                                                    id="billsRangeEnd">5</span>
                                                trong tổng số <span id="billsTotalItems">${totalBills}</span> hóa đơn
                                            </span>
                                        </div>
                                        <nav>
                                            <ul class="pagination pagination-sm mb-0" id="billsPagination">
                                                <li class="page-item" id="billsPrevBtn">
                                                    <button class="page-link" onclick="changeBillsPage(-1)">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </button>
                                                </li>
                                                <!-- Page numbers will be inserted here -->
                                                <li class="page-item" id="billsNextBtn">
                                                    <button class="page-link" onclick="changeBillsPage(1)">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </button>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Create Invoice Modal -->
                        <div class="fixed inset-0 bg-black bg-opacity-50 hidden z-50" id="createInvoiceModal">
                            <div class="flex items-center justify-center min-h-screen p-4">
                                <div
                                    class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
                                    <div class="p-6 border-b border-blue-100">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <h2 class="text-xl font-bold text-blue-900">Tạo hóa đơn mới</h2>
                                                <p class="text-blue-600 text-sm">Tạo hóa đơn thanh toán cho bệnh nhân
                                                </p>
                                            </div>
                                            <button type="button" onclick="closeCreateModal()"
                                                class="text-gray-400 hover:text-gray-600 text-2xl">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <form id="createInvoiceForm" action="StaffPaymentServlet" method="post">
                                        <input type="hidden" name="action" value="createBill">

                                        <div class="modal-body">
                                            <!-- Customer Information -->
                                            <div class="mb-4">
                                                <h6 class="text-primary mb-3">
                                                    <i class="fas fa-user me-2"></i>Thông tin bệnh nhân
                                                </h6>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label">Tên bệnh nhân</label>
                                                            <input type="text" class="form-control" name="customerName"
                                                                required>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label">Số điện thoại</label>
                                                            <input type="tel" class="form-control" name="customerPhone"
                                                                required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Services -->
                                            <div class="mb-4">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <h6 class="text-primary mb-0">
                                                        <i class="fas fa-teeth me-2"></i>Dịch vụ đã thực hiện
                                                    </h6>
                                                    <span class="badge bg-light text-dark" id="serviceCount">
                                                        Hiển thị <span id="currentCount">1</span> dịch vụ
                                                    </span>
                                                </div>

                                                <div class="border rounded"
                                                    style="max-height: 200px; overflow-y: auto;">
                                                    <!-- Sample Services for Demo -->
                                                    <div class="service-item p-3 border-bottom d-flex align-items-center gap-3"
                                                        style="background-color: #f8f9fa;">
                                                        <input type="checkbox" class="form-check-input"
                                                            name="selectedServices" value="1" data-price="3000000"
                                                            checked onchange="calculateTotal()">
                                                        <div class="flex-grow-1">
                                                            <div class="service-name fw-bold">Bọc răng sứ</div>
                                                            <div class="service-description text-muted small">Bọc răng
                                                                sứ thẩm mỹ, phục hồi răng hư tổn</div>
                                                        </div>
                                                        <div class="text-end">
                                                            <div class="service-price fw-bold text-primary">3.000.000
                                                                VNĐ</div>
                                                            <span class="badge bg-secondary small">Thẩm mỹ</span>
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="service-item p-3 border-bottom d-flex align-items-center gap-3">
                                                        <input type="checkbox" class="form-check-input"
                                                            name="selectedServices" value="2" data-price="300000"
                                                            onchange="calculateTotal()">
                                                        <div class="flex-grow-1">
                                                            <div class="service-name fw-bold">Vệ sinh răng miệng</div>
                                                            <div class="service-description text-muted small">Làm sạch
                                                                mảng bám, vôi răng, đánh bóng răng</div>
                                                        </div>
                                                        <div class="text-end">
                                                            <div class="service-price fw-bold text-primary">300.000 VNĐ
                                                            </div>
                                                            <span class="badge bg-secondary small">Vệ sinh răng</span>
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="service-item p-3 border-bottom d-flex align-items-center gap-3">
                                                        <input type="checkbox" class="form-check-input"
                                                            name="selectedServices" value="3" data-price="1000000"
                                                            onchange="calculateTotal()">
                                                        <div class="flex-grow-1">
                                                            <div class="service-name fw-bold">Điều trị tủy răng</div>
                                                            <div class="service-description text-muted small">Điều trị
                                                                viêm tủy, chữa tủy răng</div>
                                                        </div>
                                                        <div class="text-end">
                                                            <div class="service-price fw-bold text-primary">1.000.000
                                                                VNĐ</div>
                                                            <span class="badge bg-secondary small">Điều trị</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="bg-light p-3 rounded mt-3">
                                                    <div class="row">
                                                        <div class="col-6">
                                                            <strong>Tổng cộng: <span id="totalAmount"
                                                                    class="text-primary">3.000.000 VNĐ</span></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Payment Information -->
                                            <div class="mb-4">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label">Phương thức thanh toán</label>
                                                            <select class="form-select" name="paymentMethod"
                                                                onchange="handlePaymentMethodChange()">
                                                                <option value="">Chọn phương thức</option>
                                                                <option value="cash">Tiền mặt</option>
                                                                <option value="bank_transfer">Chuyển khoản</option>
                                                                <option value="card">Thẻ tín dụng</option>
                                                                <option value="installment">Trả góp</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label">Số tiền thanh toán</label>
                                                            <input type="number" class="form-control"
                                                                name="paymentAmount" id="paymentAmount" value="3000000"
                                                                onchange="validatePaymentAmount()">
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Installment Options (Hidden by default) -->
                                                <div id="installmentOptions" style="display: none;">
                                                    <div class="border rounded p-3 mb-3"
                                                        style="background-color: #fff3cd;">
                                                        <h6 class="text-warning mb-3">
                                                            <i class="fas fa-calendar-alt me-2"></i>Thiết lập trả góp
                                                        </h6>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Số tiền đặt cọc (tối thiểu
                                                                        30%)</label>
                                                                    <input type="number" class="form-control"
                                                                        name="downPayment" id="downPayment" min="900000"
                                                                        onchange="calculateInstallment()">
                                                                    <small class="text-muted">Tối thiểu: <span
                                                                            id="minDownPayment">900.000</span>
                                                                        VNĐ</small>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Số kỳ trả góp</label>
                                                                    <select class="form-select" name="installmentMonths"
                                                                        onchange="calculateInstallment()">
                                                                        <option value="3">3 tháng</option>
                                                                        <option value="6">6 tháng</option>
                                                                        <option value="9">9 tháng</option>
                                                                        <option value="12">12 tháng</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="alert alert-info mb-0">
                                                            <small>
                                                                <strong>Kế hoạch trả góp:</strong><br>
                                                                • Đặt cọc: <span id="displayDownPayment">0</span>
                                                                VNĐ<br>
                                                                • Còn lại: <span id="remainingAmount">0</span> VNĐ<br>
                                                                • Mỗi kỳ: <span id="monthlyPayment">0</span> VNĐ
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Notes -->
                                            <div class="mb-3">
                                                <label class="form-label">Ghi chú</label>
                                                <textarea class="form-control" name="notes" rows="3"
                                                    placeholder="Ghi chú về thanh toán..."></textarea>
                                            </div>
                                        </div>

                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="button" class="btn btn-primary"
                                                onclick="submitCreateInvoice()">
                                                <i class="fas fa-plus me-2"></i>Tạo hóa đơn
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script>
                            // Variables
                            let billsCurrentPage = 1, billsTotalPages = 1, billsItemsPerPage = 5;
                            let billsTotalItems = ${ totalBills };

                            // Initialize
                            document.addEventListener('DOMContentLoaded', function () {
                                console.log('🚀 Page loaded, total bills:', billsTotalItems);
                                setTimeout(() => initBillsPagination(), 100);
                            });

                            // Filter payments
                            function filterPayments() {
                                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                                const statusFilter = document.getElementById('statusFilter').value;
                                const paymentItems = document.querySelectorAll('.payment-item');
                                let visibleCount = 0;

                                paymentItems.forEach(item => {
                                    const searchData = item.dataset.search.toLowerCase();
                                    const status = item.dataset.status;

                                    const matchesSearch = searchData.includes(searchTerm);
                                    const matchesStatus = statusFilter === 'all' ||
                                        (statusFilter === 'paid' && (status === 'PAID' || status === 'Đã thanh toán')) ||
                                        (statusFilter === 'partial' && status === 'PARTIAL') ||
                                        (statusFilter === 'pending' && (status === 'PENDING' || status === 'Chờ thanh toán'));

                                    item.style.display = (matchesSearch && matchesStatus) ? 'block' : 'none';
                                    if (matchesSearch && matchesStatus) visibleCount++;
                                });

                                document.getElementById('displayCount').textContent = visibleCount;
                            }

                            // Payment actions
                            function viewInvoice(billId) { alert('Xem chi tiết hóa đơn ID: ' + billId); }
                            function printInvoice(billId) { alert('In hóa đơn ID: ' + billId); }
                            function downloadInvoice(billId) { alert('Tải xuống hóa đơn ID: ' + billId); }

                            function processPayment(billId, type) {
                                const message = type === 'full' ? 'Thu tiền đầy đủ cho hóa đơn ID: ' + billId :
                                    'Thu tiền còn nợ cho hóa đơn ID: ' + billId;
                                alert(message);
                            }

                            function createInstallment(billId, totalAmount) {
                                const downPayment = prompt('Nhập số tiền đặt cọc (tối thiểu 30%):');
                                if (!downPayment) return;

                                const downPaymentAmount = parseFloat(downPayment);
                                const minDownPayment = totalAmount * 0.3;

                                if (downPaymentAmount < minDownPayment) {
                                    alert('Tiền đặt cọc phải tối thiểu 30% = ' + minDownPayment.toLocaleString() + ' VNĐ');
                                    return;
                                }

                                const installmentCount = prompt('Số kỳ trả góp (3-12 tháng):');
                                if (!installmentCount) return;

                                const count = parseInt(installmentCount);
                                if (count < 3 || count > 12) {
                                    alert('Số kỳ trả góp phải từ 3-12 tháng');
                                    return;
                                }

                                alert('Tạo kế hoạch trả góp cho hóa đơn ' + billId +
                                    '\nĐặt cọc: ' + downPaymentAmount.toLocaleString() + ' VNĐ' +
                                    '\nSố kỳ: ' + count + ' tháng');
                            }

                            function viewInstallmentDetail(billId) {
                                alert('Xem chi tiết trả góp cho hóa đơn ID: ' + billId);
                            }

                            // Bills pagination
                            function initBillsPagination() {
                                const billItems = document.querySelectorAll('.payment-item');
                                billsTotalItems = billItems.length;
                                billsTotalPages = Math.ceil(billsTotalItems / billsItemsPerPage);

                                console.log('📋 Bills pagination:', billsTotalItems, 'items,', billsTotalPages, 'pages');

                                if (billsTotalItems > 0) {
                                    document.getElementById('billsPaginationContainer').style.display = 'flex';
                                    generateBillsPageNumbers();
                                    showBillsPage(1);
                                } else {
                                    document.getElementById('billsPaginationContainer').style.display = 'none';
                                }
                                updateBillsCount();
                            }

                            function showBillsPage(page) {
                                const billItems = document.querySelectorAll('.payment-item');
                                const startIndex = (page - 1) * billsItemsPerPage;
                                const endIndex = startIndex + billsItemsPerPage;

                                billItems.forEach((item, index) => {
                                    item.style.display = (index >= startIndex && index < endIndex) ? 'block' : 'none';
                                });

                                billsCurrentPage = page;
                                document.getElementById('billsCurrentPage').textContent = page;
                                document.getElementById('billsTotalPages').textContent = billsTotalPages;

                                document.getElementById('billsPrevBtn').classList.toggle('disabled', page === 1);
                                document.getElementById('billsNextBtn').classList.toggle('disabled', page === billsTotalPages);

                                // Regenerate page numbers to update visible range
                                generateBillsPageNumbers();

                                // Update page number active state
                                const pageButtons = document.querySelectorAll('.page-number-item');
                                pageButtons.forEach(item => {
                                    const pageNumber = parseInt(item.querySelector('.page-link').textContent);
                                    if (pageNumber === page) {
                                        item.classList.add('active');
                                    } else {
                                        item.classList.remove('active');
                                    }
                                });

                                updateBillsCount();
                            }

                            function changeBillsPage(direction) {
                                const newPage = billsCurrentPage + direction;
                                if (newPage >= 1 && newPage <= billsTotalPages) showBillsPage(newPage);
                            }

                            function goToBillsPage(page) {
                                if (page >= 1 && page <= billsTotalPages) showBillsPage(page);
                            }

                            function generateBillsPageNumbers() {
                                // Remove existing page numbers
                                const existingPageNumbers = document.querySelectorAll('.page-number-item');
                                existingPageNumbers.forEach(item => item.remove());

                                const pagination = document.getElementById('billsPagination');
                                const nextBtn = document.getElementById('billsNextBtn');

                                // Chỉ hiển thị tối đa 5 page numbers cho gọn
                                const maxVisiblePages = 5;
                                let startPage = Math.max(1, billsCurrentPage - 2);
                                let endPage = Math.min(billsTotalPages, startPage + maxVisiblePages - 1);

                                if (endPage - startPage + 1 < maxVisiblePages) {
                                    startPage = Math.max(1, endPage - maxVisiblePages + 1);
                                }

                                for (let i = startPage; i <= endPage; i++) {
                                    const pageItem = document.createElement('li');
                                    pageItem.className = 'page-item page-number-item';

                                    const pageBtn = document.createElement('button');
                                    pageBtn.className = 'page-link';
                                    pageBtn.textContent = i;
                                    pageBtn.onclick = () => goToBillsPage(i);

                                    pageItem.appendChild(pageBtn);
                                    pagination.insertBefore(pageItem, nextBtn);
                                }
                            }

                            function updateBillsCount() {
                                const currentStart = (billsCurrentPage - 1) * billsItemsPerPage + 1;
                                const currentEnd = Math.min(billsCurrentPage * billsItemsPerPage, billsTotalItems);

                                document.getElementById('billsRangeStart').textContent = currentStart;
                                document.getElementById('billsRangeEnd').textContent = currentEnd;
                                document.getElementById('displayCount').textContent = currentStart + '-' + currentEnd + ' / ' + billsTotalItems;
                            }

                            // Variables for invoice
                            let totalInvoiceAmount = 3000000;

                            // Calculate total amount
                            function calculateTotal() {
                                const checkboxes = document.querySelectorAll('input[name="selectedServices"]:checked');
                                let total = 0;
                                checkboxes.forEach(checkbox => total += parseFloat(checkbox.dataset.price || 0));

                                totalInvoiceAmount = total;
                                document.getElementById('totalAmount').textContent = total.toLocaleString() + ' VNĐ';
                                document.getElementById('currentCount').textContent = checkboxes.length;

                                // Update payment amount
                                document.getElementById('paymentAmount').value = total;

                                // Update minimum down payment (30%)
                                const minDown = Math.ceil(total * 0.3);
                                document.getElementById('minDownPayment').textContent = minDown.toLocaleString();
                                document.getElementById('downPayment').min = minDown;

                                return total;
                            }

                            // Handle payment method change
                            function handlePaymentMethodChange() {
                                const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;
                                const installmentOptions = document.getElementById('installmentOptions');
                                const paymentAmount = document.getElementById('paymentAmount');

                                if (paymentMethod === 'installment') {
                                    installmentOptions.style.display = 'block';
                                    paymentAmount.readOnly = true;
                                    paymentAmount.value = totalInvoiceAmount;
                                    calculateInstallment();
                                } else {
                                    installmentOptions.style.display = 'none';
                                    paymentAmount.readOnly = false;
                                    paymentAmount.value = totalInvoiceAmount;
                                }
                            }

                            // Validate payment amount
                            function validatePaymentAmount() {
                                const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
                                const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;

                                if (paymentMethod !== 'installment' && paymentAmount > totalInvoiceAmount) {
                                    alert('Số tiền thanh toán không được vượt quá tổng hóa đơn!');
                                    document.getElementById('paymentAmount').value = totalInvoiceAmount;
                                }
                            }

                            // Calculate installment plan
                            function calculateInstallment() {
                                const downPayment = parseFloat(document.getElementById('downPayment').value) || 0;
                                const installmentMonths = parseInt(document.querySelector('select[name="installmentMonths"]').value) || 3;
                                const minDown = Math.ceil(totalInvoiceAmount * 0.3);

                                if (downPayment < minDown) {
                                    document.getElementById('displayDownPayment').textContent = '0';
                                    document.getElementById('remainingAmount').textContent = '0';
                                    document.getElementById('monthlyPayment').textContent = '0';
                                    return;
                                }

                                const remaining = totalInvoiceAmount - downPayment;
                                const monthlyPayment = Math.ceil(remaining / installmentMonths);

                                document.getElementById('displayDownPayment').textContent = downPayment.toLocaleString();
                                document.getElementById('remainingAmount').textContent = remaining.toLocaleString();
                                document.getElementById('monthlyPayment').textContent = monthlyPayment.toLocaleString();
                            }

                            // Submit form
                            function submitCreateInvoice() {
                                const customerName = document.querySelector('input[name="customerName"]').value;
                                const customerPhone = document.querySelector('input[name="customerPhone"]').value;
                                const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;
                                const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);

                                // Validation
                                if (!customerName || !customerPhone) {
                                    alert('Vui lòng nhập đầy đủ thông tin bệnh nhân!');
                                    return;
                                }

                                const selectedServices = document.querySelectorAll('input[name="selectedServices"]:checked');
                                if (selectedServices.length === 0) {
                                    alert('Vui lòng chọn ít nhất một dịch vụ!');
                                    return;
                                }

                                if (!paymentMethod) {
                                    alert('Vui lòng chọn phương thức thanh toán!');
                                    return;
                                }

                                // Installment validation
                                if (paymentMethod === 'installment') {
                                    const downPayment = parseFloat(document.getElementById('downPayment').value) || 0;
                                    const minDown = Math.ceil(totalInvoiceAmount * 0.3);

                                    if (downPayment < minDown) {
                                        alert('Số tiền đặt cọc phải tối thiểu 30% = ' + minDown.toLocaleString() + ' VNĐ');
                                        return;
                                    }
                                }

                                // Create form data for submission
                                const formData = new FormData();
                                formData.append('action', 'createBill');
                                formData.append('customerName', customerName);
                                formData.append('customerPhone', customerPhone);
                                formData.append('paymentMethod', paymentMethod);
                                formData.append('totalAmount', totalInvoiceAmount);
                                formData.append('paymentAmount', paymentAmount);
                                formData.append('notes', document.querySelector('textarea[name="notes"]').value);

                                // Add selected services
                                selectedServices.forEach((service, index) => {
                                    formData.append('selectedServices[' + index + ']', service.value);
                                });

                                // Add installment data if applicable
                                if (paymentMethod === 'installment') {
                                    formData.append('downPayment', document.getElementById('downPayment').value);
                                    formData.append('installmentMonths', document.querySelector('select[name="installmentMonths"]').value);
                                }

                                // Submit via AJAX
                                fetch('StaffPaymentServlet', {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            alert('Tạo hóa đơn thành công!\nMã hóa đơn: ' + data.billId);

                                            // Close modal
                                            const modal = bootstrap.Modal.getInstance(document.getElementById('createInvoiceModal'));
                                            if (modal) modal.hide();

                                            // Reload page to show new bill
                                            setTimeout(() => {
                                                window.location.reload();
                                            }, 1000);
                                        } else {
                                            alert('Lỗi tạo hóa đơn: ' + data.message);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('Có lỗi xảy ra khi tạo hóa đơn!');
                                    });
                            }

                            // Modal functions
                            function openCreateModal() {
                                document.getElementById('createInvoiceModal').classList.remove('hidden');
                                calculateTotal();
                            }

                            function closeCreateModal() {
                                document.getElementById('createInvoiceModal').classList.add('hidden');
                                document.getElementById('createInvoiceForm').reset();
                                document.getElementById('totalAmount').textContent = '3.000.000 VNĐ';
                                document.getElementById('currentCount').textContent = '1';
                            }

                            // Close modal when clicking outside
                            document.getElementById('createInvoiceModal').addEventListener('click', function (e) {
                                if (e.target === this) {
                                    closeCreateModal();
                                }
                            });
                        </script>
                    </body>

                    </html>