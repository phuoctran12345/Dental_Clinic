<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        color: #333;
                    }

                    .container {
                        max-width: 600px;
                        margin: 0 auto;
                        padding: 20px;
                        border: 1px solid #ddd;
                        border-radius: 10px;
                    }

                    .header {
                        background-color: #28a745;
                        color: white;
                        padding: 20px;
                        text-align: center;
                        border-radius: 10px 10px 0 0;
                    }

                    .content {
                        padding: 20px;
                    }

                    .info-box {
                        background: #f8f9fa;
                        border-left: 4px solid #007bff;
                        padding: 15px;
                        margin: 15px 0;
                    }

                    .footer {
                        text-align: center;
                        font-size: 0.9em;
                        color: #777;
                        margin-top: 20px;
                    }

                    strong {
                        color: #0056b3;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <div class="header">
                        <h2>Xác nhận thanh toán & Lịch hẹn thành công!</h2>
                    </div>
                    <div class="content">
                        <p>Xin chào <strong>${userName}</strong>,</p>
                        <p>Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ tại phòng khám của chúng tôi. Lịch hẹn của bạn đã
                            được xác nhận thành công.</p>

                        <div class="info-box">
                            <h4>Thông tin thanh toán</h4>
                            <p><strong>Mã hóa đơn:</strong> ${billId}</p>
                            <p><strong>Dịch vụ:</strong> ${serviceName}</p>
                            <p><strong>Số tiền:</strong>
                                <fmt:formatNumber value="${billAmount}" pattern="#,##0" /> VNĐ
                            </p>
                        </div>

                        <div class="info-box">
                            <h4>Thông tin lịch hẹn</h4>
                            <p><strong>Bác sĩ:</strong> ${doctorName}</p>
                            <p><strong>Ngày khám:</strong> ${appointmentDate}</p>
                            <p><strong>Giờ khám:</strong> ${appointmentTime}</p>
                        </div>

                        <p>Vui lòng có mặt trước giờ hẹn 15 phút để làm thủ tục. Cảm ơn bạn!</p>
                    </div>
                    <div class="footer">
                        <p>&copy; 2024 Phòng khám Nha Khoa. All rights reserved.</p>
                        <p>${clinicName} | ${clinicAddress} | ${clinicPhone}</p>
                    </div>
                </div>
            </body>

            </html>