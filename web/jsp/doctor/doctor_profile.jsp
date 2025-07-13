<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ include file="/jsp/doctor/doctor_header.jsp" %>
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Cập nhật thông tin bác sĩ</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                </head>

                <body>
                    <div class="container mt-4">
                        <h2 class="mb-4"><i class="fa-solid fa-user-doctor me-2"></i>Cập nhật thông tin bác sĩ</h2>

                        <!-- Hiển thị thông báo lỗi -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Hiển thị thông báo thành công -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-circle-check me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Thông tin cá nhân</h5>
                            </div>
                            <div class="card-body">
                                <form action="DoctorProfileServlet" method="POST" class="needs-validation" novalidate>
                                    <input type="hidden" name="action" value="update">

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="fullName" class="form-label">Họ và tên</label>
                                            <input type="text" class="form-control" id="fullName" name="fullName"
                                                required>
                                            <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Số điện thoại</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" required>
                                            <div class="invalid-feedback">Vui lòng nhập số điện thoại</div>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                                required>
                                            <div class="invalid-feedback">Vui lòng chọn ngày sinh</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="gender" class="form-label">Giới tính</label>
                                            <select class="form-select" id="gender" name="gender" required>
                                                <option value="">Chọn giới tính</option>
                                                <option value="male">Nam</option>
                                                <option value="female">Nữ</option>
                                                <option value="other">Khác</option>
                                            </select>
                                            <div class="invalid-feedback">Vui lòng chọn giới tính</div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Địa chỉ</label>
                                        <textarea class="form-control" id="address" name="address" rows="2"
                                            required></textarea>
                                        <div class="invalid-feedback">Vui lòng nhập địa chỉ</div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="specialty" class="form-label">Chuyên khoa</label>
                                            <input type="text" class="form-control" id="specialty" name="specialty"
                                                required>
                                            <div class="invalid-feedback">Vui lòng nhập chuyên khoa</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="licenseNumber" class="form-label">Số giấy phép hành nghề</label>
                                            <input type="text" class="form-control" id="licenseNumber"
                                                name="licenseNumber" required>
                                            <div class="invalid-feedback">Vui lòng nhập số giấy phép</div>
                                        </div>
                                    </div>

                                    <div class="text-end">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Lưu thông tin
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        // Form validation
                        const forms = document.querySelectorAll('.needs-validation');
                        Array.from(forms).forEach(form => {
                            form.addEventListener('submit', event => {
                                if (!form.checkValidity()) {
                                    event.preventDefault();
                                    event.stopPropagation();
                                }
                                form.classList.add('was-validated');
                            }, false);
                        });
                    </script>
                </body>

                </html>