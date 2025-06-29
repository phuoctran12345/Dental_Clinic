<%@ page  language="java" %>
<%@ page import="java.util.*,
         model.MedicalReport, 
         model.Prescription" %>
<%
    MedicalReport report = (MedicalReport) request.getAttribute("report");
    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi ti?t báo cáo y t?</title>
    </head>
    <body>
        <h2>Chi ti?t báo cáo y t?</h2>

        <% if (report != null) {%>
        <p><strong>B?nh nhân:</strong> <%= report.getPatientName()%></p>
        <p><strong>Bác s?:</strong> <%= report.getDoctorName()%></p>
        <p><strong>Ch?n ?oán:</strong> <%= report.getDiagnosis()%></p>
        <p><strong>Phác ?? ?i?u tr?:</strong> <%= report.getTreatmentPlan()%></p>
        <p><strong>Ghi chú:</strong> <%= report.getNote()%></p>
        <p><strong>Bác s? ký tên:</strong> <%= report.getSign()%></p>
        <% } else { %>
        <p>Không tìm th?y báo cáo y t?.</p>
        <% } %>

        <h3>??n thu?c</h3>
        <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>Tên thu?c</th>
                <th>S? l??ng</th>
                <th>Cách dùng</th>
            </tr>
            <% for (Prescription p : prescriptions) {%>
            <tr>
                <td><%= p.getName()%></td>
                <td><%= p.getQuantity()%></td>
                <td><%= p.getUsage()%></td>
            </tr>
            <% } %>
        </table>
        <% } else { %>
        <p>Không có ??n thu?c nào ???c kê.</p>
        <% }%>

        <br>
        <form action="ExportMedicalReportServlet" method="get">
            <input type="hidden" name="reportId" value="<%= report != null ? report.getReportId() : ""%>">
            <button type="submit">T?i PDF</button>
        </form>
    </body>
</html>