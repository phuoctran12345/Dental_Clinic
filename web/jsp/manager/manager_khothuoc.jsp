<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.MedicineDAO,model.Medicine,java.util.List" %>
<%@ page import="dao.StaffDAO,dao.DoctorDAO,model.Staff,model.Doctors" %>
<%@ page import="dao.PatientDAO,model.Patients" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kho thuốc - Quản lý</title>
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
            <h1><i class="fa-solid fa-pills"></i> Kho thuốc</h1>
            <p>Danh sách thuốc có trong kho.</p>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Mã thuốc</th>
                    <th>Tên thuốc</th>
                    <th>Số lượng thuốc</th>
                    <th>Đơn vị</th>
                    <th>Chức năng</th>
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