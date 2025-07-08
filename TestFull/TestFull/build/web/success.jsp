<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thành công - Phòng khám nha khoa</title>

        <!-- Tailwind CSS CDN -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
            }

            .success-animation {
                animation: bounceIn 0.8s ease-out;
            }

            @keyframes bounceIn {
                0% {
                    transform: scale(0.3);
                    opacity: 0;
                }

                50% {
                    transform: scale(1.05);
                }

                70% {
                    transform: scale(0.9);
                }

                100% {
                    transform: scale(1);
                    opacity: 1;
                }
            }

            .floating {
                animation: floating 3s ease-in-out infinite;
            }

            @keyframes floating {

                0%,
                100% {
                    transform: translateY(0px);
                }

                50% {
                    transform: translateY(-10px);
                }
            }

            .gradient-bg {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 50%, #bae6fd 100%);
            }

            .btn-primary {
                background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(2, 132, 199, 0.3);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #64748b 0%, #475569 100%);
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, #475569 0%, #334155 100%);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(71, 85, 105, 0.3);
            }
        </style>
    </head>

    <body class="gradient-bg min-h-screen">
        <!-- Background Decoration -->
        <div class="absolute inset-0 overflow-hidden pointer-events-none">
            <div class="absolute top-10 left-10 w-20 h-20 bg-blue-200 rounded-full opacity-50 floating"></div>
            <div class="absolute top-32 right-20 w-16 h-16 bg-cyan-200 rounded-full opacity-40"
                style="animation-delay: 1s;"></div>
            <div class="absolute bottom-20 left-1/4 w-24 h-24 bg-sky-200 rounded-full opacity-30 floating"
                style="animation-delay: 2s;"></div>
            <div class="absolute bottom-32 right-1/3 w-12 h-12 bg-blue-300 rounded-full opacity-60"></div>
        </div>

        <div class="min-h-screen flex items-center justify-center p-4 relative z-10">
            <div class="max-w-md w-full">
                <!-- Success Card -->
                <div class="bg-white rounded-3xl shadow-2xl p-8 text-center success-animation">
                    <!-- Success Icon -->
                    <div class="mb-6">
                        <div
                            class="w-20 h-20 bg-gradient-to-br from-green-400 to-green-600 rounded-full flex items-center justify-center mx-auto success-animation">
                            <i class="fas fa-check text-white text-3xl"></i>
                        </div>
                    </div>

                    <!-- Title -->
                    <h1 class="text-3xl font-bold text-gray-800 mb-4">
                        Thành công!
                    </h1>

                    <!-- Message -->
                    <p class="text-gray-600 text-lg mb-2">
                        Báo cáo y tế đã được lưu thành công
                    </p>
                    <p class="text-gray-500 text-sm mb-8">
                        Thông tin khám bệnh và đơn thuốc đã được cập nhật vào hệ thống
                    </p>

                    <!-- Success Details -->
                    <div class="bg-gradient-to-r from-blue-50 to-cyan-50 rounded-2xl p-4 mb-8">
                        <div class="flex items-center justify-center space-x-4 text-sm text-gray-600">
                            <div class="flex items-center space-x-2">
                                <i class="fas fa-file-medical text-blue-500"></i>
                                <span>Báo cáo đã lưu</span>
                            </div>
                            <div class="w-1 h-1 bg-gray-400 rounded-full"></div>
                            <div class="flex items-center space-x-2">
                                <i class="fas fa-pills text-green-500"></i>
                                <span>Đơn thuốc đã kê</span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="space-y-4">
                        <!-- Primary Button - Về trang chủ -->
                        <a href="DoctorHomePageServlet"
                            class="btn-primary block w-full py-4 px-6 rounded-2xl text-white font-semibold text-lg shadow-lg">
                            <i class="fas fa-home mr-3"></i>
                            Về trang chủ
                        </a>

                        <!-- Secondary Button - Xem lịch hẹn -->
                        <a href="DoctorAppointmentsToanServlet"
                            class="btn-secondary block w-full py-3 px-6 rounded-2xl text-white font-medium shadow-lg">
                            <i class="fas fa-calendar-alt mr-3"></i>
                            Xem lịch hẹn
                        </a>
                    </div>

                    <!-- Additional Info -->
                    <div class="mt-8 pt-6 border-t border-gray-100">
                        <p class="text-xs text-gray-400 mb-2">
                            <i class="fas fa-info-circle mr-1"></i>
                            Thông tin đã được đồng bộ với hệ thống
                        </p>
                        <p class="text-xs text-gray-400">
                            Thời gian: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new
                                java.util.Date()) %>
                        </p>
                    </div>
                </div>

                <!-- Bottom Text -->
                <div class="text-center mt-6">
                    <p class="text-white text-sm opacity-80">
                        <i class="fas fa-shield-alt mr-2"></i>
                        Dữ liệu được bảo mật an toàn
                    </p>
                </div>
            </div>
        </div>

        <!-- Auto redirect script (optional) -->
        <script>
                    ng chuyển hướng sau  10 g                bỏ comment nếu muốn)
        // setTimeout(funct                    // o            on.href = 'DoctorHomePageServlet               // }, 10000);
        
        // Add click sound e ffect                ument.querySelectorAll('a').forEach(l                         link.addEventListener('click', function() {
                    // You can add sound effe                    d
                console.log('Navigating  to:'                  });
        });
        </script>
    </body>

    </html>