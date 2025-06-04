<%-- 
    Document   : footer
    Created on : May 16, 2025, 5:12:19 PM
    Author     : Home
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- Footer nha khoa -->
        <style>
            #menu-toggle:checked ~.footer p {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }
            .footer p {
                transition: transform 0.3s ease;
            }
        </style>
                <input type="checkbox" id="menu-toggle" hidden>

<footer class="footer" style="background-color: #0077cc; color: white; text-align: center; padding-left: 200px; padding-bottom: 30px; padding-top: 30px;">
    <p><strong>HAPPY SMILE</strong></p>
    <p>Địa chỉ: Khu đô thị FPT City, Ngũ Hành Sơn, Đà Nẵng</p>
    <p>Hotline: 0123 456 789</p>
    <p>Email: support@happysmile.com</p>
    <p>&copy; 2025 Happy Smile. Tất cả quyền được bảo lưu.</p>
</footer>

