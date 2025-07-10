<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh sách khách hàng</title>
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

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
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

        .customer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #eee;
        }

        .status-active {
            color: #28a745;
        }

        .status-inactive {
            color: #dc3545;
        }

        .search-box {
            margin-bottom: 20px;
        }

        .search-box input {
            width: 300px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 10px;
        }

        .pagination button {
            padding: 8px 12px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            border-radius: 5px;
        }

        .pagination button.active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }

        .pagination button:hover {
            background: #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="manager_menu.jsp" />
    
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-users"></i> Quản lý danh sách khách hàng</h1>
            <p>Xem thông tin tài khoản khách hàng đã đăng ký trong hệ thống</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalCustomers}</div>
                <div class="stat-label">Tổng số khách hàng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${activeCustomers}</div>
                <div class="stat-label">Khách hàng hoạt động</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${newCustomersThisMonth}</div>
                <div class="stat-label">Khách hàng mới tháng này</div>
            </div>
        </div>

        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên hoặc số điện thoại..." onkeyup="filterTable()">
        </div>

        <div class="table-container">
            <table id="customerTable">
                <thead>
                    <tr>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Ngày sinh</th>
                        <th>Giới tính</th>
                        <th>Ngày đăng ký</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="patient" items="${patientList}">
                        <tr>
                            <td>${patient.patientId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty patient.avatar}">
                                        <img src="${patient.avatar}" alt="Avatar" class="customer-avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/40x40/cccccc/666666?text=?" alt="Default Avatar" class="customer-avatar">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${patient.fullName}</td>
                            <td>${patient.email}</td>
                            <td>${patient.phone}</td>
                            <td>${patient.dateOfBirth}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${patient.gender == 'male'}">Nam</c:when>
                                    <c:when test="${patient.gender == 'female'}">Nữ</c:when>
                                    <c:otherwise>Khác</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${patient.createdAt}</td>
                            <td>
                                <span class="status-active">Hoạt động</span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <button onclick="changePage(${currentPage - 1})">Trước</button>
            </c:if>
            
            <c:forEach begin="1" end="${totalPages}" var="i">
                <button class="${currentPage == i ? 'active' : ''}" onclick="changePage(${i})">${i}</button>
            </c:forEach>
            
            <c:if test="${currentPage < totalPages}">
                <button onclick="changePage(${currentPage + 1})">Sau</button>
            </c:if>
        </div>
    </div>

    <script>
        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("customerTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var td = tr[i].getElementsByTagName("td");
                var show = false;
                
                for (var j = 0; j < td.length; j++) {
                    var cell = td[j];
                    if (cell) {
                        var txtValue = cell.textContent || cell.innerText;
                        if (txtValue.toLowerCase().indexOf(filter) > -1) {
                            show = true;
                            break;
                        }
                    }
                }
                
                tr[i].style.display = show ? "" : "none";
            }
        }

        function changePage(page) {
            window.location.href = 'ManagerCustomerListServlet?page=' + page;
        }
    </script>
</body>
</html> 