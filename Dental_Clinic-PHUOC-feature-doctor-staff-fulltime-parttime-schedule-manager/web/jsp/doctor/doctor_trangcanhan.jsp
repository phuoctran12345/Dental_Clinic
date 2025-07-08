<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Doctors" %>
<%@ include file="doctor_header.jsp" %>
<%@ include file="doctor_menu.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hồ Sơ Bác Sĩ</title>
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
            .doctor-trangcanhan {
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
            input[type="text"] {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background-color: #f9f9f9;
                color: #333;
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
                            <h1><i class="fas fa-user-md me-3"></i>Hồ Sơ Cá Nhân Bác Sĩ</h1>
                            <p class="mb-0">Thông tin chi tiết về bác sĩ</p>
                        </div>

                        <!-- Doctor Information -->
                        <div class="doctor-trangcanhan">
                            <div class="doctor-info">
                                <h4>Thông Tin Bác Sĩ</h4>
                            </div>

                            <!-- Hiển thị thông báo lỗi nếu có -->
                            <% if (request.getAttribute("errorMessage") != null) { %>
                            <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
                            <% } %>

                            <div class="form-group">
                                <% 
                                    Object doctor_trangcanhan = request.getAttribute("doctor_trangcanhan");
                                    if (doctor_trangcanhan != null) {
                                        Doctors doc = (Doctors) doctor_trangcanhan;
                                %>
                                <!-- Hiển thị ảnh đại diện nếu có -->
                                <% if (doc.getAvatar() != null && !doc.getAvatar().isEmpty()) { %>
                                <img src="<%= doc.getAvatar() %>" alt="Avatar" class="avatar-img">
                                <% } else { %>
                                <input type="text" value="Chưa có ảnh đại diện" readonly>
                                <% } %>

                                <label for="doctorId">ID Bác Sĩ</label>
                                <input type="text" id="doctorId" value="<%= doc.getDoctorId() %>" readonly>

                                <label for="fullName">Họ Tên</label>
                                <input type="text" id="fullName" value="<%= doc.getFullName() %>" readonly>

                                <label for="specialty">Chuyên Khoa</label>
                                <input type="text" id="specialty" value="<%= doc.getSpecialty() %>" readonly>

                                <label for="phone">Số Điện Thoại</label>
                                <input type="text" id="phone" value="<%= doc.getPhone() %>" readonly>

                                <label for="dateOfBirth">Ngày Sinh</label>
                                <input type="text" id="dateOfBirth" value="<%= (doc.getDate_of_birth() != null) ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(doc.getDate_of_birth()) : "Chưa cập nhật" %>" readonly>
                                <%
                                    String gender = doc.getGender();
                                    String genderDisplay = "Chưa cập nhật";
                                    if ("male".equalsIgnoreCase(gender)) {
                                        genderDisplay = "Nam";
                                    } else if ("female".equalsIgnoreCase(gender)) {
                                        genderDisplay = "Nữ";
                                    } else if (gender != null) {
                                        genderDisplay = "Khác"; // nếu có giá trị khác
                                    }
                                %>

                                <label for="gender">Giới Tính</label>
                                <input type="text" id="gender" value="<%= genderDisplay %>" readonly>


                                <% } else { %>
                                <div class="error-message">
                                    Không tìm thấy thông tin bác sĩ. 
                                    <a href="/doctor-schedule">Quay lại lịch làm việc</a>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
