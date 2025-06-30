<%-- Document : doctor_menu Created on : June 13, 2025, 07:51 PM Author : xAI --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap&subset=vietnamese"
              rel="stylesheet">

        <title>Doctor Menu</title>
        <style>
            *{
                margin : 0;
                padding : 0;
                box-sizing: border-box;
                font-family: 'Roboto', 'Segoe UI', Arial, 'Helvetica Neue', sans-serif;
            }

            body{
                width: 100vw;
                height: 100vh;
                background-color: #f8f9fb;
            }
            .menu-toggle {
                position: fixed;
                top: 25px;
                left:20px;
                font-size: 24px;
                z-index: 2;
                cursor: pointer;
                transition: transform 0.3s;
                transform: translateX(200px);
            }

            .menu{
                position: fixed;
                top: 0;
                left: 0px;
                width: 260px;
                height: 100%;
                background-color: white;
                padding: 20px;
                z-index: 1;
                display: flex;
                flex-direction: column;
                gap: 20px;
                transition: transform 0.3s;
                background-color: #ffff;
            }

            .menu_header{
                font-size: 18px;
                padding-bottom: 10px;
                margin-bottom: 10px;
                padding-right: 50px;
                padding-left: 15px;
            }

            .menu_header h2{
                color: #4E80EE;
            }

            .menu_item {
                display: flex;
                align-items: center;
                padding: 14px;
                border-radius: 8px;
                cursor: pointer;
                color: #333;
                background-color: white;  /* n?n tr?ng cho rõ hi?u ?ng */
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* bóng nh? m?c ??nh */
                transition: box-shadow 0.3s ease, transform 0.2s ease;
            }

            .menu_item:hover{
                background-color: #eee;
            }

            .menu_item:hover span {
                font-weight: bold;
                color: black; /* màu xanh n?i b?t */
                transform: translateY(-2px);
                transition: all 0.2s ease;
            }

            .menu_item i {
                text-align: center;
                width: 36px;             /* T?ng chi?u r?ng icon box */
                height: 36px;            /* Thêm chi?u cao */
                font-size: 18px;         /* C? icon */
                line-height: 36px;       /* Canh gi?a icon */
                background-color: white; /* N?n nh? cho icon */
                border-radius: 8px;      /* Bo nh? các góc */
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15); /* ?? bóng */
            }

            .menu_item:hover i {
                background-color: #4E80EE;
                color: white;
                transition: 0.2s;
            }

            .menu_item span{
                font-weight: 500;
                margin-left: 20px;
                transition: all 0.2s ease;
            }

            #menu-toggle:checked~.menu{
                transform: translateX(-250px);
            }
            #menu-toggle:checked~.menu-toggle{
                transform: translateX(-10px);
                color: #333;
            }

            .header-sidebar {
                display: flex;
                border-bottom: 2px solid #4E80EE;
                /* canh theo chi?u cao cho ??u nhau */
            }

            .menu_item.active {
                background-color: #d1e7ff; /* màu n?n khác */
                color: #0d6efd;            /* ??i màu ch? ho?c icon */
                font-weight: bold;
            }
            a{
                text-decoration: none;
                color: black;
            }
            .my-icon{
                padding-bottom: 100px;
            }
        </style>
    </head>

    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <label for="menu-toggle" class="menu-toggle">
            <i class="fa-solid fa-bars"></i>
        </label>

        <div class="menu">
            <div class="header-sidebar">
                <div class="logo-menu">
                    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" width="60" />
                </div>
                <div class="menu_header">           
                    <h2>HAPPY SMILE</h2>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_tongquan.jsp" class="menu_item">
                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_lichtrongthang.jsp" class="menu_item">
                <i class="fa-solid fa-calendar-days"></i>
                <span>Lịch trong tháng</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_trongngay.jsp" class="menu_item">
                <i class="fa-solid fa-calendar-day"></i>
                <span>Lịch trong ngày</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_trongtuan.jsp" class="menu_item">
                <i class="fa-solid fa-calendar-week"></i>
                <span>Lịch trong tuần</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_dangkilich.jsp" class="menu_item">
                <i class="fa-solid fa-calendar-plus"></i>
                <span>Đăng ký lịch</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_profile.jsp" class="menu_item">
                <i class="fa-solid fa-circle-user"></i>
                <span>Hồ sơ</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/doctor/doctor_caidat.jsp" class="menu_item">
                <i class="fa-solid fa-gear"></i>
                <span>Cài đặt</span>
            </a>
        </div>
    </body>
</html>
<script src="../js/script.js"></script>