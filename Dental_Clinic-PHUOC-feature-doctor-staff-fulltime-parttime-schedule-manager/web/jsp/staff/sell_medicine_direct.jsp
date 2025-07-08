<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="java.util.ArrayList" %>
            <%@page import="java.math.BigDecimal" %>
                <%@page import="dao.MedicineDAO" %>
                    <%@page import="dao.BillDAO" %>
                        <%@page import="model.Medicine" %>
                            <%@page import="model.User" %>

                                <% // Kiểm tra đăng nhập User user=(User) session.getAttribute("user"); if (user==null)
                                    { response.sendRedirect("../../login.jsp"); return; } // Biến hiển thị String
                                    error=null; String success=null; String billDetails=null; Long totalAmount=null;
                                    String customerName=null; List<Medicine> medicines = new ArrayList<>();

                                        // Load danh sách thuốc
                                        try {
                                        MedicineDAO medicineDAO = new MedicineDAO();
                                        medicines = medicineDAO.getAllMedicine();
                                        if (medicines == null) {
                                        medicines = new ArrayList<>();
                                            }
                                            } catch (Exception e) {
                                            error = "Lỗi tải danh sách thuốc: " + e.getMessage();
                                            }

                                            // Xử lý POST request (bán thuốc)
                                            if ("POST".equals(request.getMethod())) {
                                            try {
                                            String customerNameParam = request.getParameter("customer_name");
                                            String medicineIdStr = request.getParameter("medicine_id");
                                            String quantityStr = request.getParameter("quantity");
                                            String priceStr = request.getParameter("price");

                                            // Kiểm tra dữ liệu
                                            if (medicineIdStr == null || quantityStr == null || priceStr == null ||
                                            medicineIdStr.trim().isEmpty() || quantityStr.trim().isEmpty() ||
                                            priceStr.trim().isEmpty()) {
                                            error = "Vui lòng chọn thuốc, nhập số lượng và giá!";
                                            } else {
                                            int medicineId = Integer.parseInt(medicineIdStr);
                                            int quantity = Integer.parseInt(quantityStr);
                                            BigDecimal price = new BigDecimal(priceStr);

                                            if (quantity <= 0 || price.compareTo(BigDecimal.ZERO) <=0) {
                                                error="Số lượng và giá phải lớn hơn 0!" ; } else { MedicineDAO
                                                medicineDAO2=new MedicineDAO(); Medicine
                                                medicine=medicineDAO2.getMedicineById(medicineId); if (medicine==null) {
                                                error="Không tìm thấy thuốc!" ; } else if (medicine.getQuantityInStock()
                                                < quantity) { error="Không đủ thuốc trong kho! Còn lại: " +
                                                medicine.getQuantityInStock(); } else { // Tính tiền BigDecimal
                                                total=price.multiply(new BigDecimal(quantity)); // Tạo chi tiết hóa đơn
                                                billDetails="=== HÓA ĐƠN BÁN THUỐC ===\n" + "Thuốc: " +
                                                medicine.getName() + "\n" + "Số lượng: " + quantity + " " +
                                                (medicine.getUnit() !=null ? medicine.getUnit() : "viên" ) + "\n"
                                                + "Đơn giá: " + price.longValue() + " VND\n" + "Thành tiền: " +
                                                total.longValue() + " VND\n" + "Nhân viên: " + user.getUsername() + "\n"
                                                + "Ngày: " + new java.util.Date(); customerName=(customerNameParam
                                                !=null && !customerNameParam.trim().isEmpty()) ?
                                                customerNameParam.trim() : "Khách mua thuốc" ; // Lưu hóa đơn BillDAO
                                                billDAO=new BillDAO(); boolean
                                                saved=billDAO.createSimpleSale(user.getId(), total, billDetails,
                                                customerName); if (saved) { // Cập nhật tồn kho
                                                medicineDAO2.reduceMedicineStock(medicineId, quantity);
                                                success="Bán thuốc thành công!" ; totalAmount=total.longValue(); } else
                                                { error="Lỗi lưu hóa đơn!" ; } } } } } catch (NumberFormatException e) {
                                                error="Dữ liệu số không hợp lệ!" ; } catch (Exception e) {
                                                error="Lỗi hệ thống: " + e.getMessage(); e.printStackTrace(); } } %>

                                                <!DOCTYPE html>
                                                <html lang="vi">

                                                <head>
                                                    <meta charset="UTF-8">
                                                    <meta name="viewport"
                                                        content="width=device-width, initial-scale=1.0">
                                                    <title>Bán Thuốc - Nha Khoa</title>
                                                    <style>
                                                        body {
                                                            font-family: Arial, sans-serif;
                                                            margin: 20px;
                                                            background-color: #f5f5f5;
                                                        }

                                                        .container {
                                                            max-width: 1000px;
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
                                                            max-width: 300px;
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

                                                        .medicine-list {
                                                            display: grid;
                                                            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                                                            gap: 15px;
                                                            margin-top: 20px;
                                                        }

                                                        .medicine-card {
                                                            border: 1px solid #ddd;
                                                            padding: 15px;
                                                            border-radius: 8px;
                                                            background: #f9f9f9;
                                                        }

                                                        .form-row {
                                                            display: flex;
                                                            gap: 15px;
                                                            align-items: end;
                                                        }
                                                    </style>
                                                </head>

                                                <body>
                                                    <div class="container">
                                                        <div class="header">
                                                            <h1>💊 Bán Thuốc - Nha Khoa Hạnh Phúc</h1>
                                                            <p>Nhân viên: <%= user.getUsername() %> | Ngày: <%= new
                                                                        java.util.Date() %>
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
                                                                        <form method="POST">
                                                                            <div class="form-group">
                                                                                <label>Tên khách hàng (tùy
                                                                                    chọn):</label>
                                                                                <input type="text" name="customer_name"
                                                                                    placeholder="Để trống = 'Khách mua thuốc'">
                                                                            </div>

                                                                            <div class="form-row">
                                                                                <div class="form-group">
                                                                                    <label>Chọn thuốc:</label>
                                                                                    <select name="medicine_id" required>
                                                                                        <option value="">-- Chọn
                                                                                            thuốc
                                                                                            --</option>
                                                                                        <% for (Medicine medicine :
                                                                                            medicines) { %>
                                                                                            <option
                                                                                                value="<%= medicine.getMedicineId() %>">
                                                                                                <%= medicine.getName()
                                                                                                    %> -
                                                                                                    Còn: <%=
                                                                                                        medicine.getQuantityInStock()
                                                                                                        %>
                                                                                                        <%= medicine.getUnit()
                                                                                                            !=null ?
                                                                                                            medicine.getUnit()
                                                                                                            : "viên" %>
                                                                                                            - 10,000 VND
                                                                                            </option>
                                                                                            <% } %>
                                                                                    </select>
                                                                                </div>

                                                                                <div class="form-group">
                                                                                    <label>Số lượng:</label>
                                                                                    <input type="number" name="quantity"
                                                                                        min="1" required
                                                                                        placeholder="Nhập số lượng">
                                                                                </div>

                                                                                <div class="form-group">
                                                                                    <label>Giá bán (VND):</label>
                                                                                    <input type="number" name="price"
                                                                                        min="1" required
                                                                                        placeholder="Nhập giá bán">
                                                                                </div>

                                                                                <div class="form-group">
                                                                                    <button type="submit">Tạo & In Hóa
                                                                                        Đơn</button>
                                                                                </div>
                                                                            </div>
                                                                        </form>

                                                                        <!-- Danh sách thuốc -->
                                                                        <h3>📋 Danh sách thuốc có sẵn:</h3>
                                                                        <div class="medicine-list">
                                                                            <% for (Medicine medicine : medicines) { %>
                                                                                <div class="medicine-card">
                                                                                    <h4>
                                                                                        <%= medicine.getName() %>
                                                                                    </h4>
                                                                                    <p><strong>Đơn vị:</strong>
                                                                                        <%= medicine.getUnit() !=null ?
                                                                                            medicine.getUnit() : "viên"
                                                                                            %>
                                                                                    </p>
                                                                                    <p><strong>Tồn kho:</strong>
                                                                                        <%= medicine.getQuantityInStock()
                                                                                            %>
                                                                                    </p>
                                                                                    <p><strong>Giá mặc định:</strong>
                                                                                        10,000 VND</p>
                                                                                    <% if (medicine.getDescription()
                                                                                        !=null &&
                                                                                        !medicine.getDescription().trim().isEmpty())
                                                                                        { %>
                                                                                        <p><em>
                                                                                                <%= medicine.getDescription()
                                                                                                    %>
                                                                                            </em></p>
                                                                                        <% } %>
                                                                                </div>
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
                                                                                    <p><strong>Trạng thái:</strong>
                                                                                        ✅ Đã
                                                                                        thanh toán</p>
                                                                            </div>

                                                                            <div
                                                                                style="margin-top: 15px; text-align: center;">
                                                                                <button onclick="window.print()">🖨️
                                                                                    In
                                                                                    hóa đơn</button>
                                                                                <button
                                                                                    onclick="window.location.reload()">🔄
                                                                                    Bán hàng mới</button>
                                                                            </div>
                                                                            <% } %>

                                                                                <div
                                                                                    style="margin-top: 30px; text-align: center;">
                                                                                    <a href="staff_tongquan.jsp"
                                                                                        style="color: #2563eb; text-decoration: none;">←
                                                                                        Quay lại trang chủ</a>
                                                                                </div>
                                                    </div>

                                                    <% if (success !=null) { %>
                                                        <script>
                                                            setTimeout(function () {
                                                                if (confirm('Bán hàng mới?')) {
                                                                    window.location.reload();
                                                                }
                                                            }, 3000);
                                                        </script>
                                                        <% } %>
                                                </body>

                                                </html>