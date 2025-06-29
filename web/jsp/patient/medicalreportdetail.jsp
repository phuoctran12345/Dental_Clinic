<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.*, model.MedicalReport, model.Prescription" %>
        <%@ include file="user_header.jsp" %>
            <%@ include file="user_menu.jsp" %>
                <% MedicalReport report=(MedicalReport) request.getAttribute("report"); List<Prescription> prescriptions
                    = (List<Prescription>) request.getAttribute("prescriptions");
                        %>
                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <title>Chi tiết báo cáo y tế</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                            <style>
                                body {
                                    font-family: 'Segoe UI', sans-serif;
                                    background: #f5f5f5;
                                    margin: 0;
                                }

                                .container {
                                    margin-left: 300px;
                                    padding: 20px;
                                }

                                .report-card {
                                    background: white;
                                    border-radius: 10px;
                                    padding: 30px;
                                    margin-bottom: 20px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                }

                                .info-row {
                                    display: flex;
                                    margin-bottom: 15px;
                                    border-bottom: 1px solid #eee;
                                    padding-bottom: 10px;
                                }

                                .label {
                                    font-weight: bold;
                                    width: 200px;
                                    color: #333;
                                }

                                .value {
                                    flex: 1;
                                    color: #666;
                                }

                                .prescription-table {
                                    margin-top: 20px;
                                }

                                .table th {
                                    background: #00796b;
                                    color: white;
                                }

                                .btn-download {
                                    background: #00796b;
                                    color: white;
                                    border: none;
                                    padding: 10px 20px;
                                    border-radius: 5px;
                                    margin-top: 20px;
                                }

                                .btn-download:hover {
                                    background: #004d40;
                                    color: white;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="container">
                                <h2 class="mb-4"><i class="fas fa-file-medical"></i> Chi tiết báo cáo y tế</h2>

                                <% if (report !=null) {%>
                                    <div class="report-card">
                                        <h4 class="text-primary mb-3">Thông tin báo cáo</h4>

                                        <div class="info-row">
                                            <div class="label">Mã báo cáo:</div>
                                            <div class="value">#<%= report.getReportId()%>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Bệnh nhân:</div>
                                            <div class="value">
                                                <%= report.getPatientName() !=null ? report.getPatientName()
                                                    : "Chưa cập nhật" %>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Bác sĩ phụ trách:</div>
                                            <div class="value">
                                                <%= report.getDoctorName() !=null ? report.getDoctorName()
                                                    : "Chưa cập nhật" %>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Chẩn đoán:</div>
                                            <div class="value">
                                                <%= report.getDiagnosis() !=null ? report.getDiagnosis()
                                                    : "Chưa có chẩn đoán" %>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Phác đồ điều trị:</div>
                                            <div class="value">
                                                <%= report.getTreatmentPlan() !=null ? report.getTreatmentPlan()
                                                    : "Chưa có phác đồ" %>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Ghi chú:</div>
                                            <div class="value">
                                                <%= report.getNote() !=null ? report.getNote() : "Không có ghi chú" %>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Ngày tạo:</div>
                                            <div class="value">
                                                <%= report.getCreatedAt() !=null ? new
                                                    java.text.SimpleDateFormat("dd/MM/yyyy
                                                    HH:mm").format(report.getCreatedAt()) : "Chưa cập nhật" %>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="label">Bác sĩ ký tên:</div>
                                            <div class="value">
                                                <%= report.getSign() !=null ? report.getSign() : "Chưa ký" %>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="report-card prescription-table">
                                        <h4 class="text-primary mb-3"><i class="fas fa-pills"></i> Đơn thuốc kê theo
                                        </h4>

                                        <% if (prescriptions !=null && !prescriptions.isEmpty()) { %>
                                            <div class="table-responsive">
                                                <table class="table table-striped">
                                                    <thead>
                                                        <tr>
                                                            <th>STT</th>
                                                            <th>Tên thuốc</th>
                                                            <th>Số lượng</th>
                                                            <th>Cách dùng</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% int stt=1; %>
                                                            <% for (Prescription p : prescriptions) {%>
                                                                <tr>
                                                                    <td>
                                                                        <%= stt++ %>
                                                                    </td>
                                                                    <td>
                                                                        <%= p.getName() !=null ? p.getName()
                                                                            : "Chưa có tên" %>
                                                                    </td>
                                                                    <td>
                                                                        <%= p.getQuantity() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= p.getUsage() !=null ? p.getUsage()
                                                                            : "Theo chỉ định bác sĩ" %>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <% } else { %>
                                                <div class="alert alert-info">
                                                    <i class="fas fa-info-circle"></i> Không có đơn thuốc nào được kê.
                                                </div>
                                                <% }%>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/ExportMedicalReportServlet"
                                        method="get">
                                        <input type="hidden" name="reportId"
                                            value="<%= report != null ? report.getReportId() : ""%>">
                                        <button type="submit" class="btn-download">
                                            <i class="fas fa-download"></i> Tải xuống PDF
                                        </button>
                                    </form>

                                    <% } else { %>
                                        <div class="report-card">
                                            <div class="alert alert-warning text-center">
                                                <i class="fas fa-exclamation-triangle"></i>
                                                <h4>Không tìm thấy báo cáo y tế</h4>
                                                <p>Có thể báo cáo chưa được tạo hoặc đã bị xóa.</p>
                                            </div>
                                        </div>
                                        <% } %>

                                            <a href="${pageContext.request.contextPath}/jsp/patient/user_datlich_bacsi.jsp"
                                                class="btn btn-secondary">
                                                <i class="fas fa-arrow-left"></i> Quay lại danh sách lịch hẹn
                                            </a>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>