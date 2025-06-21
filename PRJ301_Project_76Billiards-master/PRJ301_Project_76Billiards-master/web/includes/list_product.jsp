<%@page import="Model.Customer"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page contentType="text/html" import="Model.Bida, java.util.ArrayList" pageEncoding="UTF-8"%>

<section id="booking" class="py-5">
    <div class="container mt-4">
        <!-- Tiêu đề Đặt bàn Bida -->
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@700&display=swap');

            #booking {
                background: linear-gradient(to bottom, #e0e0e0, #f5f5f5);
            }

            .custom-title {
                color: #204EBD;
                font-family: 'Roboto Slab', serif;
                font-weight: 700;
                font-size: 3rem;
                letter-spacing: 2px;
                text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
            }

            /* Container chính */
            .container {
                background: white;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
                margin-top: 30px;
                width: 85%;
                margin-left: auto;
                margin-right: auto;
            }

            /* Style cho danh sách */
            .row {
                display: grid; /* Chuyển sang Grid */
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); /* Tự động điều chỉnh cột */
                gap: 1.5rem;
                padding-bottom: 10px;
                overflow-x: auto;
            }

            .row::-webkit-scrollbar {
                height: 10px;
            }

            .row::-webkit-scrollbar-thumb {
                background: linear-gradient(to right, #253985, #204EBD);
                border-radius: 5px;
            }

            .row::-webkit-scrollbar-track {
                background: #f1f1f1;
            }

            .col {
                min-width: 300px; /* Chiều rộng tối thiểu */
                max-width: 600px; /* Chiều rộng tối đa khi ít phần tử */
            }

            /* Khi có 3 bàn trở lên, giới hạn max-width */
            .row:has(> .col:nth-child(3)) .col {
                max-width: 420px; /* Kích thước vừa mắt khi có 3+ bàn */
            }

            /* Thiết kế card */
            .table-card {
                border: none;
                border-radius: 15px;
                padding: 30px;
                text-align: center;
                background: linear-gradient(135deg, #ffffff, #f8f9fa);
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
                margin-bottom: 40px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .table-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }

            .table-img {
                width: 100%;
                height: 260px;
                object-fit: cover;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .table-card h5 {
                font-size: 26px;
                margin: 15px 0;
                color: #253985;
                font-weight: 700;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.1);
            }

            .table-card p {
                font-size: 18px;
                margin: 12px 0;
                color: #333;
                font-weight: 500;
            }

            .table-card .text-muted {
                color: #666 !important;
                font-weight: 400;
            }

            /* Thiết kế nút bấm */
            .table-card .btn {
                font-size: 18px;
                padding: 10px 20px;
                margin: 5px;
                border-radius: 8px;
                font-weight: 600;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .table-card .btn-danger {
                background: linear-gradient(to right, #D32F2F, #FF6F61);
                border: none;
            }

            .table-card .btn-success {
                background: linear-gradient(to right, #2E7D32, #66BB6A);
                border: none;
            }

            .table-card .btn:hover {
                transform: scale(1.1);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }

            /* Bàn đã chọn và nút Reset */
            .selected-tables {
                font-size: 22px;
                font-weight: 600;
                color: black;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.1);
            }

            .reset-btn {
                background: #FFDD57;
                color: #D32F2F;
                border: none;
                padding: 12px 25px;
                font-size: 18px;
                font-weight: 600;
                border-radius: 8px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .reset-btn:hover {
                transform: scale(1.05);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .container {
                    width: 90%;
                    padding: 20px;
                }

                .table-card {
                    max-width: 100%;
                    padding: 15px;
                }

                .table-img {
                    height: 200px;
                }

                .table-card hолы

                .table-card h5 {
                    font-size: 22px;
                }

                .table-card p {
                    font-size: 16px;
                }

                .table-card .btn {
                    font-size: 16px;
                    padding: 8px 15px;
                }

                .col {
                    min-width: 250px;
                    max-width: 300px; /* Giới hạn cho màn hình nhỏ */
                }

                .selected-tables {
                    font-size: 18px;
                }

                .reset-btn {
                    padding: 10px 20px;
                    font-size: 16px;
                }
            }
        </style>
        <h2 class="text-center mb-4 custom-title">ĐẶT BÀN BIDA</h2>

        <!-- Hiển thị số bàn đã chọn -->
        <p class="text-center selected-tables">
            Bàn đã chọn: <span id="selected-count">0</span>
            <button id="reset-btn" class="reset-btn">Reset</button>
        </p>

        <!-- Thêm phần nhắc nhở đăng nhập nếu chưa đăng nhập -->
        <%
            Customer customer = (Customer) session.getAttribute("customer");
            boolean isLoggedIn = (customer != null);
            if (!isLoggedIn) {
        %>
            <p class="text-center text-danger" style="background-color: #FFF3E0; padding: 10px; border-radius: 5px;">Vui lòng <a href="Login.jsp">đăng nhập</a> để đặt bàn!</p>
        <%
            }
        %>

        <!-- Tabs chọn Pool hoặc Carom -->
        <div class="d-flex justify-content-center">
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link active" data-bs-toggle="tab" href="#pool">Pool</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#carom" data-bs-toggle="tab">Carom</a>
                </li>
            </ul>
        </div>

        <!-- Danh sách bàn theo loại -->
        <div class="tab-content mt-3">
            <%
                ArrayList<Bida> allBida = (ArrayList<Bida>) request.getAttribute("allBida");
                if (allBida != null && !allBida.isEmpty()) {
            %>

            <!-- Bàn Pool -->
            <div class="tab-pane fade show active" id="pool">
                <div class="row">
                    <%
                        for (Bida o : allBida) {
                            if (o.getCategory().equals("Pool")) {
                    %>
                    <div class="col">
                        <div class="table-card">
                            <img src="<%= o.getImage()%>" class="table-img" alt="Bàn <%= o.getTable_ID()%>">
                            <div class="card-body">
                                <h5 class="card-title">Bàn <%= o.getTable_ID()%></h5>
                                <p class="card-text text-muted">Loại bàn: 
                                    <span id="category-<%= o.getTable_ID()%>"><%= o.getCategory()%></span>
                                </p>
                                <p class="card-text text-muted">Chất lượng: 
                                    <span id="quality-<%= o.getTable_ID()%>"><%= o.getQuality()%></span>
                                </p>
                                <p class="card-text">Giá: 
                                    <span id="price-<%= o.getTable_ID()%>"><%= o.getPrice()%></span> VND/H
                                </p>
                                <p class="card-text">
                                    Bàn còn lại: <span id="quantity-<%= o.getTable_ID()%>"><%= o.getQuantity()%></span>
                                </p>
                                <p class="card-text">
                                    Bàn đã chọn: <span id="selected-quantity-<%= o.getTable_ID()%>">0</span>
                                </p>
                                <button class="btn btn-sm btn-danger minus-btn" data-id="<%= o.getTable_ID()%>"
                                        <%= isLoggedIn ? "" : "disabled"%>>−</button>
                                <button class="btn btn-sm btn-success plus-btn" data-id="<%= o.getTable_ID()%>"
                                        <%= isLoggedIn ? "" : "disabled"%>>+</button>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <!-- Bàn Carom -->
            <div class="tab-pane fade" id="carom">
                <div class="row">
                    <%
                        for (Bida o : allBida) {
                            if (o.getCategory().equals("Carom")) {
                    %>
                    <div class="col">
                        <div class="table-card">
                            <img src="<%= o.getImage()%>" class="table-img" alt="Bàn <%= o.getTable_ID()%>">
                            <div class="card-body">
                                <h5 class="card-title">Bàn <%= o.getTable_ID()%></h5>
                                <p class="card-text text-muted">Loại bàn: 
                                    <span id="category-<%= o.getTable_ID()%>"><%= o.getCategory()%></span>
                                </p>
                                <p class="card-text text-muted">Chất lượng: 
                                    <span id="quality-<%= o.getTable_ID()%>"><%= o.getQuality()%></span>
                                </p>
                                <p class="card-text">Giá: 
                                    <span id="price-<%= o.getTable_ID()%>"><%= o.getPrice()%></span> VND/H
                                </p>
                                <p class="card-text">
                                    Bàn còn lại: <span id="quantity-<%= o.getTable_ID()%>"><%= o.getQuantity()%></span>
                                </p>
                                <p class="card-text">
                                    Bàn đã chọn: <span id="selected-quantity-<%= o.getTable_ID()%>">0</span>
                                </p>
                                <button class="btn btn-sm btn-danger minus-btn" data-id="<%= o.getTable_ID()%>"
                                        <%= isLoggedIn ? "" : "disabled"%>>−</button>
                                <button class="btn btn-sm btn-success plus-btn" data-id="<%= o.getTable_ID()%>"
                                        <%= isLoggedIn ? "" : "disabled"%>>+</button>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
            <%
            } else {
            %>
            <p class="text-center text-danger">Không có bàn khả dụng.</p>
            <%
                }
            %>
        </div>
    </div>
</section>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="JS/script.js"></script>