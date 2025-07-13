<%-- 
    Document   : header
    Created on : Jun 28, 2025
    Author     : tranhongphuoc, lebao
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f0f7ff;
            --header-bg: #fff;
            --text-color: #333;
            --card-bg: #fff;
            --shadow-color: rgba(0,0,0,0.2);
            --secondary-bg: #fafcfc;
            --news-card-bg: #fff;
            --testimonial-bg: #f0f3f5;
            --footer-bg: linear-gradient(135deg, #3c5bba, #183ba1, #4664bd);
            --copyright-bg: #18376b;
            --btn-bg: #0432b5;
            --btn-hover-bg: #527aeb;
            --link-color: #3b82f6;
            --highlight-text: #3b82f6;
        }

        [data-theme="dark"] {
            --bg-color: #1a1a1a;
            --header-bg: #2c2c2c;
            --text-color: #e0e0e0;
            --card-bg: #333;
            --shadow-color: rgba(255,255,255,0.1);
            --secondary-bg: #2c2c2c;
            --news-card-bg: #333;
            --testimonial-bg: #444;
            --footer-bg: linear-gradient(135deg, #2a4066, #1c2526, #3a4a6b);
            --copyright-bg: #1c2526;
            --btn-bg: #2563eb;
            --btn-hover-bg: #3b82f6;
            --link-color: #60a5fa;
            --highlight-text: #60a5fa;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        .header {
            background: var(--header-bg);
            padding: 20px 25px;
            box-shadow: 0 2px 5px var(--shadow-color);
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: -20px;
        }

        .logo {
            display: flex;
            align-items: center;
            transition: transform 0.3s ease;
        }

        .logo img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            margin-right: 15px;
            background: transparent;
            border: none;
        }

        .logo h1 {
            font-size: 48px;
            font-weight: 700;
            color: var(--highlight-text);
            text-transform: uppercase;
            line-height: 1.2;
        }

        .logo span {
            color: var(--highlight-text);
            font-weight: 400;
            font-size: 34px;
            text-transform: none;
        }

        .auth-buttons {
            display: flex;
            padding-right: 50px;
            gap: 20px;
            margin-top: 0;
            align-items: center;
        }

        .auth-btn {
            padding: 10px 30px;
            text-decoration: none;
            font-size: 18px;
            font-weight: 500;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .auth-btn.register {
            background: var(--header-bg);
            color: var(--highlight-text);
        }

        .auth-btn.register:hover {
            background: var(--link-color);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 3px 8px var(--shadow-color);
        }

        .auth-btn.login {
            background: var(--header-bg);
            color: var(--highlight-text);
            border: 1px solid var(--link-color);
        }

        .auth-btn.login:hover {
            background: var(--link-color);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 3px 8px var(--shadow-color);
        }

        .theme-toggle {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: var(--highlight-text);
            transition: color 0.3s ease;
        }

        .theme-toggle:hover {
            color: var(--link-color);
        }

        .language-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .language-selector select {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid var(--link-color);
            background: var(--header-bg);
            color: var(--text-color);
            font-size: 16px;
            cursor: pointer;
        }

        .nav {
            display: flex;
            justify-content: end;
        }

        .nav ul {
            display: flex;
            list-style: none;
            gap: 35px;
            border-top: 1px solid rgba(0, 0, 0, 0.3);
            margin-bottom: -5px;
            margin-right: 20px;
        }

        .nav ul li {
            position: relative;
            margin-top: 10px;
        }

        .nav ul li a {
            text-decoration: none;
            color: #1e3a8a;
            font-weight: 700;
            font-size: 17px;
            padding: 10px 15px;
            transition: color 0.1s ease;
        }

        .nav ul li a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 1px;
            background-color: var(--link-color);
            bottom: 0;
            left: 15px;
            transition: width 0.3s ease;
        }

        .nav ul li a:hover::after, .nav ul li a.active::after {
            width: calc(100% - 30px);
        }

        .nav ul li a:hover, .nav ul li a.active {
            color: var(--link-color);
            font-weight: bold;
        }

        @media screen and (max-width: 768px) {
            .header {
                padding: 8px 10px;
            }

            .header-top {
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
            }

            .logo img {
                width: 50px;
                height: 50px;
                margin-right: 10px;
            }

            .logo h1 {
                font-size: 24px;
            }

            .logo span {
                font-size: 18px;
            }

            .auth-buttons {
                padding-right: 0;
                gap: 8px;
                flex-direction: row;
            }

            .auth-btn {
                padding: 6px 12px;
                font-size: 12px;
            }

            .theme-toggle {
                font-size: 14px;
            }

            .language-selector select {
                padding: 6px;
                font-size: 12px;
            }

            .nav {
                justify-content: center;
            }

            .nav ul {
                flex-direction: row;
                gap: 10px;
                margin-right: 0;
                border-top: none;
                flex-wrap: wrap;
                justify-content: center;
            }

            .nav ul li a {
                font-size: 12px;
                padding: 6px 8px;
            }

            .nav ul li a::after {
                left: 8px;
            }
        }

        @media screen and (min-width: 769px) and (max-width: 1024px) {
            .logo img {
                width: 80px;
                height: 80px;
            }

            .logo h1 {
                font-size: 40px;
            }

            .logo span {
                font-size: 28px;
            }

            .auth-buttons {
                gap: 15px;
                padding-right: 20px;
            }

            .auth-btn {
                padding: 8px 25px;
                font-size: 16px;
            }

            .theme-toggle {
                font-size: 16px;
            }

            .language-selector select {
                padding: 7px;
                font-size: 14px;
            }

            .nav ul {
                gap: 20px;
            }

            .nav ul li a {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-top">
            <div class="logo">
                <img src="img/logo.png" alt="HAPPY Smile Logo">
                <h1>HAPPY <span>Smile</span></h1>
            </div>
            <div class="auth-buttons">
                <a href="login.jsp" class="auth-btn login" data-lang="login">Đăng nhập</a>
                <a href="signup.jsp" class="auth-btn register" data-lang="register">Đăng ký</a>
                <button class="theme-toggle" id="theme-toggle">🌙</button>
                <div class="language-selector">
                    <select id="language-switcher">
                        <option value="vi">Tiếng Việt</option>
                        <option value="en">English</option>
                        <option value="ja">日本語</option>
                    </select>
                </div>
            </div>
        </div>
        <nav class="nav">
            <ul>
                <li><a href="#hero" class="active" data-lang="overview">Tổng quan</a></li>
                <li><a href="#services" data-lang="services">Dịch vụ</a></li>
                <li><a href="#team" data-lang="team">Đội ngũ bác sĩ</a></li>
                <li><a href="#news" data-lang="news">Tin tức</a></li>
                <li><a href="#contact" data-lang="contact">Liên hệ</a></li>
            </ul>
        </nav>
    </header>
</body>
</html>