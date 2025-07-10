<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.BillDAO,model.Bill,java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doanh thu - Quản lý</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { margin-left: 250px; padding: 20px; }
        .header { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { padding: 10px; text-align: center; border: 1px solid #eee; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>
    <jsp:include page="manager_menu.jsp" />
    <div class="container">
        <div class="header">
            <h1><i class="fa-solid fa-coins"></i> Doanh thu</h1>
            <p>Danh sách hóa đơn gốc từ database.</p>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Mã hóa đơn</th>
                    <th>Mã bệnh nhân</th>
                    <th>Tổng tiền</th>
                    <th>Ngày tạo</th>
                </tr>
            </thead>
            <tbody>
                <%
                    BillDAO billDAO = new BillDAO();
                    List<Bill> bills = billDAO.getAllBills();
                    for (Bill bill : bills) {
                %>
                <tr>
                    <td><%= bill.getBillId() %></td>
                    <td><%= bill.getPatientId() %></td>
                    <td><%= bill.getAmount() %></td>
                    <td><%= bill.getCreatedAt() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html> 