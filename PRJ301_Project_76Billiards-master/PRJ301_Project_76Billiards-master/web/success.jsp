<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành công</title>

    <style>
        .success-message {
            text-align: center;
            font-size: 24px;
            color: green;
        }
        .success-message .tick {
            font-size: 50px;
            color: green;
        }
        .success-message p {
            font-size: 18px;
        }
        .success-message h1 {
            font-size: 18px;
        }
        .button {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 10px;
            background-color: green;
            color: white;
            text-align: center;
            font-size: 18px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
    </style>
    <script type="text/javascript">
        // Hàm xóa tất cả session ngoài 'customer' trong sessionStorage
        function clearSessionExceptCustomer() {
            // Duyệt qua tất cả sessionStorage và xóa ngoại trừ 'customer'
            for (let key of Object.keys(sessionStorage)) {
                if (key !== 'customer') {
                    sessionStorage.removeItem(key); // Xóa session key không phải 'customer'
                }
            }

            // Chờ 3 giây trước khi chuyển hướng
            setTimeout(function() {
                // Chuyển hướng về trang BidaShop sau khi xóa session
                window.location.href = "BidaShop";  // Chuyển hướng đến trang BidaShop
            }, 3000);  // 3 giây trễ
        }

        // Gọi hàm sau khi trang đã tải xong
        window.onload = function() {
            clearSessionExceptCustomer();
        };
    </script>
</head>
<body>
    <div class="success-message">
        <span class="tick">✔</span>
        <p>${message}</p>
        <h1>Cảm ơn bạn đã mua hàng. Trang sẽ chuyển hướng sau 3 giây!</h1>


        <!-- Button to redirect to homepage -->
        <button href="BidaShop" id="return-home">Trở về trang chủ</button>

    </div>
</body>
</html>