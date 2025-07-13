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
                                                    <link rel="stylesheet"
                                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

                                                        body {
                                                            background: #f4f7fd;
                                                            font-family: 'Segoe UI', Arial, sans-serif;
                                                        }

                                                        .container-main {
                                                            display: flex;
                                                            justify-content: center;
                                                            align-items: flex-start;
                                                            gap: 32px;
                                                            margin-top: 32px;
                                                        }

                                                        .form-section {
                                                            background: #fff;
                                                            border-radius: 12px;
                                                            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
                                                            padding: 32px;
                                                            min-width: 480px;
                                                            max-width: 540px;
                                                            width: 100%;
                                                        }

                                                        .form-title {
                                                            font-size: 1.3em;
                                                            font-weight: bold;
                                                            color: #111;
                                                            margin-bottom: 24px;
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 10px;
                                                        }

                                                        .form-title i {
                                                            color: #111;
                                                            font-size: 1.2em;
                                                        }

                                                        .form-label {
                                                            font-weight: 500;
                                                            color: #222;
                                                            margin-bottom: 6px;
                                                            display: block;
                                                        }

                                                        .form-input,
                                                        .form-select {
                                                            width: 100%;
                                                            border: 1px solid #d1d5db;
                                                            border-radius: 6px;
                                                            padding: 10px 12px;
                                                            margin-bottom: 18px;
                                                            font-size: 1em;
                                                            background: #fafbfc;
                                                            color: #222;
                                                            outline: none;
                                                            transition: border 0.2s;
                                                        }

                                                        .form-input:focus,
                                                        .form-select:focus {
                                                            border: 1.5px solid #111;
                                                            background: #fff;
                                                        }

                                                        .form-row {
                                                            display: flex;
                                                            gap: 12px;
                                                        }

                                                        .form-row>div {
                                                            flex: 1;
                                                        }

                                                        .form-radio-group {
                                                            display: flex;
                                                            gap: 24px;
                                                            margin-bottom: 18px;
                                                        }

                                                        .form-radio-label {
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 6px;
                                                            font-weight: 500;
                                                            color: #222;
                                                            cursor: pointer;
                                                        }

                                                        .form-radio {
                                                            accent-color: #111;
                                                        }

                                                        .form-btn {
                                                            width: 100%;
                                                            background: #111;
                                                            color: #fff;
                                                            font-weight: bold;
                                                            border: none;
                                                            border-radius: 6px;
                                                            padding: 12px 0;
                                                            font-size: 1.1em;
                                                            margin-top: 8px;
                                                            cursor: pointer;
                                                            transition: background 0.2s;
                                                        }

                                                        .form-btn:hover {
                                                            background: #222;
                                                        }

                                                        /* Danh sách thuốc bên phải */
                                                        .medicine-list-section {
                                                            background: #fff;
                                                            border-radius: 12px;
                                                            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
                                                            padding: 24px;
                                                            min-width: 300px;
                                                            max-width: 340px;
                                                        }

                                                        .medicine-list-title {
                                                            font-size: 1.1em;
                                                            font-weight: bold;
                                                            color: #222;
                                                            margin-bottom: 16px;
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 8px;
                                                        }

                                                        .medicine-card {
                                                            background: #f6f8fc;
                                                            border-radius: 8px;
                                                            border: 1px solid #e0e0e0;
                                                            padding: 14px 16px;
                                                            margin-bottom: 14px;
                                                        }

                                                        .medicine-card h4 {
                                                            font-size: 1em;
                                                            font-weight: bold;
                                                            color: #1a237e;
                                                            margin-bottom: 2px;
                                                        }

                                                        .medicine-card p {
                                                            font-size: 0.97em;
                                                            color: #333;
                                                            margin: 0;
                                                        }

                                                        .medicine-card .desc {
                                                            color: #1976d2;
                                                            font-size: 0.95em;
                                                            font-style: italic;
                                                            margin-top: 2px;
                                                        }

                                                        @media (max-width: 900px) {
                                                            .container-main {
                                                                flex-direction: column;
                                                                align-items: stretch;
                                                            }

                                                            .form-section,
                                                            .medicine-list-section {
                                                                min-width: unset;
                                                                max-width: 100%;
                                                            }
                                                        }
                                                    </style>
                                                </head>

                                                <body class="bg-blue-50">
                                                    <div class="container-main">
                                                        <div class="form-section">
                                                            <div class="form-title"><i class="fa fa-cart-shopping"></i>
                                                                Thông tin bán hàng</div>
                                                            <form method="POST" id="sellForm"
                                                                action="<%=request.getContextPath()%>/ConfirmSellMedicineServlet"
                                                                onsubmit="return submitCart()">
                                                                <label class="form-label">Tên khách hàng (tùy
                                                                    chọn):</label>
                                                                <input type="text" name="customer_name"
                                                                    class="form-input"
                                                                    placeholder="Để trống = 'Khách lẻ'">
                                                                <div class="form-row">
                                                                    <div>
                                                                        <label class="form-label">Chọn thuốc:</label>
                                                                        <select name="medicine_id" id="medicineSelect"
                                                                            required class="form-select">
                                                                            <option value="">-- Chọn thuốc --</option>
                                                                            <% for (Medicine medicine : medicines) { %>
                                                                                <option
                                                                                    value="<%= medicine.getMedicineId() %>"
                                                                                    data-name="<%= medicine.getName() %>"
                                                                                    data-unit="<%= medicine.getUnit() != null ? medicine.getUnit() : "viên" %>"
                                                                                    data-price="<%= medicine.getPrice()
                                                                                        !=null ?
                                                                                        medicine.getPrice().intValue() :
                                                                                        0 %>">
                                                                                        <%= medicine.getName() %> - Còn:
                                                                                            <%= medicine.getQuantityInStock()
                                                                                                %>
                                                                                                <%= medicine.getUnit()
                                                                                                    !=null ?
                                                                                                    medicine.getUnit()
                                                                                                    : "viên" %> - <%=
                                                                                                        medicine.getPrice()
                                                                                                        !=null ?
                                                                                                        String.format("%,d",
                                                                                                        medicine.getPrice().intValue())
                                                                                                        : "0" %>
                                                                                                        VND/viên
                                                                                </option>
                                                                                <% } %>
                                                                        </select>
                                                                    </div>
                                                                    <div>
                                                                        <label class="form-label">Số lượng:</label>
                                                                        <input type="number" id="quantityInput" min="1"
                                                                            required class="form-input"
                                                                            placeholder="Nhập số lượng">
                                                                    </div>
                                                                    <div>
                                                                        <label class="form-label">Giá bán
                                                                            (VND/viên):</label>
                                                                        <input type="text" id="priceDisplay"
                                                                            class="form-input" readonly>
                                                                    </div>
                                                                    <div>
                                                                        <label class="form-label">Tổng tiền
                                                                            (VND):</label>
                                                                        <input type="text" id="totalDisplay"
                                                                            class="form-input" readonly>
                                                                    </div>
                                                                </div>
                                                                <input type="hidden" name="cart_json"
                                                                    id="cartJsonInput">
                                                                <div id="cartSection" class="mt-4">
                                                                    <h3 class="medicine-list-title">Danh sách thuốc
                                                                        trong hóa đơn</h3>
                                                                    <div id="cartList"></div>
                                                                    <div style="margin-top:10px;font-weight:bold;">Tổng
                                                                        tiền: <span id="cartTotal"
                                                                            style="color:green;font-size:1.2em;">0
                                                                            VND</span></div>
                                                                </div>
                                                                <label class="form-label">Hình thức thanh toán:</label>
                                                                <div class="form-radio-group">
                                                                    <label class="form-radio-label"><input type="radio"
                                                                            name="payment_method" value="cash" checked
                                                                            class="form-radio"> Tiền mặt</label>
                                                                    <label class="form-radio-label"><input type="radio"
                                                                            name="payment_method" value="payos"
                                                                            class="form-radio"> QR PayOS</label>
                                                                </div>
                                                                <button type="button" class="form-btn"
                                                                    onclick="addToCart()">Thêm vào hóa đơn</button>
                                                                <button type="submit" class="form-btn"
                                                                    style="margin-top:10px;background:#222;">Tạo & In
                                                                    Hóa Đơn</button>
                                                            </form>
                                                        </div>
                                                        <div class="medicine-list-section">
                                                            <div class="medicine-list-title"><i
                                                                    class="fa fa-clipboard-list"></i> Danh sách thuốc có
                                                                sẵn</div>
                                                            <% for (Medicine medicine : medicines) { %>
                                                                <%-- Đặt biến tạm an toàn cho giá và đơn vị --%>
                                                                    <% String donVi=medicine.getUnit() !=null ?
                                                                        medicine.getUnit() : "viên" ; String
                                                                        gia="10,000" ; if (medicine.getPrice() !=null) {
                                                                        gia=String.format("%,d",
                                                                        medicine.getPrice().intValue()); } %>
                                                                        <div class="medicine-card">
                                                                            <h4>
                                                                                <%= medicine.getName() %>
                                                                            </h4>
                                                                            <p>Đơn vị: <%= donVi %>
                                                                            </p>
                                                                            <p>Tồn kho: <%=
                                                                                    medicine.getQuantityInStock() %>
                                                                            </p>
                                                                            <p>Giá: <%= gia %> VND</p>
                                                                            <% if (medicine.getDescription() !=null &&
                                                                                !medicine.getDescription().trim().isEmpty())
                                                                                { %>
                                                                                <div class="desc">
                                                                                    <%= medicine.getDescription() %>
                                                                                </div>
                                                                                <% } %>
                                                                        </div>
                                                                        <% } %>
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
                                                            <script>
                                                                function handlePayment(event) {
                                                                    var method = document.querySelector('input[name="payment_method"]:checked').value;
                                                                    if (method === 'payos') {
                                                                        var form = document.getElementById('sellForm');
                                                                        form.action = '<%=request.getContextPath()%>/StaffPayOSServlet';
                                                                        form.target = '_blank'; // Mở hóa đơn QR ở tab mới
                                                                        return true;
                                                                    } else {
                                                                        // Tiền mặt: xử lý như cũ (hiện hóa đơn trên trang)
                                                                        form = document.getElementById('sellForm');
                                                                        form.action = '';
                                                                        form.target = '';
                                                                        showBill(event);
                                                                        return false;
                                                                    }
                                                                }
                                                            </script>
                                                            <script>
                                                                const medicineSelect = document.getElementById('medicineSelect');
                                                                const quantityInput = document.getElementById('quantityInput');
                                                                const priceDisplay = document.getElementById('priceDisplay');
                                                                const totalDisplay = document.getElementById('totalDisplay');
                                                                let cartItems = [];

                                                                function updatePriceAndTotal() {
                                                                    const selectedOption = medicineSelect.options[medicineSelect.selectedIndex];
                                                                    const price = parseInt(selectedOption.getAttribute('data-price')) || 0;
                                                                    const quantity = parseInt(quantityInput.value) || 0;
                                                                    priceDisplay.value = price.toLocaleString('vi-VN');
                                                                    totalDisplay.value = (price * quantity).toLocaleString('vi-VN');
                                                                }
                                                                medicineSelect.addEventListener('change', updatePriceAndTotal);
                                                                quantityInput.addEventListener('input', updatePriceAndTotal);
                                                                updatePriceAndTotal();

                                                                function addToCart() {
                                                                    const selectedOption = medicineSelect.options[medicineSelect.selectedIndex];
                                                                    const medicineId = selectedOption.value;
                                                                    const name = selectedOption.getAttribute('data-name');
                                                                    const unit = selectedOption.getAttribute('data-unit');
                                                                    const price = parseInt(selectedOption.getAttribute('data-price')) || 0;
                                                                    const quantity = parseInt(quantityInput.value) || 0;
                                                                    if (!medicineId || quantity <= 0) {
                                                                        alert('Vui lòng chọn thuốc và nhập số lượng hợp lệ!');
                                                                        return;
                                                                    }
                                                                    // Kiểm tra trùng thuốc, nếu có thì cộng dồn số lượng
                                                                    const existing = cartItems.find(item => item.medicineId === medicineId);
                                                                    if (existing) {
                                                                        existing.quantity += quantity;
                                                                    } else {
                                                                        cartItems.push({ medicineId, name, unit, price, quantity });
                                                                    }
                                                                    renderCart();
                                                                    // Reset input
                                                                    quantityInput.value = 1;
                                                                    updatePriceAndTotal();
                                                                }
                                                                function removeFromCart(idx) {
                                                                    cartItems.splice(idx, 1);
                                                                    renderCart();
                                                                }
                                                                function renderCart() {
                                                                    const cartList = document.getElementById('cartList');
                                                                    const cartTotal = document.getElementById('cartTotal');
                                                                    if (cartItems.length === 0) {
                                                                        cartList.innerHTML = '<div style="color:#888;">Chưa có thuốc nào trong hóa đơn.</div>';
                                                                        cartTotal.textContent = '0 VND';
                                                                        return;
                                                                    }
                                                                    let html = '';
                                                                    let total = 0;
                                                                    cartItems.forEach((item, idx) => {
                                                                        const itemTotal = item.price * item.quantity;
                                                                        total += itemTotal;
                                                                        html += `<div style="background:#f6f8fc;border-radius:8px;padding:10px 16px;margin-bottom:8px;display:flex;align-items:center;justify-content:space-between;">
                                                                            <div><b>${item.name}</b><br><span style="font-size:0.95em;">${item.quantity} ${item.unit} × ${item.price.toLocaleString('vi-VN')} VND</span></div>
                                                                            <div style="font-weight:bold;min-width:90px;text-align:right;">${itemTotal.toLocaleString('vi-VN')} VND</div>
                                                                            <button onclick="removeFromCart(${idx})" style="background:#ef4444;color:#fff;border:none;border-radius:5px;padding:6px 14px;cursor:pointer;font-weight:bold;">Xóa</button>
                                                                        </div>`;
                                                                    });
                                                                    cartList.innerHTML = html;
                                                                    cartTotal.textContent = total.toLocaleString('vi-VN') + ' VND';
                                                                }
                                                                function submitCart() {
                                                                    if (cartItems.length === 0) {
                                                                        alert('Vui lòng thêm ít nhất 1 thuốc vào hóa đơn!');
                                                                        return false;
                                                                    }
                                                                    document.getElementById('cartJsonInput').value = JSON.stringify(cartItems);
                                                                    return true;
                                                                }
                                                            </script>
                                                </body>

                                                </html>