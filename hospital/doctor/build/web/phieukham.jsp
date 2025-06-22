<%-- 
    Document   : phieukham
    Created on : May 24, 2025, 2:59:29 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="Model.Doctors"%>
<%@page import="Model.Patients"%>
<%@page import="Model.Appointment"%>
<%@page import="Model.DoctorDB"%>
<%@ include file="/include/header.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Phiếu khám bệnh</title>
        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: auto;

            }
            .container-1 {
                max-width: 1100px;
                margin: 15px auto;
                background: #f8f9fb;
                border-radius: 10px;
                padding: 20px;


            }
            .form, .section, .buttons, .summary {
                margin-bottom: 20px;
            }
            .form {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .back-btn {

                border: 1px solid #ccc;
                color: #333;
                padding: 8px 16px;
                font-size: 14px;
                border-radius: 7px;
                cursor: pointer;
                transition: background-color 0.2s ease;
                background-color: #f0f0f0;
            }
            .back-btn a{
                color: #555;
                text-decoration: none;
            }
            .back-btn:hover {
                background-color: #e0e0e0;
            }
            .profile {
                display: flex;
                gap:5px;
                align-items: center;
                padding-bottom: 60px;
            }
            .profile img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
            }
            .profile .middle,
            .profile .right {
                flex: 1;
            }

            .profile .edit-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
            }

           
            .form-group {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }
            .form-group input, textarea {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 6px;
                flex: 1;
                min-width: 220px;
            }
            textarea {
                width: 100%;
                height: 80px;
            }
            .buttons button {
                padding: 10px 16px;
                border: none;
                border-radius: 6px;
                margin-right: 10px;
                font-weight: bold;
                cursor: pointer;
            }
            .btn-blue {
                background-color: #2196f3;
                color: white;
            }
            .btn-green {
                background-color: #4caf50;
                color: white;
            }
            .summary {
                font-size: 14px;
            }

            .medicine-section {
                margin-top: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                background: white;
            }

            .medicine-item {
                display: flex;
                gap: 10px;
                margin-bottom: 10px;
                align-items: center;
            }

            .medicine-item select, .medicine-item input {
                padding: 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .remove-medicine {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 4px;
                cursor: pointer;
            }

            .add-medicine {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 10px;
            }

        </style>
    </head>
    <body>
        <%
            // Lấy appointmentId từ URL parameter
            String appointmentIdParam = request.getParameter("appointmentId");
            int appointmentId = 0;
            
            if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
                try {
                    appointmentId = Integer.parseInt(appointmentIdParam.trim());
                } catch (NumberFormatException e) {
                    appointmentId = 0;
                }
            }
            
            // Lấy thông tin bác sĩ từ session
            Doctors doctor = (Doctors) session.getAttribute("doctor");
            
            // Khởi tạo biến
            Appointment appointment = null;
            Patients patient = null;
            
            // Lấy thông tin cuộc hẹn và bệnh nhân
            try {
                if (appointmentId > 0) {
                    appointment = DoctorDB.getAppointmentWithPatientInfo(appointmentId);
                    if (appointment != null) {
                        patient = DoctorDB.getPatientByPatientId(appointment.getPatientId());
                    }
                }
            } catch (Exception e) {
                System.out.println("Lỗi khi lấy thông tin: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Thông tin mặc định
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm dd/MM/yyyy");
            Date currentTime = new Date();
            
            // Kiểm tra xem có đủ thông tin không
            if (appointmentId == 0 || doctor == null || patient == null) {
                out.println("<div style='text-align: center; padding: 50px; font-family: Arial;'>");
                out.println("<h3 style='color: #d32f2f;'>⚠️ Lỗi: Thiếu thông tin cần thiết</h3>");
                out.println("<div style='background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0;'>");
                out.println("<p><strong>appointmentId:</strong> " + appointmentId + "</p>");
                out.println("<p><strong>doctor:</strong> " + (doctor != null ? "✅ OK" : "❌ NULL") + "</p>");
                out.println("<p><strong>patient:</strong> " + (patient != null ? "✅ OK (ID: " + patient.getPatientId() + ")" : "❌ NULL") + "</p>");
                out.println("<p><strong>appointment:</strong> " + (appointment != null ? "✅ OK" : "❌ NULL") + "</p>");
                out.println("</div>");
                out.println("<p style='color: #666;'>Vui lòng thử lại hoặc liên hệ quản trị viên.</p>");
                out.println("<a href='DoctorAppointmentsServlet' style='display: inline-block; padding: 10px 20px; background: #1976d2; color: white; text-decoration: none; border-radius: 5px; margin-top: 10px;'>← Quay lại danh sách cuộc hẹn</a>");
                out.println("</div>");
                return;
            }
        %>

        <form method="post" action="MedicalReportServlet">
            <div class="container-1">
                <div class="form">
                    <h2>Tạo phiếu khám</h2>
                    <button type="button" class="back-btn">
                        <a href="DoctorAppointmentsServlet">← Quay lại</a>
                    </button>
                </div>

                <div class="profile">
                    <div class="left">
                        <img src="images/benhnhan.jpg" alt="Avatar" 
                             onerror="this.src='data:image/svg+xml,<svg xmlns=&quot;http://www.w3.org/2000/svg&quot; width=&quot;80&quot; height=&quot;80&quot; viewBox=&quot;0 0 24 24&quot; fill=&quot;%23ccc&quot;><path d=&quot;M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z&quot;/></svg>'">
                    </div>
                    <div class="middle">
                        <p><strong>Họ và tên:</strong> <%= patient != null ? patient.getFullName() : "Bệnh nhân" %> (Mã cuộc hẹn: #<%= appointmentId %>)</p>
                        <p><strong>Ngày sinh:</strong> <%= patient != null && patient.getDateOfBirth() != null ? 
                            new SimpleDateFormat("dd/MM/yyyy").format(patient.getDateOfBirth()) : "--/--/----" %></p>
                    </div>
                    <div class="right">
                        <p><strong>Giới tính:</strong> <%= patient != null && patient.getGender() != null ? 
                            ("male".equals(patient.getGender()) ? "Nam" : "Nữ") : "--" %></p>
                        <p><strong>Số điện thoại:</strong> <%= patient != null && patient.getPhone() != null ? 
                            patient.getPhone() : "----------" %></p>
                    </div>
                </div>

                <!-- Hidden fields cho servlet - lấy từ session -->
                <input type="hidden" name="appointment_id" value="<%= appointmentId %>">
                <input type="hidden" name="patient_id" value="<%= patient != null ? patient.getPatientId() : 0 %>">
                <input type="hidden" name="doctor_id" value="<%= doctor.getDoctorId() %>">

                <div class="section">
                    <p><strong>Mã phiếu khám:</strong> #<%= appointmentId %></p>
                    <p><strong>Thời gian khám:</strong> <%= timeFormat.format(currentTime) %></p>
                    <br>
                    <textarea name="diagnosis" placeholder="Chuẩn đoán" required></textarea>
                    <br><br>
                    <textarea name="treatment_plan" placeholder="Kế hoạch điều trị"></textarea>
                    <br><br>
                    <textarea name="note" placeholder="Ghi chú thêm"></textarea>
                    <br><br>
                    <input type="text" name="sign" placeholder="Chữ ký bác sĩ" style="width: 100%;">
                </div>

                <!-- Phần đơn thuốc -->
                <div class="medicine-section">
                    <h3>Đơn thuốc</h3>
                    <div id="medicine-list">
                        <div class="medicine-item">
                            <select name="medicine_id" style="width: 200px;">
                                <option value="">Chọn thuốc</option>
                                <option value="1">Paracetamol - Kho: 500 viên</option>
                                <option value="2">Amoxicillin - Kho: 300 viên</option>
                                <option value="3">Saline 0.9% - Kho: 200 chai</option>
                                <option value="4">Loperamide - Kho: 150 viên</option>
                                <option value="5">Vitamin C - Kho: 400 viên</option>
                            </select>
                            <input type="number" name="quantity" placeholder="Số lượng" min="1" style="width: 100px;">
                            <input type="text" name="usage" placeholder="Cách dùng" style="width: 200px;">
                            <button type="button" class="remove-medicine" onclick="removeMedicine(this)">Xóa</button>
                        </div>
                    </div>
                    <button type="button" class="add-medicine" onclick="addMedicine()">+ Thêm thuốc</button>
                </div>

                <div class="buttons">
                    <button type="submit" class="btn-green">Lưu phiếu khám</button>
                    <button type="reset" class="btn-blue">Làm mới</button>
                </div>

                <div class="summary">
                    <p><em>Lưu ý: Vui lòng kiểm tra kỹ thông tin trước khi lưu phiếu khám.</em></p>
                </div>
            </div>
        </form>

        <script>
            function addMedicine() {
                const medicineList = document.getElementById('medicine-list');
                const medicineItem = document.querySelector('.medicine-item').cloneNode(true);
                
                // Reset values
                medicineItem.querySelectorAll('select, input').forEach(el => el.value = '');
                
                medicineList.appendChild(medicineItem);
            }

            function removeMedicine(button) {
                const medicineList = document.getElementById('medicine-list');
                if (medicineList.children.length > 1) {
                    button.parentElement.remove();
                } else {
                    alert('Phải có ít nhất một dòng thuốc!');
                }
            }

            // Validation before submit
            document.querySelector('form').addEventListener('submit', function(e) {
                const diagnosis = document.querySelector('textarea[name="diagnosis"]').value;
                if (!diagnosis.trim()) {
                    alert('Vui lòng nhập chuẩn đoán!');
                    e.preventDefault();
                    return false;
                }

                // Check medicine selection
                const medicineSelects = document.querySelectorAll('select[name="medicine_id"]');
                const quantities = document.querySelectorAll('input[name="quantity"]');
                
                for (let i = 0; i < medicineSelects.length; i++) {
                    if (medicineSelects[i].value && !quantities[i].value) {
                        alert('Vui lòng nhập số lượng cho thuốc đã chọn!');
                        e.preventDefault();
                        return false;
                    }
                }
            });
        </script>
    </body>
</html>
