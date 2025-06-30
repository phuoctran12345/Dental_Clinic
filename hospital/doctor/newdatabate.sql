
use BenhVien;


GO

-- 1. Tạo bảng users (không phụ thuộc)
CREATE TABLE [dbo].[users](
    [user_id] [int] IDENTITY(1,1) NOT NULL,

    [password_hash] [nvarchar](255) NOT NULL,
    [email] [nvarchar](100) NOT NULL,
    [role] [nvarchar](20) NOT NULL,
    [created_at] [datetime] NULL,
    
    PRIMARY KEY CLUSTERED ([user_id] ASC),
    UNIQUE NONCLUSTERED ([email] ASC),
    
    CONSTRAINT [CHK_Role] CHECK ([role] IN ('MANAGER', 'DOCTOR', 'PATIENT', 'STAFF'))
);
ALTER TABLE [dbo].[users] ADD DEFAULT (GETDATE()) FOR [created_at];
GO

-- 2. Tạo bảng TimeSlot (không phụ thuộc)
CREATE TABLE [dbo].[TimeSlot](
    [slot_id] [int] IDENTITY(1,1) NOT NULL,
    [start_time] [time](7) NULL,
    [end_time] [time](7) NULL,
    PRIMARY KEY CLUSTERED ([slot_id] ASC)
);
GO

-- 3. Tạo bảng Doctors (phụ thuộc users)
CREATE TABLE [dbo].[Doctors](
    [doctor_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL, -- Đồng bộ kiểu dữ liệu với users.user_id
    [full_name] [nvarchar](255) NOT NULL,
    [phone] [nvarchar](20) NOT NULL,
    [address] [nvarchar](max) NULL,
    [date_of_birth] [date] NULL,
    [gender] [nvarchar](10) NULL,
    [specialty] [nvarchar](255) NOT NULL,
    [license_number] [nvarchar](50) NOT NULL,
    [created_at] [datetime] NULL,
    [status] [nvarchar](50) NOT NULL,
    [avatar] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([doctor_id] ASC),
    UNIQUE NONCLUSTERED ([user_id] ASC),
    UNIQUE NONCLUSTERED ([license_number] ASC),
    CONSTRAINT [FK_Doctors_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]),
    CONSTRAINT [CHK_Gender_Doctors] CHECK ([gender] IN ('male', 'female', 'other'))
);
ALTER TABLE [dbo].[Doctors] ADD DEFAULT (GETDATE()) FOR [created_at];
ALTER TABLE [dbo].[Doctors] ADD DEFAULT ('active') FOR [status];
GO

-- 4. Tạo bảng Patients (phụ thuộc users)
CREATE TABLE [dbo].[Patients](
    [patient_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL, -- Đồng bộ kiểu dữ liệu
    [full_name] [nvarchar](255) NOT NULL,
    [phone] [nvarchar](20) NULL,
    [date_of_birth] [date] NULL,
    [gender] [nvarchar](10) NULL,
    [created_at] [datetime] NULL,
    [avatar] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([patient_id] ASC),
    UNIQUE NONCLUSTERED ([user_id] ASC),
    CONSTRAINT [FK_Patients_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]),
    CONSTRAINT [CHK_Gender_Patients] CHECK ([gender] IN ('male', 'female', 'other'))
);
ALTER TABLE [dbo].[Patients] ADD DEFAULT (GETDATE()) FOR [created_at];
GO

-- 5. Tạo bảng Staff (phụ thuộc users)
CREATE TABLE [dbo].[Staff](
    [staff_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL, -- Đồng bộ kiểu dữ liệu
    [full_name] [nvarchar](255) NOT NULL,
    [phone] [nvarchar](20) NOT NULL,
    [address] [nvarchar](max) NULL,
    [date_of_birth] [date] NULL,
    [gender] [nvarchar](10) NULL,
    [position] [nvarchar](100) NOT NULL,
	[avatar] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([staff_id] ASC),
    UNIQUE NONCLUSTERED ([user_id] ASC),
    CONSTRAINT [FK_Staff_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]),
    CONSTRAINT [CHK_Gender_Staff] CHECK ([gender] IN ('male', 'female', 'other'))
);
GO

-- 6. Tạo bảng Services (không phụ thuộc)
CREATE TABLE [dbo].[Services](
    [service_id] [int] IDENTITY(1,1) NOT NULL,
    [service_name] [nvarchar](255) NOT NULL,
    [description] [nvarchar](max) NULL,
    [price] [float] NOT NULL,
    [status] [nvarchar](50) NOT NULL,
    [category] [nvarchar](100) NULL,
    [image] [nvarchar](max) NULL,
	[updated_at]   DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [created_by]   NVARCHAR (100)  NULL,
    PRIMARY KEY CLUSTERED ([service_id] ASC),
    CONSTRAINT [CHK_Price] CHECK ([price] >= 0),
    CONSTRAINT [CHK_Status] CHECK ([status] IN ('active', 'inactive', 'suspended'))
);
ALTER TABLE [dbo].[Services] ADD DEFAULT ('active') FOR [status];
GO

-- 7. Tạo bảng DoctorSchedule (phụ thuộc Doctors, TimeSlot)
CREATE TABLE [dbo].[DoctorSchedule](
    [schedule_id] [int] IDENTITY(1,1) NOT NULL,
    [doctor_id] [int] NULL,
    [work_date] [date] NULL,
    [slot_id] [int] NULL,
    [status] [nvarchar](50) NULL DEFAULT (N'pending'),
    PRIMARY KEY CLUSTERED ([schedule_id] ASC),
    CONSTRAINT [FK_DoctorSchedule_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_DoctorSchedule_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot]([slot_id]),
	CONSTRAINT [CHK_DoctorSchedule_Status] CHECK ([status] IN (
            'pending',      -- Chờ phê duyệt từ manager
            'approved',     -- Đã được duyệt, có thể hiển thị cho bệnh nhân
            'rejected'     -- Bị từ chối bởi manager
        ))
);
GO

-- 8. Tạo bảng Appointment (phụ thuộc Doctors, Patients, TimeSlot)
CREATE TABLE [dbo].[Appointment](
    [appointment_id] [int] IDENTITY(1,1) NOT NULL,
    [patient_id] [int] NULL,
    [doctor_id] [int] NULL,
    [work_date] [date] NULL,
    [slot_id] [int] NULL,
    [status] [nvarchar](50) DEFAULT (N'booked') NULL,
    [reason] [nvarchar](max) NULL,
    previous_appointment_id INT NULL,
	booked_by_user_id int null,

    PRIMARY KEY CLUSTERED ([appointment_id] ASC),
    CONSTRAINT [FK_Appointment_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_Appointment_Patients] FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients]([patient_id]),
    CONSTRAINT [FK_Appointment_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot]([slot_id]),
	 CONSTRAINT [CHK_Appointment_Status]
        CHECK ([status] IN (
            'booked',        -- Đã đặt lịch (mặc định)       
            'completed',     -- Đã khám xong
            'cancelled',     -- Hủy bởi bệnh nhân hoặc bác sĩ
            'no-show'        -- Bệnh nhân không đến
        ))
);
GO
--9
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
-- 10. MEDICINE
-- ===============================
CREATE TABLE Medicine (
    medicine_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    unit NVARCHAR(50),
    quantity_in_stock INT NOT NULL,
    description NVARCHAR(1000)
);

-- ===============================
-- 11. PRESCRIPTION
-- ===============================
CREATE TABLE Prescription (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL FOREIGN KEY REFERENCES MedicalReport(report_id),
    medicine_id INT NOT NULL FOREIGN KEY REFERENCES Medicine(medicine_id),
    quantity INT NOT NULL,
    usage NVARCHAR(500)
);


-- Thêm dữ liệu mẫu
BEGIN TRY
    -- 1. Users
   INSERT INTO Users (password_hash, email, role) VALUES
(N'123', N'patient@example.com', N'patient'),   -- ID = 1
(N'999', N'choheo.soss@gmail.com', N'doctor'),  -- ID = 2
(N'113', N'doctor1@example.com', N'doctor'),    -- ID = 3
(N'133', N'staff@example.com', N'staff'),       -- ID = 4
(N'111', N'admin@example.com', N'MANAGER');       -- ID = 5
    

    -- 2. TimeSlot
    INSERT INTO [dbo].[TimeSlot] (start_time, end_time) VALUES
    ('07:00:00', '12:00:00'),
    ('13:00:00', '18:00:00'),
    ('19:00:00', '21:00:00');
    

    -- 3. Doctors
    INSERT INTO [dbo].[Doctors] (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number, status) VALUES
    (2, N'BS. Nguyễn Văn An', '0901234567', N'123 Đường Nguyễn Trãi, Q1, HCM', '1980-01-15', 'male', N'Nha khoa tổng quát', 'NK001', 'active'),
    (3, N'BS. Trần Thị Bích', '0912345678', N'456 Đường Lê Văn Sỹ, Q3, HCM', '1985-05-20', 'female', N'Chỉnh nha - Niềng răng', 'NK002', 'active');
    
  

    -- 4. Patients
    INSERT INTO [dbo].[Patients] (user_id, full_name, phone, date_of_birth, gender) VALUES
    (1, N'Nguyễn Thị Mai', '0934567890', '1990-03-25', 'female');
  
   

    -- 5. Services
    INSERT INTO [dbo].[Services] (service_name, description, price, status, category) VALUES
    (N'Khám tổng quát', N'Khám răng tổng quát, tư vấn chăm sóc răng miệng', 100000, 'active', N'Khám cơ bản'),
    (N'Lấy cao răng', N'Vệ sinh răng miệng, lấy cao răng, đánh bóng răng', 200000, 'active', N'Vệ sinh răng'),
    (N'Trám răng sâu', N'Điều trị và trám răng bị sâu với vật liệu composite', 300000, 'active', N'Điều trị'),
    (N'Nhổ răng khôn', N'Phẫu thuật nhổ răng khôn an toàn', 800000, 'active', N'Phẫu thuật'),
    (N'Niềng răng kim loại', N'Chỉnh nha với mắc cài kim loại truyền thống', 15000000, 'active', N'Chỉnh nha'),
    (N'Niềng răng invisalign', N'Chỉnh nha trong suốt hiện đại', 45000000, 'active', N'Chỉnh nha'),
    (N'Tư vấn niềng răng', N'Khám và tư vấn phương pháp chỉnh nha phù hợp', 150000, 'active', N'Tư vấn');
   

    -- 6. DoctorSchedule
    INSERT INTO [dbo].[DoctorSchedule] (doctor_id, work_date, slot_id, status) VALUES
    (2, '2025-12-20', 1, 'rejected'),
    (2, '2025-12-21', 2, 'rejected'),
    (1, '2025-12-22', 1, 'rejected'),
    (1, '2025-12-23', 2, 'rejected'),
    (1, '2025-12-24', 1, 'rejected'),
    (1, '2025-12-20', 2, 'approved'),
    (1, '2025-12-21', 1, 'approved'),
    (2, '2025-12-22', 3, 'approved'),
    (2, '2025-12-25', 2, 'approved'),
    (2, '2025-12-26', 1, 'approved'),
    (2, '2025-12-23', 1, 'pending'),
    (2, '2025-12-24', 2, 'pending'),
    (1, '2025-12-25', 1, 'pending'),
    (1, '2025-12-27', 2, 'pending'),
    (1, '2025-12-28', 1, 'pending');
   

    -- 7. Appointment
    INSERT INTO [dbo].[Appointment] (patient_id, doctor_id, work_date, slot_id, status, reason,previous_appointment_id) VALUES
    (1, 1, '2025-12-20', 2, N'booked', N'Khám tổng quát - Lấy cao răng',1),
    (1, 2, '2025-12-21', 1, N'booked', N'Tư vấn niềng răng cho con',1),
    (1, 1, '2025-12-24', 1, N'booked', N'Trám răng sâu',1),
    (1, 2, '2025-12-25', 2, N'booked', N'Tái khám niềng răng',1);
  



	INSERT INTO Medicine (name, unit, quantity_in_stock, description) VALUES
(N'Paracetamol', N'viên', 500, N'Giảm đau, hạ sốt'),
(N'Amoxicillin', N'viên', 300, N'Kháng sinh điều trị nhiễm khuẩn'),
(N'Saline 0.9%', N'chai', 200, N'Dung dịch truyền, rửa vết thương'),
(N'Loperamide', N'viên', 150, N'Chống tiêu chảy'),
(N'Vitamin C', N'viên', 400, N'Tăng sức đề kháng, phòng cảm cúm');





