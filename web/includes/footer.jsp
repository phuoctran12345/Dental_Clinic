<%-- 
    Document   : footer
    Created on : Jun 28, 2025
    Author     : tranhongphuoc, lebao
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <style>
        .footer {
            background: var(--footer-bg);
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
            background-color: var(--copyright-bg);
            font-size: 14px;
        }

        @media screen and (max-width: 768px) {
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
            .footer-container {
                margin: 0 20px;
                gap: 30px;
            }
        }
    </style>
</head>
<body>
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-col">
                <h4 data-lang="footer-title">HAPPY SMILE</h4>
                <p data-lang="footer-about">Phòng khám nha khoa tư nhân chuyên về răng, miệng, và cấy ghép implant. Chúng tôi cam kết mang đến dịch vụ chất lượng với giá cả hợp lý.</p>
                <p data-lang="footer-address">Địa chỉ: Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng</p>
                <p data-lang="footer-hotline">Hotline: 0123 456 789</p>
                <p data-lang="footer-email">Email: support@happysmile.com</p>
                <p data-lang="footer-website">Website: happysmile.com.vn</p>
            </div>
            <div class="footer-col">
                <h4 data-lang="footer-services-title">DỊCH VỤ</h4>
                <ul class="footer-links">
                    <li><a href="#" data-lang="service-general-checkup">Khám tổng quát</a></li>
                    <li><a href="#" data-lang="service-whitening">Tẩy trắng răng</a></li>
                    <li><a href="#" data-lang="service-veneers">Bọc răng sứ</a></li>
                    <li><a href="#" data-lang="service-braces">Niềng răng</a></li>
                    <li><a href="#" data-lang="service-implant">Cấy ghép Implant</a></li>
                    <li><a href="#" data-lang="service-periodontal">Điều trị nha chu</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 data-lang="footer-help-title">TRỢ GIÚP</h4>
                <ul class="footer-links">
                    <li><a href="#" data-lang="footer-help-booking">Hướng dẫn đặt lịch</a></li>
                    <li><a href="#" data-lang="footer-help-payment">Hướng dẫn thanh toán</a></li>
                    <li><a href="#" data-lang="footer-help-process">Quy trình khám bệnh</a></li>
                    <li><a href="#" data-lang="footer-help-faq">Câu hỏi thường gặp</a></li>
                    <li><a href="#" data-lang="footer-help-privacy">Chính sách bảo mật</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 data-lang="footer-cooperation-title">HỢP TÁC</h4>
                <ul class="footer-links">
                    <li><a href="#" data-lang="footer-cooperation-account">Tài khoản</a></li>
                    <li><a href="#" data-lang="footer-cooperation-contact">Liên hệ</a></li>
                    <li><a href="#" data-lang="footer-cooperation-recruitment">Tuyển dụng</a></li>
                    <li><a href="#" data-lang="footer-cooperation-insurance">Đối tác bảo hiểm</a></li>
                    <li><a href="#" data-lang="footer-cooperation-training">Cơ sở đào tạo</a></li>
                </ul>
            </div>
        </div>
    </footer>
    <div class="copyright" data-lang="copyright">
        Bản quyền thuộc về HAPPY Smile © 2025. All Rights Reserved.
    </div>
</body>
</html>