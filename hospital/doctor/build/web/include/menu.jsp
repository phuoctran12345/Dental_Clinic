<%-- 
    Document   : user_homepage
    Created on : May 16, 2025, 11:32:55 AM
    Author     : Home
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <style>
            *{
                margin : 0;
                padding : 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', sans-serif;

            }

            body{
                width: 100vw;
                height: 100vh;
                background-color: #f8f9fb;
            }
            .menu-toggle {
                position: fixed;
                top: 25px;
                left:20px;
                font-size: 24px;
                z-index: 2;
                cursor: pointer;
                transition: transform 0.3s;
                transform: translateX(200px);
            }

            .menu{
                position: fixed;
                top: 0;
                left: 0;
                width: 260px;
                height: 100%;
                background-color:#f8f9fb ;
                padding: 20px;
                z-index: 1;
                display: flex;
                flex-direction: column;
                gap: 20px;
                transition: transform 0.3s;
                transform: translateX(0);

            }

            .menu_header{
                font-size: 20px;
                padding-bottom: 10px;
                margin-bottom: 20px;
                border-bottom: 2px solid #C0DAEC;
            }
            .menu_header h2{
                color: #00BFFF;
            }

            .menu_item{
                display: flex;
                align-items: center;
                padding: 14px;
                border-radius: 8px;
                transition: all 0.1s;
                cursor: pointer;
                color: #333;
            }

            .menu_item:hover{
                background-color: #eee;
            }
            .menu_item:hover i{
                background-color: #00BFFF;
                color: white;
                transition: 0.2s;
            }
            .menu_item.active {
                background-color: #f1f1f1;
                font-weight: bold;
                color: #007bff;
            }
            .menu_item.active i {
                background-color: #00BFFF;
                color: white;
            }




            .menu_item i {
                text-align: center;
                width: 36px;             /* Tăng chiều rộng icon box */
                height: 36px;            /* Thêm chiều cao */
                font-size: 18px;         /* Cỡ icon */
                line-height: 36px;       /* Canh giữa icon */
                background-color:white; /* Nền nhẹ cho icon */
                border-radius: 8px;      /* Bo nhẹ các góc */
                color: black;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 👈 Đổ bóng *//* Màu icon */
            }


            .menu_item span{
                font-weight: 500;
                margin-left: 20px;

            }
            .menu_item span a{
                text-decoration: none;
                color: black;

            }

            #menu-toggle:checked~.menu{
                transform: translateX(-250px);

            }
            #menu-toggle:checked~.menu-toggle{
                transform: translateX(-10px);
                color: #333;
            }

            .my-icon{
                background-color: black;
            }
            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                margin-top: 10px;
                display: none;
                padding: 10px 20px;
                z-index: 1000;
            }
            .dropdown-menu a {
                display: block;
                padding: 6px 0;
                color: #333;
                text-decoration: none;
                font-size: 14px;
            }

            .dropdown-menu a:hover {
                color: #007bff;
            }

            /* Khi bật dropdown */
            .dropdown.open .dropdown-menu {
                display: block;
            }
            .menu_group {
                display: flex;
                flex-direction: column;
            }

            .dropdown_list {
                display: none;
                padding-left: 50px;
                margin-top: 5px;
                flex-direction: column;
                font-size: 14px;
                flex-direction: column;
                font-size: 14px;
                padding-left: 30px;      /* ✅ Thụt vào nhẹ */
                margin-top: 6px;
                gap: 20px;
                transition: max-height 0.1s ease;
            }

            .dropdown_list a {
                font-weight: 500;
                color: #444;
                text-decoration: none;
                padding: 2px 0;
                transition: color 0.2s;
            }
            .dropdown_list a.active {
                color: #00BFFF;
                font-weight: bold;
            }


            .dropdown_list a:hover {
                color: #00BFFF;
                font-weight: bold;
            }


            .menu_group.open .dropdown_list {
                display: flex;
            }

            .menu_item .dropdown-arrow {
                margin-left: auto;
                transition: transform 0.3s;
                background: none;       /* ❌ Xoá nền */
                box-shadow: none;       /* ❌ Xoá đổ bóng */
                border-radius: 0;       /* ❌ Xoá bo góc */
                padding: 0;             /* ❌ Xoá khoảng trống */
                color: #333;            /* ✅ Màu biểu tượng */
                font-size: 14px;
            }

            .menu_group.open .dropdown-arrow {
                transform: rotate(180deg);
            }
            .menu_group.open .menu_item {
                background-color: #f1f1f1; /* Nền sáng */
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05); /* Đổ bóng nhẹ */
            }
            .menu_group.open .menu_item i{
                background-color: #00BFFF;
                color: white;
            }

            .menu_group.open .dropdown_list {
                max-height: 300px; /* đủ lớn để hiển thị tất cả menu con */
            }



        </style>
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <label for="menu-toggle" class="menu-toggle">
            <i class="fa-solid fa-bars"></i>
        </label>

        <div class="menu" id="sideMenu">

            <div class="menu_header">
                <h2>Happy Smile</h2>
            </div>

            <div class="menu_item">
                <i class="fa-solid fa-house"></i>
                <span>
                    <a href="doctor_tongquan.jsp">Tổng quan</a>
                </span>
                </a>
            </div>


            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">

                    <i class="fa-solid fa-calendar-week"></i>
                    <span>Lượt Khám</span>

                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>

                </div>
                <div class="dropdown_list">
                    <a href="DoctorAppointmentsServlet">• Trong ngày</a>
                    <a href="cancelledAppointments">• Bị huỷ bỏ</a>
                    <a href="completedAppointments">• Kết quả khám</a>
                </div>
            </div>



            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-calendar-week"></i>
                    <span>Lịch Khám</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="doctor-schedule?action=list">• Lịch làm</a>
                    <a href="doctor_dangkilich.jsp">• Đăng kí lịch</a>
                    <a href="ReexaminationServlet">• Tái khám</a>
                </div>
            </div>


            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-calendar-week"></i>
                    <span>Tư vấn</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="doctor_phongcho.jsp">• Phòng chờ</a>
                    <a href="doctor_trochuyen.jsp">• Trò chuyện</a>

                </div>
            </div>

            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-calendar-week"></i>
                    <span>Tài Khoản</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="doctor_trangcanhan">• Trang cá nhân</a>
                    <a href="doctor_caidat">• Cài đặt</a>

                </div>
            </div>

            <script>
                function toggleDropdown(el) {
                    const allGroups = document.querySelectorAll('.menu_group');

                    // Đóng tất cả menu_group
                    allGroups.forEach(group => {
                        if (group !== el.parentElement) {
                            group.classList.remove('open');
                        }
                    });

                    // Mở menu_group hiện tại
                    el.parentElement.classList.toggle('open');
                }

                document.addEventListener("DOMContentLoaded", () => {
                    const currentPage = window.location.pathname.split("/").pop(); // Lấy tên file hiện tại

                    // Xóa active ở tất cả menu_item, dropdown_list a trước (nếu có)

                    // Tìm và đánh dấu menu_item chính active
                    const menuItems = document.querySelectorAll(".menu_item");
                    menuItems.forEach(item => {
                        const link = item.querySelector("a");
                        if (link) {
                            const linkPage = link.getAttribute("href");
                            if (linkPage === currentPage) {
                                item.classList.add("active");
                            }
                        }
                    });

                    // Tìm và đánh dấu dropdown_list a active và mở dropdown cha
                    const subLinks = document.querySelectorAll(".dropdown_list a");
                    subLinks.forEach(link => {
                        const linkPage = link.getAttribute("href");
                        if (linkPage === currentPage) {
                            link.classList.add("active");
                            const menuGroup = link.closest(".menu_group");
                            if (menuGroup) {
                                menuGroup.classList.add("open"); // Mở dropdown cha
                            }
                        }
                    });
                });

            </script>


        </div>
    </body>
</html> 
