<%-- Document : staff_quanlylichhen Created on : 14 thg 7, 2025, 19:10:40 Author : tranhongphuoc --%>

    <%@page pageEncoding="UTF-8" %>
        <%@page import="dao.AppointmentDAO" %>
            <%@page import="model.Appointment" %>
                <%@page import="java.util.List" %>
                    <%@page import="com.google.gson.Gson" %>
                        <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do khám..."
                            required></textarea>
                        </div>

                        <!-- Thông báo tự động -->
                        <div class="alert alert-success">
                            <i class="fas fa-bell"></i>
                            Thông báo tự động sẽ được gửi tới email của khách hàng
                            khi xác nhận đổi lịch.
                        </div>
                        </div>
                        <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                if (appointments == null) appointments = new java.util.ArrayList<>();
                                    %>
                                    <%! // Hàm escape chuỗi cho JS (toàn cục)
                                        public String escapeJsString(String s) {
                                        if (s==null) return "" ; return s.replace("\\", "\\\\" ).replace("'", "\\'").replace("\"", "\\\"");
}
%>
                                    <!DOCTYPE html>
                                    <html>

                                    <head>
                                        <meta charset=" UTF-8">
                                        <title>Quản lý lịch hẹn - Huỷ & Đổi lịch</title>
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
                                                content: '🚫';
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
                                                content: '⏰';
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
                                        </style>
                                        </head>

                                        <body>
                                            <div class="container">
                                                <div class="header">📅 Quản lý lịch hẹn – Huỷ & Đổi lịch</div>
                                                <div class="search-bar">
                                                    <input type="text" placeholder="Tìm theo tên hoặc SĐT..." />
                                                    <select>
                                                        <option>Tất cả trạng thái</option>
                                                        <option>Đã xác nhận</option>
                                                        <option>Chờ xác nhận</option>
                                                        <option>Đã huỷ</option>
                                                    </select>
                                                    <input type="date" />
                                                    <button>Xóa bộ lọc</button>
                                                </div>

                                                <% for (Appointment ap : appointments) { %>
                                                    <div class="card">
                                                        <%-- Trạng thái --%>
                                                            <% String status=ap.getStatus(); String statusText="" ;
                                                                String statusClass="" ; if ("BOOKED".equals(status)) {
                                                                statusText="Đã xác nhận" ;
                                                                statusClass="status-confirmed" ; } else if
                                                                ("WAITING".equals(status) || "WAITING_PAYMENT"
                                                                .equals(status)) { statusText="Chờ xác nhận" ;
                                                                statusClass="status-pending" ; } else if
                                                                ("CANCELLED".equals(status)) { statusText="Đã huỷ" ;
                                                                statusClass="status-cancelled" ; } else {
                                                                statusText=status; statusClass="" ; } %>
                                                                <div class="status <%= statusClass %>">
                                                                    <%= statusText %>
                                                                </div>
                                                                <div class="info"><b>
                                                                        <%= ap.getPatientName() !=null ?
                                                                            ap.getPatientName() : "Không rõ" %>
                                                                    </b></div>
                                                                <div class="info"><span class="label">📞</span>
                                                                    <%= ap.getPatientPhone() !=null ?
                                                                        ap.getPatientPhone() : "" %>
                                                                </div>
                                                                <div class="info"><span class="label">📅</span>
                                                                    <%= ap.getWorkDate() !=null ? ap.getWorkDate() : ""
                                                                        %>
                                                                </div>
                                                                <div class="info"><span class="label">⏰</span>
                                                                    <%= ap.getStartTime() !=null ? ap.getStartTime()
                                                                        : "" %>
                                                                </div>
                                                                <div class="info"><span class="label">Dịch vụ:</span>
                                                                    <%= ap.getServiceName() !=null ? ap.getServiceName()
                                                                        : "Chưa có dịch vụ" %>
                                                                </div>
                                                                <div class="info"><span class="label">Bác sĩ:</span>
                                                                    <%= ap.getDoctorName() !=null ? ap.getDoctorName()
                                                                        : "" %>
                                                                </div>
                                                                <% if (ap.getNote() !=null && !ap.getNote().isEmpty()) {
                                                                    %>
                                                                    <div class="note">Ghi chú: <%= ap.getNote() %>
                                                                    </div>
                                                                    <% } %>
                                                                        <div class="actions">
                                                                            <% if (!"CANCELLED".equals(status)) { %>
                                                                                <button type="button"
                                                                                    class="btn btn-cancel"
                                                                                    onclick="openCancelModal('<%= ap.getAppointmentId() %>', '<%= ap.getPatientName() %>', '<%= ap.getWorkDate() %>', '<%= ap.getStartTime() %>', '<%= ap.getServiceName() %>')">
                                                                                    Huỷ lịch
                                                                                </button>
                                                                                <button type="button"
                                                                                    class="btn btn-reschedule"
                                                                                    data-bs-toggle="modal"
                                                                                    data-bs-target="#rescheduleModal_<%= ap.getAppointmentId() %>"
                                                                                    onclick="initRescheduleModal('<%= ap.getAppointmentId() %>', '<%= escapeJsString(ap.getPatientName()) %>', '<%= ap.getWorkDate() %>', '<%= ap.getStartTime() %>', '<%= escapeJsString(ap.getServiceName()) %>')">
                                                                                    Đổi lịch
                                                                                </button>
                                                                                <% } %>
                                                                        </div>
                                                    </div>
                                                    <!-- Modal đổi lịch cho từng appointment (UI hiện đại, giữ nguyên logic backend) -->
                                                    <div class="modal fade"
                                                        id="rescheduleModal_<%= ap.getAppointmentId() %>" tabindex="-1"
                                                        aria-labelledby="rescheduleModalLabel_<%= ap.getAppointmentId() %>"
                                                        aria-hidden="true">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <div class="modal-header border-0">
                                                                    <h5 class="modal-title"><i
                                                                            class="fas fa-calendar-alt me-2"></i>Đổi
                                                                        lịch hẹn</h5>
                                                                    <button type="button" class="btn-close"
                                                                        data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <form id="rescheduleForm_<%= ap.getAppointmentId() %>"
                                                                    method="post"
                                                                    action="<%=request.getContextPath()%>/CancelAppointmentServlet">
                                                                    <input type="hidden" name="reschedule" value="1" />
                                                                    <input type="hidden" name="appointmentId"
                                                                        value="<%= ap.getAppointmentId() %>" />
                                                                    <input type="hidden" name="doctorId"
                                                                        value="<%= ap.getDoctorId() %>" />
                                                                    <input type="hidden" name="serviceId"
                                                                        id="rescheduleServiceId_<%= ap.getAppointmentId() %>">
                                                                    <input type="hidden" name="slotId"
                                                                        id="rescheduleSlotId_<%= ap.getAppointmentId() %>">
                                                                    <input type="hidden" name="workDate"
                                                                        id="rescheduleWorkDate_<%= ap.getAppointmentId() %>">
                                                                    <div class="modal-body px-4">
                                                                        <div class="bg-light p-3 rounded mb-3">
                                                                            <p><b>Bệnh nhân:</b> <span
                                                                                    id="reschedulePatient_<%= ap.getAppointmentId() %>"></span>
                                                                            </p>
                                                                            <p><b>Lịch cũ:</b> <span
                                                                                    id="rescheduleCurrentDateTime_<%= ap.getAppointmentId() %>"></span>
                                                                            </p>
                                                                            <p><b>Dịch vụ:</b> <span
                                                                                    id="rescheduleServiceName_<%= ap.getAppointmentId() %>"></span>
                                                                            </p>
                                                                        </div>
                                                                        <!-- Tabs -->
                                                                        <ul class="nav nav-tabs"
                                                                            id="rescheduleTab_<%= ap.getAppointmentId() %>"
                                                                            role="tablist">
                                                                            <li class="nav-item" role="presentation">
                                                                                <button class="nav-link active"
                                                                                    id="date-tab-<%= ap.getAppointmentId() %>"
                                                                                    data-bs-toggle="tab"
                                                                                    data-bs-target="#dateTabContent_<%= ap.getAppointmentId() %>"
                                                                                    type="button" role="tab">Chọn ngày
                                                                                    mới</button>
                                                                            </li>
                                                                            <li class="nav-item" role="presentation">
                                                                                <button class="nav-link"
                                                                                    id="time-tab-<%= ap.getAppointmentId() %>"
                                                                                    data-bs-toggle="tab"
                                                                                    data-bs-target="#timeTabContent_<%= ap.getAppointmentId() %>"
                                                                                    type="button" role="tab">Chọn giờ &
                                                                                    bác sĩ</button>
                                                                            </li>
                                                                        </ul>
                                                                        <div class="tab-content mt-3">
                                                                            <div class="tab-pane fade show active"
                                                                                id="dateTabContent_<%= ap.getAppointmentId() %>"
                                                                                role="tabpanel">
                                                                                <input type="date" class="form-control"
                                                                                    id="rescheduleDatePicker_<%= ap.getAppointmentId() %>"
                                                                                    required>
                                                                            </div>
                                                                            <div class="tab-pane fade"
                                                                                id="timeTabContent_<%= ap.getAppointmentId() %>"
                                                                                role="tabpanel">
                                                                                <div class="time-slot-grid"
                                                                                    id="rescheduleSlotGrid_<%= ap.getAppointmentId() %>">
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="mb-3 mt-3">
                                                                            <label class="form-label">Lý do đổi
                                                                                lịch:</label>
                                                                            <textarea name="reason" class="form-control"
                                                                                rows="3"
                                                                                placeholder="Nhập lý do đổi lịch..."
                                                                                required></textarea>
                                                                        </div>
                                                                        <div class="alert alert-success mt-4 mb-0">
                                                                            <i class="fas fa-bell me-2"></i>
                                                                            SMS sẽ được gửi tự động đến khách hàng thông
                                                                            báo về lịch hẹn mới.
                                                                        </div>
                                                                    </div>
                                                                    <div
                                                                        class="modal-footer border-0 justify-content-center gap-2">
                                                                        <button type="button" class="btn btn-light px-4"
                                                                            data-bs-dismiss="modal">Huỷ bỏ</button>
                                                                        <button type="submit"
                                                                            class="btn btn-primary px-4"
                                                                            id="rescheduleSubmitBtn_<%= ap.getAppointmentId() %>"
                                                                            disabled>
                                                                            Xác nhận đổi lịch
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                                        <div class="footer-stats">
                                                            <div class="stat">Đã xác nhận:
                                                                <%=appointments.stream().filter(a ->
                                                                    "BOOKED".equals(a.getStatus())).count() %>
                                                            </div>
                                                            <div class="stat">Chờ xác nhận:
                                                                <%=appointments.stream().filter(a ->
                                                                    "WAITING".equals(a.getStatus()) ||
                                                                    "WAITING_PAYMENT".equals(a.getStatus())).count() %>
                                                            </div>
                                                            <div class="stat">Đã huỷ: <%= appointments.stream().filter(a
                                                                    ->
                                                                    "CANCELLED".equals(a.getStatus())).count() %></div>
                                                            <div class="stat">Hoàn thành: <%=
                                                                    appointments.stream().filter(a ->
                                                                    "COMPLETED".equals(a.getStatus())).count() %></div>
                                                        </div>
                                                        <div style="margin-top: 24px;">
                                                            <a href="<%=request.getContextPath()%>/home.jsp">&larr; Quay
                                                                lại
                                                                trang
                                                                chủ</a>
                                                        </div>
                                            </div>
                                            <!-- Modal Huỷ lịch -->
                                            <div id="cancelModal"
                                                style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.25); align-items:center; justify-content:center;">
                                                <div
                                                    style="background:#fff; border-radius:16px; padding:32px 28px; max-width:420px; margin:auto; position:relative; box-shadow:0 8px 32px #0002;">
                                                    <div
                                                        style="display:flex; align-items:center; gap:10px; margin-bottom:18px;">
                                                        <span style="font-size:2.2em; color:#ef4444;">&#9888;</span>
                                                        <h2 style="color:#ef4444; font-size:1.3em; margin:0;">Huỷ lịch
                                                            hẹn
                                                        </h2>
                                                    </div>
                                                    <form id="cancelForm" method="post"
                                                        action="<%=request.getContextPath()%>/CancelAppointmentServlet">
                                                        <div
                                                            style="background:#f3f4f6; border-radius:8px; padding:12px 16px; margin-bottom:18px;">
                                                            <div style="margin-bottom:4px;"><b>Bệnh nhân:</b> <span
                                                                    id="cancelPatient"></span></div>
                                                            <div style="margin-bottom:4px;"><b>Ngày:</b> <span
                                                                    id="cancelDate"></span> <b>Giờ:</b> <span
                                                                    id="cancelTime"></span></div>
                                                            <div><b>Dịch vụ:</b> <span id="cancelService"></span></div>
                                                        </div>
                                                        <input type="hidden" name="appointmentId"
                                                            id="cancelAppointmentId" />
                                                        <div style="margin-bottom:10px;">
                                                            <label
                                                                style="font-weight:500; display:block; margin-bottom:4px;">Lý
                                                                do
                                                                huỷ lịch <span style="color:red">*</span></label>
                                                            <select name="cancelReason" required
                                                                style="width:100%; padding:8px; border-radius:6px; border:1px solid #ccc;">
                                                                <option value="">Chọn lý do huỷ</option>
                                                                <option value="Bận việc">Bận việc</option>
                                                                <option value="Không còn nhu cầu">Không còn nhu cầu
                                                                </option>
                                                                <option value="Khác">Khác</option>
                                                            </select>
                                                        </div>
                                                        <div style="margin-bottom:10px;">
                                                            <label
                                                                style="font-weight:500; display:block; margin-bottom:4px;">Ghi
                                                                chú thêm</label>
                                                            <textarea name="cancelNote"
                                                                style="width:100%; min-height:60px; border-radius:6px; border:1px solid #ccc;"
                                                                placeholder="Thêm ghi chú nếu cần..."></textarea>
                                                        </div>
                                                        <div
                                                            style="background:#fef9c3; color:#b45309; border-radius:6px; padding:8px; margin:12px 0; font-size:0.97em;">
                                                            <b>&#9888; Thông báo tự động:</b> Email sẽ gửi tới khách
                                                            hàng
                                                            khi
                                                            huỷ
                                                            lịch.
                                                        </div>
                                                        <div style="display:flex; gap:10px; margin-top:12px;">
                                                            <button type="button" onclick="closeCancelModal()"
                                                                style="flex:1; border:1px solid #ccc; background:#fff; border-radius:6px;">Huỷ
                                                                bỏ</button>
                                                            <button type="submit"
                                                                style="flex:1; background:#ef4444; color:#fff; border:none; border-radius:6px; font-weight:600;">Xác
                                                                nhận huỷ lịch</button>
                                                        </div>
                                                    </form>
                                                    <span onclick="closeCancelModal()"
                                                        style="position:absolute; top:10px; right:18px; cursor:pointer; font-size:1.7em; color:#888;">&times;</span>
                                                </div>
                                            </div>
                                        </body>

                                        </html>