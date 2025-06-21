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

    // Lấy tất cả khách hàng từ database
    List<Customer> customers = CustomerDAO.getAllCustomers();
%>

<div class="container">
    <div class="admin-dashboard">
        <h2 class="text-center mt-4">Trang Quản Lý Admin</h2>

        <!-- Các liên kết chức năng quản lý -->
        <div class="admin-actions">
            <div class="action-card">
                <a href="add_table.jsp" class="btn btn-primary">Thêm Bàn</a>
                <p class="action-description">Thêm các bàn mới vào hệ thống</p>
            </div>
            <div class="action-card">
                <a href="ViewHistoryServlet" class="btn btn-success">Thống kê Hóa Đơn</a>
                <p class="action-description">Xem báo cáo doanh thu và hóa đơn</p>
            </div>
            <div class="action-card">
                <a href="ManageCustomerServlet" class="btn btn-info">Quản lý Khách Hàng</a>
                <p class="action-description">Quản lý thông tin khách hàng</p>
            </div>
        </div>
    </div>
</div>

<!-- Tách riêng nút "Trang chủ" ra khỏi phần chính -->
<div class="home-button-container">
    <a href="BidaShop" class="btn btn-secondary">Trang chủ</a>
</div>

<!-- CSS for Admin Page -->
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

    .admin-actions {
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
        gap: 20px;
    }

    .action-card {
        background-color: #ffffff;
        padding: 20px;
        width: 250px;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .action-card .btn {
        width: 100%;
        padding: 12px;
        font-size: 18px;
        font-weight: 600;
        border-radius: 8px;
        transition: background 0.3s ease;
    }

    .action-description {
        margin-top: 10px;
        color: #555;
        font-size: 14px;
    }

    .btn-primary {
        background-color: #42a5f5;
        border-color: #42a5f5;
    }

    .btn-primary:hover {
        background-color: #1976d2;
        border-color: #1976d2;
    }

    .btn-success {
        background-color: #66bb6a;
        border-color: #66bb6a;
    }

    .btn-success:hover {
        background-color: #388e3c;
        border-color: #388e3c;
    }

    .btn-info {
        background-color: #29b6f6;
        border-color: #29b6f6;
    }

    .btn-info:hover {
        background-color: #0288d1;
        border-color: #0288d1;
    }

    .home-button-container {
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