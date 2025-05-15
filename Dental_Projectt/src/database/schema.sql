-- Tạo database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'dental_clinic')
BEGIN
    CREATE DATABASE dental_clinic;
END
GO

USE dental_clinic;
GO

-- Bảng Users (Người dùng)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(50) UNIQUE NOT NULL,
        password_hash NVARCHAR(255) NOT NULL, -- Sử dụng BCrypt để hash mật khẩu
        email NVARCHAR(100) UNIQUE NOT NULL,
        phone NVARCHAR(15),
        full_name NVARCHAR(100) NOT NULL,
        role NVARCHAR(20) CHECK (role IN ('ADMIN', 'DOCTOR', 'PATIENT', 'STAFF')) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE()
    );
END
GO

-- Bảng Doctors (Bác sĩ)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'doctors')
BEGIN
    CREATE TABLE doctors (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        specialization NVARCHAR(100),
        license_number NVARCHAR(50) UNIQUE NOT NULL,
        experience_years INT,
        FOREIGN KEY (user_id) REFERENCES users(id)
    );
END
GO

-- Bảng Patients (Bệnh nhân)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'patients')
BEGIN
    CREATE TABLE patients (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        date_of_birth DATE,
        gender NVARCHAR(10) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
        address NVARCHAR(MAX),
        medical_history NVARCHAR(MAX),
        FOREIGN KEY (user_id) REFERENCES users(id)
    );
END
GO

-- Bảng Staff (Nhân viên)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'staff')
BEGIN
    CREATE TABLE staff (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        position NVARCHAR(100),
        department NVARCHAR(100),
        FOREIGN KEY (user_id) REFERENCES users(id)
    );
END
GO

-- Bảng Appointments (Lịch hẹn)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'appointments')
BEGIN
    CREATE TABLE appointments (
        id INT IDENTITY(1,1) PRIMARY KEY,
        patient_id INT NOT NULL,
        doctor_id INT NOT NULL,
        appointment_date DATETIME NOT NULL,
        status NVARCHAR(20) CHECK (status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')) NOT NULL,
        reason NVARCHAR(MAX),
        payment_status NVARCHAR(20) CHECK (payment_status IN ('PENDING', 'PAID', 'REFUNDED')) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (patient_id) REFERENCES patients(id),
        FOREIGN KEY (doctor_id) REFERENCES doctors(id)
    );
END
GO

-- Bảng MedicalRecords (Hồ sơ y tế)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'medical_records')
BEGIN
    CREATE TABLE medical_records (
        id INT IDENTITY(1,1) PRIMARY KEY,
        patient_id INT NOT NULL,
        doctor_id INT NOT NULL,
        appointment_id INT NOT NULL,
        diagnosis NVARCHAR(MAX),
        treatment_plan NVARCHAR(MAX),
        notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (patient_id) REFERENCES patients(id),
        FOREIGN KEY (doctor_id) REFERENCES doctors(id),
        FOREIGN KEY (appointment_id) REFERENCES appointments(id)
    );
END
GO

-- Bảng Prescriptions (Đơn thuốc)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'prescriptions')
BEGIN
    CREATE TABLE prescriptions (
        id INT IDENTITY(1,1) PRIMARY KEY,
        medical_record_id INT NOT NULL,
        medicine_name NVARCHAR(100) NOT NULL,
        dosage NVARCHAR(100) NOT NULL,
        frequency NVARCHAR(100) NOT NULL,
        duration NVARCHAR(100) NOT NULL,
        notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (medical_record_id) REFERENCES medical_records(id)
    );
END
GO

-- Bảng Feedback (Phản hồi)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'feedback')
BEGIN
    CREATE TABLE feedback (
        id INT IDENTITY(1,1) PRIMARY KEY,
        patient_id INT NOT NULL,
        doctor_id INT NOT NULL,
        appointment_id INT NOT NULL,
        rating INT CHECK (rating >= 1 AND rating <= 5),
        comment NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (patient_id) REFERENCES patients(id),
        FOREIGN KEY (doctor_id) REFERENCES doctors(id),
        FOREIGN KEY (appointment_id) REFERENCES appointments(id)
    );
END
GO

-- Bảng ChatSessions (Phiên chat)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'chat_sessions')
BEGIN
    CREATE TABLE chat_sessions (
        id INT IDENTITY(1,1) PRIMARY KEY,
        patient_id INT NOT NULL,
        doctor_id INT,
        staff_id INT,
        status NVARCHAR(20) CHECK (status IN ('ACTIVE', 'CLOSED')) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        closed_at DATETIME,
        FOREIGN KEY (patient_id) REFERENCES patients(id),
        FOREIGN KEY (doctor_id) REFERENCES doctors(id),
        FOREIGN KEY (staff_id) REFERENCES staff(id)
    );
END
GO

-- Bảng ChatMessages (Tin nhắn chat)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'chat_messages')
BEGIN
    CREATE TABLE chat_messages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        chat_session_id INT NOT NULL,
        sender_id INT NOT NULL,
        message NVARCHAR(MAX) NOT NULL,
        is_read BIT DEFAULT 0,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id)
    );
END
GO

-- Bảng Notifications (Thông báo)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'notifications')
BEGIN
    CREATE TABLE notifications (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        title NVARCHAR(100) NOT NULL,
        message NVARCHAR(MAX) NOT NULL,
        type NVARCHAR(20) CHECK (type IN ('APPOINTMENT', 'CHAT', 'SYSTEM')) NOT NULL,
        is_read BIT DEFAULT 0,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES users(id)
    );
END
GO

-- Bảng Payments (Thanh toán)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'payments')
BEGIN
    CREATE TABLE payments (
        id INT IDENTITY(1,1) PRIMARY KEY,
        appointment_id INT NOT NULL,
        amount DECIMAL(10,2) NOT NULL,
        payment_method NVARCHAR(50) CHECK (payment_method IN ('CASH', 'CREDIT_CARD', 'BANK_TRANSFER', 'MOMO', 'VNPAY', 'ZALOPAY')) NOT NULL,
        transaction_id NVARCHAR(100),
        status NVARCHAR(20) CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED')) NOT NULL,
        payment_date DATETIME DEFAULT GETDATE(),
        notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (appointment_id) REFERENCES appointments(id)
    );
END
GO

-- Cập nhật bảng appointments để thêm các trường liên quan đến thanh toán
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'appointments')
BEGIN
    -- Thêm cột price vào bảng appointments
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('appointments') AND name = 'price')
    BEGIN
        ALTER TABLE appointments ADD price DECIMAL(10,2) NOT NULL DEFAULT 0;
    END

    -- Thêm cột payment_id vào bảng appointments
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('appointments') AND name = 'payment_id')
    BEGIN
        ALTER TABLE appointments ADD payment_id INT;
        ALTER TABLE appointments ADD CONSTRAINT FK_Appointments_Payments FOREIGN KEY (payment_id) REFERENCES payments(id);
    END
END
GO

-- Dữ liệu mẫu (Plaintext để minh họa)

-- Thêm users (Mật khẩu được hash bằng bcrypt trong thực tế)
INSERT INTO users (username, password_hash, email, phone, full_name, role) VALUES
('admin', '$2a$10$X7UrH5YxX5YxX5YxX5YxX.', 'admin@dental.com', '0123456789', 'Admin User', 'ADMIN'),
('doctor1', '$2a$10$X7UrH5YxX5YxX5YxX5YxX.', 'doctor1@dental.com', '0123456781', 'Dr. Nguyen Van A', 'DOCTOR'),
('doctor2', '$2a$10$X7UrH5YxX5YxX5YxX5YxX.', 'doctor2@dental.com', '0123456782', 'Dr. Tran Thi B', 'DOCTOR'),
('patient1', '$2a$10$X7UrH5YxX5YxX5YxX5YxX.', 'patient1@email.com', '0123456783', 'Patient A', 'PATIENT'),
('patient2', '$2a$10$X7UrH5YxX5YxX5YxX5YxX.', 'patient2@email.com', '0123456784', 'Patient B', 'PATIENT'),
('staff1', '$2a$10$X7UrH5YxX5YxX5YxX5YxX.', 'staff1@dental.com', '0123456785', 'Staff A', 'STAFF');
GO

-- Thêm doctors
INSERT INTO doctors (user_id, specialization, license_number, experience_years) VALUES
(2, 'Nha khoa tổng quát', 'DR001', 5),
(3, 'Nha khoa thẩm mỹ', 'DR002', 8);
GO

-- Thêm patients
INSERT INTO patients (user_id, date_of_birth, gender, address, medical_history) VALUES
(4, '1990-01-01', 'MALE', '123 Đường ABC, Quận 1, TP.HCM', 'Không có tiền sử bệnh'),
(5, '1995-05-15', 'FEMALE', '456 Đường XYZ, Quận 2, TP.HCM', 'Dị ứng với penicillin');
GO

-- Thêm staff
INSERT INTO staff (user_id, position, department) VALUES
(6, 'Lễ tân', 'Tiếp tân');
GO

-- Thêm appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status, reason, payment_status) VALUES
(1, 1, '2024-03-20 09:00:00', 'CONFIRMED', 'Khám răng định kỳ', 'PAID'),
(2, 2, '2024-03-21 14:30:00', 'PENDING', 'Tẩy trắng răng', 'PENDING');
GO

-- Thêm medical_records
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, treatment_plan, notes) VALUES
(1, 1, 1, 'Răng khỏe mạnh', 'Vệ sinh răng miệng định kỳ', 'Không có vấn đề nghiêm trọng');
GO

-- Thêm prescriptions
INSERT INTO prescriptions (medical_record_id, medicine_name, dosage, frequency, duration, notes) VALUES
(1, 'Kem đánh răng Sensodyne', '1 lần/ngày', 'Sau bữa tối', '3 tháng', 'Đánh răng nhẹ nhàng');
GO

-- Thêm feedback
INSERT INTO feedback (patient_id, doctor_id, appointment_id, rating, comment) VALUES
(1, 1, 1, 5, 'Bác sĩ rất chuyên nghiệp và tận tâm');
GO

-- Thêm chat_sessions
INSERT INTO chat_sessions (patient_id, doctor_id, status) VALUES
(1, 1, 'ACTIVE');
GO

-- Thêm chat_messages
INSERT INTO chat_messages (chat_session_id, sender_id, message) VALUES
(1, 1, 'Xin chào bác sĩ, tôi muốn tư vấn về vấn đề răng miệng');
GO

-- Thêm notifications
INSERT INTO notifications (user_id, title, message, type) VALUES
(4, 'Lịch hẹn mới', 'Bạn có lịch hẹn mới vào ngày 20/03/2024', 'APPOINTMENT');
GO

-- Dữ liệu mẫu cho bảng payments
INSERT INTO payments (appointment_id, amount, payment_method, transaction_id, status, payment_date, notes) VALUES
(1, 500000.00, 'VNPAY', 'VNPAY_20240320_001', 'COMPLETED', '2024-03-20 08:30:00', 'Thanh toán lịch hẹn khám răng định kỳ'),
(2, 2000000.00, 'MOMO', 'MOMO_20240321_001', 'PENDING', NULL, 'Đặt cọc lịch hẹn tẩy trắng răng');
GO

-- Cập nhật dữ liệu mẫu cho bảng appointments
UPDATE appointments 
SET price = 500000.00, payment_id = 1 
WHERE id = 1;

UPDATE appointments 
SET price = 2000000.00, payment_id = 2 
WHERE id = 2;
GO

-- Thêm các stored procedure cho quản lý thanh toán

-- Stored procedure tạo thanh toán mới
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_CreatePayment')
    DROP PROCEDURE sp_CreatePayment
GO

CREATE PROCEDURE sp_CreatePayment
    @appointment_id INT,
    @amount DECIMAL(10,2),
    @payment_method NVARCHAR(50),
    @transaction_id NVARCHAR(100) = NULL,
    @notes NVARCHAR(MAX) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra lịch hẹn tồn tại
        IF NOT EXISTS (SELECT 1 FROM appointments WHERE id = @appointment_id)
        BEGIN
            RAISERROR('Lịch hẹn không tồn tại', 16, 1);
            RETURN;
        END

        -- Tạo thanh toán mới
        INSERT INTO payments (appointment_id, amount, payment_method, transaction_id, status, notes)
        VALUES (@appointment_id, @amount, @payment_method, @transaction_id, 'PENDING', @notes);

        DECLARE @payment_id INT = SCOPE_IDENTITY();

        -- Cập nhật lịch hẹn
        UPDATE appointments 
        SET payment_id = @payment_id,
            price = @amount
        WHERE id = @appointment_id;

        COMMIT TRANSACTION;
        SELECT @payment_id AS payment_id;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Stored procedure cập nhật trạng thái thanh toán
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpdatePaymentStatus')
    DROP PROCEDURE sp_UpdatePaymentStatus
GO

CREATE PROCEDURE sp_UpdatePaymentStatus
    @payment_id INT,
    @status NVARCHAR(20),
    @transaction_id NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra thanh toán tồn tại
        IF NOT EXISTS (SELECT 1 FROM payments WHERE id = @payment_id)
        BEGIN
            RAISERROR('Thanh toán không tồn tại', 16, 1);
            RETURN;
        END

        -- Cập nhật trạng thái thanh toán
        UPDATE payments 
        SET status = @status,
            transaction_id = ISNULL(@transaction_id, transaction_id),
            payment_date = CASE WHEN @status = 'COMPLETED' THEN GETDATE() ELSE payment_date END,
            updated_at = GETDATE()
        WHERE id = @payment_id;

        -- Cập nhật trạng thái thanh toán trong lịch hẹn
        UPDATE appointments 
        SET payment_status = CASE 
            WHEN @status = 'COMPLETED' THEN 'PAID'
            WHEN @status = 'REFUNDED' THEN 'REFUNDED'
            ELSE 'PENDING'
        END
        WHERE payment_id = @payment_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Stored procedure lấy lịch sử thanh toán của bệnh nhân
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetPatientPaymentHistory')
    DROP PROCEDURE sp_GetPatientPaymentHistory
GO

CREATE PROCEDURE sp_GetPatientPaymentHistory
    @patient_id INT
AS
BEGIN
    SELECT 
        p.id AS payment_id,
        p.amount,
        p.payment_method,
        p.transaction_id,
        p.status,
        p.payment_date,
        p.notes,
        a.appointment_date,
        a.reason,
        d.full_name AS doctor_name
    FROM payments p
    INNER JOIN appointments a ON p.appointment_id = a.id
    INNER JOIN doctors d ON a.doctor_id = d.id
    WHERE a.patient_id = @patient_id
    ORDER BY p.payment_date DESC;
END
GO 