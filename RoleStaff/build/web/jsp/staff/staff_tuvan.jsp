<%-- Document : staff_tuvan Created on : 26 thg 5, 2025, 14:41:36 Author : tranhongphuoc --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/jsp/staff/staff_header.jsp" %>
<%@ include file="/jsp/staff/staff_menu.jsp" %>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tư vấn</title>
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

            .consultation-container {
                display: grid;
                grid-template-columns: 300px 1fr;
                gap: 20px;
                height: calc(100vh - 30px);
            }

            .patient-list {
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 0 10px #ddd;
                overflow-y: auto;
            }

            .patient-item {
                padding: 15px;
                border-bottom: 1px solid #e2e8f0;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .patient-item:hover {
                background-color: #f8f9fb;
            }

            .patient-item.active {
                background-color: #e0f0ff;
            }

            .patient-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 10px;
            }

            .patient-info {
                display: flex;
                align-items: center;
            }

            .patient-name {
                font-weight: 600;
                color: #1e293b;
            }

            .patient-time {
                font-size: 12px;
                color: #94a3b8;
                margin-top: 4px;
            }

            .chat-container {
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 0 10px #ddd;
                display: flex;
                flex-direction: column;
            }

            .chat-header {
                padding: 15px;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                align-items: center;
            }

            .chat-messages {
                flex-grow: 1;
                padding: 15px;
                overflow-y: auto;
            }

            .message {
                margin-bottom: 15px;
                display: flex;
                flex-direction: column;
            }

            .message-content {
                max-width: 70%;
                padding: 10px 15px;
                border-radius: 12px;
                font-size: 14px;
            }

            .message.received {
                align-items: flex-start;
            }

            .message.sent {
                align-items: flex-end;
            }

            .message.received .message-content {
                background-color: #f1f5f9;
                color: #1e293b;
            }

            .message.sent .message-content {
                background-color: #00BFFF;
                color: white;
            }

            .message-time {
                font-size: 12px;
                color: #94a3b8;
                margin-top: 4px;
            }

            .chat-input {
                padding: 15px;
                border-top: 1px solid #e2e8f0;
                display: flex;
                gap: 10px;
            }

            .chat-input input {
                flex-grow: 1;
                padding: 10px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
            }

            .chat-input input:focus {
                outline: none;
                border-color: #00BFFF;
            }

            .chat-input button {
                background-color: #00BFFF;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 10px 20px;
                font-size: 14px;
                cursor: pointer;
            }

            .chat-input button:hover {
                background-color: #0095cc;
            }

            .no-chat-selected {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100%;
                color: #94a3b8;
                font-size: 16px;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="consultation-container">
                <!-- Danh sách bệnh nhân -->
                <div class="patient-list">
                    <div class="patient-item active">
                        <div class="patient-info">
                            <img src="patient1.jpg" alt="Patient" class="patient-avatar">
                            <div>
                                <div class="patient-name">Trần Thị B</div>
                                <div class="patient-time">10 phút trước</div>
                            </div>
                        </div>
                    </div>
                    <div class="patient-item">
                        <div class="patient-info">
                            <img src="patient2.jpg" alt="Patient" class="patient-avatar">
                            <div>
                                <div class="patient-name">Lê Văn C</div>
                                <div class="patient-time">30 phút trước</div>
                            </div>
                        </div>
                    </div>
                    <div class="patient-item">
                        <div class="patient-info">
                            <img src="patient3.jpg" alt="Patient" class="patient-avatar">
                            <div>
                                <div class="patient-name">Phạm Thị D</div>
                                <div class="patient-time">1 giờ trước</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Khu vực chat -->
                <div class="chat-container">
                    <div class="chat-header">
                        <img src="patient1.jpg" alt="Patient" class="patient-avatar">
                        <div>
                            <div class="patient-name">Trần Thị B</div>
                            <div class="patient-time">Đang online</div>
                        </div>
                    </div>

                    <div class="chat-messages">
                        <div class="message received">
                            <div class="message-content">
                                Xin chào, tôi muốn tư vấn về dịch vụ niềng răng
                            </div>
                            <div class="message-time">10:00</div>
                        </div>

                        <div class="message sent">
                            <div class="message-content">
                                Xin chào, tôi có thể giúp gì cho bạn?
                            </div>
                            <div class="message-time">10:01</div>
                        </div>

                        <div class="message received">
                            <div class="message-content">
                                Tôi muốn biết thông tin về quy trình niềng răng và chi phí
                            </div>
                            <div class="message-time">10:02</div>
                        </div>
                    </div>

                    <div class="chat-input">
                        <input type="text" placeholder="Nhập tin nhắn...">
                        <button>Gửi</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Xử lý chọn bệnh nhân
            const patientItems = document.querySelectorAll('.patient-item');
            patientItems.forEach(item => {
                item.addEventListener('click', () => {
                    patientItems.forEach(i => i.classList.remove('active'));
                    item.classList.add('active');
                });
            });
        </script>
    </body>

</html>