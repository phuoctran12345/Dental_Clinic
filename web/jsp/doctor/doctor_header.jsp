<%-- Document : header Created on : May 16, 2025, 3:26:29 PM Author : Home --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Header đơn giản</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                    font-family: 'Segoe UI', sans-serif;
                }

                body {
                    background-color: #f4f4f4;
                }

                .header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 10px 30px;
                    background-color: #f8f9fb;
                }


                .search-bar {

                    flex: 1;
                    margin-right: 30px;
                    position: relative;
                    padding-left: 250px;
                }

                .search-bar input {
                    width: 100%;
                    padding: 10px 40px 10px 15px;
                    border: 1px solid #ccc;
                    border-radius: 20px;
                    font-size: 16px;
                }

                .search-bar i {
                    position: absolute;
                    right: 15px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #aaa;
                }

                .auth-buttons button {
                    margin-left: 10px;
                    padding: 8px 18px;
                    border: none;
                    border-radius: 20px;
                    background-color: #00BFFF;
                    color: white;
                    font-weight: bold;
                    cursor: pointer;
                    transition: background 0.3s;
                }

                .auth-buttons button:hover {
                    background-color: #0095cc;
                }

                #menu-toggle:checked~.header .search-bar {
                    width: 300px;
                    margin-left: -137px;
                    transition: 0.27s ease;
                }

                .search-bar {
                    transition: 0.3s ease;
                }
            </style>
        </head>

        <body>
            <input type="checkbox" id="menu-toggle" hidden>

            <div class="header">
                <div class="search-bar">
                    <input type="text" placeholder="Tìm kiếm...">
                    <i class="fa fa-search"></i>
                </div>

                <div class="auth-buttons">


                    <button onclick="location.href = 'login.jsp'">Đăng nhập</button>
                    <button onclick="location.href = 'register.jsp'">Đăng ký</button>

                </div>


            </div>
            </div>

        </body>

        </html>
        <script>
            // Kiểm tra elements tồn tại trước khi thêm event listeners
            document.addEventListener('DOMContentLoaded', function () {
                const avatarImg = document.getElementById('avatarImg');
                const avatarInput = document.getElementById('avatarInput');
                const uploadForm = document.getElementById('uploadForm');

                if (avatarImg && avatarInput) {
                    avatarImg.addEventListener('click', () => avatarInput.click());
                }

                if (avatarInput && uploadForm) {
                    avatarInput.addEventListener('change', () => {
                        if (avatarInput.files.length > 0) {
                            uploadForm.submit();
                        }
                    });
                }
            });
        </script>