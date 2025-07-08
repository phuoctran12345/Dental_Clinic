<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@page import="model.Appointment" %>
<%@page import="model.Doctors" %>
<%@page import="model.Patients" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>

<%@ include file="user_header.jsp" %>
<%@ include file="user_menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard Layout</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap&subset=vietnamese" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            .dashboard-wrapper * {
                box-sizing: border-box;
                font-family: 'Roboto', sans-serif;
            }

            .dashboard-wrapper h1,
            .dashboard-wrapper h2,
            .dashboard-wrapper h3,
            .dashboard-wrapper h4,
            .dashboard-wrapper h5,
            .dashboard-wrapper h6,
            .dashboard-wrapper p,

            .dashboard-wrapper tr,
            .dashboard-wrapper td,
            .dashboard-wrapper th {
                display: block;
            }
            .dashboard-wrapper h3{
                font-size: 20px;
                font-weight: 500;
            }



            .dashboard-wrapper * {
                all: unset;
                box-sizing: border-box;
                font-family: 'Roboto', sans-serif;
            }

            .dashboard {
                padding: 90px 10px 15px 270px;
                display: grid;
                grid-template-columns: 1.5fr 1fr;
                grid-auto-rows: minmax(100px, 1fr);
                gap: 20px;
                height: calc(108vh - 100px);
                overflow: hidden;
                font-size: 14px;
            }

            .dashboard > div {
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 0 10px #ddd;
                overflow: auto;
            }

            .calendar {
                background: linear-gradient(90deg, #2118d9 0%, #3434ba 0%, #00d4ff 100%);
                color: white;
            }

            .visit-count {
                font-size: 25px;
                font-weight: 500;
                text-align: center;
            }

            .user-info {
                position: relative;
                background: #f0f8ff;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                width: 400px;
            }

            .avatar-top-right {
                position: absolute;
                top: 15px;
                right: 15px;
                border-radius: 50%;
                width: 60px;
                height: 60px;
                object-fit: cover;
                cursor: pointer;
                border: 2px solid #00796b;
                    overflow: hidden;
            }

            .doctor-slider {
                margin-top: 10px;
                padding: 10px;
                background: #fdfdfd;
                border-radius: 12px;
                box-shadow: 0 0 10px #ccc;
            }

            .slider-viewport {
                overflow-x: auto;
                width: 100%;
                padding-bottom: 5px;
            }

            .slide-docter {
                display: flex;
                flex-wrap: nowrap;
                gap: 12px;
                min-width: max-content;
            }

            .doctor-card {
                min-width: 250px;
                background: #fff;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 0 6px rgba(0, 0, 0, 0.1);
                flex-shrink: 0;
            }

            .news-card {
                padding: 20px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .news-item {
                display: flex;
                align-items: flex-start;
                gap: 16px;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
            }

            .news-item img {
                width: 100px;
                height: 80px;
                object-fit: cover;
                border-radius: 5px;
                flex-shrink: 0;
            }

            .news-item-content {
                flex-grow: 1;
            }

            .news-item-content strong {
                font-size: 1rem;
                color: #333;
                display: block;
                margin-bottom: 6px;
            }

            .news-item-content .meta {
                color: #666;
                font-size: 0.85rem;
                margin-bottom: 6px;
            }

            .news-item-content .excerpt {
                font-size: 0.9rem;
                color: #444;
                margin-bottom: 5px;
            }

            .news-item-content a {
                font-size: 0.85rem;
                color: #287bff;
                text-decoration: none;
            }

            .view-all-link {
                display: inline-block;
                margin-top: 10px;
                padding: 6px 14px;
                background: #287bff;
                color: white;
                border-radius: 5px;
                text-decoration: none;
                font-size: 0.9rem;
            }

            .consultations {
                background: #f7f7f7;
                border-radius: 12px;
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-wrapper">
            <input type="checkbox" id="menu-toggle" hidden>

            <div class="dashboard">

                <div class="calendar">
                    <div class="recent-visits">
                        <h3>Lịch khám sắp tới</h3>
                        <h4>Danh sách các lịch hẹn gần nhất</h4>

                        <% List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments"); %>
                        <% if (upcomingAppointments != null && !upcomingAppointments.isEmpty()) { %>
                        <table style="width: 100%; text-align: left; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th>Bác sĩ</th>
                                    <th>Ngày khám</th>
                                    <th>Khung giờ</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Appointment ap : upcomingAppointments) {%>
                                <tr>
                                    <td><%= ap.getDoctorName()%></td>
                                    <td><%= ap.getWorkDate().format(java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"))%></td>
                                    <td><%= ap.getStartTime()%> - <%= ap.getEndTime()%></td>
                                    <td><%= ap.getStatus()%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <% } else { %>
                        <p>Hiện bạn chưa có lịch khám sắp tới.</p>
                        <% }%>
                    </div>
                </div>

                <div class="visit-count">
                    <h1>Số lần khám tại HAPPY SMILE</h1>
                    <div><%= request.getAttribute("totalVisits")%></div>
                </div>

                <div class="doctor-slider">
                    <h3><strong>Bác Sĩ Đang Trực</strong></h3>
                    <div class="slider-viewport">
                        <div class="slide-docter">
                            <%
                                List<Doctors> doctors = (List<Doctors>) request.getAttribute("doctors");
                                if (doctors != null) {
                                    for (Doctors doc : doctors) {
                            %>
                            <div class="doctor-card">
                                <p><strong>Bác sĩ:</strong> <%= doc.getFull_name()%></p>
                                <p>Chuyên môn: <%= doc.getSpecialty()%></p>
                                <p>SĐT: <%= doc.getPhone()%></p>
                                <p>Giá khám: 50k</p>
                                <p>
                                    <span>Trạng thái:</span>
                                    <i style="color:green;" class="fa-solid fa-circle fa-fade"></i>
                                    <span style="color: green;"><%= doc.getStatus()%></span>
                                </p>
                            </div>
                            <% }
                        } else { %>
                            <p>Không có bác sĩ nào đang trực.</p>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="user-info">
                    <h3>Thông Tin Cá Nhân</h3>
                    <%
                        Patients patient = (Patients) session.getAttribute("patient");
                        if (patient != null) {
                            String formattedDob = "--";
                            Date dob = patient.getDateOfBirth();
                            if (dob != null) {
                                formattedDob = new SimpleDateFormat("dd-MM-yyyy").format(dob);
                            }
                    %>
                    <p><strong>Họ tên:</strong> <%= patient.getFullName()%></p>
                    <p><strong>Điện thoại:</strong> <%= patient.getPhone()%></p>
                    <p><strong>Ngày sinh:</strong> <%= formattedDob%></p>
                    <p><strong>Giới tính:</strong> <%= patient.getGender()%></p>

                    <%
                        String avatar = patient.getAvatar() != null ? patient.getAvatar() : "";
                        if (!avatar.isEmpty()) {
                    %>
                    <img src="${pageContext.request.contextPath}<%= avatar%>" class="avatar-top-right" alt="Ảnh đại diện" />
                    <% } else { %>
                    <div class="avatar-top-right">Không có ảnh</div>
                    <% } %>
                    <% } else { %>
                    <p>Không tìm thấy hồ sơ bệnh nhân.</p>
                    <% } %>
                </div>

                <div class="news-card">
                    <h3>Tin tức mới nhất</h3>
                    <%
                        List<model.BlogPost> latestBlogs = (List<model.BlogPost>) request.getAttribute("latestBlogs");
                        if (latestBlogs != null && !latestBlogs.isEmpty()) {
                            int count = 0;
                            for (model.BlogPost blog : latestBlogs) {
                                if (count++ == 2)
                                    break;
                    %>
                    <div class="news-item">
                        <img src="<%= request.getContextPath() + "/" + blog.getImageUrl()%>" onerror="this.onerror=null;this.src='<%= request.getContextPath()%>/img/default-dental-placeholder.jpg';" alt="Ảnh bài viết" />
                        <div class="news-item-content">
                            <strong><%= blog.getTitle()%></strong>
                            <div class="meta"><%= blog.getCreatedAt().toString().substring(0, 16)%></div>
                            <div class="excerpt"><%= blog.getContent().length() > 100 ? blog.getContent().substring(0, 100) + "..." : blog.getContent()%></div>
                            <a href="<%= request.getContextPath()%>/blog?action=detail&blog_id=<%= blog.getBlogId()%>">Xem chi tiết</a>
                        </div>
                    </div>
                    <% }%>
                    <a href="<%= request.getContextPath()%>/blog" class="view-all-link">Xem tất cả tin tức</a>
                    <% } else { %>
                    <p>Chưa có bài viết nào.</p>
                    <% }%>
                </div>

                <div class="consultations">
                    <h3>Đang chờ tư vấn</h3>
                    <p>Thông tin tư vấn...</p>
                </div>

            </div>
        </div>
    </body>
</html>
