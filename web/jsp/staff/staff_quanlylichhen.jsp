<%-- Document : staff_quanlylichhen Created on : 14 thg 7, 2025, 19:10:40 Author : tranhongphuoc --%>

    <%@page pageEncoding="UTF-8" %>
        <%@page import="dao.AppointmentDAO" %>
            <%@page import="model.Appointment" %>
                <%@page import="java.util.List" %>
                    <%@page import="com.google.gson.Gson" %>


                        </div>
                        <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                if (appointments == null) appointments = new java.util.ArrayList<>();
                                    %>
                                    <%! // HÃ m escape chuá»i cho JS (toÃ n cá»¥c)
                                        public String escapeJsString(String
                                        s) { if (s==null) return "" ; return s.replace("\\", "\\\\" ).replace("'", "\\'"
                                        ).replace("\"", "\\\"");
}
%>
                                    <!DOCTYPE html>
                                    <html>

                                    <head>
                                        <meta charset=" UTF-8">
                                        <title>Quản lý lịch hẹn - Huỷ & Đổi lịch</title>
                                        <link
                                            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                            rel="stylesheet">
                                        <style>
                                            body {
                                                background: #f4f6fb;
                                                font-family: Arial, sans-serif;
                                            }

                                            .container {
                                                max-width: 1200px;
                                                margin: 30px auto;
                                            }

                                            .header {
                                                font-size: 2rem;
                                                color: #3b82f6;
                                                font-weight: bold;
                                                margin-bottom: 24px;
                                            }

                                            .search-bar {
                                                display: flex;
                                                gap: 12px;
                                                margin-bottom: 24px;
                                            }

                                            .search-bar input,
                                            .search-bar select {
                                                padding: 8px 12px;
                                                border-radius: 6px;
                                                border: 1px solid #ccc;
                                            }

                                            .card-list {
                                                display: flex;
                                                flex-wrap: wrap;
                                                gap: 24px;
                                            }

                                            .card {
                                                background: #fff;
                                                border-radius: 12px;
                                                box-shadow: 0 2px 8px #0001;
                                                padding: 20px;
                                                width: 320px;
                                                position: relative;
                                            }

                                            .card .status {
                                                position: absolute;
                                                top: 16px;
                                                right: 16px;
                                                font-size: 0.9em;
                                                padding: 4px 10px;
                                                border-radius: 8px;
                                            }

                                            .status-confirmed {
                                                background: #e0fbe0;
                                                color: #16a34a;
                                            }

                                            .status-pending {
                                                background: #fef9c3;
                                                color: #b45309;
                                            }

                                            .status-cancelled {
                                                background: #fee2e2;
                                                color: #dc2626;
                                            }

                                            .info {
                                                margin-bottom: 8px;
                                            }

                                            .label {
                                                color: #888;
                                                font-size: 0.95em;
                                            }

                                            .actions {
                                                display: flex;
                                                gap: 8px;
                                                margin-top: 12px;
                                            }

                                            .btn {
                                                padding: 8px 16px;
                                                border: none;
                                                border-radius: 6px;
                                                cursor: pointer;
                                                font-weight: 500;
                                            }

                                            .btn-cancel {
                                                background: #ef4444;
                                                color: #fff;
                                            }

                                            .btn-reschedule {
                                                background: #fff;
                                                color: #3b82f6;
                                                border: 1px solid #3b82f6;
                                            }

                                            .note {
                                                background: #f3f4f6;
                                                border-radius: 6px;
                                                padding: 8px;
                                                margin-top: 8px;
                                                font-size: 0.95em;
                                            }

                                            .footer-stats {
                                                display: flex;
                                                gap: 24px;
                                                margin-top: 32px;
                                            }

                                            .stat {
                                                background: #fff;
                                                border-radius: 8px;
                                                padding: 16px 32px;
                                                font-size: 1.1em;
                                                color: #3b82f6;
                                                font-weight: bold;
                                            }

                                            .time-slots {
                                                display: grid;
                                                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                                                gap: 10px;
                                                margin-top: 10px;
                                            }

                                            .time-slot {
                                                padding: 10px;
                                                text-align: center;
                                                border: 1px solid #ddd;
                                                border-radius: 5px;
                                                cursor: pointer;
                                                transition: all 0.2s;
                                                background: white;
                                                margin-bottom: 4px;
                                                position: relative;
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
                                            }

                                            .time-slot.booked::after {
                                                content: 'ð«';
                                                position: absolute;
                                                top: 2px;
                                                right: 5px;
                                                font-size: 12px;
                                            }

                                            .time-slot.expired {
                                                background: linear-gradient(135deg, #6c757d, #495057);
                                                color: white;
                                                border-color: #6c757d;
                                                cursor: not-allowed;
                                                opacity: 0.7;
                                            }

                                            .time-slot.expired::after {
                                                content: 'â°';
                                                position: absolute;
                                                top: 2px;
                                                right: 5px;
                                                font-size: 12px;
                                            }

                                            .modal-content {
                                                border: none;
                                                border-radius: 16px;
                                                box-shadow: 0 10px 34px -15px rgba(0, 0, 0, 0.24);
                                            }

                                            .modal-header {
                                                padding: 20px 24px;
                                            }

                                            .patient-info {
                                                background: #f8f9fa;
                                                padding: 16px;
                                                border-radius: 12px;
                                            }

                                            .step-container {
                                                opacity: 0.5;
                                                transition: opacity 0.3s;
                                            }

                                            .step-container.active {
                                                opacity: 1;
                                            }

                                            .step-title {
                                                font-weight: 600;
                                                color: #1a1a1a;
                                            }

                                            .step-action {
                                                color: #6b7280;
                                                font-size: 0.9em;
                                            }

                                            .time-slot-grid {
                                                display: grid;
                                                grid-template-columns: repeat(3, 1fr);
                                                gap: 12px;
                                            }

                                            .time-slot {
                                                border: 1px solid #e5e7eb;
                                                border-radius: 8px;
                                                padding: 12px;
                                                text-align: center;
                                                cursor: pointer;
                                                transition: all 0.2s;
                                                background: white;
                                            }

                                            .time-slot:hover {
                                                border-color: #3b82f6;
                                                background: #f0f9ff;
                                            }

                                            .time-slot.selected {
                                                background: #3b82f6;
                                                color: white;
                                                border-color: #3b82f6;
                                            }

                                            .time-slot.booked {
                                                background: #fee2e2;
                                                border-color: #ef4444;
                                                color: #ef4444;
                                                cursor: not-allowed;
                                                opacity: 0.7;
                                            }

                                            .btn {
                                                padding: 8px 20px;
                                                border-radius: 8px;
                                                font-weight: 500;
                                            }

                                            .btn-primary {
                                                background: #3b82f6;
                                                border: none;
                                            }

                                            .btn-primary:hover {
                                                background: #2563eb;
                                            }

                                            .btn-light {
                                                background: #f3f4f6;
                                                border: none;
                                                color: #4b5563;
                                            }

                                            .btn-light:hover {
                                                background: #e5e7eb;
                                            }

                                            .alert-success {
                                                background: #f0fdf4;
                                                border: 1px solid #bbf7d0;
                                                color: #15803d;
                                                border-radius: 8px;
                                            }

                                            .time-slot.past {
                                                background: #cfd2d6;
                                                color: #555;
                                                border-color: #bbb;
                                                cursor: not-allowed;
                                                opacity: 0.85;
                                                position: relative;
                                                font-weight: 500;
                                            }

                                            .time-slot.past:hover {
                                                background: #cfd2d6;
                                                color: #555;
                                                border-color: #bbb;
                                                transform: none;
                                            }
                                        </style>
                                        </head>

                                        <body>
                                            <div class="container py-4">
                                                <h2 class="mb-4">📅 Quản lý lịch hẹn</h2>
                                                <ul class="nav nav-tabs mb-3" id="manageTabs" role="tablist">
                                                    <li class="nav-item" role="presentation">
                                                        <button class="nav-link active" id="list-tab"
                                                            data-bs-toggle="tab" data-bs-target="#listTabContent"
                                                            type="button" role="tab">Danh sách lịch hẹn</button>
                                                    </li>
                                                    <li class="nav-item" role="presentation">
                                                        <button class="nav-link" id="reschedule-tab"
                                                            data-bs-toggle="tab" data-bs-target="#rescheduleTabContent"
                                                            type="button" role="tab">Đổi lịch</button>
                                                    </li>
                                                    <li class="nav-item" role="presentation">
                                                        <button class="nav-link" id="cancel-tab" data-bs-toggle="tab"
                                                            data-bs-target="#cancelTabContent" type="button"
                                                            role="tab">Huỷ lịch</button>
                                                    </li>
                                                </ul>
                                                <div class="tab-content" id="manageTabsContent">
                                                    <!-- Tab 1: Danh sÃ¡ch lá»ch háº¹n -->
                                                    <div class="tab-pane fade show active" id="listTabContent"
                                                        role="tabpanel">
                                                        <div class="mb-3 d-flex justify-content-between">
                                                            <input type="text" class="form-control w-25"
                                                                placeholder="Tìm kiếm tên, SĐT...">
                                                            <select class="form-select w-25">
                                                                <option value="">Tất cả trạng thái</option>
                                                                <option value="BOOKED">Đã xác nhận</option>
                                                                <option value="WAITING">Chờ xác nhận</option>
                                                                <option value="CANCELLED">Đã huỷ</option>
                                                            </select>
                                                        </div>
                                                        <table class="table table-bordered table-hover align-middle">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th>Bệnh nhân</th>
                                                                    <th>Ngày</th>
                                                                    <th>Giờ</th>
                                                                    <th>Dịch vụ</th>
                                                                    <th>Bác sĩ</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% for (Appointment ap : appointments) { %>
                                                                    <tr>
                                                                        <td>
                                                                            <%= ap.getPatientName() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= ap.getWorkDate() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= ap.getStartTime() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= ap.getServiceName() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= ap.getDoctorName() %>
                                                                        </td>
                                                                        <td>
                                                                            <% if ("BOOKED".equals(ap.getStatus())) { %>
                                                                                <span class="badge bg-success">Đã xác
                                                                                    nhận</span>
                                                                                <% } else if
                                                                                    ("WAITING".equals(ap.getStatus())
                                                                                    || "WAITING_PAYMENT"
                                                                                    .equals(ap.getStatus())) { %>
                                                                                    <span
                                                                                        class="badge bg-warning text-dark">Chờ
                                                                                        xác nhận</span>
                                                                                    <% } else if
                                                                                        ("CANCELLED".equals(ap.getStatus()))
                                                                                        { %>
                                                                                        <span class="badge bg-danger">Đã
                                                                                            huỷ</span>
                                                                                        <% } else { %>
                                                                                            <span
                                                                                                class="badge bg-secondary">
                                                                                                <%= ap.getStatus() %>
                                                                                            </span>
                                                                                            <% } %>
                                                                        </td>
                                                                        <td>
                                                                            <% if (!"CANCELLED".equals(ap.getStatus()))
                                                                                { %>
                                                                                <button class="btn btn-sm btn-primary"
                                                                                    onclick="switchToReschedule('<%= ap.getAppointmentId() %>')">Đổi
                                                                                    lịch</button>
                                                                                <button class="btn btn-sm btn-danger"
                                                                                    onclick="switchToCancel('<%= ap.getAppointmentId() %>')">Huỷ
                                                                                    lịch</button>
                                                                                <% } %>
                                                                        </td>
                                                                    </tr>
                                                                    <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <!-- Tab 2: Đổi lịch -->
                                                    <div class="tab-pane fade" id="rescheduleTabContent"
                                                        role="tabpanel">
                                                        <form id="rescheduleForm" method="post"
                                                            action="<%=request.getContextPath()%>/CancelAppointmentServlet">
                                                            <input type="hidden" name="reschedule" value="1" />
                                                            <input type="hidden" name="doctorId"
                                                                id="rescheduleDoctorId">
                                                            <input type="hidden" name="serviceId"
                                                                id="rescheduleServiceId">
                                                            <div class="mb-3">
                                                                <label>Chọn lịch hẹn cần đổi:</label>
                                                                <select id="rescheduleAppointmentId"
                                                                    name="appointmentId" class="form-select" required
                                                                    onchange="onRescheduleAppointmentChange()">
                                                                    <% for (Appointment ap : appointments) { if
                                                                        (!"CANCELLED".equals(ap.getStatus())) { %>
                                                                        <option value="<%= ap.getAppointmentId() %>"
                                                                            data-doctor-id="<%= ap.getDoctorId() %>"
                                                                            data-service-id="<%= ap.getServiceId() %>">
                                                                            <%= ap.getPatientName() %> - <%=
                                                                                    ap.getWorkDate() %>
                                                                                    <%= ap.getStartTime() %>
                                                                        </option>
                                                                        <% } } %>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label>Chọn ngày mới:</label>
                                                                <input type="date" id="rescheduleDatePicker"
                                                                    name="workDate" class="form-control" required
                                                                    onchange="if(this.value) updateStaffSlots(getSelectedDoctorId(), this.value, 'rescheduleSlotGrid')">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label>Chọn ca khám mới:</label>
                                                                <div class="time-slot-grid" id="rescheduleSlotGrid">
                                                                </div>
                                                                <input type="hidden" name="slotId"
                                                                    id="rescheduleSlotId">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label>Lý do đổi lịch:</label>
                                                                <textarea name="reason" class="form-control" rows="3"
                                                                    required></textarea>
                                                            </div>
                                                            <div class="text-end">
                                                                <button type="submit" class="btn btn-primary">Xác nhận
                                                                    đổi lịch</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                    <!-- Tab 3: Huỷ lịch -->
                                                    <div class="tab-pane fade" id="cancelTabContent" role="tabpanel">
                                                        <form id="cancelForm" method="post"
                                                            action="<%=request.getContextPath()%>/CancelAppointmentServlet">
                                                            <div class="mb-3">
                                                                <label>Chọn lịch hẹn cần huỷ:</label>
                                                                <select id="cancelAppointmentId" name="appointmentId"
                                                                    class="form-select" required>
                                                                    <% for (Appointment ap : appointments) { if
                                                                        (!"CANCELLED".equals(ap.getStatus())) { %>
                                                                        <option value="<%= ap.getAppointmentId() %>">
                                                                            <%= ap.getPatientName() %> - <%=
                                                                                    ap.getWorkDate() %>
                                                                                    <%= ap.getStartTime() %>
                                                                        </option>
                                                                        <% } } %>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label>Lý do huỷ lịch:</label>
                                                                <select name="cancelReason" class="form-select"
                                                                    required>
                                                                    <option value="">Chọn lý do huỷ</option>
                                                                    <option value="Bận việc">Bận việc</option>
                                                                    <option value="Không còn nhu cầu">Không còn nhu cầu
                                                                    </option>
                                                                    <option value="Khác">Khác</option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label>Ghi chú thêm:</label>
                                                                <textarea name="cancelNote" class="form-control"
                                                                    rows="2"></textarea>
                                                            </div>
                                                            <div class="text-end">
                                                                <button type="submit" class="btn btn-danger">Xác nhận
                                                                    huỷ lịch</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                            <script
                                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                            <script>
                                                function updateStaffSlots(doctorId, workDate, containerId) {
                                                    console.log('updateStaffSlots:', { doctorId, workDate, containerId });
                                                    if (!doctorId || !workDate) return;
                                                    var url = '/CancelAppointmentServlet?action=getSlots&doctorId=' + doctorId + '&workDate=' + workDate;
                                                    fetch(url)
                                                        .then(res => res.json())
                                                        .then(slots => {
                                                            var html = '';
                                                            slots.forEach(slot => {
                                                                var slotClass = 'time-slot';
                                                                var statusText = '';
                                                                var clickHandler = '';
                                                                if (slot.isBooked) {
                                                                    slotClass += ' booked';
                                                                    statusText = '<small class="text-danger">Đã ñã được đặt</small>';
                                                                } else if (slot.isPast) {
                                                                    slotClass += ' past';
                                                                    statusText = '<small class="text-secondary">Đã quá giờ khám</small>';
                                                                } else {
                                                                    clickHandler = 'onclick="selectStaffSlot(' + slot.slotId + ', \'' + slot.startTime + '\', \'' + slot.endTime + '\')"';
                                                                    statusText = '<small class="text-success">Còn trống</small>';
                                                                }
                                                                html += '<div class="' + slotClass + '" ' + clickHandler + '>' +
                                                                    '<strong>' + slot.startTime + ' - ' + slot.endTime + '</strong><br>' +
                                                                    statusText +
                                                                    '</div>';
                                                            });
                                                            document.getElementById(containerId).innerHTML = html;
                                                        });
                                                }
                                                function selectStaffSlot(slotId, startTime, endTime) {
                                                    // Kiểm tra nếu slot đã được đặt
                                                    if (event.currentTarget.classList.contains('booked')) {
                                                        alert('Khung giờ này đã được đặt. Vui lòng chọn khung giờ khác!');
                                                        return;
                                                    }
                                                    if (event.currentTarget.classList.contains('past')) {
                                                        alert('Khung giờ này đã quá thời gian khám!');
                                                        return;
                                                    }
                                                    // Set giá trị vào hidden input
                                                    document.getElementById('rescheduleSlotId').value = slotId;

                                                    // Highlight selected time slot
                                                    document.querySelectorAll('.time-slot:not(.booked)').forEach(slot => slot.classList.remove('selected'));
                                                    event.currentTarget.classList.add('selected');
                                                }
                                                function getSelectedDoctorId() {
                                                    var select = document.getElementById('rescheduleAppointmentId');
                                                    if (!select) return '';
                                                    var selectedOption = select.options[select.selectedIndex];
                                                    return selectedOption ? selectedOption.getAttribute('data-doctor-id') : '';
                                                }
                                                function switchToReschedule(appointmentId) {
                                                    var tab = new bootstrap.Tab(document.getElementById('reschedule-tab'));
                                                    tab.show();
                                                    var select = document.getElementById('rescheduleAppointmentId');
                                                    if (select) {
                                                        select.value = appointmentId;
                                                        onRescheduleAppointmentChange();
                                                        // Nếu đã chọn ngày mới thì render luôn ca khám
                                                        var workDate = document.getElementById('rescheduleDatePicker').value;
                                                        var doctorId = document.getElementById('rescheduleDoctorId').value;
                                                        if (workDate && doctorId) {
                                                            updateStaffSlots(doctorId, workDate, 'rescheduleSlotGrid');
                                                        }
                                                    }
                                                }
                                                function switchToCancel(appointmentId) {
                                                    var tab = new bootstrap.Tab(document.getElementById('cancel-tab'));
                                                    tab.show();
                                                    document.getElementById('cancelAppointmentId').value = appointmentId;
                                                }
                                                function onRescheduleAppointmentChange() {
                                                    var select = document.getElementById('rescheduleAppointmentId');
                                                    console.log('[DEBUG] onRescheduleAppointmentChange - select:', select);
                                                    if (!select) return; // Nếu không có select thì thoát luôn, tránh lỗi
                                                    var selectedOption = select.options[select.selectedIndex];
                                                    console.log('[DEBUG] selectedOption:', selectedOption);
                                                    var doctorId = selectedOption.getAttribute('data-doctor-id') || '';
                                                    var serviceId = selectedOption.getAttribute('data-service-id') || '';
                                                    console.log('[DEBUG] doctorId:', doctorId, 'serviceId:', serviceId);
                                                    document.getElementById('rescheduleDoctorId').value = doctorId;
                                                    document.getElementById('rescheduleServiceId').value = serviceId;
                                                    document.getElementById('rescheduleDatePicker').value = '';
                                                    document.getElementById('rescheduleSlotGrid').innerHTML = '';
                                                }
                                                // Gọi khi trang load để set giá trị ban đầu
                                                window.addEventListener('DOMContentLoaded', function () {
                                                    onRescheduleAppointmentChange();
                                                });


                                                ///

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
                                                                    } else if (slot.isPast) {
                                                                        slotClass += ' past';
                                                                        statusText = '<small class="text-secondary">Đã quá giờ khám</small>';
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
                                            </script>
                                        </body>

                                        </html>