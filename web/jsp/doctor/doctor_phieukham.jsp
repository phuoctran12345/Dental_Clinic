<%-- Document : doctor_phieukham Created on : 17 thg 6, 2025, 14:08:21 Author : tranhongphuoc --%>

    <%@page import="model.User" %>
        <%@page import="dao.MedicineDAO" %>
            <%@page import="model.Medicine" %>
                <%@page import="java.util.List" %>                   
                        <%@page  pageEncoding="UTF-8" %>
                            <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                                <% MedicineDAO dao=new MedicineDAO(); List<Medicine> medicines = dao.getAllMedicine();
                                    %>

                                    <html>

                                    <head>
                                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                                        <title>Nhập báo cáo y tế</title>
                                        <link rel="stylesheet"
                                            href="${pageContext.request.contextPath}/styles/global-fonts.css" />
                                        <link rel="stylesheet"
                                            href="${pageContext.request.contextPath}/styles/manager.css" />
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
                                        <jsp:include page="/jsp/doctor/doctor_header.jsp" />
                                        <jsp:include page="/jsp/doctor/doctor_menu.jsp" />

                                        <div class="main-content">
                                            <h2>Nhập báo cáo y tế & kê đơn thuốc</h2>

                                            <c:if test="${empty appointment}">
                                                <div class="error-message">
                                                    Không tìm thấy thông tin cuộc hẹn. Vui lòng thử lại.
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty appointment}">
                                                <form
                                                    action="${pageContext.request.contextPath}/InputMedicalReportServlet"
                                                    method="POST">
                                                    <input type="hidden" name="appointment_id"
                                                        value="${appointment.appointmentId}" />
                                                    <input type="hidden" name="doctor_id"
                                                        value="${sessionScope.user.userId}" />
                                                    <input type="hidden" name="patient_id"
                                                        value="${appointment.patientId}" />

                                                    <div class="form-group">
                                                        <label>Chẩn đoán:</label>
                                                        <textarea name="diagnosis" required></textarea>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Kế hoạch điều trị:</label>
                                                        <textarea name="treatment_plan" required></textarea>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Ghi chú:</label>
                                                        <textarea name="note"></textarea>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Chữ ký bác sĩ:</label>
                                                        <input type="text" name="sign" required />
                                                    </div>

                                                    <h3>Đơn thuốc</h3>
                                                    <div id="prescriptions">
                                                        <div class="prescription-item">
                                                            <select name="medicine_id" required>
                                                                <option value="">Chọn thuốc</option>
                                                                <c:forEach items="${medicines}" var="medicine">
                                                                    <option value="${medicine.medicineId}">
                                                                        ${medicine.name} (${medicine.unit})</option>
                                                                </c:forEach>
                                                            </select>
                                                            <input type="number" name="quantity" placeholder="Số lượng"
                                                                required min="1" />
                                                            <input type="text" name="usage" placeholder="Cách dùng"
                                                                required />
                                                            <button type="button"
                                                                onclick="removePrescription(this)">Xóa</button>
                                                        </div>
                                                    </div>

                                                    <button type="button" onclick="addPrescription()">Thêm
                                                        thuốc</button>
                                                    <button type="submit">Lưu báo cáo</button>
                                                </form>
                                            </c:if>
                                        </div>

                                        <script>
                                            function addPrescription() {
                                                const container = document.getElementById('prescriptions');
                                                const template = container.children[0].cloneNode(true);

                                                // Reset values
                                                template.querySelector('select').value = '';
                                                template.querySelector('input[name="quantity"]').value = '';
                                                template.querySelector('input[name="usage"]').value = '';

                                                container.appendChild(template);
                                            }

                                            function removePrescription(button) {
                                                const items = document.querySelectorAll('.prescription-item');
                                                if (items.length > 1) {
                                                    button.parentElement.remove();
                                                }
                                            }
                                        </script>
                                    </body>

                                    </html>