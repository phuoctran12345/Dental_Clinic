<%-- Document : doctor_menu Created on : June 24, 2025, 10:37 PM Author : xAI --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap&subset=vietnamese" rel="stylesheet">
    <title>Doctor Menu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Roboto', 'Segoe UI', Arial, 'Helvetica Neue', sans-serif;
        }

        body {
            width: 100vw;
            height: 100vh;
            background-color: #f8f9fb;
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
            left: 0;
            width: 260px;
            height: 100%;
            background-color: #fff;
            padding: 20px;
            z-index: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
            transition: transform 0.3s;
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        .menu_item:hover {
            background-color: #eee;
        }

        .menu_item:hover span {
            font-weight: bold;
            color: black;
            transform: translateY(-2px);
            transition: all 0.2s ease;
        }

        .menu_item i {
            text-align: center;
            width: 36px;
            height: 36px;
            font-size: 18px;
            line-height: 36px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
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

        .menu_item.active {
            background-color: #d1e7ff;
            color: #0d6efd;
            font-weight: bold;
        }

        .menu_item.active i {
            background-color: #4E80EE;
            color: white;
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
        }

        a {
            text-decoration: none;
            color: black;
        }

        .dropdown-arrow {
            margin-left: auto;
            transition: transform 0.3s;
            background: none;
            box-shadow: none;
            border-radius: 0;
            padding: 0;
            color: #333;
            font-size: 14px;
        }

        .menu_group.open .dropdown-arrow {
            transform: rotate(180deg);
        }

        .menu_group.open .menu_item {
            background-color: #d1e7ff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .menu_group.open .menu_item i {
            background-color: #4E80EE;
            color: white;
        }

        .dropdown_list {
            display: none;
            padding-left: 30px;
            margin-top: 6px;
            flex-direction: column;
            font-size: 14px;
            gap: 20px;
            transition: max-height 0.1s ease;
        }

        .menu_group.open .dropdown_list {
            display: flex;
            max-height: 300px;
        }

        .dropdown_list a {
            font-weight: 500;
            color: #444;
            text-decoration: none;
            padding: 2px 0;
            transition: color 0.2s;
        }

        .dropdown_list a:hover {
            color: #4E80EE;
            font-weight: bold;
        }

        .dropdown_list a.active {
            color: #4E80EE;
            font-weight: bold;
        }

        .menu_register_schedule {
            background: #e0f2fe;
            border-left: 4px solid #4E80EE;
            margin: 10px 0;
            transition: background 0.2s;
        }

        .menu_register_schedule:hover {
            background: #bae6fd;
        }

        .menu_register_schedule .fa-calendar-plus {
            color: #2563eb;
            background: #fff;
            border-radius: 8px;
            padding: 6px;
            font-size: 18px;
            margin-right: 8px;
        }

        .menu_register_schedule .menu-link {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <input type="checkbox" id="menu-toggle" hidden>
    <label for="menu-toggle" class="menu-toggle">
        <i class="fa-solid fa-bars"></i>
    </label>

    <div class="menu" id="sideMenu">
        <div class="header-sidebar">
            <div class="logo-menu">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" width="60" />
            </div>
            <div class="menu_header">
                <h2>HAPPY SMILE</h2>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/DoctorHomePageServlet " class="menu_item">
            <i class="fa-solid fa-house"></i>
            <span>Tổng quan</span>
        </a>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-calendar-week"></i>
                <span>Lượt Khám</span>
                <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet">• Trong ngày</a>
                <a href="${pageContext.request.contextPath}/cancelledAppointments">• Bị huỷ bỏ</a>
                <a href="${pageContext.request.contextPath}/completedAppointments">• Kết quả khám</a>
            </div>
        </div>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-calendar-week"></i>
                <span>Lịch Khám</span>
                <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/DoctorHaveAppointmentServlet">• Lịch làm</a>
                <a href="${pageContext.request.contextPath}/DoctorRegisterScheduleServlet">• Đăng ký lịch</a>
                <a href="${pageContext.request.contextPath}/ReexaminationServlet">• Tái khám</a>
            </div>
        </div>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-calendar-week"></i>
                <span>Tư vấn</span>
                <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/chat.jsp">• Phòng chờ</a>
                <a href="${pageContext.request.contextPath}/chat.jsp">• Trò chuyện</a>
            </div>
        </div>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-circle-user"></i>
                <span>Tài Khoản</span>
                <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/doctor_trangcanhan">• Trang cá nhân</a>
                <a href="${pageContext.request.contextPath}/EditDoctorServlet">• Cài đặt</a>
            </div>
        </div>


    </div>

    <script>
        function toggleDropdown(el) {
            const allGroups = document.querySelectorAll('.menu_group');
            allGroups.forEach(group => {
                if (group !== el.parentElement) {
                    group.classList.remove('open');
                }
            });
            el.parentElement.classList.toggle('open');
        }

        document.addEventListener("DOMContentLoaded", () => {
            const currentPage = window.location.pathname.split("/").pop();
            const menuItems = document.querySelectorAll(".menu_item");
            menuItems.forEach(item => {
                const link = item.querySelector("a");
                if (link) {
                    const linkPage = link.getAttribute("href").split("/").pop();
                    if (linkPage === currentPage) {
                        item.classList.add("active");
                    }
                }
            });

            const subLinks = document.querySelectorAll(".dropdown_list a");
            subLinks.forEach(link => {
                const linkPage = link.getAttribute("href").split("/").pop();
                if (linkPage === currentPage) {
                    link.classList.add("active");
                    const menuGroup = link.closest(".menu_group");
                    if (menuGroup) {
                        menuGroup.classList.add("open");
                    }
                }
            });
        });
    </script>
</body>
</html>