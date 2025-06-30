<%-- Document : datlich-thanhcong Created on : May 27, 2025, 5:14:09 PM Author : Home --%>
    <%@ page contentType="text/html; charset=UTF-8" language="java" %>
        <%@ include file="../patient/user_header.jsp" %>
            <%@ include file="../patient/user_menu.jsp" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Xác nhận đặt lịch</title>
                    <style>
                        body {
                            font-family: 'Segoe UI', sans-serif;
                            background: linear-gradient(to right, #e0f7fa, #f1f5f9);
                            margin: 0;
                        }

                        .container i {}

                        .container {
                            margin-left: 300px;
                            padding: 60px 30px;
                            text-align: center;
                        }

                        .message-box {
                            max-width: 600px;
                            margin: 60px auto;
                            background-color: #ffffff;
                            padding: 40px 60px;
                            border-radius: 16px;
                            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                            text-align: center;
                        }

                        .message-box h2 {
                            color: #00796b;
                            margin-bottom: 20px;
                        }

                        .message-box p {
                            font-size: 18px;
                            margin-top: 10px;
                            color: #333;
                        }

                        .btn-back {
                            margin-top: 25px;
                            padding: 10px;
                            background-color: #00796b;
                            color: white;
                            text-decoration: none;
                            border-radius: 10px;
                            font-weight: bold;
                            transition: background-color 0.3s;
                        }

                        .btn-back:hover {
                            background-color: #004d40;
                        }

                        .thongbao {
                            padding-bottom: 30px;
                        }
                    </style>
                </head>

                <body>

                    <div class="container">
                        <div class="message-box">

                            <h2><i class="fa-solid fa-circle-check"></i> Thông báo</h2>
                            <div class="thongbao">
                                <p>
                                    <%= request.getAttribute("message") %>
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/BookingPageServlet" class="btn-back">Quay về trang chủ</a>
                        </div>
                    </div>

                </body>

                </html>