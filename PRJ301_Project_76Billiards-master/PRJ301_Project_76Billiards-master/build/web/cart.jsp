<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Customer" %>
<%
    Customer customer = (Customer) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("Login.jsp"); // Nếu chưa đăng nhập, chuyển hướng về Login
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bàn đã chọn</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* Giữ nguyên toàn bộ CSS từ code trước */
            body {
                background: url('images/giohang.jpg') no-repeat center center fixed;
                background-size: cover;
                min-height: 100vh;
                padding: 40px 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                position: relative;
                color: #1e3a8a;
                font-weight: 700;
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(219, 234, 254, 0.2));
                z-index: 0;
            }

            .main-container {
                background: linear-gradient(145deg, rgba(255, 255, 255, 0.7), rgba(240, 248, 255, 0.7));
                border-radius: 20px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                padding: 30px;
                margin: 20px auto;
                max-width: 1200px;
                position: relative;
                z-index: 1;
                backdrop-filter: blur(5px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.3s ease;
            }

            .main-container:hover {
                transform: translateY(-5px);
            }

            .page-title {
                color: #1e3a8a;
                font-weight: 700;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 3px solid #bfdbfe;
                text-align: center;
            }

            .summary-box {
                background: linear-gradient(145deg, rgba(255, 255, 255, 0.65), rgba(240, 248, 255, 0.65));
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
            }

            .summary-box:hover {
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }

            .summary-item {
                font-size: 1.5rem;
                margin-bottom: 15px;
            }

            .summary-item span {
                color: #1e40af;
                font-size: 1.8rem;
            }

            .payment-section {
                background: linear-gradient(145deg, rgba(255, 255, 255, 0.7), rgba(240, 248, 255, 0.7));
                border-radius: 15px;
                padding: 25px;
                margin-top: 30px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
            }

            .payment-section:hover {
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }

            .qr-image {
                max-width: 300px;
                height: auto;
                display: block;
                margin: 15px auto;
            }

            .btn-custom {
                padding: 12px 25px;
                border-radius: 10px;
                font-weight: 700;
                transition: all 0.3s ease;
                margin: 5px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .btn-delete {
                background: linear-gradient(135deg, #dc2626, #991b1b);
                color: white;
                border: none;
            }

            .btn-delete:hover {
                background: linear-gradient(135deg, #b91c1c, #7f1d1d);
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(153, 27, 27, 0.4);
            }

            .btn-home {
                background: linear-gradient(135deg, #1e40af, #1e3a8a);
                color: white;
                border: none;
            }

            .btn-home:hover {
                background: linear-gradient(135deg, #1e3a8a, #172554);
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(30, 58, 138, 0.4);
            }

            .guide-box {
                background: linear-gradient(145deg, rgba(255, 255, 255, 0.7), rgba(240, 248, 255, 0.7));
                border-left: 4px solid #bfdbfe;
                padding: 15px;
                border-radius: 10px;
                margin-top: 20px;
                box-shadow: 0 3px 12px rgba(0, 0, 0, 0.05);
            }

            .form-control {
                border: 2px solid #dbeafe;
                border-radius: 8px;
                padding: 10px;
                background: rgba(255, 255, 255, 0.5);
                color: #1e3a8a;
                font-weight: 700;
            }

            .form-control:focus {
                border-color: #bfdbfe;
                box-shadow: 0 0 0 0.2rem rgba(191, 219, 254, 0.25);
                background: rgba(255, 255, 255, 0.8);
            }

            .form-label {
                color: #1e3a8a;
                font-weight: 700;
                margin-bottom: 8px;
            }
        </style>
    </head>
    <body class="container mt-4">
        <div class="main-container">
            <h2 class="page-title">
                <span style="font-size: 28px;">🛏️</span> Danh Sách Bàn Đã Chọn
            </h2>

            <div id="selected-table-container" class="mb-4">
                <!-- Dữ liệu bàn hiển thị tại đây -->
            </div>

            <div class="container">
                <div class="row">
                    <!-- Chọn ngày -->
                    <div class="col-md-6">
                        <label for="select-date" class="form-label">📅 Chọn ngày:</label>
                        <input type="date" id="select-date" class="form-control" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                    </div>

                    <!-- Chọn giờ -->
                    <div class="col-md-6">
                        <label for="select-time" class="form-label">⏰ Chọn giờ:</label>
                        <input type="time" id="select-time" class="form-control">
                    </div>
                </div>
            </div>

            <div class="text-center my-3 summary-box">
                <h5 class="summary-item">Ngày đặt: <span id="selected-date-display">Chưa chọn</span></h5>
                <h5 class="summary-item">Giờ đặt: <span id="selected-time-display">Chưa chọn</span></h5>
                <h5 class="text-primary summary-item">Tổng số bàn đã chọn: <span id="total-selected">0</span></h5>
                <h5 class="text-danger summary-item">Tổng tiền: <span id="total-price">0</span> VND</h5>
            </div>

            <div class="container payment-section">
                <div class="row">
                    <!-- Cột QR Code -->
                    <div class="col-md-6 text-center">
                        <h4>🔰 Quét mã QR để thanh toán</h4>
                        <img src="images/QR.jpg" alt="QR Code Thanh Toán" class="img-fluid rounded qr-image">
                    </div>

                    <!-- Cột Upload Hóa Đơn -->
                    <div class="col-md-6 text-center">
                        <h4>📸 Tải lên hình ảnh hóa đơn</h4>
                        <input type="file" id="upload-receipt" class="form-control">
                        <img id="receipt-preview" src="" class="mt-3 img-thumbnail d-none" style="max-width: 300px;"><br>
                        <button id="delete-receipt" class="btn btn-danger mt-3 d-none btn-custom btn-delete">❌ Xóa ảnh</button>

                        <!-- Hướng dẫn Upload Mã QR -->
                        <div class="alert alert-info mt-4 text-start guide-box">
                            <h5>📌 Hướng dẫn tải mã QR:</h5>
                            <ul>
                                <li>📸 Chụp ảnh màn hình hoặc lưu ảnh mã QR từ ứng dụng ngân hàng.</li>
                                <li>📂 Nhấn <strong>Chọn File</strong> để tải ảnh lên.</li>
                                <li>✅ Đảm bảo ảnh rõ ràng để xác nhận thanh toán.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Nút Xóa & Quay Lại -->
                <div class="text-center mt-4">
                    <button id="clear-tables-btn" class="btn btn-danger btn-custom btn-delete">🗑️ Xóa hết bàn đã chọn</button>
                    <a href="<%= request.getContextPath()%>/BidaShop" class="btn btn-outline-primary btn-custom btn-home">🏠 Quay lại Trang Chủ</a>
                </div>
            </div>


            <div class="text-center mt-4">
                <form id="payment-form" action="ConfirmPayment" method="post">
                    <!-- Các trường input ẩn để lưu dữ liệu -->
                    <input type="hidden" name="totalBill" id="hidden-totalBill">
                    <input type="hidden" name="date" id="hidden-date">
                    <input type="hidden" name="startTime" id="hidden-time">
                    <input type="hidden" name="receiptImage" id="hidden-receiptImage">
                    <input type="hidden" name="statusBill" value="pending">

                    <button type="submit" id="confirm-selection" class="btn btn-primary">Xác nhận thanh toán</button>
                </form>

                <script>
                    document.getElementById("payment-form").addEventListener("submit", function (e) {
                        let totalBill = sessionStorage.getItem("totalBill") || "0";
                        let selectedDate = sessionStorage.getItem("selectedDate") || new Date().toISOString().split("T")[0];
                        let selectedTime = sessionStorage.getItem("selectedTime") || "12:00";
                        let receiptImage = sessionStorage.getItem("receiptImage") || "";

                        document.getElementById("hidden-totalBill").value = totalBill;
                        document.getElementById("hidden-date").value = selectedDate;
                        document.getElementById("hidden-time").value = selectedTime;
                        document.getElementById("hidden-receiptImage").value = receiptImage;
                    });

                </script>
                <script>
                    document.getElementById("confirm-selection").addEventListener("click", function () {
                        let tableData = sessionStorage.getItem("tableData");

                        if (tableData) {
                            tableData = JSON.parse(tableData);

                            // Gửi request đầu tiên để thêm BillDetails
                            fetch("BillDetailsServlet", {
                                method: "POST",
                                headers: {"Content-Type": "application/json"},
                                body: JSON.stringify(tableData)
                            })
                                    .then(response => response.text())
                                    .then(data => {
                                        console.log("Phản hồi từ BillDetailsServlet", data);

                                        // Sau khi thêm BillDetails thành công, tiếp tục gửi request xóa bàn
                                        return fetch("UpdateTable", {
                                            method: "POST",
                                            headers: {"Content-Type": "application/json"},
                                            body: JSON.stringify(tableData)
                                        });
                                    })
                                    .then(response => response.text())
                                    .then(data => {
                                        console.log("Phản hồi từ DeleteTableServlet:", data);
                                        alert("Đã xác nhận bàn và cập nhật dữ liệu!");
                                        window.location.href = "success.jsp";
                                    })
                                    .catch(error => {
                                        console.error("Lỗi khi gửi yêu cầu:", error);
                                    });
                        } else {
                            alert("Không có bàn nào được chọn!");
                        }
                    });
                </script>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        let deleteButton = document.getElementById("clear-tables-btn");
                        if (deleteButton) {
                            deleteButton.addEventListener("click", clearSelection);
                        }

                        const uploadInput = document.getElementById('upload-receipt');
                        const receiptPreview = document.getElementById('receipt-preview');
                        const deleteBtn = document.getElementById('delete-receipt');
                        const dateInput = document.getElementById('select-date');
                        const timeInput = document.getElementById('select-time');
                        const selectedDateDisplay = document.getElementById('selected-date-display');
                        const selectedTimeDisplay = document.getElementById('selected-time-display');
                        const totalSelected = document.getElementById('total-selected');
                        const totalPrice = document.getElementById('total-price');

                        // Load initial data from sessionStorage
                        let tableData = JSON.parse(sessionStorage.getItem("tableData") || "{}");
                        let totalBill = sessionStorage.getItem("totalBill") || "0";
                        let selectedDate = sessionStorage.getItem("selectedDate");
                        let selectedTime = sessionStorage.getItem("selectedTime");

                        if (selectedDate) {
                            dateInput.value = selectedDate;
                            selectedDateDisplay.textContent = formatDate(selectedDate);
                        }
                        if (selectedTime) {
                            timeInput.value = selectedTime;
                            selectedTimeDisplay.textContent = selectedTime;
                        }
                        updateSummary(tableData, totalBill);

                        // Update date when changed
                        dateInput.addEventListener('change', function () {
                            let date = this.value;
                            sessionStorage.setItem("selectedDate", date);
                            selectedDateDisplay.textContent = formatDate(date);
                            document.getElementById("hidden-date").value = date;
                        });

                        // Update time when changed
                        timeInput.addEventListener('change', function () {
                            let time = this.value;
                            sessionStorage.setItem("selectedTime", time);
                            selectedTimeDisplay.textContent = time;
                            document.getElementById("hidden-time").value = time;
                        });

                        // Handle file upload
                        uploadInput.addEventListener('change', function () {
                            if (this.files && this.files[0]) {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    receiptPreview.src = e.target.result;
                                    receiptPreview.classList.remove('d-none');
                                    deleteBtn.classList.remove('d-none');
                                    sessionStorage.setItem("receiptImage", e.target.result);
                                };
                                reader.readAsDataURL(this.files[0]);
                            }
                        });

                        deleteBtn.addEventListener('click', function () {
                            uploadInput.value = '';
                            receiptPreview.src = '';
                            receiptPreview.classList.add('d-none');
                            deleteBtn.classList.add('d-none');
                            sessionStorage.removeItem("receiptImage");
                        });

                        // Function to format date to Vietnamese style
                        function formatDate(dateStr) {
                            const date = new Date(dateStr);
                            return date.toLocaleDateString('vi-VN', {
                                weekday: 'long',
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            });
                        }

                        // Function to update summary
                        function updateSummary(tableData, totalBill) {
                            let totalTables = Object.keys(tableData).length;
                            totalSelected.textContent = totalTables;
                            totalPrice.textContent = parseInt(totalBill).toLocaleString('vi-VN') + " VND";
                            sessionStorage.setItem("totalBill", totalBill);
                        }

                        // Example: If tableData changes elsewhere, call updateSummary(tableData, totalBill);
                    });
                </script>
                <script src="JS/script.js"></script>
                </body>
                </html>