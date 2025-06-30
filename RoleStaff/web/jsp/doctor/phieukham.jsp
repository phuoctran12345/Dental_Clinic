<%-- Document : phieukham Created on : May 24, 2025, 2:59:29 PM Author : ASUS --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo phiếu khám</title>
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

        /* Outer frame for all content */
        .outer-frame {
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12); /* Stronger shadow for prominence */
            border: 1px solid #e2e8f0;
            padding: 32px;
            margin-bottom: 32px;
        }

        /* Header section */
        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .form-header h2 {
            color: #3b82f6; /* Vibrant blue */
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Back button styling */
        .back-btn {
            padding: 10px 20px;
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            background: #ffffff;
            color: #1f2937;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            background: #f3f4f6;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .back-btn a {
            color: #1f2937;
            text-decoration: none;
        }

        /* Profile section */
        .profile {
            background: #f9fafb; /* Subtle background to differentiate within frame */
            border-radius: 5px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            display: flex;
            gap: 24px;
            margin-bottom: 32px;
        }

        .profile img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            background: #e2e8f0; /* Placeholder for missing images */
            border: 2px solid #e2e8f0;
        }

        .profile .middle, .profile .right {
            flex: 1;
        }

        .profile p {
            margin: 8px 0;
            font-size: 14px;
            color: #1f2937;
        }

        .profile p strong {
            font-weight: 600;
            color: #1f2937;
        }

        .profile .edit-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            background: #3b82f6;
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease;
        }

        .profile .edit-btn:hover {
            background: #2563eb;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        /* Form section */
        .form-section {
            background: #f9fafb; /* Subtle background to differentiate within frame */
            border-radius: 5px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            margin-bottom: 32px;
        }

        .form-section p {
            margin: 8px 0;
            font-size: 14px;
            color: #1f2937;
        }

        .form-section p strong {
            font-weight: 600;
        }

        .form-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }

        .form-group input, .form-group textarea {
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            font-size: 14px;
            color: #1f2937;
            width: 100%;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-group input:focus, .form-group textarea:focus {
            border-color: #3b82f6;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.2);
            outline: none;
        }

        .form-group textarea {
            height: 100px;
            resize: vertical;
        }

        /* Buttons section */
        .buttons {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 32px;
        }

        .buttons button {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease, transform 0.1s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .buttons button:hover {
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

        /* Summary section */
        .summary {
            background: #f9fafb; /* Subtle background to differentiate within frame */
            border-radius: 5px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
        }

        .summary p {
            margin: 8px 0;
            font-size: 14px;
            color: #1f2937;
        }

        .summary p strong {
            font-weight: 600;
            color: #1f2937;
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
            .profile {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .outer-frame, .form-section, .profile, .summary {
                padding: 16px;
            }
            .form-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .form-group {
                grid-template-columns: 1fr;
            }
            .buttons {
                flex-direction: column;
                gap: 12px;
            }
            .form-header h2 {
                font-size: 20px;
            }
        }

        @media (max-width: 576px) {
            .outer-frame, .form-section, .profile, .summary {
                padding: 12px;
            }
            .buttons button {
                padding: 10px 16px;
                font-size: 12px;
            }
            .form-group input, .form-group textarea {
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="container">
            <!-- Outer frame wrapping all content -->
            <div class="outer-frame">
                <!-- Header Section -->
                <div class="form-header">
                    <h2><i class="fas fa-file-medical"></i> Tạo phiếu khám</h2>
                    <button class="back-btn">
                        <a href="doctor_trongngay.jsp"><i class="fas fa-arrow-left"></i> Quay lại</a>
                    </button>
                </div>

                <!-- Profile Section -->
                <div class="profile">
                    <div class="left">
                        <img src="img/benhnhan.jpg" alt="Avatar">
                    </div>
                    <div class="middle">
                        <p><strong>Họ và tên:</strong> Nguyễn Văn Quốc Đạt</p>
                        <p><strong>Ngày sinh:</strong> 01/02/2004 - 20 tuổi</p>
                    </div>
                    <div class="right">
                        <p><strong>Địa chỉ:</strong> Nam Kỳ Khởi Nghĩa</p>
                        <p><strong>Giới tính:</strong> Nam</p>
                        <p><strong>Số điện thoại:</strong> 0356611341</p>
                        <button class="edit-btn"><i class="fas fa-edit"></i> Update</button>
                    </div>
                </div>

                <!-- Form Section -->
                <div class="form-section">
                    <p><strong>Mã bác sĩ:</strong> 123</p>
                    <p><strong>Thời gian khám:</strong> 10:50 23/09</p>
                    <div class="form-group">
                        <input type="text" placeholder="* Tiền sử bệnh nghiệm" required>
                        <input type="text" placeholder="* Tổng trạng thái chung" required>
                        <input type="text" placeholder="* Chiều cao" required>
                        <input type="text" placeholder="* Cân nặng" required>
                        <input type="text" placeholder="Mạch">
                        <input type="text" placeholder="Nhiệt độ">
                        <input type="text" placeholder="Huyết áp">
                    </div>
                    <div class="form-group">
                        <textarea placeholder="Chuẩn đoán"></textarea>
                    </div>
                </div>

                <!-- Buttons Section -->
                <div class="buttons">
                    <button class="btn-blue"><i class="fas fa-plus"></i> Thêm dịch vụ khám</button>
                    <button class="btn-green"><i class="fas fa-save"></i> Cập nhật kết quả</button>
                    <button class="btn-blue"><i class="fas fa-prescription-bottle"></i> Tạo lịch làm việc</button>
                </div>

                <!-- Summary Section -->
                <div class="summary">
                    <p>Tổng số xét nghiệm: 6</p>
                    <p>Tổng phí xét nghiệm: 840.000 đ</p>
                    <p>Đã giảm chi phí khám: 200.000 đ</p>
                    <p><strong>Tổng cộng: 640.000 đ</strong></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>