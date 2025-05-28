<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebars.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tin nhắn chờ</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: "Segoe UI", sans-serif;
                width: 100%;
            }

            .header{
                font-weight: 500;

            }


            .message-page {
                display: flex;
                flex-direction: column;
                height: 100vh;
                padding-left: 250px; /* cho sidebar */
                padding-top: 20px;
                padding-right: 20px;

            }


            .status {
                padding: 15px 30px;
                font-size: 16px;
                color: #333;

                margin-bottom: 15px;
            }

            .actions {
                padding: 0 30px 10px 30px;
                margin-bottom: 10px;
            }

            .actions form {
                display: inline-block;
            }

            .actions button {
                padding: 10px 10px 10px 10px;
                background-color: #007bff;
                color: white;
                font-size: 16px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            .actions button:hover {
                background-color: #0056b3;
            }

            .message-form {
                flex: 1;
                display: flex;
                flex-direction: column;
                margin: 0 30px 50px 30px;
                background-color: white;
                border-radius: 20px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                padding-bottom: 100px;
            }

            .message-form input.message-subject {
                font-size: 16px;
                padding: 12px 16px;
                border: 2px solid #ccc;
                border-radius: 20px 20px 0 0;
                outline: none;
                transition: border-color 0.2s ease;
            }

            .message-form input.message-subject:focus {
                border-color: #007bff;
            }

            .message-form textarea {
                flex: 1;
                padding: 20px;
                font-size: 18px;
                border: none;
                outline: none;
                resize: none;
                box-sizing: border-box;
            }

            .message-form button {
                position: absolute;
                bottom: 20px;
                right: 20px;
                padding: 10px 18px;
                font-size: 15px;
                font-weight: bold;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.3s ease;
                margin-right: 70px;
            }

            .message-form button:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body>

        <div class="message-page">
            <!-- Tiêu đề -->
            
            <div class="header">
                <h2><i class="fa-regular fa-envelope"></i> Tin nhắn chờ</h2>
            </div>

            <!-- Trạng thái -->
            <div class="status">
                <% Boolean hasPendingMessages = (Boolean) request.getAttribute("hasPendingMessages");
                    if (hasPendingMessages != null && hasPendingMessages) { %>
                ✅ Bạn có tin nhắn chờ cần trả lời!
                <% } else { %>
                <span><i class="fa-regular fa-bell"></i> Hiện tại không có tin nhắn chờ.</span>
                <% }%>
            </div>

            <!-- Nút tạo yêu cầu -->
            <div class="actions">
                <form action="CreateConsultationRequestServlet" method="post">
                    <button type="submit"><i class="fa-solid fa-circle-plus"></i> Tạo yêu cầu tư vấn</button>
                </form>
            </div>
            <!-- Form tin nhắn -->
            <!-- Dòng 4: Form gửi tin nhắn -->
            <form class="message-form" action="SendMessageServlet" method="post">
                <input type="text" name="subject" class="message-subject" placeholder="Chủ đề tin nhắn" required />
                <textarea name="messageContent" placeholder="Nhập nội dung tin nhắn..." required></textarea>
                <button type="submit">Gửi tin nhắn <i class="fa-regular fa-paper-plane"></i></button>
            </form>


        </div>

    </body>
</html>
