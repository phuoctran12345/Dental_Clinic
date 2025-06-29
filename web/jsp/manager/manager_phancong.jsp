<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Phê duyệt lịch làm việc</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                .header-section {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 2rem 0;
                    margin-bottom: 2rem;
                }

                .schedule-card {
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    border-radius: 12px;
                    overflow: hidden;
                }

                .status-badge {
                    font-size: 0.85rem;
                    padding: 0.4rem 0.8rem;
                }

                .action-buttons .btn {
                    margin: 0 0.2rem;
                    border-radius: 20px;
                    font-size: 0.85rem;
                }

                .no-data {
                    text-align: center;
                    padding: 3rem;
                    color: #6c757d;
                }
            </style>
        </head>

        <body class="bg-light">
            <!-- Header Section -->
            <div class="header-section">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col">
                            <h1 class="mb-1">
                                <i class="bi bi-calendar-check me-2"></i>
                                Phê duyệt lịch làm việc
                            </h1>
                            <p class="mb-0 opacity-75">Quản lý và phê duyệt lịch đăng ký làm việc của bác sĩ</p>
                        </div>
                        <div class="col-auto">
                            <a href="${pageContext.request.contextPath}/jsp/manager/" class="btn btn-outline-light">
                                <i class="bi bi-arrow-left me-1"></i>
                                Quay lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container">
                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle me-2"></i>
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Nội dung chính -->
                <div class="card schedule-card">
                    <div class="card-header bg-white border-bottom-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-list-check text-primary me-2"></i>
                                Danh sách lịch cần phê duyệt
                            </h5>
                            <span class="badge bg-primary rounded-pill">
                                ${pendingSchedules.size()} yêu cầu
                            </span>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty pendingSchedules}">
                                <div class="no-data">
                                    <i class="bi bi-calendar-x display-1 text-muted mb-3"></i>
                                    <h4 class="text-muted">Không có lịch cần phê duyệt</h4>
                                    <p class="text-muted">Hiện tại không có yêu cầu đăng ký lịch làm việc nào cần phê
                                        duyệt.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="py-3">
                                                    <i class="bi bi-person-badge me-1"></i>
                                                    Bác sĩ
                                                </th>
                                                <th class="py-3">
                                                    <i class="bi bi-calendar-date me-1"></i>
                                                    Ngày làm việc
                                                </th>
                                                <th class="py-3">
                                                    <i class="bi bi-clock me-1"></i>
                                                    Ca làm việc
                                                </th>
                                                <th class="py-3">
                                                    <i class="bi bi-info-circle me-1"></i>
                                                    Trạng thái
                                                </th>
                                                <th class="py-3 text-center">
                                                    <i class="bi bi-gear me-1"></i>
                                                    Thao tác
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${pendingSchedules}" var="schedule" varStatus="status">
                                                <tr>
                                                    <td class="py-3">
                                                        <div class="fw-medium">ID: ${schedule.doctorId}</div>
                                                    </td>
                                                    <td class="py-3">
                                                        <span class="text-primary fw-medium">${schedule.workDate}</span>
                                                    </td>
                                                    <td class="py-3">
                                                        <c:choose>
                                                            <c:when test="${schedule.slotId == 1}">
                                                                <span class="badge bg-info status-badge">
                                                                    <i class="bi bi-sun me-1"></i>Ca sáng (8h-12h)
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${schedule.slotId == 2}">
                                                                <span class="badge bg-warning status-badge">
                                                                    <i class="bi bi-sunset me-1"></i>Ca chiều (13h-17h)
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${schedule.slotId == 3}">
                                                                <span class="badge bg-primary status-badge">
                                                                    <i class="bi bi-clock-history me-1"></i>Cả ngày
                                                                    (8h-17h)
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary status-badge">Không xác
                                                                    định</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="py-3">
                                                        <span class="badge bg-warning status-badge">
                                                            <i class="bi bi-hourglass-split me-1"></i>
                                                            ${schedule.status}
                                                        </span>
                                                    </td>
                                                    <td class="py-3 text-center">
                                                        <form
                                                            action="${pageContext.request.contextPath}/jsp/manager/manager_phancong"
                                                            method="POST" class="d-inline action-buttons">
                                                            <input type="hidden" name="scheduleId"
                                                                value="${schedule.scheduleId}">
                                                            <button type="submit" name="action" value="approve"
                                                                class="btn btn-success btn-sm"
                                                                onclick="return confirm('Bạn có chắc muốn phê duyệt lịch này?')">
                                                                <i class="bi bi-check-lg me-1"></i>Duyệt
                                                            </button>
                                                            <button type="submit" name="action" value="reject"
                                                                class="btn btn-danger btn-sm"
                                                                onclick="return confirm('Bạn có chắc muốn từ chối lịch này?')">
                                                                <i class="bi bi-x-lg me-1"></i>Từ chối
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>