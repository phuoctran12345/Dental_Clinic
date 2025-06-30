<%-- 
    Document   : doctor_bihuy
    Created on : May 24, 2025, 4:03:11 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>

<!DOCTYPE html>
<html lang="vi">
   <head>
    <meta charset="UTF-8">
    <title>Kết quả khám</title>
    <style>
        body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;
            }
            .container {
                font-family: Arial, sans-serif;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 10px;
                min-height: 100vh;
            }
            #menu-toggle:checked ~.container {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }

       

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        h2 {
            color: #1e293b;
        }

        .search-input {
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            width: 240px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
            gap: 16px;
        }

        .card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            padding: 16px;
        }

        .time {
            font-weight: bold;
            color: #0f172a;
            margin-bottom: 12px;
        }

        .card-body {
            display: flex;
            gap: 16px;
        }

        .avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            object-fit: cover;
        }

        .info {
            flex: 1;
            font-size: 14px;
            color: #334155;
        }

        .info .desc {
            margin-top: 8px;
            color: #64748b;
        }

        .actions {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: flex-end;
        }

        .status {
            background-color: #10b981; /* màu xanh lá cho "hoàn thành" */
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: bold;
        }

        .result-btn {
            background-color: #3b82f6;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 13px;
            cursor: pointer;
        }

        .result-btn:hover {
            background-color: #2563eb;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h2>Kết quả khám bệnh</h2>
        <input type="text" placeholder="Tìm theo tên, ngày khám..." class="search-input"/>
    </div>

    <div class="cards">
       
            <div class="card">
                <div class="time">09:30 - 10:30 | 20/2/2024</div>
                <div class="card-body">
                    <img src="" alt="avatar" class="avatar"/>
                    <div class="info">
                        <strong>Nguyễn Văn B</strong><br />
                        <span>Số điện thoại:</span> 0912345678<br />
                        <span>Giới tính:</span> Nam &nbsp; <span>Tuổi:</span> 35<br />
                        <p class="desc">Mô tả: Kết quả khám tổng quát bao gồm xét nghiệm máu, siêu âm tổng quát, khám nội và ngoại khoa. Không phát hiện bất thường.</p>
                    </div>
                    <div class="actions">
                        <span class="status">Hoàn thành</span>
                        <form action="viewResult.jsp" method="get">
                            <button type="submit" class="result-btn">Xem kết quả</button>
                        </form>
                    </div>
                </div>
            </div>
      
    </div>
</div>
</body>
</html>

