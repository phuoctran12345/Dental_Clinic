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
    <p><strong>P-Dental Clinic</strong></p>
    <p>Địa chỉ: 123 Đường Sức Khỏe, Quận 1, TP.HCM</p>
    <p>Hotline: 0909 123 456</p>
    <p>Email: lienhe@pdental.vn</p>
    <p>&copy; 2025 P-Dental. Tất cả quyền được bảo lưu.</p>
</footer>

