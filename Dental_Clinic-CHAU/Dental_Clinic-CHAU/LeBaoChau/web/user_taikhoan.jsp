<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="Model.User"%>
<%@page import="Model.Patients"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>

<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebars.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Thông Tin Cá Nhân</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                background: #f8f9fb;
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
            }

            .dashboard {
                padding-left: 270px;
                padding-top: 15px;
                display: grid;
                gap: 20px;
                padding-right: 10px;
                padding-bottom: 50px;
                box-sizing: border-box;
                min-height: 100vh;
                justify-content: center;
            }

            .profile-card {
                background: #ffffff;
                border: 1px solid #ddd;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                padding: 25px;
                width: 100%;
                max-width: 600px;
                transition: box-shadow 0.3s ease;
            }

            .profile-card:hover {
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            }

            .dashboard h2 {
                color: #00BFFF;
                font-weight: 600;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #00BFFF;
                text-align: center;
            }

            .dashboard p {
                font-size: 16px;
                color: #333;
                margin: 0;
                padding: 12px 0;
                display: flex;
                align-items: center;
                gap: 10px;
                border-bottom: 1px solid #eee;
            }

            .dashboard strong {
                color: #333;
                font-weight: 600;
                min-width: 120px;
            }

            .edit-btn {
                background: none;
                border: 1px solid #007bff;
                color: #007bff;
                padding: 5px 12px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 12px;
                transition: all 0.3s ease;
            }

            .edit-btn:hover {
                background: #007bff;
                color: #ffffff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            }

            .password-container {
                position: relative;
                display: inline-block;
                width: 100%;
                max-width: 300px;
            }

            .password-display {
                background: #f8f9fa;
                border: 1px solid #ced4da;
                border-radius: 5px;
                padding: 8px 30px 8px 8px;
                font-size: 16px;
                color: #333;
                display: inline-block;
                width: 100%;
                box-sizing: border-box;
            }

            .toggle-password {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #007bff;
                cursor: pointer;
                font-size: 14px;
                transition: color 0.3s ease;
            }

            .toggle-password:hover {
                color: #0056b3;
            }

            .editable-field {
                background: #f8f9fa;
                border: 1px solid #ced4da;
                border-radius: 5px;
                color: #333;
                padding: 8px 30px 8px 8px;
                font-size: 16px;
                width: 100%;
                max-width: 300px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                box-sizing: border-box;
            }

            .editable-field:focus {
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
                outline: none;
            }

            .save-btn {
                background: #007bff;
                border: none;
                border-radius: 5px;
                padding: 8px 15px;
                color: #ffffff;
                font-weight: 500;
                cursor: pointer;
                margin-top: 10px;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .save-btn:hover {
                background: #0056b3;
                transform: scale(1.05);
            }

            .cancel-btn {
                background: #6c757d;
                border: none;
                border-radius: 5px;
                padding: 8px 15px;
                color: #ffffff;
                font-weight: 500;
                cursor: pointer;
                margin-top: 10px;
                margin-left: 10px;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .cancel-btn:hover {
                background: #5a6268;
                transform: scale(1.05);
            }

            .error-message {
                color: #dc3545;
                font-size: 12px;
                margin-top: 5px;
                display: none;
            }

            .server-error {
                color: #dc3545;
                font-size: 14px;
                text-align: center;
                margin-bottom: 10px;
            }

            .field-row {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }

            .field-content {
                flex: 1;
                min-width: 200px;
            }

            @media (max-width: 768px) {
                .dashboard {
                    padding-left: 0;
                    width: 100%;
                    padding: 15px;
                }

                .sidebar {
                    width: 200px;
                    transform: translateX(-100%);
                    transition: transform 0.3s ease;
                }

                .sidebar.active {
                    transform: translateX(0);
                }

                .profile-card {
                    max-width: 100%;
                }

                .editable-field, .password-container {
                    max-width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard">
            <div class="profile-card">
                <h2>Thông Tin Cá Nhân</h2>
                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                <div class="server-error"><%= error %></div>
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
                                <input type="email" name="value" class="editable-field" id="emailInput" value="<%= users.getEmail() != null ? users.getEmail() : "" %>" required>
                                <div class="error-message" id="emailError">Vui lòng nhập email hợp lệ.</div>
                                <button type="submit" class="save-btn">Lưu</button>
                                <button type="button" class="cancel-btn" onclick="cancelEdit('email')">Hủy</button>
                            </form>
                        </div>
                        <button class="edit-btn" id="emailEditBtn" onclick="editField('email')">Sửa</button>
                    </div>
                </p>

                <p>
                    <strong>Mật khẩu:</strong>
                    <div class="field-row">
                        <div class="field-content">
                            <div id="passwordDisplay" class="password-container">
                                <span class="password-display"><%= passwordMask %></span>
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
                </p>
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
                <p><strong>Ngày sinh:</strong> <%= formattedDob %></p>
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
                    passwordDisplay.textContent = '<%= users != null && users.getPasswordHash() != null ? "•".repeat(users.getPasswordHash().length()) : "--" %>';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                    isPasswordVisible = false;
                } else {
                    passwordDisplay.textContent = '<%= users != null && users.getPasswordHash() != null ? users.getPasswordHash() : "--" %>';
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
                    document.getElementById('emailInput').value = '<%= users != null && users.getEmail() != null ? users.getEmail() : "" %>';
                } else if (field === 'password') {
                    document.getElementById('passwordInput').value = '';
                    isPasswordInputVisible = false;
                    document.querySelector('#passwordForm .toggle-password i').classList.remove('fa-eye-slash');
                    document.querySelector('#passwordForm .toggle-password i').classList.add('fa-eye');
                }
            }

            document.getElementById('emailForm').addEventListener('submit', function(event) {
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

            document.getElementById('passwordForm').addEventListener('submit', function(event) {
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
            document.getElementById('emailInput').addEventListener('input', function() {
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
            document.getElementById('passwordInput').addEventListener('input', function() {
                const passwordInput = this.value;
                const passwordError = document.getElementById('passwordError');
                const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

                if (passwordInput && !passwordPattern.test(passwordInput)) {
                    passwordError.style.display = 'block';
                } else {
                    passwordError.style.display = 'none';
                }
            });

            window.addEventListener('load', function() {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('update') === 'success') {
                    window.location.href = 'user_taikhoan.jsp';
                }
            });
        </script>
    </body>
</html>