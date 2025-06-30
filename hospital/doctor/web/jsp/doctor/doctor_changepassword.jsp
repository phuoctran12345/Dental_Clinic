<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đổi Mật Khẩu Bác Sĩ</title>
    </head>
    <body>
        <h2 style="text-align: center;">Đổi Mật Khẩu Bác Sĩ</h2>
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
            if (errorMessage != null) {
        %>
        <p style="color: red;"><%= errorMessage %></p>
        <% } %>
        <% if (successMessage != null) { %>
        <p style="color: green;"><%= successMessage %></p>
        <% } %>
        <form action="/doctor/DoctorChangePasswordServlet" method="post">
            <div>
                <label for="currentPassword">Mật khẩu hiện tại:</label><br>
                <input type="password" id="currentPassword" name="currentPassword" required><br><br>
            </div>
            <div>
                <label for="newPassword">Mật khẩu mới:</label><br>
                <input type="password" id="newPassword" name="newPassword" required><br><br>
            </div>
            <div>
                <label for="confirmPassword">Xác nhận mật khẩu mới:</label><br>
                <input type="password" id="confirmPassword" name="confirmPassword" required><br><br>
            </div>
            <input type="submit" value="Đổi Mật Khẩu">
        </form>
        <br>
        <a href="/doctor/DoctorTongQuanServlet">Quay lại</a>
    </body>
</html>
