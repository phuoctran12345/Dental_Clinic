<%@page pageEncoding="UTF-8" %>
    <%@ include file="/jsp/manager/manager_header.jsp" %>
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
            <%@ page import="dao.ManagerDAO" %>
                <%@ page import="dao.UserDAO" %>
                    <%@ page import="model.Manager" %>
                        <%@ page import="model.User" %>

                            <% User user=(User) session.getAttribute("user"); if (user==null ||
                                !"MANAGER".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
                                Manager manager=ManagerDAO.getManagerInfo(user.getUserId()); %>

                                <!DOCTYPE html>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Quản lý phòng khám</title>
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <link rel="stylesheet"
                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                                    <style>
                                        .sidebar {
                                            background: #2c3e50;
                                            color: white;
                                            min-height: 100vh;
                                            padding: 20px;
                                        }

                                        .sidebar .nav-link {
                                            color: white;
                                            padding: 10px 15px;
                                            margin: 5px 0;
                                            border-radius: 5px;
                                            transition: all 0.3s;
                                        }

                                        .sidebar .nav-link:hover {
                                            background: #34495e;
                                        }

                                        .sidebar .nav-link i {
                                            margin-right: 10px;
                                        }

                                        .main-content {
                                            padding: 20px;
                                        }

                                        .card {
                                            border: none;
                                            border-radius: 10px;
                                            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                                            margin-bottom: 20px;
                                        }

                                        .card-header {
                                            background: #f8f9fa;
                                            border-bottom: none;
                                        }

                                        .stats-card {
                                            background: linear-gradient(45deg, #3498db, #2980b9);
                                            color: white;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="container-fluid">
                                        <div class="row">
                                            <!-- Sidebar -->
                                            <div class="col-md-3 col-lg-2 sidebar">
                                                <h3 class="mb-4">Quản lý phòng khám</h3>
                                                <nav class="nav flex-column">
                                                    <a class="nav-link active" href="manager_tongquan.jsp">
                                                        <i class="fas fa-home"></i> Tổng quan
                                                    </a>
                                                    <a class="nav-link" href="manager_users.jsp">
                                                        <i class="fas fa-users"></i> Quản lý người dùng
                                                    </a>
                                                    <a class="nav-link" href="manager_doctors.jsp">
                                                        <i class="fas fa-user-md"></i> Quản lý bác sĩ
                                                    </a>
                                                    <a class="nav-link" href="manager_staff.jsp">
                                                        <i class="fas fa-user-nurse"></i> Quản lý nhân viên
                                                    </a>
                                                    <a class="nav-link" href="manager_blogs.jsp">
                                                        <i class="fas fa-blog"></i> Kiểm duyệt blog y khoa
                                                    </a>
                                                    <a class="nav-link" href="manager_medicine.jsp">
                                                        <i class="fas fa-pills"></i> Quản lý kho thuốc
                                                    </a>
                                                </nav>
                                            </div>

                                            <!-- Main Content -->
                                            <div class="col-md-9 col-lg-10 main-content">
                                                <h2 class="mb-4">Tổng quan phòng khám</h2>

                                                <!-- Stats Cards -->
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="card stats-card">
                                                            <div class="card-body">
                                                                <h5 class="card-title">Tổng số bệnh nhân</h5>
                                                                <h2>150</h2>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="card stats-card">
                                                            <div class="card-body">
                                                                <h5 class="card-title">Bác sĩ</h5>
                                                                <h2>12</h2>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="card stats-card">
                                                            <div class="card-body">
                                                                <h5 class="card-title">Nhân viên</h5>
                                                                <h2>25</h2>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="card stats-card">
                                                            <div class="card-body">
                                                                <h5 class="card-title">Lượt khám hôm nay</h5>
                                                                <h2>45</h2>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Recent Activities -->
                                                <div class="card mt-4">
                                                    <div class="card-header">
                                                        <h5 class="mb-0">Hoạt động gần đây</h5>
                                                    </div>
                                                    <div class="card-body">
                                                        <ul class="list-group list-group-flush">
                                                            <li class="list-group-item">Bác sĩ Nguyễn Văn A đã cập nhật
                                                                hồ sơ bệnh nhân</li>
                                                            <li class="list-group-item">Nhân viên mới đã được thêm vào
                                                                hệ thống</li>
                                                            <li class="list-group-item">Blog y khoa mới đang chờ kiểm
                                                                duyệt</li>
                                                            <li class="list-group-item">Cập nhật kho thuốc thành công
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <script
                                        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                </body>

                                </html>