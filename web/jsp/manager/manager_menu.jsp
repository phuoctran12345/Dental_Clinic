<%@page contentType="text/html" pageEncoding="UTF-8" %>
<style>
    .menu {
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        height: 100vh;
        background-color: #fff;
        box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        transition: transform 0.3s ease;
    }

    .menu_header {
        padding: 20px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }

    .menu_header h2 {
        margin: 0;
        color: #333;
        font-size: 24px;
    }

    .menu_item {
        padding: 15px 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .menu_item:hover {
        background-color: #f5f5f5;
    }

    .menu_item i {
        width: 20px;
        color: #666;
    }

    .menu_item span {
        flex: 1;
        color: #333;
    }

    .menu_item a {
        text-decoration: none;
        color: inherit;
    }

    .dropdown-arrow {
        transition: transform 0.3s;
    }

    .menu_group.open .dropdown-arrow {
        transform: rotate(180deg);
    }

    .dropdown_list {
        display: none;
        padding-left: 30px;
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
        flex-direction: column;
    }
</style>

<script>
    function toggleDropdown(element) {
        const menuGroup = element.parentElement;
        menuGroup.classList.toggle('open');
    }
</script>

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
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_tongquan.jsp">Tổng quan</a>
            </span>
        </div>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-users"></i>
                <span>Quản lý người dùng </span>
                <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_danhsach.jsp">• Danh sách nhân viên</a>
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_customers.jsp">• Danh sách khách hàng</a>
            </div>
        </div>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-calendar-week"></i>
                <span>Lịch làm việc</span>
                <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_lichtrinh.jsp">• Lịch trình</a>
                <a href="${pageContext.request.contextPath}/ScheduleApprovalServlet">• Phân công</a>
            </div>
        </div>

        <div class="menu_group">
            <div class="menu_item" onclick="toggleDropdown(this)">
                <i class="fa-solid fa-chart-line"></i>
                <span>Thống kê</span>
                <a class="fa-solid fa-chevron-down dropdown-arrow"></a>
            </div>
            <div class="dropdown_list">
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_thongke.jsp">• Báo cáo thống kê</a>
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_doanhthu.jsp">• Doanh thu</a>
                <a href="${pageContext.request.contextPath}/jsp/manager/manager_khothuoc.jsp">• Kho thuốc</a>
            </div>
        </div>
        <!-- Đăng xuất -->
        <div class="menu_item">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>
                <a href="${pageContext.request.contextPath}/LogoutServlet">Đăng xuất</a>
            </span>
        </div>

    </div>
</body>