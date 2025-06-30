<%@page import="Model.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="Model.Doctors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="utf-8" %>

<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebars.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Thông Tin Cá Nhân</title>
        <style>
            /* Thiết lập cơ bản - Adjusted sizes */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f7fa;
                margin: 0;
                color: #333;
                font-size: 16px; /* Reduced from 18px */
            }

            /* Khung chính */
            .dashboard {
                padding: 25px 35px 50px 280px; /* Reduced padding */
                max-width: 97%;
                margin: 0 auto;
            }

            .main-frame {
                background: white;
                border-radius: 10px; /* Reduced from 12px */
                padding: 25px; /* Reduced from 30px */
                box-shadow: 0 3px 5px rgba(0, 0, 0, 0.05); /* Reduced shadow */
            }

            /* Tiêu đề - Slightly smaller */
            .section-title {
                color: #2c5282;
                font-size: 24px; /* Reduced from 28px */
                font-weight: 700;
                margin-bottom: 25px; /* Reduced from 30px */
                padding-bottom: 12px; /* Reduced from 15px */
                border-bottom: 1px solid #e2e8f0; /* Thinner border */
            }

            /* Bảng lịch hẹn - Adjusted sizes */
            table {
                width: 100%;
                min-width: 1000px;
                border-collapse: collapse;
                background: #ffffff;
                box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1); /* Reduced shadow */
                border-radius: 6px; /* Reduced from 8px */
                overflow: hidden;
                margin-bottom: 35px; /* Reduced from 40px */
                border: 1px solid #ddd;
            }

            .appointment-table thead {
                background: #4E80EE; /* Your preferred blue */
                color: white;
            }

            .appointment-table th {
                padding: 15px 14px; /* Reduced from 18px 16px */
                font-weight: 600;
                text-align: left;
                font-size: 17px; /* Reduced from 20px */
                border-right: 1px solid rgba(255,255,255,0.3);
            }

            .appointment-table th:last-child {
                border-right: none;
            }

            .appointment-table td {
                padding: 14px; /* Reduced from 16px */
                border-bottom: 1px solid #ddd;
                border-right: 1px solid #ddd;
                font-size: 16px; /* Reduced from 18px */
            }

            .appointment-table td:last-child {
                border-right: none;
            }

            .appointment-table tbody tr:last-child td {
                border-bottom: none;
            }

            .appointment-table tbody tr:hover {
                background-color: #f0f5ff;
            }

            /* Status styling */
            .status {
                font-weight: 600;
                padding: 4px 8px; /* Reduced from 5px 10px */
                border-radius: 3px; /* Reduced from 4px */
                font-size: 15px; /* Reduced from 16px */
            }
            
            .status-confirmed {
                color: #276749;
                background-color: #f0fff4;
            }
            
            .status-pending {
                color: #975a16;
                background-color: #fffaf0;
            }
            
            .status-cancelled {
                color: #9b2c2c;
                background-color: #fff5f5;
            }

            /* Form tìm kiếm - Smaller */
            .search-form {
                display: flex;
                gap: 15px; /* Reduced from 20px */
                align-items: center;
                margin-bottom: 25px; /* Reduced from 30px */
                background: white;
                padding: 20px; /* Reduced from 25px */
                border-radius: 6px; /* Reduced from 8px */
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.08); /* Reduced shadow */
                border: 1px solid #e2e8f0;
            }

            .form-group {
                display: flex;
                align-items: center;
                gap: 10px; /* Reduced from 12px */
                flex: 1;
            }

            .form-group label {
                font-weight: 600;
                color: #4a5568;
                white-space: nowrap;
                font-size: 16px; /* Reduced from 18px */
            }

            .form-control {
                padding: 12px 14px; /* Reduced from 14px 16px */
                border: 1px solid #cbd5e0;
                border-radius: 5px; /* Reduced from 6px */
                font-size: 16px; /* Reduced from 18px */
                flex: 1;
                background: #f8fafc;
            }

            .form-control:focus {
                border-color: #4E80EE;
                outline: none;
                box-shadow: 0 0 0 2px rgba(78, 128, 238, 0.2); /* Reduced from 3px */
            }

            /* Nút - Smaller */
            .btn {
                padding: 14px 28px; /* Reduced from 16px 32px */
                background: #4E80EE;
                color: white;
                border: none;
                border-radius: 6px; /* Reduced from 8px */
                font-weight: 600;
                font-size: 16px; /* Reduced from 18px */
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* Reduced shadow */
            }

            .btn:hover {
                background: #3a5fcd;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Reduced shadow */
            }

            /* Danh sách bác sĩ - Smaller */
            .doctor-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); /* Reduced from 320px */
                gap: 20px; /* Reduced from 25px */
            }

            .doctor-card {
                background: white;
                border-radius: 6px; /* Reduced from 8px */
                padding: 20px; /* Reduced from 25px */
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* Reduced shadow */
                border: 1px solid #e2e8f0;
            }

            .doctor-card h3 {
                color: #2c5282;
                margin-top: 0;
                margin-bottom: 12px; /* Reduced from 15px */
                font-size: 18px; /* Reduced from 22px */
                font-weight: 700;
            }

            .doctor-card p {
                margin: 10px 0; /* Reduced from 12px 0 */
                color: #4a5568;
                font-size: 16px; /* Reduced from 18px */
            }

            .doctor-status {
                display: flex;
                align-items: center;
                gap: 6px; /* Reduced from 8px */
                font-size: 16px; /* Reduced from 18px */
            }

            .status-active {
                color: #28a745;
                font-weight: 600;
            }

            .status-inactive {
                color: #9E9E9E;
                font-weight: 500;
            }

            /* Thông báo trống - Smaller */
            .empty-message {
                text-align: center;
                padding: 30px; /* Reduced from 40px */
                color: #718096;
                background: #f8fafc;
                border-radius: 6px; /* Reduced from 8px */
                font-size: 17px; /* Reduced from 20px */
                margin: 15px 0; /* Reduced from 20px */
                border: 1px dashed #cbd5e0;
            }

            /* Responsive adjustments */
            @media (max-width: 1200px) {
                .dashboard {
                    padding-left: 240px; /* Reduced from 280px */
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard">
            <div class="main-frame">
                <h2 class="section-title">Danh sách lịch hẹn của bạn</h2>
                
                <div class="table-container">
                    <% List<Appointment> appointment = (List<Appointment>) request.getAttribute("appointment"); %>
                    <% if (appointment != null && !appointment.isEmpty()) { %>
                        <table class="appointment-table">
                            <thead> 
                                <tr>
                                    <th>Bác sĩ</th>
                                    <th>Ngày</th>
                                    <th>Giờ</th>
                                    <th>Trạng thái</th>
                                    <th>Lý do</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Appointment ap : appointment) { %>
                                <tr>
                                    <td><%= ap.getDoctorName() %></td>
                                    <td><%= ap.getWorkDate() %></td>
                                    <td><%= ap.getStartTime() %> - <%= ap.getEndTime() %></td>
                                    <td><span class="status status-<%= ap.getStatus().toLowerCase() %>"><%= ap.getStatus() %></span></td>
                                    <td><%= ap.getReason() != null ? ap.getReason() : "Không có" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div class="empty-message">Bạn chưa có lịch hẹn nào.</div>
                    <% } %>
                </div>

                <h2 class="section-title">Danh sách Bác sĩ</h2>
                
                <form class="search-form" method="get" action="BookingPageServlet">
                    <div class="form-group">
                        <label for="keyword">Tên bác sĩ:</label>
                        <input type="text" id="keyword" name="keyword" value="${param.keyword}" class="form-control" placeholder="Nhập tên bác sĩ">
                    </div>
                    
                    <div class="form-group">
                        <label for="specialty">Chuyên khoa:</label>
                        <select id="specialty" name="specialty" class="form-control">
                            <option value="">-- Tất cả --</option>
                            <% List<String> specialties = (List<String>) request.getAttribute("specialties"); %>
                            <% String selectedSpecialty = request.getParameter("specialty"); %>
                            <% if (specialties != null) { %>
                                <% for (String spec : specialties) { %>
                                    <option value="<%= spec %>" <%= spec.equals(selectedSpecialty) ? "selected" : "" %>>
                                        <%= spec %>
                                    </option>
                                <% } %>
                            <% } %>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn">Lọc</button>
                </form>
                
                <div class="doctor-list">
                    <% List<Doctors> doctors = (List<Doctors>) request.getAttribute("doctors"); %>
                    <% if (doctors != null && !doctors.isEmpty()) { %>
                        <% for (Doctors doc : doctors) { %>
                            <div class="doctor-card">
                                <h3><%= doc.getFullName() %></h3>
                                <p><strong>Chuyên môn:</strong> <%= doc.getSpecialty() %></p>
                                <p><strong>Số điện thoại:</strong> <%= doc.getPhone() %></p>
                                <p class="doctor-status">
                                    <strong>Trạng thái:</strong>
                                    <% if ("Active".equalsIgnoreCase(doc.getStatus())) { %>
                                        <span class="status-active">● Đang trực</span>
                                    <% } else { %>
                                        <span class="status-inactive">● Ngoại tuyến</span>
                                    <% } %>
                                </p>
                                <form action="DocterScheduleServlet" method="get">
                                    <input type="hidden" name="doctor_id" value="<%= doc.getDoctorId() %>" />
                                    <button type="submit" class="btn" style="width: 100%; margin-top: 12px;">
                                        Đặt lịch với bác sĩ này
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-message">Không có bác sĩ nào để hiển thị.</div>
                    <% } %>
                </div>
            </div>
        </div>
    </body>
</html>