<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.MedicalReport, model.Prescription" %>
<%
    MedicalReport report = (MedicalReport) request.getAttribute("report");
    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết báo cáo y tế</title>
    </head>
    <body>
        <h2>Chi tiết báo cáo y tế</h2>

        <% if (report != null) {%>
        <p><strong>Bệnh nhân:</strong> <%= report.getPatientName()%></p>
        <p><strong>Bác sĩ:</strong> <%= report.getDoctorName()%></p>
        <p><strong>Chẩn đoán:</strong> <%= report.getDiagnosis()%></p>
        <p><strong>Phác đồ điều trị:</strong> <%= report.getTreatmentPlan()%></p>
        <p><strong>Ghi chú:</strong> <%= report.getNote()%></p>
        <p><strong>Bác sĩ ký tên:</strong> <%= report.getSign()%></p>
        <% } else { %>
        <p>Không tìm thấy báo cáo y tế.</p>
        <% } %>

        <h3>Đơn thuốc</h3>
        <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>Tên thuốc</th>
                <th>Số lượng</th>
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
        <p>Không có đơn thuốc nào được kê.</p>
        <% }%>

        <br>
        <form action="ExportMedicalReportServlet" method="get">
            <input type="hidden" name="reportId" value="<%= report != null ? report.getReportId() : ""%>">
            <button type="submit">Tải PDF</button>
        </form>
    </body>
</html>
