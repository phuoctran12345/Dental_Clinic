<%@page import="dao.MedicineDAO" %>
    <%@page import="model.Medicine" %>
        <%@page import="java.util.List" %>
            <%@page import="model.User" %>
                <%@page pageEncoding="UTF-8" %>

                    <% User user=(User) session.getAttribute("user"); if (user==null) {
                        response.sendRedirect("../../login.jsp"); return; } List<Medicine> medicines = (List<Medicine>)
                            request.getAttribute("medicines");
                            if (medicines == null) {
                            MedicineDAO dao = new MedicineDAO();
                            medicines = dao.getAllMedicine();
                            }
                            %>

                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>💊 Quầy Thuốc - Nha Khoa Hạnh Phúc</title>
                                <script src="https://cdn.tailwindcss.com"></script>
                                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                                    rel="stylesheet">
                                <script>
                                    tailwind.config = {
                                        theme: {
                                            extend: {
                                                colors: {
                                                    primary: {
                                                        50: '#eff6ff',
                                                        100: '#dbeafe',
                                                        500: '#3b82f6',
                                                        600: '#2563eb',
                                                        700: '#1d4ed8'
                                                    }
                                                }
                                            }
                                        }
                                    }
                                </script>
                            </head>

                            <body class="bg-gradient-to-br from-blue-50 to-cyan-50 min-h-screen">
                                <!-- Header -->
                                <div class="bg-gradient-to-r from-blue-600 to-cyan-600 text-white p-6 shadow-lg">
                                    <div class="max-w-7xl mx-auto flex justify-between items-center">
                                        <h1 class="text-3xl font-bold flex items-center gap-3">
                                            <i class="fas fa-pills"></i>
                                            Quầy Thuốc Nha Khoa
                                        </h1>
                                        <div class="bg-white/20 px-4 py-2 rounded-lg text-right">
                                            <div class="flex items-center gap-2">
                                                <i class="fas fa-user"></i>
                                                <%= user.getUsername() %>
                                            </div>
                                            <div class="text-sm opacity-90">
                                                <%= new java.util.Date() %>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="max-w-7xl mx-auto p-6">
                                    <div class="grid lg:grid-cols-3 gap-6">
                                        <!-- Medicine Section -->
                                        <div class="lg:col-span-2 bg-white rounded-xl shadow-lg p-6">
                                            <!-- Search -->
                                            <div class="relative mb-6">
                                                <input type="text" id="searchInput"
                                                    class="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                    placeholder="Tìm kiếm thuốc..." onkeyup="searchMedicine()">
                                                <i class="fas fa-search absolute left-4 top-4 text-gray-400"></i>
                                            </div>

                                            <!-- Medicine Grid -->
                                            <div
                                                class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4 max-h-96 overflow-y-auto">
                                                <% if (medicines !=null && medicines.size()> 0) {
                                                    for (Medicine medicine : medicines) {
                                                    String unitDisplay = medicine.getUnit() != null ? medicine.getUnit()
                                                    : "Viên";
                                                    %>
                                                    <div class="medicine-card border-2 border-gray-200 hover:border-blue-500 rounded-lg p-4 cursor-pointer transition-all hover:shadow-md"
                                                        data-id="<%= medicine.getMedicineId() %>"
                                                        data-name="<%= medicine.getName() %>"
                                                        data-unit="<%= unitDisplay %>"
                                                        data-stock="<%= medicine.getQuantityInStock() %>">
                                                        <h3 class="font-semibold text-gray-900 mb-2">
                                                            <%= medicine.getName() %>
                                                        </h3>
                                                        <div class="flex justify-between items-center mb-3">
                                                            <span class="text-sm text-gray-600">
                                                                <%= unitDisplay %>
                                                            </span>
                                                            <span
                                                                class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs font-medium">
                                                                Còn: <%= medicine.getQuantityInStock() %>
                                                            </span>
                                                        </div>
                                                        <div class="text-green-600 font-bold text-lg">💰 10,000 VND
                                                        </div>
                                                        <% if (medicine.getDescription() !=null &&
                                                            !medicine.getDescription().trim().isEmpty()) { %>
                                                            <p class="text-xs text-gray-500 mt-2">
                                                                <%= medicine.getDescription() %>
                                                            </p>
                                                            <% } %>
                                                    </div>
                                                    <% } } else { %>
                                                        <div class="col-span-full text-center py-12 text-gray-500">
                                                            <i class="fas fa-pills text-4xl mb-3"></i>
                                                            <p>Không có thuốc nào trong kho</p>
                                                        </div>
                                                        <% } %>
                                            </div>
                                        </div>

                                        <!-- Cart Section -->
                                        <div class="bg-white rounded-xl shadow-lg p-6">
                                            <!-- Cart Header -->
                                            <div class="flex items-center gap-3 mb-6 pb-4 border-b">
                                                <h3 class="text-xl font-bold text-gray-900">
                                                    <i class="fas fa-shopping-cart text-blue-600"></i> Giỏ hàng
                                                </h3>
                                                <span id="cartCount"
                                                    class="bg-red-500 text-white px-2 py-1 rounded-full text-sm">0</span>
                                            </div>

                                            <!-- Cart Items -->
                                            <div id="cartItems" class="mb-6 max-h-48 overflow-y-auto">
                                                <div class="text-center py-8 text-gray-500">
                                                    <i class="fas fa-cart-plus text-3xl mb-2"></i>
                                                    <p>Chọn thuốc để thêm vào giỏ hàng</p>
                                                </div>
                                            </div>

                                            <!-- Total -->
                                            <div
                                                class="bg-gradient-to-r from-green-500 to-emerald-500 text-white p-4 rounded-lg mb-6 text-center">
                                                <div id="totalAmount" class="text-2xl font-bold">0 VND</div>
                                                <div class="text-sm opacity-90">Tổng thanh toán</div>
                                            </div>

                                            <!-- Customer Form - ĐƠN GIẢN -->
                                            <div class="space-y-4 mb-6">
                                                <h4 class="font-semibold text-gray-900 flex items-center gap-2">
                                                    <i class="fas fa-user text-blue-600"></i> Tên khách hàng (tùy chọn)
                                                </h4>
                                                <input type="text" id="customerName"
                                                    class="w-full p-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500"
                                                    placeholder="Tên khách hàng (để trống = 'Khách mua thuốc')">

                                                <!-- Note -->
                                                <p class="text-sm text-gray-500">
                                                    💡 Chỉ cần nhập tên để in hóa đơn. Thông tin không bắt buộc.
                                                </p>
                                            </div>

                                            <!-- Payment Methods -->
                                            <div class="mb-6">
                                                <label class="block text-sm font-medium text-gray-700 mb-2">Phương thức
                                                    thanh toán</label>
                                                <div class="grid grid-cols-2 gap-2">
                                                    <button
                                                        class="payment-btn bg-blue-50 border-2 border-blue-200 text-blue-700 p-3 rounded-lg text-center transition-all active"
                                                        data-method="CASH">
                                                        <i class="fas fa-money-bill block mb-1"></i>
                                                        <span class="text-xs">Tiền mặt</span>
                                                    </button>
                                                    <button
                                                        class="payment-btn bg-gray-50 border-2 border-gray-200 text-gray-700 p-3 rounded-lg text-center transition-all"
                                                        data-method="BANK_TRANSFER">
                                                        <i class="fas fa-university block mb-1"></i>
                                                        <span class="text-xs">Chuyển khoản</span>
                                                    </button>
                                                    <button
                                                        class="payment-btn bg-gray-50 border-2 border-gray-200 text-gray-700 p-3 rounded-lg text-center transition-all"
                                                        data-method="CARD">
                                                        <i class="fas fa-credit-card block mb-1"></i>
                                                        <span class="text-xs">Thẻ</span>
                                                    </button>
                                                    <button
                                                        class="payment-btn bg-gray-50 border-2 border-gray-200 text-gray-700 p-3 rounded-lg text-center transition-all"
                                                        data-method="MOMO">
                                                        <i class="fas fa-mobile-alt block mb-1"></i>
                                                        <span class="text-xs">MoMo</span>
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Checkout Button -->
                                            <button id="checkoutBtn"
                                                onclick="console.log('🔴 BUTTON CLICKED!'); createBill();" disabled
                                                class="w-full bg-gradient-to-r from-green-500 to-emerald-500 hover:from-green-600 hover:to-emerald-600 text-white font-bold py-3 px-4 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all mb-2">
                                                <i class="fas fa-receipt mr-2"></i>
                                                Bán thuốc & In hóa đơn
                                            </button>

                                            <!-- DEBUG BUTTON - TẠM THỜI -->
                                            <button onclick="debugCart()"
                                                class="w-full bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded-lg transition-all text-sm mb-2">
                                                🔍 DEBUG CART (Test)
                                            </button>

                                            <!-- MANUAL TEST BUTTON -->
                                            <button onclick="manualTest()"
                                                class="w-full bg-yellow-500 hover:bg-yellow-600 text-white font-bold py-2 px-4 rounded-lg transition-all text-sm">
                                                🧪 MANUAL TEST API
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Bill Modal -->
                                <div id="billModal"
                                    class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
                                    <div
                                        class="bg-white rounded-xl shadow-2xl w-full max-w-lg max-h-screen overflow-y-auto">
                                        <div class="flex justify-between items-center p-6 border-b">
                                            <h3 class="text-xl font-bold text-gray-900">
                                                <i class="fas fa-receipt text-blue-600 mr-2"></i>Hóa đơn bán thuốc
                                            </h3>
                                            <button onclick="closeBillModal()"
                                                class="text-gray-500 hover:text-gray-700">
                                                <i class="fas fa-times text-xl"></i>
                                            </button>
                                        </div>
                                        <div id="billContent"
                                            class="p-6 font-mono text-sm bg-gray-50 whitespace-pre-line"></div>
                                        <div class="p-6 border-t flex gap-3">
                                            <button onclick="printBill()"
                                                class="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-3 px-4 rounded-lg transition-all">
                                                <i class="fas fa-print mr-2"></i>In hóa đơn
                                            </button>
                                            <button onclick="newSale()"
                                                class="flex-1 bg-green-600 hover:bg-green-700 text-white py-3 px-4 rounded-lg transition-all">
                                                <i class="fas fa-plus mr-2"></i>Bán hàng mới
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    let cart = {};
                                    let selectedPaymentMethod = 'CASH';
                                    const staffName = '<%= user.getUsername() %>';

                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Medicine card click handlers
                                        document.querySelectorAll('.medicine-card').forEach(card => {
                                            card.addEventListener('click', () => addToCart(card));
                                        });

                                        // Payment method handlers
                                        document.querySelectorAll('.payment-btn').forEach(btn => {
                                            btn.addEventListener('click', function () {
                                                document.querySelectorAll('.payment-btn').forEach(b => {
                                                    b.classList.remove('active', 'bg-blue-50', 'border-blue-200', 'text-blue-700');
                                                    b.classList.add('bg-gray-50', 'border-gray-200', 'text-gray-700');
                                                });
                                                this.classList.remove('bg-gray-50', 'border-gray-200', 'text-gray-700');
                                                this.classList.add('active', 'bg-blue-50', 'border-blue-200', 'text-blue-700');
                                                selectedPaymentMethod = this.dataset.method;
                                            });
                                        });
                                    });

                                    function addToCart(card) {
                                        console.log('🛍️ addToCart() called');

                                        const id = card.dataset.id;
                                        const name = card.dataset.name;
                                        const unit = card.dataset.unit;
                                        const stock = parseInt(card.dataset.stock);

                                        console.log('📦 Product info:');
                                        console.log('  - id:', id);
                                        console.log('  - name:', name);
                                        console.log('  - unit:', unit);
                                        console.log('  - stock:', stock);

                                        if (stock <= 0) {
                                            alert('Thuốc này đã hết hàng!');
                                            return;
                                        }

                                        // Hiển thị popup chọn số lượng
                                        const currentQuantity = cart[id] ? cart[id].quantity : 0;
                                        const maxQuantity = stock - currentQuantity;

                                        if (maxQuantity <= 0) {
                                            alert('Đã thêm hết số lượng có sẵn trong kho!');
                                            return;
                                        }

                                        const quantity = prompt(`🛒 THÊM THUỐC VÀO GIỎ HÀNG

Thuốc: ${name}
Đơn vị: ${unit} 
Giá: 10,000 VND/${unit}
Tồn kho: ${stock}
Đã có trong giỏ: ${currentQuantity}

Nhập số lượng muốn thêm (1-${maxQuantity}):`, '1');

                                        if (quantity === null) return; // User cancelled

                                        const qty = parseInt(quantity);
                                        if (isNaN(qty) || qty < 1 || qty > maxQuantity) {
                                            alert(`Vui lòng nhập số lượng từ 1 đến ${maxQuantity}!`);
                                            return;
                                        }

                                        if (cart[id]) {
                                            cart[id].quantity += qty;
                                            console.log('➕ Added ' + qty + ' more, total:', cart[id].quantity);
                                        } else {
                                            cart[id] = { name, unit, stock, quantity: qty, price: 10000 };
                                            console.log('🆕 Added new item to cart:', cart[id]);
                                        }

                                        card.classList.add('border-blue-500', 'bg-blue-50');

                                        console.log('🛒 Cart after adding:', cart);
                                        console.log('🔢 Total items in cart:', Object.keys(cart).length);

                                        updateCart();
                                    }

                                    function removeFromCart(id) {
                                        delete cart[id];
                                        document.querySelector(`[data-id="${id}"]`).classList.remove('border-blue-500', 'bg-blue-50');
                                        updateCart();
                                    }

                                    function updateQuantity(id, quantity) {
                                        if (quantity <= 0) {
                                            removeFromCart(id);
                                            return;
                                        }
                                        if (quantity > cart[id].stock) {
                                            alert('Không đủ số lượng trong kho!');
                                            return;
                                        }
                                        cart[id].quantity = quantity;
                                        updateCart();
                                    }

                                    function updateCart() {
                                        console.log('🔄 updateCart() called');

                                        const cartItems = document.getElementById('cartItems');
                                        const cartCount = document.getElementById('cartCount');
                                        const totalAmount = document.getElementById('totalAmount');
                                        const checkoutBtn = document.getElementById('checkoutBtn');

                                        const itemCount = Object.keys(cart).length;
                                        cartCount.textContent = itemCount;

                                        console.log('🛒 Cart state in updateCart():');
                                        console.log('  - itemCount:', itemCount);
                                        console.log('  - cart object:', cart);
                                        console.log('  - checkoutBtn element:', checkoutBtn);

                                        if (itemCount === 0) {
                                            cartItems.innerHTML = `
                    <div class="text-center py-8 text-gray-500">
                        <i class="fas fa-cart-plus text-3xl mb-2"></i>
                        <p>Chọn thuốc để thêm vào giỏ hàng</p>
                    </div>
                `;
                                            totalAmount.textContent = '0 VND';
                                            checkoutBtn.disabled = true;
                                            console.log('❌ Button DISABLED - cart empty');
                                            return;
                                        }

                                        let total = 0;
                                        let html = '';

                                        Object.entries(cart).forEach(([id, item]) => {
                                            const itemTotal = item.quantity * item.price;
                                            total += itemTotal;

                                            html += `
                    <div class="bg-gray-50 p-3 rounded-lg mb-3">
                        <div class="flex justify-between items-start mb-2">
                            <span class="font-medium text-gray-900">${item.name}</span>
                            <button onclick="removeFromCart('${id}')" class="text-red-500 hover:text-red-700">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="text-sm text-gray-600 mb-2">
                            ${item.price.toLocaleString('vi-VN')} VND / ${item.unit}
                        </div>
                        <div class="flex items-center gap-2 mb-2">
                            <button onclick="updateQuantity('${id}', ${item.quantity - 1})" 
                                    class="w-8 h-8 bg-blue-500 text-white rounded-full text-sm">-</button>
                            <input type="number" value="${item.quantity}" min="1" max="${item.stock}"
                                   onchange="updateQuantity('${id}', parseInt(this.value))"
                                   class="w-16 text-center border border-gray-200 rounded py-1">
                            <button onclick="updateQuantity('${id}', ${item.quantity + 1})" 
                                    class="w-8 h-8 bg-blue-500 text-white rounded-full text-sm">+</button>
                        </div>
                        <div class="text-right font-semibold text-green-600">
                            ${itemTotal.toLocaleString('vi-VN')} VND
                        </div>
                    </div>
                `;
                                        });

                                        cartItems.innerHTML = html;
                                        totalAmount.textContent = total.toLocaleString('vi-VN') + ' VND';
                                        checkoutBtn.disabled = false;

                                        console.log('✅ Button ENABLED - cart has items');
                                        console.log('  - total amount:', total);
                                        console.log('  - button disabled:', checkoutBtn.disabled);
                                    }

                                    function searchMedicine() {
                                        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                                        document.querySelectorAll('.medicine-card').forEach(card => {
                                            const name = card.dataset.name.toLowerCase();
                                            card.style.display = name.includes(searchTerm) ? 'block' : 'none';
                                        });
                                    }

                                    function createBill() {
                                        try {
                                            console.log('🔧 CREATE BILL - SIMPLE VERSION');

                                            // Check cart first
                                            if (!cart || Object.keys(cart).length === 0) {
                                                console.log('❌ Cart empty!');
                                                alert('Vui lòng chọn ít nhất một loại thuốc!');
                                                return;
                                            }

                                            // Get customer name (optional)
                                            const customerNameEl = document.getElementById('customerName');
                                            let customerName = customerNameEl ? customerNameEl.value.trim() : '';

                                            console.log('📝 Form data:');
                                            console.log('  - Customer name: "' + customerName + '"');
                                            console.log('  - Cart items: ', Object.keys(cart).length);
                                            console.log('  - Payment method: ', selectedPaymentMethod);

                                            // Disable button
                                            const checkoutBtn = document.getElementById('checkoutBtn');
                                            checkoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...';
                                            checkoutBtn.disabled = true;

                                            // Create FormData
                                            const formData = new FormData();
                                            formData.append('customer_name', customerName || 'Khách mua thuốc');
                                            formData.append('payment_method', selectedPaymentMethod || 'CASH');

                                            // Add medicine data
                                            Object.entries(cart).forEach(([id, item]) => {
                                                formData.append('medicine_id', id);
                                                formData.append('quantity', item.quantity);
                                            });

                                            // API call
                                            fetch('<%= request.getContextPath() %>/StaffSellMedicineServlet', {
                                                method: 'POST',
                                                body: formData,
                                                credentials: 'include'
                                            })
                                                .then(response => response.json())
                                                .then(data => {
                                                    console.log('✅ API Response:', data);
                                                    checkoutBtn.innerHTML = '<i class="fas fa-receipt mr-2"></i>Bán thuốc & In hóa đơn';
                                                    checkoutBtn.disabled = false;

                                                    if (data.success) {
                                                        console.log('🎉 SUCCESS - showing bill modal');
                                                        showBillModal(data);
                                                    } else {
                                                        console.log('❌ API ERROR:', data.message);
                                                        alert('Lỗi: ' + data.message);
                                                    }
                                                })
                                                .catch(error => {
                                                    console.log('❌ FETCH ERROR:', error);
                                                    alert('Lỗi kết nối: ' + error.message);
                                                    checkoutBtn.innerHTML = '<i class="fas fa-receipt mr-2"></i>Bán thuốc & In hóa đơn';
                                                    checkoutBtn.disabled = false;
                                                });

                                        } catch (error) {
                                            console.log('❌ JAVASCRIPT ERROR:', error);
                                            alert('Lỗi JavaScript: ' + error.message);
                                        }
                                    }

                                    function generateMedicineDetails() {
                                        let details = '';
                                        Object.entries(cart).forEach(([id, item]) => {
                                            const itemTotal = item.quantity * item.price;
                                            details += `• ${item.name}\n`;
                                            details += `  ${item.quantity} ${item.unit} × ${item.price.toLocaleString('vi-VN')} = ${itemTotal.toLocaleString('vi-VN')} VND\n\n`;
                                        });
                                        return details.trim();
                                    }

                                    function showBillModal(data) {
                                        const modal = document.getElementById('billModal');
                                        const billContent = document.getElementById('billContent');
                                        const currentDate = new Date().toLocaleString('vi-VN');
                                        const medicineDetails = generateMedicineDetails();

                                        const billText = `═══════════════════════════════════════
🏥 NHA KHOA HẠNH PHÚC - BÁN THUỐC
═══════════════════════════════════════

📋 HÓA ĐƠN BÁN THUỐC

Mã hóa đơn: ${data.billId}
Ngày: ${currentDate}
Nhân viên: ${staffName}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 KHÁCH HÀNG: ${data.customerName || 'Khách mua thuốc'}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💊 CHI TIẾT THUỐC:
${medicineDetails}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💰 THANH TOÁN:
Tổng cộng: ${data.totalAmount.toLocaleString('vi-VN')} VND
Phương thức: ${data.paymentMethod || 'Tiền mặt'}
Trạng thái: ✅ ĐÃ THANH TOÁN

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📞 Liên hệ: 1900 1234
🌐 Website: nhakhoahanhphuc.com

CẢM ƠN QUÝ KHÁCH! 💙

═══════════════════════════════════════`;

                                        billContent.textContent = billText;
                                        modal.classList.remove('hidden');
                                    }

                                    function closeBillModal() {
                                        document.getElementById('billModal').classList.add('hidden');
                                    }

                                    function printBill() {
                                        const billContent = document.getElementById('billContent').textContent;
                                        const printWindow = window.open('', '', 'height=600,width=800');
                                        printWindow.document.write(`
                <html>
                    <head>
                        <title>Hóa đơn bán thuốc</title>
                        <style>body{font-family: monospace; white-space: pre-line; padding: 20px;}</style>
                    </head>
                    <body>${billContent}</body>
                </html>
            `);
                                        printWindow.document.close();
                                        printWindow.print();
                                    }

                                    function newSale() {
                                        cart = {};
                                        document.querySelectorAll('.medicine-card').forEach(card => {
                                            card.classList.remove('border-blue-500', 'bg-blue-50');
                                            card.style.display = 'block';
                                        });

                                        document.getElementById('customerName').value = '';
                                        document.getElementById('searchInput').value = '';

                                        document.querySelectorAll('.payment-btn').forEach(btn => {
                                            btn.classList.remove('active', 'bg-blue-50', 'border-blue-200', 'text-blue-700');
                                            btn.classList.add('bg-gray-50', 'border-gray-200', 'text-gray-700');
                                        });
                                        document.querySelector('[data-method="CASH"]').classList.remove('bg-gray-50', 'border-gray-200', 'text-gray-700');
                                        document.querySelector('[data-method="CASH"]').classList.add('active', 'bg-blue-50', 'border-blue-200', 'text-blue-700');
                                        selectedPaymentMethod = 'CASH';

                                        updateCart();
                                        closeBillModal();
                                    }

                                    function debugCart() {
                                        console.log('\n' + '='.repeat(60));
                                        console.log('🔍 DEBUG CART - DETAILED');
                                        console.log('='.repeat(60));

                                        // Check cart state
                                        console.log('🛒 CART STATE:');
                                        console.log('  - Cart object:', cart);
                                        console.log('  - Cart keys:', Object.keys(cart));
                                        console.log('  - Cart length:', Object.keys(cart).length);
                                        console.log('  - Cart empty?:', Object.keys(cart).length === 0);

                                        // Check button state  
                                        const checkoutBtn = document.getElementById('checkoutBtn');
                                        console.log('🎯 BUTTON STATE:');
                                        console.log('  - Button element:', checkoutBtn);
                                        console.log('  - Button disabled?:', checkoutBtn ? checkoutBtn.disabled : 'BUTTON NOT FOUND');
                                        console.log('  - Button innerHTML:', checkoutBtn ? checkoutBtn.innerHTML : 'BUTTON NOT FOUND');

                                        // Check form elements
                                        const customerNameEl = document.getElementById('customerName');
                                        console.log('📝 FORM STATE:');
                                        console.log('  - Customer name element:', customerNameEl);
                                        console.log('  - Customer name value:', customerNameEl ? customerNameEl.value : 'ELEMENT NOT FOUND');

                                        // Check payment method
                                        console.log('💳 PAYMENT STATE:');
                                        console.log('  - Selected payment method:', selectedPaymentMethod);

                                        // Manual test
                                        console.log('🧪 MANUAL TESTS:');
                                        if (Object.keys(cart).length > 0) {
                                            console.log('  ✅ Cart has items - button should be enabled');
                                            if (checkoutBtn && checkoutBtn.disabled) {
                                                console.log('  ❌ BUT BUTTON IS DISABLED! This is the problem!');
                                                console.log('  🔧 Trying to enable button...');
                                                checkoutBtn.disabled = false;
                                                checkoutBtn.style.opacity = '1';
                                                console.log('  ✅ Button manually enabled');
                                            }
                                        } else {
                                            console.log('  ❌ Cart is empty - button should be disabled');
                                        }

                                        console.log('='.repeat(60));
                                    }

                                    function manualTest() {
                                        console.log('🧪 MANUAL TEST API - BYPASSING ALL VALIDATION');

                                        // Fake data để test
                                        const testData = {
                                            customer_name: 'Test Customer',
                                            payment_method: 'CASH',
                                            medicine_id: ['1', '2'],
                                            quantity: ['1', '2']
                                        };

                                        console.log('📤 Test data:', testData);

                                        // Create FormData
                                        const formData = new FormData();
                                        formData.append('customer_name', testData.customer_name);
                                        formData.append('payment_method', testData.payment_method);

                                        testData.medicine_id.forEach(id => formData.append('medicine_id', id));
                                        testData.quantity.forEach(qty => formData.append('quantity', qty));

                                        console.log('🚀 Calling API directly...');

                                        // API call
                                        fetch('<%= request.getContextPath() %>/StaffSellMedicineServlet', {
                                            method: 'POST',
                                            body: formData,
                                            credentials: 'include'
                                        })
                                            .then(response => {
                                                console.log('📥 Response status:', response.status);
                                                console.log('📥 Response headers:', response.headers);
                                                return response.text(); // Get as text first
                                            })
                                            .then(text => {
                                                console.log('📥 Raw response text:', text);
                                                try {
                                                    const data = JSON.parse(text);
                                                    console.log('✅ Parsed JSON:', data);

                                                    if (data.success) {
                                                        alert('🎉 API TEST SUCCESS! Check console for details.');
                                                        showBillModal(data);
                                                    } else {
                                                        alert('❌ API TEST FAILED: ' + data.message);
                                                    }
                                                } catch (e) {
                                                    console.log('❌ JSON Parse Error:', e);
                                                    alert('❌ Response is not JSON: ' + text);
                                                }
                                            })
                                            .catch(error => {
                                                console.log('❌ FETCH ERROR:', error);
                                                alert('❌ Network Error: ' + error.message);
                                            });
                                    }

                                    window.onclick = function (event) {
                                        const modal = document.getElementById('billModal');
                                        if (event.target === modal) {
                                            closeBillModal();
                                        }
                                    }
                                </script>
                            </body>

                            </html>