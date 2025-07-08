<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title> Báo Cáo Y Tế</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background: #f5f5f5; 
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .section { 
            margin: 20px 0; 
            padding: 15px; 
            border: 1px solid #ddd; 
            border-radius: 5px; 
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        h2 {
            color: #555;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 10px 0; 
        }
        th, td { 
            border: 1px solid #ddd; 
            padding: 10px; 
            text-align: left; 
        }
        th { 
            background-color: #f2f2f2; 
            font-weight: bold;
        }
        .error { 
            color: red; 
            font-weight: bold; 
            text-align: center;
        }
        .success { 
            color: green; 
            font-weight: bold; 
            text-align: center;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-link:hover {
            background-color: #0056b3;
        }
        .edit-btn, .save-btn, .cancel-btn, .delete-btn {
            padding: 8px 16px;
            margin: 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .edit-btn {
            background-color: #28a745;
            color: white;
        }
        .edit-btn:hover {
            background-color: #218838;
        }
        .save-btn {
            background-color: #17a2b8;
            color: white;
        }
        .save-btn:hover {
            background-color: #138496;
        }
        .cancel-btn {
            background-color: #6c757d;
            color: white;
        }
        .cancel-btn:hover {
            background-color: #545b62;
        }
        .delete-btn {
            background-color: #dc3545;
            color: white;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .edit-form {
            display: none;
        }
        .edit-input, .edit-textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .edit-textarea {
            min-height: 80px;
            resize: vertical;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .message {
            padding: 10px;
            margin: 15px 0;
            border-radius: 5px;
            text-align: center;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .button-group {
            text-align: right;
            margin-top: 10px;
        }
    </style>
    <script>
        function toggleEdit() {
            var viewMode = document.getElementById('view-mode');
            var editMode = document.getElementById('edit-mode');
            
            if (viewMode.style.display === 'none') {
                // Chuyển từ edit mode về view mode
                viewMode.style.display = 'block';
                editMode.style.display = 'none';
            } else {
                // Chuyển từ view mode sang edit mode
                viewMode.style.display = 'none';
                editMode.style.display = 'block';
            }
        }
        
        function cancelEdit() {
            document.getElementById('view-mode').style.display = 'block';
            document.getElementById('edit-mode').style.display = 'none';
        }
        
        function confirmSave() {
            return confirm('Bạn có chắc chắn muốn lưu những thay đổi này?');
        }
        
        function confirmDelete(reportId) {
            if (confirm('⚠️ CẢNH BÁO: Bạn có chắc chắn muốn xóa báo cáo này?\n\nViệc xóa sẽ:\n- Xóa toàn bộ báo cáo y tế\n- Xóa tất cả đơn thuốc liên quan\n- KHÔNG THỂ HOÀN TÁC\n\nBấm OK để xác nhận xóa, Cancel để hủy.')) {
                if (confirm('Xác nhận lần cuối: Bạn THỰC SỰ muốn xóa báo cáo này?')) {
                    window.location.href = '${pageContext.request.contextPath}/DeleteMedicalReportServlet?reportId=' + reportId;
                }
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>📋 Báo Cáo Y Tế</h1>
        
        <%
            // Lấy dữ liệu từ request attributes
            MedicalReport report = (MedicalReport) request.getAttribute("report");
            Patients patient = (Patients) request.getAttribute("patient");
            Doctors doctor = (Doctors) request.getAttribute("doctor");
            List<PrescriptionDetail> prescriptions = (List<PrescriptionDetail>) request.getAttribute("prescriptions");
            String timeSlot = (String) request.getAttribute("timeSlot");
            Integer appointmentId = (Integer) request.getAttribute("appointmentId");
            
            // Check for messages
            String message = request.getParameter("message");
            if (message != null) {
                if ("success".equals(message)) {
        %>
                    <div class="message success">✅ Cập nhật báo cáo thành công!</div>
        <%
                } else if ("error".equals(message)) {
        %>
                    <div class="message error">❌ Có lỗi xảy ra khi cập nhật báo cáo!</div>
        <%
                } else if ("delete_success".equals(message)) {
        %>
                    <div class="message success">✅ Xóa báo cáo thành công!</div>
        <%
                } else if ("delete_error".equals(message)) {
        %>
                    <div class="message error">❌ Có lỗi xảy ra khi xóa báo cáo!</div>
        <%
                }
            }
            
            if (report == null) {
        %>
                <p class='error'>❌ Không tìm thấy báo cáo y tế!</p>
                <a href="doctor_trongngay.jsp" class="back-link">⬅️ Quay lại</a>
        <%
            } else {
        %>
        
        <!-- VIEW MODE -->
        <div id="view-mode">
            <!-- Thông tin báo cáo -->
            <div class="section">
                <h2>📋 Thông Tin Báo Cáo</h2>
                <div class="button-group">
                    <button class="edit-btn" onclick="toggleEdit()">✏️ Chỉnh sửa</button>
                    <button class="delete-btn" onclick="confirmDelete('<%= report.getReportId() %>')">🗑️ Xóa báo cáo</button>
                </div>
                <table>
                    <tr><th>Thông Tin</th><th>Giá Trị</th></tr>
                    <tr><td><strong>Mã Báo Cáo</strong></td><td><%= report.getReportId() %></td></tr>
                    <tr><td><strong>Mã Cuộc Hẹn</strong></td><td><%= appointmentId != null ? appointmentId : report.getAppointmentId() %></td></tr>
                    <tr><td><strong>Khung Giờ Khám</strong></td><td><%= timeSlot != null ? timeSlot : "N/A" %></td></tr>
                    <tr><td><strong>Ngày Tạo Báo Cáo</strong></td><td><%= report.getCreatedAt() %></td></tr>
                    <tr><td><strong>Chẩn Đoán</strong></td><td><%= report.getDiagnosis() %></td></tr>
                    <tr><td><strong>Kế Hoạch Điều Trị</strong></td><td><%= report.getTreatmentPlan() != null ? report.getTreatmentPlan() : "Chưa có kế hoạch điều trị" %></td></tr>
                    <tr><td><strong>Ghi Chú</strong></td><td><%= report.getNote() != null ? report.getNote() : "Không có ghi chú" %></td></tr>
                    <tr><td><strong>Chữ Ký Bác Sĩ</strong></td><td><%= report.getSign() != null ? report.getSign() : "Chưa ký" %></td></tr>
                </table>
            </div>
        </div>
        
        <!-- EDIT MODE -->
        <div id="edit-mode" class="edit-form">
            <div class="section">
                <h2>✏️ Chỉnh Sửa Báo Cáo</h2>
                <form action="${pageContext.request.contextPath}/UpdateMedicalReportServlet" method="post" onsubmit="return confirmSave()">
                    <input type="hidden" name="reportId" value="<%= report.getReportId() %>">
                    
                    <table>
                        <tr><th>Thông Tin</th><th>Giá Trị</th></tr>
                        <tr><td><strong>Mã Báo Cáo</strong></td><td><%= report.getReportId() %></td></tr>
                        <tr><td><strong>Mã Cuộc Hẹn</strong></td><td><%= appointmentId != null ? appointmentId : report.getAppointmentId() %></td></tr>
                        <tr><td><strong>Khung Giờ Khám</strong></td><td><%= timeSlot != null ? timeSlot : "N/A" %></td></tr>
                        <tr><td><strong>Ngày Tạo Báo Cáo</strong></td><td><%= report.getCreatedAt() %></td></tr>
                    </table>
                    
                    <div class="form-group">
                        <label for="diagnosis">Chẩn Đoán:</label>
                        <textarea name="diagnosis" id="diagnosis" class="edit-textarea" required><%= report.getDiagnosis() != null ? report.getDiagnosis() : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="treatmentPlan">Kế Hoạch Điều Trị:</label>
                        <textarea name="treatmentPlan" id="treatmentPlan" class="edit-textarea"><%= report.getTreatmentPlan() != null ? report.getTreatmentPlan() : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="note">Ghi Chú:</label>
                        <textarea name="note" id="note" class="edit-textarea"><%= report.getNote() != null ? report.getNote() : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="sign">Chữ Ký Bác Sĩ:</label>
                        <input type="text" name="sign" id="sign" class="edit-input" value="<%= report.getSign() != null ? report.getSign() : "" %>">
                    </div>
                    
                    <div style="text-align: center; margin-top: 20px;">
                        <button type="submit" class="save-btn">💾 Lưu Thay Đổi</button>
                        <button type="button" class="cancel-btn" onclick="cancelEdit()">❌ Hủy</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Thông tin bệnh nhân -->
        <div class="section">
            <h2>👤 Thông Tin Bệnh Nhân</h2>
            <% if (patient != null) { %>
                <table>
                    <tr><th>Thông Tin</th><th>Giá Trị</th></tr>
                    <tr><td><strong>Mã Bệnh Nhân</strong></td><td><%= patient.getPatientId() %></td></tr>
                    <tr><td><strong>Họ và Tên</strong></td><td><%= patient.getFullName() %></td></tr>
                    <tr><td><strong>Ngày Sinh</strong></td><td><%= patient.getDateOfBirth() %></td></tr>
                    <tr><td><strong>Giới Tính</strong></td><td><%= patient.getGender() %></td></tr>
                    <tr><td><strong>Số Điện Thoại</strong></td><td><%= patient.getPhone() %></td></tr>
                </table>
            <% } else { %>
                <p class='error'>❌ Không tìm thấy thông tin bệnh nhân.</p>
            <% } %>
        </div>
        
        <!-- Thông tin bác sĩ -->
        <div class="section">
            <h2>👨‍⚕️ Thông Tin Bác Sĩ Khám</h2>
            <% if (doctor != null) { %>
                <table>
                    <tr><th>Thông Tin</th><th>Giá Trị</th></tr>
                    <tr><td><strong>Mã Bác Sĩ</strong></td><td><%= doctor.getDoctorId() %></td></tr>
                    <tr><td><strong>Họ và Tên</strong></td><td><%= doctor.getFullName() %></td></tr>
                    <tr><td><strong>Chuyên Khoa</strong></td><td><%= doctor.getSpecialty() %></td></tr>
                </table>
            <% } else { %>
                <p class='error'>❌ Không tìm thấy thông tin bác sĩ.</p>
            <% } %>
        </div>
        
        <!-- Danh sách đơn thuốc -->
        <div class="section">
            <h2>💊 Danh Sách Đơn Thuốc</h2>
            <% if (prescriptions != null && prescriptions.size() > 0) { %>
                <table>
                    <tr>
                        <th>Mã Đơn Thuốc</th>
                        <th>Tên Thuốc</th>
                        <th>Số Lượng</th>
                        <th>Đơn Vị</th>
                        <th>Cách Sử Dụng</th>
                    </tr>
                    <% for (PrescriptionDetail prescription : prescriptions) { %>
                        <tr>
                            <td><%= prescription.getPrescriptionId() %></td>
                            <td><%= prescription.getMedicineName() %></td>
                            <td><%= prescription.getQuantity() %></td>
                            <td><%= prescription.getUnit() %></td>
                            <td><%= prescription.getUsage() %></td>
                        </tr>
                    <% } %>
                </table>
            <% } else { %>
                <p style="text-align: center; color: #666; font-style: italic;">
                    ℹ️ Không có đơn thuốc nào được kê cho lần khám này.
                </p>
            <% } %>
        </div>
        
        <% } %>
        
        <!-- Navigation -->
        <div class="section" style="text-align: center;">
            <a href="${pageContext.request.contextPath}/DoctorAppointmentsServlet" class="back-link">⬅️ Quay về Trang Chính</a>
        </div>
    </div>
</body>
</html>
