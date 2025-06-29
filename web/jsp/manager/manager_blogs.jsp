<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/includes/manager_header.jsp" %>
<%@ include file="/includes/manager_menu.jsp" %>
<%@ page import="dao.BlogDAO" %>
<%@ page import="model.Blog" %>
<%@ page import="java.util.List" %>

<% 
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Blog> blogs = BlogDAO.getAllBlogs();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiểm duyệt blog y khoa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
        .blog-image {
            width: 100px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        .blog-content {
            max-height: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .status-badge {
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
                    <a class="nav-link" href="manager_staff.jsp">
                        <i class="fas fa-user-nurse"></i> Quản lý nhân viên
                    </a>
                    <a class="nav-link active" href="manager_blogs.jsp">
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
                    <h2>Kiểm duyệt blog y khoa</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBlogModal">
                        <i class="fas fa-plus"></i> Thêm blog mới
                    </button>
                </div>

                <!-- Search and Filter -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Tìm kiếm blog...">
                                    <button class="btn btn-outline-secondary" type="button">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select">
                                    <option value="">Tất cả danh mục</option>
                                    <option value="HEALTH_TIPS">Mẹo sức khỏe</option>
                                    <option value="DISEASE_INFO">Thông tin bệnh</option>
                                    <option value="NUTRITION">Dinh dưỡng</option>
                                    <option value="MEDICAL_NEWS">Tin tức y tế</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="PENDING">Chờ duyệt</option>
                                    <option value="APPROVED">Đã duyệt</option>
                                    <option value="REJECTED">Từ chối</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Blogs Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Ảnh</th>
                                        <th>Tiêu đề</th>
                                        <th>Tác giả</th>
                                        <th>Danh mục</th>
                                        <th>Ngày đăng</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(Blog blog : blogs) { %>
                                    <tr>
                                        <td><%= blog.getId() %></td>
                                        <td>
                                            <img src="<%= blog.getImage() != null ? blog.getImage() : "images/default-blog.jpg" %>" 
                                                 class="blog-image" alt="Blog Image">
                                        </td>
                                        <td>
                                            <div class="fw-bold"><%= blog.getTitle() %></div>
                                            <div class="blog-content text-muted"><%= blog.getContent() %></div>
                                        </td>
                                        <td><%= blog.getAuthor() %></td>
                                        <td>
                                            <span class="badge bg-info">
                                                <%= blog.getCategory() %>
                                            </span>
                                        </td>
                                        <td><%= blog.getCreatedAt() %></td>
                                        <td>
                                            <span class="status-badge bg-<%= 
                                                "PENDING".equals(blog.getStatus()) ? "warning" :
                                                "APPROVED".equals(blog.getStatus()) ? "success" : "danger"
                                            %>">
                                                <%= blog.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-info" title="Xem chi tiết" data-bs-toggle="modal" data-bs-target="#viewBlogModal">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" title="Duyệt" <%= "APPROVED".equals(blog.getStatus()) ? "disabled" : "" %>>
                                                <i class="fas fa-check"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" title="Từ chối" <%= "REJECTED".equals(blog.getStatus()) ? "disabled" : "" %>>
                                                <i class="fas fa-times"></i>
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

    <!-- Add Blog Modal -->
    <div class="modal fade" id="addBlogModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm blog mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Danh mục</label>
                            <select class="form-select" required>
                                <option value="HEALTH_TIPS">Mẹo sức khỏe</option>
                                <option value="DISEASE_INFO">Thông tin bệnh</option>
                                <option value="NUTRITION">Dinh dưỡng</option>
                                <option value="MEDICAL_NEWS">Tin tức y tế</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nội dung</label>
                            <textarea class="form-control" rows="10" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ảnh bìa</label>
                            <input type="file" class="form-control" accept="image/*">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary">Thêm</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Blog Modal -->
    <div class="modal fade" id="viewBlogModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết blog</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <img src="images/blog-detail.jpg" class="img-fluid rounded" alt="Blog Image">
                    </div>
                    <h3 class="mb-3">Tiêu đề blog</h3>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Tác giả: Nguyễn Văn A</span>
                        <span class="text-muted">Ngày đăng: 01/01/2024</span>
                    </div>
                    <div class="mb-3">
                        <span class="badge bg-info">Mẹo sức khỏe</span>
                    </div>
                    <div class="blog-content">
                        Nội dung blog chi tiết...
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success">Duyệt</button>
                    <button type="button" class="btn btn-danger">Từ chối</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 