<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="model.User" %>
<%@page import="model.Patients" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="user_header.jsp" %>
<%@ include file="user_menu.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thông Tin Cá Nhân</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #F9FAFB;
            margin: 0;
            width: 100%;
            min-height: 100vh;
            box-sizing: border-box;
            overflow-x: hidden;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 270px;
            height: 100%;
            background: #ffffff;
            z-index: 100;
            border-right: 1px solid #eaeaea;
        }

        .dashboard {
            padding-left: 270px;
            padding-top: 30px;
            display: grid;
            gap: 20px;
            padding-right: 30px;
            padding-bottom: 50px;
            box-sizing: border-box;
            min-height: 90vh;
            justify-content: center;
        }

        .profile-card {
            background: #ffffff;
            border: 1px solid #eaeaea;
            border-radius: 8px;
            padding: 30px;
            width: 1200px;
            max-width: 2000px;
        }

        .dashboard h2 {
            color: #4E80EE;
            font-weight: 700;
            margin-bottom: 30px;
            font-size: 28px;
            text-align: center;
        }

        .dashboard p {
            font-size: 18px;
            color: #333333;
            margin: 0;
            padding: 16px 0;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .dashboard strong {
            color: #333333;
            font-weight: 600;
            min-width: 150px;
            font-size: 18px;
        }

        .edit-btn {
            background: #4E80EE;
            border: none;
            color: white;
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }

        .password-container {
            position: relative;
            display: inline-block;
            width: 100%;
            max-width: 320px;
        }

        .password-display {
            background: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 12px 40px 12px 15px;
            font-size: 18px;
            color: #333333;
            display: inline-block;
            width: 100%;
            box-sizing: border-box;
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #7a7a7a;
            cursor: pointer;
            font-size: 18px;
        }

        .editable-field {
            background: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            color: #333333;
            padding: 12px 15px;
            font-size: 18px;
            width: 100%;
            max-width: 320px;
            box-sizing: border-box;
        }

        .editable-field:focus {
            border-color: #4E80EE;
            outline: none;
        }

        .save-btn {
            background: #4E80EE;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            margin-top: 15px;
            font-size: 16px;
        }

        .cancel-btn {
            background: #a0a0a0;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            margin-top: 15px;
            margin-left: 10px;
            font-size: 16px;
        }

        .error-message {
            color: #e74c3c;
            font-size: 16px;
            margin-top: 8px;
            display: none;
        }

        .server-error {
            color: #e74c3c;
            font-size: 16px;
            text-align: center;
            margin-bottom: 20px;
            padding: 12px;
            background: #fde8e8;
            border-radius: 6px;
        }

        .server-success {
            color: #27ae60;
            font-size: 16px;
            text-align: center;
            margin-bottom: 20px;
            padding: 12px;
            background: #d5f4e6;
            border-radius: 6px;
        }

        .field-row {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            width: 100%;
        }

        .field-content {
            flex: 1;
            min-width: 250px;
        }

        .patient-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .patient-table th, .patient-table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
        }

        .patient-table th {
            background: #f9f9f9;
            font-weight: 600;
            color: #333333;
        }

        .new-patient-form .field-row {
            margin-bottom: 20px;
            align-items: flex-start;
        }

        .new-patient-form label {
            display: block;
            font-weight: 600;
            color: #333333;
            margin-bottom: 8px;
            font-size: 18px;
        }

        .new-patient-form .editable-field {
            width: 100%;
            max-width: 320px;
        }

        .new-patient-form .error-message {
            margin-top: 5px;
        }

        .new-patient-form .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .profile-picture-container {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .profile-picture {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e0e0e0;
            background: #f9f9f9;
        }

        .profile-picture-placeholder {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7a7a7a;
            font-size: 14px;
            text-align: center;
        }

        .profile-picture-input {
            display: none;
        }

        .profile-picture-label {
            background: #4E80EE;
            color: white;
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            display: inline-block;
        }

        .profile-picture-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            display: none;
            border: 2px solid #e0e0e0;
            margin-left: 20px;
        }

        @media (max-width: 768px) {
            .dashboard {
                padding-left: 0;
                width: 100%;
                padding: 20px;
            }

            .sidebar {
                width: 250px;
                transform: translateX(-100%);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .profile-card {
                max-width: 100%;
                padding: 20px;
            }

            .dashboard h2 {
                font-size: 24px;
            }

            .dashboard p {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .dashboard strong {
                min-width: 100%;
            }

            .edit-btn {
                align-self: flex-end;
            }

            .new-patient-form .editable-field {
                max-width: 100%;
            }

            .profile-picture-container {
                flex-direction: column;
                align-items: flex-start;
            }

            .profile-picture, .profile-picture-placeholder, .profile-picture-preview {
                width: 80px;
                height: 80px;
            }
        }
    </style>
</head>

<body>
    <div class="dashboard">
        <div class="profile-card">
            <h2>Thông Tin Cá Nhân</h2>

            <!-- Hiển thị thông báo lỗi -->
            <% String error = (String) request.getAttribute("error"); 
               if (error == null) { error = request.getParameter("error"); } 
               if (error != null) { %>
                <div class="server-error">
                    <%= error %>
                </div>
            <% } %>

            <!-- Hiển thị thông báo thành công -->
            <% String success = (String) request.getAttribute("success"); 
               if (success == null) { success = request.getParameter("success"); } 
               if (success != null) { %>
                <div class="server-success">
                    <%= success %>
                </div>
            <% } %>

            <% 
                Object userObj = session.getAttribute("user"); 
                User users = null; 
                if (userObj instanceof User) { users = (User) userObj; }
                Object patientObj = session.getAttribute("patient"); 
                Patients patient = null; 
                if (patientObj instanceof Patients) { patient = (Patients) patientObj; } 
                if (users == null && patient == null) { %>
                    <p>Không tìm thấy thông tin người dùng hoặc bệnh nhân.</p>
            <% } else { 
                if (users != null) { 
                    String passwordMask = users.getPasswordHash() != null ? "•".repeat(users.getPasswordHash().length()) : "--"; 
            %>

                    <!-- Email Field -->
                    <p>
                        <strong>Email:</strong>
                        <div class="field-row">
                            <div class="field-content">
                                <span id="emailDisplay">
                                    <%= users.getEmail() != null ? users.getEmail() : "--" %>
                                </span>
                                <form id="emailForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;">
                                    <input type="hidden" name="field" value="email">
                                    <input type="email" name="value" class="editable-field" id="emailInput" 
                                           value="<%= users.getEmail() != null ? users.getEmail() : "" %>" required>
                                    <div class="error-message" id="emailError">Vui lòng nhập email hợp lệ.</div>
                                    <button type="submit" class="save-btn">Lưu</button>
                                    <button type="button" class="cancel-btn" onclick="cancelEdit('email')">Hủy</button>
                                </form>
                            </div>
                            <button class="edit-btn" id="emailEditBtn" onclick="editField('email')">Sửa</button>
                        </div>
                    </p>

                    <!-- Password Field -->
                    <p>
                        <strong>Mật khẩu:</strong>
                        <div class="field-row">
                            <div class="field-content">
                                <div id="passwordDisplay" class="password-container">
                                    <span class="password-display">
                                        <%= passwordMask %>
                                    </span>
                                    <button class="toggle-password" onclick="togglePassword()" title="Hiển thị/Ẩn mật khẩu">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <form id="passwordForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;">
                                    <input type="hidden" name="type" value="password">
                                    <!-- Mật khẩu cũ -->
                                    <div style="margin-bottom: 15px;">
                                        <label style="display: block; margin-bottom: 5px;">Mật khẩu cũ:</label>
                                        <input type="password" name="oldPassword" class="editable-field" required>
                                    </div>
                                    <!-- Mật khẩu mới -->
                                    <div style="margin-bottom: 15px;">
                                        <label style="display: block; margin-bottom: 5px;">Mật khẩu mới:</label>
                                        <input type="password" name="newPassword" class="editable-field" required>
                                    </div>
                                    <!-- Xác nhận mật khẩu mới -->
                                    <div style="margin-bottom: 15px;">
                                        <label style="display: block; margin-bottom: 5px;">Xác nhận mật khẩu mới:</label>
                                        <input type="password" name="confirmPassword" class="editable-field" required>
                                    </div>
                                    <!-- Thông báo lỗi -->
                                    <div class="error-message" style="color: red; margin-bottom: 10px;"></div>
                                    <!-- Nút submit và hủy -->
                                    <div>
                                        <button type="submit" class="save-btn">Lưu thay đổi</button>
                                        <button type="button" class="cancel-btn" onclick="hidePasswordForm()">Hủy</button>
                                    </div>
                                </form>
                            </div>
                            <button class="edit-btn" id="passwordEditBtn" onclick="showPasswordForm()">Sửa</button>
                        </div>
                    </p>
            <% } %>

            <!-- Patient Information -->
            <h2>Thông Tin Bệnh Nhân</h2>
            <% if (patient != null) { %>
                <!-- Profile Picture Field -->
                <p>
                    <strong>Ảnh đại diện:</strong>
                    <div class="field-row profile-picture-container">
                        <div class="field-content">
                            <% String avatar = patient.getAvatar() != null ? patient.getAvatar() : ""; %>
                            <% if (!avatar.isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}<%= avatar %>" class="profile-picture" alt="Ảnh đại diện">
                            <% } else { %>
                                <div class="profile-picture-placeholder">Không có ảnh</div>
                            <% } %>
                            <form id="profilePictureForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" enctype="multipart/form-data" style="display: inline-block;">
                                <input type="hidden" name="type" value="profile_picture">
                                <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                <input type="file" name="profilePicture" id="profilePictureInput" class="profile-picture-input" accept="image/png,image/jpeg,image/jpg" required>
                                <label for="profilePictureInput" class="profile-picture-label">Chọn ảnh</label>
                                <img id="profilePicturePreview" class="profile-picture-preview" alt="Ảnh xem trước">
                                <div class="error-message" id="profilePictureError">Vui lòng chọn file ảnh (PNG, JPG).</div>
                                <button type="submit" class="save-btn">Lưu</button>
                                <button type="button" class="cancel-btn" onclick="cancelProfilePicture()">Hủy</button>
                            </form>
                        </div>
                    </div>
                </p>

                <table class="patient-table">
                    <tr>
                        <th>Họ tên</th>
                        <td>
                            <div class="field-row">
                                <div class="field-content">
                                    <span id="fullNameDisplay">
                                        <%= patient.getFullName() != null ? patient.getFullName() : "--" %>
                                    </span>
                                    <form id="fullNameForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;">
                                        <input type="hidden" name="type" value="update_patient_info">
                                        <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                        <input type="text" name="fullName" class="editable-field" id="fullNameInput"
                                               value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>" required>
                                        <div class="error-message" id="fullNameError">Vui lòng nhập họ tên hợp lệ.</div>
                                        <input type="hidden" name="phone" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                                        <input type="hidden" name="dateOfBirth" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>">
                                        <input type="hidden" name="gender" value="<%= patient.getGender() != null ? patient.getGender() : "" %>">
                                        <button type="submit" class="save-btn">Lưu</button>
                                        <button type="button" class="cancel-btn" onclick="cancelEdit('fullName')">Hủy</button>
                                    </form>
                                </div>
                                <button class="edit-btn" id="fullNameEditBtn" onclick="editField('fullName')">Sửa</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>Điện thoại</th>
                        <td>
                            <div class="field-row">
                                <div class="field-content">
                                    <span id="phoneDisplay">
                                        <%= patient.getPhone() != null ? patient.getPhone() : "--" %>
                                    </span>
                                    <form id="phoneForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;">
                                        <input type="hidden" name="type" value="update_patient_info">
                                        <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                        <input type="tel" name="phone" class="editable-field" id="phoneInput"
                                               value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>"
                                               pattern="[0-9]{10,11}" required>
                                        <div class="error-message" id="phoneError">Vui lòng nhập số điện thoại hợp lệ (10-11 số).</div>
                                        <input type="hidden" name="fullName" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>">
                                        <input type="hidden" name="dateOfBirth" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>">
                                        <input type="hidden" name="gender" value="<%= patient.getGender() != null ? patient.getGender() : "" %>">
                                        <button type="submit" class="save-btn">Lưu</button>
                                        <button type="button" class="cancel-btn" onclick="cancelEdit('phone')">Hủy</button>
                                    </form>
                                </div>
                                <button class="edit-btn" id="phoneEditBtn" onclick="editField('phone')">Sửa</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>Ngày sinh</th>
                        <td>
                            <div class="field-row">
                                <div class="field-content">
                                    <span id="dobDisplay">
                                        <% 
                                            Date dob = patient.getDateOfBirth(); 
                                            String formattedDob = "--"; 
                                            if (dob != null) { 
                                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
                                                formattedDob = sdf.format(dob); 
                                            } 
                                        %>
                                        <%= formattedDob %>
                                    </span>
                                    <form id="dobForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;">
                                        <input type="hidden" name="type" value="update_patient_info">
                                        <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                        <input type="date" name="dateOfBirth" class="editable-field" id="dobInput"
                                               value="<%= formattedDob != "--" ? formattedDob : "" %>" required>
                                        <div class="error-message" id="dobError">Vui lòng nhập ngày sinh hợp lệ.</div>
                                        <input type="hidden" name="fullName" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>">
                                        <input type="hidden" name="phone" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                                        <input type="hidden" name="gender" value="<%= patient.getGender() != null ? patient.getGender() : "" %>">
                                        <button type="submit" class="save-btn">Lưu</button>
                                        <button type="button" class="cancel-btn" onclick="cancelEdit('dob')">Hủy</button>
                                    </form>
                                </div>
                                <button class="edit-btn" id="dobEditBtn" onclick="editField('dob')">Sửa</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>Giới tính</th>
                        <td>
                            <div class="field-row">
                                <div class="field-content">
                                    <span id="genderDisplay">
                                        <% 
                                            String genderDisplay = "--";
                                            if (patient.getGender() != null) {
                                                switch (patient.getGender()) {
                                                    case "male":
                                                        genderDisplay = "Nam";
                                                        break;
                                                    case "female":
                                                        genderDisplay = "Nữ";
                                                        break;
                                                    case "other":
                                                        genderDisplay = "Khác";
                                                        break;
                                                    default:
                                                        genderDisplay = patient.getGender();
                                                }
                                            }
                                        %>
                                        <%= genderDisplay %>
                                    </span>
                                    <form id="genderForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" style="display: none;">
                                        <input type="hidden" name="type" value="update_patient_info">
                                        <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                        <select name="gender" class="editable-field" id="genderInput" required>
                                            <option value="male" <%= patient.getGender() != null && patient.getGender().equals("male") ? "selected" : "" %>>Nam</option>
                                            <option value="female" <%= patient.getGender() != null && patient.getGender().equals("female") ? "selected" : "" %>>Nữ</option>
                                            <option value="other" <%= patient.getGender() != null && patient.getGender().equals("other") ? "selected" : "" %>>Khác</option>
                                        </select>
                                        <div class="error-message" id="genderError">Vui lòng chọn giới tính.</div>
                                        <input type="hidden" name="fullName" value="<%= patient.getFullName() != null ? patient.getFullName() : "" %>">
                                        <input type="hidden" name="phone" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>">
                                        <input type="hidden" name="dateOfBirth" value="<%= patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : "" %>">
                                        <button type="submit" class="save-btn">Lưu</button>
                                        <button type="button" class="cancel-btn" onclick="cancelEdit('gender')">Hủy</button>
                                    </form>
                                </div>
                                <button class="edit-btn" id="genderEditBtn" onclick="editField('gender')">Sửa</button>
                            </div>
                        </td>
                    </tr>
                </table>
            <% } else { %>
                <p>Không tìm thấy thông tin bệnh nhân.</p>
                <form id="newPatientForm" action="${pageContext.request.contextPath}/UpdateUserServlet" method="post" class="new-patient-form" enctype="multipart/form-data">
                    <input type="hidden" name="type" value="update_patient_info">
                    <h3>Thêm Thông Tin Bệnh Nhân</h3>
                    <!-- Profile Picture Field for New Patient -->
                    <div class="field-row profile-picture-container">
                        <div class="field-content">
                            <div class="profile-picture-placeholder">Không có ảnh</div>
                            <input type="file" name="profilePicture" id="newProfilePictureInput" class="profile-picture-input" accept="image/png,image/jpeg,image/jpg">
                            <label for="newProfilePictureInput" class="profile-picture-label">Chọn ảnh</label>
                            <img id="newProfilePicturePreview" class="profile-picture-preview" alt="Ảnh xem trước">
                            <div class="error-message" id="newProfilePictureError">Vui lòng chọn file ảnh (PNG, JPG).</div>
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="field-content">
                            <label for="newFullNameInput">Họ tên:</label>
                            <input type="text" name="fullName" id="newFullNameInput" class="editable-field" required>
                            <div class="error-message" id="newFullNameError">Vui lòng nhập họ tên hợp lệ.</div>
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="field-content">
                            <label for="newPhoneInput">Điện thoại:</label>
                            <input type="tel" name="phone" id="newPhoneInput" class="editable-field" pattern="[0-9]{10,11}" required>
                            <div class="error-message" id="newPhoneError">Vui lòng nhập số điện thoại hợp lệ (10-11 số).</div>
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="field-content">
                            <label for="newDobInput">Ngày sinh:</label>
                            <input type="date" name="dateOfBirth" id="newDobInput" class="editable-field" required>
                            <div class="error-message" id="newDobError">Vui lòng nhập ngày sinh hợp lệ.</div>
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="field-content">
                            <label for="newGenderInput">Giới tính:</label>
                            <select name="gender" id="newGenderInput" class="editable-field" required>
                                <option value="male">Nam</option>
                                <option value="female">Nữ</option>
                                <option value="other">Khác</option>
                            </select>
                            <div class="error-message" id="newGenderError">Vui lòng chọn giới tính.</div>
                        </div>
                    </div>
                    <div class="button-group">
                        <button type="submit" class="save-btn">Thêm Bệnh Nhân</button>
                        <button type="button" class="cancel-btn" onclick="cancelNewPatient()">Hủy</button>
                    </div>
                </form>
            <% } %>
            <% } %>
        </div>
    </div>

    <script>
        let isPasswordVisible = false;

        function togglePassword() {
            const passwordDisplay = document.querySelector('#passwordDisplay .password-display');
            const toggleIcon = document.querySelector('#passwordDisplay .toggle-password i');
            if (isPasswordVisible) {
                passwordDisplay.textContent = '<%= users != null && users.getPasswordHash() != null ? "•".repeat(users.getPasswordHash().length()) : "--"%>';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
                isPasswordVisible = false;
            } else {
                passwordDisplay.textContent = '<%= users != null && users.getPasswordHash() != null ? users.getPasswordHash() : "--"%>';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
                isPasswordVisible = true;
            }
        }

        function editField(field) {
            document.getElementById(field + 'Display').style.display = 'none';
            document.getElementById(field + 'EditBtn').style.display = 'none';
            document.getElementById(field + 'Form').style.display = 'block';
            document.getElementById(field + 'Input').focus();
        }

        function cancelEdit(field) {
            document.getElementById(field + 'Display').style.display = 'block';
            document.getElementById(field + 'EditBtn').style.display = 'inline-block';
            document.getElementById(field + 'Form').style.display = 'none';
            document.getElementById(field + 'Error').style.display = 'none';
            
            if (field === 'email') {
                document.getElementById('emailInput').value = '<%= users != null && users.getEmail() != null ? users.getEmail() : ""%>';
            } else if (field === 'fullName') {
                document.getElementById('fullNameInput').value = '<%= patient != null && patient.getFullName() != null ? patient.getFullName() : ""%>';
            } else if (field === 'phone') {
                document.getElementById('phoneInput').value = '<%= patient != null && patient.getPhone() != null ? patient.getPhone() : ""%>';
            } else if (field === 'dob') {
                document.getElementById('dobInput').value = '<%= patient != null && patient.getDateOfBirth() != null ? new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth()) : ""%>';
            } else if (field === 'gender') {
                document.getElementById('genderInput').value = '<%= patient != null && patient.getGender() != null ? patient.getGender() : ""%>';
            }
        }

        function cancelProfilePicture() {
            const profilePictureInput = document.getElementById('profilePictureInput');
            const profilePicturePreview = document.getElementById('profilePicturePreview');
            const profilePictureError = document.getElementById('profilePictureError');
            profilePictureInput.value = '';
            profilePicturePreview.style.display = 'none';
            profilePictureError.style.display = 'none';
        }

        function cancelNewPatient() {
            const form = document.getElementById('newPatientForm');
            const newProfilePictureInput = document.getElementById('newProfilePictureInput');
            const newProfilePicturePreview = document.getElementById('newProfilePicturePreview');
            const newProfilePictureError = document.getElementById('newProfilePictureError');
            form.reset();
            newProfilePicturePreview.style.display = 'none';
            newProfilePictureError.style.display = 'none';
        }

        function showPasswordForm() {
            document.getElementById('passwordForm').style.display = 'block';
        }

        function hidePasswordForm() {
            document.getElementById('passwordForm').style.display = 'none';
            document.getElementById('passwordForm').reset();
            document.querySelector('#passwordForm .error-message').textContent = '';
        }

        // Profile Picture Preview and Validation (Existing Patient)
        document.getElementById('profilePictureInput')?.addEventListener('change', function (event) {
            const file = event.target.files[0];
            const profilePictureError = document.getElementById('profilePictureError');
            const profilePicturePreview = document.getElementById('profilePicturePreview');
            
            profilePictureError.style.display = 'none';
            profilePicturePreview.style.display = 'none';

            if (file) {
                const validImageTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                if (!validImageTypes.includes(file.type)) {
                    profilePictureError.style.display = 'block';
                    event.target.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    profilePicturePreview.src = e.target.result;
                    profilePicturePreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });

        // Profile Picture Preview and Validation (New Patient)
        document.getElementById('newProfilePictureInput')?.addEventListener('change', function (event) {
            const file = event.target.files[0];
            const profilePictureError = document.getElementById('newProfilePictureError');
            const profilePicturePreview = document.getElementById('newProfilePicturePreview');
            
            profilePictureError.style.display = 'none';
            profilePicturePreview.style.display = 'none';

            if (file) {
                const validImageTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                if (!validImageTypes.includes(file.type)) {
                    profilePictureError.style.display = 'block';
                    event.target.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    profilePicturePreview.src = e.target.result;
                    profilePicturePreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });

        // Form validation
        document.getElementById('emailForm')?.addEventListener('submit', function (event) {
            const emailInput = document.getElementById('emailInput').value.trim();
            const emailError = document.getElementById('emailError');
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!emailInput || !emailPattern.test(emailInput)) {
                emailError.style.display = 'block';
                event.preventDefault();
                return false;
            } else {
                emailError.style.display = 'none';
            }
        });

        document.getElementById('passwordForm')?.addEventListener('submit', function (event) {
            event.preventDefault();
            const oldPassword = this.querySelector('[name="oldPassword"]').value;
            const newPassword = this.querySelector('[name="newPassword"]').value;
            const confirmPassword = this.querySelector('[name="confirmPassword"]').value;
            const errorDiv = this.querySelector('.error-message');

            errorDiv.textContent = '';
            if (!oldPassword || !newPassword || !confirmPassword) {
                errorDiv.textContent = 'Vui lòng điền đầy đủ thông tin';
                return;
            }
            if (newPassword !== confirmPassword) {
                errorDiv.textContent = 'Mật khẩu mới và xác nhận mật khẩu không khớp';
                return;
            }
            this.submit();
        });

        document.getElementById('fullNameForm')?.addEventListener('submit', function (event) {
            const fullNameInput = document.getElementById('fullNameInput').value.trim();
            const fullNameError = document.getElementById('fullNameError');
            if (!fullNameInput || fullNameInput.length < 2) {
                fullNameError.style.display = 'block';
                event.preventDefault();
                return false;
            } else {
                fullNameError.style.display = 'none';
            }
        });

        document.getElementById('phoneForm')?.addEventListener('submit', function (event) {
            const phoneInput = document.getElementById('phoneInput').value.trim();
            const phoneError = document.getElementById('phoneError');
            const phonePattern = /^[0-9]{10,11}$/;
            if (!phoneInput || !phonePattern.test(phoneInput)) {
                phoneError.style.display = 'block';
                event.preventDefault();
                return false;
            } else {
                phoneError.style.display = 'none';
            }
        });

        document.getElementById('dobForm')?.addEventListener('submit', function (event) {
            const dobInput = document.getElementById('dobInput').value;
            const dobError = document.getElementById('dobError');
            if (!dobInput) {
                dobError.style.display = 'block';
                event.preventDefault();
                return false;
            } else {
                dobError.style.display = 'none';
            }
        });

        document.getElementById('genderForm')?.addEventListener('submit', function (event) {
            const genderInput = document.getElementById('genderInput').value;
            const genderError = document.getElementById('genderError');
            if (!genderInput) {
                genderError.style.display = 'block';
                event.preventDefault();
                return false;
            } else {
                genderError.style.display = 'none';
            }
        });

        document.getElementById('newPatientForm')?.addEventListener('submit', function (event) {
            const fullNameInput = this.querySelector('[name="fullName"]').value.trim();
            const phoneInput = this.querySelector('[name="phone"]').value.trim();
            const dobInput = this.querySelector('[name="dateOfBirth"]').value;
            const genderInput = this.querySelector('[name="gender"]').value;
            const profilePictureInput = this.querySelector('[name="profilePicture"]').files[0];
            
            const fullNameError = document.getElementById('newFullNameError');
            const phoneError = document.getElementById('newPhoneError');
            const dobError = document.getElementById('newDobError');
            const genderError = document.getElementById('newGenderError');
            const profilePictureError = document.getElementById('newProfilePictureError');
            
            let hasError = false;

            if (!fullNameInput || fullNameInput.length < 2) {
                fullNameError.style.display = 'block';
                hasError = true;
            } else {
                fullNameError.style.display = 'none';
            }

            const phonePattern = /^[0-9]{10,11}$/;
            if (!phoneInput || !phonePattern.test(phoneInput)) {
                phoneError.style.display = 'block';
                hasError = true;
            } else {
                phoneError.style.display = 'none';
            }

            if (!dobInput) {
                dobError.style.display = 'block';
                hasError = true;
            } else {
                dobError.style.display = 'none';
            }

            if (!genderInput) {
                genderError.style.display = 'block';
                hasError = true;
            } else {
                genderError.style.display = 'none';
            }

            if (profilePictureInput) {
                const validImageTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                if (!validImageTypes.includes(profilePictureInput.type)) {
                    profilePictureError.style.display = 'block';
                    hasError = true;
                } else {
                    profilePictureError.style.display = 'none';
                }
            }

            if (hasError) {
                event.preventDefault();
                return false;
            }
        });

        window.addEventListener('load', function () {
            const successMsg = document.querySelector('.server-success');
            const errorMsg = document.querySelector('.server-error');
            if (successMsg) {
                setTimeout(() => {
                    successMsg.style.display = 'none';
                }, 5000);
            }
            if (errorMsg) {
                setTimeout(() => {
                    errorMsg.style.display = 'none';
                }, 5000);
            }
        });
    </script>
</body>
</html>
```