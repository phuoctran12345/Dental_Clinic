<%@page contentType="text/html" pageEncoding="utf-8" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="Model.Doctors"%>

<%@ include file="/includes/header.jsp" %>

<%@ include file="/includes/sidebars.jsp" %>



<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard Layout</title>
        <style>

            body {

                padding-top: 10px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f8f9fb;
                margin: 0;
                width: 100%;


            }

            .dashboard {
                padding-left: 270px;
                padding-top: 15px;
                display: grid;
                grid-template-columns: 1.5fr 1fr;
                grid-template-rows: repeat(3, 220px); /* Mỗi hàng cao 220px */
                gap: 20px;
                padding-right: 10px;
                padding-bottom: 50px;
                box-sizing: border-box;
                min-height: 100vh;

            }

            .dashboard > div {
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 0 10px #ddd;
                overflow: auto; /* Nếu nội dung dài thì cuộn */
            }

            .calendar {
                background: linear-gradient(90deg,rgba(33, 24, 217, 1) 0%, rgba(52, 52, 186, 1) 0%, rgba(0, 212, 255, 1) 100%);
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
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
            #menu-toggle:checked ~.dashboard {
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
                min-width: max-content; /* bắt buộc không bị co lại */
            }

            .doctor-card {
                min-width: 250px;
                max-width: 250px;
                background: #fff;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 0 6px rgba(0,0,0,0.1);
                flex-shrink: 0;
            }

        </style>
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>

        <div class="dashboard">

            <div class="calendar">
                <h2>Lịch khám sắp tới</h2>
                <p><strong>28</strong> Tháng 2 2024<br>07:30 AM</p>
            </div>

            <div class="visit-count">
                <p>Số lần bạn khám tại P-Clinic</p>
                <div>02</div>
            </div>
            <div class="doctor-slider">
                <h3><strong>Bác Sĩ Đang Trực</strong></h3>
                <div class="slider-viewport">
                    <div class="slide-docter">
                        <%                List<Doctors> doctors = (List<Doctors>) request.getAttribute("doctors");
                            if (doctors != null) {
                                for (Doctors doc : doctors) {
                        %>
                        <div class="doctor-card">
                            <p><strong>Bác sĩ:</strong> <%= doc.getFullName()%></p>
                            <p>Chuyên môn: <%= doc.getSpecialty()%></p>
                            <p>SĐT: <%= doc.getPhone()%></p>
                            <p>Giá khám: 50k</p>
                            <p>
                                <span>Trạng thái:</span>
                                <i style="color:green;" class="fa-solid fa-circle fa-fade"></i>
                                <span style="color: green;"><%= doc.getStatus()%></span>
                            </p>
                        </div>
                        <%  }
                        } else {
                        %>
                        <p>Không có bác sĩ nào đang trực.</p>
                        <% } %>
                    </div>
                </div>
            </div>


            <div class="user-info">
                <h3>Thông Tin Cá Nhân</h3>

                <%    Patients patient = (Patients) session.getAttribute("patient");
                    if (patient != null) {
                %>
                <p><strong>Họ tên:</strong> <%= patient.getFullName()%></p>
                <p><strong>Điện thoại:</strong> <%= patient.getPhone()%></p>
                <%
                    Date dob = patient.getDateOfBirth(); // có thể là java.sql.Date
                    String formattedDob = "--";
                    if (dob != null) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                        formattedDob = sdf.format(dob);
                    }
                %>
                <p><strong>Ngày sinh:</strong> <%= formattedDob%></p>
                <p><strong>Giới tính:</strong> <%= patient.getGender()%></p>
                <img id="avatarImg" class="avatar-top-right" src="<%= patient.getAvatar()%>" alt="Avatar" width="35" height="35" style="border-radius: 50%; cursor: pointer;" />

                <%
                } else {
                %>
                <p>Không tìm thấy hồ sơ bệnh nhân.</p>
                <%
                    }
                %>            
            </div>

            <div class="recent-visits">
                <h3>Đã khám gần đây</h3>
                <p>Danh sách các lần khám gần nhất</p>
                <p>Khám nội tổng quát - 27/02/2024</p>
                <p>Khám tim mạch - 12/07/2023</p>
            </div>

            <div class="consultations">
                <h3>Đang chờ tư vấn</h3>
                <p>Thông tin tư vấn...</p>
            </div>

        </div>

    </body>
</html>
