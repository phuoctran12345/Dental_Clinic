<%-- Document : user_menu Created on : May 16, 2025, 11:32:55 AM Author : Home --%>

<!DOCTYPE html>
<html>
    <%@ page pageEncoding="UTF-8" %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap&subset=vietnamese"
              rel="stylesheet">

        <title>User Menu</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', sans-serif;

            }

            body {
                width: 100vw;
                height: 100vh;
                background-color: white;
            }

            .menu-toggle {
                position: fixed;
                top: 25px;
                left: 20px;
                font-size: 24px;
                z-index: 2;
                cursor: pointer;
                transition: transform 0.3s;
                transform: translateX(200px);
            }

            .menu {
                position: fixed;
                top: 0;
                left: 0px;
                width: 260px;
                height: 100%;
                background-color: white;
                padding: 20px;
                z-index: 1;
                display: flex;
                flex-direction: column;
                gap: 20px;
                transition: transform 0.3s;
                background-color: white;
            }

            .menu_header {
                font-size: 18px;
                padding-bottom: 10px;
                margin-bottom: 10px;
                padding-right: 50px;
                padding-left: 15px;
            }

            .menu_header h2 {
                color: #4E80EE;
            }

            .menu_item {
                display: flex;
                align-items: center;
                padding: 14px;
                border-radius: 8px;
                cursor: pointer;
                color: #333;
                background-color: white;
                /* nền trắng cho rõ hiệu ứng */
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                /* bóng nhẹ mặc định */
                transition: box-shadow 0.3s ease, transform 0.2s ease;
            }

            .menu_item:hover {
                background-color: #eee;
            }

            .menu_item:hover span {
                color: #0d6efd;
                /* màu xanh nổi bật */
                transform: translateY(-2px);
                transition: all 0.2s ease;
            }




            .menu_item i {
                text-align: center;
                width: 36px;
                /* Tăng chiều rộng icon box */
                height: 36px;
                /* Thêm chiều cao */
                font-size: 18px;
                /* Cỡ icon */
                line-height: 36px;
                /* Canh giữa icon */
                background-color: white;
                /* Nền nhẹ cho icon */
                border-radius: 8px;
                /* Bo nhẹ các góc */
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
                /* đổ bóng */

            }


            .menu_item:hover i {
                background-color: #4E80EE;
                color: white;
                transition: 0.2s;
            }



            .menu_item span {
                font-weight: 500;
                margin-left: 20px;
                transition: all 0.2s ease;

            }

            #menu-toggle:checked~.menu {
                transform: translateX(-250px);

            }

            #menu-toggle:checked~.menu-toggle {
                transform: translateX(-10px);
                color: #333;
            }

            .header-sidebar {
                display: flex;
                border-bottom: 2px solid #4E80EE;
                /* canh theo chiều cao cho đều nhau */
            }

            .menu_item.active {
                background-color: #d1e7ff;
                /* màu nền khác */
                color: #0d6efd;
                /* đổi màu chữ hoặc icon */
                font-weight: bold;
            }

            a {
                text-decoration: none;
                color: black;
            }

            .my-icon {
                padding-bottom: 100px;
            }

            .dropdown-menu-custom {
                position: relative;
            }

            .dropdown-toggle {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .dropdown-list {
                display: none;
                position: absolute;
                left: 0;
                top: 100%;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
                border-radius: 8px;
                min-width: 220px;
                z-index: 10;
                padding: 8px 0;
                margin-top: 4px;
            }

            .dropdown-list li {
                list-style: none;
            }

            .dropdown-link {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                color: #333;
                text-decoration: none;
                transition: background 0.2s;
            }

            .dropdown-link i {
                margin-right: 10px;
            }

            .dropdown-link:hover {
                background: #f0f4ff;
                color: #1976d2;
            }

            .dropdown-menu-custom:hover .dropdown-list,
            .dropdown-menu-custom:focus-within .dropdown-list {
                display: block;
            }
        </style>
    </head>

    <body>

        <input type="checkbox" id="menu-toggle" hidden>
        <label for="menu-toggle" class="menu-toggle">
            <i class="fa-solid fa-bars"></i>
        </label>

        <div class="menu">


            <div class="menu">
                <div class="header-sidebar">
                    <div class="logo-menu">
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" width="72" />
                    </div>
                    <div class="menu_header">
                        <h2>HAPPY SMILE</h2>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/UserHompageServlet" class="menu_item">
                    <i class="fa-solid fa-house"></i>
                    <span>Trang chủ</span>
                </a>

                <a href="${pageContext.request.contextPath}/services" class="menu_item">
                    <i class="fa-solid fa-tooth"></i>
                    <span>Dịch Vụ Nha Khoa</span>
                </a>

                <a href="${pageContext.request.contextPath}/BookingPageServlet" class="menu_item">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Đăng Kí Dịch Vụ</span>
                </a>

                <a href="${pageContext.request.contextPath}/PatientAppointments" class="menu_item">
                    <i class="fa-solid fa-calendar-check"></i>
                    <span>Lịch Khám Của Tôi</span>
                </a>

                <div class="dropdown-menu-custom">
                    <a href="#" class="menu_item dropdown-toggle">
                        <i class="fa-solid fa-headset"></i>
                        <span>Tư Vấn</span>
                        <i class="fa-solid fa-caret-down" style="margin-left:auto;"></i>
                    </a>
                    <ul class="dropdown-list">
                        <li>
                            <a href="${pageContext.request.contextPath}/jsp/patient/user_chatAI.jsp"
                               class="dropdown-link">
                                <i class="fa-solid fa-robot"></i> Tư vấn với AI
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/chat.jsp"
                               class="dropdown-link">
                                <i class="fa-solid fa-user-md"></i> Nhắn tin trực tiếp với bác sĩ
                            </a>
                        </li>
                    </ul>
                </div>

                <a href="${pageContext.request.contextPath}/jsp/patient/user_taikhoan.jsp" class="menu_item">
                    <i class="fa-solid fa-circle-user"></i>
                    <span>Tài Khoản</span>
                </a>
            </div>


        </div>
    </body>

</html>
<script src="js/script.js"></script>