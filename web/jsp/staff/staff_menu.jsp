<!DOCTYPE html>
<html>

<head>
    <%@ page pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <title>Menu Staff</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">

            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                    font-family: 'Inter', sans-serif;
                }

                .menu {
                    position: fixed;
                    left: 0;
                    top: 0;
                    width: 280px;
                    height: 100vh;
                    background: #ffffff;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                    z-index: 1000;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    overflow-y: auto;
                }

                .menu::-webkit-scrollbar {
                    width: 4px;
                }

                .menu::-webkit-scrollbar-track {
                    background: transparent;
                }

                .menu::-webkit-scrollbar-thumb {
                    background: rgba(0, 0, 0, 0.2);
                    border-radius: 2px;
                }

                .menu_header {
                    padding: 30px 20px;
                    text-align: center;
                    border-bottom: 1px solid #e0e0e0;
                    background: #f8f9fa;
                }

                .menu_header h2 {
                    color: #333333;
                    font-size: 22px;
                    font-weight: 600;
                    margin-bottom: 5px;
                }

                .menu_header .subtitle {
                    color: #666666;
                    font-size: 14px;
                    font-weight: 400;
                }

                .menu_item {
                    padding: 16px 20px;
                    display: flex;
                    align-items: center;
                    cursor: pointer;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    position: relative;
                    margin: 4px 12px;
                    border-radius: 12px;
                    overflow: hidden;
                }

                .menu_item::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: #f0f0f0;
                    transform: scaleX(0);
                    transform-origin: left;
                    transition: transform 0.3s ease;
                    z-index: -1;
                }

                .menu_item:hover::before {
                    transform: scaleX(1);
                }

                .menu_item:hover {
                    background: #f5f5f5;
                    transform: translateX(8px);
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                }

                .menu_item i {
                    margin-right: 15px;
                    color: #555555;
                    width: 20px;
                    font-size: 18px;
                    transition: all 0.3s ease;
                }

                .menu_item:hover i {
                    color: #333333;
                    transform: scale(1.1);
                }

                .menu_item span {
                    color: #333333;
                    font-size: 15px;
                    font-weight: 500;
                    transition: all 0.3s ease;
                }

                .menu_item:hover span {
                    color: #000000;
                }

                .menu_item a {
                    text-decoration: none;
                    color: inherit;
                    display: block;
                    width: 100%;
                }

                .menu_group {
                    position: relative;
                }

                .dropdown_list {
                    display: none;
                    padding-left: 0;
                    background: #f8f9fa;
                    margin: 4px 12px;
                    border-radius: 8px;
                    overflow: hidden;
                    animation: slideDown 0.3s ease;
                }

                @keyframes slideDown {
                    from {
                        opacity: 0;
                        transform: translateY(-10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .dropdown_list a {
                    display: block;
                    padding: 12px 20px 12px 55px;
                    color: #666666;
                    text-decoration: none;
                    font-size: 14px;
                    font-weight: 400;
                    position: relative;
                    transition: all 0.3s ease;
                }

                .dropdown_list a::before {
                    content: '';
                    position: absolute;
                    left: 25px;
                    top: 50%;
                    transform: translateY(-50%);
                    width: 6px;
                    height: 6px;
                    background: #cccccc;
                    border-radius: 50%;
                    transition: all 0.3s ease;
                }

                .dropdown_list a:hover {
                    background: #e9ecef;
                    color: #333333;
                    padding-left: 60px;
                }

                .dropdown_list a:hover::before {
                    background: #333333;
                    transform: translateY(-50%) scale(1.2);
                }

                .dropdown-arrow {
                    margin-left: auto;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    opacity: 0.7;
                }

                .menu_item.active .dropdown-arrow {
                    transform: rotate(180deg);
                    opacity: 1;
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
                    background: #ffffff;
                    color: #333333;
                    border: 1px solid #e0e0e0;
                    border-radius: 8px;
                    padding: 12px;
                    font-size: 18px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    transition: all 0.3s ease;
                }

                .menu-toggle:hover {
                    transform: scale(1.1);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
                }

                @media (max-width: 768px) {
                    .menu {
                        transform: translateX(-100%);
                        width: 100%;
                        max-width: 280px;
                    }

                    #menu-toggle:checked~.menu {
                        transform: translateX(0);
                    }

                    .menu-toggle {
                        display: block;
                    }
                }

                .notification-badge {
                    background: #ff4444;
                    color: white;
                    border-radius: 50%;
                    padding: 4px 8px;
                    font-size: 11px;
                    margin-left: 8px;
                    font-weight: 600;
                    box-shadow: 0 2px 8px rgba(255, 68, 68, 0.3);
                    animation: pulse 2s infinite;
                }

                @keyframes pulse {
                    0% {
                        transform: scale(1);
                    }

                    50% {
                        transform: scale(1.1);
                    }

                    100% {
                        transform: scale(1);
                    }
                }

                .menu_section {
                    padding: 20px 20px 10px;
                    border-top: 1px solid #e0e0e0;
                    margin-top: 20px;
                }

                .menu_section:first-child {
                    border-top: none;
                    margin-top: 0;
                }

                .menu_section_title {
                    color: #999999;
                    font-size: 12px;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin-bottom: 15px;
                    padding-left: 8px;
                }

                /* Active menu item */
                .menu_item.current {
                    background: #e9ecef;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                }

                .menu_item.current i,
                .menu_item.current span {
                    color: #333333;
                }

                /* Clean background */
                .menu::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: #ffffff;
                    z-index: -1;
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
            <div class="subtitle">Hệ thống quản lý</div>
        </div>

        <div class="menu_section">
            <div class="menu_section_title">Tổng quan</div>

            <!-- Trang chủ -->
            <div class="menu_item current">
                <i class="fa-solid fa-house"></i>
                <span>
                    <a href="${pageContext.request.contextPath}/jsp/staff/staff_tongquan.jsp">Trang chủ</a>
                </span>
            </div>
        </div>

        <div class="menu_section">
            <div class="menu_section_title">Quản lý chính</div>

            <!-- Quản lý lịch hẹn -->
            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-calendar-check"></i>
                    <span>Quản lý lịch hẹn</span>
                    <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
                </div>
                <div class="dropdown_list">n
                    <a href="${pageContext.request.contextPath}/StaffBookingServlet">Đặt lịch mới</a>
                    <a href="${pageContext.request.contextPath}/CancelAppointmentServlet">Xem huỷ lịch hẹn</a>
                    <a href="${pageContext.request.contextPath}/RescheduleAppointmentServlet">Đổi  lịch hẹn</a>
                    
                    <a href="#">Lịch tái khám</a>
                </div>
            </div>

            <!-- Bán thuốc -->
            <!-- <div class="menu_item">
                <i class="fa-solid fa-pills"></i>
                <span>
                    <a href="${pageContext.request.contextPath}/jsp/staff/sell_medicine_direct.jsp">Bán thuốc</a>
                </span>
            </div> -->

            <!-- Quản lý hàng đợi -->
            <div class="menu_item">
                <i class="fa-solid fa-users-line"></i>
                <span>
                    <a href="${pageContext.request.contextPath}/StaffHandleQueueServlet">Quản lý hàng đợi</a>
                </span>
            </div>

            <!-- Quản lý thanh toán -->
            <div class="menu_group">
                <div class="menu_item" onclick="toggleDropdown(this)">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    <span>Quản lý thanh toán</span>
                    <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
                </div>
                <div class="dropdown_list">
                    <a href="StaffPaymentServlet?action=payments">Thanh toán hóa đơn</a>
                    <a href="StaffPaymentServlet?action=installments">Quản lý trả góp</a>
                </div>
            </div>
        </div>

        <div class="menu_section">
            <div class="menu_section_title">Công việc</div>

            <!-- Đăng kí lịch làm việc -->
            <div class="menu_item">
                <i class="fa-solid fa-calendar-plus"></i>
                <span>
                    <a href="${pageContext.request.contextPath}/StaffRegisterSecheduleServlet">Đăng Kí Lịch Làm Việc</a>
                </span>
            </div>

            <!-- Tin tức y tế -->
            <div class="menu_item">
                <i class="fa-solid fa-newspaper"></i>
                <span>
                    <a href="blog.jsp">Tin tức y tế</a>
                </span>
            </div>

            <!-- Thông báo -->
            <div class="menu_item">
                <i class="fa-solid fa-bell"></i>
                <span>
                    <a href="#">Thông báo</a>
                </span>
                <span class="notification-badge">3</span>
            </div>
        </div>

        <div class="menu_section">
            <div class="menu_section_title">Cá nhân</div>

            <!-- Tài khoản -->
            <div class="menu_item">
                <i class="fa-solid fa-user-circle"></i>
                <span>
                    <a href="${pageContext.request.contextPath}/StaffProfileServlet">Tài khoản của tôi</a>
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
    </div>

    <script>
        function toggleDropdown(element) {
            // Close all other dropdowns
            document.querySelectorAll('.menu_item.active').forEach(item => {
                if (item !== element) {
                    item.classList.remove('active');
                }
            });

            // Toggle current dropdown
            element.classList.toggle('active');
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function (event) {
            if (!event.target.closest('.menu_group')) {
                document.querySelectorAll('.menu_item.active').forEach(item => {
                    item.classList.remove('active');
                });
            }
        });

        // Add current page highlighting
        document.addEventListener('DOMContentLoaded', function () {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.menu_item a');

            menuItems.forEach(item => {
                if (item.getAttribute('href') && currentPath.includes(item.getAttribute('href'))) {
                    item.closest('.menu_item').classList.add('current');
                }
            });
        });
    </script>
</body>

</html>