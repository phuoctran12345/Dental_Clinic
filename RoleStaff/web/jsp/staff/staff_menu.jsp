<%@ page contentType="text/html; charset=UTF-8" %>
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

            .notification-badge {
                background-color: #ff4444;
                color: white;
                border-radius: 50%;
                padding: 2px 6px;
                font-size: 12px;
                margin-left: 5px;
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

            <!-- Trang chủ -->
            <div class="menu_item">
                <i class="fa-solid fa-house"></i>
                <span>
                    <a href="${pageContext.request.contextPath}/jsp/staff/staff_tongquan.jsp">Trang chủ</a>
                </span>
            </div>

            <!-- Quản lý lịch hẹn -->
            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-calendar-check"></i>
                    <span>Quản lý lịch hẹn</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="${pageContext.request.contextPath}/StaffBookingServlet">• Đặt lịch mới</a>
                    <a href="#">• Xem lịch hẹn</a>
                    <a href="#">• Lịch điều trị</a>
                </div>
            </div>

            <!-- Quản lý bệnh nhân -->
            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-users"></i>
                    <span>Quản lý bệnh nhân</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="StaffViewPatientServlet">• Danh sách bệnh nhân</a>
                    <a href="#">• Tạo tài khoản khách</a>
                    <a href="#">• Hồ sơ bệnh án</a>
                </div>
            </div>

            <!-- Quản lý thuốc -->
            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-pills"></i>
                    <span>Quản lý thuốc</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="#">• Danh sách thuốc</a>
                    <a href="#">• Kê đơn thuốc</a>
                </div>
            </div>

            <!-- Tin tức y tế -->
            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-newspaper"></i>
                    <span>Tin tức y tế</span>
                    <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
                </div>
                <div class="dropdown_list">
                    <a href="#">• Đăng tin mới</a>
                    <a href="#">• Quản lý tin tức</a>
                </div>
            </div>

            <!-- Thông báo -->
            <div class="menu_item">
                <i class="fa-solid fa-bell"></i>
                <span>
                    <a href="#">Thông báo</a>
                </span>
                <span class="notification-badge">3</span>
            </div>

            <!-- Tài khoản -->
            <div class="menu_item">
                <i class="fa-solid fa-user"></i>
                <span>
                    <% model.Staff staff=(model.Staff) session.getAttribute("staff"); long staffId=(staff !=null) ?
                        staff.getUserId() : 0; %>
                        <a href="staff-info?id=<%= staffId %>">Tài khoản của tôi</a>
                </span>
            </div>

            <!-- Đăng xuất -->
            <div class="menu_item">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>
                    <a href="LogoutServlet">Đăng xuất</a>
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