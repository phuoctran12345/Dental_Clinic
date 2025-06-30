<%-- Document : doctor_dangkilich Created on : [Insert Date], Author : [Your Name] --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký lịch làm việc</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        /* General body styling */
        body {

            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7fc;
            overflow-x: hidden;
        }

        /* Main container with padding to avoid menu overlap */
        .container {
            padding: 80px 20px 20px 290px; /* Space for fixed menu */
            min-height: 100vh;
            max-width: 1400px; /* Consistent with calendar page */
            margin: 0 auto;
            transition: padding 0.3s ease;
        }

        /* Header styling */
        h2 {
            color: #3b82f6; /* Vibrant blue */
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h3 {
            color: #3b82f6;
            font-size: 20px;
            font-weight: 600;
            margin: 32px 0 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Form container styling */
        .form-container {
            background: #ffffff;
            border-radius: 5px; /* Consistent border-radius */
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            margin-bottom: 32px;
            margin-top: 20px;
        }

        /* Form label styling */
        .form-label {
            color: #1f2937;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 12px;
            display: block;
        }

        /* Form input and select styling */
        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            padding: 12px;
            font-size: 16px;
            color: #1f2937;
            width: 100%;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
            outline: none;
        }

        /* Form group spacing */
        .mb-3 {
            margin-bottom: 24px;
        }

        /* Primary button styling */
        .btn-primary {
            background: #3b82f6;
            color: #ffffff;
            border: none;
            padding: 10px 24px;
            border-radius: 5px;
            font-weight: 600;
            transition: background 0.2s ease, box-shadow 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .btn-primary:hover {
            background: #2563eb;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        /* Table container styling */
        .table-container {
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        /* Table styling */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .table thead {
            background: #3b82f6;
            color: #ffffff;
        }

        .table th {
            padding: 12px 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
        }

        .table td {
            padding: 12px 16px;
            border-bottom: 1px solid #e2e8f0;
            color: #1f2937;
            font-size: 14px;
            vertical-align: middle;
        }

        .table tr:last-child td {
            border-bottom: none;
        }

        /* Striped table effect */
        .table-striped tbody tr:nth-child(odd) {
            background: #f9fafb;
        }

        /* Shift badge styling */
        .badge-shift {
            font-size: 12px;
            padding: 6px 12px;
            border-radius: 5px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-morning {
            background: #fefcbf;
            color: #b45309;
        }

        .badge-afternoon {
            background: #bfdbfe;
            color: #1e40af;
        }

        .badge-fullday {
            background: #d1fae5;
            color: #047857;
        }

        /* Approved status badge */
        .status-approved {
            background: #10b981;
            color: #ffffff;
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        /* Responsive adjustments */
        @media (max-width: 1200px) {
            .container {
                padding-left: 250px;
            }
        }

        @media (max-width: 992px) {
            .container {
                padding-left: 20px;
                padding-right: 20px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .form-container {
                padding: 16px;
            }
            .table th, .table td {
                padding: 8px;
                font-size: 12px;
            }
            h2 {
                font-size: 20px;
            }
            h3 {
                font-size: 18px;
            }
            .btn-primary {
                padding: 8px 16px;
                font-size: 14px;
            }
        }

        @media (max-width: 576px) {
            .form-container {
                padding: 12px;
            }
            .table th, .table td {
                font-size: 10px;
            }
            .btn-primary {
                padding: 8px 12px;
                font-size: 12px;
            }
            .form-control, .form-select {
                font-size: 14px;
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Page Header -->
        <h2><i class="fas fa-calendar-plus"></i>Đăng ký lịch làm việc</h2>

        <!-- Form Section -->
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/DoctorScheduleServlet" method="POST">
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
                <button type="submit" class="btn btn-primary"><i class="fas fa-check"></i>Đăng ký</button>
            </form>
        </div>

        <!-- Registered Schedules Section -->
        <h3><i class="fas fa-calendar-check"></i>Lịch đã đăng ký</h3>
        <div class="table-container">
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
                                    <c:when test="${schedule.slotId == 1}">
                                        <span class="badge badge-morning badge-shift">
                                            <i class="fas fa-sun"></i> Sáng (8h-12h)
                                        </span>
                                    </c:when>
                                    <c:when test="${schedule.slotId == 2}">
                                        <span class="badge badge-afternoon badge-shift">
                                            <i class="fas fa-cloud-sun"></i> Chiều (13h-17h)
                                        </span>
                                    </c:when>
                                    <c:when test="${schedule.slotId == 3}">
                                        <span class="badge badge-fullday badge-shift">
                                            <i class="fas fa-clock"></i> Cả ngày (8h-17h)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Khác</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${schedule.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Approved Schedules Section -->
        <h3><i class="fas fa-check-circle"></i>Lịch đã được xác nhận</h3>
        <div class="table-container">
            <table class="table table-striped">
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
                                    <c:when test="${schedule.slotId == 1}">
                                        <span class="badge badge-morning badge-shift">
                                            <i class="fas fa-sun"></i> Sáng (8h-12h)
                                        </span>
                                    </c:when>
                                    <c:when test="${schedule.slotId == 2}">
                                        <span class="badge badge-afternoon badge-shift">
                                            <i class="fas fa-cloud-sun"></i> Chiều (13h-17h)
                                        </span>
                                    </c:when>
                                    <c:when test="${schedule.slotId == 3}">
                                        <span class="badge badge-fullday badge-shift">
                                            <i class="fas fa-clock"></i> Cả ngày (8h-17h)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Khác</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="status-approved">
                                    <i class="fas fa-check"></i> Đã xác nhận
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>