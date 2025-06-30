<%@ include file="/jsp/patient/user_header.jsp" %>
<%@ include file="/jsp/patient/user_menu.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tin nhắn chờ</title>
        <style>
            :root {
                --primary-color: #4E80EE;
                --primary-hover: #3A6BD6;
                --success-color: #2ECC71;
                --success-hover: #27AE60;
                --warning-color: #F39C12;
                --warning-hover: #E67E22;
                --text-color: #2C3E50;
                --text-light: #7F8C8D;
                --light-gray: #F5F7FA;
                --border-color: #E0E5EC;
                --card-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            }

            body {
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
                background-color: #F9FAFB;
                color: var(--text-color);
            }

            .main-container {
                display: flex;
                min-height: 100vh;
            }

            .content-wrapper {
                flex: 1;
                padding: 20px;
                margin-left: 250px;
            }

            .message-page {
                background-color: white;
                border-radius: 8px; /* Giảm độ bo tròn */
                box-shadow: var(--card-shadow);
                border: 1px solid var(--border-color);
                padding: 20px;
                width: 97%; /* Rộng hơn */
                max-width: 2000px; /* Tăng chiều ngang tối đa */
                margin: 0 auto;
                min-height: auto; /* Bỏ chiều cao cố định */
            }

            /* Header Section */
            .header {
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid var(--border-color);
            }

            .header h2 {
                margin: 0;
                font-size: 1.8rem;
                font-weight: 600;
                color: var(--text-color);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* Status Card */
            .status-card {
                padding: 15px;
                background: #FFF9E6;
                border-radius: 6px; /* Giảm độ bo tròn */
                font-size: 1rem;
                display: flex;
                align-items: center;
                gap: 10px;
                border-left: 4px solid var(--warning-color);
                margin-bottom: 20px;
            }

            .status-card i {
                font-size: 1.3rem;
                color: var(--warning-color);
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
            }

            .action-buttons button {
                padding: 10px 20px;
                font-size: 1rem;
                font-weight: 500;
                border: none;
                border-radius: 6px; /* Giảm độ bo tròn */
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
            }

            .btn-primary:hover {
                background-color: var(--primary-hover);
            }

            .btn-secondary {
                background-color: white;
                color: var(--primary-color);
                border: 1px solid var(--primary-color);
            }

            .btn-secondary:hover {
                background-color: #f0f7ff;
            }

            /* Message Container */
            .message-container {
                display: flex;
                flex-direction: column;
                background-color: white;
                border-radius: 6px; /* Giảm độ bo tròn */
                border: 1px solid var(--border-color);
                height: 500px; /* Giảm chiều cao */
            }

            .message-header {
                padding: 15px;
                border-bottom: 1px solid var(--border-color);
            }

            .message-subject {
                width: 100%;
                font-size: 1rem;
                border: none;
                outline: none;
                background: transparent;
                padding: 8px;
            }

            .message-body {
                flex: 1;
                padding: 15px;
                position: relative;
            }

            .message-content {
                width: 100%;
                height: 100%;
                font-size: 1rem;
                line-height: 1.5;
                border: none;
                outline: none;
                resize: none;
                font-family: inherit;
                padding: 8px;
            }

            .message-footer {
                padding: 15px;
                border-top: 1px solid var(--border-color);
                display: flex;
                justify-content: flex-end;
                background-color: #f9f9f9;
                border-radius: 0 0 6px 6px; /* Giảm độ bo tròn */
            }

            .btn-send {
                padding: 8px 20px;
                font-size: 1rem;
                font-weight: 500;
                background-color: var(--success-color);
                color: white;
                border: none;
                border-radius: 6px; /* Giảm độ bo tròn */
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-send:hover {
                background-color: var(--success-hover);
            }

            /* Footer */
            .footer {
                margin-top: 20px;
                text-align: center;
                color: var(--text-light);
                font-size: 0.8rem;
            }

            /* Responsive Design */
            @media (max-width: 1200px) {
                .content-wrapper {
                    margin-left: 250px;
                    padding: 15px;
                }
            }

            @media (max-width: 992px) {
                .content-wrapper {
                    margin-left: 0;
                    padding: 10px;
                }

                .message-page {
                    padding: 15px;
                    width: 98%;
                }
            }

            @media (max-width: 768px) {
                .header h2 {
                    font-size: 1.5rem;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .message-container {
                    height: 250px;
                }
            }
        </style>
    </head>
    <body>

        <div class="main-container">
            <div class="content-wrapper">
                <div class="message-page">
                    <!-- Tiêu đề -->
                    <div class="header">
                        <h2><i class="fa-regular fa-envelope"></i> Tin nhắn chờ</h2>
                    </div>

                    <!-- Trạng thái -->
                    <div class="status-card">
                        <% Boolean hasPendingMessages = (Boolean) request.getAttribute("hasPendingMessages");
                            if (hasPendingMessages != null && hasPendingMessages) { %>
                        <i class="fa-solid fa-circle-exclamation"></i> Bạn có tin nhắn chờ cần trả lời!
                        <% } else { %>
                        <i class="fa-regular fa-bell"></i> Hiện tại không có tin nhắn chờ.
                        <% }%>
                    </div>

                    <!-- Nút hành động -->
                    <div class="action-buttons">
                        <form action="CreateConsultationRequestServlet" method="post">
                            <button type="submit" class="btn-primary">
                                <i class="fa-solid fa-circle-plus"></i> Tạo yêu cầu tư vấn
                            </button>
                        </form>
                        <button class="btn-secondary">
                            <i class="fa-solid fa-inbox"></i> Xem hộp thư đến
                        </button>
                    </div>

                    <!-- Form tin nhắn -->
                    <form class="message-container" action="SendMessageServlet" method="post">
                        <div class="message-header">
                            <input type="text" name="subject" class="message-subject" placeholder="Nhập chủ đề tin nhắn..." required />
                        </div>
                        <div class="message-body">
                            <textarea name="messageContent" class="message-content" placeholder="Nhập nội dung tin nhắn của bạn ở đây..." required></textarea>
                        </div>
                        <div class="message-footer">
                            <button type="submit" class="btn-send">
                                Gửi tin nhắn <i class="fa-regular fa-paper-plane"></i>
                            </button>
                        </div>
                    </form>

                    <div class="footer">
                        cott.tm.ndda
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>