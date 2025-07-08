<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="java.util.ArrayList" %>
            <%@page import="java.math.BigDecimal" %>
                <%@page import="dao.MedicineDAO" %>
                    <%@page import="dao.BillDAO" %>
                        <%@page import="model.Medicine" %>
                            <%@page import="model.User" %>

                                <% // Khai báo biến toàn cục cho JSP 
                                    String error=null; String success=null; String
                                    billDetails=null; Long totalAmount=null; String customerName=null; BigDecimal
                                    total=null; User user=(User) session.getAttribute("user"); BillDAO billDAO=null;
                                    List<Medicine> medicines = new ArrayList<>();

                                        // Kiểm tra đăng nhập
                                        if (user == null) {
                                        response.sendRedirect("../../login.jsp");
                                        return;
                                        }

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
                                                        /* Tailwind-like utility classes */
                                                        .bg-white {
                                                            background-color: #fff;
                                                        }

                                                        .bg-blue-50 {
                                                            background-color: #eff6ff;
                                                        }

                                                        .text-blue-700 {
                                                            color: #1d4ed8;
                                                        }

                                                        .text-blue-900 {
                                                            color: #1e3a8a;
                                                        }

                                                        .border-blue-500 {
                                                            border-color: #3b82f6;
                                                        }

                                                        .border {
                                                            border-width: 1px;
                                                            border-style: solid;
                                                        }

                                                        .rounded {
                                                            border-radius: 0.5rem;
                                                        }

                                                        .shadow {
                                                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
                                                        }

                                                        .p-4 {
                                                            padding: 1rem;
                                                        }

                                                        .p-2 {
                                                            padding: 0.5rem;
                                                        }

                                                        .mb-4 {
                                                            margin-bottom: 1rem;
                                                        }

                                                        .mb-2 {
                                                            margin-bottom: 0.5rem;
                                                        }

                                                        .mt-4 {
                                                            margin-top: 1rem;
                                                        }

                                                        .w-full {
                                                            width: 100%;
                                                        }

                                                        .max-w-md {
                                                            max-width: 28rem;
                                                        }

                                                        .mx-auto {
                                                            margin-left: auto;
                                                            margin-right: auto;
                                                        }

                                                        .flex {
                                                            display: flex;
                                                        }

                                                        .gap-2 {
                                                            gap: 0.5rem;
                                                        }

                                                        .items-center {
                                                            align-items: center;
                                                        }

                                                        .justify-between {
                                                            justify-content: space-between;
                                                        }

                                                        .font-bold {
                                                            font-weight: bold;
                                                        }

                                                        .text-center {
                                                            text-align: center;
                                                        }

                                                        .text-sm {
                                                            font-size: 0.875rem;
                                                        }

                                                        .text-lg {
                                                            font-size: 1.125rem;
                                                        }

                                                        .text-xl {
                                                            font-size: 1.25rem;
                                                        }

                                                        .text-green-700 {
                                                            color: #15803d;
                                                        }

                                                        .bg-green-50 {
                                                            background-color: #f0fdf4;
                                                        }

                                                        .border-green-500 {
                                                            border-color: #22c55e;
                                                        }

                                                        .hover\:bg-blue-600:hover {
                                                            background-color: #2563eb;
                                                            color: #fff;
                                                        }

                                                        .hover\:bg-blue-700:hover {
                                                            background-color: #1d4ed8;
                                                            color: #fff;
                                                        }

                                                        .transition {
                                                            transition: all 0.2s;
                                                        }

                                                        .cursor-pointer {
                                                            cursor: pointer;
                                                        }

                                                        .outline-none {
                                                            outline: none;
                                                        }

                                                        .focus\:ring-2:focus {
                                                            box-shadow: 0 0 0 2px #3b82f6;
                                                        }

                                                        .hidden {
                                                            display: none;
                                                        }

                                                        .block {
                                                            display: block;
                                                        }

                                                        .mt-2 {
                                                            margin-top: 0.5rem;
                                                        }

                                                        .mt-8 {
                                                            margin-top: 2rem;
                                                        }

                                                        .py-2 {
                                                            padding-top: 0.5rem;
                                                            padding-bottom: 0.5rem;
                                                        }

                                                        .px-4 {
                                                            padding-left: 1rem;
                                                            padding-right: 1rem;
                                                        }

                                                        .ring-1 {
                                                            box-shadow: 0 0 0 1px #3b82f6;
                                                        }

                                                        /* ... add more as needed ... */
                                                        /* In hóa đơn */
                                                        @media print {
                                                            body * {
                                                                visibility: hidden;
                                                            }

                                                            #billSection.show,
                                                            #billSection.show * {
                                                                visibility: visible;
                                                            }

                                                            #billSection.show {
                                                                position: absolute;
                                                                left: 0;
                                                                top: 0;
                                                                width: 148mm;
                                                                height: 210mm;
                                                                margin: 0;
                                                                padding: 15mm;
                                                                background: #fff;
                                                            }

                                                            .no-print {
                                                                display: none !important;
                                                            }
                                                        }
                                                    </style>
                                                </head>

                                                <body class="bg-blue-50">
                                                    <div class="container bg-white rounded shadow p-4 mx-auto mt-8">
                                                        <!-- Alert thành công -->
                                                        <div id="alertSuccess"
                                                            class="bg-green-50 border border-green-500 text-green-700 rounded p-4 mb-4 text-center hidden">
                                                            💊 Bán thuốc thành công!
                                                        </div>
                                                        <!-- Form bán thuốc -->
                                                        <form method="POST" id="sellForm" class="max-w-md mx-auto"
                                                            onsubmit="showBill(event)">
                                                            <div class="mb-4">
                                                                <label class="block mb-2 font-bold text-blue-900">Tên
                                                                    khách hàng (tùy chọn):</label>
                                                                <input type="text" name="customer_name"
                                                                    class="w-full border border-blue-500 rounded p-2 outline-none focus:ring-2"
                                                                    placeholder="Để trống = 'Khách mua thuốc'">
                                                            </div>
                                                            <div class="flex gap-2 mb-4 items-center">
                                                                <div class="w-full">
                                                                    <label
                                                                        class="block mb-2 font-bold text-blue-900">Chọn
                                                                        thuốc:</label>
                                                                    <select name="medicine_id" required
                                                                        class="w-full border border-blue-500 rounded p-2 outline-none focus:ring-2">
                                                                        <option value="">-- Chọn thuốc --</option>
                                                                        <% for (Medicine medicine : medicines) { %>
                                                                            <option
                                                                                value="<%= medicine.getMedicineId() %>">
                                                                                <%= medicine.getName() %> -
                                                                                    Còn: <%=
                                                                                        medicine.getQuantityInStock() %>
                                                                                        <%= medicine.getUnit() !=null ?
                                                                                            medicine.getUnit() : "viên"
                                                                                            %>
                                                                                            - 10,000 VND
                                                                            </option>
                                                                            <% } %>
                                                                    </select>
                                                                </div>
                                                                <div>
                                                                    <label class="block mb-2 font-bold text-blue-900">Số
                                                                        lượng:</label>
                                                                    <input type="number" name="quantity" min="1"
                                                                        required
                                                                        class="w-full border border-blue-500 rounded p-2 outline-none focus:ring-2"
                                                                        placeholder="Nhập số lượng">
                                                                </div>
                                                                <div>
                                                                    <label
                                                                        class="block mb-2 font-bold text-blue-900">Giá
                                                                        bán (VND):</label>
                                                                    <input type="number" name="price" min="1" required
                                                                        class="w-full border border-blue-500 rounded p-2 outline-none focus:ring-2"
                                                                        placeholder="Nhập giá bán">
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="medicine_name" value="">
                                                            <div class="text-center mt-4">
                                                                <button type="submit"
                                                                    class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition">Tạo
                                                                    & In Hóa Đơn</button>
                                                            </div>
                                                        </form>
                                                        <!-- Danh sách thuốc -->
                                                        <h3 class="text-blue-700 font-bold text-lg mt-8 mb-2">📋 Danh
                                                            sách thuốc có sẵn:</h3>
                                                        <div class="grid gap-2"
                                                            style="grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));">
                                                            <% for (Medicine medicine : medicines) { %>
                                                                <div
                                                                    class="border border-blue-500 rounded p-2 bg-blue-50">
                                                                    <h4 class="font-bold text-blue-900">
                                                                        <%= medicine.getName() %>
                                                                    </h4>
                                                                    <p class="text-sm">Đơn vị: <%= medicine.getUnit()
                                                                            !=null ? medicine.getUnit() : "viên" %>
                                                                    </p>
                                                                    <p class="text-sm">Tồn kho: <%=
                                                                            medicine.getQuantityInStock() %>
                                                                    </p>
                                                                    <p class="text-sm">Giá mặc định: 10,000 VND</p>
                                                                    <% if (medicine.getDescription() !=null &&
                                                                        !medicine.getDescription().trim().isEmpty()) {
                                                                        %>
                                                                        <p class="text-sm italic text-blue-700">
                                                                            <%= medicine.getDescription() %>
                                                                        </p>
                                                                        <% } %>
                                                                </div>
                                                                <% } %>
                                                        </div>
                                                        <!-- Hóa đơn (ẩn mặc định) -->
                                                        <div class="bill bg-white rounded shadow p-4 mx-auto mt-8"
                                                            id="billSection">
                                                            <div class="bill-header text-center">
                                                                <h2 class="bill-title text-blue-700">NHA KHOA HẠNH PHÚC
                                                                </h2>
                                                                <p class="text-sm">Địa chỉ: 123 Đường ABC, Quận XYZ,
                                                                    TP.HCM</p>
                                                                <p class="text-sm">Điện thoại: (028) 1234 5678</p>
                                                                <h3 class="text-blue-900 font-bold">HÓA ĐƠN BÁN THUỐC
                                                                </h3>
                                                            </div>
                                                            <div class="bill-info">
                                                                <p><strong>Mã HĐ:</strong> HD<%=
                                                                        System.currentTimeMillis() %>
                                                                </p>
                                                                <p><strong>Ngày:</strong>
                                                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyyHH:mm").format(new java.util.Date()) %>
                                                                </p>
                                                                <p><strong>Khách hàng:</strong>
                                                                    <%= customerName !=null ? customerName : "Khách lẻ"
                                                                        %>
                                                                </p>
                                                                <p><strong>Nhân viên:</strong>
                                                                    <%= user.getUsername() %>
                                                                </p>
                                                            </div>
                                                            <table
                                                                class="bill-table w-full border border-blue-500 rounded mb-4">
                                                                <tr class="bg-blue-50">
                                                                    <th>Thuốc</th>
                                                                    <th>SL</th>
                                                                    <th>Đơn giá</th>
                                                                    <th>Thành tiền</th>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <%= request.getParameter("medicine_name") %>
                                                                    </td>
                                                                    <td>
                                                                        <%= request.getParameter("quantity") %>
                                                                    </td>
                                                                    <td>
                                                                        <%= String.format("%,d",
                                                                            Integer.parseInt(request.getParameter("price")))
                                                                            %> VNĐ
                                                                    </td>
                                                                    <td>
                                                                        <%= String.format("%,d", totalAmount !=null ?
                                                                            totalAmount : 0) %> VNĐ
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div class="bill-footer text-center mt-4">
                                                                <p class="font-bold text-blue-900">Tổng tiền: <%=
                                                                        String.format("%,d", totalAmount !=null ?
                                                                        totalAmount : 0) %> VNĐ</p>
                                                                <p class="text-sm text-blue-700">Cảm ơn quý khách!</p>
                                                            </div>
                                                            <div class="print-buttons no-print mt-4">
                                                                <button type="button"
                                                                    class="print-button bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition"
                                                                    onclick="window.print()">🖨️ In hóa đơn</button>
                                                                <button type="button"
                                                                    class="print-button bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition"
                                                                    onclick="window.location.reload()">🔄 Bán hàng
                                                                    mới</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div style="margin-top: 30px; text-align: center;">
                                                        <a href="staff_tongquan.jsp"
                                                            style="color: #2563eb; text-decoration: none;">←
                                                            Quay lại trang chủ</a>
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

                                                            <!-- Thêm script để lấy tên thuốc -->
                                                            <script>
                                                                // Hiện hóa đơn khi submit form, chỉ hiện alert 1 lần
                                                                function showBill(event) {
                                                                    event.preventDefault();
                                                                    document.getElementById('billSection').classList.add('show');
                                                                    document.getElementById('alertSuccess').classList.remove('hidden');
                                                                    setTimeout(function () {
                                                                        document.getElementById('alertSuccess').classList.add('hidden');
                                                                    }, 2000);
                                                                    document.getElementById('billSection').scrollIntoView({ behavior: 'smooth' });
                                                                }
                                                                // Cập nhật tên thuốc khi chọn
                                                                document.querySelector('select[name="medicine_id"]').addEventListener('change', function () {
                                                                    var selectedOption = this.options[this.selectedIndex];
                                                                    var medicineName = selectedOption.text.split('-')[0].trim();
                                                                    document.querySelector('input[name="medicine_name"]').value = medicineName;
                                                                });
                                                            </script>
                                                </body>

                                                </html
                                                
                                                >