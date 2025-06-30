<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Không Tìm Thấy Báo Cáo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .no-report-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }
        .no-report-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .no-report-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .btn-outline {
            background-color: transparent;
            border: 2px solid #007bff;
            color: #007bff;
        }
        .btn-outline:hover {
            background-color: #007bff;
            color: white;
        }
        .appointment-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: left;
        }
        .appointment-info h4 {
            margin: 0 0 10px 0;
            color: #495057;
        }
        .appointment-info p {
            margin: 5px 0;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="no-report-container">
        
        <div class="no-report-title">Chưa Có Báo Cáo Y Tế</div>
        
        <div class="no-report-message">
            Cuộc hẹn này chưa có báo cáo y tế được tạo.<br>
            Bạn có thể tạo báo cáo mới hoặc quay lại trang chính để xem các cuộc hẹn khác.
        </div>

        <%
            // Lấy thông tin appointmentId từ parameter nếu có
            String appointmentIdParam = request.getParameter("appointmentId");
            if (appointmentIdParam != null) {
        %>
        <div class="appointment-info">
            <h4>📅 Thông Tin Cuộc Hẹn</h4>
            <p><strong>Mã cuộc hẹn:</strong> <%= appointmentIdParam %></p>
            <p><strong>Trạng thái:</strong> Chưa có báo cáo y tế</p>
        </div>
        <% } %>

        <div class="action-buttons">
            <% if (appointmentIdParam != null) { %>
                <a href="/doctor/jsp/doctor/phieukham.jsp?appointmentId=<%= appointmentIdParam %>" class="btn btn-success">
                    ✍️ Tạo Báo Cáo Mới
                </a>
            <% } %>
            
            <a href="/doctor/DoctorAppointmentsServlet" class="btn btn-primary">
                📋 Xem Cuộc Hẹn Hôm Nay
            </a>
            
            
            
            <a href="javascript:history.back()" class="btn btn-outline">
                ⬅️ Quay Lại
            </a>
        </div>

        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
             
        </div>
    </div>
</body>
</html> 
