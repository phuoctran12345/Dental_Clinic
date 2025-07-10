<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="dao.StaffDAO, dao.DoctorDAO, model.Staff, model.Doctors, java.util.List, java.util.logging.Logger, java.util.logging.Level" %>
<%! private static final Logger LOGGER = Logger.getLogger("manager_danhsach.jsp");%>
<%@ include file="manager_menu.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý danh sách nhân viên</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
            }
            .container {
                margin-left: 250px;
                padding: 20px;
            }
            .header {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .header h1 {
                color: #333;
                margin-bottom: 10px;
            }
            .header p {
                color: #666;
            }
            .actions {
                margin-bottom: 20px;
            }
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                margin-right: 10px;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary {
                background-color: #007bff;
                color: white;
            }
            .btn-warning {
                background-color: #ffc107;
                color: #212529;
            }
            .btn-danger {
                background-color: #dc3545;
                color: white;
            }
            .btn:hover {
                opacity: 0.8;
            }
            .btn-sm {
                padding: 5px 10px;
                font-size: 12px;
                margin-right: 5px;
            }

            /* Search box styles */
            .search-container {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .search-box {
                position: relative;
                max-width: 400px;
            }
            .search-box input {
                width: 100%;
                padding: 12px 20px 12px 45px;
                border: 2px solid #e9ecef;
                border-radius: 25px;
                font-size: 14px;
                background-color: #f8f9fa;
                transition: all 0.3s ease;
            }
            .search-box input:focus {
                outline: none;
                border-color: #007bff;
                background-color: white;
                box-shadow: 0 0 0 3px rgba(0,123,255,0.1);
            }
            .search-box i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
                font-size: 16px;
            }
            .search-results-info {
                margin-top: 10px;
                color: #666;
                font-size: 14px;
            }

            /* Tab styles */
            .tab-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }
            .tab-buttons {
                display: flex;
                background-color: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
            }
            .tab-button {
                flex: 1;
                padding: 15px 20px;
                background: none;
                border: none;
                cursor: pointer;
                font-size: 16px;
                font-weight: 500;
                color: #666;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: all 0.3s;
            }
            .tab-button.active {
                background-color: #007bff;
                color: white;
            }
            .tab-button:hover:not(.active) {
                background-color: #e9ecef;
            }
            .tab-count {
                background-color: rgba(255,255,255,0.2);
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }
            .tab-button.active .tab-count {
                background-color: rgba(255,255,255,0.3);
            }
            .tab-content {
                display: none;
            }
            .tab-content.active {
                display: block;
            }

            .table-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #333;
            }
            tr:hover {
                background-color: #f8f9fa;
            }
            .role-badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: 500;
            }
            .role-doctor {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .role-staff {
                background-color: #f3e5f5;
                color: #7b1fa2;
            }
            .status-active {
                color: #28a745;
            }
            .status-inactive {
                color: #dc3545;
            }
            .action-buttons {
                display: flex;
                gap: 5px;
                flex-wrap: wrap;
            }
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
            }
            .modal-content {
                background-color: white;
                margin: 5% auto;
                padding: 20px;
                border-radius: 10px;
                width: 80%;
                max-width: 600px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }
            .modal-actions {
                text-align: right;
                margin-top: 20px;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
            }
            .close:hover {
                color: #000;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            .empty-state {
                text-align: center;
                padding: 40px;
                color: #666;
            }
            .empty-state i {
                font-size: 48px;
                margin-bottom: 15px;
                color: #ddd;
            }
            .no-results {
                text-align: center;
                padding: 40px;
                color: #666;
            }
            .no-results i {
                font-size: 48px;
                margin-bottom: 15px;
                color: #ddd;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-users"></i> Quản lý danh sách nhân viên</h1>
                <p>Quản lý thông tin tài khoản nhân viên và bác sĩ trong hệ thống</p>
            </div>

            <!-- Thông báo -->
            <%
                String successMessage = (String) request.getAttribute("successMessage");
                if (successMessage != null) {
            %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= successMessage%>
            </div>
            <%
                }
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <%= errorMessage%>
            </div>
            <%
                }
            %>

            <%
                List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
                List<Doctors> doctorList = (List<Doctors>) request.getAttribute("doctorList");

                List<Staff> staffData = null;
                List<Doctors> doctorData = null;

                try {
                    StaffDAO staffDAO = new StaffDAO();
                    DoctorDAO doctorDAO = new DoctorDAO();
                    staffData = (staffList != null) ? staffList : staffDAO.getAllStaff();
                    doctorData = (doctorList != null) ? doctorList : doctorDAO.getAllDoctors();
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách nhân viên/bác sĩ: ", e);
                    request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải danh sách nhân viên/bác sĩ.");
                    staffData = java.util.Collections.emptyList();
                    doctorData = java.util.Collections.emptyList();
                }

                int doctorCount = doctorData != null ? doctorData.size() : 0;
                int staffCount = staffData != null ? staffData.size() : 0;
            %>

            <div class="actions">
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Thêm nhân viên
                </button>
            </div>

            <!-- Search Container -->
            <div class="search-container">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên hoặc số điện thoại..." onkeyup="searchStaff()">
                </div>
                <div class="search-results-info" id="searchResultsInfo"></div>
            </div>

            <!-- Tab Container -->
            <div class="tab-container">
                <div class="tab-buttons">
                    <button class="tab-button active" onclick="switchTab('doctors')">
                        <i class="fas fa-user-md"></i>
                        Bác sĩ
                        <span class="tab-count" id="doctorCount"><%= doctorCount%></span>
                    </button>
                    <button class="tab-button" onclick="switchTab('staff')">
                        <i class="fas fa-users"></i>
                        Nhân viên
                        <span class="tab-count" id="staffCount"><%= staffCount%></span>
                    </button>
                </div>
            </div>

            <!-- Doctors Tab Content -->
            <div id="doctors-tab" class="tab-content active">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Chuyên khoa</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="doctorsTableBody">
                            <%
                                if (doctorData.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <i class="fas fa-user-md"></i>
                                        <p>Chưa có bác sĩ nào trong hệ thống</p>
                                    </div>
                                </td>
                            </tr>
                            <%
                            } else {
                                for (Doctors doctor : doctorData) {
                            %>
                            <tr class="doctor-row" data-name="<%= doctor.getFull_name() != null ? doctor.getFull_name().toLowerCase() : ""%>" data-phone="<%= doctor.getPhone() != null ? doctor.getPhone() : ""%>">
                                <td><%= doctor.getFull_name() != null ? doctor.getFull_name() : "N/A"%></td>
                                <td><%= doctor.getUserEmail() != null ? doctor.getUserEmail() : "N/A"%></td>
                                <td><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A"%></td>
                                <td><%= doctor.getSpecialty() != null ? doctor.getSpecialty() : "N/A"%></td>
                                <td><span class="status-<%= doctor.getStatus() != null && doctor.getStatus().equals("active") ? "active" : "inactive"%>">
                                        <%= doctor.getStatus() != null && doctor.getStatus().equals("active") ? "Hoạt động" : "Không hoạt động"%>
                                    </span></td>
                                <td><% if (doctor.getCreated_at() != null) {%><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(doctor.getCreated_at())%><% } else { %>N/A<% }%></td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-warning btn-sm" onclick="resetDoctorPassword(<%= doctor.getDoctor_id()%>)" title="Reset mật khẩu">
                                            <i class="fas fa-key"></i> Reset
                                        </button>
                                        <button class="btn btn-danger btn-sm" onclick="deleteDoctor(<%= doctor.getDoctor_id()%>)" title="Xóa tài khoản">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Staff Tab Content -->
            <div id="staff-tab" class="tab-content">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Chức vụ</th>
                                <th>Loại hợp đồng</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="staffTableBody">
                            <%
                                if (staffData.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <i class="fas fa-users"></i>
                                        <p>Chưa có nhân viên nào trong hệ thống</p>
                                    </div>
                                </td>
                            </tr>
                            <%
                            } else {
                                for (Staff staff : staffData) {
                            %>
                            <tr class="staff-row" data-name="<%= staff.getFullName() != null ? staff.getFullName().toLowerCase() : ""%>" data-phone="<%= staff.getPhone() != null ? staff.getPhone() : ""%>">
                                <td><%= staff.getFullName() != null ? staff.getFullName() : "N/A"%></td>
                                <td><%= staff.getUserEmail() != null ? staff.getUserEmail() : "N/A"%></td>
                                <td><%= staff.getPhone() != null ? staff.getPhone() : "N/A"%></td>
                                <td><%= staff.getPosition() != null ? staff.getPosition() : "N/A"%></td>
                                <td>
                                    <%
                                        String empType = staff.getEmploymentType();
                                        if ("fulltime".equalsIgnoreCase(empType)) {
                                            out.print("Toàn thời gian");
                                        } else if ("parttime".equalsIgnoreCase(empType)) {
                                            out.print("Bán thời gian");
                                        } else {
                                            out.print("Chưa chọn");
                                        }
                                    %>
                                </td>
                                <td><% if (staff.getCreatedAt() != null) {%><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(staff.getCreatedAt())%><% } else { %>N/A<% }%></td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-warning btn-sm" onclick="resetStaffPassword(<%= staff.getStaffId()%>)" title="Reset mật khẩu">
                                            <i class="fas fa-key"></i> Reset
                                        </button>
                                        <button class="btn btn-danger btn-sm" onclick="deleteStaff(<%= staff.getStaffId()%>)" title="Xóa tài khoản">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal thêm nhân viên -->
        <div id="addModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">×</span>
                <h2>Thêm nhân viên mới</h2>
                <form id="addStaffForm" action="${pageContext.request.contextPath}/AddStaffServlet" method="POST">
                    <div class="form-group">
                        <label for="fullName">Họ tên:</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại:</label>
                        <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" required title="Số điện thoại phải có 10 chữ số">
                    </div>
                    <div class="form-group">
                        <label for="role">Vai trò:</label>
                        <select id="role" name="role" required>
                            <option value="">Chọn vai trò</option>
                            <option value="STAFF">Nhân viên</option>
                            <option value="DOCTOR">Bác sĩ</option>
                        </select>
                    </div>
                    <div class="form-group" id="positionGroup">
                        <label for="position">Chuyên khoa:</label>
                        <select id="position" name="position" class="form-control">
                            <option value="">Loại chuyên khoa</option>
                            <option value="Răng – Hàm – Mặt tổng quát">Răng – Hàm – Mặt tổng quát</option>
                            <option value="Nội nha (Endodontics)">Nội nha (Endodontics)</option>
                            <option value="Chỉnh nha (Orthodontics)">Chỉnh nha (Orthodontics)</option>
                            <option value="Phẫu thuật Răng – Hàm – Mặt">Phẫu thuật Răng – Hàm – Mặt</option>
                            <option value="Phục hình răng (Prosthodontics)">Phục hình răng (Prosthodontics)</option>
                            <option value="Nha khoa thẩm mỹ (Cosmetic Dentistry)">Nha khoa thẩm mỹ (Cosmetic Dentistry)</option>
                        </select>
                    </div>
                    <div class="form-group" id="staffPositionGroup" style="display: none;">
                        <label for="staffPosition">Chức vụ:</label>
                        <input type="text" id="staffPosition" name="staffPosition" placeholder="Nhập chức vụ">
                    </div>
                    <div class="form-group" id="employmentTypeGroup">
                        <label for="employmentType">Loại hợp đồng (chỉ áp dụng cho Nhân viên):</label>
                        <select id="employmentType" name="employmentType">
                            <option value="">Loại hợp đồng</option>
                            <option value="fulltime">Fulltime</option>
                            <option value="parttime">Parttime</option>
                        </select>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeModal()">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            let originalDoctorCount = <%= doctorCount%>;
            let originalStaffCount = <%= staffCount%>;

            function switchTab(tabName) {
                // Hide all tab contents
                document.querySelectorAll('.tab-content').forEach(tab => {
                    tab.classList.remove('active');
                });

                // Remove active class from all buttons
                document.querySelectorAll('.tab-button').forEach(button => {
                    button.classList.remove('active');
                });

                // Show selected tab content
                document.getElementById(tabName + '-tab').classList.add('active');

                // Add active class to clicked button
                event.target.classList.add('active');

                // Clear search when switching tabs
                document.getElementById('searchInput').value = '';
                searchStaff();
            }

            function searchStaff() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const activeTab = document.querySelector('.tab-content.active').id;

                if (activeTab === 'doctors-tab') {
                    searchInTable('doctor-row', searchTerm, 'doctorCount', originalDoctorCount);
                } else {
                    searchInTable('staff-row', searchTerm, 'staffCount', originalStaffCount);
                }
            }

            function searchInTable(rowClass, searchTerm, countElementId, originalCount) {
                const rows = document.querySelectorAll('.' + rowClass);
                let visibleCount = 0;
                let hasResults = false;

                rows.forEach(row => {
                    const name = row.getAttribute('data-name') || '';
                    const phone = row.getAttribute('data-phone') || '';

                    if (name.includes(searchTerm) || phone.includes(searchTerm)) {
                        row.style.display = '';
                        visibleCount++;
                        hasResults = true;
                    } else {
                        row.style.display = 'none';
                    }
                });

                // Update count in tab
                document.getElementById(countElementId).textContent = visibleCount;

                // Update search results info
                const searchResultsInfo = document.getElementById('searchResultsInfo');
                if (searchTerm) {
                    if (hasResults) {
                        searchResultsInfo.textContent = `Tìm thấy ${visibleCount} kết quả cho "${searchTerm}"`;
                        searchResultsInfo.style.color = '#28a745';
                    } else {
                        searchResultsInfo.textContent = `Không tìm thấy kết quả nào cho "${searchTerm}"`;
                        searchResultsInfo.style.color = '#dc3545';
                        showNoResults(rowClass);
                    }
                } else {
                    searchResultsInfo.textContent = '';
                    removeNoResults(rowClass);
                }
            }

            function showNoResults(rowClass) {
                const tableBody = rowClass === 'doctor-row' ?
                        document.getElementById('doctorsTableBody') :
                        document.getElementById('staffTableBody');

                // Remove existing no-results row
                const existingNoResults = tableBody.querySelector('.no-results-row');
                if (existingNoResults) {
                    existingNoResults.remove();
                }

                // Add no-results row
                const noResultsRow = document.createElement('tr');
                noResultsRow.className = 'no-results-row';
                noResultsRow.innerHTML = `
                    <td colspan="7">
                        <div class="no-results">
                            <i class="fas fa-search"></i>
                            <p>Không tìm thấy kết quả nào phù hợp với tìm kiếm của bạn</p>
                        </div>
                    </td>
                `;
                tableBody.appendChild(noResultsRow);
            }

            function removeNoResults(rowClass) {
                const tableBody = rowClass === 'doctor-row' ?
                        document.getElementById('doctorsTableBody') :
                        document.getElementById('staffTableBody');

                const noResultsRow = tableBody.querySelector('.no-results-row');
                if (noResultsRow) {
                    noResultsRow.remove();
                }
            }

            function openAddModal() {
                document.getElementById('addModal').style.display = 'block';
                document.getElementById('employmentTypeGroup').style.display = 'block';
                document.getElementById('positionGroup').style.display = 'block';
                document.getElementById('staffPositionGroup').style.display = 'none';
            }

            function closeModal() {
                document.getElementById('addModal').style.display = 'none';
                document.getElementById('addStaffForm').reset();
                document.getElementById('employmentTypeGroup').style.display = 'block';
                document.getElementById('positionGroup').style.display = 'block';
                document.getElementById('staffPositionGroup').style.display = 'none';
            }

            function deleteStaff(staffId) {
    if (confirm('Bạn có chắc chắn muốn xóa nhân viên này?')) {
        window.location.href = '<%=request.getContextPath()%>/DeleteStaffServlet?type=staff&id=' + staffId;
    }
}

function deleteDoctor(doctorId) {
    if (confirm('Bạn có chắc chắn muốn xóa bác sĩ này?')) {
        window.location.href = '<%=request.getContextPath()%>/DeleteStaffServlet?type=doctor&id=' + doctorId;
    }
}

            function resetStaffPassword(staffId) {
    if (confirm('Bạn có chắc chắn muốn reset mật khẩu cho nhân viên này?\nMật khẩu sẽ được đặt lại về mặc định.')) {
        window.location.href = '<%=request.getContextPath()%>/ManagerResetStaffPasswordServlet?type=staff&id=' + staffId;
    }
}

function resetDoctorPassword(doctorId) {
    if (confirm('Bạn có chắc chắn muốn reset mật khẩu cho bác sĩ này?\nMật khẩu sẽ được đặt lại về mặc định.')) {
        window.location.href = '<%=request.getContextPath()%>/ManagerResetStaffPasswordServlet?type=doctor&id=' + doctorId;
    }
}
            window.onclick = function (event) {
                var modal = document.getElementById('addModal');
                if (event.target == modal) {
                    closeModal();
                }
            }

            document.getElementById('role').addEventListener('change', function () {
                var employmentTypeGroup = document.getElementById('employmentTypeGroup');
                var positionGroup = document.getElementById('positionGroup');
                var staffPositionGroup = document.getElementById('staffPositionGroup');
                if (this.value === 'STAFF') {
                    employmentTypeGroup.style.display = 'block';
                    positionGroup.style.display = 'none';
                    staffPositionGroup.style.display = 'block';
                } else {
                    employmentTypeGroup.style.display = 'none';
                    positionGroup.style.display = 'block';
                    staffPositionGroup.style.display = 'none';
                }
            });
        </script>
    </body>
</html>