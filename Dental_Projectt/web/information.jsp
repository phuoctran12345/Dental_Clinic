<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    Integer id = (session != null) ? (Integer) session.getAttribute("id") : null;
    if (id == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông Tin Bệnh Nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="d-flex justify-content-center align-items-center vh-100 bg-light">
<div class="card p-4" style="width: 420px">
    <h4 class="text-center mb-3">Hoàn tất thông tin bệnh nhân</h4>

    <form action="RegisterInformation" method="post">
        <div class="mb-3">
            <label class="form-label">Họ tên</label>
            <input type="text" name="full_name" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Số điện thoại</label>
            <input type="text" name="phone" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">Ngày sinh</label>
            <input type="date" name="date_of_birth" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">Giới tính</label>
            <select name="gender" class="form-select">
                <option value="male">Nam</option>
                <option value="female">Nữ</option>
                <option value="other">Khác</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary w-100">Hoàn tất đăng ký</button>
    </form>
</div>
</body>
</html>
