<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HAPPY Smile - Phòng khám nha khoa tư nhân chuyên nghiệp</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background: #f0f7ff;
                padding-top: 120px;
            }

            .header {
                background: #fff;
                padding: 10px 25px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
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
                width: 90px;
                height: 90px;
                object-fit: contain;
                margin-right: 15px;
                background: transparent;
                border: none;
            }

            .logo h1 {
                font-size: 48px;
                font-weight: 700;
                color: #3b82f6;
                text-transform: uppercase;
                line-height: 1.2;
            }

            .logo span {
                color: #3b82f6;
                font-weight: 400;
                font-size: 34px;
                text-transform: none;
            }

            .auth-buttons {
                display: flex;
                padding-right: 50px;
                gap: 20px;
                margin-top: 0;
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
                background: #fff;
                color: #3b82f6;
            }

            .auth-btn.register:hover {
                background: #3b82f6;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 3px 8px rgba(0,0,0,0.2);
            }

            .auth-btn.login:hover {
                background: #3b82f6;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 3px 8px rgba(0,0,0,0.2);
            }

            .auth-btn.login {
                background: #fff;
                color: #3b82f6;
                border: 1px solid #3b82f6;
            }

            .auth-btn.login:hover {
                background: #3b82f6;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 3px 8px rgba(0,0,0,0.2);
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
                background-color: #3b82f6;
                bottom: 0;
                left: 15px;
                transition: width 0.3s ease;
            }

            .nav ul li a:hover::after, .nav ul li a.active::after {
                width: calc(100% - 30px);
            }

            .nav ul li a:hover, .nav ul li a.active {
                color: #3b82f6;
                font-weight: bold;
            }

            .hero {
                background: linear-gradient(rgba(0,0,0,0.1), rgba(0,0,0,0.3)), url('img/banner2.jpg') no-repeat center center fixed;
                color: #112ff2;
                padding: 100px 0;
                text-align: center;
                position: relative;
                overflow: hidden;
                object-fit: cover;
            }

            .hero-content {
                position: relative;
                max-width: 850px;
                margin: 0 auto;
            }

            .hero h2 {
                font-size: 37px;
                margin-bottom: 10px;
            }

            .hero h3 {
                font-size: 43px;
                margin-bottom: 20px;
            }

            .btn {
                display: inline-block;
                padding: 15px 30px;
                background-color: #0432b5;
                color: white;
                text-decoration: none;
                border-radius: 20px;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .btn:hover {
                background-color: #527aeb;
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .services {
                padding: 50px;
                text-align: center;
            }

            .services h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, #3b82f6);
                -webkit-background-clip: text;
                background-clip: text;
                color: #3b82f6;
            }

            .service-container {
                max-width: 1200px;
                margin: 0 auto;
            }

            .service-row {
                display: flex;
                justify-content: center;
                gap: 40px;
                margin-bottom: 40px;
            }

            .service-item {
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                flex: 1;
                max-width: 220px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
            }


            .service-icon {
                width: 100px;
                height: 100px;
                margin: 0 auto 15px;
            }

            .service-item p {
                color: #666;
                font-size: 20px;
            }

            .about {
                padding: 50px;
                background-color: #fafcfc;
                text-align: center;
            }

            .about h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, #3b82f6);
                -webkit-background-clip: text;
                background-clip: text;
                color: #3b82f6;
            }

            .about-content {
                display: flex;
                align-items: center;
                justify-content: center;
                max-width: 1300px;
                margin: 0 auto;
                gap: 50px;
            }

            .about-text {
                flex: 1;
                text-align: left;
            }

            .about-text p {
                color: black;
                line-height: 1.5;
                margin-bottom: 20px;
                font-size: 18px;
            }

            .about-image {
                flex: 1;
                text-align: center;
            }

            .about-image img {
                max-width: 100%;
                border-radius: 10px;
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
                border: 3px solid #1e3a8a;
            }

            .team {
                background: #fafcfc;
                padding: 50px;
                text-align: center;
            }

            .team h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, #3b82f6);
                -webkit-background-clip: text;
                background-clip: text;
                color: #3b82f6;
            }

            .team-slider {
                display: flex;
                flex-wrap: wrap;
                gap: 30px;
                justify-content: center;
                padding: 20px 0;
            }

            .doctor-card {
                background-color: white;
                border-radius: 10px;
                overflow: hidden;
                width: 100%;
                max-width: 280px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: transform 0.3s ease;
            }

            .doctor-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            }

            .doctor-image {
                height: 280px;
                background-color: #f5f5f5;
                overflow: hidden;
            }

            .doctor-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 8px 8px 0 0;
            }

            .doctor-info {
                padding: 20px;
            }

            .doctor-info h4 {
                color: #1e3a8a;
                margin-bottom: 8px;
                font-size: 20px;
            }

            .doctor-info p {
                color: #666;
                font-size: 16px;
            }

            .testimonials {
                background: #fafcfc;
                padding: 50px;
                text-align: center;
            }

            .testimonials h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, #3b82f6);
                -webkit-background-clip: text;
                background-clip: text;
                color: #3b82f6;
            }

            .testimonial-slider {
                display: flex;
                gap: 40px;
                overflow-x: auto;
                padding: 20px 0;
                scroll-behavior: smooth;
                justify-content: center;
            }

            .testimonial-card {
                background-color: #f0f3f5;
                padding: 30px;
                border-radius: 10px;
                min-width: 300px;
                text-align: left;
                position: relative;
            }

            .testimonial-card::before {
                content: '"';
                font-size: 80px;
                position: absolute;
                top: 10px;
                left: 20px;
                color: rgba(30, 58, 138, 0.1);
                font-family: serif;
            }

            .testimonial-text {
                color: #666;
                line-height: 1.6;
                margin-bottom: 20px;
                position: relative;
                z-index: 1;
            }

            .testimonial-author {
                display: flex;
                align-items: center;
            }

            .author-info h4 {
                color: black;
                margin-bottom: 5px;
            }

            .author-info p {
                color: #666;
                font-size: 14px;
            }

            .news {
                padding: 50px;
                text-align: center;
            }

            .news h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, #3b82f6);
                -webkit-background-clip: text;
                background-clip: text;
                color: #3b82f6;
            }

            .news-grid {
                display: flex;
                gap: 50px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .news-card {
                background-color: white;
                border-radius: 10px;
                overflow: hidden;
                width: 350px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: transform 0.3s ease;
            }

            .news-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            }

            .news-image {
                height: 220px;
                background-color: #f5f5f5;
            }

            .news-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .news-content {
                padding: 25px;
            }

            .news-date {
                color: #999;
                font-size: 14px;
                margin-bottom: 12px;
            }

            .news-title {
                color: #333;
                font-size: 20px;
                margin-bottom: 12px;
                line-height: 1.4;
            }

            .news-excerpt {
                color: #666;
                font-size: 16px;
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .news-link {
                color: #3b82f6;
                text-decoration: none;
                font-size: 15px;
                font-weight: 500;
            }

            .news-link:hover {
                text-decoration: underline;
            }

            .contact {
                padding: 50px;
                background-color: #fafcfc;
                text-align: center;
            }

            .contact h2 {
                font-size: 40px;
                color: #3b82f6;
                margin-bottom: 40px;
                font-weight: bold;
            }

            .contact p {
                font-size: 20px;
                color: #666;
                margin-bottom: 40px;
            }

            .contact-container {
                display: flex;
                max-width: 1200px;
                margin: 0 auto;
                gap: 40px;
                align-items: stretch;
            }

            .map {
                flex: 1;
                border: 2px solid #ddd;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .map iframe {
                width: 100%;
                height: 500px;
                border: 0;
            }

            .contact-info {
                flex: 1;
                padding: 30px;
                background: #ffffff;
                border: 1px solid #e0e0e0;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
                gap: 20px;
                text-align: center;
                font-size: 16px;
                justify-content: center;
                color: #333;
            }

            .contact-info h3 {
                font-size: 32px;
                color: #256ee6;
                font-weight: 700;
                letter-spacing: 0.5px;
                margin-bottom: 15px;
            }

            .contact-info .highlight-hours {
                background-color: #f8f9fa;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 500;
                color: #333;
                font-size: 18px;
                text-align: center;
                line-height: 1.6;
            }

            .contact-info .open-text {
                color: #28a745;
                font-weight: bold;
            }

            .contact-info .closed-text {
                color: #dc3545;
                font-weight: bold;
            }

            .contact-info hr {
                border: 0;
                border-top: 1px solid #e0e0e0;
                margin: 10px 0;
            }

            .contact-btn {
                display: inline-block;
                padding: 14px 40px;
                background: linear-gradient(135deg, #256ee6, #3b82f6);
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
            }

            .contact-btn:hover {
                background: linear-gradient(135deg, #1453ba, #2563eb);
                transform: translateY(-2px) scale(1.02);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            .contact-form {
                margin-top: 40px;
                border: 2px solid #ddd;
                border-radius: 10px;
                padding: 20px;
                background-color: #fff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                max-width: 1200px;
                margin-left: auto;
                margin-right: auto;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                color: #666;
                text-align: left;
            }

            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }

            .submit-btn {
                background: linear-gradient(135deg, #1453ba, #3b82f6);
                color: white;
                border: none;
                font-size: 17px;
                padding: 13px 35px;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .submit-btn:hover {
                background: linear-gradient(135deg, #1e3a8a, #2563eb);
            }

            .footer {
                background: linear-gradient(135deg, #3c5bba, #183ba1, #4664bd);
                padding: 30px;
                text-align: justify;
            }

            .footer-container {
                max-width: 1200px;
                margin: 0 50px;
                display: flex;
                flex-wrap: wrap;
                gap: 50px;
            }

            .footer-col {
                flex: 1;
                min-width: 250px;
            }

            .footer-col h4 {
                font-size: 27px;
                margin-bottom: 12px;
                color: white;
            }

            .footer-col p {
                color: white;
                line-height: 1.6;
                margin-bottom: 10px;
                font-size: 14px;
            }

            .footer-links {
                list-style: none;
            }

            .footer-links li {
                margin-bottom: 10px;
            }

            .footer-links li a {
                color: whitesmoke;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .copyright {
                text-align: center;
                padding: 20px 0;
                color: white;
                background-color: #18376b;
                font-size: 14px;
            }

            @media screen and (max-width: 768px) {
                body {
                    padding-top: 80px;
                }

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

                .hero {
                    padding: 40px 10px;
                }

                .hero-content {
                    max-width: 100%;
                }

                .hero h2 {
                    font-size: 20px;
                    margin-bottom: 8px;
                }

                .hero h3 {
                    font-size: 24px;
                    margin-bottom: 15px;
                }

                .btn {
                    padding: 8px 15px;
                    font-size: 12px;
                }

                .about {
                    padding: 20px 10px;
                }

                .about h3 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .about-content {
                    flex-direction: column;
                    gap: 15px;
                }

                .about-text p {
                    font-size: 12px;
                    margin-bottom: 10px;
                }

                .about-image img {
                    max-width: 80%;
                }

                .services {
                    padding: 20px 10px;
                }

                .services h3 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .service-row {
                    flex-direction: row;
                    gap: 10px;
                    flex-wrap: wrap;
                    justify-content: center;
                }

                .service-item {
                    max-width: 45%;
                    padding: 10px;
                }

                .service-icon {
                    width: 50px;
                    height: 50px;
                    margin-bottom: 10px;
                }

                .service-item p {
                    font-size: 12px;
                }

                .team {
                    padding: 20px 10px;
                }

                .team h3 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .team-slider {
                    flex-direction: row;
                    flex-wrap: wrap;
                    gap: 10px;
                }

                .doctor-card {
                    max-width: 45%;
                }

                .doctor-image {
                    height: 150px;
                }

                .doctor-info {
                    padding: 10px;
                }

                .doctor-info h4 {
                    font-size: 14px;
                    margin-bottom: 5px;
                }

                .doctor-info p {
                    font-size: 12px;
                }

                .testimonials {
                    padding: 20px 10px;
                }

                .testimonials h3 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .testimonial-slider {
                    flex-direction: column;
                    gap: 15px;
                }

                .testimonial-card {
                    min-width: 100%;
                    padding: 15px;
                }

                .testimonial-card::before {
                    font-size: 40px;
                    top: 5px;
                    left: 10px;
                }

                .testimonial-text {
                    font-size: 12px;
                    margin-bottom: 10px;
                }

                .author-info h4 {
                    font-size: 12px;
                }

                .author-info p {
                    font-size: 10px;
                }

                .news {
                    padding: 20px 10px;
                }

                .news h3 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .news-grid {
                    flex-direction: column;
                    gap: 15px;
                }

                .news-card {
                    width: 100%;
                }

                .news-image {
                    height: 120px;
                }

                .news-content {
                    padding: 15px;
                }

                .news-date {
                    font-size: 10px;
                    margin-bottom: 8px;
                }

                .news-title {
                    font-size: 14px;
                    margin-bottom: 8px;
                }

                .news-excerpt {
                    font-size: 12px;
                    margin-bottom: 10px;
                }

                .news-link {
                    font-size: 12px;
                }

                .contact {
                    padding: 20px 10px;
                }

                .contact h2 {
                    font-size: 24px;
                    margin-bottom: 20px;
                }

                .contact p {
                    font-size: 12px;
                    margin-bottom: 20px;
                }

                .contact-container {
                    flex-direction: column;
                    gap: 15px;
                }

                .map iframe {
                    height: 200px;
                }

                .contact-info {
                    padding: 15px;
                }

                .contact-info h3 {
                    font-size: 18px;
                    margin-bottom: 10px;
                }

                .contact-info .highlight-hours {
                    font-size: 12px;
                    padding: 8px 10px;
                }

                .contact-btn {
                    padding: 8px 20px;
                    font-size: 12px;
                }

                .contact-form {
                    padding: 10px;
                    margin-top: 20px;
                }

                .form-group {
                    margin-bottom: 10px;
                }

                .form-group label {
                    font-size: 12px;
                }

                .form-control {
                    font-size: 10px;
                    padding: 6px;
                }

                .submit-btn {
                    padding: 8px 20px;
                    font-size: 12px;
                }

                .footer {
                    padding: 20px 10px;
                }

                .footer-container {
                    margin: 0 10px;
                    gap: 15px;
                }

                .footer-col {
                    min-width: 100%;
                }

                .footer-col h4 {
                    font-size: 18px;
                    margin-bottom: 8px;
                }

                .footer-col p {
                    font-size: 10px;
                }

                .footer-links li a {
                    font-size: 10px;
                }

                .copyright {
                    font-size: 10px;
                    padding: 10px 0;
                }
            }

            @media screen and (min-width: 769px) and (max-width: 1024px) {
                body {
                    padding-top: 150px;
                }

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

                .nav ul {
                    gap: 20px;
                }

                .nav ul li a {
                    font-size: 16px;
                }

                .hero {
                    padding: 80px 20px;
                }

                .hero h2 {
                    font-size: 32px;
                }

                .hero h3 {
                    font-size: 38px;
                }

                .services {
                    padding: 40px 20px;
                }

                .service-row {
                    gap: 20px;
                    flex-wrap: wrap;
                }

                .service-item {
                    max-width: 45%;
                    flex: none;
                }

                .about {
                    padding: 40px 20px;
                }

                .about-content {
                    gap: 30px;
                }

                .team {
                    padding: 40px 20px;
                }

                .team-slider {
                    gap: 20px;
                }

                .doctor-card {
                    max-width: 45%;
                }

                .testimonials {
                    padding: 40px 20px;
                }

                .testimonial-slider {
                    gap: 20px;
                }

                .news {
                    padding: 40px 20px;
                }

                .news-grid {
                    gap: 20px;
                }

                .news-card {
                    width: 45%;
                }

                .contact {
                    padding: 40px 20px;
                }

                .contact-container {
                    gap: 20px;
                }

                .map iframe {
                    height: 400px;
                }

                .footer-container {
                    margin: 0 20px;
                    gap: 30px;
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
                    <a href="#" class="auth-btn login">Đăng nhập</a>
                    <a href="#" class="auth-btn register">Đăng ký</a>
                </div>
            </div>
            <nav class="nav">
                <ul>
                    <li><a href="#hero" class="active">Tổng quan</a></li>
                    <li><a href="#services">Dịch vụ</a></li>
                    <li><a href="#team">Đội ngũ bác sĩ</a></li>
                    <li><a href="#news">Tin tức</a></li>
                    <li><a href="#contact">Liên hệ</a></li>
                </ul>
            </nav>
        </header>

        <section class="hero" id="hero">
            <div class="hero-content">
                <h2>Phòng khám nha khoa</h2>
                <h3>HAPPY SMILE</h3>
                <a href="#" class="btn">Đặt lịch khám ngay</a>
            </div>
        </section>

        <section class="about" id="about">
            <h3>CHÚNG TÔI LÀ AI?</h3>
            <div class="about-content">
                <div class="about-text">
                    <p>HAPPY Smile là phòng khám nha khoa tư nhân chuyên nghiệp tại Việt Nam, với sứ mệnh mang đến dịch vụ chăm sóc răng miệng chất lượng cao và nụ cười khỏe mạnh cho mọi khách hàng.</p>
                    <p>Với đội ngũ bác sĩ giàu kinh nghiệm, được đào tạo bài bản trong và ngoài nước, cùng trang thiết bị hiện đại, chúng tôi cam kết mang đến những phương pháp điều trị tiên tiến và hiệu quả nhất.</p>
                    <p>Tại HAPPY Smile, chúng tôi không chỉ chữa trị các vấn đề răng miệng mà còn hướng đến việc phòng ngừa, tư vấn và chăm sóc sức khỏe răng miệng lâu dài cho khách hàng.</p>
                    <p>Hãy đến với chúng tôi để trải nghiệm dịch vụ nha khoa chất lượng trong một không gian thoải mái, thân thiện và chuyên nghiệp.</p>
                </div>
                <div class="about-image">
                    <img src="img/bacsii.png" alt="Phòng khám HAPPY Smile">
                </div>
            </div>
        </section>

        <section class="services" id="services">
            <h3>DỊCH VỤ NHA KHOA</h3>
            <div class="service-container">
                <div class="service-row">
                    <div class="service-item">
                        <img src="img/icon1.jpg" alt="Khám tổng quát" class="service-icon">
                        <p>Khám tổng quát</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon2.jpg" alt="Trám răng" class="service-icon">
                        <p>Trám răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon3.jpg" alt="Tẩy trắng răng" class="service-icon">
                        <p>Tẩy trắng răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon4.jpg" alt="Bọc răng sứ" class="service-icon">
                        <p>Bọc răng sứ</p>
                    </div>
                </div>
                <div class="service-row">
                    <div class="service-item">
                        <img src="img/icon5.jpg" alt="Niềng răng" class="service-icon">
                        <p>Niềng răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon6.jpg" alt="Nhổ răng" class="service-icon">
                        <p>Nhổ răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon7.jpg" alt="Cấy ghép implant" class="service-icon">
                        <p>Cấy ghép implant</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon8.jpg" alt="Điều trị nha chu" class="service-icon">
                        <p>Điều trị nha chu</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="team" id="team">
            <h3>ĐỘI NGŨ BÁC SĨ</h3>
            <div class="team-slider">
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi1.png" alt="Bác sĩ Nguyễn Văn A">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Nguyễn Văn A</h4>
                        <p>Chuyên gia Implant</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi2.png" alt="Bác sĩ Trần Thị B">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Trần Thị B</h4>
                        <p>Chuyên gia Chỉnh nha</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi3.png" alt="Bác sĩ Lê Văn C">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Lê Văn C</h4>
                        <p>Chuyên gia Phục hình</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi4.png" alt="Bác sĩ Phạm Thị D">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Phạm Thị D</h4>
                        <p>Chuyên gia Nha chu</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="testimonials">
            <h3>CẢM NHẬN TỪ KHÁCH HÀNG</h3>
            <div class="testimonial-slider">
                <div class="testimonial-card">
                    <p class="testimonial-text">Tôi đã điều trị niềng răng tại HAPPY Smile và rất hài lòng với kết quả. Các bác sĩ rất tận tâm, tư vấn chi tiết và quá trình điều trị rất chuyên nghiệp. Giờ đây tôi có thể tự tin cười mà không cần phải che miệng nữa.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Nguyễn Thị Minh</h4>
                            <p>Khách hàng niềng răng</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <p class="testimonial-text">Dịch vụ bọc răng sứ tại HAPPY Smile thực sự xuất sắc. Bác sĩ tư vấn rất tỉ mỉ, lựa chọn loại răng sứ phù hợp với gương mặt tôi. Kết quả vượt ngoài mong đợi, trông rất tự nhiên và đẹp. Tôi sẽ giới thiệu bạn bè đến đây.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Trần Văn Hoàng</h4>
                            <p>Khách hàng bọc răng sứ</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <p class="testimonial-text">Mình thường xuyên đến HAPPY Smile để khám và vệ sinh răng định kỳ. Môi trường phòng khám sạch sẽ, hiện đại và thân thiện. Các bác sĩ và nhân viên rất chuyên nghiệp và chu đáo. Chất lượng dịch vụ xứng đáng với giá tiền.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Võ Hoàng Gia Linh</h4>
                            <p>Khách hàng thường xuyên</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="news" id="news">
            <h3>TIN TỨC NHA KHOA</h3>
            <div class="news-grid">
                <div class="news-card">
                    <div class="news-image">
                        <img src="img/placeholder-news.png" alt="Cách chăm sóc răng miệng">
                    </div>
                    <div class="news-content">
                        <div class="news-date">17/05/2025</div>
                        <h4 class="news-title">5 Cách chăm sóc răng miệng hiệu quả tại nhà</h4>
                        <p class="news-excerpt">Chăm sóc răng miệng đúng cách không chỉ giúp bạn có hàm răng trắng sáng mà còn phòng ngừa nhiều bệnh lý...</p>
                        <a href="#" class="news-link">Xem thêm</a>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-image">
                        <img src="img/placeholder-news.png" alt="Niềng răng trong suốt">
                    </div>
                    <div class="news-content">
                        <div class="news-date">10/05/2025</div>
                        <h4 class="news-title">Những điều cần biết về niềng răng trong suốt</h4>
                        <p class="news-excerpt">Niềng răng trong suốt đang là xu hướng được nhiều người lựa chọn nhờ tính thẩm mỹ cao và thuận tiện...</p>
                        <a href="#" class="news-link">Xem thêm</a>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-image">
                        <img src="img/placeholder-news.png" alt="Phòng ngừa sâu răng">
                    </div>
                    <div class="news-content">
                        <div class="news-date">05/05/2025</div>
                        <h4 class="news-title">Phòng ngừa sâu răng cho trẻ em hiệu quả</h4>
                        <p class="news-excerpt">Trẻ em là đối tượng dễ bị sâu răng. Hãy cùng tìm hiểu các biện pháp phòng ngừa sâu răng hiệu quả...</p>
                        <a href="#" class="news-link">Xem thêm</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact" id="contact">
            <h2>ĐỊA CHỈ - THÔNG TIN - LIÊN HỆ</h2>
            <p>Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng, Việt Nam</p>
            <div class="contact-container">
                <div class="map">
                    <!--<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.738711613779!2d108.25104871463337!3d15.978921588939292!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142108997dc971f%3A0x1295cb3d313469c9!2zVHLGsOG7nW5gIMSQ4bqhaSBo4buNYyBGUFQgxJDJoCBO4bq1bmc!5e0!3m2!1svi!2s!4v1650010000000!5m2!1svi!2s" allowfullscreen="" loading="lazy"></iframe>-->
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.8561681211877!2d108.2583163749275!3d15.968885884696162!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142116949840599%3A0x365b35580f52e8d5!2sFPT%20University%20Danang!5e0!3m2!1sen!2s!4v1748240468982!5m2!1sen!2s" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
                <div class="contact-info">
                    <h3>NHA KHOA HAPPY SMILE</h3>
                    <hr>
                    <p class="highlight-hours">Thời gian <span class="open-text">Mở cửa</span>: Từ thứ 2 đến thứ 7, 7:00 AM - 6:00 PM</p>
                    <p class="highlight-hours">Thời gian nghỉ trong tuần: Chủ nhật <span class="closed-text">Đóng cửa</span></p>
                    <hr>
                    <a href="#" class="contact-btn">Chốt lịch Đồng giá</a>
                </div>
            </div>
            <div class="contact-form">
                <div class="form-group">
                    <label for="name">Họ và tên</label>
                    <input type="text" id="name" class="form-control" placeholder="Họ và tên" required>
                </div>
                <div class="form-group">
                    <label for="email">Email hoặc số điện thoại</label>
                    <input type="text" id="email" class="form-control" placeholder="Email hoặc số điện thoại" required>
                </div>
                <div class="form-group">
                    <label for="gender">Giới tính</label>
                    <select id="gender" class="form-control" required>
                        <option value="">Chọn giới tính</option>
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="age">Tuổi</label>
                    <input type="number" id="age" class="form-control" placeholder="Tuổi" required>
                </div>
                <div class="form-group">
                    <label for="message">Nội dung</label>
                    <textarea id="message" class="form-control" placeholder="Nhập nội dung" required></textarea>
                </div>
                <button type="submit" class="submit-btn">Gửi thông tin</button>
            </div>
        </section>

        <footer class="footer">
            <div class="footer-container">
                <div class="footer-col">
                    <h4>HAPPY SMILE</h4>
                    <p>Phòng khám nha khoa tư nhân chuyên về răng, miệng, và cấy ghép implant. Chúng tôi cam kết mang đến dịch vụ chất lượng với giá cả hợp lý.</p>
                    <p>Địa chỉ: Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng</p>
                    <p>Hotline: 0123 456 789</p>
                    <p>Email: support@happysmile.com</p>
                    <p>Website: happysmile.com.vn</p>
                </div>
                <div class="footer-col">
                    <h4>DỊCH VỤ</h4>
                    <ul class="footer-links">
                        <li><a href="#">Khám tổng quát</a></li>
                        <li><a href="#">Tẩy trắng răng</a></li>
                        <li><a href="#">Bọc răng sứ</a></li>
                        <li><a href="#">Niềng răng</a></li>
                        <li><a href="#">Cấy ghép Implant</a></li>
                        <li><a href="#">Điều trị nha chu</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>TRỢ GIÚP</h4>
                    <ul class="footer-links">
                        <li><a href="#">Hướng dẫn đặt lịch</a></li>
                        <li><a href="#">Hướng dẫn thanh toán</a></li>
                        <li><a href="#">Quy trình khám bệnh</a></li>
                        <li><a href="#">Câu hỏi thường gặp</a></li>
                        <li><a href="#">Chính sách bảo mật</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>HỢP TÁC</h4>
                    <ul class="footer-links">
                        <li><a href="#">Tài khoản</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Tuyển dụng</a></li>
                        <li><a href="#">Đối tác bảo hiểm</a></li>
                        <li><a href="#">Cơ sở đào tạo</a></li>
                    </ul>
                </div>
            </div>
        </footer>

        <div class="copyright">
            Bản quyền thuộc về HAPPY Smile © 2025. All Rights Reserved.
        </div>

        <script>
            // Smooth scrolling for navigation links
            document.querySelectorAll('.nav ul li a').forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault(); // Prevent default anchor behavior
                    const targetId = this.getAttribute('href').substring(1); // Get the target section ID
                    const targetSection = document.getElementById(targetId);

                    if (targetSection) {
                        // Calculate the offset to account for fixed header
                        const headerHeight = document.querySelector('.header').offsetHeight;
                        const targetPosition = targetSection.getBoundingClientRect().top + window.pageYOffset - headerHeight;

                        // Smooth scroll to the target position
                        window.scrollTo({
                            top: targetPosition,
                            behavior: 'smooth'
                        });

                        // Update active link
                        document.querySelectorAll('.nav ul li a').forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    }
                });
            });
        </script>
    </body>
</html>