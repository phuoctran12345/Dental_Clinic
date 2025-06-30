<%-- Document : doctor_profile Created on : [Insert Date], Author : [Your Name] --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật thông tin bác sĩ</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        /* General body styling */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7fc;
            overflow-x: hidden;
        }

        /* Content wrapper to handle menu toggle */
        .content-wrapper {
            width: 100%;
        }

        /* Main container with padding to avoid menu overlap */
        .container {
            padding: 80px 20px 20px 280px; /* Space for fixed menu */
            min-height: 100vh;
            max-width: 1400px; /* As requested */
            margin: 0 auto;
            transition: padding 0.3s ease;
        }

        /* Outer frame for all content */
        .outer-frame {
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            border: 1px solid #e2e8f0;
            padding: 32px;
            margin-bottom: 32px;
        }

        /* Page header styling */
        .page-header {
            margin-bottom: 24px;
        }

        .page-header h2 {
            color: #3b82f6; /* Vibrant blue */
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Alerts styling */
        .alert {
            border-radius: 5px;
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            position: relative;
        }

        .alert-success {
            background: #d1fae5;
            color: #047857;
            border: 1px solid #10b981;
        }

        .alert-danger {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #dc3545;
        }

        .alert-dismissible .btn-close {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            font-size: 14px;
            cursor: pointer;
            opacity: 0.7;
            padding: 0;
        }

        .alert-dismissible .btn-close:hover {
            opacity: 1;
        }

        /* Card styling */
        .card {
            background: #f9fafb;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .card-header {
            background: #3b82f6;
            color: #ffffff;
            padding: 16px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 5px 5px 0 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-body {
            padding: 24px;
        }

        /* Form styling */
        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
            margin-bottom: 20px;
        }

        .form-group {
            flex: 1;
            min-width: 300px; /* Ensures fields don't get too narrow */
        }

        .form-label {
            color: #1f2937;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }

        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            padding: 12px;
            font-size: 14px;
            color: #1f2937;
            width: 100%;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.2);
            outline: none;
        }

        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545;
        }

        .invalid-feedback {
            color: #dc3545;
            font-size: 12px;
            margin-top: 4px;
            display: none;
        }

        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback {
            display: block;
        }

        textarea.form-control {
            height: 100px;
            resize: vertical;
        }

        /* Submit button */
        .btn-primary {
            background: #3b82f6;
            color: #ffffff;
            border: none;
            padding: 12px 24px;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.2s ease, transform 0.1s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background: #2563eb;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            transform: translateY(-2px);
        }

        /* Responsive adjustments */
        @media (max-width: 1200px) {
            .container {
                padding-left: 250px;
            }
        }

        @media (max-width: 992px) {
            .container {
                padding-left: 20px;
                padding-right: 20px;
            }
            .form-row {
                flex-direction: column;
                gap: 16px;
            }
            .form-group {
                min-width: 100%;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 60px 15px 15px;
            }
            .outer-frame {
                padding: 16px;
            }
            .card-body {
                padding: 16px;
            }
            .page-header h2 {
                font-size: 20px;
            }
            .card-header {
                font-size: 16px;
            }
        }

        @media (max-width: 576px) {
            .outer-frame, .card-body {
                padding: 12px;
            }
            .form-control, .form-select {
                font-size: 12px;
                padding: 10px;
            }
            .btn-primary {
                padding: 10px 16px;
                font-size: 12px;
            }
            .alert {
                font-size: 12px;
                padding: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="container">
            <!-- Outer frame wrapping all content -->
            <div class="outer-frame">
                <!-- Page Header -->
                <div class="page-header">
                    <h2><i class="fa-solid fa-user-doctor"></i> Cập nhật thông tin bác sĩ</h2>
                </div>

                <!-- Alerts for Success/Error -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fa-solid fa-circle-check"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Profile Form -->
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-user-edit"></i> Thông tin cá nhân
                    </div>
                    <div class="card-body">
                        <form action="DoctorProfileServlet" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="update">

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="fullName" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                    <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                </div>
                                <div class="form-group">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required>
                                    <div class="invalid-feedback">Vui lòng nhập số điện thoại</div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                                    <div class="invalid-feedback">Vui lòng chọn ngày sinh</div>
                                </div>
                                <div class="form-group">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="">Chọn giới tính</option>
                                        <option value="male">Nam</option>
                                        <option value="female">Nữ</option>
                                        <option value="other">Khác</option>
                                    </select>
                                    <div class="invalid-feedback">Vui lòng chọn giới tính</div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                                <div class="invalid-feedback">Vui lòng nhập địa chỉ</div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="specialty" class="form-label">Chuyên khoa</label>
                                    <input type="text" class="form-control" id="specialty" name="specialty" required>
                                    <div class="invalid-feedback">Vui lòng nhập chuyên khoa</div>
                                </div>
                                <div class="form-group">
                                    <label for="licenseNumber" class="form-label">Số giấy phép hành nghề</label>
                                    <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" required>
                                    <div class="invalid-feedback">Vui lòng nhập số giấy phép</div>
                                </div>
                            </div>

                            <div class="text-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Lưu thông tin
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS for alerts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Form validation script -->
    <script>
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    </script>
</body>
</html>