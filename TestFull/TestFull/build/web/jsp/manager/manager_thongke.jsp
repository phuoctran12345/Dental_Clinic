<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.PatientDAO,dao.BillDAO,dao.MedicineDAO,model.Patients,model.Bill,model.Medicine,java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo thống kê - Quản lý</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { margin-left: 250px; padding: 20px; }
        .header { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        th, td { padding: 10px; text-align: center; border: 1px solid #eee; }
        th { background: #f8f9fa; }
        h2 { margin-top: 40px; }
    </style>
</head>
<body>
    <jsp:include page="manager_menu.jsp" />
    <div class="container">
        <div class="header">
            <h1><i class="fa-solid fa-chart-line"></i> Báo cáo thống kê</h1>
            <p>Danh sách dữ liệu gốc từ các bảng chính.</p>
        </div>
        <h2>Bệnh nhân</h2>
        <table>
            <thead>
                <tr>
                    <th>Mã BN</th>
                    <th>Họ tên</th>
                    <th>Ngày sinh</th>
                    <th>Giới tính</th>
                    <th>SĐT</th>
                </tr>
            </thead>
            <tbody>
                <%
                    PatientDAO patientDAO = new PatientDAO();
                    List<Patients> patients = patientDAO.getAll();
                    for (Patients p : patients) {
                %>
                <tr>
                    <td><%= p.getPatientId() %></td>
                    <td><%= p.getFullName() %></td>
                    <td><%= p.getDateOfBirth() %></td>
                    <td><%= p.getGender() %></td>
                    <td><%= p.getPhone() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <h2>Hóa đơn</h2>
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
        <h2>Thuốc</h2>
        <table>
            <thead>
                <tr>
                    <th>Mã thuốc</th>
                    <th>Tên thuốc</th>
                    <th>Số lượng tồn</th>
                    <th>Đơn vị tính</th>
                    <th>Mô tả</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Medicine> medicines = MedicineDAO.getAllMedicine();
                    for (Medicine med : medicines) {
                %>
                <tr>
                    <td><%= med.getMedicineId() %></td>
                    <td><%= med.getName() %></td>
                    <td><%= med.getQuantityInStock() %></td>
                    <td><%= med.getUnit() %></td>
                    <td><%= med.getDescription() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html> 