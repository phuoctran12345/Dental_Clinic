<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - Happy Smile</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; }
        .header { 
            background-color: #fff; 
            padding: 15px 20px; 
            box-shadow: 0 2px 4px rgba(0,0,0,0.1); 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            position: fixed; 
            top: 0; 
            right: 0; 
            left: 0; 
            z-index: 1000; 
        }
        .header-left { display: flex; align-items: center; }
        .logo { font-size: 24px; font-weight: bold; color: #2196F3; margin-right: 20px; }
        .search-box { 
            display: flex; 
            align-items: center; 
            background-color: #f8f9fa; 
            border-radius: 20px; 
            padding: 8px 15px; 
            margin-left: 20px; 
        }
        .search-box input { border: none; background: none; outline: none; margin-left: 10px; width: 200px; }
        .header-right { display: flex; align-items: center; gap: 15px; }
        .user-info { display: flex; align-items: center; gap: 10px; }
        .sidebar { 
            position: fixed; 
            left: 0; 
            top: 70px; 
            width: 250px; 
            height: calc(100vh - 70px); 
            background-color: #fff; 
            box-shadow: 2px 0 4px rgba(0,0,0,0.1); 
            overflow-y: auto; 
        }
        .sidebar-menu { padding: 20px 0; }
        .menu-item { 
            padding: 12px 20px; 
            cursor: pointer; 
            transition: background-color 0.3s; 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            color: #333; 
            text-decoration: none; 
        }
        .menu-item:hover { background-color: #f0f0f0; }
        .menu-item.active { background-color: #e3f2fd; border-right: 3px solid #2196F3; color: #2196F3; }
        .submenu { padding-left: 45px; font-size: 14px; }
        .submenu-toggle { cursor: pointer; }
        .submenu-items { display: none; }
        .submenu-items.show { display: block; }
        .main-content { margin-left: 250px; margin-top: 70px; padding: 30px; }
        .page-title { font-size: 28px; font-weight: 600; color: #333; margin-bottom: 30px; }
        .activity-section { 
            background-color: #fff; 
            border-radius: 12px; 
            padding: 25px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); 
            margin-bottom: 20px;
        }
        .activity-title { 
            font-size: 20px; 
            font-weight: 600; 
            margin-bottom: 20px; 
            color: #333; 
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f0f0f0; }
        form label { display: block; margin: 10px 0 5px; }
        form input, form select, form textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        form textarea { height: 100px; }
        .action-btn {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: #333;
        }
        .action-btn:hover {
            border-color: #2196F3;
            color: #2196F3;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <div class="logo">Happy Smile</div>
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Tìm kiếm dịch vụ...">
            </div>
        </div>
        <div class="header-right">
            <i class="fas fa-bell" style="font-size: 20px; color: #666; cursor: pointer;"></i>
            <div class="user-info">
                <span>Manager</span>
                <i class="fas fa-user-circle" style="font-size: 24px; color: #666;"></i>
            </div>
        </div>
    </div>

    <div class="sidebar">
        <div class="sidebar-menu">
            <a href="jsp/manager/manager_tongquan.jsp" class="menu-item"><i class="fas fa-chart-line"></i><span>Tổng quan</span></a>
            <div class="menu-item submenu-toggle active" onclick="toggleSubmenu('user-menu')">
                <i class="fas fa-users"></i><span>Quản lý người dùng</span><i class="fas fa-chevron-down"></i>
            </div>
            <div id="user-menu" class="submenu-items show">
                <a href="jsp/manager/manager_nhanvien.jsp" class="menu-item submenu active"><span>Quản lý tài khoản nhân viên</span></a>
                <a href="jsp/manager/manager_benhnhan.jsp" class="menu-item submenu"><span>Quản lý tài khoản bệnh nhân</span></a>
            </div>
            <div class="menu-item submenu-toggle" onclick="toggleSubmenu('schedule-menu')">
                <i class="fas fa-calendar-alt"></i><span>Quản lý lịch</span><i class="fas fa-chevron-down"></i>
            </div>
            <div id="schedule-menu" class="submenu-items">
                <a href="jsp/manager/manager_phancong.jsp" class="menu-item submenu"><span>Phân công</span></a>
                <a href="jsp/manager/manager_lichtrinh.jsp" class="menu-item submenu"><span>Lịch trình nhân viên</span></a>
            </div>
            <a href="jsp/manager/manager_danhmuc.jsp" class="menu-item"><i class="fas fa-tags"></i><span>Quản lý danh mục</span></a>
            <div class="menu-item submenu-toggle" onclick="toggleSubmenu('inventory-menu')">
                <i class="fas fa-pills"></i><span>Quản lý kho</span><i class="fas fa-chevron-down"></i>
            </div>
            <div id="inventory-menu" class="submenu-items">
                <a href="jsp/manager/manager_khothuoc.jsp" class="menu-item submenu"><span>Danh sách thuốc</span></a>
            </div>
            <div class="menu-item submenu-toggle" onclick="toggleSubmenu('stats-menu')">
                <i class="fas fa-chart-bar"></i><span>Thống kê</span><i class="fas fa-chevron-down"></i>
            </div>
            <div id="stats-menu" class="submenu-items">
                <a href="jsp/manager/manager_doanhthu.jsp" class="menu-item submenu"><span>Doanh thu</span></a>
                <a href="jsp/manager/manager_baocaodichvu.jsp" class="menu-item submenu"><span>Báo cáo sử dụng dịch vụ</span></a>
                <a href="jsp/manager/manager_thongke.jsp" class="menu-item submenu"><span>Thống kê người dùng</span></a>
            </div>
            <a href="jsp/manager/manager_taikhoan.jsp" class="menu-item"><i class="fas fa-user"></i><span>Tài khoản</span></a>
        </div>
    </div>

    <div class="main-content">
        <h1 class="page-title">Quản lý danh mục</h1>
        <div class="quick-actions">
            <a href="#add-service" class="action-btn"><i class="fas fa-plus-circle"></i><div>Thêm dịch vụ</div></a>
        </div>
        <div class="activity-section">
            <h2 class="activity-title">Danh sách dịch vụ</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên dịch vụ</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                        <th>Danh mục</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="service" items="${services}">
                        <tr>
                            <td>${service.service_id}</td>
                            <td>${service.service_name}</td>
                            <td>${service.price}</td>
                            <td>${service.status}</td>
                            <td>${service.category}</td>
                            <td>
                                <a href="editService?id=${service.service_id}" class="action-btn"><i class="fas fa-edit"></i></a>
                                <a href="deleteService?id=${service.service_id}" class="action-btn" onclick="return confirm('Xác nhận xóa?')"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="activity-section" id="add-service">
            <h2 class="activity-title">Thêm dịch vụ mới</h2>
            <form action="addService" method="post">
                <label>Tên dịch vụ: <input type="text" name="service_name" required></label>
                <label>Giá: <input type="number" name="price" min="0" required></label>
                <label>Danh mục: <input type="text" name="category"></label>
                <label>Trạng thái:
                    <select name="status" required>
                        <option value="active">Hoạt động</option>
                        <option value="inactive">Không hoạt động</option>
                        <option value="suspended">Tạm ngưng</option>
                    </select>
                </label>
                <label>Mô tả: <textarea name="description"></textarea></label>
                <button type="submit" class="action-btn">Thêm</button>
            </form>
        </div>
    </div>

    <script>
        function toggleSubmenu(menuId) {
            const submenu = document.getElementById(menuId);
            const icon = event.currentTarget.querySelector('.fa-chevron-down');
            if (submenu.classList.contains('show')) {
                submenu.classList.remove('show');
                icon.style.transform = 'rotate(0deg)';
            } else {
                document.querySelectorAll('.submenu-items').forEach(menu => {
                    if (menu.id !== menuId) {
                        menu.classList.remove('show');
                    }
                });
                document.querySelectorAll('.fa-chevron-down').forEach(icon => {
                    if (icon !== event.currentTarget.querySelector('.fa-chevron-down')) {
                        icon.style.transform = 'rotate(0deg)';
                    }
                });
                submenu.classList.add('show');
                icon.style.transform = 'rotate(180deg)';
            }
        }
    </script>
</body>
</html>