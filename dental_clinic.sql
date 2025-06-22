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
        password_hash NVARCHAR(255) NOT NULL,
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