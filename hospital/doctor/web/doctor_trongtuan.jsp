<%-- 
    Document   : doctor_trongtuan
    Created on : Jun 2, 2025, 3:07:51 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/menu.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                background: #f4f6f9;
            }

            .container-fluid {
                min-height: 100vh;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 10px;
                border-radius: 10px;
            }
            #menu-toggle:checked ~ .container-fluid {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
            }
            .debug-info {
                background: white;
                padding: 15px;
                border-radius: 5px;
                font-size: 0.9em;
                margin-bottom: 20px;
                border: 1px solid #dee2e6;
            }
            .simple-schedule {
                border: 2px solid #007bff;
                padding: 15px;
                margin: 10px 0;
                border-radius: 10px;
                background: white;
            }
            .schedule-card {
                background: white;
                border: 2px solid #007bff;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .doctor-info {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px;
                border-radius: 15px 15px 0 0;
            }
            .menu a,
            #menu a {
                text-decoration: none !important;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="main-container">
                        <!-- Header -->
                        <div class="page-header">
                            <h1><i class="fas fa-calendar-alt me-3"></i>${pageTitle}</h1>
                            <p class="mb-0">Quản lý và xem lịch làm việc của bác sĩ</p>
                        </div>

                        <!-- Debug Information -->
                        <div class="debug-info">
                            <strong>Số lượng lịch:</strong> ${schedules != null ? schedules.size() : 0}<br>
                            
                            
                            

                            <c:if test="${schedules != null and not empty schedules}">
                                <strong>Chi tiết lịch đầu tiên:</strong><br>
                                - Schedule ID: ${schedules[0].scheduleId}<br>
                                - Doctor ID: ${schedules[0].doctorId}<br>
                                - Work Date: <fmt:formatDate value="${schedules[0].workDate}" pattern="dd/MM/yyyy" /><br>
                                - Slot ID: ${schedules[0].slotId}<br>

                                <c:if test="${schedules[0].doctor != null}">
                                    - Doctor Name: ${schedules[0].doctor.fullName}<br>
                                    - Doctor Specialty: ${schedules[0].doctor.specialty}<br>
                                </c:if>
                                <c:if test="${schedules[0].doctor == null}">
                                    - ❌ Doctor object is NULL<br>
                                </c:if>

                                <c:if test="${schedules[0].timeSlot != null}">
                                    - Start Time: ${schedules[0].timeSlot.startTime}<br>
                                    - End Time: ${schedules[0].timeSlot.endTime}<br>
                                </c:if>
                                <c:if test="${schedules[0].timeSlot == null}">
                                    - ❌ TimeSlot object is NULL<br>
                                </c:if>
                            </c:if>

                            <c:if test="${schedules == null or empty schedules}">
                                <strong>❌ Schedules list is empty or null</strong>
                            </c:if>
                        </div>

                        <!-- Danh sách lịch làm việc đơn giản -->
                        <div class="schedule-list">
                            <h5 class="mb-4">
                                <i class="fas fa-clock me-2"></i>
                                Danh Sách Lịch Làm Việc 
                                <span class="badge bg-secondary">${schedules != null ? schedules.size() : 0} lịch</span>
                            </h5>

                            <c:forEach var="schedule" items="${schedules}" varStatus="status">
                                <div class="simple-schedule">
                                    <strong>Lịch #${status.index + 1}:</strong><br>
                                    ID: ${schedule.scheduleId} | 
                                    Doctor ID: ${schedule.doctorId} | 
                                    Date: <fmt:formatDate value="${schedule.workDate}" pattern="dd/MM/yyyy" /> | 
                                    Slot: ${schedule.slotId}<br>

                                    <c:choose>
                                        <c:when test="${schedule.doctor != null}">
                                            👨‍⚕️ Bác sĩ: ${schedule.doctor.fullName} - ${schedule.doctor.specialty}
                                        </c:when>
                                        <c:otherwise>
                                            ❌ Doctor object is null
                                        </c:otherwise>
                                    </c:choose>
                                    <br>

                                    <c:choose>
                                        <c:when test="${schedule.timeSlot != null}">
                                            ⏰ Giờ: ${schedule.timeSlot.startTime} - ${schedule.timeSlot.endTime}
                                        </c:when>
                                        <c:otherwise>
                                            ❌ TimeSlot object is null
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>

                            <c:if test="${schedules == null or empty schedules}">
                                <div class="alert alert-warning">
                                    <h5>Không có lịch làm việc nào</h5>
                                    <p>Không tìm thấy lịch làm việc theo điều kiện đã chọn.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>