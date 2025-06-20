<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Services</title>
</head>
<body>
    <h1>Debug ServiceDAO</h1>
    
    <%
    try {
        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getAllServices();
        
        out.println("<h2>Kết quả getAllServices():</h2>");
        out.println("<p><strong>Số lượng dịch vụ:</strong> " + services.size() + "</p>");
        
        if (services.isEmpty()) {
            out.println("<p style='color: red;'>KHÔNG CÓ DỊCH VỤ NÀO!</p>");
            out.println("<p>Có thể do:</p>");
            out.println("<ul>");
            out.println("<li>Database connection lỗi</li>");
            out.println("<li>Bảng Services trống</li>");
            out.println("<li>Query SQL lỗi</li>");
            out.println("</ul>");
        } else {
            out.println("<h3>Danh sách dịch vụ:</h3>");
            out.println("<table border='1' style='border-collapse: collapse;'>");
            out.println("<tr><th>ID</th><th>Tên</th><th>Giá</th><th>Trạng thái</th><th>Danh mục</th></tr>");
            
            for (Service service : services) {
                out.println("<tr>");
                out.println("<td>" + service.getServiceId() + "</td>");
                out.println("<td>" + service.getServiceName() + "</td>");
                out.println("<td>" + service.getPrice() + "</td>");
                out.println("<td>" + service.getStatus() + "</td>");
                out.println("<td>" + service.getCategory() + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        
    } catch (Exception e) {
        out.println("<h2 style='color: red;'>LỖI:</h2>");
        out.println("<pre>" + e.getMessage() + "</pre>");
        e.printStackTrace();
    }
    %>
    
    <hr>
    <p><a href="javascript:history.back()">← Quay lại</a></p>
</body>
</html> 