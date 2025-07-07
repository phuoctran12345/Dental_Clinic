<%-- Tóm lại: Nếu email Google chưa có trong database, hãy tự động tạo tài khoản mới rồi đăng nhập luôn. Nếu đã có thì
    đăng nhập như bình thường. --%>
    <%@ page contentType="text/html; charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <style>
                body {
                    /* Ghi chú: Đặt nền ảnh, căn giữa, cố định và phủ toàn màn hình trên màn hình lớn */
                    background: url('img/nen1.jpg') no-repeat center center fixed;
                    background-size: cover;
                    /* Nền phủ toàn màn hình trên màn hình lớn */
                    margin: 0;
                    padding: 0;
                    min-height: 100vh;
                    /* Ghi chú: Sử dụng flex để căn chỉnh container sang bên trái trên màn hình lớn */
                    display: flex;
                    justify-content: flex-start;
                    align-items: center;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                }

                .login-container {
                    /* Ghi chú: Đặt chiều rộng tối đa và căn chỉnh lề trái trên màn hình lớn */
                    width: 500px;
                    /* Thay max-width bằng width để cố định kích thước */
                    margin-left: 130px;
                    /* Khoảng cách từ lề trái trên màn hình lớn */
                    padding: 30px;
                    /* Tăng padding để form rộng hơn */
                    background-color: rgba(255, 255, 255, 0.9);
                    /* Thêm nền trắng mờ để dễ đọc */
                    border-radius: 15px;
                    /* Bo góc container */
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    /* Thêm bóng đổ nhẹ */
                }

                .login-container h3 {
                    /* Ghi chú: Định dạng tiêu đề với màu xanh, căn giữa, và kích thước chữ */
                    color: #4E80EE;
                    font-size: 31px;
                    font-weight: 600;
                    text-align: center;
                    margin-bottom: 30px;
                    /* Tăng khoảng cách dưới tiêu đề */
                }

                .form-control {
                    /* Ghi chú: Bo góc trường nhập liệu, thêm viền và hiệu ứng chuyển đổi */
                    border-radius: 15px;
                    border: 1px solid #ced4da;
                    padding: 15px;
                    /* Tăng padding cho input */
                    height: 45px;
                    /* Cố định chiều cao input */
                    font-size: 16px;
                    /* Tăng kích thước chữ */
                    transition: border-color 0.3s ease, box-shadow 0.3s ease;
                    margin-bottom: 15px;
                    /* Tăng khoảng cách giữa các input */
                }

                .form-control:focus {
                    /* Ghi chú: Hiệu ứng khi focus vào trường nhập liệu */
                    border-color: #3b82f6;
                    /* Màu viền xanh để rõ ràng */
                    box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
                }

                .btn-primary {
                    /* Ghi chú: Định dạng nút đăng nhập với màu xanh đậm và bo góc */
                    border-radius: 15px;
                    /* Bo góc nhiều hơn */
                    background-color: #0432b5;
                    border: none;
                    padding: 15px;
                    /* Tăng padding cho nút */
                    font-weight: 500;
                    font-size: 16px;
                    /* Tăng kích thước chữ */
                    height: 50px;
                    /* Cố định chiều cao nút */
                    transition: background-color 0.3s ease, transform 0.2s ease;
                }

                .btn-primary:hover {
                    /* Ghi chú: Hiệu ứng hover cho nút đăng nhập */
                    background-color: #022a8c;
                    transform: translateY(-2px);
                }

                .text-center a {
                    /* Ghi chú: Định dạng liên kết với màu đen và hiệu ứng hover */
                    color: #1f2937;
                    font-weight: 500;
                    text-decoration: none;
                    transition: color 0.2s ease;
                    font-size: 15px;
                    /* Tăng kích thước chữ */
                }

                .text-center a:hover {
                    /* Ghi chú: Đổi màu liên kết khi hover */
                    color: #3b82f6;
                    text-decoration: underline;
                }

                .error-message {
                    /* Ghi chú: Định dạng thông báo lỗi với màu đỏ, căn giữa */
                    color: #dc2626;
                    font-size: 0.875rem;
                    text-align: center;
                    margin-bottom: 1rem;
                }

                .form-label {
                    /* Ghi chú: Đảm bảo nhãn trường nhập liệu căn chỉnh đều */
                    font-weight: 700;
                    color: #1f2937;
                    font-size: 16px;
                    /* Tăng kích thước chữ nhãn */
                    margin-bottom: 8px;
                    /* Tăng khoảng cách dưới nhãn */
                }

                /* Thêm style cho nút Google */
                .google-btn {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background-color: #fff;
                    color: #1f2937;
                    border: 1px solid #ced4da;
                    border-radius: 15px;
                    padding: 12px;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    margin-bottom: 20px;
                }

                .google-btn:hover {
                    background-color: #f8f9fa;
                    transform: translateY(-2px);
                }

                .google-btn img {
                    width: 20px;
                    margin-right: 10px;
                }

                /* Điều chỉnh khoảng cách giữa các phần tử */
                .mb-3 {
                    margin-bottom: 20px !important;
                }

                .mt-3 {
                    margin-top: 5px !important;
                }

                .mt-4 {
                    margin-top: 5px !important;
                }
            </style>
        </head>

        <body>

            <div class="login-container">
                <h3 class="text-center">Please login to use the service</h3>
                <form action="<%= request.getContextPath()%>/LoginServlet" method="post">
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="Your Email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password_hash" name="password_hash" class="form-control"
                            placeholder="Your Password" required>
                    </div>
                    <% if (request.getParameter("error") !=null) { String error=request.getParameter("error"); String
                        errorMessage="" ; switch (error) { case "empty_fields" :
                        errorMessage="Vui lòng điền đầy đủ thông tin!" ; break; case "invalid_credentials" :
                        errorMessage="Email hoặc mật khẩu không đúng!" ; break; case "account_locked" :
                        errorMessage="Tài khoản đã bị khóa!" ; break; case "system_error" :
                        errorMessage="Có lỗi xảy ra, vui lòng thử lại!" ; break; default:
                        errorMessage="Đăng nhập thất bại!" ; }%>
                        <div class="alert alert-danger">
                            <%= errorMessage%>
                        </div>
                        <% }%>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                            <div style="margin-top: 20px">
                                <a class="google-btn w-100 text-decoration-none"
                                    href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/TestFull/LoginGG/LoginGoogleHandler&response_type=code&client_id=560611814939-bfrj1rtiahhq41h0d6fd3lcg876ic3ve.apps.googleusercontent.com&approval_prompt=force">
                                    <img src="https://www.google.com/favicon.ico" alt="Google">
                                    Sign in with Google
                                </a>
                            </div>

                            <div style="text-align:center; margin: 20px 0;">
                                <button type="button" id="face-camera-btn" class="google-btn w-100 text-decoration-none"
                                    style="border: 1px solid #dc2626;">
                                    <img src="https://cdn-icons-png.flaticon.com/512/1077/1077114.png" alt="Camera"
                                        style="width:24px; margin-right:10px;">
                                    Đăng nhập bằng khuôn mặt
                                </button>
                            </div>

                            <!-- Camera và Canvas để chụp ảnh -->
                            <div id="camera-section" style="display:none; text-align:center; margin: 20px 0;">
                                <div style="position: relative; display: inline-block;">
                                    <video id="video" width="300" height="200" autoplay
                                        style="border: 3px solid #28a745; border-radius: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);"></video>
                                    <div id="face-overlay"
                                        style="position: absolute; top: 0; left: 0; width: 300px; height: 200px; border: 2px dashed #ffc107; border-radius: 15px; pointer-events: none; display: none;">
                                    </div>
                                </div>
                                <div style="margin-top: 15px;">
                                    <div id="face-status"
                                        style="margin-bottom: 10px; font-weight: bold; color: #28a745;">📷
                                        Đang tìm khuôn mặt...</div>
                                    <button type="button" id="capture-btn" class="btn btn-success"
                                        style="margin-right: 10px;" disabled>
                                        <i class="fas fa-camera"></i> Chụp ảnh
                                    </button>
                                    <button type="button" id="cancel-btn" class="btn btn-secondary">
                                        <i class="fas fa-times"></i> Hủy
                                    </button>
                                </div>
                                <div id="countdown"
                                    style="font-size: 24px; font-weight: bold; color: #dc3545; margin-top: 10px; display: none;">
                                </div>
                            </div>
                            <canvas id="canvas" width="300" height="200" style="display:none;"></canvas>
                            <p class="text-center mt-3">
                                <a href="<%= request.getContextPath()%>/signup.jsp">Sign up</a> | <a
                                    href="ResetPasswordServlet?action=forgot-password">Quên mật khẩu?</a>
                            </p>

                            <div class="text-center mt-3">
                                <span>Hoặc</span>
                            </div>


                            <p class="text-center mt-4">
                                <a href="<%= request.getContextPath()%>/" style="color: blue;">Trang Chủ</a>
                            </p>


                </form>

            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <!-- Ghi chú: Script kiểm tra form trước khi gửi -->
            <script>
                document.querySelector("form").addEventListener("submit", function (e) {
                    const password = document.querySelector("input[name='password_hash']").value;
                    // Ghi chú: Có thể thêm logic kiểm tra mật khẩu nếu cần
                });
            </script>

            <script>
                let stream = null;
                let faceDetectionInterval = null;
                let countdownTimer = null;

                // Nút bấm mở camera
                document.getElementById('face-camera-btn').onclick = async function () {
                    try {
                        // Kiểm tra trình duyệt có hỗ trợ camera không
                        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                            alert('Trình duyệt của bạn không hỗ trợ camera!');
                            return;
                        }

                        // Mở camera với constraints tốt hơn
                        stream = await navigator.mediaDevices.getUserMedia({
                            video: {
                                width: { ideal: 640 },
                                height: { ideal: 480 },
                                facingMode: 'user' // Camera trước
                            }
                        });

                        const video = document.getElementById('video');
                        video.srcObject = stream;

                        // Hiển thị phần camera
                        document.getElementById('camera-section').style.display = 'block';
                        this.style.display = 'none';

                        // Bắt đầu detect khuôn mặt
                        startFaceDetection();

                    } catch (e) {
                        alert('Không thể mở camera! Vui lòng cho phép quyền truy cập camera.');
                        console.error('Camera error:', e);
                    }
                };

                // Hàm detect khuôn mặt liên tục
                function startFaceDetection() {
                    const video = document.getElementById('video');
                    const canvas = document.getElementById('canvas');
                    const ctx = canvas.getContext('2d');
                    const overlay = document.getElementById('face-overlay');
                    const status = document.getElementById('face-status');
                    const captureBtn = document.getElementById('capture-btn');

                    faceDetectionInterval = setInterval(() => {
                        if (video.readyState === video.HAVE_ENOUGH_DATA) {
                            // Vẽ frame hiện tại lên canvas để kiểm tra
                            ctx.drawImage(video, 0, 0, 300, 200);
                            const imageData = canvas.toDataURL('image/jpeg', 0.5);

                            // Giả lập detect khuôn mặt (trong thực tế gọi API)
                            // Ở đây chỉ enable nút chụp sau 2 giây để demo
                            setTimeout(() => {
                                overlay.style.display = 'block';
                                status.innerHTML = '✅ Phát hiện khuôn mặt - Sẵn sàng chụp!';
                                status.style.color = '#28a745';
                                captureBtn.disabled = false;
                                clearInterval(faceDetectionInterval);
                            }, 2000);
                        }
                    }, 500);
                }

                // Nút chụp ảnh với countdown
                document.getElementById('capture-btn').onclick = function () {
                    startCountdown();
                };

                // Countdown trước khi chụp
                function startCountdown() {
                    const countdown = document.getElementById('countdown');
                    const captureBtn = document.getElementById('capture-btn');

                    captureBtn.disabled = true;
                    countdown.style.display = 'block';

                    let count = 3;
                    countdown.textContent = count;

                    countdownTimer = setInterval(() => {
                        count--;
                        if (count > 0) {
                            countdown.textContent = count;
                        } else {
                            clearInterval(countdownTimer);
                            countdown.style.display = 'none';
                            capturePhoto();
                        }
                    }, 1000);
                }

                // Hàm chụp ảnh thực tế
                function capturePhoto() {
                    const video = document.getElementById('video');
                    const canvas = document.getElementById('canvas');
                    const ctx = canvas.getContext('2d');
                    const status = document.getElementById('face-status');

                    // Hiệu ứng flash
                    document.getElementById('face-overlay').style.background = 'rgba(255,255,255,0.8)';
                    setTimeout(() => {
                        document.getElementById('face-overlay').style.background = 'transparent';
                    }, 200);

                    // Vẽ ảnh từ video lên canvas
                    ctx.drawImage(video, 0, 0, 300, 200);

                    // Chuyển ảnh thành base64
                    const imageData = canvas.toDataURL('image/jpeg', 0.9);

                    status.innerHTML = '🔄 Đang xác thực...';
                    status.style.color = '#ffc107';

                    // Gửi lên server để nhận diện
                    fetch('FaceRecognitionServlet', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            action: 'login',
                            image: imageData
                        })
                    })
                        .then(res => res.json())
                        .then(result => {
                            if (result.success) {
                                status.innerHTML = '✅ Đăng nhập thành công!';
                                status.style.color = '#28a745';
                                setTimeout(() => {
                                    window.location.href = 'home.jsp';
                                }, 1500);
                            } else {
                                status.innerHTML = '❌ ' + (result.message || 'Đăng nhập thất bại!');
                                status.style.color = '#dc3545';
                                // Reset sau 3 giây
                                setTimeout(() => {
                                    resetCamera();
                                }, 3000);
                            }
                        })
                        .catch(err => {
                            status.innerHTML = '❌ Lỗi kết nối server!';
                            status.style.color = '#dc3545';
                            console.error('Login error:', err);
                            setTimeout(() => {
                                resetCamera();
                            }, 3000);
                        });
                }

                // Reset camera để thử lại
                function resetCamera() {
                    const status = document.getElementById('face-status');
                    const captureBtn = document.getElementById('capture-btn');
                    const overlay = document.getElementById('face-overlay');

                    status.innerHTML = '📷 Đang tìm khuôn mặt...';
                    status.style.color = '#28a745';
                    captureBtn.disabled = true;
                    overlay.style.display = 'none';

                    startFaceDetection();
                }

                // Nút hủy
                document.getElementById('cancel-btn').onclick = function () {
                    stopCamera();
                };

                // Hàm tắt camera
                function stopCamera() {
                    if (stream) {
                        stream.getTracks().forEach(track => track.stop());
                        stream = null;
                    }

                    // Clear intervals
                    if (faceDetectionInterval) {
                        clearInterval(faceDetectionInterval);
                        faceDetectionInterval = null;
                    }

                    if (countdownTimer) {
                        clearInterval(countdownTimer);
                        countdownTimer = null;
                    }

                    document.getElementById('camera-section').style.display = 'none';
                    document.getElementById('face-camera-btn').style.display = 'block';
                    document.getElementById('countdown').style.display = 'none';
                }
            </script>

        </body>

        </html>