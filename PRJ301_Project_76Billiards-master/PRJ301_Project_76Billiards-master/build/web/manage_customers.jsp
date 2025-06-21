<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@page import="Model.Customer"%>
<%@page import="java.util.List"%>
<%@page import="Model.CustomerDAO"%>
<%
    // Kiểm tra xem người dùng đã đăng nhập và có phải admin không
    if (session.getAttribute("customer") == null || ((Customer) session.getAttribute("customer")).getRole_ID() != 1) {
        response.sendRedirect("Login.jsp");
        return;
    }

    // Lấy thông tin admin hiện tại
    Customer currentAdmin = (Customer) session.getAttribute("customer");
    boolean isMainAdmin = (currentAdmin.getCustomer_ID() == 1); // Admin chính có Customer_ID = 1

    // Lấy danh sách khách hàng từ attribute do Servlet truyền qua
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    if (customers == null) {
        customers = CustomerDAO.getAllCustomers();
    }
    String message = (String) request.getAttribute("message");
%>

<div class="container">
    <div class="admin-dashboard">
        <h2 class="text-center mt-4">Quản Lý Khách Hàng</h2>

        <!-- Hiển thị thông báo nếu có -->
        <% if (message != null) {%>
        <div class="alert alert-success text-center" role="alert">
            <%= message%>
        </div>
        <% } %>

        <!-- Hiển thị danh sách khách hàng -->
        <table class="table table-bordered table-striped mt-3">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Ngày tạo</th>
                    <th>Trạng thái</th>
                    <th>Quyền Admin</th>
                </tr>
            </thead>
            <tbody>
                <% for (Customer c : customers) {%>
                <tr>
                    <td><%= c.getCustomer_ID()%></td>
                    <td><%= c.getName()%></td>
                    <td><%= c.getEmail()%></td>
                    <td><%= c.getPhoneNumber()%></td>
                    <td><%= c.getCreated_At()%></td>
                    <td><%= c.isStatus() ? "Hoạt động" : "Khóa"%></td>
                    <td>
                        <% if (isMainAdmin && c.getCustomer_ID() != currentAdmin.getCustomer_ID()) { %>
                        <% if (c.getRole_ID() == 1) {%>
                        <a href="ManageCustomerServlet?action=revokeAdmin&id=<%= c.getCustomer_ID()%>" 
                           class="btn btn-danger btn-sm">Hủy quyền Admin</a>
                        <% } else {%>
                        <a href="ManageCustomerServlet?action=grantAdmin&id=<%= c.getCustomer_ID()%>" 
                           class="btn btn-success btn-sm">Cấp quyền Admin</a>
                        <% } %>
                        <% } else {%>
                        <%= c.getRole_ID() == 1 ? "Admin" : "Không"%>
                        <% } %>
                    </td>
                </tr>
                <% }%>
            </tbody>
        </table>

        <!-- Nút quay lại -->
        <div class="back-button-container">
            <a href="BidaShop" class="btn btn-secondary">Trang chủ</a>
            <a href="admin.jsp" class="btn btn-secondary">Quay lại</a> <!-- Nút Quay lại thêm vào đây -->
        </div>
    </div>
</div>

<!-- CSS for Manage Customers Page -->
<style>
    body {
        font-family: 'Poppins', sans-serif;
        background: #f4f6f9;
        color: #333;
        margin: 0;
        padding: 0;
    }

    .container {
        margin-top: 30px;
        margin-bottom: 40px;
    }

    .admin-dashboard {
        background-color: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        padding: 30px;
    }

    h2 {
        font-size: 36px;
        color: #1565c0;
        text-align: center;
        margin-bottom: 30px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    table th, table td {
        padding: 15px;
        text-align: center;
    }

    table th {
        background-color: #1565c0;
        color: white;
    }

    table tbody tr:nth-child(odd) {
        background-color: #f9f9f9;
    }

    table tbody tr:nth-child(even) {
        background-color: #e9f1f9;
    }

    .table-bordered {
        border: 1px solid #ddd;
    }

    .thead-dark {
        background-color: #1565c0;
    }

    .btn-warning {
        background-color: #ffca28;
        border-color: #ffca28;
        color: #333;
    }

    .btn-warning:hover {
        background-color: #ffb300;
        border-color: #ffb300;
    }

    .btn-sm {
        padding: 5px 10px;
        font-size: 14px;
    }

    .back-button-container {
        display: flex;
        justify-content: center;
        margin: 40px auto;
        padding-bottom: 30px;
    }

    .btn-secondary {
        background-color: #757575;
        border-color: #757575;
        font-size: 18px;
        padding: 15px 50px;
        font-weight: 600;
        border-radius: 8px;
        text-transform: uppercase;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        transition: all 0.3s ease;
    }

    .btn-secondary:hover {
        background-color: #616161;
        border-color: #616161;
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
    }
</style>
