<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Patients" %>

<%@ include file="/jsp/patient/user_header.jsp" %>
<%@ include file="/jsp/patient/user_menu.jsp" %>
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
                width: 900px;
                max-width: 1000px;
            }

            .dashboard h2 {
                color: #4E80EE;
                font-weight: 600;
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
            }
        </style>
    </head>
    <body>
        <div class="dashboard">
            <div class="profile-card">
                <h2>Thông Tin Cá Nhân</h2>
                <%                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                <div class="server-error"><%= error%></div>
                <%
                    }
                %>
                <%
                    Object userObj = session.getAttribute("user");
                    User users = null;
                    if (userObj instanceof User) {
                        users = (User) userObj;
                    }

                    Object patientObj = session.getAttribute("patient");
                    Patients patient = null;
                    if (patientObj instanceof Patients) {
                        patient = (Patients) patientObj;
                    }

                    if (users == null && patient == null) {
                %>
                <p>Không tìm thấy thông tin người dùng hoặc bệnh nhân.</p>
                <%
                } else {
                    if (users != null) {
                        String passwordMask = users.getPasswordHash() != null ? "•".repeat(users.getPasswordHash().length()) : "--";
                %>
                <p>
                    <strong>Email:</strong>
                <div class="field-row">
                    <div class="field-content">
                        <span id="emailDisplay"><%= users.getEmail() != null ? users.getEmail() : "--"%></span>
                        <form id="emailForm" action="UpdateUserServlet" method="post" style="display: none;">
                            <input type="hidden" name="field" value="email">
                            <input type="email" name="value" class="editable-field" id="emailInput" value="<%= users.getEmail() != null ? users.getEmail() : ""%>" required>
                            <div class="error-message" id="emailError">Vui lòng nhập email hợp lệ.</div>
                            <button type="submit" class="save-btn">Lưu</button>
                            <button type="button" class="cancel-btn" onclick="cancelEdit('email')">Hủy</button>
                        </form>
                    </div>
                    <button class="edit-btn" id="emailEditBtn" onclick="editField('email')">Sửa</button>
                </div>

                <p>
                    <strong>Mật khẩu:</strong>
                <div class="field-row">
                    <div class="field-content">
                        <div id="passwordDisplay" class="password-container">
                            <span class="password-display"><%= passwordMask%></span>
                            <button class="toggle-password" onclick="togglePassword()" title="Hiển thị/Ẩn mật khẩu">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <form id="passwordForm" action="UpdateUserServlet" method="post" style="display: none;">
                            <input type="hidden" name="field" value="password">
                            <div class="password-container">
                                <input type="password" name="value" class="editable-field" id="passwordInput" required>
                                <button type="button" class="toggle-password" onclick="togglePasswordInput()" title="Hiển thị/Ẩn mật khẩu">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="error-message" id="passwordError">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (e.g., !@#$%^&*).</div>
                            <button type="submit" class="save-btn">Lưu</button>
                            <button type="button" class="cancel-btn" onclick="cancelEdit('password')">Hủy</button>
                        </form>
                    </div>
                    <button class="edit-btn" id="passwordEditBtn" onclick="editField('password')">Sửa</button>
                </div>

                <%
                    }
                    if (patient != null) {
                %>
                <p><strong>Họ tên:</strong> <%= patient.getFullName() != null ? patient.getFullName() : "--"%></p>
                <p><strong>Điện thoại:</strong> <%= patient.getPhone() != null ? patient.getPhone() : "--"%></p>
                <%
                    Date dob = patient.getDateOfBirth();
                    String formattedDob = "--";
                    if (dob != null) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                        formattedDob = sdf.format(dob);
                    }
                %>
                <p><strong>Ngày sinh:</strong> <%= formattedDob%></p>
                <p><strong>Giới tính:</strong> <%= patient.getGender() != null ? patient.getGender() : "--"%></p>
                <%
                } else if (users != null) {
                %>
                <p>Không tìm thấy thông tin bệnh nhân.</p>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <script>
            let isPasswordVisible = false;
            let isPasswordInputVisible = false;

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

            function togglePasswordInput() {
                const passwordInput = document.getElementById('passwordInput');
                const toggleIcon = document.querySelector('#passwordForm .toggle-password i');
                if (isPasswordInputVisible) {
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                    isPasswordInputVisible = false;
                } else {
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                    isPasswordInputVisible = true;
                }
            }

            function editField(field) {
                // Ẩn phần hiển thị và nút sửa
                document.getElementById(field + 'Display').style.display = 'none';
                document.getElementById(field + 'EditBtn').style.display = 'none';

                // Hiển thị form chỉnh sửa
                document.getElementById(field + 'Form').style.display = 'block';

                if (field === 'password') {
                    document.getElementById('passwordInput').value = '';
                    isPasswordInputVisible = false;
                    document.querySelector('#passwordForm .toggle-password i').classList.remove('fa-eye-slash');
                    document.querySelector('#passwordForm .toggle-password i').classList.add('fa-eye');
                }

                // Focus vào input field
                document.getElementById(field + 'Input').focus();
            }

            function cancelEdit(field) {
                // Hiển thị lại phần hiển thị và nút sửa
                document.getElementById(field + 'Display').style.display = 'block';
                document.getElementById(field + 'EditBtn').style.display = 'inline-block';

                // Ẩn form chỉnh sửa
                document.getElementById(field + 'Form').style.display = 'none';

                // Reset error message
                document.getElementById(field + 'Error').style.display = 'none';

                // Reset input value to original
                if (field === 'email') {
                    document.getElementById('emailInput').value = '<%= users != null && users.getEmail() != null ? users.getEmail() : ""%>';
                } else if (field === 'password') {
                    document.getElementById('passwordInput').value = '';
                    isPasswordInputVisible = false;
                    document.querySelector('#passwordForm .toggle-password i').classList.remove('fa-eye-slash');
                    document.querySelector('#passwordForm .toggle-password i').classList.add('fa-eye');
                }
            }

            document.getElementById('emailForm').addEventListener('submit', function (event) {
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

            document.getElementById('passwordForm').addEventListener('submit', function (event) {
                const passwordInput = document.getElementById('passwordInput').value;
                const passwordError = document.getElementById('passwordError');
                const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

                if (!passwordPattern.test(passwordInput)) {
                    passwordError.style.display = 'block';
                    event.preventDefault();
                    return false;
                } else {
                    passwordError.style.display = 'none';
                }
            });

            // Validation real-time cho email
            document.getElementById('emailInput').addEventListener('input', function () {
                const emailInput = this.value.trim();
                const emailError = document.getElementById('emailError');
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (emailInput && !emailPattern.test(emailInput)) {
                    emailError.style.display = 'block';
                } else {
                    emailError.style.display = 'none';
                }
            });

            // Validation real-time cho password
            document.getElementById('passwordInput').addEventListener('input', function () {
                const passwordInput = this.value;
                const passwordError = document.getElementById('passwordError');
                const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

                if (passwordInput && !passwordPattern.test(passwordInput)) {
                    passwordError.style.display = 'block';
                } else {
                    passwordError.style.display = 'none';
                }
            });

            window.addEventListener('load', function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('update') === 'success') {
                    window.location.href = 'user_taikhoan.jsp';
                }
            });
        </script>
    </body>
</html>