<%-- Document : user_datlich Created on : 11 thg 6, 2025, 00:44:05 Author : tranhongphuoc --%>

    <%@ page contentType="text/html; charset=UTF-8" %>
        <%@ include file="../patient/user_header.jsp" %>
            <%@ include file="../patient/user_menu.jsp" %>
                <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                                <meta charset="UTF-8">
                                <title>Đặt lịch khám bệnh</title>
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
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
                                        margin-left: 300px;
                                        padding: 20px;
                                    }

                                    .doctor-card {
                                        background: white;
                                        border-radius: 10px;
                                        padding: 20px;
                                        margin-bottom: 20px;
                                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                    }

                                    .appointment-list {
                                        background: white;
                                        border-radius: 10px;
                                        padding: 20px;
                                        margin-top: 30px;
                                    }

                                    .modal-content {
                                        border-radius: 15px;
                                    }

                                    .btn-book {
                                        background: #00796b;
                                        color: white;
                                        border: none;
                                        padding: 8px 20px;
                                        border-radius: 5px;
                                        transition: 0.3s;
                                    }

                                    .btn-book:hover {
                                        background: #004d40;
                                        color: white;
                                    }

                                    .search-box {
                                        margin-bottom: 20px;
                                    }

                                    .error-message {
                                        color: #dc3545;
                                        margin-bottom: 15px;
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
                                        background: white;
                                    }

                                    .time-slot:hover {
                                        background: #f8f9fa;
                                        border-color: #00796b;
                                    }

                                    .time-slot.selected {
                                        background: #00796b;
                                        color: white;
                                        border-color: #00796b;
                                    }

                                    .time-slot.booked {
                                        background: linear-gradient(135deg, #dc3545, #c82333);
                                        color: white;
                                        border-color: #dc3545;
                                        cursor: not-allowed;
                                        opacity: 0.8;
                                        position: relative;
                                    }

                                    .time-slot.booked:hover {
                                        background: linear-gradient(135deg, #dc3545, #c82333);
                                        color: white;
                                        border-color: #dc3545;
                                        transform: none;
                                    }

                                    .time-slot.booked::after {
                                        content: '🚫';
                                        position: absolute;
                                        top: 2px;
                                        right: 5px;
                                        font-size: 12px;
                                    }

                                    /* Tab styles cho modal */
                                    .nav-tabs .nav-link {
                                        border: none;
                                        border-bottom: 3px solid transparent;
                                        color: #6c757d;
                                        font-weight: 500;
                                        padding: 12px 20px;
                                    }

                                    .nav-tabs .nav-link:hover {
                                        border-color: transparent;
                                        color: #00796b;
                                        background-color: #f8f9fa;
                                    }

                                    .nav-tabs .nav-link.active {
                                        color: #00796b;
                                        background-color: transparent;
                                        border-color: transparent transparent #00796b transparent;
                                        font-weight: 600;
                                    }

                                    .relative-info-card {
                                        border: 1px solid #e3f2fd;
                                        background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
                                        border-radius: 10px;
                                        margin-top: 15px;
                                    }

                                    .relative-info-card .card-header {
                                        background: linear-gradient(135deg, #00796b 0%, #004d40 100%);
                                        color: white;
                                        border-bottom: none;
                                    }

                                    .service-item {
                                        border: 2px solid #dee2e6;
                                        background: #f8f9fa;
                                        padding: 12px;
                                        border-radius: 8px;
                                        cursor: pointer;
                                        transition: all 0.3s ease;
                                        min-height: 120px;
                                    }

                                    .service-item:hover {
                                        border-color: #00796b;
                                        background: #e8f5e8;
                                    }

                                    .service-item.selected {
                                        border-color: #00796b;
                                        background: #e8f5e8;
                                    }
                                </style>
                            </head>

                            <body>
                                <div class="container">
                                    <h2 class="mb-4">Đặt lịch khám bệnh</h2>

                                    <!-- Hướng dẫn sử dụng -->
                                    <div class="alert alert-info mb-4">
                                        <h5><i class="fas fa-info-circle me-2"></i>Hướng dẫn đặt lịch:</h5>
                                        <ul class="mb-0">
                                            <li><strong>🧑 Đặt cho bản thân:</strong> Chọn tab "Đặt cho mình"</li>
                                            <li><strong>👨‍👩‍👧‍👦 Đặt cho người thân:</strong> Chọn tab "Đặt cho người
                                                thân" và điền thông tin</li>
                                            <li><strong>⚙️ Server tự động xử lý:</strong> Servlet sẽ validate và lưu
                                                database</li>
                                            <li><strong>🎯 Kết quả:</strong> Bản thân → patient_id có giá trị | Người
                                                thân → relative_id có giá trị</li>
                                        </ul>
                                    </div>

                                    <!-- Hiển thị dịch vụ đã chọn -->
                                    <c:if test="${not empty selectedService}">
                                        <div class="alert alert-info mb-4">
                                            <h5><i class="fas fa-tooth me-2"></i>Dịch vụ đã chọn</h5>
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <strong>${selectedService.serviceName}</strong><br>
                                                    <small class="text-muted">${selectedService.description}</small><br>
                                                    <span class="badge bg-primary">${selectedService.category}</span>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <h4 class="text-success mb-0">
                                                        <fmt:formatNumber value="${selectedService.price}"
                                                            pattern="#,##0" /> VNĐ
                                                    </h4>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Hiển thị thông báo lỗi -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger" role="alert">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <!-- Tìm kiếm -->
                                    <div class="search-box">
                                        <form id="searchForm" method="GET"
                                            action="${pageContext.request.contextPath}/BookingPageServlet">
                                            <c:if test="${not empty selectedService}">
                                                <input type="hidden" name="serviceId"
                                                    value="${selectedService.serviceId}" />
                                            </c:if>
                                            <div class="form-group">
                                                <input type="text" name="keyword" placeholder="Tìm kiếm bác sĩ..."
                                                    value="${param.keyword}">
                                                <select name="specialty">
                                                    <option value="">Chọn chuyên khoa</option>
                                                    <c:forEach items="${specialties}" var="spec">
                                                        <option value="${spec}" ${param.specialty==spec ? 'selected'
                                                            : '' }>${spec}</option>
                                                    </c:forEach>
                                                </select>
                                                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- Danh sách bác sĩ -->
                                    <div class="row">
                                        <c:forEach items="${doctors}" var="doctor">
                                            <div class="col-md-6 mb-4">
                                                <div class="doctor-card">
                                                    <h4>${doctor.full_name}</h4>
                                                    <p><i class="fas fa-stethoscope"></i> ${doctor.specialty}</p>
                                                    <p>Số điện thoại: <i>${doctor.phone}</i></p>
                                                    <p>
                                                        <span>Trạng thái:</span>
                                                        <c:choose>
                                                            <c:when test="${doctor.status == 'Active'}">
                                                                <i style="color:green;"
                                                                    class="fa-solid fa-circle fa-fade"></i>
                                                                <span style="color: green;">Đang trực</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i style="color:gray;" class="fa-solid fa-circle"></i>
                                                                <span style="color: gray;">Ngoại tuyến</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>

                                                    <button class="btn btn-book" type="button" data-bs-toggle="modal"
                                                        data-bs-target="#bookingModal${doctor.doctor_id}">
                                                        Đặt lịch với bác sĩ này
                                                    </button>

                                                    <!-- workDates riêng cho từng bác sĩ -->
                                                    <script>
                                                        window['workDates_${doctor.doctor_id}'] = [
                                                            <c:forEach items="${doctor.workDates}" var="date" varStatus="loop">
                                                                "${date}"<c:if test="${!loop.last}">,</c:if>
                                                            </c:forEach>
                                                        ];
                                                    </script>

                                                    <!-- Modal đặt lịch -->
                                                    <div class="modal fade" id="bookingModal${doctor.doctor_id}"
                                                        tabindex="-1"
                                                        aria-labelledby="bookingModalLabel${doctor.doctor_id}"
                                                        aria-hidden="true">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title"
                                                                        id="bookingModalLabel${doctor.doctor_id}">
                                                                        Đăng ký lịch với ${doctor.full_name}
                                                                    </h5>
                                                                    <button type="button" class="btn-close"
                                                                        data-bs-dismiss="modal"></button>
                                                                </div>

                                                                <div class="modal-body">
                                                                    <!-- Tab Navigation -->
                                                                    <ul class="nav nav-tabs"
                                                                        id="bookingTabs${doctor.doctor_id}"
                                                                        role="tablist">
                                                                        <li class="nav-item" role="presentation">
                                                                            <button class="nav-link active"
                                                                                id="self-tab-${doctor.doctor_id}"
                                                                                data-bs-toggle="tab"
                                                                                data-bs-target="#self-${doctor.doctor_id}"
                                                                                type="button" role="tab">
                                                                                <i class="fas fa-user me-2"></i>Đặt cho
                                                                                mình
                                                                            </button>
                                                                        </li>
                                                                        <li class="nav-item" role="presentation">
                                                                            <button class="nav-link"
                                                                                id="relative-tab-${doctor.doctor_id}"
                                                                                data-bs-toggle="tab"
                                                                                data-bs-target="#relative-${doctor.doctor_id}"
                                                                                type="button" role="tab">
                                                                                <i class="fas fa-users me-2"></i>Đặt cho
                                                                                người thân
                                                                            </button>
                                                                        </li>
                                                                    </ul>

                                                                    <!-- Tab Content -->
                                                                    <div class="tab-content"
                                                                        id="bookingTabContent${doctor.doctor_id}">
                                                                        <!-- Tab đặt lịch cho bản thân -->
                                                                        <div class="tab-pane fade show active"
                                                                            id="self-${doctor.doctor_id}"
                                                                            role="tabpanel">
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/BookingPageServlet"
                                                                                method="post" class="mt-3">
                                                                                <input type="hidden" name="doctorId"
                                                                                    value="${doctor.doctor_id}" />
                                                                                <input type="hidden" name="bookingFor"
                                                                                    value="self" />
                                                                                <c:if
                                                                                    test="${not empty selectedService}">
                                                                                    <input type="hidden"
                                                                                        name="serviceId"
                                                                                        value="${selectedService.serviceId}" />
                                                                                </c:if>

                                                                                <!-- Chọn dịch vụ -->
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Chọn dịch
                                                                                        vụ khám:</label>
                                                                                    <div class="row">
                                                                                        <c:forEach items="${services}"
                                                                                            var="service">
                                                                                            <div class="col-md-6 mb-2">
                                                                                                <div class="service-item"
                                                                                                    onclick="selectService(this, ${service.serviceId}, '${fn:escapeXml(service.serviceName)}', ${service.price}, 'self_${doctor.doctor_id}')">
                                                                                                    <h6
                                                                                                        style="color: #00796b; margin-bottom: 6px;">
                                                                                                        ${service.serviceName}
                                                                                                    </h6>
                                                                                                    <p class="text-muted mb-2"
                                                                                                        style="font-size: 0.85em;">
                                                                                                        ${service.description}
                                                                                                    </p>
                                                                                                    <div
                                                                                                        class="d-flex justify-content-between align-items-center">
                                                                                                        <span
                                                                                                            class="badge bg-info"
                                                                                                            style="font-size: 0.7em;">${service.category}</span>
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
                                                                                    </div>
                                                                                    <input type="hidden"
                                                                                        name="serviceId"
                                                                                        id="selectedServiceId_self_${doctor.doctor_id}">
                                                                                </div>

                                                                                <!-- Chọn ngày khám -->
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Chọn ngày
                                                                                        khám:</label>
                                                                                    <input
                                                                                        id="work_date_picker_self_${doctor.doctor_id}"
                                                                                        type="text" name="workDate"
                                                                                        class="form-control" required>
                                                                                </div>

                                                                                <!-- Chọn ca khám -->
                                                                                <div class="mb-3"
                                                                                    id="timeSlotsContainer_self_${doctor.doctor_id}"
                                                                                    style="display: none;">
                                                                                    <label class="form-label">Chọn ca
                                                                                        khám:</label>
                                                                                    <div class="time-slots"
                                                                                        id="timeSlots_self_${doctor.doctor_id}">
                                                                                    </div>
                                                                                    <input type="hidden" name="slotId"
                                                                                        id="selectedSlotId_self_${doctor.doctor_id}">
                                                                                </div>

                                                                                <!-- Lý do khám -->
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Lý do
                                                                                        khám:</label>
                                                                                    <textarea name="reason"
                                                                                        class="form-control" rows="3"
                                                                                        required></textarea>
                                                                                </div>

                                                                                <div class="text-end">
                                                                                    <button type="button"
                                                                                        class="btn btn-secondary"
                                                                                        data-bs-dismiss="modal">Đóng</button>
                                                                                    <button type="submit"
                                                                                        class="btn btn-primary">Xác nhận
                                                                                        đặt
                                                                                        lịch</button>
                                                                                </div>
                                                                            </form>
                                                                        </div>

                                                                        <!-- Tab đặt lịch cho người thân -->
                                                                        <div class="tab-pane fade"
                                                                            id="relative-${doctor.doctor_id}"
                                                                            role="tabpanel">
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/BookingPageServlet"
                                                                                method="post" class="mt-3">
                                                                                <input type="hidden" name="doctorId"
                                                                                    value="${doctor.doctor_id}" />
                                                                                <input type="hidden" name="bookingFor"
                                                                                    value="relative" />
                                                                                <c:if
                                                                                    test="${not empty selectedService}">
                                                                                    <input type="hidden"
                                                                                        name="serviceId"
                                                                                        value="${selectedService.serviceId}" />
                                                                                </c:if>

                                                                                <!-- Thông tin người thân -->
                                                                                <div
                                                                                    class="relative-info-card card mb-3">
                                                                                    <div class="card-header">
                                                                                        <h6 class="mb-0"><i
                                                                                                class="fas fa-users me-2"></i>Thông
                                                                                            tin
                                                                                            người thân</h6>
                                                                                        <small class="text-light">💡 Có
                                                                                            thể bỏ trống, hệ thống sẽ
                                                                                            tạo thông tin mặc
                                                                                            định</small>
                                                                                    </div>
                                                                                    <div class="card-body">
                                                                                        <div class="row">
                                                                                            <div class="col-md-6 mb-3">
                                                                                                <label
                                                                                                    class="form-label">Họ
                                                                                                    và tên:</label>
                                                                                                <input type="text"
                                                                                                    name="relativeName"
                                                                                                    class="form-control"
                                                                                                    placeholder="Nhập họ tên người thân">
                                                                                            </div>
                                                                                            <div class="col-md-6 mb-3">
                                                                                                <label
                                                                                                    class="form-label">Số
                                                                                                    điện thoại:</label>
                                                                                                <input type="tel"
                                                                                                    name="relativePhone"
                                                                                                    class="form-control"
                                                                                                    placeholder="Nhập số điện thoại">
                                                                                            </div>
                                                                                            <div class="col-md-4 mb-3">
                                                                                                <label
                                                                                                    class="form-label">Ngày
                                                                                                    sinh:</label>
                                                                                                <input type="date"
                                                                                                    name="relativeDob"
                                                                                                    class="form-control">
                                                                                            </div>
                                                                                            <div class="col-md-4 mb-3">
                                                                                                <label
                                                                                                    class="form-label">Giới
                                                                                                    tính:</label>
                                                                                                <select
                                                                                                    name="relativeGender"
                                                                                                    class="form-control">
                                                                                                    <option value="">
                                                                                                        Chọn giới tính
                                                                                                    </option>
                                                                                                    <option value="Nam">
                                                                                                        Nam</option>
                                                                                                    <option value="Nữ">
                                                                                                        Nữ</option>
                                                                                                    <option
                                                                                                        value="Khác">
                                                                                                        Khác</option>
                                                                                                </select>
                                                                                            </div>
                                                                                            <div class="col-md-4 mb-3">
                                                                                                <label
                                                                                                    class="form-label">Mối
                                                                                                    quan hệ:</label>
                                                                                                <select
                                                                                                    name="relativeRelationship"
                                                                                                    class="form-control">
                                                                                                    <option value="">
                                                                                                        Chọn mối quan hệ
                                                                                                    </option>
                                                                                                    <option value="Cha">
                                                                                                        Cha</option>
                                                                                                    <option value="Mẹ">
                                                                                                        Mẹ</option>
                                                                                                    <option value="Con">
                                                                                                        Con</option>
                                                                                                    <option value="Anh">
                                                                                                        Anh</option>
                                                                                                    <option value="Chị">
                                                                                                        Chị</option>
                                                                                                    <option value="Em">
                                                                                                        Em</option>
                                                                                                    <option value="Vợ">
                                                                                                        Vợ</option>
                                                                                                    <option
                                                                                                        value="Chồng">
                                                                                                        Chồng</option>
                                                                                                    <option
                                                                                                        value="Khác">
                                                                                                        Khác</option>
                                                                                                </select>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>

                                                                                <!-- Chọn dịch vụ -->
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Chọn dịch
                                                                                        vụ khám:</label>
                                                                                    <div class="row">
                                                                                        <c:forEach items="${services}"
                                                                                            var="service">
                                                                                            <div class="col-md-6 mb-2">
                                                                                                <div class="service-item"
                                                                                                    onclick="selectService(this, ${service.serviceId}, '${fn:escapeXml(service.serviceName)}', ${service.price}, 'relative_${doctor.doctor_id}')">
                                                                                                    <h6
                                                                                                        style="color: #00796b; margin-bottom: 6px;">
                                                                                                        ${service.serviceName}
                                                                                                    </h6>
                                                                                                    <p class="text-muted mb-2"
                                                                                                        style="font-size: 0.85em;">
                                                                                                        ${service.description}
                                                                                                    </p>
                                                                                                    <div
                                                                                                        class="d-flex justify-content-between align-items-center">
                                                                                                        <span
                                                                                                            class="badge bg-info"
                                                                                                            style="font-size: 0.7em;">${service.category}</span>
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
                                                                                    </div>
                                                                                    <input type="hidden"
                                                                                        name="serviceId"
                                                                                        id="selectedServiceId_relative_${doctor.doctor_id}">
                                                                                </div>

                                                                                <!-- Chọn ngày khám -->
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Chọn ngày
                                                                                        khám:</label>
                                                                                    <input
                                                                                        id="work_date_picker_relative_${doctor.doctor_id}"
                                                                                        type="text" name="workDate"
                                                                                        class="form-control" required>
                                                                                </div>

                                                                                <!-- Chọn ca khám -->
                                                                                <div class="mb-3"
                                                                                    id="timeSlotsContainer_relative_${doctor.doctor_id}"
                                                                                    style="display: none;">
                                                                                    <label class="form-label">Chọn ca
                                                                                        khám:</label>
                                                                                    <div class="time-slots"
                                                                                        id="timeSlots_relative_${doctor.doctor_id}">
                                                                                    </div>
                                                                                    <input type="hidden" name="slotId"
                                                                                        id="selectedSlotId_relative_${doctor.doctor_id}">
                                                                                </div>

                                                                                <!-- Lý do khám -->
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Lý do
                                                                                        khám:</label>
                                                                                    <textarea name="reason"
                                                                                        class="form-control" rows="3"
                                                                                        required></textarea>
                                                                                </div>

                                                                                <div class="text-end">
                                                                                    <button type="button"
                                                                                        class="btn btn-secondary"
                                                                                        data-bs-dismiss="modal">Đóng</button>
                                                                                    <button type="submit"
                                                                                        class="btn btn-primary">Xác nhận
                                                                                        đặt
                                                                                        lịch</button>
                                                                                </div>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Danh sách lịch hẹn -->
                                <div class="appointment-list">
                                    <h3>Lịch hẹn của bạn</h3>
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>Ngày khám</th>
                                                    <th>Giờ khám</th>
                                                    <th>Bác sĩ</th>
                                                    <th>Trạng thái</th>
                                                    <th>Lý do</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${appointments}" var="apt">
                                                    <tr>
                                                        <td>${apt.workDate}</td>
                                                        <td>${apt.startTime} - ${apt.endTime}</td>
                                                        <td>${apt.doctorName}</td>
                                                        <td>${apt.status}</td>
                                                        <td>${apt.reason}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Initialize flatpickr cho cả hai tab của mỗi bác sĩ
                                        <c:forEach items="${doctors}" var="doctor">
                                    // Tab self
                                            flatpickr("#work_date_picker_self_${doctor.doctor_id}", {
                                                dateFormat: "Y-m-d",
                                            enable: window['workDates_${doctor.doctor_id}'],
                                            minDate: "today",
                                            locale: {
                                                firstDayOfWeek: 1
                                                },
                                            onChange: function (selectedDates, dateStr) {
                                                updateSchedules(dateStr, ${ doctor.doctor_id }, 'self');
                                                }
                                            });

                                            // Tab relative
                                            flatpickr("#work_date_picker_relative_${doctor.doctor_id}", {
                                                dateFormat: "Y-m-d",
                                            enable: window['workDates_${doctor.doctor_id}'],
                                            minDate: "today",
                                            locale: {
                                                firstDayOfWeek: 1
                                                },
                                            onChange: function (selectedDates, dateStr) {
                                                updateSchedules(dateStr, ${ doctor.doctor_id }, 'relative');
                                                }
                                            });
                                        </c:forEach>
                                    });

                                    function updateSchedules(selectedDate, doctorId, tabType) {
                                        var url = '${pageContext.request.contextPath}/BookingPageServlet?ajax=true&doctorId=' + doctorId + '&workDate=' + selectedDate;

                                        // Hiển thị container và loading
                                        document.getElementById('timeSlotsContainer_' + tabType + '_' + doctorId).style.display = 'block';
                                        document.getElementById('timeSlots_' + tabType + '_' + doctorId).innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải khung giờ...</div>';

                                        fetch(url)
                                            .then(function (response) {
                                                return response.json();
                                            })
                                            .then(function (slots) {
                                                console.log('Dữ liệu khung giờ trả về:', slots);

                                                var timeSlotsDiv = document.getElementById('timeSlots_' + tabType + '_' + doctorId);
                                                var html = '';

                                                if (slots.length === 0) {
                                                    html = '<div class="alert alert-warning">Không có khung giờ nào khả dụng cho ngày này</div>';
                                                } else {
                                                    slots.forEach(function (slot) {
                                                        var slotClass = 'time-slot';
                                                        var clickHandler = '';
                                                        var statusText = '';

                                                        if (slot.isBooked) {
                                                            slotClass += ' booked';
                                                            statusText = '<small class="text-muted">Đã được đặt</small>';
                                                        } else {
                                                            clickHandler = 'onclick="selectTimeSlot(' + slot.slotId + ', \'' + slot.startTime + '\', \'' + slot.endTime + '\', ' + doctorId + ', \'' + tabType + '\')"';
                                                            statusText = '<small class="text-success">Còn trống</small>';
                                                        }

                                                        html += '<div class="' + slotClass + '" ' + clickHandler + '>' +
                                                            '<strong>' + slot.startTime + ' - ' + slot.endTime + '</strong><br>' +
                                                            statusText +
                                                            '</div>';
                                                    });
                                                }

                                                timeSlotsDiv.innerHTML = html;
                                            })
                                            .catch(function (error) {
                                                console.error('Error loading timeslots:', error);
                                                document.getElementById('timeSlots_' + tabType + '_' + doctorId).innerHTML = '<div class="alert alert-danger">Có lỗi khi tải khung giờ</div>';
                                            });
                                    }

                                    function selectTimeSlot(slotId, startTime, endTime, doctorId, tabType) {
                                        // Kiểm tra nếu slot đã được đặt
                                        if (event.currentTarget.classList.contains('booked')) {
                                            alert('Khung giờ này đã được đặt. Vui lòng chọn khung giờ khác!');
                                            return;
                                        }

                                        // Set giá trị vào hidden input
                                        document.getElementById('selectedSlotId_' + tabType + '_' + doctorId).value = slotId;

                                        // Highlight selected time slot
                                        document.querySelectorAll('#timeSlots_' + tabType + '_' + doctorId + ' .time-slot:not(.booked)').forEach(slot => slot.classList.remove('selected'));
                                        event.currentTarget.classList.add('selected');

                                        console.log('Selected slot:', slotId, startTime, endTime, 'for doctor:', doctorId, 'tab:', tabType);
                                    }

                                    function selectService(element, serviceId, serviceName, servicePrice, tabType) {
                                        // Reset tất cả service cards trong tab hiện tại
                                        var tabContainer = element.closest('.tab-pane');
                                        tabContainer.querySelectorAll('.service-item').forEach(function (card) {
                                            card.classList.remove('selected');
                                        });

                                        // Highlight card được chọn
                                        element.classList.add('selected');

                                        // Cập nhật hidden input
                                        document.getElementById('selectedServiceId_' + tabType).value = serviceId;

                                        console.log('Selected service for', tabType, ':', serviceId, serviceName, servicePrice);
                                    }
                                </script>
                            </body>

                            </html>