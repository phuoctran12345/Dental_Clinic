<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${pageTitle}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                background: #f4f6f9;
            }
            .container-fluid {
                min-height: 100vh;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 10px;
                border-radius: 10px;
            }
            #menu-toggle:checked ~ .container-fluid {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
            }
            .doctor-caidat {
                background: white;
                border: 2px solid #007bff;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .doctor-info {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px;
                border-radius: 15px 15px 0 0;
                margin: -15px -15px 15px -15px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 6px;
                color: #555;
            }
            input[type="text"], input[type="date"], select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background-color: #f9f9f9;
                color: #333;
            }
            input[readonly] {
                background-color: #e9ecef;
            }
            input[type="submit"] {
                background-color: #4CAF50;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }
            input[type="submit"]:hover {
                background-color: #45a049;
            }
            .avatar-img {
                max-width: 100%;
                border-radius: 5px;
                margin-bottom: 10px;
            }
            .error-message {
                color: red;
                text-align: center;
                margin-bottom: 15px;
            }
            .extra {
                text-align: center;
                margin-top: 10px;
            }
            .extra a {
                color: #007bff;
                text-decoration: none;
            }
            .extra a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="main-container">
                        <!-- Header -->
                        <div class="page-header">
                            <h1><i class="fas fa-user-md me-3"></i>Chỉnh sửa thông tin bác sĩ</h1>
                            <p class="mb-0">Cập nhật thông tin cá nhân của bác sĩ</p>
                        </div>

                        <!-- Doctor Edit Form -->
                        <div class="doctor-caidat">
                            <div class="doctor-info">
                                <h4>Thông tin bác sĩ</h4>
                            </div>

                            <!-- Hiển thị thông báo lỗi nếu có -->
                            <c:if test="${not empty errorMessage}">
                                <div class="error-message"><c:out value="${errorMessage}"/></div>
                            </c:if>

                            <div class="form-group">
                                <c:choose>
                                    <c:when test="${not empty doctor}">
                                        <form action="doctor_caidat" method="post">
                                            <input type="hidden" name="user_id" value="<c:out value='${doctor.userId}'/>">

                                            <!-- Hiển thị ảnh đại diện nếu có -->
                                            <c:if test="${not empty doctor.avatar}">
                                                <img src="<c:out value='${doctor.avatar}'/>" alt="Avatar" class="avatar-img">
                                            </c:if>
                                            <c:if test="${empty doctor.avatar}">
                                                <input type="text" value="Chưa có ảnh đại diện" readonly>
                                            </c:if>

                                            <label for="doctorId">ID Bác Sĩ</label>
                                            <input type="text" id="doctorId" name="doctorId" value="<c:out value='${doctor.doctorId}'/>" readonly>

                                            <label for="fullName">Họ Tên</label>
                                            <input type="text" id="fullName" name="full_name" value="<c:out value='${doctor.fullName}'/>" required>

                                            <label for="specialty">Chuyên Khoa</label>
                                            <input type="text" id="specialty" name="specialty" value="<c:out value='${doctor.specialty}'/>" required>

                                            <label for="phone">Số Điện Thoại</label>
                                            <input type="text" id="phone" name="phone" value="<c:out value='${doctor.phone}'/>" required>

                                            <label for="address">Địa Chỉ</label>
                                            <input type="text" id="address" name="address" value="<c:out value='${doctor.address}'/>">

                                            <label for="dateOfBirth">Ngày Sinh</label>
                                            <input type="date" id="dateOfBirth" name="date_of_birth" 
                                                   value="<fmt:formatDate value='${doctor.dateOfBirth}' pattern='yyyy-MM-dd'/>">

                                            <label for="gender">Giới Tính</label>
                                            <select id="gender" name="gender" required>
                                                <option value="male" <c:if test="${doctor.gender == 'Nam'}">selected</c:if>>Nam</option>
                                                <option value="female" <c:if test="${doctor.gender == 'Nữ'}">selected</c:if>>Nữ</option>
                                                <option value="other" <c:if test="${doctor.gender == 'Khác'}">selected</c:if>>Khác</option>
                                                </select>

                                                <label for="licenseNumber">Số Giấy Phép</label>
                                                <input type="text" id="licenseNumber" name="license_number" value="<c:out value='${doctor.licenseNumber}'/>" required>

                                            <label for="status">Trạng Thái</label>
                                            <select id="status" name="status" required>
                                                <option value="Đang hoạt động" <c:if test="${doctor.status == 'Active'}">selected</c:if>>Hoạt động</option>
                                                <option value="Không hoạt động" <c:if test="${doctor.status == 'Inactive'}">selected</c:if>>Không hoạt động</option>
                                                </select>

                                                <form action="uploadAvatar" method="post" enctype="multipart/form-data">
                                                    <label for="avatar">Ảnh Đại Diện</label>
                                                    <input type="file" id="avatar" name="avatar" accept="image/*" value="<c:out value='${doctor.avatar}'/>">
                                                <input type="submit" value="Upload">
                                            </form>
                                            <div class="form-group text-center mt-3">
                                                <a href="doctor_changepassword.jsp" class="btn btn-warning">
                                                    <i class="fas fa-key me-1"></i> Đổi mật khẩu
                                                </a>
                                            </div>

                                            <div class="form-group">
                                                <input type="submit" value="Cập nhật thông tin">
                                            </div>
                                        </form>

                                        <div class="extra">
                                            <a href="doctor_trangcanhan">Quay lại hồ sơ</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="error-message">
                                            Không tìm thấy thông tin bác sĩ.
                                            <a href="doctor_trangcanhan">Quay lại hồ sơ</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>