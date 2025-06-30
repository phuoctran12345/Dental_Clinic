CREATE DATABASE dental_clinic;
GO

USE [dental_clinic];
GO

-- 1. Tạo bảng users
CREATE TABLE [dbo].[users] (
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

-- 2. Tạo bảng TimeSlot
CREATE TABLE [dbo].[TimeSlot] (
    [slot_id] [int] IDENTITY(1,1) NOT NULL,
    [start_time] [time](7) NULL,
    [end_time] [time](7) NULL,
    PRIMARY KEY CLUSTERED ([slot_id] ASC)
);
GO

-- 3. Tạo bảng Doctors
CREATE TABLE [dbo].[Doctors] (
    [doctor_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
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
    CONSTRAINT [CHK_Gender_Doctors] CHECK ([gender] IN ('male', 'female', 'other')),
    CONSTRAINT [CHK_Status_Doctors] CHECK ([status] IN ('active', 'inactive', 'suspended'))
);
ALTER TABLE [dbo].[Doctors] ADD DEFAULT (GETDATE()) FOR [created_at];
ALTER TABLE [dbo].[Doctors] ADD DEFAULT ('active') FOR [status];
GO

-- 4. Tạo bảng Patients
CREATE TABLE [dbo].[Patients] (
    [patient_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
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

-- 5. Tạo bảng Staff
CREATE TABLE [dbo].[Staff] (
    [staff_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
    [full_name] [nvarchar](255) NOT NULL,
    [phone] [nvarchar](20) NOT NULL,
    [address] [nvarchar](max) NULL,
    [date_of_birth] [date] NULL,
    [gender] [nvarchar](10) NULL,
    [position] [nvarchar](100) NOT NULL,
    [avatar] [nvarchar](max) NULL,
    [created_at] [datetime] NULL,
    [status] [nvarchar](50) NOT NULL,
    PRIMARY KEY CLUSTERED ([staff_id] ASC),
    UNIQUE NONCLUSTERED ([user_id] ASC),
    CONSTRAINT [FK_Staff_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]),
    CONSTRAINT [CHK_Gender_Staff] CHECK ([gender] IN ('male', 'female', 'other')),
    CONSTRAINT [CHK_Status_Staff] CHECK ([status] IN ('active', 'inactive', 'suspended'))
);
ALTER TABLE [dbo].[Staff] ADD DEFAULT (GETDATE()) FOR [created_at];
ALTER TABLE [dbo].[Staff] ADD DEFAULT ('active') FOR [status];
GO

-- 6. Tạo bảng Services
CREATE TABLE [dbo].[Services] (
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

-- 7. Tạo bảng DoctorSchedule
CREATE TABLE [dbo].[DoctorSchedule] (
    [schedule_id] [int] IDENTITY(1,1) NOT NULL,
    [doctor_id] [int] NULL,
    [work_date] [date] NULL,
    [slot_id] [int] NULL,
    [status] [nvarchar](50) NULL DEFAULT (N'pending'),
    PRIMARY KEY CLUSTERED ([schedule_id] ASC),
    CONSTRAINT [FK_DoctorSchedule_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_DoctorSchedule_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot]([slot_id]),
    CONSTRAINT [CHK_DoctorSchedule_Status] CHECK ([status] IN ('pending', 'approved', 'rejected'))
);
GO

-- 8. Tạo bảng Appointment
CREATE TABLE [dbo].[Appointment] (
    [appointment_id] [int] IDENTITY(1,1) NOT NULL,
    [patient_id] [int] NULL,
    [doctor_id] [int] NULL,
    [work_date] [date] NULL,
    [slot_id] [int] NULL,
    [status] [nvarchar](50) DEFAULT (N'booked') NULL,
    [reason] [nvarchar](max) NULL,
    [previous_appointment_id] [int] NULL,
    [booked_by_user_id] [int] NULL,
    PRIMARY KEY CLUSTERED ([appointment_id] ASC),
    CONSTRAINT [FK_Appointment_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_Appointment_Patients] FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients]([patient_id]),
    CONSTRAINT [FK_Appointment_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot]([slot_id]),
    CONSTRAINT [FK_Appointment_Previous] FOREIGN KEY ([previous_appointment_id]) REFERENCES [dbo].[Appointment]([appointment_id]),
    CONSTRAINT [FK_Appointment_BookedBy] FOREIGN KEY ([booked_by_user_id]) REFERENCES [dbo].[users]([user_id]),
    CONSTRAINT [CHK_Appointment_Status] CHECK ([status] IN ('booked', 'completed', 'cancelled', 'no-show'))
);
GO

-- 9. Tạo bảng MedicalReport
CREATE TABLE [dbo].[MedicalReport] (
    [report_id] [int] IDENTITY(1,1) PRIMARY KEY,
    [appointment_id] [int] NOT NULL,
    [doctor_id] [int] NOT NULL,
    [patient_id] [int] NOT NULL,
    [diagnosis] [nvarchar](500),
    [treatment_plan] [nvarchar](1000),
    [note] [nvarchar](1000),
    [created_at] [datetime] DEFAULT GETDATE(),
    [sign] [nvarchar](max),
    CONSTRAINT [FK_MedicalReport_Appointment] FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment]([appointment_id]),
    CONSTRAINT [FK_MedicalReport_Doctors] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors]([doctor_id]),
    CONSTRAINT [FK_MedicalReport_Patients] FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients]([patient_id])
);
GO

-- 10. Tạo bảng Medicine
CREATE TABLE [dbo].[Medicine] (
    [medicine_id] [int] IDENTITY(1,1) PRIMARY KEY,
    [name] [nvarchar](255) NOT NULL,
    [unit] [nvarchar](50),
    [quantity_in_stock] [int] NOT NULL,
    [description] [nvarchar](1000),
    CONSTRAINT [CHK_QuantityInStock] CHECK ([quantity_in_stock] >= 0)
);
GO

-- 11. Tạo bảng Prescription
CREATE TABLE [dbo].[Prescription] (
    [prescription_id] [int] IDENTITY(1,1) PRIMARY KEY,
    [report_id] [int] NOT NULL,
    [medicine_id] [int] NOT NULL,
    [quantity] [int] NOT NULL,
    [usage] [nvarchar](500),
    CONSTRAINT [FK_Prescription_MedicalReport] FOREIGN KEY ([report_id]) REFERENCES [dbo].[MedicalReport]([report_id]),
    CONSTRAINT [FK_Prescription_Medicine] FOREIGN KEY ([medicine_id]) REFERENCES [dbo].[Medicine]([medicine_id]),
    CONSTRAINT [CHK_Quantity] CHECK ([quantity] > 0)
);
GO

-- Thêm dữ liệu mẫu
BEGIN TRY
    -- 1. Users
    INSERT INTO [dbo].[users] (password_hash, email, role) VALUES
        (N'123', N'patient@example.com', N'PATIENT'),
        (N'999', N'choheo.soss@gmail.com', N'DOCTOR'),
        (N'113', N'doctor1@example.com', N'DOCTOR'),
        (N'133', N'staff@example.com', N'STAFF'),
        (N'111', N'admin@example.com', N'MANAGER');

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

    -- 5. Staff
    INSERT INTO [dbo].[Staff] (user_id, full_name, phone, address, date_of_birth, gender, position, status) VALUES
        (4, N'Lê Văn Nam', '0923456789', N'789 Đường Trần Hưng Đạo, Q5, HCM', '1992-07-10', 'male', N'Receptionist', 'active');

    -- 6. Services
    INSERT INTO [dbo].[Services] (service_name, description, price, status, category) VALUES
        (N'Khám tổng quát', N'Khám răng tổng quát, tư vấn chăm sóc răng miệng', 100000, 'active', N'Khám cơ bản'),
        (N'Lấy cao răng', N'Vệ sinh răng miệng, lấy cao răng, đánh bóng răng', 200000, 'active', N'Vệ sinh răng'),
        (N'Trám răng sâu', N'Điều trị và trám răng bị sâu với vật liệu composite', 300000, 'active', N'Điều trị'),
        (N'Nhổ răng khôn', N'Phẫu thuật nhổ răng khôn an toàn', 800000, 'active', N'Phẫu thuật'),
        (N'Niềng răng kim loại', N'Chỉnh nha với mắc cài kim loại truyền thống', 15000000, 'active', N'Chỉnh nha'),
        (N'Niềng răng invisalign', N'Chỉnh nha trong suốt hiện đại', 45000000, 'active', N'Chỉnh nha'),
        (N'Tư vấn niềng răng', N'Khám và tư vấn phương pháp chỉnh nha phù hợp', 150000, 'active', N'Tư vấn');

    -- 7. DoctorSchedule (corrected to use valid doctor_id values)
    INSERT INTO [dbo].[DoctorSchedule] (doctor_id, work_date, slot_id, status) VALUES
        (1, '2025-12-20', 1, 'rejected'),
        (1, '2025-12-21', 2, 'rejected'),
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

    -- 8. Appointment (corrected to use valid doctor_id and previous_appointment_id)
    INSERT INTO [dbo].[Appointment] (patient_id, doctor_id, work_date, slot_id, status, reason, previous_appointment_id, booked_by_user_id) VALUES
        (1, 1, '2025-12-20', 2, N'booked', N'Khám tổng quát - Lấy cao răng', NULL, 1),
        (1, 2, '2025-12-21', 1, N'booked', N'Tư vấn niềng răng cho con', 1, 1),
        (1, 1, '2025-12-24', 1, N'booked', N'Trám răng sâu', 2, 1),
        (1, 2, '2025-12-25', 2, N'booked', N'Tái khám niềng răng', 3, 1);

    -- 9. Medicine
    INSERT INTO [dbo].[Medicine] (name, unit, quantity_in_stock, description) VALUES
        (N'Paracetamol', N'viên', 500, N'Giảm đau, hạ sốt'),
        (N'Amoxicillin', N'viên', 300, N'Kháng sinh điều trị nhiễm khuẩn'),
        (N'Saline 0.9%', N'chai', 200, N'Dung dịch truyền, rửa vết thương'),
        (N'Loperamide', N'viên', 150, N'Chống tiêu chảy'),
        (N'Vitamin C', N'viên', 400, N'Tăng sức đề kháng, phòng cảm cúm');

END TRY
BEGIN CATCH
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;
GO




ALTER TABLE [dbo].[Staff]
DROP CONSTRAINT IF EXISTS [FK_Staff_users]; -- Xóa ràng buộc cũ nếu có

ALTER TABLE [dbo].[Staff]
ADD CONSTRAINT [FK_Staff_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]) ON DELETE CASCADE;


-- Thêm user mới cho nha sĩ (nếu cần)
INSERT INTO [dbo].[users] (password_hash, email, role) VALUES
    (N'456', N'doctor3@example.com', N'DOCTOR');
GO

-- Thêm dữ liệu mẫu cho Doctors (nếu cần kiểm tra)
INSERT INTO [dbo].[Doctors] (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number, status)
VALUES (6, N'BS. Phạm Văn Cường', '0909876543', N'101 Đường Pasteur, Q1, HCM', '1982-09-12', 'male', N'Nha khoa thẩm mỹ', 'NK003', 'active');
GO


CREATE TABLE [dbo].[Bills] (
    [bill_id]                  NVARCHAR (50)   NOT NULL,
    [order_id]                 NVARCHAR (50)   NOT NULL,
    [service_id]               INT             NOT NULL,
    [patient_id]               INT             NULL,
    [user_id]                  INT             NULL,
    [amount]                   FLOAT           NOT NULL,
    [original_price]           FLOAT           NOT NULL,
    [discount_amount]          FLOAT           DEFAULT ((0)) NULL,
    [tax_amount]               FLOAT           DEFAULT ((0)) NULL,
    [payment_method]           NVARCHAR (50)   DEFAULT ('PayOS') NOT NULL,
    [payment_status]           NVARCHAR (50)   DEFAULT ('pending') NOT NULL,
    [customer_name]            NVARCHAR (255)  NOT NULL,
    [customer_phone]           NVARCHAR (20)   NULL,
    [customer_email]           NVARCHAR (255)  NULL,
    [doctor_id]                INT             NULL,
    [appointment_date]         DATE            NULL,
    [appointment_time]         TIME (7)        NULL,
    [appointment_notes]        NVARCHAR (1000) NULL,
    [payos_order_id]           NVARCHAR (100)  NULL,
    [payos_transaction_id]     NVARCHAR (100)  NULL,
    [payos_signature]          NVARCHAR (500)  NULL,
    [payment_gateway_response] NVARCHAR (MAX)  NULL,
    [created_at]               DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [updated_at]               DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [paid_at]                  DATETIME2 (7)   NULL,
    [cancelled_at]             DATETIME2 (7)   NULL,
    [refunded_at]              DATETIME2 (7)   NULL,
    [notes]                    NVARCHAR (1000) NULL,
    [internal_notes]           NVARCHAR (1000) NULL,
    [is_deleted]               BIT             DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([bill_id] ASC),
    CHECK ([amount]>(0)),
    CHECK ([discount_amount]>=(0)),
    CHECK ([original_price]>(0)),
    CHECK ([tax_amount]>=(0)),
    CONSTRAINT [FK_Bills_Services] FOREIGN KEY ([service_id]) REFERENCES [dbo].[Services] ([service_id]),
    UNIQUE NONCLUSTERED ([order_id] ASC)
);


INSERT INTO [dbo].[Bills] (
    bill_id,
    order_id,
    service_id,
    patient_id,
    user_id,
    amount,
    original_price,
    discount_amount,
    tax_amount,
    payment_method,
    payment_status,
    customer_name,
    customer_phone,
    customer_email,
    doctor_id,
    appointment_date,
    appointment_time,
    appointment_notes,
    payos_order_id,
    payos_transaction_id,
    payos_signature,
    payment_gateway_response,
    created_at,
    updated_at,
    paid_at,
    cancelled_at,
    refunded_at,
    notes,
    internal_notes,
    is_deleted
)
VALUES (
    N'BILL001',
    N'ORDER001',
    1,                      -- service_id: cần có trong bảng Services
    101,                   -- patient_id
    5,                     -- user_id (nhân viên tạo hóa đơn)
    500000.00,             -- amount: tổng số tiền phải trả
    600000.00,             -- original_price: giá gốc
    50000.00,              -- discount_amount
    10000.00,              -- tax_amount
    N'PayOS',              -- payment_method
    N'completed',          -- payment_status
    N'Nguyễn Văn A',       -- customer_name
    N'0905123456',         -- customer_phone
    N'a.nguyen@example.com', -- customer_email
    2,                     -- doctor_id
    '2025-06-30',          -- appointment_date
    '09:30:00',            -- appointment_time
    N'Khám răng định kỳ',  -- appointment_notes
    N'PAYOS_123456789',    -- payos_order_id
    N'TRANS_987654321',    -- payos_transaction_id
    N'abcd1234signature',  -- payos_signature
    N'{ "code": 200, "message": "Success" }',  -- payment_gateway_response
    GETDATE(),             -- created_at
    GETDATE(),             -- updated_at
    GETDATE(),             -- paid_at
    NULL,                  -- cancelled_at
    NULL,                  -- refunded_at
    N'Khách đã thanh toán.', -- notes
    N'Giao dịch qua PayOS.', -- internal_notes
    0                      -- is_deleted
);
