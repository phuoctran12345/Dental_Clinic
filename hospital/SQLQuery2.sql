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
    doctor_id INT PRIMARY KEY IDENTITY,
    user_id INT UNIQUE NOT NULL,

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
    doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id),
    work_date DATE,
    slot_id INT FOREIGN KEY REFERENCES timeSlot(slot_id)
);
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY IDENTITY,
    patient_id INT FOREIGN KEY REFERENCES Patients(patient_id),
    doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id),
    work_date DATE,
    slot_id INT FOREIGN KEY REFERENCES TimeSlot(slot_id),
    status NVARCHAR(50) DEFAULT N'Đã đặt', -- 'Đã đặt', 'Hoàn tất', 'Đã hủy'
    reason NVARCHAR(MAX)
);
CREATE TABLE MedicalReport (
    report_id INT IDENTITY PRIMARY KEY,
    appointment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    diagnosis NVARCHAR(500),
    treatment_plan NVARCHAR(1000),
    note NVARCHAR(1000),
    created_at DATETIME DEFAULT GETDATE(),
	sign NVARCHAR(MAX),

    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);


CREATE TABLE Medicine (
    medicine_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    unit NVARCHAR(50),
    quantity_in_stock INT NOT NULL,
    description NVARCHAR(1000)
);



CREATE TABLE Prescription (
    prescription_id INT IDENTITY PRIMARY KEY,
    report_id INT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    usage NVARCHAR(500),

    FOREIGN KEY (report_id) REFERENCES MedicalReport(report_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id)
);
INSERT INTO Users (password_hash, email, role)
VALUES 
(N'999', N'choheo.soss@gmail.com', N'doctor'),
(N'123', N'patient@example.com', N'patient'),
(N'113', N'doctor1@example.com', N'doctor'),
(N'133', N'doctor2@example.com', N'doctor'),
(N'111', N'admin@example.com', N'admin');

INSERT INTO Patients (id, full_name, phone, date_of_birth, gender)
VALUES 
(1, N'Nguyễn Đỗ Phúc Toàn', N'0123456789', '1990-01-01', N'male');

INSERT INTO Doctors (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number,status)
VALUES 
(2, N'Lê Thị Mèo', N'0987654321', N'123 Nguyễn Trãi, Hà Nội', '1985-05-20', N'female', N'Nội tổng quát', N'VN-123456',N'Đang hoạt động'), 
(3, N'Phúc Toàn', N'0123456789', N'123 Nguyễn Nghiêm, Đà Nẵng', '1985-05-20', N'male', N'Nhi Khoa', N'VN-1234567',N'Đang hoạt động');

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

INSERT INTO Medicine (name, unit, quantity_in_stock, description) VALUES
(N'Paracetamol', N'viên', 500, N'Giảm đau, hạ sốt'),
(N'Amoxicillin', N'viên', 300, N'Kháng sinh điều trị nhiễm khuẩn'),
(N'Saline 0.9%', N'chai', 200, N'Dung dịch truyền, rửa vết thương'),
(N'Loperamide', N'viên', 150, N'Chống tiêu chảy'),
(N'Vitamin C', N'viên', 400, N'Tăng sức đề kháng, phòng cảm cúm');


