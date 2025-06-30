<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/common/taglib.jsp" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title>404 - Không tìm thấy trang</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    font-family: Arial, sans-serif;
                    background-color: #f5f5f5;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                }

                .error-container {
                    text-align: center;
                    padding: 40px;
                    background-color: white;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    max-width: 500px;
                    width: 90%;
                }

                .error-content h1 {
                    font-size: 72px;
                    color: #e74c3c;
                    margin: 0;
                }

                .error-content h2 {
                    font-size: 24px;
                    color: #333;
                    margin: 20px 0;
                }

                .error-content p {
                    color: #666;
                    margin-bottom: 30px;
                    line-height: 1.6;
                }

                .btn-home {
                    display: inline-block;
                    padding: 12px 30px;
                    background-color: #3498db;
                    color: white;
                    text-decoration: none;
                    border-radius: 4px;
                    transition: background-color 0.3s;
                }

                .btn-home:hover {
                    background-color: #2980b9;
                }
            </style>
        </head>

        <body>
            <div class="error-container">
                <div class="error-content">
                    <h1>404</h1>
                    <h2>Oops! Không tìm thấy trang</h2>
                    <p>Xin lỗi, trang bạn đang tìm kiếm không tồn tại, đã bị xóa hoặc tạm thời không khả dụng.</p>
                    <c:if test="${not empty error}">
                        <p style="color: #e74c3c;">${error}</p>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/DispatchServlet" class="btn-home">Về trang chủ</a>
                </div>
            </div>
        </body>

        </html>