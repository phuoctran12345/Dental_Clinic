<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="../doctor/doctor_header.jsp" %>
        <%@ include file="../doctor/doctor_menu.jsp" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Quản lý lịch hẹn - Phòng khám nha khoa</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                            rel="stylesheet">
                        <style>
                            body {
                                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                                min-height: 100vh;
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            }

                            .appointments-container {
                                background: white;
                                border-radius: 15px;
                                box-shadow: 0 8px 25px rgba(59, 130, 246, 0.1);
                                padding: 30px;
                                margin: 20px 0;
                            }

                            .appointment-card {
                                border: 1px solid #e5e7eb;
                                border-radius: 10px;
                                padding: 20px;
                                margin: 15px 0;
                                transition: all 0.3s ease;
                            }

                            .appointment-card:hover {
                                box-shadow: 0 4px 15px rgba(59, 130, 246, 0.1);
                                transform: translateY(-2px);
                            }

                            .appointment-card.booked {
                                border-left: 4px solid #3b82f6;
                            }

                            .appointment-card.completed {
                                border-left: 4px solid #10b981;
                            }

                            .appointment-card.cancelled {
                                border-left: 4px solid #ef4444;
                            }

                            .status-badge {
                                padding: 5px 12px;
                                border-radius: 20px;
                                font-size: 0.85em;
                                font-weight: 600;
                            }

                            .status-booked {
                                background: #dbeafe;
                                color: #1e40af;
                            }

                            .status-completed {
                                background: #d1fae5;
                                color: #065f46;
                            }

                            .status-cancelled {
                                background: #fee2e2;
                                color: #991b1b;
                            }

                            .time-badge {
                                background: linear-gradient(45deg, #3b82f6, #1e40af);
                                color: white;
                                padding: 8px 15px;
                                border-radius: 20px;
                                font-weight: 600;
                            }

                            .btn-primary {
                                background: linear-gradient(45deg, #3b82f6, #1e40af);
                                border: none;
                                border-radius: 8px;
                                padding: 8px 16px;
                                font-weight: 600;
                                transition: all 0.3s ease;
                            }

                            .btn-primary:hover {
                                background: linear-gradient(45deg, #1e40af, #1e3a8a);
                                transform: translateY(-1px);
                            }

                            .btn-success {
                                background: linear-gradient(45deg, #10b981, #059669);
                                border: none;
                                border-radius: 8px;
                                padding: 8px 16px;
                                font-weight: 600;
                            }

                            .btn-warning {
                                background: linear-gradient(45deg, #f59e0b, #d97706);
                                border: none;
                                border-radius: 8px;
                                padding: 8px 16px;
                                font-weight: 600;
                            }

                            .filter-section {
                                background: #f8f9fa;
                                border-radius: 10px;
                                padding: 20px;
                                margin-bottom: 30px;
                            }

                            .form-control {
                                border: 2px solid #e5e7eb;
                                border-radius: 8px;
                                padding: 10px 15px;
                                transition: all 0.3s ease;
                            }

                            .form-control:focus {
                                border-color: #3b82f6;
                                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                            }

                            .stats-card {
                                background: linear-gradient(135deg, #3b82f6, #1e40af);
                                color: white;
                                border-radius: 10px;
                                padding: 20px;
                                margin: 10px 0;
                            }

                            .reschedule-modal .modal-content {
                                border-radius: 15px;
                            }

                            .reschedule-modal .modal-header {
                                background: linear-gradient(135deg, #3b82f6, #1e40af);
                                color: white;
                                border-radius: 15px 15px 0 0;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="container">
                            <div class="appointments-container">
                                <!-- Header -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2><i class="fas fa-calendar-check me-2"></i>Quản lý lịch hẹn</h2>
                                    <a href="doctor_leave_request.jsp" class="btn btn-warning">
                                        <i class="fas fa-calendar-times me-2"></i>Đăng ký nghỉ
                                    </a>
                                </div>

                                <!-- Thống kê -->
                                <div class="row mb-4">
                                    <div class="col-md-3">
                                        <div class="stats-card text-center">
                                            <h4>${stats.total}</h4>
                                            <p class="mb-0">Tổng lịch hẹn</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stats-card text-center">
                                            <h4>${stats.booked}</h4>
                                            <p class="mb-0">Đã đặt</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stats-card text-center">
                                            <h4>${stats.completed}</h4>
                                            <p class="mb-0">Hoàn thành</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stats-card text-center">
                                            <h4>${stats.cancelled}</h4>
                                            <p class="mb-0">Đã hủy</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Bộ lọc -->
                                <div class="filter-section">
                                    <form id="filterForm" method="GET">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <label class="form-label">Trạng thái:</label>
                                                <select name="status" class="form-control"
                                                    onchange="this.form.submit()">
                                                    <option value="">Tất cả</option>
                                                    <option value="BOOKED" ${param.status=='BOOKED' ? 'selected' : '' }>
                                                        Đã đặt</option>
                                                    <option value="COMPLETED" ${param.status=='COMPLETED' ? 'selected'
                                                        : '' }>Hoàn thành</option>
                                                    <option value="CANCELLED" ${param.status=='CANCELLED' ? 'selected'
                                                        : '' }>Đã hủy</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Từ ngày:</label>
                                                <input type="date" name="fromDate" class="form-control"
                                                    value="${param.fromDate}" onchange="this.form.submit()">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Đến ngày:</label>
                                                <input type="date" name="toDate" class="form-control"
                                                    value="${param.toDate}" onchange="this.form.submit()">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Tìm kiếm:</label>
                                                <input type="text" name="search" class="form-control"
                                                    placeholder="Tên bệnh nhân..." value="${param.search}"
                                                    onchange="this.form.submit()">
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <!-- Danh sách lịch hẹn -->
                                <div id="appointmentsList">
                                    <c:forEach items="${appointments}" var="appointment">
                                        <div class="appointment-card ${appointment.status.toLowerCase()}">
                                            <div class="row align-items-center">
                                                <div class="col-md-3">
                                                    <h6 class="mb-1">
                                                        <i class="fas fa-user me-2"></i>${appointment.patientName}
                                                    </h6>
                                                    <small class="text-muted">${appointment.patientPhone}</small>
                                                </div>
                                                <div class="col-md-2">
                                                    <span class="time-badge">
                                                        <i class="fas fa-clock me-1"></i>${appointment.timeSlot}
                                                    </span>
                                                </div>
                                                <div class="col-md-2">
                                                    <span
                                                        class="status-badge status-${appointment.status.toLowerCase()}">
                                                        ${appointment.statusDisplay}
                                                    </span>
                                                </div>
                                                <div class="col-md-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${appointment.workDate}"
                                                            pattern="dd/MM/yyyy" />
                                                    </small>
                                                </div>
                                                <div class="col-md-3 text-end">
                                                    <c:if test="${appointment.status == 'BOOKED'}">
                                                        <button class="btn btn-primary btn-sm me-2"
                                                            onclick="viewAppointment(${appointment.appointmentId})">
                                                            <i class="fas fa-eye me-1"></i>Chi tiết
                                                        </button>
                                                        <button class="btn btn-warning btn-sm"
                                                            onclick="showRescheduleModal(${appointment.appointmentId})">
                                                            <i class="fas fa-exchange-alt me-1"></i>Chuyển lịch
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${appointment.status == 'COMPLETED'}">
                                                        <button class="btn btn-success btn-sm"
                                                            onclick="viewReport(${appointment.appointmentId})">
                                                            <i class="fas fa-file-medical me-1"></i>Xem báo cáo
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${not empty appointment.reason}">
                                                <div class="mt-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-comment me-1"></i>Lý do: ${appointment.reason}
                                                    </small>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty appointments}">
                                        <div class="text-center py-5">
                                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Không có lịch hẹn nào</h5>
                                            <p class="text-muted">Hãy thử thay đổi bộ lọc để tìm kiếm</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Modal chuyển lịch -->
                        <div class="modal fade reschedule-modal" id="rescheduleModal" tabindex="-1">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <i class="fas fa-exchange-alt me-2"></i>Chuyển lịch hẹn
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div id="rescheduleContent">
                                            <div class="text-center">
                                                <div class="spinner-border" role="status">
                                                    <span class="visually-hidden">Đang tải...</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Xem chi tiết lịch hẹn
                            function viewAppointment(appointmentId) {
                                window.open('doctor_appointment_detail.jsp?id=' + appointmentId, '_blank');
                            }

                            // Xem báo cáo
                            function viewReport(appointmentId) {
                                window.open('doctor_medical_report.jsp?appointmentId=' + appointmentId, '_blank');
                            }

                            // Hiển thị modal chuyển lịch
                            function showRescheduleModal(appointmentId) {
                                const modal = new bootstrap.Modal(document.getElementById('rescheduleModal'));
                                modal.show();

                                // Load nội dung chuyển lịch
                                loadRescheduleContent(appointmentId);
                            }

                            // Load nội dung chuyển lịch
                            function loadRescheduleContent(appointmentId) {
                                const content = document.getElementById('rescheduleContent');
                                content.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"></div></div>';

                                fetch('${pageContext.request.contextPath}/RescheduleAppointmentServlet?action=get_reschedule_options&appointmentId=' + appointmentId)
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            displayRescheduleOptions(data, appointmentId);
                                        } else {
                                            content.innerHTML = '<div class="alert alert-danger">' + data.message + '</div>';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        content.innerHTML = '<div class="alert alert-danger">Có lỗi xảy ra khi tải thông tin</div>';
                                    });
                            }

                            // Hiển thị tùy chọn chuyển lịch
                            function displayRescheduleOptions(data, appointmentId) {
                                const content = document.getElementById('rescheduleContent');

                                let html = `
                <div class="mb-3">
                    <h6>Thông tin lịch hẹn hiện tại:</h6>
                    <div class="alert alert-info">
                        <strong>Bệnh nhân:</strong> ${data.currentAppointment.patientName}<br>
                        <strong>Thời gian:</strong> ${data.currentAppointment.timeSlot}<br>
                        <strong>Ngày:</strong> ${data.currentAppointment.workDate}
                    </div>
                </div>
            `;

                                if (data.availableDoctors.length > 0) {
                                    html += `
                    <div class="mb-3">
                        <h6>Chọn bác sĩ thay thế:</h6>
                        <div class="row">
                `;

                                    data.availableDoctors.forEach(doctor => {
                                        html += `
                        <div class="col-md-6 mb-2">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">${doctor.fullName}</h6>
                                    <p class="card-text small">${doctor.specialty}</p>
                                    <button class="btn btn-primary btn-sm" onclick="selectReplacementDoctor(${appointmentId}, ${doctor.doctorId})">
                                        Chọn bác sĩ này
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                                    });

                                    html += `
                        </div>
                    </div>
                `;
                                } else {
                                    html += `
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Không có bác sĩ thay thế khả dụng. Hệ thống sẽ tự động hủy lịch hẹn.
                    </div>
                `;
                                }

                                html += `
                <div class="text-center mt-3">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-warning" onclick="autoReschedule(${appointmentId})">
                        <i class="fas fa-magic me-2"></i>Tự động chuyển lịch
                    </button>
                </div>
            `;

                                content.innerHTML = html;
                            }

                            // Chọn bác sĩ thay thế
                            function selectReplacementDoctor(appointmentId, newDoctorId) {
                                if (confirm('Bạn có chắc chắn muốn chuyển lịch hẹn sang bác sĩ này?')) {
                                    performReschedule(appointmentId, newDoctorId);
                                }
                            }

                            // Tự động chuyển lịch
                            function autoReschedule(appointmentId) {
                                if (confirm('Hệ thống sẽ tự động tìm bác sĩ thay thế phù hợp nhất. Tiếp tục?')) {
                                    performReschedule(appointmentId, null);
                                }
                            }

                            // Thực hiện chuyển lịch
                            function performReschedule(appointmentId, newDoctorId) {
                                const formData = new FormData();
                                formData.append('action', 'auto_reschedule');
                                formData.append('appointmentId', appointmentId);
                                if (newDoctorId) {
                                    formData.append('newDoctorId', newDoctorId);
                                }

                                fetch('${pageContext.request.contextPath}/RescheduleAppointmentServlet', {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            alert('✅ Chuyển lịch hẹn thành công!\n\n' + data.message);
                                            bootstrap.Modal.getInstance(document.getElementById('rescheduleModal')).hide();
                                            window.location.reload();
                                        } else {
                                            alert('❌ Có lỗi xảy ra: ' + data.message);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('❌ Có lỗi xảy ra khi chuyển lịch hẹn');
                                    });
                            }
                        </script>
                    </body>

                    </html>