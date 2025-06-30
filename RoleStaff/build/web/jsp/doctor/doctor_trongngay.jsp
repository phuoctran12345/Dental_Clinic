<%-- Document : doctor_trongngay Created on : [Insert Date], Author : [Your Name] --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lượt khám hôm nay</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        /* General body styling */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7fc;
            overflow-x: hidden;
        }

        /* Content wrapper to handle menu toggle */
        .content-wrapper {
            width: 100%;
        }

        /* Main container with padding to avoid menu overlap */
        .container {
            padding: 80px 20px 20px 280px; /* Space for fixed menu */
            min-height: 100vh;
            max-width: 1400px; /* Consistent with other pages */
            margin: 0 auto;
            transition: padding 0.3s ease;
        }

        /* Header section */
        .content-header {
            margin-bottom: 32px;
        }

        .content-header h2 {
            color: #3b82f6; /* Vibrant blue */
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .content-header p {
            color: #6b7280;
            font-size: 16px;
            font-weight: 500;
            margin: 0;
        }

        /* Section container for Waiting and Done */
        .section {
            margin-bottom: 48px; /* Increased spacing between sections */
        }

        /* Section header styling */
        .section-header {
            background: #ffffff;
            border-radius: 5px;
            padding: 16px 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 6px solid; /* Thicker border for emphasis */
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
        }

        .section-header.waiting {
            border-left-color: #3b82f6; /* Blue for waiting */
        }

        .section-header.done {
            border-left-color: #10b981; /* Green for done */
        }

        .section-header h3 {
            color: #1f2937;
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }

        .section-header i {
            font-size: 18px;
            color: #1f2937;
        }

        /* Cards grid for appointments */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); /* Slightly wider cards */
            gap: 24px;
        }

        /* Individual card styling */
        .card {
            background: #ffffff;
            border-radius: 5px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            position: relative;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        /* Card header styling */
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid #e2e8f0; /* Subtle divider */
        }

        .card-header p {
            font-size: 16px;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        /* Badge styling for status */
        .badge {
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            text-transform: uppercase; /* For emphasis */
        }

        .badge.waiting {
            background: #bfdbfe;
            color: #1e40af;
        }

        .badge.done {
            background: #d1fae5;
            color: #047857;
        }

        /* Patient info section */
        .info {
            display: flex;
            gap: 16px;
            margin-bottom: 20px;
        }

        .info img {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            object-fit: cover;
            background: #e2e8f0; /* Placeholder for missing images */
            border: 2px solid #e2e8f0;
        }

        .info-details p {
            margin: 6px 0;
            font-size: 14px;
            color: #1f2937;
            line-height: 1.5;
        }

        .info-details p strong {
            color: #1f2937;
            font-weight: 600;
        }

        /* Action buttons */
        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap; /* Prevent overflow on small screens */
        }

        .actions button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease, transform 0.1s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .actions button:hover {
            transform: translateY(-2px);
        }

        .btn-blue {
            background: #3b82f6;
            color: #ffffff;
        }

        .btn-blue:hover {
            background: #2563eb;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-green {
            background: #10b981;
            color: #ffffff;
        }

        .btn-green:hover {
            background: #059669;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-gray {
            background: #e5e7eb;
            color: #1f2937;
        }

        .btn-gray:hover {
            background: #d1d5db;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        /* Empty state styling */
        .empty-state {
            text-align: center;
            padding: 32px;
            color: #6b7280;
            font-size: 16px;
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
        }

        .empty-state i {
            font-size: 32px;
            margin-bottom: 16px;
            color: #9ca3af;
        }

        /* Responsive adjustments */
        @media (max-width: 1200px) {
            .container {
                padding-left: 250px;
            }
        }

        @media (max-width: 992px) {
            .container {
                padding-left: 20px;
                padding-right: 20px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .cards {
                grid-template-columns: 1fr;
            }
            .card {
                padding: 16px;
            }
            .content-header h2 {
                font-size: 20px;
            }
            .section-header h3 {
                font-size: 18px;
            }
            .info img {
                width: 48px;
                height: 48px;
            }
            .actions button {
                padding: 8px 16px;
                font-size: 12px;
            }
        }

        @media (max-width: 576px) {
            .card {
                padding: 12px;
            }
            .info-details p {
                font-size: 12px;
            }
            .card-header p {
                font-size: 14px;
            }
            .badge {
                font-size: 10px;
                padding: 4px 8px;
            }
            .section-header {
                padding: 12px 16px;
            }
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="container">
            <!-- Header Section -->
            <div class="content-header">
                <h2><i class="fas fa-stethoscope"></i> Lượt khám hôm nay</h2>
                <p>Ngày 22/09/2024</p>
            </div>

            <!-- Waiting Section -->
            <div class="section">
                <div class="section-header waiting">
                    <i class="fas fa-hourglass-half"></i>
                    <h3>Đang chờ khám</h3>
                </div>
                <div class="cards">
                    <div class="card">
                        <div class="card-header">
                            <p>09:30 - 10:30</p>
                            <span class="badge waiting"><i class="fas fa-hourglass-half"></i> Đang chờ</span>
                        </div>
                        <div class="info">
                            <img src="" alt="avatar">
                            <div class="info-details">
                                <p><strong>Nguyễn Văn A</strong></p>
                                <p>Số điện thoại: 0785771092</p>
                                <p>Giới tính: Nam | Tuổi: 29</p>
                                <p>Mô tả: Bệnh nhân đăng ký khám tổng quát nhằm kiểm tra toàn diện về sức khỏe...</p>
                            </div>
                        </div>
                        <div class="actions">
                            <button class="btn-blue" onclick="window.location.href='phieukham.jsp'">
                                <i class="fas fa-file-medical"></i> Tạo phiếu khám
                            </button>
                            <button class="btn-gray"><i class="fas fa-cog"></i> Cài đặt</button>
                        </div>
                    </div>
                    <!-- Placeholder for empty state -->
                    <!-- <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <p>Chưa có lượt khám đang chờ</p>
                    </div> -->
                </div>
            </div>

            <!-- Done Section -->
            <div class="section">
                <div class="section-header done">
                    <i class="fas fa-check-circle"></i>
                    <h3>Đã khám xong</h3>
                </div>
                <div class="cards">
                    <div class="card">
                        <div class="card-header">
                            <p>09:30 - 10:30</p>
                            <span class="badge done"><i class="fas fa-check"></i> Khám xong</span>
                        </div>
                        <div class="info">
                            <img src="" alt="avatar">
                            <div class="info-details">
                                <p><strong>Nguyễn Văn A</strong></p>
                                <p>Số điện thoại: 0785771092</p>
                                <p>Giới tính: Nam | Tuổi: 29</p>
                                <p>Mô tả: Bệnh nhân đăng ký khám tổng quát nhằm kiểm tra toàn diện về sức khỏe...</p>
                            </div>
                        </div>
                        <div class="actions">
                            <button class="btn-gray"><i class="fas fa-eye"></i> Xem phiếu khám</button>
                            <button class="btn-green"><i class="fas fa-check"></i> Khám xong</button>
                        </div>
                    </div>
                    <!-- Placeholder for empty state -->
                    <!-- <div class="empty-state">
                        <i class="fas fa-calendar-check"></i>
                        <p>Chưa có lượt khám đã hoàn thành</p>
                    </div> -->
                </div>
            </div>
        </div>
    </div>
</body>
</html>