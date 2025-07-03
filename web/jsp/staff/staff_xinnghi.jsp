<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng ký nghỉ phép - Nhân viên</title>

                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

                <style>
                    .leave-counter {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 20px;
                        border-radius: 10px;
                        margin-bottom: 30px;
                        text-align: center;
                    }

                    .counter-number {
                        font-size: 2.5rem;
                        font-weight: bold;
                    }

                    .status-pending {
                        color: #ffc107;
                    }

                    .status-approved {
                        color: #28a745;
                    }

                    .status-rejected {
                        color: #dc3545;
                    }

                    .request-form {
                        background: #f8f9fa;
                        padding: 25px;
                        border-radius: 10px;
                        margin-bottom: 30px;
                    }

                    .request-history {
                        background: white;
                        border-radius: 10px;
                        overflow: hidden;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .btn-leave {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        padding: 10px 30px;
                        border-radius: 25px;
                        font-weight: 500;
                    }

                    .btn-leave:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                    }
                </style>
            </head>

            <body class="bg-light">
                <%@ include file="staff_header.jsp" %>

                    <div class="container-fluid">
                        <div class="row">
                            <%@ include file="staff_menu.jsp" %>

                                <div class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
                                    <div
                                        class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                        <h1 class="h2">
                                            <i class="fas fa-calendar-times me-2"></i>
                                            Đăng ký nghỉ phép
                                        </h1>
                                        <div class="btn-toolbar mb-2 mb-md-0">
                                            <div class="btn-group me-2">
                                                <button type="button" class="btn btn-outline-secondary">
                                                    <i class="fas fa-calendar-alt me-1"></i>
                                                    Tháng ${currentMonth}/${currentYear}
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Thông báo -->
                                    <c:if test="${not empty sessionScope.success}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>
                                            ${sessionScope.success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                        <c:remove var="success" scope="session" />
                                    </c:if>

                                    <c:if test="${not empty sessionScope.error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            ${sessionScope.error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                        <c:remove var="error" scope="session" />
                                    </c:if>

                                    <!-- Thông tin loại nhân viên -->
                                    <div class="mb-3">
                                        <span class="badge bg-info">
                                            <c:choose>
                                                <c:when test="${employmentType eq 'fulltime'}">Full-time</c:when>
                                                <c:otherwise>Part-time</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <!-- Counter nghỉ phép -->
                                    <div class="row">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="leave-counter">
                                                <div class="counter-number">${usedDays} / ${maxDays}</div>
                                                <div class="fs-5">Ngày nghỉ phép trong tháng</div>
                                                <div class="mt-2">
                                                    <small>Còn lại: <strong>${remainingDays} ngày</strong></small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Form đăng ký nghỉ phép -->
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="request-form">
                                                <h5 class="mb-4">
                                                    <i class="fas fa-plus-circle me-2"></i>
                                                    Đăng ký nghỉ phép mới
                                                </h5>

                                                <c:choose>
                                                    <c:when test="${remainingDays > 0}">
                                                        <form method="post" action="StaffScheduleServlet">
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <label for="workDate" class="form-label">
                                                                        <i class="fas fa-calendar-day me-1"></i>
                                                                        Ngày nghỉ phép <span
                                                                            class="text-danger">*</span>
                                                                    </label>
                                                                    <input type="date" class="form-control"
                                                                        id="workDate" name="workDate"
                                                                        min="<fmt:formatDate value='${java.util.Date}' pattern='yyyy-MM-dd'/>"
                                                                        required>
                                                                </div>
                                                            </div>

                                                            <button type="submit" class="btn btn-primary btn-leave">
                                                                <i class="fas fa-paper-plane me-2"></i>
                                                                Gửi yêu cầu nghỉ phép
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="alert alert-warning">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            Bạn đã sử dụng hết số ngày nghỉ phép trong tháng này
                                                            (${maxDays} ngày).
                                                            <br>Vui lòng chờ tháng sau để đăng ký nghỉ phép.
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Lịch sử yêu cầu -->
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="request-history">
                                                <div class="card-header bg-white border-bottom">
                                                    <h5 class="mb-0">
                                                        <i class="fas fa-history me-2"></i>
                                                        Lịch sử yêu cầu nghỉ phép
                                                    </h5>
                                                </div>

                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Ngày nghỉ</th>
                                                                <th>Loại yêu cầu</th>
                                                                <th>Trạng thái</th>
                                                                <th>Người phê duyệt</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:choose>
                                                                <c:when test="${not empty scheduleRequests}">
                                                                    <c:forEach var="request"
                                                                        items="${scheduleRequests}">
                                                                        <tr>
                                                                            <td>
                                                                                <i class="fas fa-calendar-day me-2"></i>
                                                                                <fmt:formatDate
                                                                                    value="${request.workDate}"
                                                                                    pattern="dd/MM/yyyy" />
                                                                            </td>
                                                                            <td>
                                                                                <span
                                                                                    class="badge ${request.requestTypeCssClass}">
                                                                                    ${request.requestTypeDisplayName}
                                                                                </span>
                                                                            </td>
                                                                            <td>
                                                                                <span
                                                                                    class="badge ${request.statusCssClass}">
                                                                                    ${request.statusDisplayName}
                                                                                </span>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty request.approverName}">
                                                                                        ${request.approverName}
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <em class="text-muted">Chưa xử
                                                                                            lý</em>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <tr>
                                                                        <td colspan="4" class="text-center py-4">
                                                                            <i
                                                                                class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                                            <br>
                                                                            <em class="text-muted">Chưa có yêu cầu nghỉ
                                                                                phép nào trong tháng này</em>
                                                                        </td>
                                                                    </tr>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

                    <script>
                        // Tự động set ngày tối thiểu là ngày mai
                        document.addEventListener('DOMContentLoaded', function () {
                            const today = new Date();
                            const tomorrow = new Date(today);
                            tomorrow.setDate(tomorrow.getDate() + 1);

                            const dateInput = document.getElementById('leaveDate');
                            if (dateInput) {
                                dateInput.min = tomorrow.toISOString().split('T')[0];
                            }
                        });

                        // Auto dismiss alerts after 5 seconds
                        setTimeout(function () {
                            const alerts = document.querySelectorAll('.alert');
                            alerts.forEach(function (alert) {
                                const bsAlert = new bootstrap.Alert(alert);
                                bsAlert.close();
                            });
                        }, 5000);
                    </script>
            </body>

            </html>