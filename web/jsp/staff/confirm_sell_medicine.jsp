<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String customerName=(String) request.getAttribute("customer_name"); String medicineId=(String)
        request.getAttribute("medicine_id"); String medicineName=(String) request.getAttribute("medicine_name"); String
        quantity=(String) request.getAttribute("quantity"); String price=(String) request.getAttribute("price"); String
        paymentMethod=(String) request.getAttribute("payment_method"); int total=0; try {
        total=Integer.parseInt(quantity) * Integer.parseInt(price); } catch(Exception e) {} %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Xác nhận hóa đơn bán thuốc</title>
            <style>
                body {
                    background: #f8f9fa;
                    font-family: 'Segoe UI', Arial, sans-serif;
                }

                .container {
                    max-width: 500px;
                    margin: 40px auto;
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
                    padding: 32px;
                }

                h2 {
                    color: #222;
                    text-align: center;
                    margin-bottom: 8px;
                }

                .info {
                    margin-bottom: 18px;
                }

                .info strong {
                    color: #333;
                }

                .total {
                    font-size: 1.2em;
                    color: #111;
                    font-weight: bold;
                    text-align: right;
                    margin-top: 18px;
                }

                .note {
                    color: #888;
                    font-size: 0.95em;
                    text-align: center;
                    margin-top: 18px;
                }

                .back,
                .confirm {
                    display: inline-block;
                    margin: 18px 8px 0 8px;
                    padding: 10px 24px;
                    border-radius: 6px;
                    font-weight: bold;
                    text-decoration: none;
                }

                .back {
                    background: #eee;
                    color: #333;
                    border: 1px solid #ccc;
                }

                .confirm {
                    background: #111;
                    color: #fff;
                    border: none;
                }

                .bill-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 18px;
                }

                .bill-table th,
                .bill-table td {
                    border: 1px solid #e0e0e0;
                    padding: 8px 12px;
                    text-align: left;
                }

                .bill-table th {
                    background: #f5f5f5;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h2>XÁC NHẬN HÓA ĐƠN</h2>
                <div class="info">
                    <div><strong>Khách hàng:</strong>
                        <%= customerName !=null && !customerName.isEmpty() ? customerName : "Khách lẻ" %>
                    </div>
                    <div><strong>Hình thức thanh toán:</strong>
                        <%= "payos" .equals(paymentMethod) ? "QR PayOS" : "Tiền mặt" %>
                    </div>
                </div>
                <table class="bill-table">
                    <tr>
                        <th>Thuốc</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                    <tr>
                        <td>
                            <%= medicineName %>
                        </td>
                        <td>
                            <%= quantity %>
                        </td>
                        <td>
                            <%= price %> VNĐ
                        </td>
                        <td>
                            <%= total %> VNĐ
                        </td>
                    </tr>
                </table>
                <div class="total">Tổng tiền: <%= total %> VNĐ</div>
                <form method="POST" action="<%=request.getContextPath()%>/<%= " payos".equals(paymentMethod)
                    ? "StaffPayOSServlet" : "SellMedicineDirectServlet" %>">
                    <input type="hidden" name="customer_name" value="<%= customerName %>">
                    <input type="hidden" name="medicine_id" value="<%= medicineId %>">
                    <input type="hidden" name="medicine_name" value="<%= medicineName %>">
                    <input type="hidden" name="quantity" value="<%= quantity %>">
                    <input type="hidden" name="price" value="<%= price %>">
                    <input type="hidden" name="payment_method" value="<%= paymentMethod %>">
                    <a href="sell_medicine_direct.jsp" class="back">Quay lại</a>
                    <button type="submit" class="confirm">Xác nhận & Tạo hóa đơn</button>
                </form>
                <div class="note">Kiểm tra kỹ thông tin trước khi xác nhận!</div>
            </div>
        </body>

        </html>