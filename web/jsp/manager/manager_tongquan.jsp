<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan phòng khám - Happy Smile</title>
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
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
            gap: 20px; 
            margin-bottom: 30px; 
        }
        .stat-card { 
            background: linear-gradient(135deg, #2196F3, #1976D2); 
            color: white; 
            padding: 25px; 
            border-radius: 12px; 
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
        }
        .stat-card.green { background: linear-gradient(135deg, #4CAF50, #388E3C); }
        .stat-card.orange { background: linear-gradient(135deg, #FF9800, #F57C00); }
        .stat-card.purple { background: linear-gradient(135deg, #9C27B0, #7B1FA2); }
        .stat-card h3 { 
            font-size: 16px; 
            font-weight: 500; 
            margin-bottom: 10px; 
            opacity: 0.9; 
        }
        .stat-card .number { font-size: 36px; font-weight: bold; margin-bottom: 10px; }
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
        .activity-item { 
            padding: 12px 0; 
            border-bottom: 1px solid #eee; 
            color: #666; 
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-icon { 
            width: 8px; 
            height: 8px; 
            background-color: #2196F3; 
            border-radius: 50%; 
        }
        .chart-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
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
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <div class="logo">Happy Smile</div>
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Tìm kiếm...">
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

    <!-- Sidebar -->
    <div class="sidebar">
    <div class="sidebar-menu">
        <a href="manager_tongquan.jsp" class="menu-item active"><i class="fas fa-chart-line"></i><span>Tổng quan</span></a>
        
        <div class="menu-item submenu-toggle" onclick="toggleSubmenu('user-menu')">
            <i class="fas fa-users"></i><span>Quản lý người dùng</span><i class="fas fa-chevron-down"></i>
        </div>
        <div id="user-menu" class="submenu-items">
            <a href="jsp/manager/manager_nhanvien.jsp" class="menu-item submenu"><span>Quản lý tài khoản nhân viên</span></a>
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

    <!-- Main Content -->
    <div class="main-content">
        <h1 class="page-title">Tổng quan phòng khám</h1>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Tổng số bệnh nhân</h3>
                <div class="number">1</div>
                <small>Bệnh nhân đã đăng ký</small>
            </div>
            <div class="stat-card green">
                <h3>Bác sĩ</h3>
                <div class="number">3</div>
                <small>Bác sĩ đang hoạt động</small>
            </div>
            <div class="stat-card orange">
                <h3>Nhân viên</h3>
                <div class="number">1</div>
                <small>Nhân viên hỗ trợ</small>
            </div>
            <div class="stat-card purple">
                <h3>Lượt khám hôm nay</h3>
                <div class="number">4</div>
                <small>Cuộc hẹn đã đặt</small>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="manager_nhanvien.jsp" class="action-btn">
                <i class="fas fa-user-plus" style="font-size: 24px; margin-bottom: 10px; color: #2196F3;"></i>
                <div>Thêm nhân viên</div>
            </a>
            <a href="manager_danhmuc.jsp" class="action-btn">
                <i class="fas fa-plus-circle" style="font-size: 24px; margin-bottom: 10px; color: #4CAF50;"></i>
                <div>Thêm dịch vụ</div>
            </a>
            <a href="manager_phancong.jsp" class="action-btn">
                <i class="fas fa-calendar-plus" style="font-size: 24px; margin-bottom: 10px; color: #FF9800;"></i>
                <div>Phân công lịch</div>
            </a>
            <a href="manager_khothuoc.jsp" class="action-btn">
                <i class="fas fa-pills" style="font-size: 24px; margin-bottom: 10px; color: #9C27B0;"></i>
                <div>Quản lý kho</div>
            </a>
        </div>

        <!-- Charts and Activity -->
        <div class="chart-container">
            <div class="chart-card">
                <h3 class="activity-title">Doanh thu 7 ngày gần đây</h3>
                <div style="height: 300px; display: flex; align-items: center; justify-content: center; color: #999;">
                    <i class="fas fa-chart-area" style="font-size: 48px; margin-right: 15px;"></i>
                    <span>Biểu đồ doanh thu sẽ được hiển thị tại đây</span>
                </div>
            </div>

            <div class="chart-card">
                <h3 class="activity-title">Dịch vụ phổ biến</h3>
                <div style="padding: 20px 0;">
                    <div style="margin-bottom: 15px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span>Khám tổng quát</span>
                            <span>45%</span>
                        </div>
                        <div style="background: #e0e0e0; height: 8px; border-radius: 4px;">
                            <div style="background: #2196F3; width: 45%; height: 100%; border-radius: 4px;"></div>
                        </div>
                    </div>
                    <div style="margin-bottom: 15px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span>Lấy cao răng</span>
                            <span>30%</span>
                        </div>
                        <div style="background: #e0e0e0; height: 8px; border-radius: 4px;">
                            <div style="background: #4CAF50; width: 30%; height: 100%; border-radius: 4px;"></div>
                        </div>
                    </div>
                    <div style="margin-bottom: 15px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span>Trám răng</span>
                            <span>25%</span>
                        </div>
                        <div style="background: #e0e0e0; height: 8px; border-radius: 4px;">
                            <div style="background: #FF9800; width: 25%; height: 100%; border-radius: 4px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="activity-section">
            <h2 class="activity-title">Hoạt động gần đây</h2>
            <div class="activity-item">
                <div class="activity-icon"></div>
                <span>BS. Nguyễn Văn An đã cập nhật lịch làm việc</span>
                <small style="margin-left: auto; color: #999;">2 giờ trước</small>
            </div>
            <div class="activity-item">
                <div class="activity-icon"></div>
                <span>Bệnh nhân Nguyễn Thị Mai đã đặt lịch khám</span>
                <small style="margin-left: auto; color: #999;">3 giờ trước</small>
            </div>
            <div class="activity-item">
                <div class="activity-icon"></div>
                <span>Nhân viên Lê Văn Nam đã cập nhật thông tin kho thuốc</span>
                <small style="margin-left: auto; color: #999;">5 giờ trước</small>
            </div>
            <div class="activity-item">
                <div class="activity-icon"></div>
                <span>Dịch vụ "Tư vấn niềng răng" đã được thêm vào hệ thống</span>
                <small style="margin-left: auto; color: #999;">6 giờ trước</small>
            </div>
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
                // Close all other submenus
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