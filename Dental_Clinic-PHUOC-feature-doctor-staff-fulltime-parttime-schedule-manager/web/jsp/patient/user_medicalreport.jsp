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
        <title>Chi ti?t b�o c�o y t?</title>
    </head>
    <body>
        <h2>Chi ti?t b�o c�o y t?</h2>

        <% if (report != null) {%>
        <p><strong>B?nh nh�n:</strong> <%= report.getPatientName()%></p>
        <p><strong>B�c s?:</strong> <%= report.getDoctorName()%></p>
        <p><strong>Ch?n ?o�n:</strong> <%= report.getDiagnosis()%></p>
        <p><strong>Ph�c ?? ?i?u tr?:</strong> <%= report.getTreatmentPlan()%></p>
        <p><strong>Ghi ch�:</strong> <%= report.getNote()%></p>
        <p><strong>B�c s? k� t�n:</strong> <%= report.getSign()%></p>
        <% } else { %>
        <p>Kh�ng t�m th?y b�o c�o y t?.</p>
        <% } %>

        <h3>??n thu?c</h3>
        <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>T�n thu?c</th>
                <th>S? l??ng</th>
                <th>C�ch d�ng</th>
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
        <p>Kh�ng c� ??n thu?c n�o ???c k�.</p>
        <% }%>

        <br>
        <form action="ExportMedicalReportServlet" method="get">
            <input type="hidden" name="reportId" value="<%= report != null ? report.getReportId() : ""%>">
            <button type="submit">T?i PDF</button>
        </form>
    </body>
</html>