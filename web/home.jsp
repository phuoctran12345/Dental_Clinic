
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HAPPY Smile - Phòng khám nha khoa tư nhân chuyên nghiệp</title>
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

            body {
                background: var(--bg-color);
                padding-top: 120px;
                color: var(--text-color);
                transition: background 0.3s ease, color 0.3s ease;
            }

            .hero {
                background: linear-gradient(rgba(0,0,0,0.1), rgba(0,0,0,0.3)), url('img/banner.png');
                background-size: cover; /* Ảnh sẽ bao phủ toàn bộ màn hình */
                background-position: center; /* Căn giữa ảnh */
                color: #fff;
                padding: 120px 0;
                text-align: left;
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

            .services {
                padding: 50px;
                text-align: center;
                background: var(--bg-color);
            }

            .services h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, var(--link-color));
                -webkit-background-clip: text;
                background-clip: text;
                color: var(--highlight-text);
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
                background-color: var(--card-bg);
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                flex: 1;
                max-width: 220px;
                box-shadow: 0 5px 15px var(--shadow-color);
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
                background-color: var(--secondary-bg);
                text-align: center;
            }

            .about h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, var(--link-color));
                -webkit-background-clip: text;
                background-clip: text;
                color: var(--highlight-text);
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
                color: var(--text-color);
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
                box-shadow: 0 10px 20px var(--shadow-color);
                border: 3px solid #1e3a8a;
            }

            .team {
                background: var(--secondary-bg);
                padding: 50px;
                text-align: center;
            }

            .team h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, var(--link-color));
                -webkit-background-clip: text;
                background-clip: text;
                color: var(--highlight-text);
            }

            .team-slider {
                display: flex;
                flex-wrap: wrap;
                gap: 30px;
                justify-content: center;
                padding: 20px 0;
            }

            .doctor-card {
                background-color: var(--card-bg);
                border-radius: 10px;
                overflow: hidden;
                width: 100%;
                max-width: 280px;
                box-shadow: 0 5px 15px var(--shadow-color);
                transition: transform 0.3s ease;
            }

            .doctor-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px var(--shadow-color);
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
                background: var(--secondary-bg);
                padding: 50px;
                text-align: center;
            }

            .testimonials h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, var(--link-color));
                -webkit-background-clip: text;
                background-clip: text;
                color: var(--highlight-text);
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
                background-color: var(--testimonial-bg);
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
                color: var(--text-color);
                margin-bottom: 5px;
            }

            .author-info p {
                color: #666;
                font-size: 14px;
            }

            .news {
                padding: 50px;
                text-align: center;
                background: var(--bg-color);
            }

            .news h3 {
                font-size: 40px;
                margin-bottom: 40px;
                background: linear-gradient(135deg, #1e3a8a, var(--link-color));
                -webkit-background-clip: text;
                background-clip: text;
                color: var(--highlight-text);
            }

            .news-grid {
                display: flex;
                gap: 50px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .news-card {
                background-color: var(--news-card-bg);
                border-radius: 10px;
                overflow: hidden;
                width: 350px;
                box-shadow: 0 5px 15px var(--shadow-color);
                transition: transform 0.3s ease;
            }

            .news-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px var(--shadow-color);
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
                color: var(--text-color);
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
                color: var(--link-color);
                text-decoration: none;
                font-size: 15px;
                font-weight: 500;
            }

            .news-link:hover {
                text-decoration: underline;
            }

            .contact {
                padding: 50px;
                background-color: var(--secondary-bg);
                text-align: center;
            }

            .contact h2 {
                font-size: 40px;
                color: var(--highlight-text);
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
                box-shadow: 0 5px 15px var(--shadow-color);
            }

            .map iframe {
                width: 100%;
                height: 500px;
                border: 0;
            }

            .contact-info {
                flex: 1;
                padding: 30px;
                background: var(--card-bg);
                border: 1px solid #e0e0e0;
                border-radius: 15px;
                box-shadow: 0 4px 12px var(--shadow-color);
                display: flex;
                flex-direction: column;
                gap: 20px;
                text-align: center;
                font-size: 16px;
                justify-content: center;
                color: var(--text-color);
            }

            .contact-info h3 {
                font-size: 32px;
                color: var(--highlight-text);
                font-weight: 700;
                letter-spacing: 0.5px;
                margin-bottom: 15px;
            }

            .contact-info .highlight-hours {
                background-color: var(--testimonial-bg);
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 500;
                color: var(--text-color);
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
                background: linear-gradient(135deg, #256ee6, var(--link-color));
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
                box-shadow: 0 5px 15px var(--shadow-color);
            }

            .contact-form {
                margin-top: 40px;
                border: 2px solid #ddd;
                border-radius: 10px;
                padding: 20px;
                background-color: var(--card-bg);
                box-shadow: 0 5px 15px var(--shadow-color);
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
                background: var(--card-bg);
                color: var(--text-color);
            }

            .submit-btn {
                background: linear-gradient(135deg, #1453ba, var(--link-color));
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

            @media screen and (max-width: 768px) {
                body {
                    padding-top: 80px;
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
            }

            @media screen and (min-width: 769px) and (max-width: 1024px) {
                body {
                    padding-top: 150px;
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
            }
        </style>
    </head>
    <body>
        <%@ include file="/includes/header.jsp" %>

        <section class="hero" id="hero">
            <div class="hero-content">
                <h2 data-lang="hero-subtitle">Phòng khám nha khoa</h2>
                <h3 data-lang="hero-title">HAPPY SMILE</h3>
                
            </div>
        </section>

        <section class="about" id="about">
            <h3 data-lang="about-title">CHÚNG TÔI LÀ AI?</h3>
            <div class="about-content">
                <div class="about-text">
                    <p data-lang="about-text-1">HAPPY Smile là phòng khám nha khoa tư nhân chuyên nghiệp tại Việt Nam, với sứ mệnh mang đến dịch vụ chăm sóc răng miệng chất lượng cao và nụ cười khỏe mạnh cho mọi khách hàng.</p>
                    <p data-lang="about-text-2">Với đội ngũ bác sĩ giàu kinh nghiệm, được đào tạo bài bản trong và ngoài nước, cùng trang thiết bị hiện đại, chúng tôi cam kết mang đến những phương pháp điều trị tiên tiến và hiệu quả nhất.</p>
                    <p data-lang="about-text-3">Tại HAPPY Smile, chúng tôi không chỉ chữa trị các vấn đề răng miệng mà còn hướng đến việc phòng ngừa, tư vấn và chăm sóc sức khỏe răng miệng lâu dài cho khách hàng.</p>
                    <p data-lang="about-text-4">Hãy đến với chúng tôi để trải nghiệm dịch vụ nha khoa chất lượng trong một không gian thoải mái, thân thiện và chuyên nghiệp.</p>
                </div>
                <div class="about-image">
                    <img src="img/bacsii.png" alt="Phòng khám HAPPY Smile">
                </div>
            </div>
        </section>

        <section class="services" id="services">
            <h3 data-lang="services-title">DỊCH VỤ NHA KHOA</h3>
            <div class="service-container">
                <div class="service-row">
                    <div class="service-item">
                        <img src="img/icon1.jpg" alt="Khám tổng quát" class="service-icon">
                        <p data-lang="service-general-checkup">Khám tổng quát</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon2.jpg" alt="Trám răng" class="service-icon">
                        <p data-lang="service-filling">Trám răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon3.jpg" alt="Tẩy trắng răng" class="service-icon">
                        <p data-lang="service-whitening">Tẩy trắng răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon4.jpg" alt="Bọc răng sứ" class="service-icon">
                        <p data-lang="service-veneers">Bọc răng sứ</p>
                    </div>
                </div>
                <div class="service-row">
                    <div class="service-item">
                        <img src="img/icon5.jpg" alt="Niềng răng" class="service-icon">
                        <p data-lang="service-braces">Niềng răng</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon6.jpg" alt="Nhổ răng" class="service-icon">
                        <p data-lang="service-extraction">Nhổ răng</p>
                    </div>
                    <div class="service-item">
                        <img src="jsp/img/icon7.jpg" alt="Cấy ghép implant" class="service-icon">
                        <p data-lang="service-implant">Cấy ghép implant</p>
                    </div>
                    <div class="service-item">
                        <img src="img/icon8.jpg" alt="Điều trị nha chu" class="service-icon">
                        <p data-lang="service-periodontal">Điều trị nha chu</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="team" id="team">
            <h3 data-lang="team-title">ĐỘI NGŨ BÁC SĨ</h3>
            <div class="team-slider">
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi1.png" alt="Bác sĩ Nguyễn Văn A">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Nguyễn Văn A</h4>
                        <p data-lang="doctor-implant">Chuyên gia Implant</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi2.png" alt="Bác sĩ Trần Thị B">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Trần Thị B</h4>
                        <p data-lang="doctor-orthodontics">Chuyên gia Chỉnh nha</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi3.png" alt="Bác sĩ Lê Văn C">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Lê Văn C</h4>
                        <p data-lang="doctor-restoration">Chuyên gia Phục hình</p>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="img/bacsi4.png" alt="Bác sĩ Phạm Thị D">
                    </div>
                    <div class="doctor-info">
                        <h4>Bs. Phạm Thị D</h4>
                        <p data-lang="doctor-periodontal">Chuyên gia Nha chu</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="testimonials">
            <h3 data-lang="testimonials-title">CẢM NHẬN TỪ KHÁCH HÀNG</h3>
            <div class="testimonial-slider">
                <div class="testimonial-card">
                    <p class="testimonial-text" data-lang="testimonial-1">Tôi đã điều trị niềng răng tại HAPPY Smile và rất hài lòng với kết quả. Các bác sĩ rất tận tâm, tư vấn chi tiết và quá trình điều trị rất chuyên nghiệp. Giờ đây tôi có thể tự tin cười mà không cần phải che miệng nữa.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Nguyễn Thị Minh</h4>
                            <p data-lang="testimonial-author-1">Khách hàng niềng răng</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <p class="testimonial-text" data-lang="testimonial-2">Dịch vụ bọc răng sứ tại HAPPY Smile thực sự xuất sắc. Bác sĩ tư vấn rất tỉ mỉ, lựa chọn loại răng sứ phù hợp với gương mặt tôi. Kết quả vượt ngoài mong đợi, trông rất tự nhiên và đẹp. Tôi sẽ giới thiệu bạn bè đến đây.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Trần Văn Hoàng</h4>
                            <p data-lang="testimonial-author-2">Khách hàng bọc răng sứ</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <p class="testimonial-text" data-lang="testimonial-3">Mình thường xuyên đến HAPPY Smile để khám và vệ sinh răng định kỳ. Môi trường phòng khám sạch sẽ, hiện đại và thân thiện. Các bác sĩ và nhân viên rất chuyên nghiệp và chu đáo. Chất lượng dịch vụ xứng đáng với giá tiền.</p>
                    <div class="testimonial-author">
                        <div class="author-info">
                            <h4>Võ Hoàng Gia Linh</h4>
                            <p data-lang="testimonial-author-3">Khách hàng thường xuyên</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="news" id="news">
            <h3 data-lang="news-title">TIN TỨC NHA KHOA</h3>
            <div class="news-grid">
                <div class="news-card">
                    <div class="news-image">
                        <img src="img/tintuc1.png" alt="Cách chăm sóc răng miệng">
                    </div>
                    <div class="news-content">
                        <div class="news-date">17/05/2025</div>
                        <h4 class="news-title" data-lang="news-title-1">TOP 11 cách chăm sóc răng miệng hiệu quả, cho răng khỏe đẹp</h4>
                        <p class="news-excerpt" data-lang="news-excerpt-1">Chăm sóc răng miệng đúng cách không chỉ giúp bạn có hàm răng trắng sáng mà còn phòng ngừa nhiều bệnh lý...</p>
                        <a href="https://elitedental.com.vn/top-cac-cach-cham-soc-rang-mieng-hieu-qua-cho-rang-khoe-dep.html" class="news-link" data-lang="read-more">Xem thêm</a>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-image">
                        <img src="img/tintuc2.jpg" alt="Niềng răng trong suốt">
                    </div>
                    <div class="news-content">
                        <div class="news-date">10/05/2025</div>
                        <h4 class="news-title" data-lang="news-title-2">Những điều cần biết về niềng răng trong suốt</h4>
                        <p class="news-excerpt" data-lang="news-excerpt-2">Niềng răng trong suốt đang là xu hướng được nhiều người lựa chọn nhờ tính thẩm mỹ cao và thuận tiện...</p>
                        <a href="https://medlatec.vn/tin-tuc/nieng-rang-trong-suot--uu-nhuoc-diem-va-nhung-dieu-can-luu-y-s99-n31947" class="news-link" data-lang="read-more">Xem thêm</a>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-image">
                        <img src="img/tintuc3.png" alt="Phòng ngừa sâu răng">
                    </div>
                    <div class="news-content">
                        <div class="news-date">05/05/2025</div>
                        <h4 class="news-title" data-lang="news-title-3">Phòng ngừa sâu răng cho trẻ em hiệu quả</h4>
                        <p class="news-excerpt" data-lang="news-excerpt-3">Trẻ em là đối tượng dễ bị sâu răng. Hãy cùng tìm hiểu các biện pháp phòng ngừa sâu răng hiệu quả...</p>
                        <a href="https://elitedental.com.vn/doctors/nguyen-thi-xuan-ngoc" class="news-link" data-lang="read-more">Xem thêm</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact" id="contact">
            <h2 data-lang="contact-title">ĐỊA CHỈ - THÔNG TIN - LIÊN HỆ</h2>
            <p data-lang="contact-address">Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng, Việt Nam</p>
            <div class="contact-container">
                <div class="map">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.738711613779!2d108.25104871463337!3d15.978921588939292!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142108997dc971f%3A0x1295cb3d313469c9!2zVHLGsOG7nW5gIMSQ4bqhaSBo4buNYyBGUFQgxJDJoCBO4bq1bmc!5e0!3m2!1svi!2s!4v1650010000000!5m2!1svi!2s" allowfullscreen="" loading="lazy"></iframe>
                </div>
                <div class="contact-info">
                    <h3 data-lang="contact-info-title">NHA KHOA HAPPY SMILE</h3>
                    <hr>
                    <p class="highlight-hours" data-lang="contact-hours-open">Thời gian <span class="open-text">Mở cửa</span>: Từ thứ 2 đến thứ 7, 7:00 AM - 6:00 PM</p>
                    <p class="highlight-hours" data-lang="contact-hours-closed">Thời gian nghỉ trong tuần: Chủ nhật <span class="closed-text">Đóng cửa</span></p>
                    <hr>
                    <a href="#" class="contact-btn" data-lang="contact-btn">Chốt lịch Đồng giá</a>
                </div>
            </div>
            <div class="contact-form">
                <div class="form-group">
                    <label for="name" data-lang="form-name">Họ và tên</label>
                    <input type="text" id="name" class="form-control" placeholder="Họ và tên" required>
                </div>
                <div class="form-group">
                    <label for="email" data-lang="form-email">Email hoặc số điện thoại</label>
                    <input type="text" id="email" class="form-control" placeholder="Email hoặc số điện thoại" required>
                </div>
                <div class="form-group">
                    <label for="gender" data-lang="form-gender">Giới tính</label>
                    <select id="gender" class="form-control" required>
                        <option value="" data-lang="form-gender-select">Chọn giới tính</option>
                        <option value="male" data-lang="form-gender-male">Nam</option>
                        <option value="female" data-lang="form-gender-female">Nữ</option>
                        <option value="other" data-lang="form-gender-other">Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="age" data-lang="form-age">Tuổi</label>
                    <input type="number" id="age" class="form-control" placeholder="Tuổi" required>
                </div>
                <div class="form-group">
                    <label for="message" data-lang="form-message">Nội dung</label>
                    <textarea id="message" class="form-control" placeholder="Nhập nội dung" required></textarea>
                </div>
                <button type="submit" class="submit-btn" data-lang="form-submit">Gửi thông tin</button>
            </div>
        </section>

        <%@ include file="/includes/footer.jsp" %>

        <script>
            // Translations object
            const translations = {
                vi: {
                    "login": "Đăng nhập",
                    "register": "Đăng ký",
                    "overview": "Tổng quan",
                    "services": "Dịch vụ",
                    "team": "Đội ngũ bác sĩ",
                    "news": "Tin tức",
                    "contact": "Liên hệ",
                    "hero-subtitle": "Phòng khám nha khoa",
                    "hero-title": "HAPPY SMILE",
                    "book-appointment": "Đặt lịch khám ngay",
                    "about-title": "CHÚNG TÔI LÀ AI?",
                    "about-text-1": "HAPPY Smile là phòng khám nha khoa tư nhân chuyên nghiệp tại Việt Nam, với sứ mệnh mang đến dịch vụ chăm sóc răng miệng chất lượng cao và nụ cười khỏe mạnh cho mọi khách hàng.",
                    "about-text-2": "Với đội ngũ bác sĩ giàu kinh nghiệm, được đào tạo bài bản trong và ngoài nước, cùng trang thiết bị hiện đại, chúng tôi cam kết mang đến những phương pháp điều trị tiên tiến và hiệu quả nhất.",
                    "about-text-3": "Tại HAPPY Smile, chúng tôi không chỉ chữa trị các vấn đề răng miệng mà còn hướng đến việc phòng ngừa, tư vấn và chăm sóc sức khỏe răng miệng lâu dài cho khách hàng.",
                    "about-text-4": "Hãy đến với chúng tôi để trải nghiệm dịch vụ nha khoa chất lượng trong một không gian thoải mái, thân thiện và chuyên nghiệp.",
                    "services-title": "DỊCH VỤ NHA KHOA",
                    "service-general-checkup": "Khám tổng quát",
                    "service-filling": "Trám răng",
                    "service-whitening": "Tẩy trắng răng",
                    "service-veneers": "Bọc răng sứ",
                    "service-braces": "Niềng răng",
                    "service-extraction": "Nhổ răng",
                    "service-implant": "Cấy ghép implant",
                    "service-periodontal": "Điều trị nha chu",
                    "team-title": "ĐỘI NGŨ BÁC SĨ",
                    "doctor-implant": "Chuyên gia Implant",
                    "doctor-orthodontics": "Chuyên gia Chỉnh nha",
                    "doctor-restoration": "Chuyên gia Phục hình",
                    "doctor-periodontal": "Chuyên gia Nha chu",
                    "testimonials-title": "CẢM NHẬN TỪ KHÁCH HÀNG",
                    "testimonial-1": "Tôi đã điều trị niềng răng tại HAPPY Smile và rất hài lòng với kết quả. Các bác sĩ rất tận tâm, tư vấn chi tiết và quá trình điều trị rất chuyên nghiệp. Giờ đây tôi có thể tự tin cười mà không cần phải che miệng nữa.",
                    "testimonial-author-1": "Khách hàng niềng răng",
                    "testimonial-2": "Dịch vụ bọc răng sứ tại HAPPY Smile thực sự xuất sắc. Bác sĩ tư vấn rất tỉ mỉ, lựa chọn loại răng sứ phù hợp với gương mặt tôi. Kết quả vượt ngoài mong đợi, trông rất tự nhiên và đẹp. Tôi sẽ giới thiệu bạn bè đến đây.",
                    "testimonial-author-2": "Khách hàng bọc răng sứ",
                    "testimonial-3": "Mình thường xuyên đến HAPPY Smile để khám và vệ sinh răng định kỳ. Môi trường phòng khám sạch sẽ, hiện đại và thân thiện. Các bác sĩ và nhân viên rất chuyên nghiệp và chu đáo. Chất lượng dịch vụ xứng đáng với giá tiền.",
                    "testimonial-author-3": "Khách hàng thường xuyên",
                    "news-title": "TIN TỨC NHA KHOA",
                    "news-title-1": "TOP 11 cách chăm sóc răng miệng hiệu quả, cho răng khỏe đẹp",
                    "news-excerpt-1": "Chăm sóc răng miệng đúng cách không chỉ giúp bạn có hàm răng trắng sáng mà còn phòng ngừa nhiều bệnh lý...",
                    "news-title-2": "Những điều cần biết về niềng răng trong suốt",
                    "news-excerpt-2": "Niềng răng trong suốt đang là xu hướng được nhiều người lựa chọn nhờ tính thẩm mỹ cao và thuận tiện...",
                    "news-title-3": "Phòng ngừa sâu răng cho trẻ em hiệu quả",
                    "news-excerpt-3": "Trẻ em là đối tượng dễ bị sâu răng. Hãy cùng tìm hiểu các biện pháp phòng ngừa sâu răng hiệu quả...",
                    "read-more": "Xem thêm",
                    "contact-title": "ĐỊA CHỈ - THÔNG TIN - LIÊN HỆ",
                    "contact-address": "Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng, Việt Nam",
                    "contact-info-title": "NHA KHOA HAPPY SMILE",
                    "contact-hours-open": "Thời gian <span class='open-text'>Mở cửa</span>: Từ thứ 2 đến thứ 7, 7:00 AM - 6:00 PM",
                    "contact-hours-closed": "Thời gian nghỉ trong tuần: Chủ nhật <span class='closed-text'>Đóng cửa</span>",
                    "contact-btn": "Chốt lịch Đồng giá",
                    "form-name": "Họ và tên",
                    "form-email": "Email hoặc số điện thoại",
                    "form-gender": "Giới tính",
                    "form-gender-select": "Chọn giới tính",
                    "form-gender-male": "Nam",
                    "form-gender-female": "Nữ",
                    "form-gender-other": "Khác",
                    "form-age": "Tuổi",
                    "form-message": "Nội dung",
                    "form-submit": "Gửi thông tin",
                    "footer-title": "HAPPY SMILE",
                    "footer-about": "Phòng khám nha khoa tư nhân chuyên về răng, miệng, và cấy ghép implant. Chúng tôi cam kết mang đến dịch vụ chất lượng với giá cả hợp lý.",
                    "footer-address": "Địa chỉ: Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng",
                    "footer-hotline": "Hotline: 0123 456 789",
                    "footer-email": "Email: support@happysmile.com",
                    "footer-website": "Website: happysmile.com.vn",
                    "footer-services-title": "DỊCH VỤ",
                    "footer-help-title": "TRỢ GIÚP",
                    "footer-help-booking": "Hướng dẫn đặt lịch",
                    "footer-help-payment": "Hướng dẫn thanh toán",
                    "footer-help-process": "Quy trình khám bệnh",
                    "footer-help-faq": "Câu hỏi thường gặp",
                    "footer-help-privacy": "Chính sách bảo mật",
                    "footer-cooperation-title": "HỢP TÁC",
                    "footer-cooperation-account": "Tài khoản",
                    "footer-cooperation-contact": "Liên hệ",
                    "footer-cooperation-recruitment": "Tuyển dụng",
                    "footer-cooperation-insurance": "Đối tác bảo hiểm",
                    "footer-cooperation-training": "Cơ sở đào tạo",
                    "copyright": "Bản quyền thuộc về HAPPY Smile © 2025. All Rights Reserved."
                },
                en: {
                    "login": "Login",
                    "register": "Register",
                    "overview": "Overview",
                    "services": "Services",
                    "team": "Our Team",
                    "news": "News",
                    "contact": "Contact",
                    "hero-subtitle": "Dental Clinic",
                    "hero-title": "HAPPY SMILE",
                    "book-appointment": "Book an Appointment",
                    "about-title": "WHO WE ARE",
                    "about-text-1": "HAPPY Smile is a professional private dental clinic in Vietnam, dedicated to providing high-quality dental care and healthy smiles for all our clients.",
                    "about-text-2": "With a team of experienced dentists trained both domestically and internationally, along with state-of-the-art equipment, we are committed to delivering the most advanced and effective treatment methods.",
                    "about-text-3": "At HAPPY Smile, we not only treat dental issues but also focus on prevention, consultation, and long-term oral health care for our clients.",
                    "about-text-4": "Visit us to experience quality dental services in a comfortable, friendly, and professional environment.",
                    "services-title": "DENTAL SERVICES",
                    "service-general-checkup": "General Checkup",
                    "service-filling": "Dental Filling",
                    "service-whitening": "Teeth Whitening",
                    "service-veneers": "Porcelain Veneers",
                    "service-braces": "Braces",
                    "service-extraction": "Tooth Extraction",
                    "service-implant": "Dental Implant",
                    "service-periodontal": "Periodontal Treatment",
                    "team-title": "OUR TEAM",
                    "doctor-implant": "Implant Specialist",
                    "doctor-orthodontics": "Orthodontics Specialist",
                    "doctor-restoration": "Restoration Specialist",
                    "doctor-periodontal": "Periodontal Specialist",
                    "testimonials-title": "CLIENT TESTIMONIALS",
                    "testimonial-1": "I had my braces treatment at HAPPY Smile and am very satisfied with the results. The doctors were dedicated, provided detailed consultations, and the treatment process was very professional. Now I can smile confidently without covering my mouth.",
                    "testimonial-author-1": "Braces Client",
                    "testimonial-2": "The porcelain veneer service at HAPPY Smile was outstanding. The doctors were meticulous in their consultations, choosing the right veneers for my face. The results exceeded my expectations, looking very natural and beautiful. I will recommend my friends to come here.",
                    "testimonial-author-2": "Veneers Client",
                    "testimonial-3": "I regularly visit HAPPY Smile for checkups and cleanings. The clinic environment is clean, modern, and friendly. The doctors and staff are very professional and attentive. The service quality is worth the price.",
                    "testimonial-author-3": "Regular Client",
                    "news-title": "DENTAL NEWS",
                    "news-title-1": "TOP 11 Effective Ways to Care for Your Teeth at Home",
                    "news-excerpt-1": "Proper dental care not only helps you achieve a bright smile but also prevents many oral diseases...",
                    "news-title-2": "What You Need to Know About Clear Aligners",
                    "news-excerpt-2": "Clear aligners are a popular choice due to their high aesthetics and convenience...",
                    "news-title-3": "Effective Ways to Prevent Tooth Decay in Children",
                    "news-excerpt-3": "Children are prone to tooth decay. Let’s explore effective prevention methods...",
                    "read-more": "Read More",
                    "contact-title": "ADDRESS - INFORMATION - CONTACT",
                    "contact-address": "FPT City Urban Area, Ngu Hanh Son, Da Nang, Vietnam",
                    "contact-info-title": "HAPPY SMILE DENTAL",
                    "contact-hours-open": "Opening Hours: Monday to Saturday, 7:00 AM - 6:00 PM",
                    "contact-hours-closed": "Closed on Sundays",
                    "contact-btn": "Book Fixed-Price Appointment",
                    "form-name": "Full Name",
                    "form-email": "Email or Phone Number",
                    "form-gender": "Gender",
                    "form-gender-select": "Select Gender",
                    "form-gender-male": "Male",
                    "form-gender-female": "Female",
                    "form-gender-other": "Other",
                    "form-age": "Age",
                    "form-message": "Message",
                    "form-submit": "Submit",
                    "footer-title": "HAPPY SMILE",
                    "footer-about": "A private dental clinic specializing in teeth, oral health, and dental implants. We are committed to providing quality services at reasonable prices.",
                    "footer-address": "Address: FPT City Urban Area, Ngu Hanh Son, Da Nang",
                    "footer-hotline": "Hotline: 0123 456 789",
                    "footer-email": "Email: support@happysmile.com",
                    "footer-website": "Website: happysmile.com.vn",
                    "footer-services-title": "SERVICES",
                    "footer-help-title": "HELP",
                    "footer-help-booking": "Booking Guide",
                    "footer-help-payment": "Payment Guide",
                    "footer-help-process": "Treatment Process",
                    "footer-help-faq": "FAQs",
                    "footer-help-privacy": "Privacy Policy",
                    "footer-cooperation-title": "COOPERATION",
                    "footer-cooperation-account": "Account",
                    "footer-cooperation-contact": "Contact",
                    "footer-cooperation-recruitment": "Recruitment",
                    "footer-cooperation-insurance": "Insurance Partners",
                    "footer-cooperation-training": "Training Facilities",
                    "copyright": "Copyright © 2025 HAPPY Smile. All Rights Reserved."
                },
                ja: {
                    "login": "ログイン",
                    "register": "登録",
                    "overview": "概要",
                    "services": "サービス",
                    "team": "私たちのチーム",
                    "news": "ニュース",
                    "contact": "連絡先",
                    "hero-subtitle": "歯科クリニック",
                    "hero-title": "HAPPY SMILE",
                    "book-appointment": "今すぐ予約",
                    "about-title": "私たちは誰ですか？",
                    "about-text-1": "HAPPY Smileは、ベトナムのプロフェッショナルな民間歯科クリニックで、高品質の歯科ケアと健康な笑顔をお客様に提供することを使命としています。",
                    "about-text-2": "国内外で訓練を受けた経験豊富な歯科医師チームと最新の設備により、最も先進的で効果的な治療法をお約束します。",
                    "about-text-3": "HAPPY Smileでは、口腔の問題の治療だけでなく、予防、相談、長期的な口腔健康ケアにも重点を置いています。",
                    "about-text-4": "快適でフレンドリーかつプロフェッショナルな環境で、質の高い歯科サービスを体験してください。",
                    "services-title": "歯科サービス",
                    "service-general-checkup": "一般検診",
                    "service-filling": "詰め物",
                    "service-whitening": "歯のホワイトニング",
                    "service-veneers": "セラミックベニア",
                    "service-braces": "矯正",
                    "service-extraction": "抜歯",
                    "service-implant": "インプラント",
                    "service-periodontal": "歯周病治療",
                    "team-title": "私たちのチーム",
                    "doctor-implant": "インプラント専門医",
                    "doctor-orthodontics": "矯正専門医",
                    "doctor-restoration": "修復専門医",
                    "doctor-periodontal": "歯周病専門医",
                    "testimonials-title": "お客様の声",
                    "testimonial-1": "HAPPY Smileで矯正治療を受け、結果に非常に満足しています。医師は熱心で、詳細な相談を提供し、治療プロセスは非常にプロフェッショナルでした。今では口を隠さずに自信を持って笑えます。",
                    "testimonial-author-1": "矯正のお客様",
                    "testimonial-2": "HAPPY Smileのセラミックベニアサービスは本当に素晴らしかったです。医師は丁寧に相談し、私の顔に合ったベニアを選んでくれました。結果は期待以上で、とても自然で美しいです。友達にもここを勧めます。",
                    "testimonial-author-2": "ベニアのお客様",
                    "testimonial-3": "HAPPY Smileに定期的に検診とクリーニングのために通っています。クリニックの環境は清潔でモダン、フレンドリーです。医師とスタッフは非常にプロフェッショナルで丁寧です。サービスの質は価格に見合っています。",
                    "testimonial-author-3": "定期的なお客様",
                    "news-title": "歯科ニュース",
                    "news-title-1": "自宅で効果的に歯をケアする11の方法",
                    "news-excerpt-1": "正しい歯のケアは、白い歯を手に入れるだけでなく、多くの口腔疾患を予防します...",
                    "news-title-2": "透明な矯正について知っておくべきこと",
                    "news-excerpt-2": "透明な矯正は、審美性が高く便利なため、多くの人に選ばれるトレンドです...",
                    "news-title-3": "子供の虫歯を効果的に予防する方法",
                    "news-excerpt-3": "子供は虫歯になりやすいです。効果的な予防方法を探ってみましょう...",
                    "read-more": "もっと見る",
                    "contact-title": "住所 - 情報 - 連絡先",
                    "contact-address": "ベトナム、ダナン、グーハンソン、FPTシティ都市エリア",
                    "contact-info-title": "HAPPY SMILE歯科",
                    "contact-hours-open": "営業時間：月曜日から土曜日、7:00 AM - 6:00 PM",
                    "contact-hours-closed": "日曜日は休業",
                    "contact-btn": "固定価格で予約",
                    "form-name": "氏名",
                    "form-email": "メールまたは電話番号",
                    "form-gender": "性別",
                    "form-gender-select": "性別を選択",
                    "form-gender-male": "男性",
                    "form-gender-female": "女性",
                    "form-gender-other": "その他",
                    "form-age": "年齢",
                    "form-message": "メッセージ",
                    "form-submit": "送信",
                    "footer-title": "HAPPY SMILE",
                    "footer-about": "歯、口腔、インプラントを専門とする民間歯科クリニック。リーズナブルな価格で高品質のサービスを提供します。",
                    "footer-address": "住所：FPTシティ都市エリア、グーハンソン、ダナン",
                    "footer-hotline": "ホットライン：0123 456 789",
                    "footer-email": "メール：support@happysmile.com",
                    "footer-website": "ウェブサイト：happysmile.com.vn",
                    "footer-services-title": "サービス",
                    "footer-help-title": "ヘルプ",
                    "footer-help-booking": "予約ガイド",
                    "footer-help-payment": "支払いガイド",
                    "footer-help-process": "治療プロセス",
                    "footer-help-faq": "よくある質問",
                    "footer-help-privacy": "プライバシーポリシー",
                    "footer-cooperation-title": "協力",
                    "footer-cooperation-account": "アカウント",
                    "footer-cooperation-contact": "連絡先",
                    "footer-cooperation-recruitment": "採用",
                    "footer-cooperation-insurance": "保険のパートナー",
                    "footer-cooperation-training": "トレーニング施設",
                    "copyright": "© 2025 HAPPY Smile. All Rights Reserved."
                }
            };

            // Function to update page content based on selected language
            function updateLanguage(lang) {
                // Update all elements with data-lang attributes
                document.querySelectorAll('[data-lang]').forEach(element => {
                    const key = element.getAttribute('data-lang');
                    if (translations[lang] && translations[lang][key]) {
                        // Handle elements with HTML content (e.g., contact-hours-open)
                        if (element.innerHTML.includes('<span')) {
                            element.innerHTML = translations[lang][key];
                        } else {
                            element.textContent = translations[lang][key];
                        }
                    }
                });

                // Update placeholder attributes for form inputs
                document.querySelectorAll('input[placeholder], textarea[placeholder]').forEach(element => {
                    const key = element.getAttribute('data-lang');
                    if (translations[lang] && translations[lang][key]) {
                        element.placeholder = translations[lang][key];
                    }
                });

                // Update select options
                document.querySelectorAll('#gender option').forEach(option => {
                    const key = option.getAttribute('data-lang');
                    if (translations[lang] && translations[lang][key]) {
                        option.textContent = translations[lang][key];
                    }
                });

                // Update the language selector to reflect the current language
                document.getElementById('language-switcher').value = lang;
            }

            // Initialize language from session
            <%
                String language = (String) session.getAttribute("language");
                if (language == null) {
                    language = "vi"; // Default to Vietnamese
                }
            %>
            const currentLang = '<%= language%>';
            updateLanguage(currentLang);

            // Handle language switcher change event
            document.getElementById('language-switcher').addEventListener('change', function () {
                const selectedLang = this.value;
                // Update content immediately
                updateLanguage(selectedLang);
                // Send request to LanguageServlet to update session
                fetch(`LanguageServlet?lang=${selectedLang}`, {
                    method: 'GET'
                }).catch(error => {
                    console.error('Error updating language:', error);
                });
            });

            // Theme toggle functionality
            document.getElementById('theme-toggle').addEventListener('click', function () {
                const currentTheme = document.documentElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                document.documentElement.setAttribute('data-theme', newTheme);
                this.textContent = newTheme === 'dark' ? '☀️' : '🌙';
                // Save theme preference in localStorage
                localStorage.setItem('theme', newTheme);
            });

            // Initialize theme from localStorage
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
            document.getElementById('theme-toggle').textContent = savedTheme === 'dark' ? '☀️' : '🌙';
        </script>
    </body>
</html>