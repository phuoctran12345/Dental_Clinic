<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- HÃY ĐẢM BẢO FILE NÀY ĐƯỢC LƯU VỚI ENCODING UTF-8 TRONG IDE --%>
<%@page import="model.Appointment" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="model.Doctors" %>
<%@page import="model.Patients" %>

<%@ include file="/jsp/patient/user_header.jsp" %>
<%@ include file="/jsp/patient/user_menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard P-Clinic</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <style>
            :root {
                --primary: #4F46E5;
                --primary-light: #6366F1;
                --secondary: #10B981;
                --danger: #EF4444;
                --warning: #F59E0B;
                --gray-100: #F3F4F6;
                --gray-200: #E5E7EB;
                --gray-500: #6B7280;
                --gray-700: #374151;
                --white: #FFFFFF;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: #F9FAFB;
                margin: 0;
                padding: 0;
                color: var(--gray-700);
            }

            .dashboard-container {
                padding: 24px 24px 24px 280px;
                max-width: 1900px;
                margin: 0 auto;
            }

            .dashboard-header {
                margin-bottom: 24px;
            }

            .dashboard-header h1 {
                font-size: 28px;
                font-weight: 700;
                color: var(--gray-700);
                margin: 0;
            }

            .dashboard-header p {
                color: var(--gray-500);
                margin: 8px 0 0;
            }

            .dashboard-grid {
                display: grid;
                grid-template-columns: repeat(12, 1fr);
                gap: 24px;
            }

            .card {
                background: var(--white);
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                border: 1px solid var(--gray-200);
                padding: 20px;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
                padding-bottom: 12px;
                border-bottom: 1px solid var(--gray-200);
            }

            .card-title {
                font-size: 18px;
                font-weight: 600;
                margin: 0;
                color: var(--gray-700);
            }

            .card-icon {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--white);
            }

            /* Calendar Card */
            .calendar-card {
                grid-column: span 4;
                background: #4E80EE ;
                color: var(--white);
            }

            .calendar-card .card-header {
                border-bottom-color: rgba(255,255,255,0.2);
            }

            .calendar-card .card-title {
                color: var(--white);
            }

            .calendar-date {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .calendar-time {
                font-size: 16px;
                opacity: 0.9;
            }

            /* Visit Count Card */
            .visit-card {
                grid-column: span 2;
            }

            .visit-card .card-icon {
                background: var(--secondary);
            }

            .visit-count {
                font-size: 32px;
                font-weight: 700;
                text-align: center;
                margin: 16px 0;
                color: var(--gray-700);
            }

            .visit-label {
                text-align: center;
                color: var(--gray-500);
                font-size: 14px;
            }

            /* Doctor Card */
            .doctor-card {
                grid-column: span 6;
            }

            .doctor-card .card-icon {
                background: var(--warning);
            }

            .doctor-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }

            .doctor-info p {
                margin: 8px 0;
                font-size: 14px;
            }

            .doctor-info span {
                font-weight: 500;
                color: var(--gray-700);
            }

            .status-active {
                color: var(--secondary);
                font-weight: 500;
            }

            /* User Info Card */
            .user-card {
                grid-column: span 4;
            }

            .user-card .card-icon {
                background: var(--primary);
            }

            .user-info p {
                margin: 12px 0;
                font-size: 14px;
            }

            .user-info span {
                font-weight: 500;
            }

            /* Recent Visits Card */
            .visits-card {
                grid-column: span 8;
            }

            .visits-card .card-icon {
                background: var(--danger);
            }

            .visit-item {
                padding: 12px 0;
                border-bottom: 1px solid var(--gray-200);
                display: flex;
                justify-content: space-between;
            }

            .visit-item:last-child {
                border-bottom: none;
            }

            .visit-date {
                color: var(--gray-500);
                font-size: 13px;
            }

            /* Consultations Card */
            .consult-card {
                grid-column: span 12;
            }

            .consult-card .card-icon {
                background: var(--primary-light);
            }

            .consult-content {
                padding: 16px;
                background: var(--gray-100);
                border-radius: 6px;
                font-size: 14px;
            }

            /* Responsive */
            @media (max-width: 1200px) {
                .dashboard-container {
                    padding-left: 24px;
                }

                .calendar-card {
                    grid-column: span 6;
                }

                .visit-card {
                    grid-column: span 3;
                }

                .doctor-card {
                    grid-column: span 6;
                }

                .user-card {
                    grid-column: span 6;
                }
            }

            @media (max-width: 768px) {
                .dashboard-grid {
                    grid-template-columns: 1fr;
                }

                .calendar-card,
                .visit-card,
                .doctor-card,
                .user-card,
                .visits-card,
                .consult-card {
                    grid-column: span 1;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-container">
            <div class="dashboard-header">
                <h1>Xin chào, Mai Ngân</h1>
                <p>Thông tin tổng quan về tình trạng khám chữa bệnh của bạn</p>
            </div>

            <div class="dashboard-grid">
                <!-- Calendar Card -->
                <div class="card calendar-card">
                    <div class="card-header">
                        <h3 class="card-title">Lịch khám sắp tới</h3>
                        <div class="card-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                    </div>
                    <div class="calendar-date">28 Tháng 2 2024</div>
                    <div class="calendar-time">07:30 AM</div>
                </div>

                <!-- Visit Count Card -->
                <div class="card visit-card">
                    <div class="card-header">
                        <h3 class="card-title">Số lần khám</h3>
                        <div class="card-icon">
                            <i class="fas fa-heartbeat"></i>
                        </div>
                    </div>
                    <div class="visit-count">02</div>
                    <div class="visit-label">tại P-Clinic</div>
                </div>

                <!-- Doctor Card -->
                <div class="card doctor-card">
                    <div class="card-header">
                        <h3 class="card-title">Bác sĩ đang trực</h3>
                        <div class="card-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                    </div>
                    <div class="doctor-info">
                        <div>
                            <p>Bác sĩ: <span>Châu Lê</span></p>
                            <p>Chuyên môn: <span>Răng sâu</span></p>
                        </div>
                        <div>
                            <p>Số điện thoại: <span>00624746072</span></p>
                            <p>Giá khám: <span>168.000đ</span></p>
                            <p>Trạng thái: <span class="status-active">Đang trực</span></p>
                        </div>
                    </div>
                </div>

                <!-- User Info Card -->
                <div class="card user-card">
                    <div class="card-header">
                        <h3 class="card-title">Thông tin cá nhân</h3>
                        <div class="card-icon">
                            <i class="fas fa-user"></i>
                        </div>
                    </div>
                    <div class="user-info">

                        <%    Patients patient = (Patients) session.getAttribute("patient");
                            if (patient != null) {
                        %>
                        <p><strong>Họ tên:</strong> <%= patient.getFullName()%></p>
                        <p><strong>Điện thoại:</strong> <%= patient.getPhone()%></p>
                        <%
                            Date dob = patient.getDateOfBirth(); // có thể là java.sql.Date
                            String formattedDob = "--";
                            if (dob != null) {
                                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                                formattedDob = sdf.format(dob);
                            }
                        %>
                        <p><strong>Ngày sinh:</strong> <%= formattedDob%></p>
                        <p><strong>Giới tính:</strong> <%= patient.getGender()%></p>
                        <%
                        } else {
                        %>
                        <p>Không tìm thấy hồ sơ bệnh nhân.</p>
                        <%
                            }
                        %>
                    </div>
                </div>

                <!-- Recent Visits Card -->
                <div class="card visits-card">
                    <div class="card-header">
                        <h3 class="card-title">Đã khám gần đây</h3>
                        <div class="card-icon">
                            <i class="fas fa-history"></i>
                        </div>
                    </div>
                    <div class="visit-item">
                        <span>Khám răng sâu</span>
                        <span class="visit-date">17/09/2024</span>
                    </div>
                    <div class="visit-item">
                        <span>Khám nội tổng quát</span>
                        <span class="visit-date">12/07/2023</span>
                    </div>
                </div>

                <!-- Consultations Card -->
                <div class="card consult-card">
                    <div class="card-header">
                        <h3 class="card-title">Đang chờ tư vấn</h3>
                        <div class="card-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                    </div>
                    <div class="consult-content">
                        Thông tin tư vấn sẽ được hiển thị tại đây khi có yêu cầu.
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>