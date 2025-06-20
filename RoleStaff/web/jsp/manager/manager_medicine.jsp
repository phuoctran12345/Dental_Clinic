<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ include file="/includes/manager_header.jsp" %>
        <%@ include file="/includes/manager_menu.jsp" %>
            <%@ page import="dao.MedicineDAO" %>
                <%@ page import="model.Medicine" %>
                    <%@ page import="java.util.List" %>

                        <% User user=(User) session.getAttribute("user"); if (user==null ||
                            !"MANAGER".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
                            List<Medicine> medicines = MedicineDAO.getAllMedicines();
                            %>

                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Quản lý kho thuốc</title>
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

                                    .medicine-image {
                                        width: 60px;
                                        height: 60px;
                                        object-fit: cover;
                                        border-radius: 5px;
                                    }

                                    .stock-badge {
                                        padding: 5px 10px;
                                        border-radius: 15px;
                                        font-size: 0.8rem;
                                    }

                                    .stock-warning {
                                        background: #fff3e0;
                                        color: #e65100;
                                    }

                                    .stock-normal {
                                        background: #e8f5e9;
                                        color: #2e7d32;
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
                                                <a class="nav-link" href="manager_staff.jsp">
                                                    <i class="fas fa-user-nurse"></i> Quản lý nhân viên
                                                </a>
                                                <a class="nav-link" href="manager_blogs.jsp">
                                                    <i class="fas fa-blog"></i> Kiểm duyệt blog y khoa
                                                </a>
                                                <a class="nav-link active" href="manager_medicine.jsp">
                                                    <i class="fas fa-pills"></i> Quản lý kho thuốc
                                                </a>
                                            </nav>
                                        </div>

                                        <!-- Main Content -->
                                        <div class="col-md-9 col-lg-10 main-content">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h2>Quản lý kho thuốc</h2>
                                                <div>
                                                    <button class="btn btn-success me-2" data-bs-toggle="modal"
                                                        data-bs-target="#importMedicineModal">
                                                        <i class="fas fa-file-import"></i> Nhập thuốc
                                                    </button>
                                                    <button class="btn btn-primary" data-bs-toggle="modal"
                                                        data-bs-target="#addMedicineModal">
                                                        <i class="fas fa-plus"></i> Thêm thuốc mới
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Stats Cards -->
                                            <div class="row mb-4">
                                                <div class="col-md-3">
                                                    <div class="card bg-primary text-white">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Tổng số thuốc</h5>
                                                            <h2>150</h2>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="card bg-success text-white">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Thuốc trong kho</h5>
                                                            <h2>120</h2>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="card bg-warning text-white">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Sắp hết hàng</h5>
                                                            <h2>20</h2>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="card bg-danger text-white">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Hết hàng</h5>
                                                            <h2>10</h2>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Search and Filter -->
                                            <div class="card mb-4">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="input-group">
                                                                <input type="text" class="form-control"
                                                                    placeholder="Tìm kiếm thuốc...">
                                                                <button class="btn btn-outline-secondary" type="button">
                                                                    <i class="fas fa-search"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select">
                                                                <option value="">Tất cả loại thuốc</option>
                                                                <option value="ANTIBIOTIC">Kháng sinh</option>
                                                                <option value="PAINKILLER">Giảm đau</option>
                                                                <option value="VITAMIN">Vitamin</option>
                                                                <option value="OTHER">Khác</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select">
                                                                <option value="">Tất cả trạng thái</option>
                                                                <option value="IN_STOCK">Còn hàng</option>
                                                                <option value="LOW_STOCK">Sắp hết</option>
                                                                <option value="OUT_OF_STOCK">Hết hàng</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Medicines Table -->
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Ảnh</th>
                                                                    <th>Tên thuốc</th>
                                                                    <th>Loại</th>
                                                                    <th>Đơn vị</th>
                                                                    <th>Số lượng</th>
                                                                    <th>Giá</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% for(Medicine medicine : medicines) { %>
                                                                    <tr>
                                                                        <td>
                                                                            <%= medicine.getId() %>
                                                                        </td>
                                                                        <td>
                                                                            <img src="<%= medicine.getImage() != null ? medicine.getImage() : "
                                                                                images/default-medicine.jpg" %>"
                                                                            class="medicine-image" alt="Medicine Image">
                                                                        </td>
                                                                        <td>
                                                                            <div class="fw-bold">
                                                                                <%= medicine.getName() %>
                                                                            </div>
                                                                            <small class="text-muted">
                                                                                <%= medicine.getDescription() %>
                                                                            </small>
                                                                        </td>
                                                                        <td>
                                                                            <%= medicine.getType() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= medicine.getUnit() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= medicine.getQuantity() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= medicine.getPrice() %> VNĐ
                                                                        </td>
                                                                        <td>
                                                                            <span class="stock-badge <%= 
                                                medicine.getQuantity() <= 0 ? " bg-danger" : medicine.getQuantity()
                                                                                <=10 ? "stock-warning" : "stock-normal"
                                                                                %>">
                                                                                <%= medicine.getQuantity() <=0
                                                                                    ? "Hết hàng" :
                                                                                    medicine.getQuantity() <=10
                                                                                    ? "Sắp hết" : "Còn hàng" %>
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

                                <!-- Add Medicine Modal -->
                                <div class="modal fade" id="addMedicineModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Thêm thuốc mới</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form>
                                                    <div class="mb-3">
                                                        <label class="form-label">Tên thuốc</label>
                                                        <input type="text" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Loại thuốc</label>
                                                        <select class="form-select" required>
                                                            <option value="ANTIBIOTIC">Kháng sinh</option>
                                                            <option value="PAINKILLER">Giảm đau</option>
                                                            <option value="VITAMIN">Vitamin</option>
                                                            <option value="OTHER">Khác</option>
                                                        </select>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Số lượng</label>
                                                            <input type="number" class="form-control" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Đơn vị</label>
                                                            <input type="text" class="form-control" required>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Giá</label>
                                                        <input type="number" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Mô tả</label>
                                                        <textarea class="form-control" rows="3"></textarea>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Ảnh thuốc</label>
                                                        <input type="file" class="form-control" accept="image/*">
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

                                <!-- Import Medicine Modal -->
                                <div class="modal fade" id="importMedicineModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Nhập thuốc</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form>
                                                    <div class="mb-3">
                                                        <label class="form-label">Chọn thuốc</label>
                                                        <select class="form-select" required>
                                                            <option value="">Chọn thuốc cần nhập</option>
                                                            <% for(Medicine medicine : medicines) { %>
                                                                <option value="<%= medicine.getId() %>">
                                                                    <%= medicine.getName() %>
                                                                </option>
                                                                <% } %>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Số lượng nhập</label>
                                                        <input type="number" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Ngày nhập</label>
                                                        <input type="date" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Nhà cung cấp</label>
                                                        <input type="text" class="form-control" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Ghi chú</label>
                                                        <textarea class="form-control" rows="3"></textarea>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-success">Nhập thuốc</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            </body>

                            </html>