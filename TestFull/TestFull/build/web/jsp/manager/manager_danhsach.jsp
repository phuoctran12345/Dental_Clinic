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
            .btn-danger {
                background-color: #dc3545;
                color: white;
            }
            .btn:hover {
                opacity: 0.8;
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
                if (staffList != null || doctorList != null) {
            %>
            <%
            } else {
            %>
            <%
                }
            %>

            <div class="actions">
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Thêm nhân viên
                </button>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Vai trò</th>
                            <th>Chức vụ</th>
                            <th>Loại hợp đồng</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
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

                            if (staffData.isEmpty() && doctorData.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 20px;">
                                <div class="alert-danger">
                                    <i class="fas fa-info-circle"></i> Không có nhân viên hoặc bác sĩ nào trong hệ thống.
                                </div>
                            </td>
                        </tr>
                        <%
                        } else {
                            for (Staff staff : staffData) {
                        %>
                        <tr>
                            <td><%= staff.getFullName() != null ? staff.getFullName() : "N/A"%></td>
                            <td><%= staff.getUserEmail() != null ? staff.getUserEmail() : "N/A"%></td>
                            <td><%= staff.getPhone() != null ? staff.getPhone() : "N/A"%></td>
                            <td><span class="role-badge role-staff">Nhân viên</span></td>
                            <td><%= staff.getPosition() != null ? staff.getPosition() : "N/A"%></td>
                            <td><%= staff.getEmploymentType() != null && staff.getEmploymentType().equals("fulltime") ? "Toàn thời gian" : "Bán thời gian"%></td>
                            <td><span class="status-<%= staff.getStatus() != null && staff.getStatus().equals("active") ? "active" : "inactive"%>">
                                    <%= staff.getStatus() != null && staff.getStatus().equals("active") ? "Hoạt động" : "Không hoạt động"%>
                                </span></td>
                            <td><% if (staff.getCreatedAt() != null) {%><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(staff.getCreatedAt())%><% } else { %>N/A<% }%></td>
                            <td>
                                <button class="btn btn-danger" onclick="deleteStaff(<%= staff.getStaffId()%>)">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                            </td>
                        </tr>
                        <%
                            }
                            for (Doctors doctor : doctorData) {
                        %>
                        <tr>
                            <td><%= doctor.getFull_name() != null ? doctor.getFull_name() : "N/A"%></td>
                            <td><%= doctor.getUserEmail() != null ? doctor.getUserEmail() : "N/A"%></td>
                            <td><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A"%></td>
                            <td><span class="role-badge role-doctor">Bác sĩ</span></td>
                            <td><%= doctor.getSpecialty() != null ? doctor.getSpecialty() : "N/A"%></td>
                            <td>-</td>
                            <td><span class="status-<%= doctor.getStatus() != null && doctor.getStatus().equals("active") ? "active" : "inactive"%>">
                                    <%= doctor.getStatus() != null && doctor.getStatus().equals("active") ? "Hoạt động" : "Không hoạt động"%>
                                </span></td>
                            <td><% if (doctor.getCreated_at() != null) {%><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(doctor.getCreated_at())%><% } else { %>N/A<% }%></td>
                            <td>
                                <button class="btn btn-danger" onclick="deleteDoctor(<%= doctor.getDoctor_id()%>)">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
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
                        <label for="position">Chức vụ/Chuyên khoa:</label>
                        <input type="text" id="position" name="position" required>
                    </div>
                    <div class="form-group" id="employmentTypeGroup">
                        <label for="employmentType">Loại hợp đồng (chỉ áp dụng cho Nhân viên):</label>
                        <select id="employmentType" name="employmentType">
                            <option value="fulltime">Toàn thời gian</option>
                            <option value="parttime">Bán thời gian</option>
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
            function openAddModal() {
                document.getElementById('addModal').style.display = 'block';
                document.getElementById('employmentTypeGroup').style.display = 'block';
                document.getElementById('positionGroup').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('addModal').style.display = 'none';
                document.getElementById('addStaffForm').reset();
                document.getElementById('employmentTypeGroup').style.display = 'block';
                document.getElementById('positionGroup').style.display = 'block';
            }

            function deleteStaff(staffId) {
                if (confirm('Bạn có chắc chắn muốn xóa nhân viên này?')) {
                    window.location.href = 'DeleteStaffServlet?staffId=' + staffId;
                }
            }

            function deleteDoctor(doctorId) {
                if (confirm('Bạn có chắc chắn muốn xóa bác sĩ này?')) {
                    window.location.href = 'DeleteDoctorServlet?doctorId=' + doctorId;
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
                if (this.value === 'STAFF') {
                    employmentTypeGroup.style.display = 'block';
                    positionGroup.style.display = 'none';
                } else {
                    employmentTypeGroup.style.display = 'none';
                    positionGroup.style.display = 'block';
                }
            });
        </script>
    </body>
</html>