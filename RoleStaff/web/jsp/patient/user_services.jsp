<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jsp/patient/user_header.jsp" %>
<%@ include file="/jsp/patient/user_menu.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dịch vụ y tế - Phòng khám nha khoa</title>


        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
              rel="stylesheet">
<style>
body {
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #EFF6FF;
    color: #374151;
    line-height: 1.6;
    overflow-x: hidden;
}

.header-container {
    background-color: #FFFFFF;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    padding: 20px 0;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
}

.user-menu {
    position: fixed;
    top: 70px; /* Adjusted to start below header, assuming header height is ~70px */
    left: 0;
    width: 250px; /* Assuming menu width is ~250px */
    background-color: #FFFFFF;
    padding: 20px 0;
    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
    height: calc(100vh - 70px); /* Full height minus header */
    overflow-y: auto;
    z-index: 1000;
}

.user-menu button {
    display: flex;
    align-items: center;
    width: 100%;
    padding: 10px 20px;
    margin: 5px 0;
    border: none;
    border-radius: 6px;
    background: #F3F4F6;
    color: #4E80EE;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
}

.user-menu button:hover {
    background: #E5E7EB;
}

.main-content {
    margin-left: 260px; /* Slightly more than menu width to avoid overlap */
    margin-top: 90px; /* Adjusted to clear header height */
    padding: 20px;
    min-height: calc(100vh - 90px); /* Ensure content takes full height minus header */
}

.welcome-message {
    background-color: #FFFFFF;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    margin-bottom: 20px;
    text-align: center;
}

.welcome-message h2 {
    color: #4E80EE;
    font-size: 1.5rem;
    margin: 0 0 10px;
}

.welcome-message p {
    color: #6B7280;
    font-size: 0.875rem;
    margin: 0;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .user-menu {
        position: absolute;
        top: 70px;
        left: 0;
        width: 200px;
        height: auto;
        z-index: 1000;
    }
    .main-content {
        margin-left: 210px;
        margin-top: 90px;
    }
}

@media (max-width: 576px) {
    .user-menu {
        width: 180px;
    }
    .main-content {
        margin-left: 190px;
        margin-top: 70px; /* Reduced if header height is less on mobile */
    }
}
</style>
    </head>

    <body>
        <!-- Header Banner -->
        <div class="header-banner">
            <div class="container text-center">
                <h1 class="display-4 mb-3">
                    <i class="fas fa-tooth me-3"></i>
                    Dịch vụ nha khoa
                </h1>
                <p class="lead">Chăm sóc răng miệng toàn diện với đội ngũ bác sĩ chuyên nghiệp</p>
            </div>
        </div>

        <div class="container">
            <!-- Search & Filter Section -->
            <div class="search-box">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-primary text-white">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" id="searchInput"
                                   placeholder="Tìm kiếm dịch vụ...">
                        </div>
                    </div>
                    <div class="col-md-4 text-end mt-3 mt-md-0">
                        <button class="btn btn-outline-primary me-2" onclick="showAllServices()">
                            <i class="fas fa-list me-1"></i> Tất cả
                        </button>
                        <button class="btn btn-primary" onclick="resetSearch()">
                            <i class="fas fa-refresh me-1"></i> Làm mới
                        </button>
                    </div>
                </div>

                <!-- Category Filter -->
                <div class="category-filter mt-3">
                    <h6 class="mb-3"><i class="fas fa-filter me-2"></i>Lọc theo danh mục:</h6>
                    <button class="btn btn-outline-secondary category-btn active" data-category="">
                        Tất cả
                    </button>
                    <c:forEach var="category" items="${categories}">
                        <button class="btn btn-outline-primary category-btn"
                                data-category="${category}">
                            ${category}
                        </button>
                    </c:forEach>
                </div>
            </div>

            <!-- Services Grid -->
            <div class="row" id="servicesContainer">
                <c:forEach var="service" items="${services}">
                    <div class="col-lg-4 col-md-6 mb-4 service-item" data-category="${service.category}"
                         data-name="${service.serviceName}">
                        <div class="card service-card h-100">
                            <c:choose>
                                <c:when test="${not empty service.image}">
                                    <img src="${service.image}" class="card-img-top service-image"
                                         alt="${service.serviceName}">
                                </c:when>
                                <c:otherwise>
                                    <div
                                        class="service-image bg-light d-flex align-items-center justify-content-center">
                                        <i class="fas fa-tooth fa-4x text-muted"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="card-body d-flex flex-column">
                                <div class="mb-2">
                                    <span class="service-category">${service.category}</span>
                                </div>
                                <h5 class="card-title">${service.serviceName}</h5>
                                <p class="card-text flex-grow-1">
                                    <c:choose>
                                        <c:when test="${not empty service.description}">
                                            ${service.description}
                                        </c:when>
                                        <c:otherwise>
                                            <i class="text-muted">Chưa có mô tả chi tiết</i>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="mt-auto">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="price-tag">
                                            <fmt:formatNumber value="${service.price}" type="number"
                                                              groupingUsed="true" /> VNĐ
                                        </span>
                                        <button class="btn btn-primary btn-sm view-detail-btn"
                                                data-service-id="${service.serviceId}">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- No Results Message -->
            <div id="noResults" class="text-center py-5" style="display: none;">
                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">Không tìm thấy dịch vụ nào</h4>
                <p class="text-muted">Vui lòng thử tìm kiếm với từ khóa khác</p>
            </div>

            <!-- Back to Home -->
            <div class="text-center mt-5 mb-4">
                <a href="UserHompageServlet" class="btn btn-outline-primary">
                    <i class="fas fa-home me-2"></i>Về trang chủ
                </a>
            </div>
        </div>

        <!-- Service Detail Modal -->
        <div class="modal fade" id="serviceDetailModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-info-circle me-2"></i>Chi tiết dịch vụ
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="serviceDetailContent">
                        <div class="text-center">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Đang tải...</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary" onclick="bookService()">
                            <i class="fas fa-calendar-plus me-1"></i>Đặt lịch khám
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            let currentServiceId = null;

                            // Search functionality
                            document.getElementById('searchInput').addEventListener('input', function () {
                                const searchTerm = this.value.toLowerCase();
                                filterServices(searchTerm, '');
                            });

                            // Category filter
                            document.querySelectorAll('.category-btn').forEach(btn => {
                                btn.addEventListener('click', function () {
                                    // Update active state
                                    document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                                    this.classList.add('active');

                                    const category = this.dataset.category;
                                    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                                    filterServices(searchTerm, category);
                                });
                            });

                            function filterServices(searchTerm, category) {
                                const serviceItems = document.querySelectorAll('.service-item');
                                let visibleCount = 0;

                                serviceItems.forEach(item => {
                                    const serviceName = item.dataset.name.toLowerCase();
                                    const serviceCategory = item.dataset.category;

                                    const matchesSearch = searchTerm === '' || serviceName.includes(searchTerm);
                                    const matchesCategory = category === '' || serviceCategory === category;

                                    if (matchesSearch && matchesCategory) {
                                        item.style.display = 'block';
                                        visibleCount++;
                                    } else {
                                        item.style.display = 'none';
                                    }
                                });

                                // Show/hide no results message
                                document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
                            }

                            function showAllServices() {
                                document.getElementById('searchInput').value = '';
                                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                                document.querySelector('.category-btn[data-category=""]').classList.add('active');
                                filterServices('', '');
                            }

                            function resetSearch() {
                                showAllServices();
                            }

                            function viewServiceDetail(serviceId) {
                                currentServiceId = serviceId;
                                const modal = new bootstrap.Modal(document.getElementById('serviceDetailModal'));

                                // Show loading
                                document.getElementById('serviceDetailContent').innerHTML = `
<div class="text-center">
    <div class="spinner-border" role="status">
        <span class="visually-hidden">Đang tải...</span>
    </div>
</div>
`;

                                modal.show();

                                // Load service detail
                                fetch('/RoleStaff/services?action=detail&id=' + serviceId + '&format=json')
                                        .then(response => response.json())
                                        .then(service => {
                                            document.getElementById('serviceDetailContent').innerHTML =
                                                    '<div class="row">' +
                                                    '<div class="col-md-4">' +
                                                    (service.image ?
                                                            '<img src="' + service.image + '" class="img-fluid rounded" alt="' + service.serviceName + '">' :
                                                            '<div class="bg-light p-5 text-center rounded">' +
                                                            '<i class="fas fa-tooth fa-4x text-muted"></i>' +
                                                            '</div>'
                                                            ) +
                                                    '</div>' +
                                                    '<div class="col-md-8">' +
                                                    '<h4 class="text-primary">' +
                                                    '<i class="fas fa-tooth me-2"></i>' + service.serviceName +
                                                    '</h4>' +
                                                    '<div class="mb-3">' +
                                                    '<span class="badge bg-primary fs-6">' + service.category + '</span>' +
                                                    '</div>' +
                                                    '<div class="service-details">' +
                                                    '<div class="detail-item mb-3">' +
                                                    '<h6 class="text-secondary mb-1">' +
                                                    '<i class="fas fa-info-circle me-1"></i>Mô tả dịch vụ:' +
                                                    '</h6>' +
                                                    '<p class="mb-0">' + (service.description || 'Chưa có mô tả chi tiết') + '</p>' +
                                                    '</div>' +
                                                    '<div class="detail-item mb-3">' +
                                                    '<h6 class="text-secondary mb-1">' +
                                                    '<i class="fas fa-dollar-sign me-1"></i>Giá dịch vụ:' +
                                                    '</h6>' +
                                                    '<span class="text-success fs-4 fw-bold">' +
                                                    new Intl.NumberFormat('vi-VN').format(service.price) + ' VNĐ' +
                                                    '</span>' +
                                                    '</div>' +
                                                    '<div class="detail-item mb-3">' +
                                                    '<h6 class="text-secondary mb-1">' +
                                                    '<i class="fas fa-check-circle me-1"></i>Trạng thái:' +
                                                    '</h6>' +
                                                    '<span class="badge bg-success fs-6">Đang hoạt động</span>' +
                                                    '</div>' +
                                                    '<div class="detail-item mb-3">' +
                                                    '<h6 class="text-secondary mb-1">' +
                                                    '<i class="fas fa-clock me-1"></i>Thời gian thực hiện:' +
                                                    '</h6>' +
                                                    '<span>30-60 phút (tùy theo tình trạng)</span>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '<div class="alert alert-info mt-3">' +
                                                    '<h6 class="mb-2">' +
                                                    '<i class="fas fa-lightbulb me-1"></i>Lưu ý quan trọng:' +
                                                    '</h6>' +
                                                    '<ul class="mb-0 small">' +
                                                    '<li>Vui lòng đến đúng giờ hẹn</li>' +
                                                    '<li>Mang theo CMND/CCCD khi đến khám</li>' +
                                                    '<li>Thanh toán trước khi thực hiện dịch vụ</li>' +
                                                    '<li>Có thể hủy lịch trước 24h</li>' +
                                                    '</ul>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '</div>';

                                            // Update modal footer buttons
                                            const modalFooter = document.querySelector('#serviceDetailModal .modal-footer');
                                            modalFooter.innerHTML = `
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
            <i class="fas fa-times me-1"></i>Đóng
        </button>
        <button type="button" class="btn btn-outline-primary" onclick="bookServiceWithDoctor()">
            <i class="fas fa-user-md me-1"></i>Chọn bác sĩ trước
        </button>
        <button type="button" class="btn btn-success" onclick="bookServiceDirect()">
            <i class="fas fa-calendar-plus me-1"></i>Chọn bác sĩ và đặt lịch
        </button>
    `;
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            document.getElementById('serviceDetailContent').innerHTML = `
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle me-2"></i>
            Không thể tải thông tin dịch vụ. Vui lòng thử lại.
        </div>
    `;
                                        });
                            }

                            function bookService() {
                                bookServiceWithDoctor();
                            }

                            function bookServiceDirect() {
                                if (currentServiceId) {
                                    // THAY ĐỔI: Chuyển đến trang chọn bác sĩ thay vì thanh toán trực tiếp
                                    window.location.href = 'BookingPageServlet?serviceId=' + currentServiceId;
                                }
                            }

                            function bookServiceWithDoctor() {
                                if (currentServiceId) {
                                    // Redirect to booking page to select doctor first
                                    window.location.href = 'BookingPageServlet?serviceId=' + currentServiceId;
                                }
                            }

                            // Initialize tooltips if needed
                            document.addEventListener('DOMContentLoaded', function () {
                                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                });

                                // Add event listeners for view detail buttons
                                document.querySelectorAll('.view-detail-btn').forEach(button => {
                                    button.addEventListener('click', function () {
                                        const serviceId = this.getAttribute('data-service-id');
                                        viewServiceDetail(serviceId);
                                    });
                                });
                            });
        </script>
    </body>

</html>