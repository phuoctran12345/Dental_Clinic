<%@page import="model.Appointment" %>
    <%@page import="java.util.List" %>
        <%@page pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Lịch khám hôm nay</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    body {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    .container {
                        background: rgba(255, 255, 255, 0.95);
                        border-radius: 20px;
                        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                        backdrop-filter: blur(10px);
                        margin-top: 30px;
                        margin-bottom: 30px;
                    }

                    .header-section {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        text-align: center;
                        padding: 30px;
                        border-radius: 20px 20px 0 0;
                        margin: -15px -15px 30px -15px;
                    }

                    .header-section h1 {
                        margin: 0;
                        font-size: 2.5rem;
                        font-weight: 600;
                    }

                    .debug-info {
                        background: #e3f2fd;
                        border-left: 4px solid #2196f3;
                        padding: 15px;
                        border-radius: 8px;
                        margin-bottom: 30px;
                    }

                    .appointments-table {
                        background: white;
                        border-radius: 15px;
                        overflow: hidden;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                    }

                    .table th {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        padding: 20px 15px;
                        font-weight: 600;
                        text-align: center;
                    }

                    .table td {
                        padding: 15px;
                        vertical-align: middle;
                        border-bottom: 1px solid #f1f3f4;
                        text-align: center;
                    }

                    .table tbody tr:hover {
                        background-color: #f8f9ff;
                        transform: translateY(-2px);
                        transition: all 0.3s ease;
                    }

                    .btn-report {
                        background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
                        color: white;
                        text-decoration: none;
                        padding: 8px 16px;
                        border-radius: 25px;
                        font-size: 0.9rem;
                        font-weight: 500;
                        transition: all 0.3s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .btn-report:hover {
                        color: white;
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
                    }

                    .status-badge {
                        padding: 5px 12px;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        font-weight: 500;
                    }

                    .status-pending {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .status-completed {
                        background: #d1edff;
                        color: #0c5460;
                    }

                    .no-appointments {
                        text-align: center;
                        padding: 60px 20px;
                        color: #666;
                    }

                    .no-appointments i {
                        font-size: 4rem;
                        color: #ddd;
                        margin-bottom: 20px;
                    }

                    .appointment-id {
                        font-weight: 600;
                        color: #667eea;
                    }

                    .patient-id {
                        background: #f0f7ff;
                        padding: 5px 10px;
                        border-radius: 15px;
                        font-weight: 500;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <div class="header-section">
                        <h1><i class="fas fa-calendar-day me-3"></i>Lịch khám hôm nay</h1>
                    </div>

                    <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                            Long doctorId = (Long) request.getAttribute("doctorId");
                            Integer userId = (Integer) request.getAttribute("userId");
                            %>

                            <div class="debug-info">
                                <strong><i class="fas fa-info-circle me-2"></i>Thông tin debug:</strong>
                                User ID: <span class="badge bg-primary">
                                    <%= userId %>
                                </span>,
                                Doctor ID: <span class="badge bg-success">
                                    <%= doctorId %>
                                </span>
                            </div>

                            <% if (appointments !=null && !appointments.isEmpty()) { %>
                                <div class="appointments-table">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th><i class="fas fa-hashtag me-2"></i>ID Lịch</th>
                                                <th><i class="fas fa-user me-2"></i>ID Bệnh nhân</th>
                                                <th><i class="fas fa-calendar me-2"></i>Ngày khám</th>
                                                <th><i class="fas fa-clock me-2"></i>Ca khám</th>
                                                <th><i class="fas fa-flag me-2"></i>Trạng thái</th>
                                                <th><i class="fas fa-comment-medical me-2"></i>Lý do</th>
                                                <th><i class="fas fa-file-medical me-2"></i>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Appointment appointment : appointments) { %>
                                                <tr>
                                                    <td>
                                                        <span class="appointment-id">#<%= appointment.getAppointmentId()
                                                                %></span>
                                                    </td>
                                                    <td>
                                                        <span class="patient-id">
                                                            <%= appointment.getPatientId() %>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <strong>
                                                            <%= appointment.getWorkDate() %>
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info">Ca <%= appointment.getSlotId() %>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-pending">
                                                            <%= appointment.getStatus() %>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <em>
                                                            <%= appointment.getReason() %>
                                                        </em>
                                                    </td>
                                                    <td>
                                                        <a class="btn-report"
                                                            href="jsp/doctor/doctor_thembaocao.jsp?appointment_id=<%= appointment.getAppointmentId() %>&patient_id=<%= appointment.getPatientId() %>&doctor_id=<%= doctorId %>">
                                                            <i class="fas fa-plus-circle"></i>
                                                            Nhập báo cáo
                                                        </a>
                                                    </td>
                                                </tr>
                                                <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                <% } else { %>
                                    <div class="no-appointments">
                                        <i class="fas fa-calendar-times"></i>
                                        <h4>Không có lịch khám nào hôm nay</h4>
                                        <p class="text-muted">Hiện tại không có cuộc hẹn nào được lên lịch.</p>
                                    </div>
                                    <% } %>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>