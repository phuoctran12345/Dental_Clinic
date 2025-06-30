<%@page import="model.Patients" %>
<%@page import="model.User" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Header đơn giản</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', sans-serif;
            }

            body {
                background-color: #fffff;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 40px;
                background-color: #f8f9fb;
            }

            .search-bar {
                flex: 1;
                margin-right: 30px;
                position: relative;
                padding-left: 250px;
            }

            .search-bar input {
                width: 100%;
                padding: 10px 40px 10px 15px;
                border: 1px solid #ccc;
                border-radius: 20px;
                font-size: 16px;
            }

            .search-bar i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #aaa;
            }

            .auth-buttons button {
                margin-left: 10px;
                padding: 8px 18px;
                border: none;
                border-radius: 20px;
                background-color: #4E80EE;
                color: white;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.3s;
            }

            .auth-buttons button:hover {
                background-color: #0d6efd;
            }

            #menu-toggle:checked ~ .header .search-bar {
                width: 300px;
                margin-left: -137px;
                transition: 0.27s ease;
            }

            .search-bar {
                transition: 0.3s ease;
            }
        </style>
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <div class="header">
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm...">
                <i class="fa fa-search"></i>
            </div>

            <div class="auth-buttons">
                <% User user = (User) session.getAttribute("user");
                    if (user != null) {%>
                <div class="user-avatar">
                    <form id="uploadForm" action="AvatarServlet" method="post" enctype="multipart/form-data" style="display: none;">
                        <input type="file" id="avatarInput" name="avatar" accept="image/*" style="display: none;" />
                        <input type="hidden" name="userId" value="<%= user.getId()%>" />
                    </form>
                    <% Patients patient = (Patients) session.getAttribute("patient");
                            if (patient != null) {%>
                    <span>Welcome, <%= patient.getFullName()%></span>
                    <% } else { %>
                    <span>Welcome, guest</span>
                    <% } %>
                    <% if (patient != null) {%>
                    <img id="avatarImg" src="<%= patient.getAvatar()%>" alt="Avatar" />
                    <% } else { %>
                    <img id="avatarImg" src="/img/default-avatar.jpg" alt="Avatar" />
                    <% } %>
                    <button onclick="location.href = 'LogoutServlet'">Đăng xuất</button>
                </div>
                <% } else { %>
                <button onclick="location.href = '/RoleStaff/login.jsp'">Đăng nhập</button>
                <button onclick="location.href = '/RoleStaff/signup.jsp'">Đăng ký</button>
                <% }%>
            </div>
        </div>

        <script>
            const avatarImg = document.getElementById('avatarImg');
            const avatarInput = document.getElementById('avatarInput');
            const uploadForm = document.getElementById('uploadForm');

            if (avatarImg) {
                avatarImg.addEventListener('click', () => avatarInput.click());
            }

            if (avatarInput) {
                avatarInput.addEventListener('change', () => {
                    if (avatarInput.files.length > 0) {
                        uploadForm.submit();
                    }
                });
            }
        </script>
    </body>
</html> 