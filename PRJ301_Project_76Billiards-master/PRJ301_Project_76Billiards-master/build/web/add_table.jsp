<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý Bàn Bi-a</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Montserrat', sans-serif;
                background: url('images/themban1.jpg') no-repeat center center fixed;
                background-size: cover;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 15px;
                position: relative;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.4); /* Giảm độ tối để tăng độ sáng nền */
                z-index: 1;
            }

            .container {
                max-width: 800px;
                position: relative;
                z-index: 2;
            }

            .card {
                background: rgba(255, 255, 255, 0.98); /* Tăng độ sáng của card */
                border: none;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
                padding: 25px;
                margin-bottom: 20px;
                backdrop-filter: blur(10px);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .card:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            }

            .card h2 {
                font-size: 24px;
                font-weight: 700;
                color: #0056D2;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                margin-bottom: 15px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
                text-align: center;
                position: relative;
                opacity: 0;
                animation: slideInFromTop 0.6s ease forwards;
            }

            @keyframes slideInFromTop {
                0% {
                    opacity: 0;
                    transform: translateY(-15px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .card h4 {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
                color: #1A3C34;
            }

            .form-section {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                align-items: start;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
                will-change: opacity, transform;
                animation: slideInFromLeft 0.6s ease forwards;
            }

            .form-group:nth-child(1) {
                animation-delay: 0.3s;
            }
            .form-group:nth-child(2) {
                animation-delay: 0.4s;
            }
            .form-group:nth-child(3) {
                animation-delay: 0.5s;
            }
            .form-group:nth-child(4) {
                animation-delay: 0.6s;
            }

            @keyframes slideInFromLeft {
                0% {
                    opacity: 0;
                    transform: translateX(-15px);
                }
                100% {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .form-label {
                font-weight: 600;
                color: #1A3C34;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: 1px;
                position: relative;
                transition: color 0.3s ease;
            }

            .form-label::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 0;
                height: 2px;
                background: #0056D2;
                transition: width 0.3s ease;
            }

            .form-group:hover .form-label::after {
                width: 100%;
            }

            .form-group:hover .form-label {
                color: #0056D2;
            }

            .form-control, .form-select {
                border-radius: 8px;
                border: 2px solid #d1d5db; /* Viền đậm hơn để tăng độ tương phản */
                padding: 10px;
                background: #ffffff; /* Nền trắng hoàn toàn để chữ dễ đọc */
                transition: border-color 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
                font-size: 14px;
                color: #1A3C34;
                font-weight: 500; /* Chữ đậm hơn một chút */
            }

            .form-control:focus, .form-select:focus {
                border-color: #0056D2;
                box-shadow: 0 0 6px rgba(0, 86, 210, 0.3);
                outline: none;
                background: #ffffff;
                transform: scale(1.02);
            }

            /* Đảm bảo các tùy chọn trong datalist dễ đọc */
            datalist option {
                background: #ffffff;
                color: #1A3C34;
                font-weight: 500;
            }

            .btn {
                border-radius: 8px;
                padding: 10px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-size: 14px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                position: relative;
                overflow: hidden;
                opacity: 0;
                animation: slideInFromBottom 0.6s ease forwards;
                animation-delay: 0.7s;
                color: #1A3C34;
            }

            @keyframes slideInFromBottom {
                0% {
                    opacity: 0;
                    transform: translateY(15px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                transition: 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
            }

            .btn-success {
                background: linear-gradient(45deg, #0041A3, #0056D2);
                border: none;
            }

            .btn-danger {
                background: linear-gradient(45deg, #e74c3c, #c0392b);
                border: none;
            }

            .btn-primary {
                background: linear-gradient(45deg, #0041A3, #0056D2);
                border: none;
                padding: 10px 30px;
            }

            hr {
                border: 0;
                height: 2px;
                background: linear-gradient(to right, transparent, #0056D2, transparent);
                margin: 20px 0;
            }

            .text-center {
                margin-top: 30px;
            }

            .icon {
                font-size: 18px;
                transition: transform 0.3s ease;
                color: #1A3C34;
            }

            .btn:hover .icon {
                transform: rotate(360deg);
            }

            .custom-file-input {
                width: 0.1px;
                height: 0.1px;
                opacity: 0;
                overflow: hidden;
                position: absolute;
                z-index: -1;
            }

            .custom-file-label {
                display: flex;
                align-items: center;
                justify-content: center;
                border: 2px dashed #0056D2;
                border-radius: 8px;
                padding: 10px;
                margin-top: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                background: rgba(0, 86, 210, 0.05);
                color: #1A3C34;
                font-size: 14px;
            }

            .custom-file-label:hover {
                background: rgba(0, 86, 210, 0.1);
                border-color: #0041A3;
            }

            .custom-file-label::before {
                content: '\f093';
                font-family: 'Font Awesome 5 Free';
                font-weight: 900;
                margin-right: 8px;
            }

            .alert {
                position: relative;
                z-index: 3;
                margin-bottom: 20px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                text-align: center;
                opacity: 0;
                animation: fadeIn 0.5s ease forwards;
                color: #1A3C34;
            }

            @keyframes fadeIn {
                0% {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @media (max-width: 768px) {
                body {
                    padding: 10px;
                }
                .container {
                    max-width: 100%;
                }
                .card {
                    padding: 15px;
                    border-radius: 10px;
                }
                .card h2 {
                    font-size: 20px;
                    letter-spacing: 1px;
                }
                .card h4 {
                    font-size: 16px;
                    gap: 6px;
                }
                .form-section {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }
                .form-group {
                    animation: none;
                }
                .form-label {
                    font-size: 11px;
                }
                .form-control, .form-select {
                    padding: 8px;
                    font-size: 13px;
                }
                .btn {
                    padding: 8px;
                    font-size: 13px;
                    animation-delay: 0.6s;
                }
                .btn-primary {
                    padding: 8px 25px;
                }
                hr {
                    margin: 15px 0;
                }
                .text-center {
                    margin-top: 20px;
                }
                .icon {
                    font-size: 16px;
                }
                .alert {
                    font-size: 13px;
                }
            }

            @media (max-width: 576px) {
                .card {
                    padding: 10px;
                }
                .card h2 {
                    font-size: 18px;
                }
                .card h4 {
                    font-size: 14px;
                }
                .form-label {
                    font-size: 10px;
                }
                .form-control, .form-select {
                    padding: 6px;
                    font-size: 12px;
                }
                .btn {
                    padding: 6px;
                    font-size: 12px;
                }
                .btn-primary {
                    padding: 6px 20px;
                }
                .icon {
                    font-size: 14px;
                }
                .alert {
                    font-size: 12px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <%
                String message = request.getParameter("message");
                String status = request.getParameter("status");
                if (message != null && !message.isEmpty()) {
            %>
            <div class="alert <%= status != null && status.equals("success") ? "alert-success" : "alert-danger"%>">
                <%= message%>
            </div>
            <%
                }
            %>

            <div class="card">
                <h2>Quản lý Bàn Bi-a</h2>
                <hr>

                <h4 class="text-success"><i class="fas fa-plus-circle icon"></i> Thêm bàn mới</h4>
                <form action="ManageTable" method="post" class="mb-4" enctype="multipart/form-data">
                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label">Loại bàn</label>
                            <input type="text" name="category" class="form-control" list="categoryOptions" placeholder="Nhập hoặc chọn loại bàn" required>
                            <datalist id="categoryOptions">
                                <option value="Carom">Carom</option>
                                <option value="Pool">Pool</option>
                            </datalist>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Chất lượng</label>
                            <input type="text" name="quality" class="form-control" list="qualityOptions" placeholder="Nhập hoặc chọn chất lượng" required>
                            <datalist id="qualityOptions">
                                <option value="Thường">Normal</option>
                                <option value="VIP">VIP</option>
                            </datalist>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giá (VND/H)</label>
                            <input type="text" name="price" class="form-control" list="priceOptions" placeholder="Nhập hoặc chọn giá" required>
                            <datalist id="priceOptions">
                                <option value="50000">50,000 VND</option>
                                <option value="60000">60,000 VND</option>
                                <option value="100000">100,000 VND</option>
                                <option value="120000">120,000 VND</option>
                            </datalist>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số lượng</label>
                            <input type="number" name="quantity" class="form-control" list="quantityOptions" placeholder="Nhập hoặc chọn số lượng" required>
                            <datalist id="quantityOptions">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </datalist>
                        </div>
                    </div>
                    <div class="form-group mt-3">
                        <label class="form-label">Ảnh</label>
                        <div class="input-group">
                            <input type="text" name="imageUrl" id="imageUrl" class="form-control" list="imageOptions" placeholder="Nhập hoặc chọn ảnh">
                            <datalist id="imageOptions">
                                <option value="images/Pool1.png">Pool1.png (Normal)</option>
                                <option value="images/Carom1.png">Carom1.png (VIP)</option>
                                <option value="images/Pool2.png">Pool2.png (Normal)</option>
                                <option value="images/Carom2.png">Carom2.png (VIP)</option>
                            </datalist>
                        </div>    
                        <div class="mt-2">
                            <input type="file" name="imageFile" id="imageFile" class="custom-file-input" accept="image/*" onchange="updateFileLabel()">
                            <label class="custom-file-label" for="imageFile">Chọn tệp ảnh (nếu cần)</label>
                        </div>
                    </div>
                    <button type="submit" name="action" value="add" class="btn btn-success w-100 mt-4"><i class="fas fa-plus icon"></i> Thêm bàn</button>
                </form>

                <h4 class="text-danger"><i class="fas fa-trash-alt icon"></i> Xóa bàn</h4>
                <form action="ManageTable" method="post">
                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label">Nhập ID bàn</label>
                            <input type="number" name="table_id" class="form-control" placeholder="VD: 1" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số lượng bàn muốn xóa</label>
                            <input type="number" name="amount" class="form-control" placeholder="VD: 1" required>
                        </div>
                    </div>
                    <button type="submit" name="action" value="delete" class="btn btn-danger w-100 mt-4"><i class="fas fa-trash icon"></i> Xóa bàn</button>
                </form>
            </div>

            <div class="text-center">
                <div class="d-flex justify-content-center gap-3">
                    <a href="<%= request.getContextPath()%>/BidaShop" class="btn btn-primary">
                        <i class="fas fa-home icon"></i> Trang Chủ
                    </a>
                    <a href="<%= request.getContextPath()%>/admin.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left icon"></i> Quay Lại
                    </a>
                </div>
            </div>
        </div>
        <script>
            function updateFileLabel() {
                var input = document.getElementById('imageFile');
                var label = input.nextElementSibling;
                if (input.files && input.files.length > 0) {
                    label.textContent = input.files[0].name;
                } else {
                    label.textContent = "Chọn tệp ảnh (nếu cần)";
                }
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>