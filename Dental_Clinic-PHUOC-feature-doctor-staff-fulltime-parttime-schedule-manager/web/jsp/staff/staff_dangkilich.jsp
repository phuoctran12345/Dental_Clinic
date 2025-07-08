<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng ký lịch làm việc - Nhân viên</title>

                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

                <style>
                    .calendar-container {
                        background: white;
                        border-radius: 10px;
                        padding: 20px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        margin-bottom: 30px;
                    }

                    .calendar-grid {
                        display: grid;
                        grid-template-columns: repeat(7, 1fr);
                        gap: 2px;
                        margin-top: 20px;
                    }

                    .calendar-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 10px;
                        text-align: center;
                        font-weight: bold;
                    }

                    .calendar-day {
                        min-height: 80px;
                        border: 1px solid #e0e0e0;
                        padding: 8px;
                        position: relative;
                        background: #f8f9fa;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .calendar-day:hover {
                        background: #e3f2fd;
                        border-color: #2196f3;
                    }

                    .calendar-day.has-schedule {
                        background: #e8f5e8;
                        border-color: #4caf50;
                    }

                    .calendar-day.today {
                        background: #fff3e0;
                        border-color: #ff9800;
                        font-weight: bold;
                    }

                    .day-number {
                        font-weight: bold;
                        margin-bottom: 5px;
                    }

                    .schedule-info {
                        background: #4caf50;
                        color: white;
                        font-size: 10px;
                        padding: 2px 4px;
                        border-radius: 3px;
                        margin-top: 2px;
                    }

                    .work-form {
                        background: #f8f9fa;
                        padding: 25px;
                        border-radius: 10px;
                        margin-bottom: 30px;
                    }

                    .schedule-history {
                        background: white;
                        border-radius: 10px;
                        overflow: hidden;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .btn-work {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        padding: 10px 30px;
                        border-radius: 25px;
                        font-weight: 500;
                    }

                    .btn-work:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                    }

                    .time-slot-card {
                        border: 2px solid #e0e0e0;
                        border-radius: 8px;
                        padding: 15px;
                        margin-bottom: 15px;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .time-slot-card:hover {
                        border-color: #667eea;
                        background: #f8f9ff;
                    }

                    .time-slot-card.selected {
                        border-color: #667eea;
                        background: #e8f4f8;
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
                                            <i class="fas fa-calendar-plus me-2"></i>
                                            Đăng ký lịch làm việc
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

                                    <!-- Calendar và Form đăng ký -->
                                    <div class="row">
                                        <!-- Calendar View -->
                                        <div class="col-md-8">
                                            <div class="calendar-container">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <h5>
                                                        <i class="fas fa-calendar me-2"></i>
                                                        Lịch làm việc tháng ${currentMonth}/${currentYear}
                                                    </h5>
                                                    <div class="d-flex">
                                                        <button class="btn btn-outline-primary btn-sm me-2"
                                                            onclick="changeMonth(-1)">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </button>
                                                        <button class="btn btn-outline-primary btn-sm"
                                                            onclick="changeMonth(1)">
                                                            <i class="fas fa-chevron-right"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <!-- Calendar Grid -->
                                                <div class="calendar-grid">
                                                    <!-- Headers -->
                                                    <div class="calendar-header">CN</div>
                                                    <div class="calendar-header">T2</div>
                                                    <div class="calendar-header">T3</div>
                                                    <div class="calendar-header">T4</div>
                                                    <div class="calendar-header">T5</div>
                                                    <div class="calendar-header">T6</div>
                                                    <div class="calendar-header">T7</div>

                                                    <!-- Days - Simple implementation for demo -->
                                                    <c:forEach begin="1" end="31" var="day">
                                                        <div
                                                            class="calendar-day <c:if test='${day == java.time.LocalDate.now().dayOfMonth}'>today</c:if>">
                                                            <div class="day-number">${day}</div>
                                                            <!-- Check if this day has schedule -->
                                                            <c:forEach var="schedule" items="${scheduleRequests}">
                                                                <fmt:formatDate value="${schedule.workDate}" pattern="d"
                                                                    var="scheduleDay" />
                                                                <c:if test="${scheduleDay == day}">
                                                                    <div class="schedule-info">
                                                                        ${schedule.slotName != null ? schedule.slotName
                                                                        : 'Nghỉ phép'}
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Form đăng ký -->
                                        <div class="col-md-4">
                                            <div class="work-form">
                                                <h5 class="mb-4">
                                                    <i class="fas fa-plus-circle me-2"></i>
                                                    Đăng ký ca làm việc
                                                </h5>

                                                <form method="post" action="StaffScheduleServlet" id="workForm">
                                                    <div class="mb-3">
                                                        <label for="workDate" class="form-label">
                                                            <i class="fas fa-calendar-day me-1"></i>
                                                            Ngày làm việc <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="date" class="form-control" id="workDate"
                                                            name="workDate"
                                                            min="<fmt:formatDate value='${java.util.Date}' pattern='yyyy-MM-dd'/>"
                                                            required>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">
                                                            <i class="fas fa-clock me-1"></i>
                                                            Chọn ca làm việc <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="hidden" id="slotId" name="slotId" required>

                                                        <div class="time-slots-container">
                                                            <c:if test="${empty timeSlots}">
                                                                <div class="alert alert-info">
                                                                    <i class="fas fa-info-circle me-2"></i>
                                                                    Không có ca làm việc nào được cấu hình
                                                                </div>
                                                            </c:if>
                                                            <c:forEach var="timeSlot" items="${timeSlots}">
                                                                <c:if test="${not empty timeSlot}">
                                                                    <div class="time-slot-card"
                                                                        onclick="selectTimeSlot('${timeSlot.slotId}', this)">
                                                                        <div
                                                                            class="d-flex justify-content-between align-items-center">
                                                                            <div>
                                                                                <strong>${timeSlot.slotName}</strong>
                                                                                <br>
                                                                                <small class="text-muted">
                                                                                    ${timeSlot.displayTime}
                                                                                </small>
                                                                            </div>
                                                                            <i
                                                                                class="fas fa-circle-check text-success d-none check-icon"></i>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <button type="submit" class="btn btn-primary btn-work w-100">
                                                        <i class="fas fa-paper-plane me-2"></i>
                                                        Đăng ký ca làm việc
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Lịch sử đăng ký -->
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="schedule-history">
                                                <div class="card-header bg-white border-bottom">
                                                    <h5 class="mb-0">
                                                        <i class="fas fa-history me-2"></i>
                                                        Lịch sử đăng ký ca làm việc
                                                    </h5>
                                                </div>

                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Ngày làm việc</th>
                                                                <th>Ca làm việc</th>
                                                                <th>Loại yêu cầu</th>
                                                                <th>Trạng thái</th>
                                                                <th>Ngày tạo</th>
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
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty request.slotName}">
                                                                                        <span
                                                                                            class="badge bg-info">${request.slotName}</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <em class="text-muted">Không có
                                                                                            ca</em>
                                                                                    </c:otherwise>
                                                                                </c:choose>
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
                                                                                <fmt:formatDate
                                                                                    value="${request.createdAt}"
                                                                                    pattern="dd/MM/yyyy HH:mm" />
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
                                                                        <td colspan="6" class="text-center py-4">
                                                                            <i
                                                                                class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                                            <br>
                                                                            <em class="text-muted">Chưa có đăng ký ca
                                                                                làm việc nào trong tháng này</em>
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
                        // Chọn ca làm việc
                        function selectTimeSlot(slotId, element) {
                            // Remove previous selection
                            document.querySelectorAll('.time-slot-card').forEach(card => {
                                card.classList.remove('selected');
                                card.querySelector('.check-icon').classList.add('d-none');
                            });

                            // Add selection to clicked card
                            element.classList.add('selected');
                            element.querySelector('.check-icon').classList.remove('d-none');

                            // Set hidden input value
                            document.getElementById('slotId').value = parseInt(slotId);
                        }

                        // Chuyển tháng
                        function changeMonth(direction) {
                            const currentMonth = parseInt('${currentMonth}');
                            const currentYear = parseInt('${currentYear}');

                            let newMonth = currentMonth + direction;
                            let newYear = currentYear;

                            if (newMonth > 12) {
                                newMonth = 1;
                                newYear++;
                            } else if (newMonth < 1) {
                                newMonth = 12;
                                newYear--;
                            }

                            window.location.href = 'StaffScheduleServlet?month=' + newMonth + '&year=' + newYear;
                        }

                        // Set ngày tối thiểu là ngày mai
                        document.addEventListener('DOMContentLoaded', function () {
                            const today = new Date();
                            const tomorrow = new Date(today);
                            tomorrow.setDate(tomorrow.getDate() + 1);

                            const dateInput = document.getElementById('workDate');
                            if (dateInput) {
                                dateInput.min = tomorrow.toISOString().split('T')[0];
                            }
                        });

                        // Validate form
                        document.getElementById('workForm').addEventListener('submit', function (e) {
                            const slotId = document.getElementById('slotId').value;
                            if (!slotId) {
                                e.preventDefault();
                                alert('Vui lòng chọn ca làm việc!');
                                return false;
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