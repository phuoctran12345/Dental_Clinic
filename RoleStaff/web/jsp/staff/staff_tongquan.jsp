<%-- Document : staff_homepage Created on : 26 thg 5, 2025, 14:40:44 Author : tranhongphuoc --%>

    <%@page  pageEncoding="UTF-8" %>
        <%@ include file="/jsp/staff/staff_header.jsp" %>
            <%@ include file="/jsp/staff/staff_menu.jsp" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Trang chủ Staff</title>
                    <style>
                        body {
                            margin-left: 0;
                            padding: 0;
                            overflow-x: hidden;
                            overflow-y: hidden;
                        }

                        .dashboard {
                            padding-left: 282px;
                            padding-top: 15px;
                            display: grid;
                            grid-template-columns: 1.1fr 1fr 0.9fr;
                            grid-template-rows: 310px 300px;
                            gap: 10px;
                            padding-right: 10px;
                            padding-bottom: 50px;
                            box-sizing: border-box;
                            min-height: 100vh;
                        }

                        .dashboard>div {
                            border-radius: 12px;
                            padding: 20px;
                            box-shadow: 0 0 10px #ddd;
                            background-color: #fff;
                        }

                        .calendar {
                            grid-column: 1 / 2;
                            grid-row: 1 / 2;
                        }

                        .appointments {
                            grid-column: 2 / 3;
                            grid-row: 1 / 2;
                        }

                        .status {
                            grid-column: 3 / 4;
                            grid-row: 1 / 2;
                        }

                        .staff-info {
                            grid-column: 1 / 2;
                            grid-row: 2 / 3;
                        }

                        .consultations {
                            grid-column: 2 / 4;
                            grid-row: 2 / 3;
                        }

                        .card-header {
                            background: url('header-bg.png') no-repeat center/cover;
                            padding: 16px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .staff-avatar {
                            width: 64px;
                            height: 64px;
                            border-radius: 50%;
                            border: 2px solid #fff;
                            object-fit: cover;
                        }

                        .settings-btn {
                            background-color: #e0f0ff;
                            border: none;
                            border-radius: 8px;
                            padding: 8px 12px;
                            font-size: 14px;
                            cursor: pointer;
                        }

                        .card-body {
                            padding: 16px;
                        }

                        .staff-name {
                            font-size: 20px;
                            font-weight: 600;
                            color: #1e293b;
                            margin-bottom: 8px;
                        }

                        .staff-info p {
                            font-size: 14px;
                            color: #64748b;
                            margin-bottom: 4px;
                        }

                        .appointments h4 {
                            text-align: center;
                            font-size: 18px;
                            color: #0f172a;
                            margin-bottom: 16px;
                        }

                        .appointment-item {
                            display: flex;
                            align-items: center;
                            padding: 12px;
                            border-bottom: 1px solid #e2e8f0;
                        }

                        .appointment-avatar {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            object-fit: cover;
                            margin-right: 12px;
                        }

                        .appointment-info {
                            flex-grow: 1;
                        }

                        .appointment-name {
                            font-weight: 600;
                            color: #1e293b;
                        }

                        .appointment-time {
                            font-size: 14px;
                            color: #64748b;
                        }

                        .appointment-status {
                            padding: 4px 8px;
                            border-radius: 12px;
                            font-size: 12px;
                            font-weight: 500;
                        }

                        .status-pending {
                            background-color: #fef3c7;
                            color: #92400e;
                        }

                        .status-confirmed {
                            background-color: #dcfce7;
                            color: #166534;
                        }

                        .status-cancelled {
                            background-color: #fee2e2;
                            color: #991b1b;
                        }

                        .consultations h4 {
                            text-align: center;
                            font-size: 18px;
                            color: #0f172a;
                            margin-bottom: 16px;
                        }

                        .consultation-item {
                            display: flex;
                            align-items: center;
                            padding: 12px;
                            border-bottom: 1px solid #e2e8f0;
                        }

                        .consultation-avatar {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            object-fit: cover;
                            margin-right: 12px;
                        }

                        .consultation-info {
                            flex-grow: 1;
                        }

                        .consultation-name {
                            font-weight: 600;
                            color: #1e293b;
                        }

                        .consultation-message {
                            font-size: 14px;
                            color: #64748b;
                        }

                        .consultation-time {
                            font-size: 12px;
                            color: #94a3b8;
                        }
                    </style>
                </head>

                <body>
                    <div class="dashboard">
                        <!-- Thông tin nhân viên -->
                        <div class="staff-info">
                            <div class="card-header">
                                <img src="staff.jpg" alt="Staff Avatar" class="staff-avatar">
                                <button class="settings-btn">Cài đặt ⚙️</button>
                            </div>
                            <div class="card-body">
                                <h2 class="staff-name">Nguyễn Văn A</h2>
                                <p><i class="fa-solid fa-venus-mars"></i> Giới tính: Nam</p>
                                <p><i class="fa-solid fa-user-tie"></i> Chức vụ: Nhân viên lễ tân</p>
                                <p><i class="fa-solid fa-phone"></i> Số điện thoại: 0123456789</p>
                            </div>
                        </div>

                        <!-- Lịch hẹn -->
                        <div class="appointments">
                            <h4>Lịch hẹn hôm nay</h4>
                            <div class="appointment-item">
                                <img src="patient1.jpg" alt="Patient" class="appointment-avatar">
                                <div class="appointment-info">
                                    <div class="appointment-name">Trần Thị B</div>
                                    <div class="appointment-time">09:00 - Khám tổng quát</div>
                                </div>
                                <span class="appointment-status status-confirmed">Đã xác nhận</span>
                            </div>
                            <div class="appointment-item">
                                <img src="patient2.jpg" alt="Patient" class="appointment-avatar">
                                <div class="appointment-info">
                                    <div class="appointment-name">Lê Văn C</div>
                                    <div class="appointment-time">10:30 - Tư vấn răng</div>
                                </div>
                                <span class="appointment-status status-pending">Chờ xác nhận</span>
                            </div>
                        </div>

                        <!-- Trạng thái -->
                        <div class="status">
                            <h4>Cập nhật trạng thái</h4>
                            <p>Cho người khác biết là bạn hiện đang có mặt tại phòng khám.</p>
                            <div class="toggle-container">
                                <label class="toggle-switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                                <span class="status-label">Hiện đang trực</span>
                            </div>
                        </div>

                        <!-- Yêu cầu tư vấn -->
                        <div class="consultations">
                            <h4>Yêu cầu tư vấn</h4>
                            <div class="consultation-item">
                                <img src="patient3.jpg" alt="Patient" class="consultation-avatar">
                                <div class="consultation-info">
                                    <div class="consultation-name">Phạm Thị D</div>
                                    <div class="consultation-message">Tôi muốn tư vấn về dịch vụ niềng răng...</div>
                                    <div class="consultation-time">10 phút trước</div>
                                </div>
                            </div>
                            <div class="consultation-item">
                                <img src="patient4.jpg" alt="Patient" class="consultation-avatar">
                                <div class="consultation-info">
                                    <div class="consultation-name">Hoàng Văn E</div>
                                    <div class="consultation-message">Tôi cần tư vấn về giá dịch vụ...</div>
                                    <div class="consultation-time">30 phút trước</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </body>

                </html>