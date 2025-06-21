<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử hóa đơn</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 80%;
                margin: 50px auto;
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            .title {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .table th, .table td {
                padding: 12px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }
            .table th {
                background-color: #007bff;
                color: white;
            }
            .table tr:hover {
                background-color: #f1f1f1;
            }
            .btn {
                display: inline-block;
                padding: 8px 12px;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                transition: background 0.3s;
                margin: 0 5px;
            }
            .btn-view {
                background-color: #17a2b8;
            }
            .btn-confirm {
                background-color: #28a745;
            }
            .btn-cancel {
                background-color: #dc3545;
            }
            .btn:hover {
                opacity: 0.9;
            }
            .status {
                padding: 5px 10px;
                border-radius: 15px;
                font-weight: bold;
            }
            .status-pending {
                background-color: #ffc107;
                color: #000;
            }
            .status-confirmed {
                background-color: #28a745;
                color: white;
            }
            .status-cancelled {
                background-color: #dc3545;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="title">Lịch sử hóa đơn</h1>

            <table class="table">
                <thead>
                    <tr>
                        <th>Mã hóa đơn</th>
                        <th>Ngày lập</th>
                        <th>Giờ bắt đầu</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bill" items="${billList}">
                        <tr>
                            <td>${bill.billID}</td>
                            <td>${bill.date}</td>
                            <td>${bill.startTime}</td>
                            <td>
                                <fmt:formatNumber value="${bill.totalBill}" pattern="#,###" /> VND
                            </td>
                            <td>
                                <span class="status status-${bill.statusBill.toLowerCase()}">
                                    ${bill.statusBill}
                                </span>
                            </td>
                            <td>
                                <a href="billDetails.jsp?billID=${bill.billID}" class="btn btn-view">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div style="text-align: center; margin-top: 20px;">
                <a href="BidaShop" class="btn btn-view">Trang chủ</a>
                <c:if test="${isAdmin}">
                    <a href="admin.jsp" class="btn btn-view">Quay lại</a>
                </c:if>
            </div>
        </div>
    </body>
</html>