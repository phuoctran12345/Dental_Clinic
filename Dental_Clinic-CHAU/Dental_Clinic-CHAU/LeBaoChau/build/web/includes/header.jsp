<%-- 
    Document   : header
    Created on : May 16, 2025, 3:26:29 PM
    Author     : Home
--%>

<%@page import="Model.Patients"%>
<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                background-color: #f4f4f4;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 30px;
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
                background-color: #00BFFF;
                color: white;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.3s;
            }

            .auth-buttons button:hover {
                background-color: #0095cc;
            }
            #menu-toggle:checked ~ .header .search-bar {
                width: 300px;
                margin-left: -137px;
                transition: 0.27s ease;
            }

            .search-bar {
                transition: 0.3s ease;
            }

            /* Added styles for initial-based avatar */
            .initial-avatar {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background-color: #00BFFF;
                color: white;
                display: flex;
                justify-content: center;
                align-items: center;
                font-weight: bold;
                font-size: 16px;
                text-transform: uppercase;
                cursor: pointer;
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
                <%
                    User user = (User) session.getAttribute("user");

                    if (user != null) {
                        Patients patient = (Patients) session.getAttribute("patient");
                        String initial = "G"; // Default to 'G' for guest
                        if (patient != null && patient.getFullName() != null && !patient.getFullName().isEmpty()) {
                            initial = patient.getFullName().substring(0, 1).toUpperCase();
                        }
                %>
                <div class="user-avatar" style="display: flex; align-items: center; gap: 10px;">
                    <form id="uploadForm" action="AvatarServlet" method="post" enctype="multipart/form-data" style="display: none;">
                        <input type="file" id="avatarInput" name="avatar" accept="image/*" style="display: none;" />
                        <input type="hidden" name="id" value="<%= user.getId()%>" />
                    </form>
                    <span>Welcome, <%= patient != null ? patient.getFullName() : "guest"%></span>
                    <div class="initial-avatar" id="avatarImg"><%= initial %></div>
                    <div>
                        <button onclick="location.href = 'LogoutServlet'">Đăng xuất</button>
                    </div>
                <%
                    } else {
                %>
                    <button onclick="location.href = 'login.jsp'">Đăng nhập</button>
                    <button onclick="location.href = 'signup.jsp'">Đăng ký</button>
                <%
                    }
                %>
                </div>
            </div>
        </div>
    </body>
</html>
<script>
    const avatarImg = document.getElementById('avatarImg');
    
    avatarImg.addEventListener('click', () => {
        window.location.href = 'user_taikhoan.jsp';
    });
</script>