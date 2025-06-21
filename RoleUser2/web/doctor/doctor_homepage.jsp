
<%@page import="Model.User"%>
<%@page import="Model.MedicineDAO"%>
<%@page import="Model.Medicine"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    MedicineDAO dao = new MedicineDAO();
    List<Medicine> medicines = dao.getAllMedicine();
%>

<html>
    <head>
        <title>Nhập báo cáo y tế & kê đơn thuốc</title>
        <script>
            function renderMedicineFields() {
                const num = document.getElementById("numMedicines").value;
                const container = document.getElementById("medicineFields");
                container.innerHTML = ""; // Xóa cũ

                for (let i = 0; i < num; i++) {
                    const div = document.createElement("div");
                    div.style.marginBottom = "15px";
                    div.style.border = "1px solid #ccc";
                    div.style.padding = "10px";

                    div.innerHTML = `
                        <label>Thuốc ${i + 1}:</label><br>
                        <select name="medicine_id" required>
                            <option value="">-- Chọn thuốc --</option>
            <% for (Medicine med : medicines) {%>
                                <option value="<%= med.getMedicineId()%>"><%= med.getName()%></option>
            <% } %>
                        </select><br><br>

                        <label>Số lượng:</label><br>
                        <input type="number" name="quantity" min="1" required><br><br>

                        <label>Cách dùng:</label><br>
                        <input type="text" name="usage" required><br>
                    `;
                    container.appendChild(div);
                }
            }
        </script>
    </head>
    <body>
        <h2>Nhập báo cáo y tế & kê đơn thuốc</h2>

        <%
            int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
            int patientId = Integer.parseInt(request.getParameter("patient_id"));
            User user = (User) session.getAttribute("user"); // bác sĩ
        %>
        <form action="${pageContext.request.contextPath}/InputMedicalReportServlet" method="post">
            <!-- Ẩn các giá trị này, tự động truyền -->
            <input type="hidden" name="appointment_id" value="<%= appointmentId%>">
            <input type="hidden" name="patient_id" value="<%= patientId%>">
            <input type="hidden" name="doctor_id" value="<%= user.getUserId()%>">

            <label>Chẩn đoán:</label><br>
            <textarea name="diagnosis" rows="3" cols="50" required></textarea><br><br>

            <label>Phác đồ điều trị:</label><br>
            <textarea name="treatment_plan" rows="3" cols="50" required></textarea><br><br>

            <label>Ghi chú:</label><br>
            <textarea name="note" rows="3" cols="50"></textarea><br><br>

            <label>Ký tên bác sĩ:</label><br>
            <input type="text" name="sign" required><br><br>

            <hr>
            <h3>Kê đơn thuốc</h3>
            <label for="numMedicines">Số loại thuốc:</label>
            <input type="number" id="numMedicines" name="numMedicines" min="1" max="10" required onchange="renderMedicineFields()">

            <div id="medicineFields"></div>

            <br>
            <button type="submit">Lưu báo cáo & kê đơn thuốc</button>
        </form>
    </body>
</html>