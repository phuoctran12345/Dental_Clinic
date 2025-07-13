<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Phê duyệt lịch làm việc</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
                    rel="stylesheet">
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

                    .nav-tabs .nav-link {
                        color: #495057;
                        font-weight: 500;
                        border: none;
                        border-bottom: 3px solid transparent;
                        border-radius: 0;
                        padding: 1rem 1.5rem;
                    }

                    .nav-tabs .nav-link.active {
                        color: #667eea;
                        border-bottom-color: #667eea;
                        background: none;
                    }

                    .nav-tabs .nav-link:hover {
                        border-color: transparent;
                        color: #667eea;
                    }

                    .tab-content {
                        margin-top: 1rem;
                    }

                    .staff-badge {
                        font-size: 0.75rem;
                        padding: 0.3rem 0.6rem;
                    }
                </style>
            </head>

            <body class="bg-light">
                <!-- Header Section -->
                <div class="header-section">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col">
                                <h1 class="mb-1" id="approval-title">
                                    <i class="bi bi-calendar-x me-2"></i>
                                    Phê duyệt lịch nghỉ phép của bác sĩ
                                </h1>
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

                    <!-- Tab Navigation -->
                    <div class="card schedule-card">
                        
                        <div class="card-header bg-white border-bottom-0 p-0">
                            <ul class="nav nav-tabs" id="approvalTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="doctor-tab" data-bs-toggle="tab"
                                        data-bs-target="#doctor-panel" type="button" role="tab"
                                        aria-controls="doctor-panel" aria-selected="true">
                                        <i class="bi bi-person-badge me-2"></i>
                                        Bác sĩ
                                        <span class="badge bg-primary ms-2" id="doctor-count">
                                            ${pendingDoctorSchedules.size()}
                                        </span>
                                    </button>
                                </li>
                                
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="staff-tab" data-bs-toggle="tab"
                                        data-bs-target="#staff-panel" type="button" role="tab"
                                        aria-controls="staff-panel" aria-selected="false">
                                        <i class="bi bi-people me-2"></i>
                                        Nhân viên
                                        <span class="badge bg-success ms-2" id="staff-count">
                                            ${pendingStaffRequests.size()}
                                        </span>
                                    </button>
                                </li>
                                
                            </ul>
                        </div>

                        <div class="card-body p-0">
                            <div class="tab-content" id="approvalTabsContent">

                                <!-- Doctor Panel -->
                                <div class="tab-pane fade show active" id="doctor-panel" role="tabpanel"
                                    aria-labelledby="doctor-tab">
                                    <c:choose>
                                        <c:when test="${empty pendingDoctorSchedules}">
                                            <div class="no-data">
                                                <i class="bi bi-calendar-x display-1 text-muted mb-3"></i>
                                                <h4 class="text-muted">Không có lịch bác sĩ cần phê duyệt</h4>
                                                <p class="text-muted">Hiện tại không có yêu cầu đăng ký lịch làm việc
                                                    nào của bác sĩ cần phê duyệt.</p>
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
                                                        <c:forEach items="${pendingDoctorSchedules}" var="schedule"
                                                            varStatus="status">
                                                            <tr>
                                                                <td class="py-3">
                                                                    <div class="fw-medium">
                                                                        <i
                                                                            class="bi bi-person-circle text-primary me-2"></i>
                                                                        ID: ${schedule.doctorId}
                                                                    </div>
                                                                </td>
                                                                <td class="py-3">
                                                                    <span class="text-primary fw-medium">
                                                                        <fmt:formatDate pattern="dd/MM/yyyy"
                                                                            value="${schedule.workDate}" />
                                                                    </span>
                                                                </td>
                                                                <td class="py-3">
                                                                    <span class="badge bg-warning status-badge">
                                                                        <i class="bi bi-hourglass-split me-1"></i>
                                                                        Chờ duyệt
                                                                    </span>
                                                                </td>
                                                                <td class="py-3 text-center">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/ManagerApprovalStaffScheduleServlet"
                                                                        method="POST" class="d-inline action-buttons">
                                                                        <input type="hidden" name="request_type"
                                                                            value="doctor">
                                                                        <input type="hidden" name="schedule_id"
                                                                            value="${schedule.scheduleId}">
                                                                        
                                                                        <button type="submit" name="action"
                                                                            value="approve"
                                                                            class="btn btn-success btn-sm"
                                                                            onclick="return confirm('Bạn có chắc muốn phê duyệt lịch này?')">
                                                                            <i class="bi bi-check-lg me-1"></i>Duyệt
                                                                        </button>
                                                                        
                                                                        <button type="submit" name="action"
                                                                            value="reject" class="btn btn-danger btn-sm"
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

                                <!-- Staff Panel -->
                                <div class="tab-pane fade" id="staff-panel" role="tabpanel" aria-labelledby="staff-tab">
                                    <c:choose>
                                        <c:when test="${empty pendingStaffRequests}">
                                            <div class="no-data">
                                                <i class="bi bi-people-fill display-1 text-muted mb-3"></i>
                                                <h4 class="text-muted">Không có yêu cầu nhân viên cần phê duyệt</h4>
                                                <p class="text-muted">Hiện tại không có yêu cầu đăng ký ca làm việc hoặc
                                                    nghỉ phép nào của nhân viên cần phê duyệt.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th class="py-3">
                                                                <i class="bi bi-people me-1"></i>
                                                                Nhân viên
                                                            </th>
                                                            <th class="py-3">
                                                                <i class="bi bi-calendar-date me-1"></i>
                                                                Ngày
                                                            </th>
                                                            <th class="py-3">
                                                                <i class="bi bi-briefcase me-1"></i>
                                                                Loại yêu cầu
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
                                                        <c:forEach items="${pendingStaffRequests}" var="request"
                                                            varStatus="status">
                                                            <tr>
                                                                <td class="py-3">
                                                                    <div class="fw-medium">
                                                                        <i
                                                                            class="bi bi-person-badge text-success me-2"></i>
                                                                        ${request.staffName}
                                                                    </div>
                                                                    <small class="text-muted">
                                                                        <span
                                                                            class="badge staff-badge ${request.employmentType == 'fulltime' ? 'bg-primary' : 'bg-info'}">
                                                                            ${request.employmentType == 'fulltime' ?
                                                                            'Full-time' : 'Part-time'}
                                                                        </span>
                                                                    </small>
                                                                </td>
                                                                <td class="py-3">
                                                                    <span class="text-primary fw-medium">
                                                                        <fmt:formatDate pattern="dd/MM/yyyy"
                                                                            value="${request.workDate}" />
                                                                    </span>
                                                                </td>
                                                                <td class="py-3">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${request.employmentType eq 'fulltime' && empty request.slotId}">
                                                                            <span class="badge bg-warning status-badge">
                                                                                <i
                                                                                    class="bi bi-calendar-x me-1"></i>Nghỉ
                                                                                phép cả ngày
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${request.employmentType eq 'parttime' && not empty request.slotId}">
                                                                            <span class="badge bg-info status-badge">
                                                                                <i class="bi bi-briefcase me-1"></i>Đăng
                                                                                ký ca
                                                                                <c:if
                                                                                    test="${not empty request.slotId}">
                                                                                    <br />
                                                                                    <span class="text-dark">Ca số:
                                                                                        <b>${request.slotId}</b></span>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${not empty request.slotName}">
                                                                                    <br />
                                                                                    <span class="text-dark">Tên ca:
                                                                                        <b>${request.slotName}</b></span>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${not empty request.slotTime}">
                                                                                    <br />
                                                                                    <span class="text-dark">Thời gian:
                                                                                        <b>${request.slotTime}</b></span>
                                                                                </c:if>
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="badge bg-secondary status-badge">
                                                                                <i
                                                                                    class="bi bi-question-circle me-1"></i>Không
                                                                                xác định
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="py-3">
                                                                    <span class="badge bg-warning status-badge">
                                                                        <i class="bi bi-hourglass-split me-1"></i>
                                                                        Chờ duyệt
                                                                    </span>
                                                                </td>
                                                                <td class="py-3 text-center">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/ManagerApprovalStaffScheduleServlet"
                                                                        method="POST" class="d-inline action-buttons">
                                                                        <input type="hidden" name="request_type"
                                                                            value="staff">
                                                                        <input type="hidden" name="schedule_id"
                                                                            value="${request.scheduleId}">
                                                                        <button type="submit" name="action"
                                                                            value="approve"
                                                                            class="btn btn-success btn-sm"
                                                                            onclick="return confirm('Bạn có chắc muốn phê duyệt yêu cầu này?')">
                                                                            <i class="bi bi-check-lg me-1"></i>Duyệt
                                                                        </button>
                                                                        <button type="submit" name="action"
                                                                            value="reject" class="btn btn-danger btn-sm"
                                                                            onclick="return confirm('Bạn có chắc muốn từ chối yêu cầu này?')">
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
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    // Auto-switch to Staff tab if there are staff requests but no doctor schedules
                    document.addEventListener('DOMContentLoaded', function () {
                        const doctorCount = parseInt('${pendingDoctorSchedules.size()}') || 0;
                        const staffCount = parseInt('${pendingStaffRequests.size()}') || 0;

                        // Nếu không có lịch bác sĩ nhưng có staff thì tự chuyển tab
                        if (doctorCount === 0 && staffCount > 0) {
                            const staffTab = new bootstrap.Tab(document.getElementById('staff-tab'));
                            staffTab.show();
                        }

                        // Đổi tiêu đề động khi chuyển tab
                        const approvalTitle = document.getElementById('approval-title');
                        document.getElementById('doctor-tab').addEventListener('click', function () {
                            approvalTitle.innerHTML = '<i class="bi bi-calendar-x me-2"></i>Phê duyệt lịch nghỉ phép của bác sĩ';
                        });
                        document.getElementById('staff-tab').addEventListener('click', function () {
                            approvalTitle.innerHTML = '<i class="bi bi-calendar-x me-2"></i>Phê duyệt lịch nghỉ phép và lịch làm của nhân viên';
                        });
                    });
                </script>
            </body>

            </html>