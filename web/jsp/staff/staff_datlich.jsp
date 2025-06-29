<%-- Document : user_datlich Created on : 11 thg 6, 2025, 00:44:05 Author : tranhongphuoc --%>

    <%@ page contentType="text/html; charset=UTF-8" %>
        <%@ include file="/jsp/staff/staff_header.jsp" %>
            <%@ include file="/jsp/staff/staff_menu.jsp" %>
                <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                            <%@ page import="dao.ServiceDAO" %>
                                <%@ page import="model.Service" %>
                                    <%@ page import="java.util.List" %>
                                        <!DOCTYPE html>
                                        <html lang="vi">

                                        <head>
                                            <meta charset="UTF-8">
                                            <title>Quản lý lịch hẹn</title>
                                            <link
                                                href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                                rel="stylesheet">
                                            <link rel="stylesheet"
                                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                                            <link rel="stylesheet"
                                                href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                                            <style>
                                                body {
                                                    font-family: 'Segoe UI', sans-serif;
                                                    background: #f5f5f5;
                                                    margin: 0;
                                                }

                                                .container {
                                                    margin-left: 270px;
                                                    padding: 30px;
                                                }

                                                .stats-cards {
                                                    display: grid;
                                                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                                    gap: 20px;
                                                    margin-bottom: 30px;
                                                }

                                                .stat-card {
                                                    background: white;
                                                    padding: 20px;
                                                    border-radius: 10px;
                                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                                    text-align: center;
                                                }

                                                .stat-card h3 {
                                                    margin: 0;
                                                    font-size: 2em;
                                                    color: #2c5aa0;
                                                }

                                                .stat-card p {
                                                    margin: 5px 0 0 0;
                                                    color: #666;
                                                }

                                                .appointment-table {
                                                    background: white;
                                                    border-radius: 10px;
                                                    padding: 20px;
                                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                                }

                                                .btn-new-appointment {
                                                    background: #28a745;
                                                    color: white;
                                                    border: none;
                                                    padding: 12px 25px;
                                                    border-radius: 8px;
                                                    font-size: 16px;
                                                    margin-bottom: 20px;
                                                }

                                                .btn-new-appointment:hover {
                                                    background: #218838;
                                                    color: white;
                                                }

                                                .modal-header {
                                                    background: #f8f9fa;
                                                    border-bottom: 1px solid #dee2e6;
                                                }

                                                .form-step {
                                                    display: none;
                                                }

                                                .form-step.active {
                                                    display: block;
                                                }

                                                .step-indicator {
                                                    display: flex;
                                                    justify-content: space-between;
                                                    margin-bottom: 30px;
                                                }

                                                .step {
                                                    flex: 1;
                                                    text-align: center;
                                                    padding: 10px;
                                                    background: #e9ecef;
                                                    border-radius: 5px;
                                                    margin: 0 5px;
                                                    position: relative;
                                                }

                                                .step.active {
                                                    background: #007bff;
                                                    color: white;
                                                }

                                                .step.completed {
                                                    background: #28a745;
                                                    color: white;
                                                }

                                                .patient-item {
                                                    border: 1px solid #ddd;
                                                    border-radius: 5px;
                                                    padding: 15px;
                                                    margin-bottom: 10px;
                                                    cursor: pointer;
                                                    transition: all 0.3s ease;
                                                    background: #f8f9fa;
                                                }

                                                .patient-item:hover {
                                                    background: #e3f2fd;
                                                    border-color: #007bff;
                                                    transform: translateY(-2px);
                                                    box-shadow: 0 4px 8px rgba(0, 123, 255, 0.2);
                                                }

                                                .patient-item.selected {
                                                    background: #007bff;
                                                    color: white;
                                                    border-color: #007bff;
                                                }

                                                .patient-item.selected small {
                                                    color: #e3f2fd !important;
                                                }

                                                .service-item {
                                                    border: 1px solid #ddd;
                                                    border-radius: 8px;
                                                    padding: 15px;
                                                    margin: 10px 0;
                                                    cursor: pointer;
                                                    transition: all 0.3s;
                                                }

                                                .service-item:hover {
                                                    border-color: #007bff;
                                                    background: #f8f9fa;
                                                }

                                                .service-item.selected {
                                                    border-color: #007bff;
                                                    background: #e3f2fd;
                                                }

                                                .time-slots {
                                                    display: grid;
                                                    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                                                    gap: 10px;
                                                    margin-top: 15px;
                                                }

                                                .time-slot {
                                                    padding: 10px;
                                                    text-align: center;
                                                    border: 1px solid #ddd;
                                                    border-radius: 5px;
                                                    cursor: pointer;
                                                    transition: all 0.2s;
                                                }

                                                .time-slot:hover {
                                                    background: #f8f9fa;
                                                    border-color: #007bff;
                                                }

                                                .time-slot.selected {
                                                    background: #007bff;
                                                    color: white;
                                                    border-color: #007bff;
                                                }

                                                .search-section {
                                                    background: white;
                                                    padding: 20px;
                                                    border-radius: 10px;
                                                    margin-bottom: 20px;
                                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                                }
                                            </style>
                                        </head>

                                        <body>
                                            <div class="container">
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <h2><i class="fas fa-calendar-check me-2"></i>Quản lý lịch hẹn</h2>
                                                    <button class="btn btn-new-appointment" data-bs-toggle="modal"
                                                        data-bs-target="#newAppointmentModal">
                                                        <i class="fas fa-plus me-2"></i>Đặt lịch mới
                                                    </button>
                                                </div>

                                                <!-- Thống kê -->
                                                <div class="stats-cards">
                                                    <div class="stat-card">
                                                        <h3>5</h3>
                                                        <p>Tổng lịch hẹn</p>
                                                    </div>
                                                    <div class="stat-card">
                                                        <h3>0</h3>
                                                        <p>Hôm nay</p>
                                                    </div>
                                                    <div class="stat-card">
                                                        <h3>2</h3>
                                                        <p>Đã xác nhận</p>
                                                    </div>
                                                    <div class="stat-card">
                                                        <h3>1</h3>
                                                        <p>Chờ xác nhận</p>
                                                    </div>
                                                    <div class="stat-card">
                                                        <h3>1</h3>
                                                        <p>Hoàn thành</p>
                                                    </div>
                                                </div>

                                                <!-- Hiển thị thông báo -->
                                                <c:if test="${not empty error}">
                                                    <div class="alert alert-danger alert-dismissible fade show"
                                                        role="alert">
                                                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                                                        <button type="button" class="btn-close"
                                                            data-bs-dismiss="alert"></button>
                                                    </div>
                                                </c:if>

                                                <c:if test="${not empty success}">
                                                    <div class="alert alert-success alert-dismissible fade show"
                                                        role="alert">
                                                        <i class="fas fa-check-circle me-2"></i>${success}
                                                        <button type="button" class="btn-close"
                                                            data-bs-dismiss="alert"></button>
                                                    </div>
                                                </c:if>

                                                <!-- Tìm kiếm -->
                                                <div class="search-section">
                                                    <h5><i class="fas fa-search me-2"></i>Tìm kiếm lịch hẹn</h5>
                                                    <form method="GET"
                                                        action="${pageContext.request.contextPath}/StaffBookingServlet">
                                                        <div class="row g-3">
                                                            <div class="col-md-3">
                                                                <input type="text" name="patientName"
                                                                    class="form-control" placeholder="Tên bệnh nhân">
                                                            </div>
                                                            <div class="col-md-3">
                                                                <input type="date" name="appointmentDate"
                                                                    class="form-control">
                                                            </div>
                                                            <div class="col-md-3">
                                                                <select name="status" class="form-select">
                                                                    <option value="">Tất cả trạng thái</option>
                                                                    <option value="Chờ xác nhận">Chờ xác nhận</option>
                                                                    <option value="Đã xác nhận">Đã xác nhận</option>
                                                                    <option value="Hoàn thành">Hoàn thành</option>
                                                                    <option value="Đã hủy">Đã hủy</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <button type="submit" class="btn btn-primary w-100">
                                                                    <i class="fas fa-search me-1"></i>Tìm kiếm
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Danh sách lịch hẹn -->
                                                <div class="appointment-table">
                                                    <h5><i class="fas fa-list me-2"></i>Danh sách lịch hẹn hôm nay</h5>
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th>STT</th>
                                                                    <th>Thời gian</th>
                                                                    <th>Bệnh nhân</th>
                                                                    <th>Bác sĩ</th>
                                                                    <th>Dịch vụ</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty todayAppointments}">
                                                                        <tr>
                                                                            <td colspan="7" class="text-center py-4">
                                                                                <i class="fas fa-calendar-times text-muted"
                                                                                    style="font-size: 3em;"></i>
                                                                                <p class="text-muted mt-2">Chưa có lịch
                                                                                    hẹn nào hôm
                                                                                    nay
                                                                                </p>
                                                                            </td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach items="${todayAppointments}"
                                                                            var="apt" varStatus="status">
                                                                            <tr>
                                                                                <td>${status.index + 1}</td>
                                                                                <td>
                                                                                    ${apt.workDate}<br>
                                                                                    <small
                                                                                        class="text-muted">${apt.startTime}
                                                                                        -
                                                                                        ${apt.endTime}</small>
                                                                                </td>
                                                                                <td>
                                                                                    <strong>${apt.patientName}</strong><br>
                                                                                    <small
                                                                                        class="text-muted">${apt.patientPhone}</small>
                                                                                </td>
                                                                                <td>${apt.doctorName}</td>
                                                                                <td>${apt.serviceName}</td>
                                                                                <td>
                                                                                    <span class="badge ${apt.status == 'Đã xác nhận' ? 'bg-success' : 
                           apt.status == 'Chờ xác nhận' ? 'bg-warning' : 
                           apt.status == 'Hoàn thành' ? 'bg-primary' : 'bg-danger'}">
                                                                                        ${apt.status}
                                                                                    </span>
                                                                                </td>
                                                                                <td>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-primary me-1"
                                                                                        title="Xem chi tiết"
                                                                                        data-appointment-id="${apt.appointmentId}"
                                                                                        onclick="viewAppointmentDetail(this)">
                                                                                        <i class="fas fa-eye"></i>
                                                                                    </button>
                                                                                    <c:if
                                                                                        test="${apt.status != 'Đã xác nhận' && apt.status != 'Hoàn thành'}">
                                                                                        <button
                                                                                            class="btn btn-sm btn-outline-success me-1"
                                                                                            title="Xác nhận"
                                                                                            data-appointment-id="${apt.appointmentId}"
                                                                                            onclick="confirmAppointment(this)">
                                                                                            <i class="fas fa-check"></i>
                                                                                        </button>
                                                                                    </c:if>
                                                                                    <c:if
                                                                                        test="${apt.status != 'Hoàn thành' && apt.status != 'Đã hủy'}">
                                                                                        <button
                                                                                            class="btn btn-sm btn-outline-danger"
                                                                                            title="Hủy"
                                                                                            data-appointment-id="${apt.appointmentId}"
                                                                                            onclick="cancelAppointment(this)">
                                                                                            <i class="fas fa-times"></i>
                                                                                        </button>
                                                                                    </c:if>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Modal đặt lịch mới -->
                                            <div class="modal fade" id="newAppointmentModal" tabindex="-1"
                                                aria-labelledby="newAppointmentModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="newAppointmentModalLabel">
                                                                <i class="fas fa-calendar-plus me-2"></i>Đặt lịch hẹn
                                                                mới
                                                            </h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <!-- Chỉ báo bước -->
                                                            <div class="step-indicator">
                                                                <div class="step active" id="step1">1. Chọn bệnh nhân
                                                                </div>
                                                                <div class="step" id="step2">2. Chọn dịch vụ</div>
                                                                <div class="step" id="step3">3. Chọn bác sĩ & thời gian
                                                                </div>
                                                                <div class="step" id="step4">4. Xác nhận</div>
                                                            </div>

                                                            <form id="appointmentForm"
                                                                action="${pageContext.request.contextPath}/StaffBookingServlet"
                                                                method="post">
                                                                <input type="hidden" name="action"
                                                                    value="book_appointment">

                                                                <!-- Bước 1: Chọn bệnh nhân -->
                                                                <div class="form-step active" id="step1Content">
                                                                    <h6>Tìm kiếm và chọn bệnh nhân</h6>
                                                                    <div class="row mb-3">
                                                                        <div class="col-md-6">
                                                                            <input type="text" id="patientSearch"
                                                                                class="form-control"
                                                                                placeholder="Nhập tên hoặc số điện thoại">
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <button type="button"
                                                                                class="btn btn-outline-primary"
                                                                                onclick="searchPatients()">
                                                                                <i class="fas fa-search me-1"></i>Tìm
                                                                                kiếm
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                    <div id="patientResults">
                                                                        <!-- Kết quả tìm kiếm bệnh nhân sẽ hiển thị ở đây -->
                                                                    </div>
                                                                    <input type="hidden" name="patientId"
                                                                        id="selectedPatientId">
                                                                </div>

                                                                <!-- Bước 2: Chọn dịch vụ -->
                                                                <div class="form-step" id="step2Content">
                                                                    <h6>Chọn dịch vụ khám</h6>

                                                                    <!-- Fallback: Load services trực tiếp nếu servlet không có -->
                                                                    <c:if test="${empty services}">
                                                                        <% try { dao.ServiceDAO fallbackDAO=new
                                                                            dao.ServiceDAO();
                                                                            java.util.List<model.Service>
                                                                            fallbackServices =
                                                                            fallbackDAO.getAllServices();
                                                                            request.setAttribute("services",
                                                                            fallbackServices);
                                                                            } catch (Exception e) {
                                                                            // Ignore
                                                                            }
                                                                            %>
                                                                    </c:if>

                                                                    <!-- Debug info -->
                                                                    <div class="alert alert-info mb-3">
                                                                        <strong>Debug:</strong> Số dịch vụ:
                                                                        ${fn:length(services)}
                                                                        <c:if test="${empty services}">
                                                                            <br><span class="text-warning">⚠️ Không load
                                                                                được dịch vụ!</span>
                                                                        </c:if>
                                                                    </div>

                                                                    <div class="row">
                                                                        <c:choose>
                                                                            <c:when test="${empty services}">
                                                                                <div class="col-12">
                                                                                    <div
                                                                                        class="alert alert-warning text-center">
                                                                                        <i
                                                                                            class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                                                                                        <h5>Không có dịch vụ nào</h5>
                                                                                        <p>Vấn đề với ServiceDAO hoặc
                                                                                            database connection</p>
                                                                                    </div>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach items="${services}"
                                                                                    var="service">
                                                                                    <div class="col-md-6 mb-2">
                                                                                        <div class="service-item" style="
                                                                                            border: 2px solid #dee2e6; 
                                                                                            background: #f8f9fa; 
                                                                                            padding: 15px; 
                                                                                            border-radius: 8px; 
                                                                                            cursor: pointer;
                                                                                            transition: all 0.3s ease;
                                                                                        " onmouseover="this.style.borderColor='#007bff'; this.style.background='#e3f2fd';"
                                                                                            onmouseout="this.style.borderColor='#dee2e6'; this.style.background='#f8f9fa';"
                                                                                            data-service-id="${service.serviceId}"
                                                                                            data-service-name="${service.serviceName}"
                                                                                            data-service-price="${service.price}"
                                                                                            onclick="selectService(this)">
                                                                                            <h6
                                                                                                style="color: #007bff; margin-bottom: 8px;">
                                                                                                ${service.serviceName}
                                                                                            </h6>
                                                                                            <p class="text-muted mb-2"
                                                                                                style="font-size: 0.9em;">
                                                                                                ${service.description}
                                                                                            </p>
                                                                                            <div
                                                                                                class="d-flex justify-content-between align-items-center">
                                                                                                <span
                                                                                                    class="badge bg-info">${service.category}</span>
                                                                                                <strong
                                                                                                    class="text-success">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${service.price}"
                                                                                                        pattern="#,##0" />
                                                                                                    VNĐ
                                                                                                </strong>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </c:forEach>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <input type="hidden" name="serviceId"
                                                                        id="selectedServiceId">
                                                                </div>

                                                                <!-- Bước 3: Chọn bác sĩ và thời gian -->
                                                                <div class="form-step" id="step3Content">
                                                                    <h6>Chọn bác sĩ và thời gian</h6>

                                                                    <!-- Debug info cho doctors -->
                                                                    <div class="alert alert-info mb-3">
                                                                        <strong>Debug:</strong> Có ${fn:length(doctors)}
                                                                        bác sĩ trong hệ thống
                                                                        <c:if test="${empty doctors}">
                                                                            <br><span class="text-warning">⚠️ Không có
                                                                                bác sĩ nào!</span>
                                                                        </c:if>
                                                                    </div>

                                                                    <div class="row mb-3">
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Chọn bác
                                                                                sĩ:</label>
                                                                            <select name="doctorId" id="doctorSelect"
                                                                                class="form-select"
                                                                                onchange="loadTimeSlots()">
                                                                                <option value="">-- Chọn bác sĩ --
                                                                                </option>
                                                                                <c:choose>
                                                                                    <c:when test="${empty doctors}">
                                                                                        <option disabled>Không có bác sĩ
                                                                                            nào</option>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <c:forEach items="${doctors}"
                                                                                            var="doctor">
                                                                                            <option
                                                                                                value="${doctor.doctorId}">
                                                                                                ${doctor.fullName} -
                                                                                                ${doctor.specialty}
                                                                                            </option>
                                                                                        </c:forEach>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Chọn ngày:</label>
                                                                            <input type="date" name="workDate"
                                                                                id="workDateInput" class="form-control"
                                                                                onchange="loadTimeSlots()">
                                                                        </div>
                                                                    </div>
                                                                    <div id="timeSlotsContainer" style="display: none;">
                                                                        <label class="form-label">Chọn giờ khám:</label>
                                                                        <div class="alert alert-info"
                                                                            id="timeSlotsDebug" style="display: none;">
                                                                            <strong>Debug TimeSlots:</strong> <span
                                                                                id="timeSlotsCount">0</span> khung giờ
                                                                        </div>
                                                                        <div class="time-slots" id="timeSlots">
                                                                            <!-- Khung giờ sẽ được load bằng AJAX -->
                                                                        </div>
                                                                    </div>
                                                                    <input type="hidden" name="slotId"
                                                                        id="selectedSlotId">
                                                                </div>

                                                                <!-- Bước 4: Xác nhận và lý do khám -->
                                                                <div class="form-step" id="step4Content">
                                                                    <h6>Xác nhận thông tin và lý do khám</h6>

                                                                    <div class="card mb-3">
                                                                        <div class="card-body">
                                                                            <h6 class="card-title">Thông tin đặt lịch
                                                                            </h6>
                                                                            <div id="appointmentSummary">
                                                                                <!-- Tóm tắt thông tin đặt lịch -->
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-3">
                                                                        <label class="form-label">Lý do khám / Ghi
                                                                            chú:</label>
                                                                        <textarea name="reason" class="form-control"
                                                                            rows="3"
                                                                            placeholder="Nhập lý do khám bệnh hoặc ghi chú..."></textarea>
                                                                    </div>
                                                                </div>
                                                            </form>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" id="prevBtn"
                                                                onclick="previousStep()" style="display: none;">
                                                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                                                            </button>
                                                            <button type="button" class="btn btn-primary" id="nextBtn"
                                                                onclick="nextStep()">
                                                                Tiếp theo<i class="fas fa-arrow-right ms-1"></i>
                                                            </button>
                                                            <button type="submit" class="btn btn-success" id="submitBtn"
                                                                form="appointmentForm" style="display: none;">
                                                                <i class="fas fa-check me-1"></i>Đặt lịch
                                                            </button>
                                                            <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Đóng</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            </div>

                                            <script
                                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                            <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                                            <script>
                                                let currentStep = 1;
                                                const totalSteps = 4;
                                                let selectedPatient = null;
                                                let selectedService = null;
                                                let selectedDoctor = null;
                                                let selectedSlot = null;

                                                // Khởi tạo datepicker
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    flatpickr("#workDateInput", {
                                                        dateFormat: "Y-m-d",
                                                        minDate: "today",
                                                        locale: "vn"
                                                    });
                                                });

                                                // Điều hướng bước
                                                function nextStep() {
                                                    if (validateCurrentStep()) {
                                                        if (currentStep < totalSteps) {
                                                            document.getElementById('step' + currentStep + 'Content').classList.remove('active');
                                                            document.getElementById('step' + currentStep).classList.remove('active');
                                                            document.getElementById('step' + currentStep).classList.add('completed');

                                                            currentStep++;

                                                            document.getElementById('step' + currentStep + 'Content').classList.add('active');
                                                            document.getElementById('step' + currentStep).classList.add('active');

                                                            updateButtons();

                                                            if (currentStep === 4) {
                                                                updateAppointmentSummary();
                                                            }
                                                        }
                                                    }
                                                }

                                                function previousStep() {
                                                    if (currentStep > 1) {
                                                        document.getElementById('step' + currentStep + 'Content').classList.remove('active');
                                                        document.getElementById('step' + currentStep).classList.remove('active');

                                                        currentStep--;

                                                        document.getElementById('step' + currentStep + 'Content').classList.add('active');
                                                        document.getElementById('step' + currentStep).classList.remove('completed');
                                                        document.getElementById('step' + currentStep).classList.add('active');

                                                        updateButtons();
                                                    }
                                                }

                                                function updateButtons() {
                                                    const prevBtn = document.getElementById('prevBtn');
                                                    const nextBtn = document.getElementById('nextBtn');
                                                    const submitBtn = document.getElementById('submitBtn');

                                                    prevBtn.style.display = currentStep > 1 ? 'inline-block' : 'none';
                                                    nextBtn.style.display = currentStep < totalSteps ? 'inline-block' : 'none';
                                                    submitBtn.style.display = currentStep === totalSteps ? 'inline-block' : 'none';
                                                }

                                                // Validation cho từng bước
                                                function validateCurrentStep() {
                                                    switch (currentStep) {
                                                        case 1:
                                                            if (!selectedPatient) {
                                                                alert('Vui lòng chọn bệnh nhân');
                                                                return false;
                                                            }
                                                            break;
                                                        case 2:
                                                            if (!selectedService) {
                                                                alert('Vui lòng chọn dịch vụ');
                                                                return false;
                                                            }
                                                            break;
                                                        case 3:
                                                            if (!selectedDoctor || !selectedSlot) {
                                                                alert('Vui lòng chọn bác sĩ và thời gian');
                                                                return false;
                                                            }
                                                            break;
                                                    }
                                                    return true;
                                                }

                                                // Tìm kiếm bệnh nhân
                                                function searchPatients() {
                                                    const searchTerm = document.getElementById('patientSearch').value;
                                                    if (!searchTerm.trim()) {
                                                        alert('Vui lòng nhập thông tin tìm kiếm');
                                                        return;
                                                    }

                                                    // Hiển thị loading
                                                    document.getElementById('patientResults').innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';

                                                    // Gọi API JSON trực tiếp
                                                    fetch('${pageContext.request.contextPath}/StaffBookingServlet?action=search_patient&format=json&phone=' + encodeURIComponent(searchTerm))
                                                        .then(response => response.json())
                                                        .then(patients => {
                                                            displayPatientResults(patients);
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
                                                            document.getElementById('patientResults').innerHTML = '<div class="text-danger">Có lỗi xảy ra khi tìm kiếm</div>';
                                                        });
                                                }

                                                function displayPatientResults(patients) {
                                                    let html = '';

                                                    if (patients && patients.length > 0) {
                                                        patients.forEach(patient => {
                                                            html += '<div class="patient-item" data-patient-id="' + patient.patientId + '" data-patient-name="' + patient.fullName + '" data-patient-phone="' + patient.phone + '" onclick="selectPatient(this)">' +
                                                                '<div class="row">' +
                                                                '<div class="col-md-6">' +
                                                                '<strong>' + patient.fullName + '</strong><br>' +
                                                                '<small class="text-muted">SĐT: ' + patient.phone + '</small>' +
                                                                '</div>' +
                                                                '<div class="col-md-6">' +
                                                                '<small>Ngày sinh: ' + (patient.dateOfBirth || 'Chưa có') + '</small><br>' +
                                                                '<small>Giới tính: ' + (patient.gender || 'Chưa có') + '</small>' +
                                                                '</div>' +
                                                                '</div>' +
                                                                '</div>';
                                                        });
                                                    } else {
                                                        html = '<div class="text-center text-muted"><i class="fas fa-user-times"></i><br>Không tìm thấy bệnh nhân nào</div>';
                                                    }

                                                    document.getElementById('patientResults').innerHTML = html;
                                                }

                                                function selectPatient(element) {
                                                    const id = element.getAttribute('data-patient-id');
                                                    const name = element.getAttribute('data-patient-name');
                                                    const phone = element.getAttribute('data-patient-phone');

                                                    selectedPatient = { id, name, phone };
                                                    document.getElementById('selectedPatientId').value = id;

                                                    // Highlight selected patient
                                                    document.querySelectorAll('.patient-item').forEach(item => item.classList.remove('selected'));
                                                    element.classList.add('selected');
                                                }

                                                function selectService(element) {
                                                    const id = element.getAttribute('data-service-id');
                                                    const name = element.getAttribute('data-service-name');
                                                    const price = parseFloat(element.getAttribute('data-service-price'));

                                                    selectedService = { id, name, price };
                                                    document.getElementById('selectedServiceId').value = id;

                                                    // Highlight selected service
                                                    document.querySelectorAll('.service-item').forEach(item => item.classList.remove('selected'));
                                                    element.classList.add('selected');
                                                }

                                                function loadTimeSlots() {
                                                    const doctorId = document.getElementById('doctorSelect').value;
                                                    const workDate = document.getElementById('workDateInput').value;

                                                    console.log('loadTimeSlots called:', { doctorId, workDate });

                                                    if (doctorId && workDate) {
                                                        selectedDoctor = doctorId;

                                                        // Hiển thị loading
                                                        document.getElementById('timeSlots').innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải khung giờ...</div>';
                                                        document.getElementById('timeSlotsContainer').style.display = 'block';
                                                        document.getElementById('timeSlotsDebug').style.display = 'block';

                                                        const url = '${pageContext.request.contextPath}/StaffBookingServlet?action=get_timeslots&doctorId=' + doctorId + '&workDate=' + workDate;
                                                        console.log('Fetching URL:', url);

                                                        fetch(url)
                                                            .then(response => {
                                                                console.log('Response status:', response.status);
                                                                return response.json();
                                                            })
                                                            .then(slots => {
                                                                console.log('Received slots:', slots);

                                                                // Update debug info
                                                                document.getElementById('timeSlotsCount').textContent = slots.length;

                                                                let html = '';
                                                                if (slots.length === 0) {
                                                                    html = '<div class="alert alert-warning">Không có khung giờ nào khả dụng cho ngày này</div>';
                                                                } else {
                                                                    slots.forEach(slot => {
                                                                        html += '<div class="time-slot" data-slot-id="' + slot.slotId + '" data-start-time="' + slot.startTime + '" data-end-time="' + slot.endTime + '" onclick="selectTimeSlot(this)">' +
                                                                            '<strong>' + slot.startTime + ' - ' + slot.endTime + '</strong><br>' +
                                                                            '<small>Slot ID: ' + slot.slotId + '</small>' +
                                                                            '</div>';
                                                                    });
                                                                }

                                                                document.getElementById('timeSlots').innerHTML = html;
                                                            })
                                                            .catch(error => {
                                                                console.error('Error loading timeslots:', error);
                                                                document.getElementById('timeSlots').innerHTML = '<div class="alert alert-danger">Có lỗi khi tải khung giờ: ' + error.message + '</div>';
                                                                document.getElementById('timeSlotsCount').textContent = 'Lỗi';
                                                            });
                                                    } else {
                                                        console.log('Missing doctorId or workDate');
                                                        document.getElementById('timeSlotsContainer').style.display = 'none';
                                                    }
                                                }

                                                function selectTimeSlot(element) {
                                                    const slotId = element.getAttribute('data-slot-id');
                                                    const startTime = element.getAttribute('data-start-time');
                                                    const endTime = element.getAttribute('data-end-time');

                                                    selectedSlot = { slotId, startTime, endTime };
                                                    document.getElementById('selectedSlotId').value = slotId;

                                                    // Highlight selected time slot
                                                    document.querySelectorAll('.time-slot').forEach(slot => slot.classList.remove('selected'));
                                                    element.classList.add('selected');
                                                }

                                                function updateAppointmentSummary() {
                                                    const doctorSelect = document.getElementById('doctorSelect');
                                                    const workDate = document.getElementById('workDateInput').value;

                                                    let html = '<div class="row">' +
                                                        '<div class="col-md-6">' +
                                                        '<p><strong>Bệnh nhân:</strong> ' + (selectedPatient ? selectedPatient.name : 'Chưa chọn') + '</p>' +
                                                        '<p><strong>Số điện thoại:</strong> ' + (selectedPatient ? selectedPatient.phone : 'Chưa chọn') + '</p>' +
                                                        '<p><strong>Dịch vụ:</strong> ' + (selectedService ? selectedService.name : 'Chưa chọn') + '</p>' +
                                                        '</div>' +
                                                        '<div class="col-md-6">' +
                                                        '<p><strong>Bác sĩ:</strong> ' + (selectedDoctor ? doctorSelect.options[doctorSelect.selectedIndex].text : 'Chưa chọn') + '</p>' +
                                                        '<p><strong>Ngày khám:</strong> ' + (workDate || 'Chưa chọn') + '</p>' +
                                                        '<p><strong>Giờ khám:</strong> ' + (selectedSlot ? selectedSlot.startTime + ' - ' + selectedSlot.endTime : 'Chưa chọn') + '</p>' +
                                                        '</div>' +
                                                        '</div>';

                                                    if (selectedService) {
                                                        html += '<p><strong>Giá dịch vụ:</strong> <span class="text-success">' + selectedService.price.toLocaleString() + ' VNĐ</span></p>';
                                                    }

                                                    document.getElementById('appointmentSummary').innerHTML = html;
                                                }

                                                // Reset modal khi đóng
                                                document.getElementById('newAppointmentModal').addEventListener('hidden.bs.modal', function () {
                                                    currentStep = 1;
                                                    selectedPatient = null;
                                                    selectedService = null;
                                                    selectedDoctor = null;
                                                    selectedSlot = null;

                                                    // Reset form
                                                    document.getElementById('appointmentForm').reset();

                                                    // Reset steps
                                                    document.querySelectorAll('.form-step').forEach(step => step.classList.remove('active'));
                                                    document.querySelectorAll('.step').forEach(step => {
                                                        step.classList.remove('active', 'completed');
                                                    });

                                                    document.getElementById('step1Content').classList.add('active');
                                                    document.getElementById('step1').classList.add('active');

                                                    updateButtons();
                                                });

                                                // ================== APPOINTMENT ACTIONS ==================

                                                /**
                                                 * Xem chi tiết appointment
                                                 */
                                                function viewAppointmentDetail(button) {
                                                    const appointmentId = button.getAttribute('data-appointment-id');

                                                    // Hiển thị loading
                                                    Swal.fire({
                                                        title: 'Đang tải...',
                                                        html: '<i class="fas fa-spinner fa-spin"></i> Đang lấy thông tin chi tiết',
                                                        allowOutsideClick: false,
                                                        showConfirmButton: false
                                                    });

                                                    // Call API để lấy chi tiết
                                                    fetch('${pageContext.request.contextPath}/StaffBookingServlet?action=get_detail&appointmentId=' + appointmentId)
                                                        .then(response => response.json())
                                                        .then(data => {
                                                            if (data.success) {
                                                                showAppointmentDetail(data.appointment);
                                                            } else {
                                                                Swal.fire('Lỗi!', 'Không thể lấy thông tin chi tiết: ' + data.message, 'error');
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
                                                            Swal.fire('Lỗi!', 'Có lỗi xảy ra khi lấy thông tin', 'error');
                                                        });
                                                }

                                                /**
                                                 * Hiển thị chi tiết appointment trong modal
                                                 */
                                                function showAppointmentDetail(appointment) {
                                                    const html = '<div class="row">' +
                                                        '<div class="col-md-6">' +
                                                        '<p><strong>Mã lịch hẹn:</strong> #' + appointment.appointmentId + '</p>' +
                                                        '<p><strong>Bệnh nhân:</strong> ' + appointment.patientName + '</p>' +
                                                        '<p><strong>Số điện thoại:</strong> ' + appointment.patientPhone + '</p>' +
                                                        '<p><strong>Bác sĩ:</strong> ' + appointment.doctorName + '</p>' +
                                                        '</div>' +
                                                        '<div class="col-md-6">' +
                                                        '<p><strong>Ngày khám:</strong> ' + appointment.workDate + '</p>' +
                                                        '<p><strong>Giờ khám:</strong> ' + appointment.startTime + ' - ' + appointment.endTime + '</p>' +
                                                        '<p><strong>Dịch vụ:</strong> ' + (appointment.serviceName || 'Chưa có') + '</p>' +
                                                        '<p><strong>Trạng thái:</strong> <span class="badge bg-' + getStatusColor(appointment.status) + '">' + appointment.status + '</span></p>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        (appointment.reason ? '<div class="mt-3"><strong>Lý do khám:</strong><br>' + appointment.reason + '</div>' : '');

                                                    Swal.fire({
                                                        title: '<i class="fas fa-eye text-primary"></i> Chi tiết lịch hẹn',
                                                        html: html,
                                                        width: '600px',
                                                        confirmButtonText: '<i class="fas fa-times"></i> Đóng',
                                                        confirmButtonColor: '#6c757d'
                                                    });
                                                }

                                                /**
                                                 * Xác nhận appointment
                                                 */
                                                function confirmAppointment(button) {
                                                    const appointmentId = button.getAttribute('data-appointment-id');

                                                    Swal.fire({
                                                        title: 'Xác nhận lịch hẹn?',
                                                        text: 'Bạn có chắc chắn muốn xác nhận lịch hẹn này?',
                                                        icon: 'question',
                                                        showCancelButton: true,
                                                        confirmButtonColor: '#28a745',
                                                        cancelButtonColor: '#6c757d',
                                                        confirmButtonText: '<i class="fas fa-check"></i> Xác nhận',
                                                        cancelButtonText: '<i class="fas fa-times"></i> Hủy'
                                                    }).then((result) => {
                                                        if (result.isConfirmed) {
                                                            updateAppointmentStatus(appointmentId, 'Đã xác nhận', 'success');
                                                        }
                                                    });
                                                }

                                                /**
                                                 * Hủy appointment
                                                 */
                                                function cancelAppointment(button) {
                                                    const appointmentId = button.getAttribute('data-appointment-id');

                                                    Swal.fire({
                                                        title: 'Hủy lịch hẹn?',
                                                        text: 'Bạn có chắc chắn muốn hủy lịch hẹn này?',
                                                        icon: 'warning',
                                                        showCancelButton: true,
                                                        confirmButtonColor: '#dc3545',
                                                        cancelButtonColor: '#6c757d',
                                                        confirmButtonText: '<i class="fas fa-times"></i> Hủy lịch',
                                                        cancelButtonText: '<i class="fas fa-arrow-left"></i> Quay lại'
                                                    }).then((result) => {
                                                        if (result.isConfirmed) {
                                                            updateAppointmentStatus(appointmentId, 'Đã hủy', 'error');
                                                        }
                                                    });
                                                }

                                                /**
                                                 * Cập nhật trạng thái appointment
                                                 */
                                                function updateAppointmentStatus(appointmentId, newStatus, alertType) {
                                                    // Hiển thị loading
                                                    Swal.fire({
                                                        title: 'Đang xử lý...',
                                                        html: '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật trạng thái',
                                                        allowOutsideClick: false,
                                                        showConfirmButton: false
                                                    });

                                                    // Call API để cập nhật
                                                    fetch('${pageContext.request.contextPath}/StaffBookingServlet', {
                                                        method: 'POST',
                                                        headers: {
                                                            'Content-Type': 'application/x-www-form-urlencoded',
                                                        },
                                                        body: 'action=update_status&appointmentId=' + appointmentId + '&status=' + encodeURIComponent(newStatus)
                                                    })
                                                        .then(response => response.json())
                                                        .then(data => {
                                                            if (data.success) {
                                                                Swal.fire({
                                                                    title: 'Thành công!',
                                                                    text: 'Đã cập nhật trạng thái lịch hẹn',
                                                                    icon: alertType,
                                                                    confirmButtonText: 'OK'
                                                                }).then(() => {
                                                                    // Reload trang để cập nhật danh sách
                                                                    location.reload();
                                                                });
                                                            } else {
                                                                Swal.fire('Lỗi!', 'Không thể cập nhật trạng thái: ' + data.message, 'error');
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
                                                            Swal.fire('Lỗi!', 'Có lỗi xảy ra khi cập nhật trạng thái', 'error');
                                                        });
                                                }

                                                /**
                                                 * Get Bootstrap color class for status
                                                 */
                                                function getStatusColor(status) {
                                                    switch (status) {
                                                        case 'Đã xác nhận': return 'success';
                                                        case 'Chờ xác nhận': return 'warning';
                                                        case 'Hoàn thành': return 'primary';
                                                        case 'Đã hủy': return 'danger';
                                                        case 'ĐANG GIỮ CHỖ': return 'info';
                                                        default: return 'secondary';
                                                    }
                                                }
                                            </script>

                                            <!-- SweetAlert2 for better alerts -->
                                            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                                        </body>

                                        </html>