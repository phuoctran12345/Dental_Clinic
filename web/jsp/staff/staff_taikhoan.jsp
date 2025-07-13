<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Staff" %>
<%@ page import="model.User" %>
<%@ include file="/jsp/staff/staff_header.jsp" %>
<%@ include file="/jsp/staff/staff_menu.jsp" %>
<%
    Staff staff = (Staff) request.getAttribute("staff");
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin nhân viên</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
        }
        .container {
            max-width: 750px;
            background: #fff;
            margin: 30px auto;
            padding: 35px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
        }
        .message {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        .error { background: #fce4e4; color: #c0392b; }
        .success { background: #e1f5e0; color: #27ae60; }

        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            color: #34495e;
        }
        .form-group input, select {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .form-submit {
            text-align: center;
            margin-top: 20px;
        }
        .form-submit button {
            padding: 10px 28px;
            font-size: 15px;
            background: #2980b9;
            color: white;
            border: none;
            border-radius: 5px;
            transition: background 0.3s ease;
        }
        .form-submit button:hover {
            background: #2471a3;
        }
        .readonly-info {
            padding: 10px;
            border-radius: 5px;
            background: #f8f9fa;
            border: 1px solid #dcdde1;
            color: #333;
        }

        .avatar-section {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }
        .avatar-section img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #ccc;
            cursor: pointer;
        }
        .avatar-section input[type="file"] {
            display: none;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Thông Tin Tài Khoản Nhân Viên</h2>

    <% if (request.getAttribute("error") != null) { %>
        <div class="message error"><%= request.getAttribute("error") %></div>
    <% } else if (request.getAttribute("success") != null) { %>
        <div class="message success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if (staff != null && user != null) { %>
        <!-- Avatar -->
        <div class="avatar-section">
            <form id="uploadForm" action="UpdateStaffAvatarServlet" method="post" enctype="multipart/form-data">
                <input type="file" id="avatarInput" name="avatar" accept="image/*" />
                <input type="hidden" name="userId" value="<%= user.getId() %>" />
            </form>
            <img id="avatarImg" src="<%= staff.getAvatar() %>" alt="Avatar" />
            <span>Bấm vào ảnh để đổi</span>
        </div>

        <!-- Email -->
        <form method="post" action="<%=request.getContextPath()%>/StaffUpdateServlet">
            <input type="hidden" name="type" value="email" />
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="value" value="<%= user.getEmail() %>" required />
            </div>
            <div class="form-submit">
                <button type="submit">Cập nhật email</button>
            </div>
        </form>

        <hr/>

        <!-- Password -->
        <form method="post" action="<%=request.getContextPath()%>/StaffUpdateServlet">
            <input type="hidden" name="type" value="password" />
            <div class="form-group">
                <label>Mật khẩu cũ:</label>
                <input type="password" name="oldPassword" required />
            </div>
            <div class="form-group">
                <label>Mật khẩu mới:</label>
                <input type="password" name="newPassword" required />
            </div>
            <div class="form-group">
                <label>Nhập lại mật khẩu mới:</label>
                <input type="password" name="confirmPassword" required />
            </div>
            <div class="form-submit">
                <button type="submit">Đổi mật khẩu</button>
            </div>
        </form>

        <hr/>

        <!-- Staff Info -->
        <form method="post" action="<%=request.getContextPath()%>/StaffUpdateServlet">
            <input type="hidden" name="type" value="update_staff_info" />
            <div class="form-group">
                <label>Họ và tên:</label>
                <input type="text" name="fullName" value="<%= staff.getFullName() %>" required />
            </div>
            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="phone" value="<%= staff.getPhone() %>" required />
            </div>
            <div class="form-group">
                <label>Ngày sinh:</label>
                <input type="date" name="dateOfBirth" value="<%= staff.getDateOfBirth() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(staff.getDateOfBirth()) : "" %>" required />
            </div>
            <div class="form-group">
                <label>Giới tính:</label>
                <select name="gender" required>
                    <option value="male" <%= "male".equalsIgnoreCase(staff.getGender()) ? "selected" : "" %>>Nam</option>
                    <option value="female" <%= "female".equalsIgnoreCase(staff.getGender()) ? "selected" : "" %>>Nữ</option>
                    <option value="other" <%= "other".equalsIgnoreCase(staff.getGender()) ? "selected" : "" %>>Khác</option>
                </select>
            </div>
            <div class="form-group">
                <label>Địa chỉ:</label>
                <input type="text" name="address" value="<%= staff.getAddress() %>" required />
            </div>
            <div class="form-submit">
                <button type="submit">Lưu thay đổi</button>
            </div>
        </form>

        <hr/>

        <!-- Readonly -->
        <div class="form-group">
            <label>Chức vụ:</label>
            <div class="readonly-info"><%= staff.getPosition() != null ? staff.getPosition() : "Chưa cập nhật" %></div>
        </div>
        <div class="form-group">
            <label>Loại hợp đồng:</label>
            <div class="readonly-info">
                <%
                    String empType = staff.getEmploymentType();
                    if ("fulltime".equals(empType)) out.print("Toàn thời gian");
                    else if ("parttime".equals(empType)) out.print("Bán thời gian");
                    else out.print("Chưa cập nhật");
                %>
            </div>
        </div>
        <div class="form-group">
            <label>Ngày tạo:</label>
            <div class="readonly-info">
                <%= staff.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(staff.getCreatedAt()) : "Chưa cập nhật" %>
            </div>
        </div>

    <% } else { %>
        <div class="message error">Không tìm thấy thông tin nhân viên.</div>
    <% } %>
</div>
</body>
</html>

<script>
    const avatarImg = document.getElementById('avatarImg');
    const avatarInput = document.getElementById('avatarInput');
    const uploadForm = document.getElementById('uploadForm');

    avatarImg.addEventListener('click', () => avatarInput.click());

    avatarInput.addEventListener('change', () => {
        if (avatarInput.files.length > 0) {
            uploadForm.submit();
        }
    });
</script>
