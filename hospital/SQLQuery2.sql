use Doctor;

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    role NVARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);


CREATE TABLE Patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID tự tăng
    id INT NOT NULL UNIQUE,               -- Khóa ngoại liên kết Users (cần tạo FK sau)
    full_name NVARCHAR(255) NOT NULL,             -- Họ tên (mã hóa AES-256)
    phone NVARCHAR(20) NULL,                       -- Số điện thoại (mã hóa AES-256)
    date_of_birth DATE NULL,                       -- Ngày sinh (mã hóa AES-256)
    gender NVARCHAR(10) NULL CHECK (gender IN ('male','female','other')), -- Giới tính
    created_at DATETIME DEFAULT GETDATE() ,        -- Thời gian tạo hồ sơ
	avatar NVARCHAR(MAX)
);

CREATE TABLE Doctors (
    doctor_id BIGINT PRIMARY KEY IDENTITY,
    user_id BIGINT UNIQUE NOT NULL,

    full_name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    address NVARCHAR(MAX) NULL,
    date_of_birth DATE NULL,

    gender NVARCHAR(10) CHECK (gender IN (N'male', N'female', N'other')),
    specialty NVARCHAR(255) NOT NULL,
    license_number NVARCHAR(50) UNIQUE NOT NULL,
     status NVARCHAR(50) DEFAULT N'Đang hoạt động' 
        CHECK (status IN (N'Đang hoạt động', N'Không hoạt động')),
    created_at DATETIME DEFAULT GETDATE(),
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
(N'133', N'doctor2@example.com', N'doctor'),
(N'111', N'admin@example.com', N'admin');

INSERT INTO Patients (id, full_name, phone, date_of_birth, gender)
VALUES 
(1, N'Nguyễn Đỗ Phúc Toàn', N'0123456789', '1990-01-01', N'male');

INSERT INTO Doctors (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number,status)
VALUES 
(2, N'Lê Thị Mèo', N'0987654321', N'123 Nguyễn Trãi, Hà Nội', '1985-05-20', N'female', N'Nội tổng quát', N'VN-123456',N'Đang hoạt động');

INSERT INTO TimeSlot (start_time, end_time)
VALUES 
('08:00', '08:30'),
('08:30', '09:00'),
('09:00', '09:30'),
('09:30', '10:00');

INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id)
VALUES 
(1, '2025-05-30', 1),
(1, '2025-05-30', 2),
(1, '2025-05-31', 1);


INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason)
VALUES 
(1, 1, '2025-06-01', 1, N'Đã đặt', N'Khám tổng quát');
DELETE FROM Users;



