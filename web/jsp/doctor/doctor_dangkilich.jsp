<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Đăng ký lịch làm việc</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body>
            <div class="container mt-5">
                <h2>Đăng ký lịch làm việc</h2>
                <form action="${pageContext.request.contextPath}/DoctorScheduleServlet" method="POST" class="mt-4">
                    <div class="mb-3">
                        <label for="doctor_id" class="form-label">Mã bác sĩ</label>
                        <input type="number" class="form-control" id="doctor_id" name="doctor_id" required
                            value="${param.doctor_id != null ? param.doctor_id : ''}">
                    </div>
                    <div class="mb-3">
                        <label for="work_date" class="form-label">Ngày làm việc</label>
                        <input type="date" class="form-control" id="work_date" name="work_date" required>
                    </div>
                    <div class="mb-3">
                        <label for="slot_id" class="form-label">Ca làm việc</label>
                        <select class="form-select" id="slot_id" name="slot_id" required>
                            <c:forEach items="${shifts}" var="shift">
                                <option value="${shift.slotId}">${shift.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Đăng ký</button>
                </form>
                <h3 class="mt-5">Lịch đã đăng ký</h3>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Ngày</th>
                            <th>Ca</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${schedules}" var="schedule">
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
                                <td>${schedule.status}</td>
                            </tr>
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