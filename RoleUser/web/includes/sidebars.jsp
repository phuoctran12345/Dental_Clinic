<%-- 
    Document   : user_homepage
    Created on : May 16, 2025, 11:32:55 AM
    Author     : Home
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            



            *{
                margin : 0;
                padding : 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', sans-serif;
                
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
                background-color: #f8f9fb;


            }

            .menu_header{
                font-size: 13px;
                padding-bottom: 10px;
                margin-bottom: 20px;
                padding-right: 50px;
                padding-left: 15px;
            }

            .menu_header h2{
                color: #00BFFF;
            }

            .menu_item{
                display: flex;
                align-items: center;
                padding: 14px;
                border-radius: 8px;
                transition: all 0.1s;
                cursor: pointer;
                color: #333;
            }

            .menu_item:hover{
                background-color: #eee;
            }

            .menu_item:hover span {
                font-weight: bold;
                color: black; /* màu xanh nổi bật */
                transform: translateY(-2px);
                transition: all 0.2s ease;
            }




            .menu_item i {
                text-align: center;
                width: 36px;             /* Tăng chiều rộng icon box */
                height: 36px;            /* Thêm chiều cao */
                font-size: 18px;         /* Cỡ icon */
                line-height: 36px;       /* Canh giữa icon */
                background-color: white; /* Nền nhẹ cho icon */
                border-radius: 8px;      /* Bo nhẹ các góc */
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15); /* đổ bóng */

            }
          
            
            .menu_item:hover i {
                background-color: #00BFFF;
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
                border-bottom: 2px solid #00BFFF;
                /* canh theo chiều cao cho đều nhau */
            }

            .menu_item.active {
                background-color: #d1e7ff; /* màu nền khác */
                color: #0d6efd;            /* đổi màu chữ hoặc icon */
                font-weight: bold;
            }
            a{
                text-decoration: none;
                color: black;
            }.my-icon{
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
                    <img src="imgs/logo.png" alt="Logo" width="40" />
                </div>
                <div class="menu_header">           
                    <h2>HAPPY SMILE  </h2>
                </div>
            </div>
           
                <a href="user_homepage.jsp" class="menu_item">
                <i class="fa-solid fa-house "></i>
                <span>Home</span>
                </a>
           
          
                <a href="user_datlich.jsp" class="menu_item">
                <i class="fa-solid fa-calendar-days"></i>
                <span>Lịch Khám</span>
                </a>
         
            
                <a href="user_tuvan.jsp" class="menu_item">
                <i class="fa-solid fa-headset"></i>
                <span>Tư Vấn</span>
                </a>
          
         
                <a href="user_taikhoan.jsp" class="menu_item">
                <i class="fa-solid fa-circle-user"></i>
                <span>Tài Khoản</span>
                </a>
          

        </div>
    </body>
</html>
                <script src="js/script.js"></script>

