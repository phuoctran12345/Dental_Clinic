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
                                        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                                        gap: 10px;
                                        margin-top: 10px;
                                    }

                                    .time-slot-item {
                                        border: 1px solid #ddd;
                                        border-radius: 5px;
                                        padding: 10px;
                                        text-align: center;
                                        cursor: pointer;
                                        transition: all 0.3s ease;
                                    }

                                    .time-slot-item:hover {
                                        background-color: #f8f9fa;
                                        border-color: #00796b;
                                    }

                                    .time-slot-label {
                                        margin: 0;
                                        cursor: pointer;
                                        display: block;
                                        padding: 5px;
                                    }

                                    input[type="radio"] {
                                        display: none;
                                    }

                                    input[type="radio"]:checked+.time-slot-label {
                                        background-color: #00796b;
                                        color: white;
                                        border-radius: 3px;
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
                                </style>
                            </head>

                            <body>
                                <div class="container">
                                    <h2 class="mb-4">Đặt lịch khám bệnh</h2>

                                    <!-- Tab chuyển đổi giữa đặt cho mình và người thân -->
                                    <div class="booking-type-tabs mb-4">
                                        <ul class="nav nav-tabs" id="bookingTypeTabs" role="tablist">
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link active" id="self-tab" data-bs-toggle="tab"
                                                    data-bs-target="#self-booking" type="button" role="tab"
                                                    aria-controls="self-booking" aria-selected="true">
                                                    <i class="fas fa-user me-2"></i>Đặt cho mình
                                                </button>
                                            </li>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link" id="relative-tab" data-bs-toggle="tab"
                                                    data-bs-target="#relative-booking" type="button" role="tab"
                                                    aria-controls="relative-booking" aria-selected="false">
                                                    <i class="fas fa-users me-2"></i>Đặt cho người thân
                                                </button>
                                            </li>
                                        </ul>
                                        <div class="tab-content" id="bookingTypeTabContent">
                                            <!-- Tab đặt cho mình -->
                                            <div class="tab-pane fade show active" id="self-booking" role="tabpanel"
                                                aria-labelledby="self-tab">
                                                <div class="alert alert-info mt-3">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    <strong>Đặt lịch cho bản thân:</strong> Sử dụng thông tin tài khoản
                                                    của bạn
                                                </div>
                                            </div>
                                            <!-- Tab đặt cho người thân -->
                                            <div class="tab-pane fade" id="relative-booking" role="tabpanel"
                                                aria-labelledby="relative-tab">
                                                <div class="alert alert-warning mt-3">
                                                    <i class="fas fa-users me-2"></i>
                                                    <strong>Đặt lịch cho người thân:</strong> Vui lòng nhập đầy đủ thông
                                                    tin người cần khám
                                                </div>
                                                <!-- Form thông tin người thân -->
                                                <div class="relative-info-form card">
                                                    <div class="card-header">
                                                        <h6><i class="fas fa-user-plus me-2"></i>Thông tin người thân
                                                        </h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="row">
                                                            <div class="col-md-6 mb-3">
                                                                <label class="form-label">Họ và tên <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" id="relativeName" name="relativeName"
                                                                    class="form-control"
                                                                    placeholder="Nhập họ tên người thân" required>
                                                            </div>
                                                            <div class="col-md-6 mb-3">
                                                                <label class="form-label">Số điện thoại <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="tel" id="relativePhone"
                                                                    name="relativePhone" class="form-control"
                                                                    placeholder="Nhập số điện thoại" required>
                                                            </div>
                                                            <div class="col-md-4 mb-3">
                                                                <label class="form-label">Ngày sinh <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="date" id="relativeDob" name="relativeDob"
                                                                    class="form-control" required>
                                                            </div>
                                                            <div class="col-md-4 mb-3">
                                                                <label class="form-label">Giới tính <span
                                                                        class="text-danger">*</span></label>
                                                                <select id="relativeGender" name="relativeGender"
                                                                    class="form-control" required>
                                                                    <option value="">Chọn giới tính</option>
                                                                    <option value="Nam">Nam</option>
                                                                    <option value="Nữ">Nữ</option>
                                                                    <option value="Khác">Khác</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-4 mb-3">
                                                                <label class="form-label">Mối quan hệ <span
                                                                        class="text-danger">*</span></label>
                                                                <select id="relativeRelationship"
                                                                    name="relativeRelationship" class="form-control"
                                                                    required>
                                                                    <option value="">Chọn mối quan hệ</option>
                                                                    <option value="Cha">Cha</option>
                                                                    <option value="Mẹ">Mẹ</option>
                                                                    <option value="Con">Con</option>
                                                                    <option value="Anh">Anh</option>
                                                                    <option value="Chị">Chị</option>
                                                                    <option value="Em">Em</option>
                                                                    <option value="Vợ">Vợ</option>
                                                                    <option value="Chồng">Chồng</option>
                                                                    <option value="Khác">Khác</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
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
                                            <!-- Truyền serviceId trong search -->
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
                                                            : '' }>
                                                            ${spec}</option>
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
                                                    <!-- Modal riêng cho từng bác sĩ -->
                                                    <div class="modal fade" id="bookingModal${doctor.doctor_id}"
                                                        tabindex="-1"
                                                        aria-labelledby="bookingModalLabel${doctor.doctor_id}"
                                                        aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <form
                                                                    action="${pageContext.request.contextPath}/BookingPageServlet"
                                                                    method="post">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title"
                                                                            id="bookingModalLabel${doctor.doctor_id}">
                                                                            Đăng
                                                                            ký
                                                                            lịch với ${doctor.full_name}</h5>
                                                                        <button type="button" class="btn-close"
                                                                            data-bs-dismiss="modal"
                                                                            aria-label="Đóng"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <input type="hidden" name="doctorId"
                                                                            value="${doctor.doctor_id}" />
                                                                        <!-- Truyền serviceId -->
                                                                        <c:if test="${not empty selectedService}">
                                                                            <input type="hidden" name="serviceId"
                                                                                value="${selectedService.serviceId}" />
                                                                        </c:if>

                                                                        <!-- Chọn dịch vụ -->
                                                                        <div class="mb-3">
                                                                            <label class="form-label">Chọn dịch vụ
                                                                                khám:</label>

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
                                                                                    } %>
                                                                            </c:if>

                                                                            <!-- Debug info -->
                                                                            <div class="alert alert-info mb-3"
                                                                                style="font-size: 0.85em;">
                                                                                <strong>Debug:</strong> Số dịch vụ:
                                                                                ${fn:length(services)}
                                                                                <c:if test="${empty services}">
                                                                                    <br><span class="text-warning">⚠️
                                                                                        Không
                                                                                        load được dịch vụ!</span>
                                                                                </c:if>
                                                                            </div>

                                                                            <div class="row">
                                                                                <c:choose>
                                                                                    <c:when test="${empty services}">
                                                                                        <div class="col-12">
                                                                                            <div
                                                                                                class="alert alert-warning text-center">
                                                                                                <i
                                                                                                    class="fas fa-exclamation-triangle fa-2x mb-2"></i>
                                                                                                <h6>Không có dịch vụ nào
                                                                                                </h6>
                                                                                                <p class="mb-0 small">
                                                                                                    Vấn đề
                                                                                                    với ServiceDAO hoặc
                                                                                                    database connection
                                                                                                </p>
                                                                                            </div>
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <c:forEach items="${services}"
                                                                                            var="service">
                                                                                            <div class="col-md-6 mb-2">
                                                                                                <div class="service-item"
                                                                                                    style="
                                                                                                border: 2px solid #dee2e6; 
                                                                                                background: #f8f9fa; 
                                                                                                padding: 12px; 
                                                                                                border-radius: 8px; 
                                                                                                cursor: pointer;
                                                                                                transition: all 0.3s ease;
                                                                                                min-height: 120px;
                                                                                            " onmouseover="this.style.borderColor='#00796b'; this.style.background='#e8f5e8';"
                                                                                                    onmouseout="this.style.borderColor='#dee2e6'; this.style.background='#f8f9fa';"
                                                                                                    onclick="selectService_${doctor.doctor_id}(${service.serviceId}, '${service.serviceName}', ${service.price})">
                                                                                                    <h6
                                                                                                        style="color: #00796b; margin-bottom: 6px; font-size: 0.95em;">
                                                                                                        ${service.serviceName}
                                                                                                    </h6>
                                                                                                    <p class="text-muted mb-2"
                                                                                                        style="font-size: 0.8em; line-height: 1.3;">
                                                                                                        ${service.description}
                                                                                                    </p>
                                                                                                    <div
                                                                                                        class="d-flex justify-content-between align-items-center">
                                                                                                        <span
                                                                                                            class="badge bg-info"
                                                                                                            style="font-size: 0.7em;">${service.category}</span>
                                                                                                        <strong
                                                                                                            class="text-success"
                                                                                                            style="font-size: 0.9em;">
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

                                                                            <!-- Hidden input để lưu serviceId đã chọn -->
                                                                            <input type="hidden" name="serviceId"
                                                                                id="selectedServiceId_${doctor.doctor_id}">

                                                                            <!-- Hiển thị dịch vụ đã chọn -->
                                                                            <div id="selectedServiceInfo_${doctor.doctor_id}"
                                                                                class="mt-2" style="display: none;">
                                                                                <div class="alert alert-success mb-0"
                                                                                    style="font-size: 0.9em;">
                                                                                    <strong>✅ Đã chọn:</strong> <span
                                                                                        id="selectedServiceName_${doctor.doctor_id}"></span>
                                                                                    <br><strong>Giá:</strong> <span
                                                                                        id="selectedServicePrice_${doctor.doctor_id}"
                                                                                        class="text-success"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <div class="mb-3">
                                                                            <label>Chọn ngày khám:</label>
                                                                            <input
                                                                                id="work_date_picker_${doctor.doctor_id}"
                                                                                type="text" name="workDate"
                                                                                class="form-control" required>
                                                                        </div>
                                                                        <div class="mb-3"
                                                                            id="timeSlotsContainer_${doctor.doctor_id}"
                                                                            style="display: none;">
                                                                            <label>Chọn ca khám:</label>
                                                                            <div class="time-slots"
                                                                                id="timeSlots_${doctor.doctor_id}">
                                                                                <!-- Khung giờ sẽ được load bằng AJAX -->
                                                                            </div>
                                                                            <input type="hidden" name="slotId"
                                                                                id="selectedSlotId_${doctor.doctor_id}">
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label>Lý do khám:</label>
                                                                            <textarea name="reason" class="form-control"
                                                                                required></textarea>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary"
                                                                            data-bs-dismiss="modal">Đóng</button>
                                                                        <button type="submit"
                                                                            class="btn btn-primary">Xác
                                                                            nhận
                                                                            đặt lịch</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Bảng hiển thị lịch làm việc của tất cả bác sĩ (2 tuần tới) -->
                                    <h3 class="mt-5">Lịch làm việc của tất cả bác sĩ (2 tuần tới)</h3>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i>
                                        <strong>Lưu ý:</strong> Bảng này hiển thị ngày làm việc thực tế (đã loại bỏ ngày
                                        nghỉ phép của bác sĩ)
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Bác sĩ</th>
                                                    <th>Ngày làm việc</th>
                                                    <th>Trạng thái</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${doctors}" var="doctor">
                                                    <c:forEach items="${doctor.workDates}" var="workDate">
                                                        <tr>
                                                            <td>${doctor.full_name} - ${doctor.specialty}</td>
                                                            <td>${workDate}</td>
                                                            <td><span class="badge bg-success">Đang làm việc</span></td>
                                                            <td>
                                                                <button class="btn btn-sm btn-primary"
                                                                    onclick="openBookingModal('${doctor.doctor_id}', '${workDate}')">
                                                                    Đặt lịch
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <script>
                                        function openBookingModal(doctorId, workDate) {
                                            // Tìm modal của bác sĩ tương ứng
                                            const modal = document.getElementById('bookingModal' + doctorId);
                                            if (modal) {
                                                // Set ngày đã chọn vào input date
                                                const dateInput = modal.querySelector('input[name="workDate"]');
                                                if (dateInput) {
                                                    dateInput.value = workDate;
                                                }

                                                // Hiển thị modal
                                                const bootstrapModal = new bootstrap.Modal(modal);
                                                bootstrapModal.show();
                                            }
                                        }
                                    </script>

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

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        <c:forEach items="${doctors}" var="doctor">
                                            flatpickr("#work_date_picker_${doctor.doctor_id}", {
                                                dateFormat: "Y-m-d",
                                            enable: window['workDates_${doctor.doctor_id}'],
                                            minDate: "today", // Không cho chọn ngày cũ
                                            locale: {
                                                firstDayOfWeek: 1 // Thứ 2 là ngày đầu tuần
                                                },
                                            onChange: function (selectedDates, dateStr) {
                                                updateSchedules(dateStr, ${ doctor.doctor_id });
                                                }
                                            });
                                        </c:forEach>
                                    });

                                    function updateSchedules(selectedDate, doctorId) {
                                        var url = '${pageContext.request.contextPath}/BookingPageServlet?ajax=true&doctorId=' + doctorId + '&workDate=' + selectedDate;

                                        // Hiển thị container và loading
                                        document.getElementById('timeSlotsContainer_' + doctorId).style.display = 'block';
                                        document.getElementById('timeSlots_' + doctorId).innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải khung giờ...</div>';

                                        fetch(url)
                                            .then(function (response) {
                                                return response.json();
                                            })
                                            .then(function (slots) {
                                                console.log('Dữ liệu khung giờ trả về:', slots); // Debug

                                                var timeSlotsDiv = document.getElementById('timeSlots_' + doctorId);
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
                                                            clickHandler = 'onclick="selectTimeSlot(' + slot.slotId + ', \'' + slot.startTime + '\', \'' + slot.endTime + '\', ' + doctorId + ')"';
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
                                                document.getElementById('timeSlots_' + doctorId).innerHTML = '<div class="alert alert-danger">Có lỗi khi tải khung giờ</div>';
                                            });
                                    }

                                    function selectTimeSlot(slotId, startTime, endTime, doctorId) {
                                        // Kiểm tra nếu slot đã được đặt
                                        if (event.currentTarget.classList.contains('booked')) {
                                            alert('Khung giờ này đã được đặt. Vui lòng chọn khung giờ khác!');
                                            return;
                                        }

                                        // Set giá trị vào hidden input
                                        document.getElementById('selectedSlotId_' + doctorId).value = slotId;

                                        // Highlight selected time slot (chỉ với slot chưa được đặt)
                                        document.querySelectorAll('#timeSlots_' + doctorId + ' .time-slot:not(.booked)').forEach(slot => slot.classList.remove('selected'));
                                        event.currentTarget.classList.add('selected');

                                        console.log('Selected slot:', slotId, startTime, endTime, 'for doctor:', doctorId);
                                    }

                                    // Tạo function riêng cho từng doctor để tránh conflict
                                    <c:forEach items="${doctors}" var="doctor">
                                        window['selectService_${doctor.doctor_id}'] = function(serviceId, serviceName, servicePrice) {
                                            // Reset tất cả service cards
                                            document.querySelectorAll('#bookingModal${doctor.doctor_id} .service-item').forEach(card => {
                                                card.style.borderColor = '#dee2e6';
                                                card.style.background = '#f8f9fa';
                                            });

                                        // Highlight card được chọn
                                        event.currentTarget.style.borderColor = '#00796b';
                                        event.currentTarget.style.background = '#e8f5e8';

                                        // Cập nhật hidden input
                                        document.getElementById('selectedServiceId_${doctor.doctor_id}').value = serviceId;

                                        // Hiển thị thông tin service đã chọn
                                        document.getElementById('selectedServiceName_${doctor.doctor_id}').textContent = serviceName;
                                        document.getElementById('selectedServicePrice_${doctor.doctor_id}').textContent =
                                        new Intl.NumberFormat('vi-VN').format(servicePrice) + ' VNĐ';
                                        document.getElementById('selectedServiceInfo_${doctor.doctor_id}').style.display = 'block';

                                        console.log('Selected service for doctor ${doctor.doctor_id}:', serviceId, serviceName, servicePrice);
                                    };
                                    </c:forEach>

                                    // Logic xử lý tab chuyển đổi
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Handle tab switching
                                        const selfTab = document.getElementById('self-tab');
                                        const relativeTab = document.getElementById('relative-tab');

                                        selfTab.addEventListener('click', function () {
                                            // Khi chọn đặt cho mình, xóa các field người thân required
                                            const relativeFields = document.querySelectorAll('#relative-booking input, #relative-booking select');
                                            relativeFields.forEach(field => {
                                                field.removeAttribute('required');
                                            });
                                        });

                                        relativeTab.addEventListener('click', function () {
                                            // Khi chọn đặt cho người thân, thêm required cho các field
                                            const relativeFields = document.querySelectorAll('#relative-booking input, #relative-booking select');
                                            relativeFields.forEach(field => {
                                                if (!field.id.includes('hidden')) {
                                                    field.setAttribute('required', 'required');
                                                }
                                            });
                                        });
                                    });

                                    // Override form submit để thêm bookingFor và thông tin người thân
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const forms = document.querySelectorAll('form[action*="BookingPageServlet"]');
                                        forms.forEach(form => {
                                            form.addEventListener('submit', function (e) {
                                                // Kiểm tra tab nào đang active
                                                const relativeTab = document.querySelector('#relative-tab');
                                                const isRelativeBooking = relativeTab.classList.contains('active');

                                                // Thêm hidden input cho bookingFor
                                                let bookingForInput = form.querySelector('input[name="bookingFor"]');
                                                if (!bookingForInput) {
                                                    bookingForInput = document.createElement('input');
                                                    bookingForInput.type = 'hidden';
                                                    bookingForInput.name = 'bookingFor';
                                                    form.appendChild(bookingForInput);
                                                }

                                                if (isRelativeBooking) {
                                                    bookingForInput.value = 'relative';

                                                    // Thêm thông tin người thân vào form
                                                    const relativeFields = ['relativeName', 'relativePhone', 'relativeDob', 'relativeGender', 'relativeRelationship'];
                                                    relativeFields.forEach(fieldName => {
                                                        const sourceField = document.getElementById(fieldName);
                                                        let targetField = form.querySelector(`input[name="${fieldName}"], select[name="${fieldName}"]`);

                                                        if (!targetField) {
                                                            targetField = document.createElement('input');
                                                            targetField.type = 'hidden';
                                                            targetField.name = fieldName;
                                                            form.appendChild(targetField);
                                                        }

                                                        if (sourceField) {
                                                            targetField.value = sourceField.value;

                                                            // Validate required fields
                                                            if (!sourceField.value.trim()) {
                                                                e.preventDefault();
                                                                alert(`Vui lòng nhập ${sourceField.previousElementSibling.textContent}`);
                                                                sourceField.focus();
                                                                return false;
                                                            }
                                                        }
                                                    });
                                                } else {
                                                    bookingForInput.value = 'self';
                                                }
                                            });
                                        });
                                    });
                                </script>
                            </body>

                            </html>