<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ include file="/includes/manager_header.jsp" %>
        <%@ include file="/includes/manager_menu.jsp" %>
            <%@ page import="dao.StaffDAO" %>
                <%@ page import="model.Staff" %>
                    <%@ page import="java.util.List" %>

                        <% User user=(User) session.getAttribute("user"); if (user==null ||
                            !"MANAGER".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
                            List<Staff> staffList = StaffDAO.getAllStaff();
                            %>

                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Quản lý nhân viên</title>
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

                                    .staff-avatar {
                                        width: 40px;
                                        height: 40px;
                                        border-radius: 50%;
                                        object-fit: cover;
                                    }

                                    .department-badge {
                                        background: #e8f5e9;
                                        color: #2e7d32;
                                        padding: 5px 10px;
                                        border-radius: 15px;
                                        font-size: 0.8rem;
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
                                                <a class="nav-link" href="manager_tongquan.jsp">
                                                    <i class="fas fa-home"></i> Tổng quan
                                                </a>
                                                <a class="nav-link" href="manager_users.jsp">
                                                    <i class="fas fa-users"></i> Quản lý người dùng
                                                </a>
                                                <a class="nav-link" href="manager_doctors.jsp">
                                                    <i class="fas fa-user-md"></i> Quản lý bác sĩ
                                                </a>
                                                <a class="nav-link active" href="manager_staff.jsp">
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
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h2>Quản lý nhân viên</h2>
                                                <button class="btn btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#addStaffModal">
                                                    <i class="fas fa-plus"></i> Thêm nhân viên
                                                </button>
                                            </div>

                                            <!-- Search and Filter -->
                                            <div class="card mb-4">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="input-group">
                                                                <input type="text" class="form-control"
                                                                    placeholder="Tìm kiếm nhân viên...">
                                                                <button class="btn btn-outline-secondary" type="button">
                                                                    <i class="fas fa-search"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select">
                                                                <option value="">Tất cả phòng ban</option>
                                                                <option value="RECEPTION">Lễ tân</option>
                                                                <option value="NURSING">Điều dưỡng</option>
                                                                <option value="PHARMACY">Dược</option>
                                                                <option value="LABORATORY">Xét nghiệm</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select">
                                                                <option value="">Tất cả trạng thái</option>
                                                                <option value="ACTIVE">Đang làm việc</option>
                                                                <option value="ON_LEAVE">Nghỉ phép</option>
                                                                <option value="INACTIVE">Không hoạt động</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Staff Table -->
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Ảnh</th>
                                                                    <th>Họ tên</th>
                                                                    <th>Phòng ban</th>
                                                                    <th>Chức vụ</th>
                                                                    <th>Email</th>
                                                                    <th>Số điện thoại</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% for(Staff staff : staffList) { %>
                                                                    <tr>
                                                                        <td>
                                                                            <%= staff.getUserId() %>
                                                                        </td>
                                                                        <td>
                                                                            <img src="<%= staff.getAvatar() != null ? staff.getAvatar() : "
                                                                                images/default-avatar.jpg" %>"
                                                                            class="staff-avatar" alt="Staff Avatar">
                                                                        </td>
                                                                        <td>
                                                                            <%= staff.getName() %>
                                                                        </td>
                                                                        <td>
                                                                            <span class="department-badge">
                                                                                <%= staff.getDepartment() %>
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <%= staff.getPosition() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= staff.getEmail() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= staff.getPhone() %>
                                                                        </td>
                                                                        <td>
                                                                            <span class="badge bg-<%= 
                                                " ACTIVE".equals(staff.getStatus()) ? "success" : "ON_LEAVE"
                                                                                .equals(staff.getStatus()) ? "warning"
                                                                                : "danger" %>">
                                                                                <%= staff.getStatus() %>
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <button class="btn btn-sm btn-info"
                                                                                title="Xem chi tiết">
                                                                                <i class="fas fa-eye"></i>
                                                                            </button>
                                                                            <button class="btn btn-sm btn-warning"
                                                                                title="Chỉnh sửa">
                                                                                <i class="fas fa-edit"></i>
                                                                            </button>
                                                                            <button class="btn btn-sm btn-danger"
                                                                                title="Xóa">
                                                                                <i class="fas fa-trash"></i>
                                                                            </button>
                                                                        </td>
                                                                    </tr>
                                                                    <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Add Staff Modal -->
                                <div class="modal fade" id="addStaffModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Thêm nhân viên mới</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form>
                                                    <div class="mb-3">
                                                        <label class="form-label">Họ tên</label>
                                                        <input type="text" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Email</label>
                                                        <input type="email" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Số điện thoại</label>
                                                        <input type="tel" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Phòng ban</label>
                                                        <select class="form-select" required>
                                                            <option value="RECEPTION">Lễ tân</option>
                                                            <option value="NURSING">Điều dưỡng</option>
                                                            <option value="PHARMACY">Dược</option>
                                                            <option value="LABORATORY">Xét nghiệm</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Chức vụ</label>
                                                        <input type="text" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Mật khẩu</label>
                                                        <input type="password" class="form-control" required>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-primary">Thêm</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            </body>

                            </html>