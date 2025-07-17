-- =============================================
-- CẤU HÌNH DATABASE CHO VINAHOST
-- =============================================

-- Tạo database
CREATE DATABASE IF NOT EXISTS dental_clinic_db
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Sử dụng database
USE dental_clinic_db;

-- Tạo user và cấp quyền (thay thế bằng thông tin thực từ VinaHost)
-- CREATE USER 'dental_user'@'localhost' IDENTIFIED BY 'your_secure_password';
-- GRANT ALL PRIVILEGES ON dental_clinic_db.* TO 'dental_user'@'localhost';
-- FLUSH PRIVILEGES;

-- Import dữ liệu từ file SQL gốc
-- SOURCE /path/to/your/dental_clinic.sql;

-- Kiểm tra các bảng đã tạo
SHOW TABLES;

-- Kiểm tra encoding
SHOW VARIABLES LIKE 'character_set%';
SHOW VARIABLES LIKE 'collation%';

-- =============================================
-- LƯU Ý QUAN TRỌNG:
-- =============================================
-- 1. Thay 'your_secure_password' bằng mật khẩu mạnh
-- 2. Import file dental_clinic.sql từ dự án gốc
-- 3. Cập nhật connection string trong code Java
-- 4. Test kết nối database trước khi deploy 