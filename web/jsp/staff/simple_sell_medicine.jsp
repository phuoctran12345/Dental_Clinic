<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="model.Medicine" %>
            <%@page import="model.User" %>

                <% User user=(User) session.getAttribute("user"); if (user==null) {
                    response.sendRedirect("../../login.jsp"); return; } List<Medicine> medicines = (List<Medicine>)
                        request.getAttribute("medicines");
                        String error = (String) request.getAttribute("error");
                        String success = (String) request.getAttribute("success");
                        String billDetails = (String) request.getAttribute("billDetails");
                        Long totalAmount = (Long) request.getAttribute("totalAmount");
                        String customerName = (String) request.getAttribute("customerName");
                        %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Bán Thuốc - Nha Khoa</title>
                            <style>
                                body {
                                    font-family: Arial, sans-serif;
                                    margin: 20px;
                                    background-color: #f5f5f5;
                                }

                                .container {
                                    max-width: 1200px;
                                    margin: 0 auto;
                                    background: white;
                                    padding: 20px;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                }

                                .header {
                                    background: #2563eb;
                                    color: white;
                                    padding: 15px;
                                    margin: -20px -20px 20px -20px;
                                    border-radius: 8px 8px 0 0;
                                }

                                .form-group {
                                    margin-bottom: 15px;
                                }

                                label {
                                    display: block;
                                    margin-bottom: 5px;
                                    font-weight: bold;
                                }

                                input,
                                select {
                                    width: 100%;
                                    padding: 10px;
                                    border: 1px solid #ddd;
                                    border-radius: 4px;
                                    font-size: 14px;
                                }

                                button {
                                    background: #16a34a;
                                    color: white;
                                    padding: 12px 24px;
                                    border: none;
                                    border-radius: 4px;
                                    cursor: pointer;
                                    font-size: 16px;
                                }

                                button:hover {
                                    background: #15803d;
                                }

                                .medicine-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                                    gap: 15px;
                                    margin-bottom: 20px;
                                }

                                .medicine-card {
                                    border: 1px solid #ddd;
                                    padding: 15px;
                                    border-radius: 8px;
                                    background: #f9f9f9;
                                }

                                .error {
                                    background: #fef2f2;
                                    color: #dc2626;
                                    padding: 10px;
                                    border-radius: 4px;
                                    margin-bottom: 15px;
                                    border: 1px solid #fecaca;
                                }

                                .success {
                                    background: #f0fdf4;
                                    color: #16a34a;
                                    padding: 10px;
                                    border-radius: 4px;
                                    margin-bottom: 15px;
                                    border: 1px solid #bbf7d0;
                                }

                                .bill {
                                    background: #f8fafc;
                                    border: 1px solid #e2e8f0;
                                    padding: 20px;
                                    border-radius: 8px;
                                    margin-top: 20px;
                                    font-family: monospace;
                                    white-space: pre-line;
                                }

                                .form-row {
                                    display: grid;
                                    grid-template-columns: 1fr 1fr 100px;
                                    gap: 15px;
                                    align-items: end;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="container">
                                <div class="header">
                                    <h1>💊 Bán Thuốc - Nha Khoa</h1>
                                    <p>Nhân viên: <%= user.getUsername() %> | Ngày: <%= new java.util.Date() %>
                                    </p>
                                </div>

                                <!-- Hiển thị lỗi -->
                                <% if (error !=null) { %>
                                    <div class="error">❌ <%= error %>
                                    </div>
                                    <% } %>

                                        <!-- Hiển thị thành công -->
                                        <% if (success !=null) { %>
                                            <div class="success">✅ <%= success %>
                                            </div>
                                            <% } %>

                                                <!-- Form bán thuốc -->
                                                <form method="POST" action="SimpleSellMedicineServlet">
                                                    <div class="form-group">
                                                        <label>Tên khách hàng (tùy chọn):</label>
                                                        <input type="text" name="customer_name"
                                                            placeholder="Để trống = 'Khách mua thuốc'">
                                                    </div>

                                                    <div class="form-row">
                                                        <div class="form-group">
                                                            <label>Chọn thuốc:</label>
                                                            <select name="medicine_id" required>
                                                                <option value="">-- Chọn thuốc --</option>
                                                                <% if (medicines !=null) { for (Medicine medicine :
                                                                    medicines) { %>
                                                                    <option value="<%= medicine.getMedicineId() %>">
                                                                        <%= medicine.getName() %> -
                                                                            Còn: <%= medicine.getQuantityInStock() %>
                                                                                <%= medicine.getUnit() !=null ?
                                                                                    medicine.getUnit() : "viên" %>
                                                                    </option>
                                                                    <% } } %>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Số lượng:</label>
                                                            <input type="number" name="quantity" min="1" required
                                                                placeholder="Nhập số lượng">
                                                        </div>

                                                        <div class="form-group">
                                                            <button type="submit">Bán Thuốc</button>
                                                        </div>
                                                    </div>
                                                </form>

                                                <!-- Danh sách thuốc -->
                                                <h3>📋 Danh sách thuốc có sẵn:</h3>
                                                <div class="medicine-grid">
                                                    <% if (medicines !=null) { for (Medicine medicine : medicines) { %>
                                                        <div class="medicine-card">
                                                            <h4>
                                                                <%= medicine.getName() %>
                                                            </h4>
                                                            <p><strong>Đơn vị:</strong>
                                                                <%= medicine.getUnit() !=null ? medicine.getUnit()
                                                                    : "viên" %>
                                                            </p>
                                                            <p><strong>Tồn kho:</strong>
                                                                <%= medicine.getQuantityInStock() %>
                                                            </p>
                                                            <p><strong>Giá:</strong> 10,000 VND</p>
                                                            <% if (medicine.getDescription() !=null &&
                                                                !medicine.getDescription().trim().isEmpty()) { %>
                                                                <p><em>
                                                                        <%= medicine.getDescription() %>
                                                                    </em></p>
                                                                <% } %>
                                                        </div>
                                                        <% } } else { %>
                                                            <p>Không có thuốc nào trong kho.</p>
                                                            <% } %>
                                                </div>

                                                <!-- Hiển thị hóa đơn -->
                                                <% if (billDetails !=null) { %>
                                                    <div class="bill">
                                                        <h3>🧾 Hóa đơn đã tạo:</h3>
                                                        <%= billDetails %>

                                                            <hr>
                                                            <p><strong>Khách hàng:</strong>
                                                                <%= customerName %>
                                                            </p>
                                                            <p><strong>Tổng tiền:</strong>
                                                                <%= totalAmount %> VND
                                                            </p>
                                                            <p><strong>Trạng thái:</strong> ✅ Đã thanh toán</p>
                                                    </div>
                                                    <% } %>

                                                        <div style="margin-top: 30px; text-align: center;">
                                                            <a href="../staff/staff_tongquan.jsp"
                                                                style="color: #2563eb;">← Quay lại trang chủ</a>
                                                        </div>
                            </div>

                            <script>
        // Auto refresh sau khi bán thành công
        <% if (success != null) { %>
                                    setTimeout(function () {
                                        if (confirm('Bán hàng mới?')) {
                                            window.location.href = 'SimpleSellMedicineServlet';
                                        }
                                    }, 3000);
        <% } %>
                            </script>
                        </body>

                        </html>