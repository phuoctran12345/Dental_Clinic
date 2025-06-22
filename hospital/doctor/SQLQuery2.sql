-- Sử dụng cơ sở dữ liệu Doctor
USE Doctor;

-- ===============================
-- 1. USERS
-- ===============================
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    role NVARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- ===============================
-- 2. PATIENTS
-- ===============================
CREATE TABLE Patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    full_name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20) NULL,
    date_of_birth DATE NULL,
    gender NVARCHAR(10) NULL CHECK (gender IN (N'male', N'female', N'other')),
    created_at DATETIME DEFAULT GETDATE(),
    avatar NVARCHAR(MAX)
);

-- ===============================
-- 3. DOCTORS
-- ===============================
CREATE TABLE Doctors (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,

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
    avatar NVARCHAR(MAX)
);

-- ===============================
-- 4. TIME SLOT
-- ===============================
CREATE TABLE TimeSlot (
    slot_id INT IDENTITY(1,1) PRIMARY KEY,
    start_time TIME,
    end_time TIME
);

-- ===============================
-- 5. DOCTOR SCHEDULE
-- ===============================
CREATE TABLE DoctorSchedule (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY,
    doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id),
    work_date DATE,
    slot_id INT FOREIGN KEY REFERENCES TimeSlot(slot_id)
);

-- ===============================
-- 6. APPOINTMENT
-- ===============================
CREATE TABLE Appointment (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT FOREIGN KEY REFERENCES Patients(patient_id),
    doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id),
    work_date DATE,
    slot_id INT FOREIGN KEY REFERENCES TimeSlot(slot_id),
    status NVARCHAR(50) DEFAULT N'Đã đặt',
    reason NVARCHAR(MAX),
    previous_appointment_id INT NULL,
    FOREIGN KEY (previous_appointment_id) REFERENCES Appointment(appointment_id)
);

-- ===============================
-- 7. MEDICAL REPORT
-- ===============================
CREATE TABLE MedicalReport (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id INT NOT NULL FOREIGN KEY REFERENCES Appointment(appointment_id),
    doctor_id INT NOT NULL FOREIGN KEY REFERENCES Doctors(doctor_id),
    patient_id INT NOT NULL FOREIGN KEY REFERENCES Patients(patient_id),
    diagnosis NVARCHAR(500),
    treatment_plan NVARCHAR(1000),
    note NVARCHAR(1000),
    created_at DATETIME DEFAULT GETDATE(),
    sign NVARCHAR(MAX)
);

-- ===============================
-- 8. MEDICINE
-- ===============================
CREATE TABLE Medicine (
    medicine_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    unit NVARCHAR(50),
    quantity_in_stock INT NOT NULL,
    description NVARCHAR(1000)
);

-- ===============================
-- 9. PRESCRIPTION
-- ===============================
CREATE TABLE Prescription (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL FOREIGN KEY REFERENCES MedicalReport(report_id),
    medicine_id INT NOT NULL FOREIGN KEY REFERENCES Medicine(medicine_id),
    quantity INT NOT NULL,
    usage NVARCHAR(500)
);

-- ===============================
-- 10. FOREIGN KEY: Liên kết Users
-- ===============================
ALTER TABLE Patients
ADD CONSTRAINT FK_Patients_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Doctors
ADD CONSTRAINT FK_Doctors_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

-- ===============================
-- DỮ LIỆU MẪU
-- ===============================
-- 1. Users
INSERT INTO Users (password_hash, email, role) VALUES
(N'123', N'patient@example.com', N'patient'),   -- ID = 1
(N'999', N'choheo.soss@gmail.com', N'doctor'),  -- ID = 2
(N'113', N'doctor1@example.com', N'doctor'),    -- ID = 3
(N'133', N'doctor2@example.com', N'doctor'),    -- ID = 4
(N'111', N'admin@example.com', N'admin');       -- ID = 5

-- 2. Patients
INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender) VALUES
(1, N'Nguyễn Đỗ Phúc Toàn', N'0123456789', '1990-01-01', N'male');

-- 3. Doctors
INSERT INTO Doctors (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number, status) VALUES
(2, N'Lê Thị Mèo', N'0987654321', N'123 Nguyễn Trãi, Hà Nội', '1985-05-20', N'female', N'Nội tổng quát', N'VN-123456', N'Đang hoạt động'),
(3, N'Phúc Toàn', N'0123456789', N'123 Nguyễn Nghiêm, Đà Nẵng', '1985-05-20', N'male', N'Nhi Khoa', N'VN-654321', N'Đang hoạt động');

-- 4. TimeSlot
INSERT INTO TimeSlot (start_time, end_time) VALUES
('08:00', '08:30'),
('08:30', '09:00'),
('09:00', '09:30'),
('09:30', '10:00');

-- 5. DoctorSchedule
INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id) VALUES
(1, '2025-05-30', 1),
(1, '2025-05-30', 2),
(1, '2025-05-31', 1);

-- 6. Appointment
INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, previous_appointment_id) VALUES
(1, 1, '2025-06-20', 1, N'Đã hủy', N'Khám tổng quát6', NULL),
(1, 1, '2025-06-21', 1, N'Đã hủy', N'Khám tổng quát7', NULL),
(1, 1, '2025-06-22', 1, N'Đã hủy', N'Khám tổng quát8', NULL),
(1, 1, '2025-06-23', 1, N'Đã hủy', N'Khám tổng quát9', NULL),
(1, 1, '2025-06-22', 1, N'Đã đặt', N'Khám tổng quát1', NULL),
(1, 1, '2025-06-22', 1, N'Đã đặt', N'Khám tổng quát2', NULL),
(1, 1, '2025-06-22', 1, N'Đã đặt', N'Khám tổng quát3', NULL),
(1, 1, '2025-06-22', 1, N'Đã đặt', N'Khám tổng quát4', NULL),
(1, 1, '2025-06-22', 1, N'Đã đặt', N'Khám tổng quát5', NULL),
(1, 2, '2025-07-02', 1, N'Hoàn tất', N'Khám tim', NULL),
(1, 2, '2025-07-15', 1, N'Đã đặt', N'Tái khám tim', 2);

-- 7. Medicine
INSERT INTO Medicine (name, unit, quantity_in_stock, description) VALUES
(N'Paracetamol', N'viên', 500, N'Giảm đau, hạ sốt'),
(N'Amoxicillin', N'viên', 300, N'Kháng sinh điều trị nhiễm khuẩn'),
(N'Saline 0.9%', N'chai', 200, N'Dung dịch truyền, rửa vết thương'),
(N'Loperamide', N'viên', 150, N'Chống tiêu chảy'),
(N'Vitamin C', N'viên', 400, N'Tăng sức đề kháng, phòng cảm cúm');
