use Doctor;

CREATE TABLE Doctors (
    doctor_id BIGINT PRIMARY KEY IDENTITY,                 -- ID tự tăng
    user_id BIGINT UNIQUE NOT NULL,                        -- Liên kết với bảng Users (foreign key)
    
    full_name NVARCHAR(255) NOT NULL,                      -- Họ tên (không mã hóa, cần hiển thị)
    phone NVARCHAR(20) NOT NULL,                           -- Số điện thoại (công khai)
    address NVARCHAR(MAX) NULL,                            -- Địa chỉ (nếu cần mã hóa thì xử lý trong app)
    date_of_birth DATE NULL,                               -- Ngày sinh (tùy hiển thị tuổi)
    
    gender NVARCHAR(10) CHECK (gender IN (N'male', N'female', N'other')),  -- Giới tính
    specialty NVARCHAR(255) NOT NULL,                      -- Chuyên môn (VD: chỉnh nha, phục hình…)
    license_number NVARCHAR(50) UNIQUE NOT NULL,           -- Số giấy phép hành nghề

    created_at DATETIME DEFAULT GETDATE()                  -- Thờ	i gian tạo
);

INSERT INTO Doctors (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number)
VALUES (1,
        N'Nguyen Do Phuc Toan',
        '0123456789', 
        N'123 Đường ABC, Quận 1, TP.HCM', 
        '1985-06-15',
		N'male',
        N'Nội tim mạch', 
        'BACSITOAN001');



		select*from Doctors;

CREATE TABLE Patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID tự tăng
    id INT NOT NULL UNIQUE,               -- Khóa ngoại liên kết Users (cần tạo FK sau)
    full_name NVARCHAR(255) NOT NULL,             -- Họ tên (mã hóa AES-256)
    phone NVARCHAR(20) NULL,                       -- Số điện thoại (mã hóa AES-256)
    date_of_birth DATE NULL,                       -- Ngày sinh (mã hóa AES-256)
    gender NVARCHAR(10) NULL CHECK (gender IN ('male','female','other')), -- Giới tính
    created_at DATETIME DEFAULT GETDATE()         -- Thời gian tạo hồ sơ
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
INSERT INTO Patients (id, full_name, phone, date_of_birth, gender)
VALUES 
(2, N'Trần Thị Mai', '0987654321', '1990-03-12', 'female'),
(3, N'Lê Văn An', '0912345678', '1982-11-08', 'male'),
(4, N'Phạm Hồng Minh', '0909988776', '1995-05-22', 'other');


INSERT INTO TimeSlot (start_time, end_time)
VALUES 
('08:00', '08:30'),
('08:30', '09:00'),
('09:00', '09:30'),
('09:30', '10:00'),
('10:00', '10:30');

INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id)
VALUES 
(1, '2025-05-01', 1),
(1, '2025-05-01', 2),
(1, '2025-05-01', 3);

INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason)
VALUES 
(2, 1, '2025-06-01', 1, N'Đã đặt', N'Khám định kỳ'),
(3, 1, '2025-06-01', 2, N'Đã đặt', N'Đau ngực'),
(4, 1, '2025-06-01', 3, N'Đã đặt', N'Tái khám sau điều trị');

SELECT * FROM Appointment;