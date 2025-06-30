create database BenhVien;
use BenhVien;

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    role NVARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);


CREATE TABLE Patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID tự tăng
    user_id INT NOT NULL UNIQUE,               -- Khóa ngoại liên kết Users (cần tạo FK sau)
    full_name NVARCHAR(255) NOT NULL,             -- Họ tên (mã hóa AES-256)
    phone NVARCHAR(20) UNIQUE NOT NULL,                       -- Số điện thoại (mã hóa AES-256)
    date_of_birth DATE NOT NULL,                       -- Ngày sinh (mã hóa AES-256)
    gender NVARCHAR(10) NOT NULL CHECK (gender IN ('male','female','other')), -- Giới tính
    created_at DATETIME DEFAULT GETDATE() ,        -- Thời gian tạo hồ sơ
	avatar NVARCHAR(MAX)
);

CREATE TABLE Doctors (
    doctor_id BIGINT PRIMARY KEY IDENTITY,
    user_id BIGINT UNIQUE NOT NULL,

    full_name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20) UNIQUE NOT NULL,
    address NVARCHAR(MAX) NULL,
    date_of_birth DATE NULL,

    gender NVARCHAR(10) CHECK (gender IN (N'male', N'female', N'other')),
    specialty NVARCHAR(255) NOT NULL,
    license_number NVARCHAR(50) UNIQUE NOT NULL,
    
    
    created_at DATETIME DEFAULT GETDATE(),
	status NVARCHAR(100),
	avatar NVARCHAR(MAX) -- Thêm dòng này để lưu ảnh đại diện

);


CREATE TABLE TimeSlot (
    slot_id INT PRIMARY KEY IDENTITY,
    start_time TIME,
    end_time TIME
);

CREATE TABLE DoctorSchedule (
    schedule_id INT PRIMARY KEY IDENTITY,
    doctor_id BIGINT FOREIGN KEY REFERENCES Doctors(doctor_id),
    work_date DATE,
    slot_id INT FOREIGN KEY REFERENCES timeSlot(slot_id)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY IDENTITY,
    patient_id INT FOREIGN KEY REFERENCES Patients(patient_id),
    doctor_id BIGINT FOREIGN KEY REFERENCES Doctors(doctor_id),
    work_date DATE,
    slot_id INT FOREIGN KEY REFERENCES TimeSlot(slot_id),
    status NVARCHAR(50) DEFAULT N'Đã đặt', -- 'Đã đặt', 'Hoàn tất', 'Đã hủy'
    reason NVARCHAR(MAX)
);

INSERT INTO Users (password_hash, email, role)
VALUES 
(N'123', N'patient@example.com', N'patient'),
(N'113', N'doctor1@example.com', N'doctor'),
(N'111', N'admin@example.com', N'admin');

select*from DoctorSchedule;

INSERT INTO Users (password_hash, email, role)
VALUES (
	N'123',
	N'bacsi@123',
	N'DOCTOR'

);

-- Thêm dữ liệu vào TimeSlot
INSERT INTO TimeSlot (start_time, end_time) VALUES
('08:00:00', '09:00:00'),
('09:00:00', '10:00:00'),
('10:00:00', '11:00:00'),
('13:00:00', '14:00:00'),
('14:00:00', '15:00:00'),
('15:00:00', '16:00:00'),
('16:00:00', '17:00:00');

-- Giả sử bạn có doctor_id = 1, 2 trong bảng Doctors
-- Thêm dữ liệu vào DoctorSchedule
INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id) VALUES
(5, '2025-06-09', 2),
(5, '2025-06-10', 1),
(7, '2025-06-09', 3);



INSERT INTO Doctors (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number, status) VALUES 
(1, 'Tran Gia Vy', '0357726072', '12 Nguyễn Văn Cừ, Quận 1, TP.HCM', '2009-07-12', 'male', 'Nội tổng quát', 'VY123', 'Active'),
(2, 'Chau Le', '0654746072', '12 Nguyễn Văn Linh, Quận Gò Vấp, TP.HCM', '2000-03-05', 'female', 'Răng sâu', 'Chau453', 'Active'),
(3, 'Minh Tran', '0987654321', '45 Lê Duẩn, Quận 1, TP.HCM', '1998-07-22', 'male', 'Niềng răng', 'Minh998', 'Inactive');


