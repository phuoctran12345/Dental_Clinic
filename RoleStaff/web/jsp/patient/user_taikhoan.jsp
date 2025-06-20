<%@page import="java.util.Date" %>
    <%@page import="java.text.SimpleDateFormat" %>
        <%@page import="model.User" %>
            <%@page import="model.Patients" %>
                <%@ page contentType="text/html; charset=UTF-8" %>
                    <%@ include file="../patient/user_header.jsp" %>
                        <%@ include file="../patient/user_menu.jsp" %>

                            <!DOCTYPE html>
                            <html>

                            <head>
                                <title>Thông Tin Cá Nhân</title>
                                <link
                                    href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap"
                                    rel="stylesheet">
                                <link rel="stylesheet"
                                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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

                                        <!-- Hiển thị thông báo lỗi -->
                                        <% String error=(String) request.getAttribute("error"); if (error==null) {
                                            error=request.getParameter("error"); } if (error !=null) { %>
                                            <div class="server-error">
                                                <%= error %>
                                            </div>
                                            <% } %>

                                                <!-- Hiển thị thông báo thành công -->
                                                <% String success=(String) request.getAttribute("success"); if
                                                    (success==null) { success=request.getParameter("success"); } if
                                                    (success !=null) { %>
                                                    <div class="server-success">
                                                        <%= success %>
                                                    </div>
                                                    <% } %>

                                                        <% Object userObj=session.getAttribute("user"); User users=null;
                                                            if (userObj instanceof User) { users=(User) userObj; }
                                                            Object patientObj=session.getAttribute("patient"); Patients
                                                            patient=null; if (patientObj instanceof Patients) {
                                                            patient=(Patients) patientObj; } if (users==null &&
                                                            patient==null) { %>
                                                            <p>Không tìm thấy thông tin người dùng hoặc bệnh nhân.</p>
                                                            <% } else { if (users !=null) { String
                                                                passwordMask=users.getPasswordHash() !=null ? "•"
                                                                .repeat(users.getPasswordHash().length()) : "--" ; %>

                                                                <!-- Email Field -->
                                                                <p>
                                                                    <strong>Email:</strong>
                                                                <div class="field-row">
                                                                    <div class="field-content">
                                                                        <span id="emailDisplay">
                                                                            <%= users.getEmail() !=null ?
                                                                                users.getEmail() : "--" %>
                                                                        </span>
                                                                        <form id="emailForm"
                                                                            action="../../UpdateUserServlet"
                                                                            method="post" style="display: none;">
                                                                            <input type="hidden" name="field"
                                                                                value="email">
                                                                            <input type="email" name="value"
                                                                                class="editable-field" id="emailInput"
                                                                                value="<%= users.getEmail() != null ? users.getEmail() : "" %>"
                                                                                required>
                                                                            <div class="error-message" id="emailError">
                                                                                Vui lòng nhập email hợp lệ.</div>
                                                                            <button type="submit"
                                                                                class="save-btn">Lưu</button>
                                                                            <button type="button" class="cancel-btn"
                                                                                onclick="cancelEdit('email')">Hủy</button>
                                                                        </form>
                                                                    </div>
                                                                    <button class="edit-btn" id="emailEditBtn"
                                                                        onclick="editField('email')">Sửa</button>
                                                                </div>
                                                                </p>

                                                                <!-- Password Field -->
                                                                <p>
                                                                    <strong>Mật khẩu:</strong>
                                                                <div class="field-row">
                                                                    <div class="field-content">
                                                                        <div id="passwordDisplay"
                                                                            class="password-container">
                                                                            <span class="password-display">
                                                                                <%= passwordMask %>
                                                                            </span>
                                                                            <button class="toggle-password"
                                                                                onclick="togglePassword()"
                                                                                title="Hiển thị/Ẩn mật khẩu">
                                                                                <i class="fas fa-eye"></i>
                                                                            </button>
                                                                        </div>
                                                                        <form id="passwordForm"
                                                                            action="${pageContext.request.contextPath}/UpdateUserServlet"
                                                                            method="post" style="display: none;">
                                                                            <input type="hidden" name="type"
                                                                                value="password">

                                                                            <!-- Mật khẩu cũ -->
                                                                            <div style="margin-bottom: 15px;">
                                                                                <label
                                                                                    style="display: block; margin-bottom: 5px;">Mật
                                                                                    khẩu cũ:</label>
                                                                                <input type="password"
                                                                                    name="oldPassword"
                                                                                    class="editable-field" required>
                                                                            </div>

                                                                            <!-- Mật khẩu mới -->
                                                                            <div style="margin-bottom: 15px;">
                                                                                <label
                                                                                    style="display: block; margin-bottom: 5px;">Mật
                                                                                    khẩu mới:</label>
                                                                                <input type="password"
                                                                                    name="newPassword"
                                                                                    class="editable-field" required>
                                                                            </div>

                                                                            <!-- Xác nhận mật khẩu mới -->
                                                                            <div style="margin-bottom: 15px;">
                                                                                <label
                                                                                    style="display: block; margin-bottom: 5px;">Xác
                                                                                    nhận mật khẩu mới:</label>
                                                                                <input type="password"
                                                                                    name="confirmPassword"
                                                                                    class="editable-field" required>
                                                                            </div>

                                                                            <!-- Thông báo lỗi -->
                                                                            <div class="error-message"
                                                                                style="color: red; margin-bottom: 10px;">
                                                                            </div>

                                                                            <!-- Nút submit và hủy -->
                                                                            <div>
                                                                                <button type="submit"
                                                                                    class="save-btn">Lưu thay
                                                                                    đổi</button>
                                                                                <button type="button" class="cancel-btn"
                                                                                    onclick="hidePasswordForm()">Hủy</button>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                    <button class="edit-btn" id="passwordEditBtn"
                                                                        onclick="showPasswordForm()">Sửa</button>
                                                                </div>
                                                                </p>

                                                                <% } if (patient !=null) { %>
                                                                    <p><strong>Họ tên:</strong>
                                                                        <%= patient.getFullName() !=null ?
                                                                            patient.getFullName() : "--" %>
                                                                    </p>
                                                                    <p><strong>Điện thoại:</strong>
                                                                        <%= patient.getPhone() !=null ?
                                                                            patient.getPhone() : "--" %>
                                                                    </p>
                                                                    <% Date dob=patient.getDateOfBirth(); String
                                                                        formattedDob="--" ; if (dob !=null) {
                                                                        SimpleDateFormat sdf=new
                                                                        SimpleDateFormat("dd-MM-yyyy");
                                                                        formattedDob=sdf.format(dob); } %>
                                                                        <p><strong>Ngày sinh:</strong>
                                                                            <%= formattedDob %>
                                                                        </p>
                                                                        <p><strong>Giới tính:</strong>
                                                                            <%= patient.getGender() !=null ?
                                                                                patient.getGender() : "--" %>
                                                                        </p>
                                                                        <% } else if (users !=null) { %>
                                                                            <p>Không tìm thấy thông tin bệnh nhân.</p>
                                                                            <% } } %>
                                    </div>
                                </div>

                                <script>
                                    let isPasswordVisible = false;
                                    let isPasswordInputVisible = false;
                                    let isOldPasswordInputVisible = false;
                                    let isConfirmPasswordInputVisible = false;

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

                                    function toggleOldPasswordInput() {
                                        const oldPasswordInput = document.getElementById('oldPasswordInput');
                                        const toggleIcon = oldPasswordInput.nextElementSibling.querySelector('i');
                                        if (isOldPasswordInputVisible) {
                                            oldPasswordInput.type = 'password';
                                            toggleIcon.classList.remove('fa-eye-slash');
                                            toggleIcon.classList.add('fa-eye');
                                            isOldPasswordInputVisible = false;
                                        } else {
                                            oldPasswordInput.type = 'text';
                                            toggleIcon.classList.remove('fa-eye');
                                            toggleIcon.classList.add('fa-eye-slash');
                                            isOldPasswordInputVisible = true;
                                        }
                                    }

                                    function togglePasswordInput() {
                                        const passwordInput = document.getElementById('passwordInput');
                                        const toggleIcon = passwordInput.nextElementSibling.querySelector('i');
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

                                    function toggleConfirmPasswordInput() {
                                        const confirmPasswordInput = document.getElementById('confirmPasswordInput');
                                        const toggleIcon = confirmPasswordInput.nextElementSibling.querySelector('i');
                                        if (isConfirmPasswordInputVisible) {
                                            confirmPasswordInput.type = 'password';
                                            toggleIcon.classList.remove('fa-eye-slash');
                                            toggleIcon.classList.add('fa-eye');
                                            isConfirmPasswordInputVisible = false;
                                        } else {
                                            confirmPasswordInput.type = 'text';
                                            toggleIcon.classList.remove('fa-eye');
                                            toggleIcon.classList.add('fa-eye-slash');
                                            isConfirmPasswordInputVisible = true;
                                        }
                                    }

                                    function editField(field) {
                                        // Ẩn phần hiển thị và nút sửa
                                        document.getElementById(field + 'Display').style.display = 'none';
                                        document.getElementById(field + 'EditBtn').style.display = 'none';

                                        // Hiển thị form chỉnh sửa
                                        document.getElementById(field + 'Form').style.display = 'block';

                                        if (field === 'password') {
                                            document.getElementById('oldPasswordInput').value = '';
                                            document.getElementById('passwordInput').value = '';
                                            document.getElementById('confirmPasswordInput').value = '';

                                            // Reset tất cả toggle visibility
                                            isOldPasswordInputVisible = false;
                                            isPasswordInputVisible = false;
                                            isConfirmPasswordInputVisible = false;

                                            // Reset tất cả icon
                                            document.querySelectorAll('#passwordForm .toggle-password i').forEach(icon => {
                                                icon.classList.remove('fa-eye-slash');
                                                icon.classList.add('fa-eye');
                                            });

                                            // Focus vào trường mật khẩu cũ
                                            document.getElementById('oldPasswordInput').focus();
                                        } else {
                                            // Focus vào input field cho email
                                            document.getElementById(field + 'Input').focus();
                                        }
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
                                            document.getElementById('oldPasswordInput').value = '';
                                            document.getElementById('passwordInput').value = '';
                                            document.getElementById('confirmPasswordInput').value = '';

                                            // Reset tất cả toggle visibility
                                            isOldPasswordInputVisible = false;
                                            isPasswordInputVisible = false;
                                            isConfirmPasswordInputVisible = false;

                                            // Reset tất cả icon
                                            document.querySelectorAll('#passwordForm .toggle-password i').forEach(icon => {
                                                icon.classList.remove('fa-eye-slash');
                                                icon.classList.add('fa-eye');
                                            });
                                        }
                                    }

                                    // Form validation
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
                                        event.preventDefault();

                                        const oldPassword = this.querySelector('[name="oldPassword"]').value;
                                        const newPassword = this.querySelector('[name="newPassword"]').value;
                                        const confirmPassword = this.querySelector('[name="confirmPassword"]').value;
                                        const errorDiv = this.querySelector('.error-message');

                                        // Reset error message
                                        errorDiv.textContent = '';

                                        // Kiểm tra các trường không được rỗng
                                        if (!oldPassword || !newPassword || !confirmPassword) {
                                            errorDiv.textContent = 'Vui lòng điền đầy đủ thông tin';
                                            return;
                                        }

                                        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
                                        if (newPassword !== confirmPassword) {
                                            errorDiv.textContent = 'Mật khẩu mới và xác nhận mật khẩu không khớp';
                                            return;
                                        }

                                        // Nếu validation pass, submit form
                                        this.submit();
                                    });

                                    // Real-time validation cho email
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

                                    // Real-time validation cho mật khẩu
                                    document.getElementById('passwordInput').addEventListener('input', function () {
                                        validatePasswordRealtime();
                                    });

                                    document.getElementById('confirmPasswordInput').addEventListener('input', function () {
                                        validatePasswordRealtime();
                                    });

                                    function validatePasswordRealtime() {
                                        const passwordInput = document.getElementById('passwordInput').value;
                                        const confirmPasswordInput = document.getElementById('confirmPasswordInput').value;
                                        const passwordError = document.querySelector('#passwordForm .error-message');
                                        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

                                        if (passwordInput && !passwordPattern.test(passwordInput)) {
                                            passwordError.textContent = 'Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%^&*).';
                                            passwordError.style.display = 'block';
                                        } else if (confirmPasswordInput && passwordInput !== confirmPasswordInput) {
                                            passwordError.textContent = 'Xác nhận mật khẩu không khớp.';
                                            passwordError.style.display = 'block';
                                        } else {
                                            passwordError.style.display = 'none';
                                        }
                                    }

                                    // Auto-hide success/error messages after 5 seconds
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

                                    // Hiển thị form đổi mật khẩu
                                    function showPasswordForm() {
                                        document.getElementById('passwordForm').style.display = 'block';
                                    }

                                    // Ẩn form đổi mật khẩu
                                    function hidePasswordForm() {
                                        document.getElementById('passwordForm').style.display = 'none';
                                        document.getElementById('passwordForm').reset();
                                        document.querySelector('#passwordForm .error-message').textContent = '';
                                    }
                                </script>
                            </body>

                            </html>