<%@page import="Model.Customer"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>76 Billiards</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="CSS/style.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="JS/script.js"></script>
    </head>
    <body>

        <!-- Thanh điều hướng -->
        <nav class="navbar">
            <div class="container-fluid">
                <a class="navbar-brand" href="#">
                    <img src="images/logo1.png" alt="Logo">
                    <span id="blink-text">76 BILLIARDS</span>
                </a>
                <ul class="navbar-menu">
                    <li><a class="nav-link" href="#">Trang chủ</a></li>
                    <li><a class="nav-link" href="#" onclick="scrollToSection('booking')">Đặt bàn</a></li>
                        <% if (session.getAttribute("customer") == null || ((Customer) session.getAttribute("customer")).getRole_ID() != 1) { %>
                    <li><a class="nav-link" href="ViewHistoryServlet">Lịch sử</a></li>
                        <% } %>
                        <% if (session.getAttribute("customer") != null) {
                                Customer customer = (Customer) session.getAttribute("customer");
                                if (customer.getRole_ID() == 1) { // Giả sử role_id 1 là admin
                        %>
                    <li><a class="nav-link" href="admin.jsp">Quản lí</a></li>
                        <% }
                } %>
                    <li>
                        <% if (session.getAttribute("customer") == null) { %>
                        <!-- Hiển thị nút đăng nhập và đăng ký khi chưa đăng nhập -->
                    <li class="login-text d-flex gap-2">
                        <a class="nav-link" href="Login.jsp">Đăng nhập</a>
                        <a class="nav-link" href="Signup.jsp">Đăng ký</a>
                    </li>
                    <% } else { %>
                    <!-- Hiển thị nút đăng xuất khi đã đăng nhập -->
                    <li class="login-text d-flex gap-2">
                        <a class="nav-link" id="logout-btn" href="logout">Đăng xuất</a>
                    </li>
                    <% } %>
                    </li>

                    <!-- Giỏ hàng chỉ hiển thị khi người dùng đã đăng nhập -->
                    <% if (session.getAttribute("customer") != null) {%>
                    <li>
                        <a href="cart.jsp" class="cart-btn" style="position: relative; display: inline-block;">
                            <img src="images/icon.png" alt="Giỏ hàng" class="cart-icon" style="width: 55px; height: 40px;">
                            <span id="cart-count" style="position: absolute; top: -5px; right: -5px; background: red; color: white; border-radius: 50%; padding: 3px 7px; font-size: 14px; display: none;">0</span>
                        </a>
                    </li>
                    <li>
                        <a href="profile.jsp" class="profile-btn" style="text-decoration: none;">
                            <div class="profile-icon" style="width: 40px; height: 40px; background-color: #007bff; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold;">
                                <%= Character.toUpperCase(((Customer) session.getAttribute("customer")).getName().charAt(0))%>
                            </div>
                        </a>
                    </li>
                    <% } else { %>
                    <!-- Nếu chưa đăng nhập, bấm vào giỏ hàng sẽ yêu cầu đăng nhập -->
                    <li>
                        <a href="Login.jsp" class="cart-btn" style="position: relative; display: inline-block;">
                            <img src="images/icon.png" alt="Giỏ hàng" class="cart-icon" style="width: 55px; height: 40px;">
                        </a>
                    </li>
                    <% }%>
                </ul>
            </div>
        </nav>
    </body>
</html>