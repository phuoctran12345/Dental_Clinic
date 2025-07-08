<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Thông Tin Bệnh Nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="d-flex justify-content-center align-items-center vh-100 bg-light">
        <div class="card p-4" style="width: 420px">
            <h4 class="text-center mb-3">Hoàn tất thông tin bệnh nhân</h4>

            <%-- Hiển thị thông báo nếu có --%>
                <% if (request.getAttribute("message") !=null) { %>
                    <div class="alert alert-info text-center mb-3">
                        <%= request.getAttribute("message") %>
                    </div>
                    <% } %>

                        <form action="UserRegisterWhenTheyNotRegisterInformation" method="POST">
                            <%-- Thêm hidden field cho user_id --%>
                                <input type="hidden" name="user_id" value="<%= session.getAttribute("user_id_for_patient") %>">

                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" value="<%= session.getAttribute("email_for_patient") !=null ? session.getAttribute("email_for_patient") : "" %>"
                                    readonly>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" name="fullname" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="tel" name="phone" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                    <textarea name="address" class="form-control" rows="3" required></textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Ngày sinh <span class="text-danger">*</span></label>
                                    <input type="date" name="dob" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Giới tính <span class="text-danger">*</span></label>
                                    <select name="gender" class="form-select" required>
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary">Lưu thông tin</button>
                                </div>
                        </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>