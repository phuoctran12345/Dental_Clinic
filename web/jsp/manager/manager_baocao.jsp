<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo hệ thống</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }

        .container {
            margin-left: 250px;
            padding: 20px;
        }

        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .header h1 {
            color: #333;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
        }

        .filters {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-row {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }

        .filter-group select, .filter-group input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            background-color: #007bff;
            color: white;
            margin-top: 20px;
        }

        .btn:hover {
            opacity: 0.8;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #007bff, #28a745);
        }

        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
            color: #007bff;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .stat-change {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 12px;
            display: inline-block;
        }

        .stat-change.positive {
            background-color: #d4edda;
            color: #155724;
        }

        .stat-change.negative {
            background-color: #f8d7da;
            color: #721c24;
        }

        .charts-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .chart-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            text-align: center;
        }

        .reports-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .report-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .report-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .report-list {
            list-style: none;
        }

        .report-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .report-item:last-child {
            border-bottom: none;
        }

        .report-item-label {
            color: #333;
        }

        .report-item-value {
            font-weight: 600;
            color: #007bff;
        }

        .export-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-top: 20px;
        }

        .export-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .export-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .export-btn.pdf {
            background-color: #dc3545;
            color: white;
        }

        .export-btn.excel {
            background-color: #28a745;
            color: white;
        }

        .export-btn.csv {
            background-color: #17a2b8;
            color: white;
        }

        .export-btn:hover {
            opacity: 0.8;
        }

        @media (max-width: 768px) {
            .charts-container, .reports-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="manager_menu.jsp" />
    
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-chart-bar"></i> Báo cáo hệ thống</h1>
            <p>Báo cáo tổng hợp về hoạt động của hệ thống nha khoa</p>
        </div>

        <div class="filters">
            <div class="filter-row">
                <div class="filter-group">
                    <label>Thời gian:</label>
                    <select id="timeRange" onchange="updateReport()">
                        <option value="today">Hôm nay</option>
                        <option value="week">Tuần này</option>
                        <option value="month" selected>Tháng này</option>
                        <option value="quarter">Quý này</option>
                        <option value="year">Năm nay</option>
                        <option value="custom">Tùy chỉnh</option>
                    </select>
                </div>
                <div class="filter-group" id="customDateRange" style="display: none;">
                    <label>Từ ngày:</label>
                    <input type="date" id="startDate" onchange="updateReport()">
                </div>
                <div class="filter-group" id="customDateRange2" style="display: none;">
                    <label>Đến ngày:</label>
                    <input type="date" id="endDate" onchange="updateReport()">
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-number">${totalPatients}</div>
                <div class="stat-label">Tổng số bệnh nhân</div>
                <div class="stat-change positive">+${newPatientsThisMonth} tháng này</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-number">${totalAppointments}</div>
                <div class="stat-label">Lịch hẹn</div>
                <div class="stat-change positive">+${completedAppointments} hoàn thành</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-number">${totalRevenue}</div>
                <div class="stat-label">Doanh thu (VNĐ)</div>
                <div class="stat-change positive">+${revenueGrowth}% so tháng trước</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="stat-number">${totalDoctors}</div>
                <div class="stat-label">Bác sĩ hoạt động</div>
                <div class="stat-change positive">${activeDoctors} đang làm việc</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-pills"></i>
                </div>
                <div class="stat-number">${totalMedicines}</div>
                <div class="stat-label">Loại thuốc</div>
                <div class="stat-change positive">${lowStockMedicines} cần nhập</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <div class="stat-number">${totalServices}</div>
                <div class="stat-label">Dịch vụ</div>
                <div class="stat-change positive">${activeServices} đang hoạt động</div>
            </div>
        </div>

        <div class="charts-container">
            <div class="chart-card">
                <div class="chart-title">Lịch hẹn theo tháng</div>
                <canvas id="appointmentsChart" width="400" height="200"></canvas>
            </div>

            <div class="chart-card">
                <div class="chart-title">Doanh thu theo dịch vụ</div>
                <canvas id="revenueChart" width="400" height="200"></canvas>
            </div>
        </div>

        <div class="reports-container">
            <div class="report-card">
                <div class="report-title">
                    <i class="fas fa-chart-line"></i>
                    Thống kê lịch hẹn
                </div>
                <ul class="report-list">
                    <li class="report-item">
                        <span class="report-item-label">Tổng lịch hẹn</span>
                        <span class="report-item-value">${totalAppointments}</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Đã hoàn thành</span>
                        <span class="report-item-value">${completedAppointments}</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Đã hủy</span>
                        <span class="report-item-value">${cancelledAppointments}</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Chờ thanh toán</span>
                        <span class="report-item-value">${pendingPayments}</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Tỷ lệ hoàn thành</span>
                        <span class="report-item-value">${completionRate}%</span>
                    </li>
                </ul>
            </div>

            <div class="report-card">
                <div class="report-title">
                    <i class="fas fa-money-bill-wave"></i>
                    Thống kê tài chính
                </div>
                <ul class="report-list">
                    <li class="report-item">
                        <span class="report-item-label">Tổng doanh thu</span>
                        <span class="report-item-value">${totalRevenue} VNĐ</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Doanh thu trung bình/ngày</span>
                        <span class="report-item-value">${avgDailyRevenue} VNĐ</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Dịch vụ bán chạy nhất</span>
                        <span class="report-item-value">${topService}</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Số hóa đơn</span>
                        <span class="report-item-value">${totalBills}</span>
                    </li>
                    <li class="report-item">
                        <span class="report-item-label">Tỷ lệ thanh toán</span>
                        <span class="report-item-value">${paymentRate}%</span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="export-section">
            <h3><i class="fas fa-download"></i> Xuất báo cáo</h3>
            <div class="export-buttons">
                <button class="export-btn pdf" onclick="exportReport('pdf')">
                    <i class="fas fa-file-pdf"></i>
                    Xuất PDF
                </button>
                <button class="export-btn excel" onclick="exportReport('excel')">
                    <i class="fas fa-file-excel"></i>
                    Xuất Excel
                </button>
                <button class="export-btn csv" onclick="exportReport('csv')">
                    <i class="fas fa-file-csv"></i>
                    Xuất CSV
                </button>
            </div>
        </div>
    </div>

    <script>
        // Khởi tạo biểu đồ
        function initCharts() {
            // Biểu đồ lịch hẹn
            var appointmentsCtx = document.getElementById('appointmentsChart').getContext('2d');
            var appointmentsChart = new Chart(appointmentsCtx, {
                type: 'line',
                data: {
                    labels: ${appointmentLabels},
                    datasets: [{
                        label: 'Lịch hẹn',
                        data: ${appointmentData},
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Biểu đồ doanh thu
            var revenueCtx = document.getElementById('revenueChart').getContext('2d');
            var revenueChart = new Chart(revenueCtx, {
                type: 'doughnut',
                data: {
                    labels: ${serviceLabels},
                    datasets: [{
                        data: ${serviceRevenueData},
                        backgroundColor: [
                            '#FF6384',
                            '#36A2EB',
                            '#FFCE56',
                            '#4BC0C0',
                            '#9966FF',
                            '#FF9F40'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function updateReport() {
            var timeRange = document.getElementById('timeRange').value;
            var customDateRange = document.getElementById('customDateRange');
            var customDateRange2 = document.getElementById('customDateRange2');

            if (timeRange === 'custom') {
                customDateRange.style.display = 'block';
                customDateRange2.style.display = 'block';
            } else {
                customDateRange.style.display = 'none';
                customDateRange2.style.display = 'none';
            }

            // Gửi request AJAX để cập nhật dữ liệu
            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'ManagerReportServlet?timeRange=' + timeRange, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // Cập nhật trang với dữ liệu mới
                    location.reload();
                }
            };
            xhr.send();
        }

        function exportReport(format) {
            var timeRange = document.getElementById('timeRange').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;

            var url = 'ExportReportServlet?format=' + format + '&timeRange=' + timeRange;
            if (startDate) url += '&startDate=' + startDate;
            if (endDate) url += '&endDate=' + endDate;

            window.open(url, '_blank');
        }

        // Khởi tạo trang
        document.addEventListener('DOMContentLoaded', function() {
            initCharts();
            
            // Set ngày hiện tại cho filter
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').value = today;
            document.getElementById('endDate').value = today;
        });
    </script>
</body>
</html> 