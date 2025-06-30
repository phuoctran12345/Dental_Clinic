<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer id = (Integer) session.getAttribute("id");
    String tempEmail = (String) session.getAttribute("temp_email");

    if (id == null && tempEmail == null) {
        // Người dùng không đăng nhập, cũng chưa đăng ký bước 1 => quay về login
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông Tin Bệnh Nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            /* Body với nền ảnh nền full màn hình, căn trái, căn giữa chiều dọc */
            body {
                background: url('img/nen2.jpg') no-repeat center center fixed;
                background-size: cover;
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                justify-content: center; /* Căn giữa ngang */
                align-items: center;     /* Căn giữa dọc */
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            }

            .card {
                max-width: 700px; /* hoặc width: 600px; */
                padding: 25px 30px;
                background: rgba(255, 255, 255, 0.85);
                border-radius: 8px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            }


            h4.text-center {
                color: #3b82f6;
                font-weight: 600;
                font-size: 30px;
                margin-bottom: 30px;
            }

            .form-label {
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 6px;
            }

            .form-control, .form-select {
                border-radius: 10px;
                border: 1px solid #ced4da;
                padding: 12px 15px;
                font-size: 15px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 8px rgba(59, 130, 246, 0.4);
                outline: none;
            }

            .btn-primary {
                border-radius: 8px;
                background-color: #0432b5;
                border: none;
                padding: 14px;
                font-weight: 600;
                font-size: 18px;
                transition: background-color 0.3s ease, transform 0.2s ease;
                width: 100%; /* Đảm bảo nút rộng 100% */
            }

            .btn-primary:hover {
                background-color: #022a8c;
                transform: translateY(-2px);
            }
        </style>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function handleFormSubmit(event) {
                event.preventDefault(); // Ngăn form submit ngay lập tức
                
                // Lấy form data
                const form = event.target;
                const formData = new FormData(form);
                
                // Submit form bằng fetch
                fetch('RegisterInformation', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        // Hiển thị thông báo thành công
                        Swal.fire({
                            title: 'Hoàn tất thành công!',
                            text: 'Đã hoàn tất tất cả các thông tin! Vui lòng đăng nhập lại.',
                            icon: 'success',
                            confirmButtonText: 'Đến trang đăng nhập',
                            confirmButtonColor: '#0432b5',
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            showClass: {
                                popup: 'animate__animated animate__fadeInDown'
                            },
                            hideClass: {
                                popup: 'animate__animated animate__fadeOutUp'
                            }
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.location.href = "login.jsp";
                            }
                        });
                    } else {
                        // Hiển thị lỗi nếu có
                        Swal.fire({
                            title: 'Có lỗi xảy ra!',
                            text: 'Vui lòng thử lại sau.',
                            icon: 'error',
                            confirmButtonColor: '#0432b5'
                        });
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire({
                        title: 'Có lỗi xảy ra!',
                        text: 'Vui lòng thử lại sau.',
                        icon: 'error',
                        confirmButtonColor: '#0432b5'
                    });
                });
                
                return false;
            }
        </script>
    </head>


    <body class="d-flex justify-content-center align-items-center vh-100 bg-light">
        <div class="card p-4">
            <h4 class="text-center mb-3">Xin hãy hoàn tất thông tin cá nhân</h4>

            <form action="RegisterInformation" method="post" onsubmit="return handleFormSubmit(event)">
                <div class="mb-3">
                    <label class="form-label">Họ tên</label>
                    <input type="text" name="full_name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" name="phone" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Ngày sinh</label>
                    <input type="date" name="date_of_birth" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <select name="gender" class="form-select">
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100">Hoàn tất đăng ký</button>
            </form>
        </div>
    </body>
</html>