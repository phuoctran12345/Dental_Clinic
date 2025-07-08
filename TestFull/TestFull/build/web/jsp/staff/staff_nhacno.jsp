<%@page pageEncoding="UTF-8" %>
    <%@page import="java.util.*" %>
        <%@page import="model.*" %>
            <%@page import="dao.*" %>
                <%@ include file="/jsp/staff/staff_header.jsp" %>
                    <%@ include file="/jsp/staff/staff_menu.jsp" %>
                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Nhắc nợ khách hàng - DentCare</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                            <style>
                                body {
                                    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                }

                                .main-content {
                                    margin-left: 280px;
                                    padding: 24px;
                                    min-height: 100vh;
                                }

                                .page-title {
                                    color: #1e3a8a;
                                    font-size: 2rem;
                                    font-weight: 700;
                                    margin-bottom: 24px;
                                }

                                .card {
                                    border: none;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                }

                                .card-header {
                                    background: linear-gradient(135deg, #eff6ff 0%, #e0f2fe 100%);
                                    border-bottom: 1px solid #dbeafe;
                                    font-weight: 600;
                                    color: #1e3a8a;
                                }

                                .reminder-row {
                                    padding: 16px;
                                    margin: 8px 0;
                                    border: 1px solid #e5e7eb;
                                    border-radius: 8px;
                                    transition: all 0.2s;
                                }

                                .reminder-row:hover {
                                    background-color: #f8fafc;
                                    border-color: #3b82f6;
                                }

                                .reminder-row.urgent {
                                    border-left: 5px solid #dc2626;
                                    background: linear-gradient(135deg, #fef2f2 0%, #ffffff 100%);
                                }

                                .reminder-row.due-soon {
                                    border-left: 5px solid #f59e0b;
                                    background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);
                                }

                                .reminder-row.normal {
                                    border-left: 5px solid #2563eb;
                                }

                                .priority-badge {
                                    padding: 4px 12px;
                                    border-radius: 20px;
                                    font-size: 0.75rem;
                                    font-weight: 600;
                                    text-transform: uppercase;
                                }

                                .priority-badge.urgent {
                                    background: #fecaca;
                                    color: #dc2626;
                                    animation: pulse 2s infinite;
                                }

                                .priority-badge.due-soon {
                                    background: #fef3c7;
                                    color: #d97706;
                                }

                                .priority-badge.normal {
                                    background: #dbeafe;
                                    color: #2563eb;
                                }

                                @keyframes pulse {

                                    0%,
                                    100% {
                                        opacity: 1;
                                    }

                                    50% {
                                        opacity: 0.8;
                                    }
                                }

                                .contact-btn {
                                    margin: 2px;
                                    border-radius: 6px;
                                    font-size: 0.8rem;
                                    padding: 6px 12px;
                                    border: none;
                                    color: white;
                                    cursor: pointer;
                                    transition: all 0.2s;
                                }

                                .btn-sms {
                                    background: #10b981;
                                }

                                .btn-sms:hover {
                                    background: #059669;
                                    color: white;
                                }

                                .btn-call {
                                    background: #3b82f6;
                                }

                                .btn-call:hover {
                                    background: #2563eb;
                                    color: white;
                                }

                                .btn-email {
                                    background: #8b5cf6;
                                }

                                .btn-email:hover {
                                    background: #7c3aed;
                                    color: white;
                                }

                                .bill-id {
                                    font-family: 'Courier New', monospace;
                                    background: #f1f5f9;
                                    padding: 2px 6px;
                                    border-radius: 4px;
                                    font-size: 0.9rem;
                                }

                                .order-id {
                                    font-family: 'Courier New', monospace;
                                    color: #64748b;
                                    font-size: 0.8rem;
                                }

                                .filter-tabs {
                                    margin-bottom: 24px;
                                }

                                .filter-tabs .nav-link {
                                    border-radius: 8px;
                                    margin-right: 8px;
                                    color: #6b7280;
                                    border: 1px solid #d1d5db;
                                }

                                .filter-tabs .nav-link.active {
                                    background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
                                    color: white;
                                    border-color: #2563eb;
                                }

                                @media (max-width: 768px) {
                                    .main-content {
                                        margin-left: 0;
                                        padding: 16px;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <%@include file="staff_menu.jsp" %>

                                <div class="main-content">
                                    <!-- Header -->
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h1 class="page-title">
                                            <i class="fas fa-bell me-3"></i>
                                            Nhắc nợ khách hàng
                                        </h1>
                                        <div>
                                            <button class="btn btn-success" onclick="sendBulkReminders()">
                                                <i class="fas fa-paper-plane me-2"></i>Gửi hàng loạt
                                            </button>
                                            <a href="StaffPaymentServlet?action=installments"
                                                class="btn btn-outline-primary">
                                                <i class="fas fa-arrow-left me-2"></i>Quay lại trả góp
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Stats Overview -->
                                    <div class="row mb-4">
                                        <div class="col-md-3">
                                            <div class="card">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-exclamation-triangle fa-2x text-danger mb-2"></i>
                                                    <h5 class="card-title">Quá hạn</h5>
                                                    <h3 class="text-danger">8</h3>
                                                    <small class="text-muted">khách hàng</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="card">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-clock fa-2x text-warning mb-2"></i>
                                                    <h5 class="card-title">Sắp đến hạn</h5>
                                                    <h3 class="text-warning">5</h3>
                                                    <small class="text-muted">khách hàng</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="card">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-calendar-check fa-2x text-info mb-2"></i>
                                                    <h5 class="card-title">Đã nhắc hôm nay</h5>
                                                    <h3 class="text-info">12</h3>
                                                    <small class="text-muted">lượt</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="card">
                                                <div class="card-body text-center">
                                                    <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                                                    <h5 class="card-title">Tỷ lệ phản hồi</h5>
                                                    <h3 class="text-success">85%</h3>
                                                    <small class="text-muted">trong tuần</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Filter Tabs -->
                                    <ul class="nav nav-pills filter-tabs">
                                        <li class="nav-item">
                                            <button class="nav-link active" data-filter="all"
                                                onclick="filterReminders('all')">
                                                Tất cả (25)
                                            </button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link" data-filter="urgent"
                                                onclick="filterReminders('urgent')">
                                                Khẩn cấp (8)
                                            </button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link" data-filter="due-soon"
                                                onclick="filterReminders('due-soon')">
                                                Sắp đến hạn (5)
                                            </button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link" data-filter="normal"
                                                onclick="filterReminders('normal')">
                                                Bình thường (12)
                                            </button>
                                        </li>
                                    </ul>

                                    <!-- Main Content -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">
                                                <i class="fas fa-list me-2"></i>
                                                Danh sách khách hàng cần nhắc nợ
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <!-- Search và Filter -->
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="input-group">
                                                        <span class="input-group-text">
                                                            <i class="fas fa-search"></i>
                                                        </span>
                                                        <input type="text" id="searchInput" class="form-control"
                                                            placeholder="Tìm theo bill_id, tên khách hàng, số điện thoại...">
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <select id="reminderTypeFilter" class="form-select">
                                                        <option value="">Tất cả loại nhắc</option>
                                                        <option value="SMS">SMS</option>
                                                        <option value="CALL">Điện thoại</option>
                                                        <option value="EMAIL">Email</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <button class="btn btn-primary w-100" onclick="searchReminders()">
                                                        <i class="fas fa-search me-2"></i>Tìm kiếm
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Reminders List -->
                                            <div id="remindersList">

                                                <!-- Urgent Reminder -->
                                                <div class="reminder-row urgent" data-priority="urgent">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-1">
                                                            <div class="text-center">
                                                                <i
                                                                    class="fas fa-exclamation-triangle fa-2x text-danger"></i>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <h6 class="mb-1">
                                                                <span class="bill-id">BILL_FDEF5983</span>
                                                            </h6>
                                                            <p class="mb-1">
                                                                <i class="fas fa-user text-secondary me-1"></i>
                                                                <strong>Nguyễn Văn A</strong>
                                                            </p>
                                                            <p class="mb-1">
                                                                <i class="fas fa-phone text-secondary me-1"></i>
                                                                0123456789
                                                            </p>
                                                            <p class="mb-0 order-id">
                                                                <i class="fas fa-receipt text-muted me-1"></i>
                                                                ORDER_1750487405119
                                                            </p>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="text-center">
                                                                <strong class="text-danger">833,333 VNĐ</strong>
                                                                <br><small class="text-muted">Kỳ 3/6</small>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="mb-1">
                                                                <span class="priority-badge urgent">Quá hạn 7
                                                                    ngày</span>
                                                            </div>
                                                            <small class="text-muted">Hạn: 15/08/2024</small>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <small class="text-muted d-block">Lần nhắc cuối:</small>
                                                            <span class="fw-bold">20/08/2024</span>
                                                            <br><small class="text-info">SMS</small>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="d-grid gap-1">
                                                                <button class="btn contact-btn btn-sms"
                                                                    onclick="sendReminder('BILL_FDEF5983', 'SMS')">
                                                                    <i class="fas fa-sms me-1"></i>SMS
                                                                </button>
                                                                <button class="btn contact-btn btn-call"
                                                                    onclick="sendReminder('BILL_FDEF5983', 'CALL')">
                                                                    <i class="fas fa-phone me-1"></i>Gọi
                                                                </button>
                                                                <button class="btn contact-btn btn-email"
                                                                    onclick="sendReminder('BILL_FDEF5983', 'EMAIL')">
                                                                    <i class="fas fa-envelope me-1"></i>Email
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Due Soon Reminder -->
                                                <div class="reminder-row due-soon" data-priority="due-soon">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-1">
                                                            <div class="text-center">
                                                                <i class="fas fa-clock fa-2x text-warning"></i>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <h6 class="mb-1">
                                                                <span class="bill-id">BILL_ABC12345</span>
                                                            </h6>
                                                            <p class="mb-1">
                                                                <i class="fas fa-user text-secondary me-1"></i>
                                                                <strong>Trần Thị B</strong>
                                                            </p>
                                                            <p class="mb-1">
                                                                <i class="fas fa-phone text-secondary me-1"></i>
                                                                0987654321
                                                            </p>
                                                            <p class="mb-0 order-id">
                                                                <i class="fas fa-receipt text-muted me-1"></i>
                                                                ORDER_1750487405120
                                                            </p>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="text-center">
                                                                <strong class="text-warning">833,333 VNĐ</strong>
                                                                <br><small class="text-muted">Kỳ 7/12</small>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="mb-1">
                                                                <span class="priority-badge due-soon">Còn 2 ngày</span>
                                                            </div>
                                                            <small class="text-muted">Hạn: 25/08/2024</small>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <small class="text-muted d-block">Lần nhắc cuối:</small>
                                                            <span class="fw-bold">18/08/2024</span>
                                                            <br><small class="text-success">Gọi điện</small>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="d-grid gap-1">
                                                                <button class="btn contact-btn btn-sms"
                                                                    onclick="sendReminder('BILL_ABC12345', 'SMS')">
                                                                    <i class="fas fa-sms me-1"></i>SMS
                                                                </button>
                                                                <button class="btn contact-btn btn-call"
                                                                    onclick="sendReminder('BILL_ABC12345', 'CALL')">
                                                                    <i class="fas fa-phone me-1"></i>Gọi
                                                                </button>
                                                                <button class="btn contact-btn btn-email"
                                                                    onclick="sendReminder('BILL_ABC12345', 'EMAIL')">
                                                                    <i class="fas fa-envelope me-1"></i>Email
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Normal Reminder -->
                                                <div class="reminder-row normal" data-priority="normal">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-1">
                                                            <div class="text-center">
                                                                <i class="fas fa-info-circle fa-2x text-primary"></i>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <h6 class="mb-1">
                                                                <span class="bill-id">BILL_DEF78901</span>
                                                            </h6>
                                                            <p class="mb-1">
                                                                <i class="fas fa-user text-secondary me-1"></i>
                                                                <strong>Lê Văn C</strong>
                                                            </p>
                                                            <p class="mb-1">
                                                                <i class="fas fa-phone text-secondary me-1"></i>
                                                                0369852741
                                                            </p>
                                                            <p class="mb-0 order-id">
                                                                <i class="fas fa-receipt text-muted me-1"></i>
                                                                ORDER_1750487405122
                                                            </p>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="text-center">
                                                                <strong class="text-primary">750,000 VNĐ</strong>
                                                                <br><small class="text-muted">Kỳ 2/9</small>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="mb-1">
                                                                <span class="priority-badge normal">Còn 5 ngày</span>
                                                            </div>
                                                            <small class="text-muted">Hạn: 28/08/2024</small>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <small class="text-muted d-block">Lần nhắc cuối:</small>
                                                            <span class="fw-bold">15/08/2024</span>
                                                            <br><small class="text-purple">Email</small>
                                                        </div>

                                                        <div class="col-md-2">
                                                            <div class="d-grid gap-1">
                                                                <button class="btn contact-btn btn-sms"
                                                                    onclick="sendReminder('BILL_DEF78901', 'SMS')">
                                                                    <i class="fas fa-sms me-1"></i>SMS
                                                                </button>
                                                                <button class="btn contact-btn btn-call"
                                                                    onclick="sendReminder('BILL_DEF78901', 'CALL')">
                                                                    <i class="fas fa-phone me-1"></i>Gọi
                                                                </button>
                                                                <button class="btn contact-btn btn-email"
                                                                    onclick="sendReminder('BILL_DEF78901', 'EMAIL')">
                                                                    <i class="fas fa-envelope me-1"></i>Email
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>

                                            <!-- Bulk Actions -->
                                            <div class="card mt-4">
                                                <div class="card-header">
                                                    <h6 class="mb-0"><i class="fas fa-tasks me-2"></i>Thao tác hàng loạt
                                                    </h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-3">
                                                            <button class="btn btn-warning w-100"
                                                                onclick="selectUrgentReminders()">
                                                                <i class="fas fa-exclamation-triangle me-2"></i>
                                                                Chọn tất cả quá hạn
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <button class="btn btn-info w-100" onclick="sendBulkSMS()">
                                                                <i class="fas fa-sms me-2"></i>
                                                                Gửi SMS hàng loạt
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <button class="btn btn-success w-100"
                                                                onclick="generateReport()">
                                                                <i class="fas fa-file-alt me-2"></i>
                                                                Báo cáo nhắc nợ
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <button class="btn btn-secondary w-100"
                                                                onclick="exportToExcel()">
                                                                <i class="fas fa-file-excel me-2"></i>
                                                                Xuất Excel
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Reminder Modal -->
                                <div class="modal fade" id="reminderModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">
                                                    <i class="fas fa-bell me-2"></i>
                                                    Gửi thông báo nhắc nợ
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form id="reminderForm">
                                                    <input type="hidden" id="reminderBillId">
                                                    <input type="hidden" id="reminderType">

                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <label class="form-label">Hóa đơn:</label>
                                                            <input type="text" id="reminderBillIdDisplay"
                                                                class="form-control-plaintext bill-id" readonly>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="form-label">Loại thông báo:</label>
                                                            <input type="text" id="reminderTypeDisplay"
                                                                class="form-control-plaintext" readonly>
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="reminderMessage" class="form-label">Nội dung thông
                                                            báo:</label>
                                                        <textarea id="reminderMessage" class="form-control" rows="6">Kính chào Quý khách,

Phòng khám nha khoa DentCare thông báo Quý khách có kỳ trả góp đến hạn thanh toán.

Chi tiết:
- Mã hóa đơn: [BILL_ID]
- Số tiền: [AMOUNT] VNĐ
- Hạn thanh toán: [DUE_DATE]

Vui lòng liên hệ hotline 0123456789 để thanh toán hoặc đến trực tiếp phòng khám.

Xin cảm ơn Quý khách!</textarea>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="reminderSchedule" class="form-label">Lên lịch
                                                            gửi:</label>
                                                        <select id="reminderSchedule" class="form-select">
                                                            <option value="now">Gửi ngay</option>
                                                            <option value="1hour">Sau 1 giờ</option>
                                                            <option value="1day">Sau 1 ngày</option>
                                                            <option value="custom">Tùy chỉnh thời gian</option>
                                                        </select>
                                                    </div>

                                                    <div id="customScheduleDiv" class="mb-3" style="display: none;">
                                                        <label for="customScheduleTime" class="form-label">Thời gian
                                                            gửi:</label>
                                                        <input type="datetime-local" id="customScheduleTime"
                                                            class="form-control">
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-primary"
                                                    onclick="submitReminder()">
                                                    <i class="fas fa-paper-plane me-1"></i>Gửi thông báo
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    // Filter functionality
                                    function filterReminders(priority) {
                                        // Update active tab
                                        document.querySelectorAll('.filter-tabs .nav-link').forEach(link => {
                                            link.classList.remove('active');
                                        });
                                        document.querySelector(`[data-filter="${priority}"]`).classList.add('active');

                                        // Filter cards
                                        const cards = document.querySelectorAll('.reminder-row');
                                        cards.forEach(card => {
                                            if (priority === 'all' || card.dataset.priority === priority) {
                                                card.style.display = 'block';
                                            } else {
                                                card.style.display = 'none';
                                            }
                                        });
                                    }

                                    // Search functionality
                                    function searchReminders() {
                                        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                                        const typeFilter = document.getElementById('reminderTypeFilter').value;
                                        const cards = document.querySelectorAll('.reminder-row');

                                        cards.forEach(card => {
                                            const text = card.textContent.toLowerCase();
                                            const matchesSearch = text.includes(searchTerm);
                                            const matchesType = !typeFilter;

                                            card.style.display = (matchesSearch && matchesType) ? 'block' : 'none';
                                        });
                                    }

                                    // Send individual reminder
                                    function sendReminder(billId, type) {
                                        document.getElementById('reminderBillId').value = billId;
                                        document.getElementById('reminderType').value = type;
                                        document.getElementById('reminderBillIdDisplay').value = billId;
                                        document.getElementById('reminderTypeDisplay').value = type;

                                        // Update message template based on type
                                        let message = document.getElementById('reminderMessage').value;
                                        message = message.replace('[BILL_ID]', billId);
                                        document.getElementById('reminderMessage').value = message;

                                        new bootstrap.Modal(document.getElementById('reminderModal')).show();
                                    }

                                    function submitReminder() {
                                        const billId = document.getElementById('reminderBillId').value;
                                        const type = document.getElementById('reminderType').value;
                                        const message = document.getElementById('reminderMessage').value;
                                        const schedule = document.getElementById('reminderSchedule').value;

                                        // Submit to server
                                        const formData = new FormData();
                                        formData.append('action', 'send_reminder');
                                        formData.append('billId', billId);
                                        formData.append('reminderType', type);
                                        formData.append('message', message);
                                        formData.append('schedule', schedule);

                                        if (schedule === 'custom') {
                                            formData.append('customTime', document.getElementById('customScheduleTime').value);
                                        }

                                        fetch('StaffPaymentServlet', {
                                            method: 'POST',
                                            body: formData
                                        })
                                            .then(response => response.text())
                                            .then(result => {
                                                console.log('Reminder result:', result);
                                                alert('Đã ' + (schedule === 'now' ? 'gửi' : 'lên lịch gửi') + ' thông báo ' + type + ' cho hóa đơn ' + billId + ' thành công!');
                                                bootstrap.Modal.getInstance(document.getElementById('reminderModal')).hide();

                                                // Update UI to show reminder sent
                                                setTimeout(() => location.reload(), 1000);
                                            })
                                            .catch(error => {
                                                console.error('Reminder error:', error);
                                                alert('Có lỗi khi gửi thông báo: ' + error.message);
                                            });
                                    }

                                    // Bulk actions
                                    function selectUrgentReminders() {
                                        const urgentCount = document.querySelectorAll('.reminder-row.urgent').length;
                                        alert('Đã chọn tất cả ' + urgentCount + ' hóa đơn quá hạn');
                                    }

                                    function sendBulkSMS() {
                                        if (confirm('Gửi SMS nhắc nợ cho tất cả khách hàng đã chọn?')) {
                                            fetch('StaffPaymentServlet?action=send_bulk_sms')
                                                .then(response => response.text())
                                                .then(result => {
                                                    alert('Đã gửi SMS hàng loạt thành công!');
                                                })
                                                .catch(error => {
                                                    console.error('Bulk SMS error:', error);
                                                    alert('Có lỗi khi gửi SMS hàng loạt');
                                                });
                                        }
                                    }

                                    function sendBulkReminders() {
                                        if (confirm('Gửi thông báo nhắc nợ cho tất cả khách hàng trong danh sách?')) {
                                            fetch('StaffPaymentServlet?action=send_bulk_reminders')
                                                .then(response => response.text())
                                                .then(result => {
                                                    alert('Đã gửi thông báo hàng loạt thành công!');
                                                    setTimeout(() => location.reload(), 1000);
                                                })
                                                .catch(error => {
                                                    console.error('Bulk reminders error:', error);
                                                    alert('Có lỗi khi gửi thông báo hàng loạt');
                                                });
                                        }
                                    }

                                    function generateReport() {
                                        window.open('StaffPaymentServlet?action=generate_reminder_report', '_blank');
                                    }

                                    function exportToExcel() {
                                        window.location.href = 'StaffPaymentServlet?action=export_reminders';
                                    }

                                    // Schedule toggle
                                    document.getElementById('reminderSchedule').addEventListener('change', function () {
                                        const customDiv = document.getElementById('customScheduleDiv');
                                        if (this.value === 'custom') {
                                            customDiv.style.display = 'block';
                                        } else {
                                            customDiv.style.display = 'none';
                                        }
                                    });

                                    // Auto-refresh every 5 minutes to check for new reminders
                                    setInterval(function () {
                                        console.log('Auto-refreshing reminder data...');
                                        // In production, use AJAX to refresh data without full page reload
                                    }, 300000);

                                    // Real-time search
                                    document.getElementById('searchInput').addEventListener('input', function () {
                                        searchReminders();
                                    });
                                </script>
                        </body>

                        </html>