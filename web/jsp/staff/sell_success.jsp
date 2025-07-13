<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String customerName=(String) request.getAttribute("customer_name"); String medicineName=(String)
        request.getAttribute("medicine_name"); Integer quantity=(Integer) request.getAttribute("quantity");
        java.math.BigDecimal price=(java.math.BigDecimal) request.getAttribute("price"); java.math.BigDecimal
        total=(java.math.BigDecimal) request.getAttribute("total"); %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Bán thuốc thành công</title>
            <style>
                body {
                    background: #f8f9fa;
                    font-family: 'Segoe UI', Arial, sans-serif;
                }

                .container {
                    max-width: 420px;
                    margin: 60px auto;
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
                    padding: 32px;
                    text-align: center;
                }

                .success {
                    color: #15803d;
                    font-size: 2em;
                    margin-bottom: 12px;
                }

                .info {
                    margin-bottom: 18px;
                    color: #222;
                }

                .total {
                    font-size: 1.1em;
                    color: #111;
                    font-weight: bold;
                    margin-top: 18px;
                }

                .back {
                    display: inline-block;
                    margin-top: 24px;
                    padding: 10px 24px;
                    border-radius: 6px;
                    background: #111;
                    color: #fff;
                    font-weight: bold;
                    text-decoration: none;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="success">💊 Bán thuốc thành công!</div>
                <div class="info">
                    <div><strong>Khách hàng:</strong>
                        <%= customerName !=null && !customerName.isEmpty() ? customerName : "Khách lẻ" %>
                    </div>
                    <div><strong>Thuốc:</strong>
                        <%= medicineName %>
                    </div>
                    <div><strong>Số lượng:</strong>
                        <%= quantity %>á
                    </div>
                    <div><strong>Đơn giá:</strong>
                        <%= price !=null ? String.format("%,d", price.intValue()) : "" %> VNĐ
                    </div>
                </div>
                <div class="total">Tổng tiền: <%= total !=null ? String.format("%,d", total.intValue()) : "" %> VNĐ
                </div>
                <a href="/jsp/staff/sell_medicine_direct.jsp" class="back">Quay lại bán hàng</a>
            </div>
        </body>

        </html>