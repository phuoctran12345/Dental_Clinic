<%@page  pageEncoding="UTF-8" %>
    <%@ include file="/jsp/manager/manager_header.jsp" %>
        <%@ include file="/jsp/manager/manager_menu.jsp" %>
            <%@ page import="dao.DoctorDAO" %>
                <%@ page import="model.Doctor" %>
                    <%@ page import="java.util.List" %>

                        <% User user=(User) session.getAttribute("user"); if (user==null ||
                            !"MANAGER".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
                            List<Doctor> doctors = DoctorDAO.getAllDoctors();
                            %>

                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Quản lý bác sĩ</title>
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

                                    .doctor-avatar {
                                        width: 50px;
                                        height: 50px;
                                        border-radius: 50%;
                                        object-fit: cover;
                                    }

                                    .specialty-badge {
                                        background: #e3f2fd;
                                        color: #1976d2;
                                        padding: 5px 10px;
                                        border-radius: 15px;
                                        font-size: 0.8rem;
                                        margin: 2px;
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
                                                <a class="nav-link active" href="manager_doctors.jsp">
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
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h2>Quản lý bác sĩ</h2>
                                                <button class="btn btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#addDoctorModal">
                                                    <i class="fas fa-plus"></i> Thêm bác sĩ
                                                </button>
                                            </div>

                                            <!-- Search and Filter -->
                                            <div class="card mb-4">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="input-group">
                                                                <input type="text" class="form-control"
                                                                    placeholder="Tìm kiếm bác sĩ...">
                                                                <button class="btn btn-outline-secondary" type="button">
                                                                    <i class="fas fa-search"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select">
                                                                <option value="">Tất cả chuyên khoa</option>
                                                                <option value="INTERNAL">Nội khoa</option>
                                                                <option value="SURGERY">Ngoại khoa</option>
                                                                <option value="PEDIATRICS">Nhi khoa</option>
                                                                <option value="GYNECOLOGY">Sản phụ khoa</option>
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

                                            <!-- Doctors Grid -->
                                            <div class="row">
                                                <% for(Doctor doctor : doctors) { %>
                                                    <div class="col-md-6 col-lg-4 mb-4">
                                                        <div class="card h-100">
                                                            <div class="card-body">
                                                                <div class="d-flex align-items-center mb-3">
                                                                    <img src="<%= doctor.getAvatar() != null ? doctor.getAvatar() : "
                                                                        images/default-avatar.jpg" %>"
                                                                    class="doctor-avatar me-3" alt="Doctor Avatar">
                                                                    <div>
                                                                        <h5 class="card-title mb-0">
                                                                            <%= doctor.getName() %>
                                                                        </h5>
                                                                        <p class="text-muted mb-0">
                                                                            <%= doctor.getSpecialty() %>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <div class="specialty-badge d-inline-block">
                                                                        <i class="fas fa-graduation-cap"></i>
                                                                        <%= doctor.getDegree() %>
                                                                    </div>
                                                                    <div class="specialty-badge d-inline-block">
                                                                        <i class="fas fa-clock"></i>
                                                                        <%= doctor.getExperience() %> năm kinh nghiệm
                                                                    </div>
                                                                </div>
                                                                <p class="card-text">
                                                                    <i class="fas fa-envelope me-2"></i>
                                                                    <%= doctor.getEmail() %><br>
                                                                        <i class="fas fa-phone me-2"></i>
                                                                        <%= doctor.getPhone() %>
                                                                </p>
                                                                <div class="d-flex justify-content-between">
                                                                    <span class="badge bg-<%= 
                                        " ACTIVE".equals(doctor.getStatus()) ? "success" : "ON_LEAVE"
                                                                        .equals(doctor.getStatus()) ? "warning"
                                                                        : "danger" %>">
                                                                        <%= doctor.getStatus() %>
                                                                    </span>
                                                                    <div>
                                                                        <button class="btn btn-sm btn-info"
                                                                            title="Xem lịch">
                                                                            <i class="fas fa-calendar"></i>
                                                                        </button>
                                                                        <button class="btn btn-sm btn-warning"
                                                                            title="Chỉnh sửa">
                                                                            <i class="fas fa-edit"></i>
                                                                        </button>
                                                                        <button class="btn btn-sm btn-danger"
                                                                            title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Add Doctor Modal -->
                                <div class="modal fade" id="addDoctorModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Thêm bác sĩ mới</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Họ tên</label>
                                                            <input type="text" class="form-control" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" class="form-control" required>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Số điện thoại</label>
                                                            <input type="tel" class="form-control" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Chuyên khoa</label>
                                                            <select class="form-select" required>
                                                                <option value="INTERNAL">Nội khoa</option>
                                                                <option value="SURGERY">Ngoại khoa</option>
                                                                <option value="PEDIATRICS">Nhi khoa</option>
                                                                <option value="GYNECOLOGY">Sản phụ khoa</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Bằng cấp</label>
                                                            <input type="text" class="form-control" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Kinh nghiệm (năm)</label>
                                                            <input type="number" class="form-control" required>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Mô tả</label>
                                                        <textarea class="form-control" rows="3"></textarea>
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