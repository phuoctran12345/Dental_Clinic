<%-- Document : staff_datlich Created on : 26 thg 5, 2025, 14:40:58 Author : tranhongphuoc --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/jsp/staff/staff_header.jsp" %>
<%@ include file="/jsp/staff/staff_menu.jsp" %>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt lịch</title>
        <style>
            body {
                margin-left: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;
            }

            .container {
                padding-left: 282px;
                padding-top: 15px;
                padding-right: 15px;
                padding-bottom: 15px;
            }

            .booking-form {
                background-color: #fff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 0 10px #ddd;
                max-width: 800px;
                margin: 0 auto;
            }

            .form-title {
                text-align: center;
                color: #1e293b;
                margin-bottom: 24px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #1e293b;
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 16px;
            }

            .form-control:focus {
                outline: none;
                border-color: #00BFFF;
                box-shadow: 0 0 0 2px rgba(0, 191, 255, 0.2);
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .btn-submit {
                background-color: #00BFFF;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 24px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                width: 100%;
                margin-top: 20px;
            }

            .btn-submit:hover {
                background-color: #0095cc;
            }

            .time-slots {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 10px;
                margin-top: 10px;
            }

            .time-slot {
                padding: 8px;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s;
            }

            .time-slot:hover {
                background-color: #f8f9fb;
            }

            .time-slot.selected {
                background-color: #00BFFF;
                color: white;
                border-color: #00BFFF;
            }

            .time-slot.unavailable {
                background-color: #f1f5f9;
                color: #94a3b8;
                cursor: not-allowed;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="booking-form">
                <h2 class="form-title">Đặt lịch khám</h2>
                <form action="BookingServlet" method="POST">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="patient-name">Họ và tên bệnh nhân</label>
                            <input type="text" id="patient-name" name="patient-name" class="form-control"
                                   required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" class="form-control" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="date">Ngày khám</label>
                            <input type="date" id="date" name="date" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Giờ khám</label>
                            <div class="time-slots">
                                <div class="time-slot">08:00</div>
                                <div class="time-slot">09:00</div>
                                <div class="time-slot unavailable">10:00</div>
                                <div class="time-slot">11:00</div>
                                <div class="time-slot">13:00</div>
                                <div class="time-slot">14:00</div>
                                <div class="time-slot">15:00</div>
                                <div class="time-slot">16:00</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="service">Dịch vụ khám</label>
                        <select id="service" name="service" class="form-control" required>
                            <option value="">Chọn dịch vụ</option>
                            <option value="general">Khám tổng quát</option>
                            <option value="dental">Khám răng</option>
                            <option value="consultation">Tư vấn</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="doctor">Bác sĩ</label>
                        <select id="doctor" name="doctor" class="form-control" required>
                            <option value="">Chọn bác sĩ</option>
                            <option value="1">Bác sĩ Nguyễn Văn A</option>
                            <option value="2">Bác sĩ Trần Thị B</option>
                            <option value="3">Bác sĩ Lê Văn C</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="note">Ghi chú</label>
                        <textarea id="note" name="note" class="form-control" rows="3"></textarea>
                    </div>

                    <button type="submit" class="btn-submit">Đặt lịch</button>
                </form>
            </div>
        </div>

        <script>
            // Xử lý chọn giờ khám
            const timeSlots = document.querySelectorAll('.time-slot:not(.unavailable)');
            timeSlots.forEach(slot => {
                slot.addEventListener('click', () => {
                    timeSlots.forEach(s => s.classList.remove('selected'));
                    slot.classList.add('selected');
                });
            });
        </script>
    </body>

</html>