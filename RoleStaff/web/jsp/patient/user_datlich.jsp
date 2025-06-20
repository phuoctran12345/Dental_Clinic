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
                                </style>
                            </head>

                            <body>
                                <div class="container">
                                    <h2 class="mb-4">Đặt lịch khám bệnh</h2>

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
                                                        html += '<div class="time-slot" onclick="selectTimeSlot(' + slot.slotId + ', \'' + slot.startTime + '\', \'' + slot.endTime + '\', ' + doctorId + ')">' +
                                                            '<strong>' + slot.startTime + ' - ' + slot.endTime + '</strong><br>' +
                                                            '<small>Slot ID: ' + slot.slotId + '</small>' +
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
                                        // Set giá trị vào hidden input
                                        document.getElementById('selectedSlotId_' + doctorId).value = slotId;

                                        // Highlight selected time slot
                                        document.querySelectorAll('#timeSlots_' + doctorId + ' .time-slot').forEach(slot => slot.classList.remove('selected'));
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
                                </script>
                            </body>

                            </html>