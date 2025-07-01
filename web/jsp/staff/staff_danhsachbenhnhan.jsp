<%@page  pageEncoding="UTF-8" %>
    <%@ include file="/jsp/staff/staff_header.jsp" %>
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
            <%@ page import="dao.PatientDAO" %>
                <%@ page import="model.Patients" %>
                    <%@ page import="java.util.List" %>
                        <%@ page import="java.text.SimpleDateFormat" %>

                            <!DOCTYPE html>
                            <html>

                            <head>
                                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                                <title>Danh sách bệnh nhân</title>
                                <link rel="stylesheet"
                                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                                <style>
                                    body {
                                        margin-left: 0;
                                        padding: 0;
                                        overflow-x: hidden;
                                        overflow-y: hidden;
                                    }

                                    .container {
                                        padding-left: 282px;
                                        padding-top: 15px;
                                        padding-right: 15px;
                                        padding-bottom: 15px;
                                    }

                                    .patient-container {
                                        background-color: #fff;
                                        border-radius: 12px;
                                        box-shadow: 0 0 10px #ddd;
                                        padding: 20px;
                                    }

                                    .page-header {
                                        display: flex;
                                        justify-content: space-between;
                                        align-items: center;
                                        margin-bottom: 20px;
                                    }

                                    .page-title {
                                        font-size: 24px;
                                        font-weight: 600;
                                        color: #1e293b;
                                    }

                                    .add-patient-btn {
                                        background-color: #00BFFF;
                                        color: white;
                                        border: none;
                                        border-radius: 8px;
                                        padding: 10px 20px;
                                        font-size: 14px;
                                        cursor: pointer;
                                        display: flex;
                                        align-items: center;
                                        gap: 8px;
                                    }

                                    .add-patient-btn:hover {
                                        background-color: #0095cc;
                                    }

                                    .search-filter {
                                        display: flex;
                                        gap: 15px;
                                        margin-bottom: 20px;
                                    }

                                    .search-box {
                                        flex: 1;
                                        position: relative;
                                    }

                                    .search-box input {
                                        width: 100%;
                                        padding: 10px 40px 10px 15px;
                                        border: 1px solid #e2e8f0;
                                        border-radius: 8px;
                                        font-size: 14px;
                                    }

                                    .search-box i {
                                        position: absolute;
                                        right: 15px;
                                        top: 50%;
                                        transform: translateY(-50%);
                                        color: #94a3b8;
                                    }

                                    .filter-select {
                                        padding: 10px;
                                        border: 1px solid #e2e8f0;
                                        border-radius: 8px;
                                        font-size: 14px;
                                        color: #1e293b;
                                        min-width: 150px;
                                    }

                                    .patient-table {
                                        width: 100%;
                                        border-collapse: collapse;
                                    }

                                    .patient-table th {
                                        text-align: left;
                                        padding: 12px;
                                        background-color: #f8f9fb;
                                        color: #1e293b;
                                        font-weight: 600;
                                        border-bottom: 2px solid #e2e8f0;
                                    }

                                    .patient-table td {
                                        padding: 12px;
                                        border-bottom: 1px solid #e2e8f0;
                                        color: #475569;
                                    }

                                    .patient-table tr:hover {
                                        background-color: #f8f9fb;
                                    }

                                    .patient-info {
                                        display: flex;
                                        align-items: center;
                                        gap: 12px;
                                    }

                                    .patient-avatar {
                                        width: 40px;
                                        height: 40px;
                                        border-radius: 50%;
                                        object-fit: cover;
                                    }

                                    .patient-name {
                                        font-weight: 500;
                                        color: #1e293b;
                                    }

                                    .patient-phone {
                                        font-size: 13px;
                                        color: #64748b;
                                    }

                                    .action-buttons {
                                        display: flex;
                                        gap: 8px;
                                    }

                                    .action-btn {
                                        padding: 6px 12px;
                                        border: none;
                                        border-radius: 6px;
                                        font-size: 13px;
                                        cursor: pointer;
                                        transition: background-color 0.3s;
                                    }

                                    .view-btn {
                                        background-color: #e0f0ff;
                                        color: #00BFFF;
                                    }

                                    .edit-btn {
                                        background-color: #fef3c7;
                                        color: #92400e;
                                    }

                                    .delete-btn {
                                        background-color: #fee2e2;
                                        color: #991b1b;
                                    }

                                    .action-btn:hover {
                                        opacity: 0.8;
                                    }

                                    .pagination {
                                        display: flex;
                                        justify-content: center;
                                        gap: 8px;
                                        margin-top: 20px;
                                    }

                                    .page-btn {
                                        padding: 8px 12px;
                                        border: 1px solid #e2e8f0;
                                        border-radius: 6px;
                                        background-color: white;
                                        color: #1e293b;
                                        cursor: pointer;
                                        transition: all 0.3s;
                                    }

                                    .page-btn:hover {
                                        background-color: #f8f9fb;
                                    }

                                    .page-btn.active {
                                        background-color: #00BFFF;
                                        color: white;
                                        border-color: #00BFFF;
                                    }
                                </style>
                            </head>

                            <body>
                                <div class="container">
                                    <div class="patient-container">
                                        <div class="page-header">
                                            <h1 class="page-title">Danh sách bệnh nhân</h1>                                            
                                        </div>

                                        <div class="search-filter">
                                            <form action="staff_view_patient.jsp" method="GET" class="search-box">
                                                <input type="text" name="keyword" placeholder="Tìm kiếm bệnh nhân..."
                                                    value="<%= request.getParameter(" keyword") !=null ?
                                                    request.getParameter("keyword") : "" %>">
                                                <i class="fa-solid fa-search"></i>
                                            </form>
                                            <form action="staff_view_patient.jsp" method="GET">
                                                <select name="gender" class="filter-select"
                                                    onchange="this.form.submit()">
                                                    <option value="">Tất cả giới tính</option>
                                                    <option value="male" <%="male"
                                                        .equals(request.getParameter("gender")) ? "selected" : "" %>>Nam
                                                    </option>
                                                    <option value="female" <%="female"
                                                        .equals(request.getParameter("gender")) ? "selected" : "" %>>Nữ
                                                    </option>
                                                    <option value="other" <%="other"
                                                        .equals(request.getParameter("gender")) ? "selected" : "" %>
                                                        >Khác</option>
                                                </select>
                                            </form>
                                        </div>

                                        <table class="patient-table">
                                            <thead>
                                                <tr>
                                                    <th>Bệnh nhân</th>
                                                    <th>Giới tính</th>
                                                    <th>Ngày sinh</th>
                                                    <th>Số điện thoại</th>
                                                    <th>Ngày tạo</th>
                                                    
                                                </tr>
                                            </thead>
                                            <tbody>
                                                    <%
                                                        List<model.Patients> patients = (List<model.Patients>) request.getAttribute("patients");
                                                        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                                        if (patients != null && !patients.isEmpty()) {
                                                            for (model.Patients patient : patients) {
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <div class="patient-info">
                                                                <img src="images/default-avatar.png" alt="Patient" class="patient-avatar">
                                                                <div>
                                                                    <div class="patient-name"><%= patient.getFullName() %></div>
                                                                    <div class="patient-phone">ID: <%= patient.getId() %></div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><%= patient.getGender() %></td>
                                                        <td><%= patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "" %></td>
                                                        <td><%= patient.getPhone() != null ? patient.getPhone() : "" %></td>
                                                        <td><%= patient.getCreatedAt() != null ? dateFormat.format(patient.getCreatedAt()) : "" %></td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <button class="action-btn view-btn"
                                                                    onclick="window.location.href='staff_view_patient_detail.jsp?id=<%= patient.getPatientId() %>'">Xem</button>
                                                                <button class="action-btn edit-btn"
                                                                    onclick="window.location.href='staff_edit_patient.jsp?id=<%= patient.getPatientId() %>'">Sửa</button>
                                                                <button class="action-btn delete-btn"
                                                                    onclick="deletePatient(<%= patient.getPatientId() %>)">Xóa</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                            }
                                                        } else {
                                                    %>
                                                    <tr>
                                                        <td colspan="6" style="text-align: center;">Không có dữ liệu bệnh nhân</td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                        </table>
                                    </div>
                                </div>

                                <script>
                                    function deletePatient(patientId) {
                                        if (confirm('Bạn có chắc chắn muốn xóa bệnh nhân này?')) {
                                            window.location.href = 'staff_delete_patient.jsp?id=' + patientId;
                                        }
                                    }
                                </script>
                            </body>

                            </html>