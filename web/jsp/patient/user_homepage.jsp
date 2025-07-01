<%-- 
    Document   : user_homepage
    Created on : 17 thg 6, 2025, 22:32:47
    Author     : tranhongphuoc
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%-- HÃY ĐẢM BẢO FILE NÀY ĐƯỢC LƯU VỚI ENCODING UTF-8 TRONG IDE --%>
        <%@page import="model.Appointment" %>
            <%@page import="java.text.SimpleDateFormat" %>
                <%@page import="java.util.Date" %>
                    <%@page import="java.util.List" %>
                        <%@page import="model.Doctors" %>
                            <%@page import="model.Patients" %>

                                <%@ include file="/jsp/patient/user_header.jsp" %>
                                    <%@ include file="/jsp/patient/user_menu.jsp" %>

                                        <!DOCTYPE html>
                                        <html lang="vi">

                                        <head>
                                            <meta charset="UTF-8" />
                                            <meta name="viewport" content="width=device-width, initial-scale=1" />
                                            <title>Dashboard Layout</title>
                                            <!-- Đảm bảo subset=vietnamese để hỗ trợ tiếng Việt -->
                                            <link
                                                href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap&subset=vietnamese"
                                                rel="stylesheet">
                                            <link rel="stylesheet"
                                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                                            <style>
                                                body {
                                                    font-family: 'Roboto', Arial, Helvetica, sans-serif;
                                                    padding-top: 10px;
                                                    background: #f8f9fb;
                                                    margin: 0;
                                                    width: 100%;
                                                }

                                                h1,
                                                h2,
                                                h3,
                                                h4,
                                                h5,
                                                h6 {
                                                    font-family: 'Roboto', Arial, Helvetica, sans-serif;
                                                    font-weight: 500;
                                                }

                                                p,
                                                span,
                                                td,
                                                th {
                                                    font-family: 'Roboto', Arial, Helvetica, sans-serif;
                                                    font-weight: 400;
                                                }

                                                .dashboard {
                                                    padding-left: 270px;
                                                    padding-top: 15px;
                                                    display: grid;
                                                    grid-template-columns: 1.5fr 1fr;
                                                    grid-template-rows: repeat(3, 220px);
                                                    gap: 20px;
                                                    padding-right: 10px;
                                                    padding-bottom: 50px;
                                                    box-sizing: border-box;
                                                    min-height: 100vh;
                                                }

                                                .dashboard>div {
                                                    border-radius: 12px;
                                                    padding: 20px;
                                                    box-shadow: 0 0 10px #ddd;
                                                    overflow: auto;
                                                }

                                                .calendar {
                                                    background: linear-gradient(90deg, rgba(33, 24, 217, 1) 0%, rgba(52, 52, 186, 1) 0%, rgba(0, 212, 255, 1) 100%);
                                                    color: white;
                                                }

                                                .visit-count {
                                                    font-size: 28px;
                                                    font-weight: bold;
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
                                                }

                                                .calendar h2,
                                                .doctors-slider h3,
                                                .user-info h3,
                                                .recent-visits h3,
                                                .consultations h3 {
                                                    margin-bottom: 10px;
                                                }

                                                .calendar p {
                                                    font-size: 20px;
                                                    line-height: 1.6;
                                                }

                                                #menu-toggle:checked~.dashboard {
                                                    transform: translateX(-125px);
                                                    transition: transform 0.3s ease;
                                                }

                                                .dashboard {
                                                    transition: transform 0.3s ease;
                                                }

                                                .doctor-slider {
                                                    margin-top: 10px;
                                                    padding: 10px;
                                                    background: #fdfdfd;
                                                    border-radius: 12px;
                                                    box-shadow: 0 0 10px #ccc;
                                                    overflow: hidden;
                                                }

                                                .slider-viewport {
                                                    overflow-x: auto;
                                                    overflow-y: hidden;
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
                                                    max-width: 250px;
                                                    background: #fff;
                                                    padding: 15px;
                                                    border-radius: 10px;
                                                    box-shadow: 0 0 6px rgba(0, 0, 0, 0.1);
                                                    flex-shrink: 0;
                                                }
                                            </style>
                                        </head>

                                        <body>
                                            <input type="checkbox" id="menu-toggle" hidden>

                                            <div class="dashboard">

                                                <div class="calendar">
                                                    <div class="recent-visits">
                                                        <h3>Lịch khám sắp tới</h3>
                                                        <p>Danh sách các lịch hẹn gần nhất</p>

                                                        <% List<Appointment> upcomingAppointments = (List<Appointment>)
                                                                request.getAttribute("upcomingAppointments");
                                                                %>

                                                                <% if (upcomingAppointments !=null &&
                                                                    !upcomingAppointments.isEmpty()) { %>
                                                                    <table class="table table-bordered"
                                                                        style="width: 100%; text-align: left;">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Bác sĩ</th>
                                                                                <th>Ngày khám</th>
                                                                                <th>Khung giờ</th>
                                                                                <th>Trạng thái</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% for (Appointment ap :
                                                                                upcomingAppointments) { %>
                                                                                <tr>
                                                                                    <td>
                                                                                        <%= ap.getDoctorName()%>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%=
                                                                                            ap.getWorkDate().format(java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"))%>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= ap.getStartTime()%> - <%=
                                                                                                ap.getEndTime()%>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= ap.getStatus()%>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                    <% } else { %>
                                                                        <p>Hiện bạn chưa có lịch khám sắp tới.</p>
                                                                        <% } %>
                                                    </div>
                                                </div>

                                                <div class="visit-count">
                                                    <p>Số lần bạn khám tại HAPPY SMILE</p>
                                                    <div>
                                                        <%= request.getAttribute("totalVisits")%>
                                                    </div>
                                                </div>
                                                <div class="doctor-slider">
                                                    <h3><strong>Bác Sĩ Đang Trực</strong></h3>
                                                    <div class="slider-viewport">
                                                        <div class="slide-docter">
                                                            <% List<Doctors> doctors = (List<Doctors>)
                                                                    request.getAttribute("doctors");
                                                                    if (doctors != null) {
                                                                    for (Doctors doc : doctors) {
                                                                    %>
                                                                    <div class="doctor-card">
                                                                        <p><strong>Bác sĩ:</strong>
                                                                            <%= doc.getFull_name()%>
                                                                        </p>
                                                                        <p>Chuyên môn: <%= doc.getSpecialty()%>
                                                                        </p>
                                                                        <p>SĐT: <%= doc.getPhone()%>
                                                                        </p>
                                                                        <p>Giá khám: 50k</p>
                                                                        <p>
                                                                            <span>Trạng thái:</span>
                                                                            <i style="color:green;"
                                                                                class="fa-solid fa-circle fa-fade"></i>
                                                                            <span style="color: green;">
                                                                                <%= doc.getStatus()%>
                                                                            </span>
                                                                        </p>
                                                                    </div>
                                                                    <% } } else { %>
                                                                        <p>Không có bác sĩ nào đang trực.</p>
                                                                        <% } %>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="user-info">
                                                    <h3>Thông Tin Cá Nhân</h3>

                                                    <% Patients patient=(Patients) session.getAttribute("patient"); if
                                                        (patient !=null) { String formattedDob="--" ; Date
                                                        dob=patient.getDateOfBirth(); if (dob !=null) { SimpleDateFormat
                                                        sdf=new SimpleDateFormat("dd-MM-yyyy");
                                                        formattedDob=sdf.format(dob); } %>
                                                        <p><strong>Họ tên:</strong>
                                                            <%= patient.getFullName()%>
                                                        </p>
                                                        <p><strong>Điện thoại:</strong>
                                                            <%= patient.getPhone()%>
                                                        </p>
                                                        <p><strong>Ngày sinh:</strong>
                                                            <%= formattedDob%>
                                                        </p>
                                                        <p><strong>Giới tính:</strong>
                                                            <%= patient.getGender()%>
                                                        </p>
                                                        <% if (patient.getAvatar() !=null) { %>
                                                            <img id="avatarImg" class="avatar-top-right"
                                                                src="<%= patient.getAvatar()%>" alt="Avatar" width="35"
                                                                height="35"
                                                                style="border-radius: 50%; cursor: pointer;" />
                                                            <% } else { %>
                                                                <img id="avatarImg" class="avatar-top-right"
                                                                    src="images/default-avatar.jpg" alt="Avatar"
                                                                    width="35" height="35"
                                                                    style="border-radius: 50%; cursor: pointer;" />
                                                                <% } %>

                                                                    <% } else { %>
                                                                        <p>Không tìm thấy hồ sơ bệnh nhân.</p>
                                                                        <% } %>
                                                </div>

                                                <div class="dontknow">

                                                </div>




                                                <div class="consultations">
                                                    <h3>Đang chờ tư vấn</h3>
                                                    <p>Thông tin tư vấn...</p>
                                                </div>

                                            </div>

                                        </body>

                                        </html>