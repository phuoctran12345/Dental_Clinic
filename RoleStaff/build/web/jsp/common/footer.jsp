<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Footer</title>
        <style>
            .footer {
                background-color: #f8f9fa;
                padding: 20px 0;
                text-align: center;
                position: fixed;
                bottom: 0;
                width: 100%;
                border-top: 1px solid #dee2e6;
            }
            
            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 20px;
            }
            
            .footer-left {
                text-align: left;
            }
            
            .footer-right {
                text-align: right;
            }
            
            .footer p {
                margin: 5px 0;
                color: #6c757d;
                font-size: 14px;
            }
            
            .footer a {
                color: #0d6efd;
                text-decoration: none;
            }
            
            .footer a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-left">
                    <p>© 2024 Happy Smile Dental Clinic</p>
                    <p>Địa chỉ: 123 Đường ABC, Quận 1, TP.HCM</p>
                </div>
                <div class="footer-right">
                    <p>Hotline: 0987 654 321</p>
                    <p>Email: contact@happysmile.com</p>
                </div>
            </div>
        </footer>
    </body>
</html> 