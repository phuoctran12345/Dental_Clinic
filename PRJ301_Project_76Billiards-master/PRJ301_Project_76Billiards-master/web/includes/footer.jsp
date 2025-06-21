<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-section left-section">
            <h4 class="footer-title">Liên hệ</h4>
            <p><i class="fas fa-map-marker-alt"></i> FPT Đà Nẵng, Ngũ Hành Sơn</p>
            <p><i class="fas fa-phone"></i> 0364 598 349</p>
            <p><i class="fas fa-envelope"></i> lechitrung1810@gmail.com</p>
        </div>
        <div class="footer-section right-section">
            <h4 class="footer-title">Chúng tôi</h4>
            <p><i class="fas fa-info-circle"></i> Nhóm phát triển web FPT</p>
            <p><i class="fas fa-users"></i> Đội ngũ sáng tạo & nhiệt huyết</p>
            <p><i class="fas fa-globe"></i> Website: www.fptwebexample.com</p>
        </div>
    </div>
</footer>

<!-- FontAwesome để hiển thị icon -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;700&display=swap" rel="stylesheet">

<!-- CSS cho footer -->
<style>
    /* Footer */
    .footer {
        background: url('images/giohang.jpg') no-repeat center center fixed;
        background-size: cover;
        padding: 30px 0;
        font-family: 'Poppins', sans-serif;
        width: 100%;
        color: #FFFFFF;
    }

    /* Container trong footer */
    .footer .container {
        background: rgba(255, 255, 255, 0.3);
        padding: 15px;
        margin: 0 auto;
        max-width: 1200px;
        display: flex;
        justify-content: space-between; /* Căn đều hai bên */
        align-items: flex-start; /* Căn các section lên trên cùng */
        flex-wrap: nowrap; /* Không cho phép xuống dòng */
    }

    /* Section */
    .footer-section {
        flex: 1; /* Mỗi section chiếm không gian đều nhau */
        min-width: 220px;
        display: flex;
        flex-direction: column;
        align-items: flex-start; /* Căn nội dung trong section */
    }

    /* Specific positioning for left and right sections */
    .left-section {
        align-items: center; 
    }

    .right-section {
        align-items: center; 
    }

    /* Tiêu đề */
    .footer-title {
        font-size: 20px;
        font-weight: 700;
        text-transform: uppercase;
        margin-bottom: 12px;
        color: #FFFFFF;
        letter-spacing: 0.5px;
        text-shadow: none; /* Bỏ text-shadow để chữ rõ hơn */
    }

    /* Nội dung */
    .footer p {
        font-size: 13px;
        margin: 6px 0;
        font-weight: 400;
        color: #FFFFFF;
        text-shadow: none; /* Bỏ text-shadow để chữ rõ hơn */
        transition: transform 0.3s ease-in-out, color 0.3s ease-in-out;
    }

    /* Icon */
    .footer i {
        margin-right: 8px;
        font-size: 14px;
        color: #FFFFFF;
        text-shadow: none; /* Bỏ text-shadow để chữ rõ hơn */
        transition: transform 0.3s ease-in-out;
    }

    /* Hover hiệu ứng */
    .footer p:hover, .footer i:hover {
        color: #FFDD57;
        transform: translateY(-1px);
    }

    /* Responsive cho footer */
    @media (max-width: 768px) {
        .footer {
            padding: 20px 0;
        }
        .footer .container {
            padding: 10px;
            flex-direction: column; /* Xếp dọc trên mobile */
            gap: 15px;
        }
        .footer-section {
            min-width: 100%; /* Chiếm toàn bộ chiều rộng trên mobile */
            align-items: center; /* Căn giữa trên mobile */
        }
        .left-section, .right-section {
            align-items: center; /* Căn giữa trên mobile */
        }
        .footer-title {
            font-size: 18px;
        }
        .footer p {
            font-size: 12px;
        }
        .footer i {
            font-size: 13px;
        }
    }
</style>