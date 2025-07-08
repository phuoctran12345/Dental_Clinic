<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/common/taglib.jsp" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title>404 - Không tìm thấy trang</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/error.css">
        </head>

        <body>
            <div class="error-container">
                <div class="error-content">
                    <h1>404</h1>
                    <h2>Oops! Không tìm thấy trang</h2>
                    <p>Xin lỗi, trang bạn đang tìm kiếm không tồn tại, đã bị xóa hoặc tạm thời không khả dụng.</p>
                    <a href="${pageContext.request.contextPath}/DispatchServlet" class="btn-home">Về trang chủ</a>
                </div>
            </div>
        </body>

        </html>