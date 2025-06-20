<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Page</title>
    </head>

    <body>
        <h1>Lịch Khám Test Page</h1>
        <p>Nếu bạn thấy trang này, nghĩa là JSP đã được render thành công.</p>

        <% // Lấy dữ liệu từ request để kiểm tra Object appointments=request.getAttribute("appointments"); String
            errorMessage=(String) request.getAttribute("errorMessage"); %>

            <p>
                Attribute 'appointments' is: <%= appointments !=null ? "Not Null" : "Null" %>
            </p>
            <p>
                Attribute 'errorMessage' is: <%= errorMessage !=null ? "'" + errorMessage + "'" : "Null" %>
            </p>

    </body>

    </html>