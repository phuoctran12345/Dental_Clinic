<%@page pageEncoding="UTF-8" %>
    <%@ include file="/jsp/staff/staff_header.jsp" %>
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
            <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                    <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Quản lý thanh toán - Dental Clinic</title>

                            <!-- Font Awesome và Bootstrap -->
                            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                                rel="stylesheet">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">

                            <style>
                                * {
                                    margin: 0;
                                    padding: 0;
                                    box-sizing: border-box;
                                }

                                body {
                                    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                    min-height: 100vh;
                                }

                                .main-content {
                                    margin-left: 280px;
                                    padding: 24px;
                                    min-height: 100vh;
                                }

                                /* Header Section */
                                .page-header {
                                    display: flex;
                                    align-items: center;
                                    justify-content: space-between;
                                    margin-bottom: 24px;
                                }

                                .page-title {
                                    color: #1e3a8a;
                                    font-size: 2rem;
                                    font-weight: 700;
                                    margin-bottom: 4px;
                                }

                                .page-subtitle {
                                    color: #2563eb;
                                    font-size: 1rem;
                                }

                                .btn-primary-custom {
                                    background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
                                    border: none;
                                    color: white;
                                    padding: 12px 24px;
                                    border-radius: 8px;
                                    text-decoration: none;
                                    display: flex;
                                    align-items: center;
                                    gap: 8px;
                                    transition: all 0.2s;
                                }

                                .btn-primary-custom:hover {
                                    background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 100%);
                                    transform: translateY(-1px);
                                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
                                }

                                /* Stats Cards */
                                .stats-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                                    gap: 16px;
                                    margin-bottom: 24px;
                                }

                                .stat-card {
                                    background: white;
                                    border: 1px solid #dbeafe;
                                    border-radius: 12px;
                                    padding: 20px;
                                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                                    transition: all 0.2s;
                                }

                                .stat-card:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                                }

                                .stat-content {
                                    display: flex;
                                    align-items: center;
                                    justify-content: space-between;
                                }

                                .stat-info h3 {
                                    font-size: 0.875rem;
                                    font-weight: 500;
                                    margin-bottom: 4px;
                                }

                                .stat-number {
                                    font-size: 2rem;
                                    font-weight: 700;
                                }

                                .stat-icon {
                                    font-size: 32px;
                                }

                                /* Revenue Stats Colors */
                                .stat-card.revenue .stat-info h3 {
                                    color: #2563eb;
                                }

                                .stat-card.revenue .stat-number {
                                    color: #1e3a8a;
                                }

                                .stat-card.revenue .stat-icon {
                                    color: #3b82f6;
                                }

                                .stat-card.paid .stat-info h3 {
                                    color: #059669;
                                }

                                .stat-card.paid .stat-number {
                                    color: #047857;
                                }

                                .stat-card.paid .stat-icon {
                                    color: #10b981;
                                }

                                .stat-card.pending .stat-info h3 {
                                    color: #dc2626;
                                }

                                .stat-card.pending .stat-number {
                                    color: #b91c1c;
                                }

                                .stat-card.pending .stat-icon {
                                    color: #ef4444;
                                }

                                .stat-card.partial .stat-info h3 {
                                    color: #d97706;
                                }

                                .stat-card.partial .stat-number {
                                    color: #b45309;
                                }

                                .stat-card.partial .stat-icon {
                                    color: #f59e0b;
                                }

                                /* Filter Section */
                                .filter-card {
                                    background: white;
                                    border: 1px solid #dbeafe;
                                    border-radius: 12px;
                                    padding: 20px;
                                    margin-bottom: 24px;
                                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                                }

                                .filter-grid {
                                    display: grid;
                                    grid-template-columns: 1fr auto;
                                    gap: 16px;
                                    align-items: center;
                                }

                                .search-box {
                                    position: relative;
                                }

                                .search-input {
                                    width: 100%;
                                    padding: 12px 12px 12px 40px;
                                    border: 1px solid #dbeafe;
                                    border-radius: 8px;
                                    font-size: 0.875rem;
                                    transition: all 0.2s;
                                }

                                .search-input:focus {
                                    outline: none;
                                    border-color: #2563eb;
                                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                                }

                                .search-icon {
                                    position: absolute;
                                    left: 12px;
                                    top: 50%;
                                    transform: translateY(-50%);
                                    color: #3b82f6;
                                }

                                .filter-select {
                                    padding: 12px 16px;
                                    border: 1px solid #dbeafe;
                                    border-radius: 8px;
                                    background: white;
                                    color: #1e3a8a;
                                    font-size: 0.875rem;
                                    min-width: 180px;
                                    cursor: pointer;
                                }

                                .filter-select:focus {
                                    outline: none;
                                    border-color: #2563eb;
                                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                                }

                                /* Bills List */
                                .bills-card {
                                    background: white;
                                    border: 1px solid #dbeafe;
                                    border-radius: 12px;
                                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                                    overflow: hidden;
                                }

                                .bills-header {
                                    background: linear-gradient(135deg, #eff6ff 0%, #e0f2fe 100%);
                                    padding: 20px;
                                    border-bottom: 1px solid #dbeafe;
                                }

                                .bills-title {
                                    color: #1e3a8a;
                                    font-size: 1.25rem;
                                    font-weight: 600;
                                    margin-bottom: 4px;
                                }

                                .bills-subtitle {
                                    color: #2563eb;
                                    font-size: 0.875rem;
                                    margin: 0;
                                }

                                .payment-item {
                                    padding: 20px;
                                    border-bottom: 1px solid #eff6ff;
                                    transition: all 0.2s;
                                }

                                .payment-item:hover {
                                    background-color: #f8fafc;
                                }

                                .payment-item:last-child {
                                    border-bottom: none;
                                }

                                /* Status Badges */
                                .status-badge {
                                    padding: 4px 12px;
                                    border-radius: 20px;
                                    font-size: 0.75rem;
                                    font-weight: 600;
                                    text-transform: uppercase;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 4px;
                                }

                                .status-badge.paid {
                                    background: #d1fae5;
                                    color: #059669;
                                }

                                .status-badge.partial {
                                    background: #fef3c7;
                                    color: #d97706;
                                }

                                .status-badge.pending {
                                    background: #fee2e2;
                                    color: #dc2626;
                                }

                                /* Action Buttons */
                                .action-buttons {
                                    display: flex;
                                    gap: 8px;
                                    flex-wrap: wrap;
                                }

                                .btn-action {
                                    padding: 6px 12px;
                                    border: 1px solid #dbeafe;
                                    border-radius: 6px;
                                    background: white;
                                    color: #2563eb;
                                    text-decoration: none;
                                    font-size: 0.8rem;
                                    display: flex;
                                    align-items: center;
                                    gap: 4px;
                                    transition: all 0.2s;
                                    cursor: pointer;
                                }

                                .btn-action:hover {
                                    background: #eff6ff;
                                    border-color: #2563eb;
                                    transform: translateY(-1px);
                                }

                                .btn-action.success {
                                    background: #d1fae5;
                                    color: #059669;
                                    border-color: #a7f3d0;
                                }

                                .btn-action.success:hover {
                                    background: #a7f3d0;
                                }

                                .btn-action.warning {
                                    background: #fef3c7;
                                    color: #d97706;
                                    border-color: #fcd34d;
                                }

                                .btn-action.warning:hover {
                                    background: #fcd34d;
                                }

                                /* Modal Styles */
                                .modal-overlay {
                                    position: fixed;
                                    top: 0;
                                    left: 0;
                                    right: 0;
                                    bottom: 0;
                                    background: rgba(0, 0, 0, 0.5);
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    z-index: 1000;
                                }

                                .modal-overlay.hidden {
                                    display: none;
                                }

                                .modal-content {
                                    background: white;
                                    border-radius: 12px;
                                    max-width: 600px;
                                    width: 90%;
                                    max-height: 90vh;
                                    overflow-y: auto;
                                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                                }

                                .modal-header {
                                    padding: 20px;
                                    border-bottom: 1px solid #dbeafe;
                                    background: linear-gradient(135deg, #eff6ff 0%, #e0f2fe 100%);
                                }

                                .modal-title {
                                    color: #1e3a8a;
                                    font-size: 1.25rem;
                                    font-weight: 600;
                                    margin: 0;
                                }

                                .modal-subtitle {
                                    color: #2563eb;
                                    font-size: 0.875rem;
                                    margin: 4px 0 0 0;
                                }

                                .modal-close {
                                    background: none;
                                    border: none;
                                    color: #6b7280;
                                    font-size: 1.5rem;
                                    cursor: pointer;
                                    padding: 0;
                                    width: 32px;
                                    height: 32px;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    border-radius: 50%;
                                    transition: all 0.2s;
                                }

                                .modal-close:hover {
                                    background: rgba(0, 0, 0, 0.1);
                                    color: #374151;
                                }

                                .modal-body {
                                    padding: 20px;
                                }

                                .modal-footer {
                                    padding: 20px;
                                    border-top: 1px solid #dbeafe;
                                    display: flex;
                                    gap: 12px;
                                    justify-content: flex-end;
                                }

                                /* Form Styles */
                                .form-group {
                                    margin-bottom: 16px;
                                }

                                .form-label {
                                    display: block;
                                    color: #1e3a8a;
                                    font-weight: 500;
                                    margin-bottom: 6px;
                                    font-size: 0.875rem;
                                }

                                .form-control {
                                    width: 100%;
                                    padding: 10px 12px;
                                    border: 1px solid #dbeafe;
                                    border-radius: 6px;
                                    font-size: 0.875rem;
                                    transition: all 0.2s;
                                }

                                .form-control:focus {
                                    outline: none;
                                    border-color: #2563eb;
                                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                                }

                                /* Responsive */
                                @media (max-width: 768px) {
                                    .main-content {
                                        margin-left: 0;
                                        padding: 16px;
                                    }

                                    .stats-grid {
                                        grid-template-columns: repeat(2, 1fr);
                                    }

                                    .filter-grid {
                                        grid-template-columns: 1fr;
                                    }

                                    .page-header {
                                        flex-direction: column;
                                        gap: 16px;
                                        align-items: flex-start;
                                    }
                                }

                                /* Empty State */
                                .empty-state {
                                    padding: 60px 20px;
                                    text-align: center;
                                    color: #6b7280;
                                }

                                .empty-state i {
                                    font-size: 48px;
                                    margin-bottom: 16px;
                                    color: #d1d5db;
                                }

                                .empty-state h3 {
                                    color: #374151;
                                    margin-bottom: 8px;
                                }

                                /* Installment Modal Styles */
                                .large-modal {
                                    max-width: 800px;
                                    width: 90%;
                                }

                                .input-display {
                                    padding: 12px;
                                    background-color: #f8f9fa;
                                    border: 1px solid #dee2e6;
                                    border-radius: 6px;
                                    color: #495057;
                                    font-weight: 500;
                                }

                                .preview-section {
                                    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                                    border: 1px solid #dbeafe;
                                    border-radius: 12px;
                                    padding: 20px;
                                    min-height: 300px;
                                }

                                .installment-preview {
                                    background: white;
                                    border: 1px solid #e3f2fd;
                                    border-radius: 8px;
                                    padding: 16px;
                                    margin-top: 10px;
                                }

                                .installment-preview h6 {
                                    color: #1976d2;
                                    border-bottom: 2px solid #e3f2fd;
                                    padding-bottom: 8px;
                                    margin-bottom: 16px;
                                }

                                .btn-close {
                                    background: none;
                                    border: none;
                                    font-size: 24px;
                                    font-weight: bold;
                                    color: #999;
                                    cursor: pointer;
                                    width: 32px;
                                    height: 32px;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    border-radius: 50%;
                                    transition: all 0.2s;
                                    float: right;
                                }

                                .btn-close:hover {
                                    background-color: #f8f9fa;
                                    color: #666;
                                }

                                .modal-header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="main-content">
                                <!-- Header -->
                                <div class="page-header">
                                    <div>
                                        <h1 class="page-title">Quản lý thanh toán</h1>
                                        <p class="page-subtitle">Theo dõi hóa đơn và thanh toán</p>
                                    </div>
                                    <button onclick="openCreateModal()" class="btn-primary-custom">
                                        <i class="fas fa-plus"></i>
                                        <span>Tạo hóa đơn</span>
                                    </button>
                                </div>

                                <!-- Stats Cards -->
                                <div class="stats-grid">
                                    <!-- Total Revenue -->
                                    <div class="stat-card revenue">
                                        <div class="stat-content">
                                            <div class="stat-info">
                                                <h3>Tổng doanh thu</h3>
                                                <div class="stat-number">
                                                    <fmt:formatNumber value="${totalRevenue / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </div>
                                            </div>
                                            <i class="fas fa-dollar-sign stat-icon"></i>
                                        </div>
                                    </div>

                                    <!-- Paid Amount -->
                                    <div class="stat-card paid">
                                        <div class="stat-content">
                                            <div class="stat-info">
                                                <h3>Đã thu</h3>
                                                <div class="stat-number">
                                                    <fmt:formatNumber value="${paidAmount / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </div>
                                            </div>
                                            <i class="fas fa-check-circle stat-icon"></i>
                                        </div>
                                    </div>

                                    <!-- Pending Amount -->
                                    <div class="stat-card pending">
                                        <div class="stat-content">
                                            <div class="stat-info">
                                                <h3>Chờ thu</h3>
                                                <div class="stat-number">
                                                    <fmt:formatNumber value="${pendingAmount / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </div>
                                            </div>
                                            <i class="fas fa-clock stat-icon"></i>
                                        </div>
                                    </div>

                                    <!-- Partial Amount -->
                                    <div class="stat-card partial">
                                        <div class="stat-content">
                                            <div class="stat-info">
                                                <h3>Nợ một phần</h3>
                                                <div class="stat-number">
                                                    <fmt:formatNumber value="${partialAmount / 1000000}"
                                                        maxFractionDigits="1" />M
                                                </div>
                                            </div>
                                            <i class="fas fa-exclamation-triangle stat-icon"></i>
                                        </div>
                                    </div>
                                </div>

                                <!-- Filters -->
                                <div class="filter-card">
                                    <div class="filter-grid">
                                        <div class="search-box">
                                            <i class="fas fa-search search-icon"></i>
                                            <input type="text" class="search-input"
                                                placeholder="Tìm theo tên, số hóa đơn hoặc SĐT..." id="searchInput"
                                                onkeyup="filterPayments()">
                                        </div>
                                        <select class="filter-select" id="statusFilter" onchange="filterPayments()">
                                            <option value="all">Tất cả trạng thái</option>
                                            <option value="paid">Đã thanh toán</option>
                                            <option value="partial">Thanh toán một phần</option>
                                            <option value="pending">Chờ thanh toán</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Bills List -->
                                <div class="bills-card">
                                    <div class="bills-header">
                                        <h2 class="bills-title">Danh sách hóa đơn</h2>
                                        <p class="bills-subtitle">Hiển thị <span id="displayCount">${totalBills}</span>
                                            hóa
                                            đơn</p>
                                    </div>

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
                                                                            <span class="status-badge paid">
                                                                                <i class="fas fa-check-circle"></i>
                                                                                Đã thanh toán
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${bill.paymentStatus == 'PARTIAL' || bill.paymentStatus == 'partial'}">
                                                                            <span class="status-badge partial">
                                                                                <i class="fas fa-clock"></i>
                                                                                Thanh toán một phần
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="status-badge pending">
                                                                                <i
                                                                                    class="fas fa-exclamation-triangle"></i>
                                                                                Chờ thanh toán
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
                                                                                    test="${bill.paymentStatus == 'PAID' || bill.paymentStatus == 'Đã thanh toán' || bill.paymentStatus == 'success'}">
                                                                                    <fmt:formatNumber
                                                                                        value="${bill.totalAmount}"
                                                                                        type="number" />
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${bill.paymentStatus == 'PARTIAL' || bill.paymentStatus == 'partial'}">
                                                                                    <fmt:formatNumber
                                                                                        value="${bill.totalAmount * 0.5}"
                                                                                        type="number" />
                                                                                </c:when>
                                                                                <c:otherwise>0</c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                    <c:if
                                                                        test="${bill.paymentStatus != 'PAID' && bill.paymentStatus != 'Đã thanh toán' && bill.paymentStatus != 'success'}">
                                                                        <div>
                                                                            <small class="text-muted">Còn nợ:</small>
                                                                            <div class="fw-bold text-danger">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${bill.paymentStatus == 'PARTIAL' || bill.paymentStatus == 'partial'}">
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
                                                                <div class="action-buttons mb-2">
                                                                    <button class="btn-action"
                                                                        onclick="viewInvoice(${bill.billId})"
                                                                        title="Xem chi tiết">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                    <button class="btn-action"
                                                                        onclick="printInvoice(${bill.billId})"
                                                                        title="In hóa đơn">
                                                                        <i class="fas fa-print"></i>
                                                                    </button>
                                                                    <button class="btn-action"
                                                                        onclick="downloadInvoice(${bill.billId})"
                                                                        title="Tải xuống">
                                                                        <i class="fas fa-download"></i>
                                                                    </button>
                                                                </div>

                                                                <div class="action-buttons">
                                                                    <c:if
                                                                        test="${bill.paymentStatus == 'PENDING' || bill.paymentStatus == 'Chờ thanh toán' || bill.paymentStatus == 'pending'}">
                                                                        <button class="btn-action success"
                                                                            onclick="processPayment(${bill.billId}, 'full')">
                                                                            <i class="fas fa-credit-card"></i>
                                                                            Thu tiền
                                                                        </button>
                                                                        <button class="btn-action warning"
                                                                            onclick="createInstallment('${bill.billId}', ${bill.totalAmount})">
                                                                            <i class="fas fa-calendar-alt"></i>
                                                                            Trả góp
                                                                        </button>
                                                                    </c:if>

                                                                    <c:if
                                                                        test="${bill.paymentStatus == 'PARTIAL' || bill.paymentStatus == 'partial'}">
                                                                        <button class="btn-action warning"
                                                                            onclick="processPayment(${bill.billId}, 'remaining')">
                                                                            <i class="fas fa-credit-card"></i>
                                                                            Thu nợ
                                                                        </button>
                                                                    </c:if>

                                                                    <c:if
                                                                        test="${bill.paymentStatus == 'INSTALLMENT' || bill.paymentStatus == 'installment'}">
                                                                        <button class="btn-action"
                                                                            onclick="viewInstallmentDetail('${bill.billId}')">
                                                                            <i class="fas fa-list-alt"></i>
                                                                            Chi tiết
                                                                        </button>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <i class="fas fa-receipt"></i>
                                                    <h3>Chưa có hóa đơn</h3>
                                                    <p>Hiện tại không có hóa đơn nào trong hệ thống.</p>
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
                            <div class="modal-overlay hidden" id="createInvoiceModal">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <div
                                            style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
                                            <div>
                                                <h2 class="modal-title">Tạo hóa đơn mới</h2>
                                                <p class="modal-subtitle">Tạo hóa đơn thanh toán cho bệnh nhân</p>
                                            </div>
                                            <button type="button" onclick="closeCreateModal()" class="modal-close">
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
                                                        Hiển thị <span id="currentCount">
                                                            <c:choose>
                                                                <c:when test="${not empty services}">
                                                                    ${fn:length(services)}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    0
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span> dịch vụ
                                                    </span>
                                                </div>

                                                <div class="border rounded"
                                                    style="max-height: 200px; overflow-y: auto;">
                                                    <!-- Dynamic Services from Database -->
                                                    <c:choose>
                                                        <c:when test="${empty services}">
                                                            <div class="p-3 text-center text-muted">
                                                                <i class="fas fa-exclamation-triangle fa-2x mb-2"></i>
                                                                <div>Không có dịch vụ nào trong hệ thống</div>
                                                                <small>Vui lòng liên hệ quản trị viên</small>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach items="${services}" var="service"
                                                                varStatus="status">
                                                                <div class="service-item p-3 border-bottom d-flex align-items-center gap-3"
                                                                    ${status.first
                                                                    ? 'style="background-color: #f8f9fa;"' : '' }>
                                                                    <input type="checkbox" class="form-check-input"
                                                                        name="selectedServices"
                                                                        value="${service.serviceId}"
                                                                        data-price="${service.price}" ${status.first
                                                                        ? 'checked' : '' } onchange="calculateTotal()">
                                                                    <div class="flex-grow-1">
                                                                        <div class="service-name fw-bold">
                                                                            ${service.serviceName}</div>
                                                                        <div
                                                                            class="service-description text-muted small">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty service.description}">
                                                                                    ${service.description}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    Dịch vụ chăm sóc sức khỏe răng miệng
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                    <div class="text-end">
                                                                        <div class="service-price fw-bold text-primary">
                                                                            <fmt:formatNumber value="${service.price}"
                                                                                type="number" pattern="#,###" />
                                                                            VNĐ
                                                                        </div>
                                                                        <span class="badge bg-secondary small">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty service.category}">
                                                                                    ${service.category}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    Dịch vụ
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="bg-light p-3 rounded mt-3">
                                                    <div class="row">
                                                        <div class="col-6">
                                                            <strong>Tổng cộng: <span id="totalAmount"
                                                                    class="text-primary">0
                                                                    VNĐ</span></strong>
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
                                                                name="paymentAmount" id="paymentAmount" value="0"
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
                                                                        oninput="calculateInstallment()"
                                                                        onchange="calculateInstallment()"
                                                                        placeholder="Nhập số tiền đặt cọc">
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
                                                                        <option value="6" selected>6 tháng</option>
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

                                    console.log('🔍 Filter applied:', { searchTerm, statusFilter });

                                    paymentItems.forEach(item => {
                                        const searchData = item.dataset.search.toLowerCase();
                                        const status = item.dataset.status ? item.dataset.status.toLowerCase().trim() : '';

                                        console.log('📋 Item:', { searchData, status, statusFilter });

                                        const matchesSearch = searchData.includes(searchTerm);

                                        // Fixed status matching logic
                                        let matchesStatus = false;

                                        if (statusFilter === 'all') {
                                            matchesStatus = true;
                                        } else if (statusFilter === 'paid') {
                                            matchesStatus = (status === 'đã thanh toán' || status === 'paid' || status === 'success' || status.includes('đã thanh toán') || status.includes('paid') || status.includes('success'));
                                        } else if (statusFilter === 'partial') {
                                            matchesStatus = (status === 'thanh toán một phần' || status === 'partial' || status.includes('một phần') || status.includes('partial'));
                                        } else if (statusFilter === 'pending') {
                                            matchesStatus = (status === 'chờ thanh toán' || status === 'pending' || status === '' || status.includes('chờ') || status.includes('pending'));
                                        }

                                        const isVisible = matchesSearch && matchesStatus;
                                        item.style.display = isVisible ? 'block' : 'none';

                                        if (isVisible) {
                                            visibleCount++;
                                            console.log('✅ Showing item:', item.dataset.search);
                                        } else {
                                            console.log('❌ Hiding item:', item.dataset.search, { matchesSearch, matchesStatus });
                                        }
                                    });

                                    document.getElementById('displayCount').textContent = visibleCount;
                                    console.log('📊 Filter result: ' + visibleCount + ' items visible');

                                    // Update pagination after filtering
                                    initBillsPagination();
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
                                    // Open installment creation modal
                                    openInstallmentModal(billId, totalAmount);
                                }

                                function openInstallmentModal(billId, totalAmount) {
                                    document.getElementById('installmentModal').classList.remove('hidden');
                                    document.getElementById('installmentBillId').textContent = billId;
                                    document.getElementById('installmentTotalAmount').textContent = totalAmount.toLocaleString() + ' VNĐ';

                                    // Set default values
                                    document.getElementById('downPaymentPercent').value = 30;
                                    document.getElementById('installmentPeriodsSelect').value = 6;

                                    // Calculate initial values
                                    calculateInstallmentPlan();
                                }

                                function closeInstallmentModal() {
                                    document.getElementById('installmentModal').classList.add('hidden');
                                    document.getElementById('installmentForm').reset();
                                }

                                function calculateInstallmentPlan() {
                                    const billId = document.getElementById('installmentBillId').textContent;
                                    const totalAmountText = document.getElementById('installmentTotalAmount').textContent;
                                    const totalAmount = parseFloat(totalAmountText.replace(/[^\d]/g, ''));

                                    const percent = parseFloat(document.getElementById('downPaymentPercent').value) || 30;
                                    const periods = parseInt(document.getElementById('installmentPeriodsSelect').value) || 6;

                                    // Validation
                                    if (percent < 30 || percent > 100) {
                                        document.getElementById('downPaymentPercent').style.borderColor = '#dc3545';
                                        document.getElementById('planPreview').innerHTML = '<div class="text-danger">Tỷ lệ đặt cọc phải từ 30-100%</div>';
                                        return;
                                    } else {
                                        document.getElementById('downPaymentPercent').style.borderColor = '#dbeafe';
                                    }

                                    const downPayment = Math.ceil((totalAmount * percent) / 100);
                                    const remaining = totalAmount - downPayment;
                                    const monthlyPayment = Math.ceil(remaining / periods);
                                    const lastPayment = remaining - (monthlyPayment * (periods - 1));

                                    // Update preview
                                    const preview = '<div class="installment-preview">' +
                                        '<h6 class="text-primary mb-3">📋 Kế hoạch trả góp cho hóa đơn ' + billId + '</h6>' +
                                        '<div class="row">' +
                                        '<div class="col-md-6">' +
                                        '<div class="mb-2"><strong>Tổng hóa đơn:</strong> ' + totalAmount.toLocaleString() + ' VNĐ</div>' +
                                        '<div class="mb-2"><strong>Đặt cọc (' + percent + '%):</strong> <span class="text-success">' + downPayment.toLocaleString() + ' VNĐ</span></div>' +
                                        '<div class="mb-2"><strong>Còn lại:</strong> ' + remaining.toLocaleString() + ' VNĐ</div>' +
                                        '</div>' +
                                        '<div class="col-md-6">' +
                                        '<div class="mb-2"><strong>Số kỳ:</strong> ' + periods + ' tháng</div>' +
                                        '<div class="mb-2"><strong>Mỗi kỳ:</strong> ' + monthlyPayment.toLocaleString() + ' VNĐ</div>' +
                                        '<div class="mb-2"><strong>Kỳ cuối:</strong> ' + lastPayment.toLocaleString() + ' VNĐ</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="mt-3 p-3 bg-light rounded">' +
                                        '<small class="text-muted">' +
                                        '<i class="fas fa-calendar-alt me-1"></i>' +
                                        'Lịch trả: Bắt đầu từ tháng tiếp theo, đến hạn vào ngày ' + new Date().getDate() + ' hàng tháng' +
                                        '</small>' +
                                        '</div>' +
                                        '</div>';

                                    document.getElementById('planPreview').innerHTML = preview;
                                }

                                function submitInstallmentPlan() {
                                    const billId = document.getElementById('installmentBillId').textContent;
                                    const totalAmountText = document.getElementById('installmentTotalAmount').textContent;
                                    const totalAmount = parseFloat(totalAmountText.replace(/[^\d]/g, ''));

                                    const percent = parseFloat(document.getElementById('downPaymentPercent').value);
                                    const periods = parseInt(document.getElementById('installmentPeriodsSelect').value);

                                    if (percent < 30 || percent > 100) {
                                        alert('Tỷ lệ đặt cọc phải từ 30-100%!');
                                        return;
                                    }

                                    const downPayment = Math.ceil((totalAmount * percent) / 100);

                                    // Submit to server
                                    const formData = new FormData();
                                    formData.append('action', 'create_installment');
                                    formData.append('billId', billId);
                                    formData.append('totalAmount', totalAmount);
                                    formData.append('downPayment', downPayment);
                                    formData.append('installmentCount', periods);

                                    fetch('StaffPaymentServlet', {
                                        method: 'POST',
                                        body: formData
                                    })
                                        .then(response => response.text())
                                        .then(result => {
                                            console.log('✅ Installment plan created:', result);
                                            alert('Tạo kế hoạch trả góp thành công!');
                                            closeInstallmentModal();
                                            // Reload page to show updated bill status
                                            setTimeout(() => window.location.reload(), 1000);
                                        })
                                        .catch(error => {
                                            console.error('❌ Error creating installment plan:', error);
                                            alert('Có lỗi khi tạo kế hoạch trả góp: ' + error.message);
                                        });
                                }

                                function viewInstallmentDetail(billId) {
                                    // Calculate next payment due date
                                    const today = new Date();
                                    const currentDay = today.getDate();
                                    const currentMonth = today.getMonth();
                                    const currentYear = today.getFullYear();

                                    // Tính ngày đến hạn kỳ tiếp theo (giả sử kỳ hạn là ngày 15 hàng tháng)
                                    let nextDueDate = new Date(currentYear, currentMonth, 15);

                                    // Nếu hôm nay đã qua ngày 15, thì kỳ tiếp theo sẽ là tháng sau
                                    if (currentDay > 15) {
                                        nextDueDate = new Date(currentYear, currentMonth + 1, 15);
                                    }

                                    // Tính số ngày còn lại
                                    const timeDiff = nextDueDate.getTime() - today.getTime();
                                    const daysRemaining = Math.ceil(timeDiff / (1000 * 3600 * 24));

                                    // Format ngày đến hạn
                                    const formatDate = nextDueDate.toLocaleDateString('vi-VN', {
                                        day: '2-digit',
                                        month: '2-digit',
                                        year: 'numeric'
                                    });

                                    let statusMessage = '';
                                    if (daysRemaining < 0) {
                                        statusMessage = 'QUÁ HẠN ' + Math.abs(daysRemaining) + ' ngày';
                                    } else if (daysRemaining === 0) {
                                        statusMessage = 'ĐẾN HẠN HÔM NAY';
                                    } else if (daysRemaining <= 7) {
                                        statusMessage = 'SẮP ĐẾN HẠN trong ' + daysRemaining + ' ngày';
                                    } else {
                                        statusMessage = 'Còn ' + daysRemaining + ' ngày đến hạn';
                                    }

                                    const detailMessage = 'Chi tiết trả góp hóa đơn ID: ' + billId + '\n\n' +
                                        '📅 Kỳ thanh toán tiếp theo: ' + formatDate + '\n' +
                                        '⏰ Trạng thái: ' + statusMessage + '\n\n' +
                                        'Nhấn OK để xem chi tiết đầy đủ...';

                                    alert(detailMessage);

                                    // Có thể chuyển hướng đến trang chi tiết
                                    // window.location.href = 'StaffPaymentServlet?action=installment_detail&billId=' + billId;
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
                                let totalInvoiceAmount = 0;

                                // Calculate total amount
                                function calculateTotal() {
                                    const checkboxes = document.querySelectorAll('input[name="selectedServices"]:checked');
                                    let total = 0;
                                    let count = 0;

                                    checkboxes.forEach(checkbox => {
                                        const price = parseFloat(checkbox.dataset.price || 0);
                                        total += price;
                                        count++;
                                    });

                                    // Update display
                                    document.getElementById('totalAmount').textContent = total.toLocaleString() + ' VNĐ';
                                    document.getElementById('paymentAmount').value = total;
                                    document.getElementById('currentCount').textContent = count;

                                    // Update global variable
                                    totalInvoiceAmount = total;

                                    // Update installment calculations if installment is selected
                                    const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;
                                    if (paymentMethod === 'installment') {
                                        updateInstallmentDisplay();
                                    }
                                }

                                // Initialize calculation when page loads
                                document.addEventListener('DOMContentLoaded', function () {
                                    // Wait a bit for page to fully load, then calculate
                                    setTimeout(() => {
                                        calculateTotal();
                                    }, 100);
                                });

                                // Update installment display helper function
                                function updateInstallmentDisplay() {
                                    const downPaymentInput = document.getElementById('downPayment');
                                    if (downPaymentInput && totalInvoiceAmount > 0) {
                                        const minDown = Math.ceil(totalInvoiceAmount * 0.3);
                                        document.getElementById('minDownPayment').textContent = minDown.toLocaleString();
                                        downPaymentInput.min = minDown;
                                        if (parseFloat(downPaymentInput.value) < minDown) {
                                            downPaymentInput.value = minDown;
                                        }
                                        calculateInstallment();
                                    }
                                }

                                // Handle payment method change
                                function handlePaymentMethodChange() {
                                    const paymentMethodSelect = document.querySelector('select[name="paymentMethod"]');
                                    const installmentOptions = document.getElementById('installmentOptions');
                                    const paymentAmount = document.getElementById('paymentAmount');
                                    const downPaymentInput = document.getElementById('downPayment');

                                    if (!paymentMethodSelect) {
                                        console.log('⚠️ Payment method select not found');
                                        return;
                                    }

                                    const paymentMethod = paymentMethodSelect.value;
                                    console.log('💳 Payment method changed to:', paymentMethod);

                                    if (paymentMethod === 'installment') {
                                        if (installmentOptions) installmentOptions.style.display = 'block';
                                        if (paymentAmount) {
                                            paymentAmount.readOnly = true;
                                            paymentAmount.value = totalInvoiceAmount;
                                        }

                                        // Set default down payment (30% minimum)
                                        const minDownPayment = Math.ceil(totalInvoiceAmount * 0.3);
                                        if (downPaymentInput && (!downPaymentInput.value || parseFloat(downPaymentInput.value) < minDownPayment)) {
                                            downPaymentInput.value = minDownPayment;
                                        }

                                        // Calculate installment plan
                                        setTimeout(() => calculateInstallment(), 100);
                                    } else {
                                        if (installmentOptions) installmentOptions.style.display = 'none';
                                        if (paymentAmount) {
                                            paymentAmount.readOnly = false;
                                            paymentAmount.value = totalInvoiceAmount;
                                        }
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
                                    const downPaymentInput = document.getElementById('downPayment');
                                    const installmentMonthsSelect = document.querySelector('select[name="installmentMonths"]');

                                    if (!downPaymentInput || !installmentMonthsSelect) {
                                        console.log('⚠️ Installment elements not found');
                                        return;
                                    }

                                    const downPayment = parseFloat(downPaymentInput.value) || 0;
                                    const installmentMonths = parseInt(installmentMonthsSelect.value) || 3;
                                    const minDown = Math.ceil(totalInvoiceAmount * 0.3);

                                    console.log('💳 Calculating installment:', {
                                        downPayment: downPayment,
                                        installmentMonths: installmentMonths,
                                        totalAmount: totalInvoiceAmount,
                                        minDown: minDown
                                    });

                                    // Always update display, even if invalid
                                    const remaining = Math.max(0, totalInvoiceAmount - downPayment);
                                    const monthlyPayment = installmentMonths > 0 ? Math.ceil(remaining / installmentMonths) : 0;

                                    // Update display elements
                                    const displayDownPayment = document.getElementById('displayDownPayment');
                                    const remainingAmountEl = document.getElementById('remainingAmount');
                                    const monthlyPaymentEl = document.getElementById('monthlyPayment');

                                    if (displayDownPayment) displayDownPayment.textContent = downPayment.toLocaleString();
                                    if (remainingAmountEl) remainingAmountEl.textContent = remaining.toLocaleString();
                                    if (monthlyPaymentEl) monthlyPaymentEl.textContent = monthlyPayment.toLocaleString();

                                    // Validate and show warning if needed
                                    if (downPayment < minDown) {
                                        console.log('⚠️ Down payment too low:', downPayment, 'Min required:', minDown);

                                        // Add warning style
                                        if (downPaymentInput) {
                                            downPaymentInput.style.borderColor = '#dc3545';
                                            downPaymentInput.style.backgroundColor = '#fff5f5';
                                        }
                                    } else {
                                        // Remove warning style
                                        if (downPaymentInput) {
                                            downPaymentInput.style.borderColor = '#dbeafe';
                                            downPaymentInput.style.backgroundColor = 'white';
                                        }
                                    }
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
                                        const downPaymentInput = document.getElementById('downPayment');
                                        const installmentMonthsSelect = document.querySelector('select[name="installmentMonths"]');

                                        if (!downPaymentInput || !installmentMonthsSelect) {
                                            alert('Lỗi: Không tìm thấy thông tin trả góp!');
                                            return;
                                        }

                                        const downPayment = parseFloat(downPaymentInput.value) || 0;
                                        const installmentMonths = parseInt(installmentMonthsSelect.value) || 0;
                                        const minDown = Math.ceil(totalInvoiceAmount * 0.3);

                                        console.log('🔍 Validating installment:', {
                                            downPayment: downPayment,
                                            minDown: minDown,
                                            installmentMonths: installmentMonths,
                                            totalAmount: totalInvoiceAmount
                                        });

                                        if (downPayment < minDown) {
                                            alert('Số tiền đặt cọc phải tối thiểu 30%!\nYêu cầu: ' + minDown.toLocaleString() + ' VNĐ\nBạn nhập: ' + downPayment.toLocaleString() + ' VNĐ');
                                            downPaymentInput.focus();
                                            downPaymentInput.style.borderColor = '#dc3545';
                                            downPaymentInput.style.backgroundColor = '#fff5f5';
                                            return;
                                        }

                                        if (downPayment > totalInvoiceAmount) {
                                            alert('Số tiền đặt cọc không được vượt quá tổng hóa đơn!\nTối đa: ' + totalInvoiceAmount.toLocaleString() + ' VNĐ');
                                            downPaymentInput.focus();
                                            return;
                                        }

                                        if (installmentMonths < 3 || installmentMonths > 12) {
                                            alert('Số kỳ trả góp phải từ 3-12 tháng!');
                                            installmentMonthsSelect.focus();
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

                                    // Debug log
                                    console.log('🚀 Submitting invoice with data:', {
                                        customerName, customerPhone, paymentMethod,
                                        totalAmount: totalInvoiceAmount, paymentAmount,
                                        selectedServices: Array.from(selectedServices).map(s => s.value)
                                    });

                                    // Submit via XMLHttpRequest (more reliable than fetch for this case)
                                    const xhr = new XMLHttpRequest();
                                    xhr.open('POST', 'StaffPaymentServlet', true);

                                    // Create URLSearchParams instead of FormData for better compatibility
                                    const params = new URLSearchParams();
                                    params.append('action', 'createBill');
                                    params.append('customerName', customerName);
                                    params.append('customerPhone', customerPhone);
                                    params.append('paymentMethod', paymentMethod);
                                    params.append('totalAmount', totalInvoiceAmount);
                                    params.append('paymentAmount', paymentAmount);
                                    params.append('notes', document.querySelector('textarea[name="notes"]').value || '');

                                    // Add selected services
                                    selectedServices.forEach((service, index) => {
                                        params.append('selectedServices[' + index + ']', service.value);
                                    });

                                    // Add installment data if applicable
                                    if (paymentMethod === 'installment') {
                                        const downPaymentValue = document.getElementById('downPayment').value || '0';
                                        const installmentMonthsValue = document.querySelector('select[name="installmentMonths"]').value || '6';

                                        params.append('downPayment', downPaymentValue);
                                        params.append('installmentMonths', installmentMonthsValue);

                                        console.log('📋 Adding installment data:', {
                                            downPayment: downPaymentValue,
                                            installmentMonths: installmentMonthsValue
                                        });
                                    }

                                    // Set headers
                                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
                                    xhr.setRequestHeader('Accept', 'application/json');

                                    // Debug log
                                    console.log('🚀 Sending AJAX request with params:', params.toString());

                                    xhr.onreadystatechange = function () {
                                        console.log('📡 ReadyState:', xhr.readyState, 'Status:', xhr.status);

                                        if (xhr.readyState === 4) {
                                            console.log('📡 Response headers:', xhr.getAllResponseHeaders());
                                            console.log('📡 Content-Type:', xhr.getResponseHeader('Content-Type'));
                                            console.log('📡 Response length:', xhr.responseText.length);
                                            console.log('📡 Response preview:', xhr.responseText.substring(0, 200));

                                            if (xhr.status === 200) {
                                                const contentType = xhr.getResponseHeader('Content-Type');
                                                if (contentType && contentType.includes('application/json')) {
                                                    try {
                                                        const data = JSON.parse(xhr.responseText);
                                                        console.log('✅ JSON parsed successfully:', data);

                                                        if (data.success) {
                                                            alert('Tạo hóa đơn thành công!\nMã hóa đơn: ' + data.billId);
                                                            closeCreateModal();
                                                            setTimeout(() => window.location.reload(), 1000);
                                                        } else {
                                                            alert('Lỗi tạo hóa đơn: ' + data.message);
                                                        }
                                                    } catch (e) {
                                                        console.error('❌ JSON parse error:', e);
                                                        console.error('❌ Raw response:', xhr.responseText);
                                                        alert('Lỗi phân tích phản hồi từ server!\nPhản hồi: ' + xhr.responseText.substring(0, 300));
                                                    }
                                                } else {
                                                    console.error('❌ Non-JSON response, Content-Type:', contentType);
                                                    alert('Server trả về định dạng không đúng!\nContent-Type: ' + contentType + '\nResponse: ' + xhr.responseText.substring(0, 300));
                                                }
                                            } else {
                                                console.error('❌ HTTP error:', xhr.status, xhr.statusText);
                                                alert('Lỗi HTTP: ' + xhr.status + ' ' + xhr.statusText + '\nResponse: ' + xhr.responseText.substring(0, 300));
                                            }
                                        }
                                    };

                                    xhr.onerror = function () {
                                        console.error('❌ Network error');
                                        alert('Lỗi kết nối mạng!');
                                    };

                                    xhr.ontimeout = function () {
                                        console.error('❌ Request timeout');
                                        alert('Yêu cầu bị timeout!');
                                    };

                                    xhr.timeout = 30000; // 30 second timeout

                                    try {
                                        xhr.send(params.toString());
                                        console.log('📤 Request sent successfully');
                                    } catch (e) {
                                        console.error('❌ Send error:', e);
                                        alert('Lỗi gửi yêu cầu: ' + e.message);
                                    }
                                }

                                // Modal functions
                                function openCreateModal() {
                                    const modal = document.getElementById('createInvoiceModal');
                                    if (modal) {
                                        modal.classList.remove('hidden');

                                        // Calculate total first
                                        calculateTotal();

                                        // Initialize installment section
                                        const minDownPayment = Math.ceil(totalInvoiceAmount * 0.3);
                                        const minDownPaymentDisplay = document.getElementById('minDownPayment');
                                        const downPaymentInput = document.getElementById('downPayment');

                                        if (minDownPaymentDisplay) {
                                            minDownPaymentDisplay.textContent = minDownPayment.toLocaleString();
                                        }

                                        if (downPaymentInput) {
                                            downPaymentInput.min = minDownPayment;
                                            downPaymentInput.value = minDownPayment;
                                        }

                                        // Reset payment method
                                        const paymentMethodSelect = document.querySelector('select[name="paymentMethod"]');
                                        if (paymentMethodSelect) {
                                            paymentMethodSelect.value = '';
                                        }

                                        // Hide installment options by default
                                        const installmentOptions = document.getElementById('installmentOptions');
                                        if (installmentOptions) {
                                            installmentOptions.style.display = 'none';
                                        }

                                        console.log('📋 Modal opened with total amount:', totalInvoiceAmount);
                                        console.log('📋 Min down payment set to:', minDownPayment);
                                        console.log('📋 Elements found:', {
                                            modal: !!modal,
                                            minDownPaymentDisplay: !!minDownPaymentDisplay,
                                            downPaymentInput: !!downPaymentInput,
                                            paymentMethodSelect: !!paymentMethodSelect,
                                            installmentOptions: !!installmentOptions
                                        });
                                    }
                                }

                                function closeCreateModal() {
                                    const modal = document.getElementById('createInvoiceModal');
                                    const form = document.getElementById('createInvoiceForm');

                                    if (modal) modal.classList.add('hidden');
                                    if (form) form.reset();

                                    // Reset display values
                                    const totalAmountEl = document.getElementById('totalAmount');
                                    const currentCountEl = document.getElementById('currentCount');
                                    const displayDownPayment = document.getElementById('displayDownPayment');
                                    const remainingAmountEl = document.getElementById('remainingAmount');
                                    const monthlyPaymentEl = document.getElementById('monthlyPayment');

                                    if (totalAmountEl) totalAmountEl.textContent = '0 VNĐ';
                                    if (currentCountEl) currentCountEl.textContent = '0';
                                    if (displayDownPayment) displayDownPayment.textContent = '0';
                                    if (remainingAmountEl) remainingAmountEl.textContent = '0';
                                    if (monthlyPaymentEl) monthlyPaymentEl.textContent = '0';

                                    // Hide installment options
                                    const installmentOptions = document.getElementById('installmentOptions');
                                    if (installmentOptions) installmentOptions.style.display = 'none';

                                    // Reset payment amount
                                    const paymentAmount = document.getElementById('paymentAmount');
                                    if (paymentAmount) {
                                        paymentAmount.readOnly = false;
                                        paymentAmount.value = '';
                                    }

                                    // Reset input styles
                                    const downPaymentInput = document.getElementById('downPayment');
                                    if (downPaymentInput) {
                                        downPaymentInput.style.borderColor = '#dbeafe';
                                        downPaymentInput.style.backgroundColor = 'white';
                                    }

                                    // Reset global variable
                                    totalInvoiceAmount = 0;

                                    console.log('📋 Modal closed and reset');
                                }

                                // Close modal when clicking outside
                                document.getElementById('createInvoiceModal').addEventListener('click', function (e) {
                                    if (e.target === this) {
                                        closeCreateModal();
                                    }
                                });
                            </script>

                            <!-- Installment Plan Modal -->
                            <div id="installmentModal" class="modal-overlay hidden">
                                <div class="modal-content large-modal">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <i class="fas fa-credit-card me-2"></i>
                                            Tạo Kế Hoạch Trả Góp
                                        </h5>
                                        <button type="button" class="btn-close"
                                            onclick="closeInstallmentModal()">×</button>
                                    </div>

                                    <div class="modal-body">
                                        <form id="installmentForm">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label class="form-label">Hóa đơn:</label>
                                                        <div class="input-display">
                                                            <strong id="installmentBillId">-</strong>
                                                        </div>
                                                    </div>

                                                    <div class="form-group mb-3">
                                                        <label class="form-label">Tổng tiền:</label>
                                                        <div class="input-display">
                                                            <strong id="installmentTotalAmount"
                                                                class="text-primary">-</strong>
                                                        </div>
                                                    </div>

                                                    <div class="form-group mb-3">
                                                        <label for="downPaymentPercent" class="form-label">Tỷ lệ đặt cọc
                                                            (%):</label>
                                                        <input type="number" id="downPaymentPercent"
                                                            class="form-control" min="30" max="100" value="30"
                                                            oninput="calculateInstallmentPlan()"
                                                            onchange="calculateInstallmentPlan()" />
                                                        <small class="text-muted">Tối thiểu 30%, tối đa 100%</small>
                                                    </div>

                                                    <div class="form-group mb-3">
                                                        <label for="installmentPeriodsSelect" class="form-label">Số kỳ
                                                            trả
                                                            góp:</label>
                                                        <select id="installmentPeriodsSelect" class="form-control"
                                                            onchange="calculateInstallmentPlan()">
                                                            <option value="3">3 tháng</option>
                                                            <option value="6" selected>6 tháng</option>
                                                            <option value="9">9 tháng</option>
                                                            <option value="12">12 tháng</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div id="planPreview" class="preview-section">
                                                        <div class="text-muted text-center">
                                                            Chọn tỷ lệ đặt cọc để xem kế hoạch
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            onclick="closeInstallmentModal()">Hủy</button>
                                        <button type="button" class="btn btn-primary" onclick="submitInstallmentPlan()">
                                            <i class="fas fa-save me-1"></i>
                                            Tạo Kế Hoạch
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Bootstrap JS -->
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>