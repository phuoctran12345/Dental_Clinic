<%-- 
    Document   : doctorAppointments
    Created on : Jun 17, 2025, 6:05:32 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Appointment"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách Lịch hẹn - Doctor Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Arial', sans-serif;
            }
            .header {
                background: linear-gradient(135deg, #007bff, #0056b3);
                color: white;
                padding: 2rem 0;
                margin-bottom: 2rem;
            }
            .card {
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border: none;
                border-radius: 10px;
            }
            .status-badge {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
                border-radius: 20px;
            }
            .status-confirmed {
                background-color: #28a745;
                color: white;
            }
            .status-completed {
                background-color: #6c757d;
                color: white;
            }
            .status-cancelled {
                background-color: #dc3545;
                color: white;
            }
            .appointment-card {
                transition: transform 0.2s;
                margin-bottom: 1rem;
            }
            .appointment-card:hover {
                transform: translateY(-2px);
            }
            .info-section {
                background-color: #e9ecef;
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
            }
            .no-appointments {
                text-align: center;
                padding: 3rem;
                color: #6c757d;
            }
            .btn-action {
                margin: 0.2rem;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1><i class="fas fa-calendar-check"></i> Danh sách Lịch hẹn</h1>
                        <p class="mb-0">Quản lý và theo dõi các cuộc hẹn khám bệnh</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="doctor_tongquan.jsp" class="btn btn-light">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- Thông tin người dùng -->
            <div class="info-section">
                <div class="row">
                    <div class="col-md-6">
                        <h5><i class="fas fa-user-md"></i> Thông tin bác sĩ</h5>
                        <p><strong>User ID:</strong> 
                            <span class="badge bg-primary"><%=request.getAttribute("userId")%></span>
                            <% Boolean testMode = (Boolean) request.getAttribute("testMode"); %>
                            <% if (testMode != null && testMode) { %>
                                <span class="badge bg-warning text-dark ms-2">TEST MODE</span>
                            <% } %>
                        </p>
                        <% String testReason = (String) request.getAttribute("testReason"); %>
                        <% if (testReason != null) { %>
                            <p><strong>Session Status:</strong> 
                                <small class="text-muted"><%=testReason%></small>
                            </p>
                        <% } %>
                    </div>
                    <div class="col-md-6">
                        <h5><i class="fas fa-info-circle"></i> Trạng thái hệ thống</h5>
                        <p><strong>Thời gian:</strong> 
                            <span class="text-success"><%=new java.util.Date()%></span>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Kiểm tra lỗi -->
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle"></i> <strong>Lỗi!</strong> <%=error%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Danh sách lịch hẹn -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-list"></i> Danh sách Lịch hẹn
                            </h5>
                        </div>
                        <div class="card-body">
                            <%
                                List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                
                                if (appointments != null && !appointments.isEmpty()) {
                            %>
                            <!-- Bảng thống kê -->
                            <div class="row mb-4">
                                <div class="col-md-4">
                                    <div class="card bg-info text-white">
                                        <div class="card-body text-center">
                                            <h4><%=appointments.size()%></h4>
                                            <p>Tổng số lịch hẹn</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card bg-success text-white">
                                        <div class="card-body text-center">
                                            <h4>
                                                <%
                                                    int confirmedCount = 0;
                                                    for (Appointment app : appointments) {
                                                        if ("Đã đặt".equalsIgnoreCase(app.getStatus())) {
                                                            confirmedCount++;
                                                        }
                                                    }
                                                %>
                                                <%=confirmedCount%>
                                            </h4>
                                            <p>Đã xác nhận</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card bg-warning text-dark">
                                        <div class="card-body text-center">
                                            <h4>
                                                <%
                                                    int pendingCount = appointments.size() - confirmedCount;
                                                %>
                                                <%=pendingCount%>
                                            </h4>
                                            <p>Khác</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Danh sách chi tiết -->
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th><i class="fas fa-hashtag"></i> ID</th>
                                            <th><i class="fas fa-user"></i> Bệnh nhân</th>
                                            <th><i class="fas fa-calendar"></i> Ngày khám</th>
                                            <th><i class="fas fa-clock"></i> Slot</th>
                                            <th><i class="fas fa-info-circle"></i> Trạng thái</th>
                                            <th><i class="fas fa-notes-medical"></i> Lý do</th>
                                            <th><i class="fas fa-cogs"></i> Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Appointment appointment : appointments) { %>
                                        <tr>
                                            <td>
                                                <span class="badge bg-secondary"><%=appointment.getAppointmentId()%></span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-user-circle text-primary me-2"></i>
                                                    ID: <%=appointment.getPatientId()%>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="text-primary">
                                                    <i class="fas fa-calendar-day"></i>
                                                    <%=appointment.getWorkDate() != null ? dateFormat.format(appointment.getWorkDate()) : "N/A"%>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">Slot <%=appointment.getSlotId()%></span>
                                            </td>
                                            <td>
                                                <%
                                                    String status = appointment.getStatus();
                                                    String statusClass = "status-badge ";
                                                    if ("Đã đặt".equalsIgnoreCase(status)) {
                                                        statusClass += "status-confirmed";
                                                    } else if ("Hoàn tất".equalsIgnoreCase(status)) {
                                                        statusClass += "status-completed";
                                                    } else if ("Đã hủy".equalsIgnoreCase(status)) {
                                                        statusClass += "status-cancelled";
                                                    } else {
                                                        statusClass += "bg-warning text-dark";
                                                    }
                                                %>
                                                <span class="<%=statusClass%>"><%=status != null ? status : "N/A"%></span>
                                            </td>
                                            <td>
                                                <div class="text-muted">
                                                    <%=appointment.getReason() != null && !appointment.getReason().isEmpty() ? appointment.getReason() : "Không có ghi chú"%>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary btn-action" 
                                                            title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-success btn-action"
                                                            title="Hoàn tất">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-danger btn-action"
                                                            title="Hủy">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <%
                                } else {
                            %>
                            <!-- Không có lịch hẹn -->
                            <div class="no-appointments">
                                <i class="fas fa-calendar-times fa-5x text-muted mb-3"></i>
                                <h4>Không có lịch hẹn nào</h4>
                                <p>Hiện tại bạn chưa có lịch hẹn nào được đặt.</p>
                                <a href="doctor_dangkilich.jsp" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Tạo lịch mới
                                </a>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin debug -->
            <div class="mt-4">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0"><i class="fas fa-bug"></i> Thông tin Debug</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Session Status:</strong> 
                                    <span class="text-success">Active</span>
                                </p>
                                <p><strong>Request Method:</strong> 
                                    <span class="badge bg-primary"><%=request.getMethod()%></span>
                                </p>
                                <p><strong>Test Mode:</strong> 
                                    <span class="badge bg-<%=testMode != null && testMode ? "warning" : "success"%>">
                                        <%=testMode != null && testMode ? "ON" : "OFF"%>
                                    </span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Context Path:</strong> 
                                    <code><%=request.getContextPath()%></code>
                                </p>
                                <p><strong>Servlet Path:</strong> 
                                    <code><%=request.getServletPath()%></code>
                                </p>
                                <p><strong>Server Info:</strong> 
                                    <code><%=application.getServerInfo()%></code>
                                </p>
                            </div>
                        </div>
                        
                        <!-- Test SQL Button -->
                        <div class="mt-3">
                            <button class="btn btn-info btn-sm" onclick="showTestInfo()">
                                <i class="fas fa-database"></i> Hiển thị thông tin test
                            </button>
                            <div id="testInfo" class="mt-2" style="display: none;">
                                <div class="alert alert-info">
                                    <h6>Hướng dẫn test:</h6>
                                    <ol>
                                        <li>Chạy script <code>test_data.sql</code> trong SQL Server</li>
                                        <li>Đảm bảo database <strong>Doctor</strong> có dữ liệu</li>
                                        <li>Refresh trang này để xem kết quả</li>
                                    </ol>
                                    <p><strong>Query test:</strong></p>
                                    <code>
                                        SELECT a.* FROM Appointment a<br>
                                        INNER JOIN Doctors d ON a.doctor_id = d.doctor_id<br>
                                        WHERE d.user_id = 1
                                    </code>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto-dismiss alerts
            setTimeout(function() {
                var alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    var bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);

            // Add click handlers for action buttons
            document.querySelectorAll('.btn-action').forEach(button => {
                button.addEventListener('click', function() {
                    const action = this.title;
                    const row = this.closest('tr');
                    const appointmentId = row.querySelector('.badge').textContent;
                    
                    alert(`Thực hiện ${action} cho lịch hẹn #${appointmentId}`);
                    // Ở đây bạn có thể thêm logic xử lý thực tế
                });
            });

            // Test connection button
            function testConnection() {
                fetch('/doctorAppointments')
                    .then(response => response.text())
                    .then(data => {
                        console.log('Connection test successful');
                        alert('Kết nối servlet thành công!');
                    })
                    .catch(error => {
                        console.error('Connection test failed:', error);
                        alert('Lỗi kết nối servlet!');
                    });
            }

            // Add test button
            document.addEventListener('DOMContentLoaded', function() {
                const header = document.querySelector('.header .col-md-4');
                if (header) {
                    const testBtn = document.createElement('button');
                    testBtn.className = 'btn btn-warning me-2';
                    testBtn.innerHTML = '<i class="fas fa-plug"></i> Test Servlet';
                    testBtn.onclick = testConnection;
                    header.insertBefore(testBtn, header.firstChild);
                }
            });

            // Show test info function
            function showTestInfo() {
                const testInfo = document.getElementById('testInfo');
                if (testInfo.style.display === 'none') {
                    testInfo.style.display = 'block';
                } else {
                    testInfo.style.display = 'none';
                }
            }
        </script>
    </body>
</html>
