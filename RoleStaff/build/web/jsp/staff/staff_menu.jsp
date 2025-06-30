<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Menu Staff</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', sans-serif;
            }

            .menu {
                position: fixed;
                left: 0;
                top: 0;
                width: 250px;
                height: 100vh;
                background-color: #fff;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                transition: 0.3s ease;
            }

            .menu_header {
                padding: 20px;
                text-align: center;
                border-bottom: 1px solid #eee;
            }

            .menu_header h2 {
                color: #00BFFF;
                font-size: 24px;
            }

            .menu_item {
                padding: 15px 20px;
                display: flex;
                align-items: center;
                cursor: pointer;
                transition: 0.3s;
            }

            .menu_item:hover {
                background-color: #f8f9fb;
            }

            .menu_item i {
                margin-right: 10px;
                color: #666;
                width: 20px;
            }

            .menu_item span {
                color: #333;
                font-size: 16px;
            }

            .menu_item a {
                text-decoration: none;
                color: inherit;
            }

            .menu_group {
                position: relative;
            }

            .dropdown_list {
                display: none;
                padding-left: 20px;
                background-color: #f8f9fb;
            }

            .dropdown_list a {
                display: block;
                padding: 10px 20px;
                color: #666;
                text-decoration: none;
                font-size: 14px;
            }

            .dropdown_list a:hover {
                background-color: #e9ecef;
            }

            .dropdown-arrow {
                margin-left: auto;
                transition: 0.3s;
            }

            .menu_item.active .dropdown-arrow {
                transform: rotate(180deg);
            }

            .menu_item.active+.dropdown_list {
                display: block;
            }

            .menu-toggle {
                position: fixed;
                left: 20px;
                top: 20px;
                z-index: 1001;
                cursor: pointer;
                display: none;
            }

            @media (max-width: 768px) {
                .menu {
                    transform: translateX(-100%);
                }

                #menu-toggle:checked~.menu {
                    transform: translateX(0);
                }

                .menu-toggle {
                    display: block;
                }
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
                <h2>Nha Khoa Hạnh Phúc</h2>
            </div>

            <div class="menu_item">
                <i class="fa-solid fa-house"></i>
                <span>
                    <a href="staff_homepage.jsp">Trang chủ</a>
                </span>
            </div>

            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-calendar-check"></i>
                    <span>Đặt lịch hẹn</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="staff_datlich.jsp">• Đặt lịch mới</a>
                    <a href="#">• Lịch đã đặt</a>
                    <a href="#">• Lịch đã hủy</a>
                </div>
            </div>

            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-users"></i>
                    <span>Bệnh nhân</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="StaffViewPatientServlet">• Danh sách bệnh nhân</a>                    
                    <a href="#">• Lịch sử khám</a>
                </div>
            </div>

            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-comments"></i>
                    <span>Tư vấn</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="staff_tuvan.jsp">• Yêu cầu tư vấn</a>
                    <a href="#">• Lịch sử tư vấn</a>
                </div>
            </div>

            <div class="menu_item">
                <i class="fa-solid fa-user"></i>
                <span>
                    <%
                        model.Staff staff = (model.Staff) session.getAttribute("staff");
                        long staffId = (staff != null) ? staff.getId() : 0; // 0 là mặc định nếu chưa đăng nhập
%>
                    <a href="staff-info?id=<%= staffId%>">Tài khoản của tôi</a>
                </span>
            </div>
        </div>

        <script>
            function toggleDropdown(element) {
                element.classList.toggle('active');
            }
        </script>
    </body>

</html>