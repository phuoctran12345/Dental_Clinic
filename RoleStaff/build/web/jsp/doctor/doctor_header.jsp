<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Header</title>
        <style>
            .header {
                background-color: white;
                padding: 15px 30px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                position: fixed;
                top: 0;
                right: 0;
                left: 260px;
                z-index: 1;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header-left {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .search-box {
                position: relative;
            }

            .search-box input {
                padding: 8px 15px;
                padding-right: 40px;
                border: 1px solid #ddd;
                border-radius: 20px;
                width: 300px;
                font-size: 14px;
            }

            .search-box i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #666;
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

            .user-profile img {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
            }

            .user-info {
                display: flex;
                flex-direction: column;
            }

            .user-name {
                font-weight: 500;
                color: #333;
            }

            .user-role {
                font-size: 12px;
                color: #666;
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
        <header class="header">
            <div class="header-left">
                <div class="search-box">
                    <input type="text" placeholder="Tìm kiếm...">
                    <i class="fa-solid fa-search"></i>
                </div>
            </div>
            <div class="header-right">
                <div class="notification">
                    <i class="fa-solid fa-bell"></i>
                    <span class="notification-badge">3</span>
                </div>
                <div class="user-profile">
                    <img src="img/avatar.jpg" alt="User Avatar">
                    <div class="user-info">
                        <span class="user-name">Dr. Nguyễn Văn A</span>
                        <span class="user-role">Bác sĩ</span>
                    </div>
                </div>
            </div>
        </header>
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