<%-- Document : staff_quanlyhangdoibenhnhan Created on : 20 thg 6, 2025, 22:29:08 Author : tranhongphuoc --%>

    <%@page pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%@ include file="/jsp/staff/staff_header.jsp" %>
                <%@ include file="/jsp/staff/staff_menu.jsp" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <title>Quản lý hàng đợi bệnh nhân</title>
                        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                            rel="stylesheet">
                        <style>
                            * {
                                margin: 0;
                                padding: 0;
                                box-sizing: border-box;
                            }

                            body {
                                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                min-height: 100vh;
                            }

                            .main-content {
                                margin-left: 280px;
                                padding: 24px;
                                min-height: 100vh;
                            }

                            /* Header Section */
                            .page-header {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                margin-bottom: 24px;
                            }

                            .page-title {
                                color: #1e3a8a;
                                font-size: 2rem;
                                font-weight: 700;
                                margin-bottom: 4px;
                            }

                            .page-subtitle {
                                color: #2563eb;
                                font-size: 1rem;
                            }

                            .header-actions {
                                display: flex;
                                gap: 8px;
                            }

                            .btn-refresh {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                padding: 8px 16px;
                                background: white;
                                border: 1px solid #dbeafe;
                                color: #1d4ed8;
                                border-radius: 8px;
                                cursor: pointer;
                                text-decoration: none;
                            }

                            .btn-refresh:hover {
                                background: #eff6ff;
                            }

                            /* Stats Grid */
                            .stats-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                gap: 16px;
                                margin-bottom: 24px;
                            }

                            .stat-card {
                                background: white;
                                border: 1px solid #e5e7eb;
                                border-radius: 12px;
                                padding: 20px;
                                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                            }

                            .stat-content {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                            }

                            .stat-info h3 {
                                font-size: 0.875rem;
                                font-weight: 500;
                                margin-bottom: 4px;
                                color: #2563eb;
                            }

                            .stat-number {
                                font-size: 2rem;
                                font-weight: 700;
                                color: #1e3a8a;
                            }

                            .stat-icon {
                                font-size: 32px;
                                color: #3b82f6;
                            }

                            /* Queue List */
                            .queue-card {
                                background: white;
                                border: 1px solid #dbeafe;
                                border-radius: 12px;
                                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                            }

                            .queue-header {
                                background: linear-gradient(135deg, #eff6ff 0%, #e0f2fe 100%);
                                padding: 20px;
                                border-bottom: 1px solid #dbeafe;
                            }

                            .queue-title {
                                color: #1e3a8a;
                                font-size: 1.25rem;
                                font-weight: 600;
                                margin-bottom: 4px;
                            }

                            .queue-subtitle {
                                color: #2563eb;
                                font-size: 0.875rem;
                            }

                            .queue-list {
                                display: flex;
                                flex-direction: column;
                            }

                            .queue-item {
                                display: flex;
                                align-items: center;
                                padding: 16px 20px;
                                border-bottom: 1px solid #eff6ff;
                            }

                            .queue-item:last-child {
                                border-bottom: none;
                            }

                            .item-content {
                                display: flex;
                                align-items: center;
                                width: 100%;
                                gap: 16px;
                            }

                            .patient-number {
                                width: 48px;
                                height: 48px;
                                border-radius: 50%;
                                background: #dbeafe;
                                color: #1d4ed8;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: 700;
                                font-size: 18px;
                            }

                            .patient-info {
                                flex: 1;
                            }

                            .info-row {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                margin-bottom: 8px;
                            }

                            .patient-name {
                                font-weight: 600;
                                color: #1e3a8a;
                                font-size: 1.1rem;
                            }

                            .status-badge {
                                padding: 4px 12px;
                                border-radius: 20px;
                                font-size: 0.75rem;
                                font-weight: 600;
                                text-transform: uppercase;
                            }

                            .status-badge.confirmed {
                                background: #dbeafe;
                                color: #1d4ed8;
                            }



                            .status-badge.treatment {
                                background: #f3e8ff;
                                color: #7c3aed;
                            }

                            .status-badge.completed {
                                background: #d1fae5;
                                color: #059669;
                            }

                            .status-badge.other {
                                background: #f3f4f6;
                                color: #374151;
                            }

                            .details-grid {
                                display: grid;
                                grid-template-columns: repeat(2, 1fr);
                                gap: 8px;
                            }

                            .detail-item {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                font-size: 0.875rem;
                                color: #3b82f6;
                            }

                            .detail-item i {
                                width: 16px;
                                color: #2563eb;
                            }

                            .action-buttons {
                                display: flex;
                                gap: 8px;
                                align-items: center;
                            }

                            .status-update-dropdown {
                                position: relative;
                            }

                            .status-select {
                                padding: 6px 10px;
                                border: 1px solid #dbeafe;
                                border-radius: 6px;
                                background: white;
                                color: #1e3a8a;
                                font-size: 0.8rem;
                                font-weight: 500;
                                cursor: pointer;
                                min-width: 130px;
                                transition: all 0.2s;
                            }

                            .status-select:hover {
                                border-color: #3b82f6;
                                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.1);
                            }

                            .status-select:focus {
                                outline: none;
                                border-color: #2563eb;
                                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                            }

                            .btn-action {
                                width: 32px;
                                height: 32px;
                                border-radius: 50%;
                                border: none;
                                background: transparent;
                                cursor: pointer;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                transition: all 0.2s;
                            }

                            .btn-action.phone:hover {
                                background: #dbeafe;
                                color: #2563eb;
                            }

                            .btn-action.view:hover {
                                background: #f0fdf4;
                                color: #16a34a;
                            }

                            .btn-action.edit:hover {
                                background: #fef3c7;
                                color: #d97706;
                            }

                            .empty-state {
                                padding: 40px;
                                text-align: center;
                                color: #6b7280;
                            }

                            .empty-state i {
                                font-size: 48px;
                                margin-bottom: 16px;
                            }

                            /* Responsive */
                            @media (max-width: 768px) {
                                .main-content {
                                    margin-left: 0;
                                    padding: 16px;
                                }

                                .details-grid {
                                    grid-template-columns: 1fr;
                                }

                                .stats-grid {
                                    grid-template-columns: repeat(2, 1fr);
                                }
                            }
                        </style>
                    </head>

                    <body>
                        <div class="main-content">
                            <!-- Header -->
                            <div class="page-header">
                                <div>
                                    <h1 class="page-title">Quản lý hàng đợi</h1>
                                    <p class="page-subtitle">Danh sách bệnh nhân - <span id="current-time"></span></p>
                                </div>
                                <a href="StaffHandleQueueServlet" class="btn-refresh">
                                    <i class="fas fa-sync-alt"></i>
                                    Làm mới
                                </a>
                            </div>

                            <!-- Stats Grid -->
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-content">
                                        <div class="stat-info">
                                            <h3>Tổng số</h3>
                                            <div class="stat-number">${totalAppointments}</div>
                                        </div>
                                        <i class="fas fa-users stat-icon"></i>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-content">
                                        <div class="stat-info">
                                            <h3>Đã đặt lịch</h3>
                                            <div class="stat-number">${bookedCount}</div>
                                        </div>
                                        <i class="fas fa-calendar-check stat-icon"></i>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-content">
                                        <div class="stat-info">
                                            <h3>Hoàn thành</h3>
                                            <div class="stat-number">${completedCount}</div>
                                        </div>
                                        <i class="fas fa-check-circle stat-icon"></i>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-content">
                                        <div class="stat-info">
                                            <h3>Đã hủy</h3>
                                            <div class="stat-number">${cancelledCount}</div>
                                        </div>
                                        <i class="fas fa-times-circle stat-icon"></i>
                                    </div>
                                </div>


                            </div>

                            <!-- Queue List -->
                            <div class="queue-card">
                                <div class="queue-header">
                                    <h2 class="queue-title">Danh sách hàng đợi</h2>
                                    <p class="queue-subtitle">Hiển thị ${totalAppointments} lịch hẹn hôm nay - <span
                                            id="current-date"></span></p>
                                </div>

                                <div class="queue-list">
                                    <c:choose>
                                        <c:when test="${not empty appointments}">
                                            <c:forEach var="appointment" items="${appointments}" varStatus="status">
                                                <div class="queue-item">
                                                    <div class="item-content">
                                                        <div class="patient-number">
                                                            <span class="number">${status.index + 1}</span>
                                                        </div>

                                                        <div class="patient-info">
                                                            <div class="info-row">
                                                                <h4 class="patient-name">${appointment.patientName}</h4>
                                                                <c:choose>
                                                                    <c:when test="${appointment.status == 'BOOKED'}">
                                                                        <div class="status-badge confirmed">Đã đặt lịch
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'COMPLETED'}">
                                                                        <div class="status-badge completed">Hoàn thành
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'CANCELLED'}">
                                                                        <div class="status-badge other">Đã hủy</div>
                                                                    </c:when>

                                                                    <c:when
                                                                        test="${appointment.status == 'WAITING_PAYMENT'}">
                                                                        <div class="status-badge confirmed">Đã đặt lịch
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="status-badge other">
                                                                            ${appointment.status}</div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>

                                                            <div class="details-grid">
                                                                <div class="detail-item">
                                                                    <i class="fas fa-user-md"></i>
                                                                    <span>${appointment.doctorName}</span>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <i class="fas fa-tooth"></i>
                                                                    <span>${appointment.serviceName}</span>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <i class="fas fa-calendar"></i>
                                                                    <span>${appointment.workDate}</span>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <i class="fas fa-phone"></i>
                                                                    <span>${appointment.patientPhone}</span>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="action-buttons">
                                                            <!-- Status Update Dropdown - 4 Status Mới -->
                                                            <div class="status-update-dropdown">
                                                                <select class="status-select"
                                                                    onchange="updateAppointmentStatus(${appointment.appointmentId}, this.value)"
                                                                    title="Thay đổi trạng thái">
                                                                    <!-- Current Status -->
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${appointment.status == 'BOOKED'}">
                                                                            <option value="BOOKED" selected>📅 Đã đặt
                                                                                lịch</option>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${appointment.status == 'COMPLETED'}">
                                                                            <option value="COMPLETED" selected>✅ Hoàn
                                                                                thành</option>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${appointment.status == 'CANCELLED'}">
                                                                            <option value="CANCELLED" selected>❌ Đã hủy
                                                                            </option>
                                                                        </c:when>

                                                                        <c:when test="${appointment.status == 'WAITING_PAYMENT'}">
                                                                            <option value="BOOKED" selected>📅 Đã đặt lịch</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${appointment.status}"
                                                                                selected>${appointment.status}</option>
                                                                        </c:otherwise>
                                                                    </c:choose>

                                                                    <!-- Other Options -->
                                                                    <c:if test="${appointment.status != 'BOOKED'}">
                                                                        <option value="BOOKED">📅 Đã đặt lịch</option>
                                                                    </c:if>
                                                                    <c:if test="${appointment.status != 'COMPLETED'}">
                                                                        <option value="COMPLETED">✅ Hoàn thành</option>
                                                                    </c:if>
                                                                    <c:if test="${appointment.status != 'CANCELLED'}">
                                                                        <option value="CANCELLED">❌ Đã hủy</option>
                                                                    </c:if>

                                                                </select>
                                                            </div>

                                                            <button class="btn-action phone"
                                                                onclick="callPatient('${appointment.patientPhone}', '${appointment.patientName}')"
                                                                title="Gọi điện">
                                                                <i class="fas fa-phone"></i>
                                                            </button>
                                                            <button class="btn-action view"
                                                                onclick="copyPhone('${appointment.patientPhone}', '${appointment.patientName}')"
                                                                title="Copy số điện thoại">
                                                                <i class="fas fa-copy"></i>
                                                            </button>
                                                            <button class="btn-action edit"
                                                                onclick="editAppointment(${appointment.appointmentId})"
                                                                title="Chỉnh sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-calendar-times"></i>
                                                <h3>Chưa có lịch hẹn</h3>
                                                <p>Hiện tại không có lịch hẹn nào trong hệ thống.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <script>
                            // Cập nhật thời gian realtime
                            function updateCurrentTime() {
                                const now = new Date();
                                const timeString = now.toLocaleTimeString('vi-VN');
                                const dateString = now.toLocaleDateString('vi-VN');
                                document.getElementById('current-time').textContent = timeString;

                                // Cập nhật ngày hiện tại
                                const currentDateElement = document.getElementById('current-date');
                                if (currentDateElement) {
                                    currentDateElement.textContent = dateString;
                                }
                            }

                            updateCurrentTime();
                            setInterval(updateCurrentTime, 1000);

                            // Auto refresh mỗi 15 giây để có dữ liệu thời gian thực
                            setInterval(() => {
                                console.log('🔄 Auto refreshing queue data from database...');
                                window.location.reload();
                            }, 15000);

                            // Chức năng gọi điện - Staff gọi cho bệnh nhân qua Twilio
                            function callPatient(patientPhone, patientName) {
                                console.log('🔥 CALL FUNCTION TRIGGERED!');
                                console.log('📞 Input - Phone:', patientPhone, '| Name:', patientName);

                                const staffPhone = '0936929381'; // Số điện thoại staff

                                // Clean và format số điện thoại
                                const cleanPatientPhone = patientPhone.replace(/\s+/g, '').replace(/[^\d+]/g, '');
                                console.log('📞 Original phone:', patientPhone);
                                console.log('📞 Cleaned phone:', cleanPatientPhone);

                                const message = `📞 THÔNG TIN CUỘC GỌI\n\n` +
                                    `👨‍💼 Staff: ${staffPhone}\n` +
                                    `👤 Bệnh nhân: ${patientName}\n` +
                                    `📱 Số BN: ${cleanPatientPhone}\n\n` +
                                    `Chọn cách gọi:\n` +
                                    `• OK: Gọi qua Twilio (chuyên nghiệp)\n` +
                                    `• Cancel: Gọi qua FaceTime`;

                                if (confirm(message)) {
                                    // Phương pháp 1: Gọi qua Twilio API
                                    console.log('📞 Calling via Twilio:', cleanPatientPhone);

                                    // Hiển thị loading
                                    alert('📞 Đang kết nối cuộc gọi qua Twilio...\nVui lòng đợi trong giây lát.');

                                    fetch('twilio-call', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                        },
                                        body: 'phone=' + encodeURIComponent(cleanPatientPhone) + '&patientName=' + encodeURIComponent(patientName)
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                alert('✅ ' + data.message + '\n📞 Cuộc gọi đang được kết nối...\n🔄 Call ID: ' + data.callSid);
                                                console.log('✅ Twilio call successful:', data);
                                            } else {
                                                alert('❌ Twilio Error: ' + data.message + '\n\n🔄 Đang chuyển sang FaceTime...');
                                                // Fallback về FaceTime nếu Twilio fail
                                                window.open('tel:' + cleanPatientPhone, '_self');
                                            }
                                        })
                                        .catch(error => {
                                            console.error('❌ Twilio Error:', error);
                                            alert('❌ Lỗi kết nối Twilio.\n\n🔄 Đang chuyển sang FaceTime...');
                                            // Fallback về FaceTime
                                            window.open('tel:' + cleanPatientPhone, '_self');
                                        });

                                } else {
                                    // Phương pháp 2: Gọi qua FaceTime (macOS)
                                    console.log('📞 Calling via FaceTime:', cleanPatientPhone);

                                    try {
                                        const telUrl = 'tel:' + cleanPatientPhone;
                                        console.log('📞 Opening FaceTime:', telUrl);
                                        window.open(telUrl, '_self');

                                        // Copy backup
                                        if (navigator.clipboard) {
                                            navigator.clipboard.writeText(cleanPatientPhone);
                                        }

                                    } catch (error) {
                                        console.error('❌ FaceTime Error:', error);
                                        alert('❌ Không thể mở FaceTime.\n\n📱 Số điện thoại: ' + cleanPatientPhone);
                                    }
                                }

                                // Log cuộc gọi vào database
                                fetch('StaffHandleQueueServlet', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: 'action=call_patient&staffPhone=' + staffPhone + '&patientPhone=' + cleanPatientPhone + '&patientName=' + encodeURIComponent(patientName)
                                }).catch(err => console.error('❌ Log error:', err));
                            }

                            // Function backup - Copy số điện thoại
                            function copyPhone(patientPhone, patientName) {
                                const cleanPhone = patientPhone.replace(/\s+/g, '').replace(/[^\d+]/g, '');
                                const staffPhone = '0936929381';

                                const message = `📋 COPY SỐ ĐIỆN THOẠI\n\n` +
                                    `👤 Bệnh nhân: ${patientName}\n` +
                                    `📱 Số BN: ${cleanPhone}\n` +
                                    `👨‍💼 Staff: ${staffPhone}\n\n` +
                                    `Số đã được copy vào clipboard!`;

                                // Copy to clipboard
                                if (navigator.clipboard) {
                                    navigator.clipboard.writeText(cleanPhone).then(() => {
                                        alert(message);
                                    }).catch(() => {
                                        prompt('Copy số điện thoại này:', cleanPhone);
                                    });
                                } else {
                                    prompt('Copy số điện thoại này:', cleanPhone);
                                }
                            }

                            function editAppointment(appointmentId) {
                                alert('Chỉnh sửa lịch hẹn ID: ' + appointmentId);
                            }

                            // Function cập nhật trạng thái appointment
                            function updateAppointmentStatus(appointmentId, newStatus) {
                                if (!appointmentId || !newStatus) {
                                    alert('❌ Thiếu thông tin cập nhật trạng thái!');
                                    return;
                                }

                                console.log('🔄 Updating appointment status:', appointmentId, '→', newStatus);

                                // Hiển thị loading
                                const selectElement = document.querySelector(`select[onchange*="${appointmentId}"]`);
                                if (selectElement) {
                                    selectElement.style.opacity = '0.6';
                                    selectElement.disabled = true;
                                }

                                // Gửi request cập nhật trạng thái
                                fetch('StaffHandleQueueServlet', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: 'action=update_status&appointmentId=' + appointmentId + '&newStatus=' + encodeURIComponent(newStatus)
                                })
                                    .then(response => {
                                        if (response.ok) {
                                            console.log('✅ Status updated successfully');
                                            // Reload trang để cập nhật dữ liệu
                                            setTimeout(() => {
                                                window.location.reload();
                                            }, 500);
                                        } else {
                                            throw new Error('HTTP error ' + response.status);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('❌ Error updating status:', error);
                                        alert('❌ Lỗi khi cập nhật trạng thái: ' + error.message);

                                        // Restore select element
                                        if (selectElement) {
                                            selectElement.style.opacity = '1';
                                            selectElement.disabled = false;
                                            selectElement.value = selectElement.options[0].value; // Reset về giá trị ban đầu
                                        }
                                    });
                            }
                        </script>
                    </body>

                    </html>