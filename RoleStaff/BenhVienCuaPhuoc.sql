create database BenhVienCuaPhuoc;
use BenhVienCuaPhuoc;


GO

-- 1. Tạo bảng users (không phụ thuộc)
CREATE TABLE [dbo].[users](
    [user_id] [int] IDENTITY(1,1) NOT NULL,
    [username] [nvarchar](50) NOT NULL,
    [password_hash] [nvarchar](255) NOT NULL,
    [email] [nvarchar](100) NOT NULL,
    [role] [nvarchar](20) NOT NULL,
    [created_at] [datetime] NULL,
    [avatar] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([user_id] ASC),
    UNIQUE NONCLUSTERED ([email] ASC),
    UNIQUE NONCLUSTERED ([username] ASC),
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
    [doctor_id] [bigint] IDENTITY(1,1) NOT NULL,
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
    [staff_id] [bigint] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL, -- Đồng bộ kiểu dữ liệu
    [full_name] [nvarchar](255) NOT NULL,
    [phone] [nvarchar](20) NOT NULL,
    [address] [nvarchar](max) NULL,
    [date_of_birth] [date] NULL,
    [gender] [nvarchar](10) NULL,
    [position] [nvarchar](100) NOT NULL,
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
    PRIMARY KEY CLUSTERED ([service_id] ASC),
    CONSTRAINT [CHK_Price] CHECK ([price] >= 0),
    CONSTRAINT [CHK_Status] CHECK ([status] IN ('active', 'inactive', 'suspended'))
);
ALTER TABLE [dbo].[Services] ADD DEFAULT ('active') FOR [status];
GO

-- 7. Tạo bảng DoctorSchedule (phụ thuộc Doctors, TimeSlot)
CREATE TABLE [dbo].[DoctorSchedule](
    [schedule_id] [int] IDENTITY(1,1) NOT NULL,
    [doctor_id] [bigint] NULL,
    [work_date] [date] NULL,
    [slot_id] [int] NULL,
    [status] [nvarchar](50) NULL,
    PRIMARY KEY CLUSTERED ([schedule_id] ASC),
    CONSTRAINT [FK_DoctorSchedule_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_DoctorSchedule_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot]([slot_id])
);
GO

-- 8. Tạo bảng Appointment (phụ thuộc Doctors, Patients, TimeSlot)
CREATE TABLE [dbo].[Appointment](
    [appointment_id] [int] IDENTITY(1,1) NOT NULL,
    [patient_id] [int] NULL,
    [doctor_id] [bigint] NULL,
    [work_date] [date] NULL,
    [slot_id] [int] NULL,
    [status] [nvarchar](50) DEFAULT (N'Đã đặt') NULL,
    [reason] [nvarchar](max) NULL,
    [doctor_name] [nvarchar](50) NULL,
    [start_time] [time](7) NULL,
    [end_time] [time](7) NULL,
    PRIMARY KEY CLUSTERED ([appointment_id] ASC),
    CONSTRAINT [FK_Appointment_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_Appointment_Patients] FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients]([patient_id]),
    CONSTRAINT [FK_Appointment_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot]([slot_id])
);
GO

-- Thêm dữ liệu mẫu
BEGIN TRY
    -- 1. Users
    INSERT INTO [dbo].[users] (username, password_hash, email, role) VALUES
    ('dentist1', '123456', 'dentist1@nhakhoa.vn', 'DOCTOR'),
    ('dentist2', '123456', 'dentist2@nhakhoa.vn', 'DOCTOR'),
    ('dentist3', '123456', 'dentist3@nhakhoa.vn', 'DOCTOR'),
    ('patient1', '123456', 'patient1@email.vn', 'PATIENT'),
    ('patient2', '123456', 'patient2@email.vn', 'PATIENT');
    PRINT N'Thêm 5 người dùng thành công.';

    -- 2. TimeSlot
    INSERT INTO [dbo].[TimeSlot] (start_time, end_time) VALUES
    ('08:00:00', '12:00:00'),
    ('14:00:00', '18:00:00'),
    ('19:00:00', '21:00:00');
    PRINT N'Thêm 3 ca làm việc thành công.';

    -- 3. Doctors
    INSERT INTO [dbo].[Doctors] (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number, status) VALUES
    (1, N'BS. Nguyễn Văn An', '0901234567', N'123 Đường Nguyễn Trãi, Q1, HCM', '1980-01-15', 'male', N'Nha khoa tổng quát', 'NK001', 'active'),
    (2, N'BS. Trần Thị Bích', '0912345678', N'456 Đường Lê Văn Sỹ, Q3, HCM', '1985-05-20', 'female', N'Chỉnh nha - Niềng răng', 'NK002', 'active'),
    (3, N'BS. Lê Minh Cường', '0923456789', N'789 Đường Võ Văn Tần, Q3, HCM', '1978-12-10', 'male', N'Phẫu thuật hàm mặt', 'NK003', 'active');
    PRINT N'Thêm 3 bác sĩ thành công.';

    -- 4. Patients
    INSERT INTO [dbo].[Patients] (user_id, full_name, phone, date_of_birth, gender) VALUES
    (4, N'Nguyễn Thị Mai', '0934567890', '1990-03-25', 'female'),
    (5, N'Phạm Văn Hùng', '0945678901', '1988-07-08', 'male');
    PRINT N'Thêm 2 bệnh nhân thành công.';

    -- 5. Services
    INSERT INTO [dbo].[Services] (service_name, description, price, status, category) VALUES
    (N'Khám tổng quát', N'Khám răng tổng quát, tư vấn chăm sóc răng miệng', 100000, 'active', N'Khám cơ bản'),
    (N'Lấy cao răng', N'Vệ sinh răng miệng, lấy cao răng, đánh bóng răng', 200000, 'active', N'Vệ sinh răng'),
    (N'Trám răng sâu', N'Điều trị và trám răng bị sâu với vật liệu composite', 300000, 'active', N'Điều trị'),
    (N'Nhổ răng khôn', N'Phẫu thuật nhổ răng khôn an toàn', 800000, 'active', N'Phẫu thuật'),
    (N'Niềng răng kim loại', N'Chỉnh nha với mắc cài kim loại truyền thống', 15000000, 'active', N'Chỉnh nha'),
    (N'Niềng răng invisalign', N'Chỉnh nha trong suốt hiện đại', 45000000, 'active', N'Chỉnh nha'),
    (N'Tư vấn niềng răng', N'Khám và tư vấn phương pháp chỉnh nha phù hợp', 150000, 'active', N'Tư vấn');
    PRINT N'Thêm 7 dịch vụ thành công.';

    -- 6. DoctorSchedule
    INSERT INTO [dbo].[DoctorSchedule] (doctor_id, work_date, slot_id, status) VALUES
    (1, '2025-12-20', 1, 'approved'),
    (1, '2025-12-21', 2, 'approved'),
    (1, '2025-12-22', 1, 'approved'),
    (1, '2025-12-23', 2, 'approved'),
    (1, '2025-12-24', 1, 'approved'),
    (2, '2025-12-20', 2, 'approved'),
    (2, '2025-12-21', 1, 'approved'),
    (2, '2025-12-22', 3, 'approved'),
    (2, '2025-12-25', 2, 'approved'),
    (2, '2025-12-26', 1, 'approved'),
    (3, '2025-12-23', 1, 'approved'),
    (3, '2025-12-24', 2, 'approved'),
    (3, '2025-12-25', 1, 'approved'),
    (3, '2025-12-27', 2, 'approved'),
    (3, '2025-12-28', 1, 'approved');
    PRINT N'Thêm 15 lịch làm việc thành công.';

    -- 7. Appointment
    INSERT INTO [dbo].[Appointment] (patient_id, doctor_id, work_date, slot_id, status, reason, doctor_name, start_time, end_time) VALUES
    (1, 1, '2025-12-20', 1, N'Đã đặt', N'Khám tổng quát - Lấy cao răng', N'BS. Nguyễn Văn An', '08:00:00', '12:00:00'),
    (2, 2, '2025-12-21', 1, N'Đã đặt', N'Tư vấn niềng răng cho con', N'BS. Trần Thị Bích', '08:00:00', '12:00:00'),
    (1, 3, '2025-12-23', 1, N'Đã đặt', N'Nhổ răng khôn', N'BS. Lê Minh Cường', '08:00:00', '12:00:00'),
    (2, 1, '2025-12-24', 1, N'Đã đặt', N'Trám răng sâu', N'BS. Nguyễn Văn An', '08:00:00', '12:00:00'),
    (1, 2, '2025-12-25', 2, N'Đã đặt', N'Tái khám niềng răng', N'BS. Trần Thị Bích', '14:00:00', '18:00:00');
    PRINT N'Thêm 5 cuộc hẹn thành công.';
END TRY
BEGIN CATCH
    PRINT N'Lỗi khi thêm dữ liệu: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO

-- Kiểm tra dữ liệu
SELECT 'users' AS TableName, COUNT(*) AS RowCount FROM [dbo].[users]
UNION ALL
SELECT 'TimeSlot', COUNT(*) FROM [dbo].[TimeSlot]
UNION ALL
SELECT 'Doctors', COUNT(*) FROM [dbo].[Doctors]
UNION ALL
SELECT 'Patients', COUNT(*) FROM [dbo].[Patients]
UNION ALL
SELECT 'Services', COUNT(*) FROM [dbo].[Services]
UNION ALL
SELECT 'DoctorSchedule', COUNT(*) FROM [dbo].[DoctorSchedule]
UNION ALL
SELECT 'Appointment', COUNT(*) FROM [dbo].[Appointment];
GO

-- Thông báo thành công
PRINT N'Dữ liệu mẫu phòng khám nha khoa đã được thêm thành công!';
PRINT N'Bao gồm:';
PRINT N'- 5 Người dùng (3 bác sĩ, 2 bệnh nhân)';
PRINT N'- 3 Bác sĩ nha khoa với chuyên môn khác nhau';
PRINT N'- 2 Bệnh nhân';
PRINT N'- 3 Ca làm việc (Sáng, Chiều, Tối)';
PRINT N'- 7 Dịch vụ nha khoa';
PRINT N'- 15 Lịch làm việc được duyệt';
PRINT N'- 5 Cuộc hẹn nha khoa mẫu';

-- Ghi chú
PRINT N'';
PRINT N'⚠️ LƯU Ý QUAN TRỌNG:';
PRINT N'1. Script đã sửa thứ tự tạo bảng để đảm bảo foreign key hợp lệ.';
PRINT N'2. Trường start_time/end_time trong Appointment đã đổi sang TIME thay vì DATE.';
PRINT N'3. Xóa CHECK constraint trùng lặp trong bảng Staff.';
PRINT N'4. Đồng bộ kiểu dữ liệu user_id thành int trong tất cả bảng.';
PRINT N'5. Cập nhật ngày dữ liệu mẫu sang năm 2025.';
PRINT N'6. Nếu lỗi Msg 207 (username) xảy ra, kiểm tra trigger, stored procedure, hoặc query ngoài script này.';
PRINT N'7. Script đã thêm kiểm tra cơ sở dữ liệu và xác nhận số dòng dữ liệu.';