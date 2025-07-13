<%@page pageEncoding="UTF-8" %>
    <%@ include file="/jsp/doctor/doctor_header.jsp" %>
        <%@ include file="/jsp/doctor/doctor_menu.jsp" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Đăng ký lịch làm việc</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                </head>

                <body>
                    <div class="container mt-5">
                        <h2>Đăng ký lịch nghỉ</h2>
                        <form action="${pageContext.request.contextPath}/DoctorRegisterScheduleServlet" method="POST"
                            class="mt-4">
                            <div class="mb-3">
                                <label for="doctor_id" class="form-label">Mã bác sĩ</label>
                                <input type="number" class="form-control" id="doctor_id" name="doctor_id" required
                                    value="${param.doctor_id != null ? param.doctor_id : ''}">
                            </div>
                            <div class="mb-3">
                                <label for="work_date" class="form-label">Ngày nghỉ</label>
                                <input type="date" class="form-control" id="work_date" name="work_date" required>
                            </div>
                            <input type="hidden" id="request_type" name="request_type" value="leave">
                            <button type="submit" class="btn btn-primary">Đăng ký nghỉ</button>
                        </form>
                        <h3 class="mt-5">Lịch nghỉ đã đăng ký</h3>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Ngày nghỉ</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${schedules}" var="schedule">
                                    <c:if test="${schedule.slotId == null}">
                                        <tr>
                                            <td>${schedule.workDate}</td>
                                            <td>${schedule.status}</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Hiển thị lịch đã được approved riêng -->
                        <h3 class="mt-5">Lịch đã được xác nhận</h3>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Ngày</th>
                                    <th>Ca</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${approvedSchedules}" var="schedule">
                                    <tr>
                                        <td>${schedule.workDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${schedule.slotId == 1}">Sáng (8h-12h)</c:when>
                                                <c:when test="${schedule.slotId == 2}">Chiều (13h-17h)</c:when>
                                                <c:when test="${schedule.slotId == 3}">Cả ngày (8h-17h)</c:when>
                                                <c:otherwise>Khác</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>Đã xác nhận</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>