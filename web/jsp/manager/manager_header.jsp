<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .header {
                position: fixed;
                top: 0;
                left: 250px;
                right: 0;
                height: 60px;
                background-color: #fff;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 20px;
                z-index: 999;
            }

            .header-left {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .search-box {
                position: relative;
            }

            .search-box input {
                padding: 8px 15px;
                padding-left: 35px;
                border: 1px solid #ddd;
                border-radius: 20px;
                width: 300px;
                font-size: 14px;
            }

            .search-box i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #666;
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .notification {
                position: relative;
                cursor: pointer;
            }

            .notification i {
                font-size: 20px;
                color: #666;
            }

            .notification-badge {
                position: absolute;
                top: -5px;
                right: -5px;
                background-color: #ff4444;
                color: white;
                border-radius: 50%;
                width: 18px;
                height: 18px;
                font-size: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .user-profile {
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
            }

            .user-avatar {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                object-fit: cover;
            }

            .user-name {
                font-size: 14px;
                color: #333;
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                right: 0;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 10px 0;
                display: none;
                min-width: 150px;
            }

            .dropdown-menu a {
                display: block;
                padding: 8px 15px;
                color: #333;
                text-decoration: none;
                transition: background-color 0.2s;
            }

            .dropdown-menu a:hover {
                background-color: #f5f5f5;
            }

            .user-profile:hover .dropdown-menu {
                display: block;
            }
        </style>
    </head>

    <body>
        <div class="header">
            <div class="header-left">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Tìm kiếm...">
                </div>
            </div>
            <div class="header-right">
                <div class="notification">
                    <i class="fas fa-bell"></i>
                    <span class="notification-badge">3</span>
                </div>
                <div class="user-profile">
                    <img src="manager.jpg" alt="User Avatar" class="user-avatar">
                    <span class="user-name">Manager Name</span>
                    <div class="dropdown-menu">
                        <a href="manager_trangcanhan.jsp">Trang cá nhân</a>
                        <a href="manager_caidat.jsp">Cài đặt</a>
                        <a href="${pageContext.request.contextPath}/logout.jsp">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>