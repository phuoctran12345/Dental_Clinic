<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="java.math.BigDecimal" %>
        <%@page import="model.Bill" %>
            <% Bill bill=(Bill) request.getAttribute("bill"); String medicineName=(String)
                request.getAttribute("medicineName"); Integer quantity=(Integer) request.getAttribute("quantity");
                BigDecimal price=(BigDecimal) request.getAttribute("price"); BigDecimal total=(BigDecimal)
                request.getAttribute("total"); String qrCode=(String) request.getAttribute("qrCode"); %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Hóa đơn bán thuốc - QR PayOS</title>
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

                        .qr {
                            text-align: center;
                            margin: 24px 0;
                        }

                        .qr img {
                            width: 220px;
                            height: 220px;
                            border-radius: 8px;
                            border: 1px solid #eee;
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

                        .back {
                            display: block;
                            margin: 24px auto 0;
                            text-align: center;
                            color: #2563eb;
                            text-decoration: none;
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
                        <h2>HÓA ĐƠN BÁN THUỐC</h2>
                        <div class="info">
                            <div><strong>Mã hóa đơn:</strong>
                                <%= bill !=null ? bill.getBillId() : "" %>
                            </div>
                            <div><strong>Khách hàng:</strong>
                                <%= bill !=null ? bill.getCustomerName() : "" %>
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
                                    <%= price !=null ? String.format("%,d", price.intValue()) : "" %> VNĐ
                                </td>
                                <td>
                                    <%= total !=null ? String.format("%,d", total.intValue()) : "" %> VNĐ
                                </td>
                            </tr>
                        </table>
                        <div class="total">Tổng tiền: <%= total !=null ? String.format("%,d", total.intValue()) : "" %>
                                VNĐ</div>
                        <div class="qr">
                            <p><strong>Quét mã QR để thanh toán qua PayOS:</strong></p>
                            <% if (qrCode !=null && !qrCode.isEmpty()) { %>
                                <img src="<%= qrCode %>" alt="QR PayOS" />
                                <% } else { %>
                                    <div style="color:red;">Không tạo được mã QR. Vui lòng thử lại!</div>
                                    <% } %>
                        </div>
                        <div class="note">Sau khi thanh toán thành công, vui lòng báo cho nhân viên để xác nhận và nhận
                            thuốc.</div>
                        <a href="sell_medicine_direct.jsp" class="back">← Quay lại bán hàng</a>
                    </div>
                </body>

                </html>