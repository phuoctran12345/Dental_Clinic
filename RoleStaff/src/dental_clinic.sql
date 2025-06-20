CREATE TABLE [dbo].[Appointment] (
   [appointment_id] INT            IDENTITY (1, 1) NOT NULL,
   [patient_id]     INT            NULL,
   [doctor_id]      BIGINT         NULL,
   [work_date]      DATE           NULL,
   [slot_id]        INT            NULL,
   [status]         NVARCHAR (50)  DEFAULT (N'Đã đặt') NULL,
   [reason]         NVARCHAR (MAX) NULL,
   [doctor_name]    NVARCHAR (50)  NULL,
   [start_time]     DATE           NULL,
   [end_time]       DATE           NULL,
   PRIMARY KEY CLUSTERED ([appointment_id] ASC),
   FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
   FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id]),
   FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id])
);

-- Table Bills để lưu thông tin hóa đơn PayOS
CREATE TABLE [dbo].[Bills] (
   [bill_id] INT IDENTITY(1,1) NOT NULL,
   [appointment_id] INT NOT NULL,
   [patient_id] INT NOT NULL,
   [total_amount] DECIMAL(10,2) NOT NULL,
   [service_fee] DECIMAL(10,2) DEFAULT(0),
   [discount] DECIMAL(10,2) DEFAULT(0),
   [final_amount] DECIMAL(10,2) NOT NULL,
   [payment_status] NVARCHAR(50) DEFAULT(N'Chờ thanh toán') NOT NULL,
   [payment_method] NVARCHAR(50) DEFAULT(N'PayOS') NOT NULL,
   [payos_order_id] BIGINT NULL,
   [payos_transaction_id] NVARCHAR(255) NULL,
   [payos_payment_url] NVARCHAR(MAX) NULL,
   [created_at] DATETIME DEFAULT(GETDATE()),
   [paid_at] DATETIME NULL,
   [description] NVARCHAR(MAX) NULL,
   PRIMARY KEY CLUSTERED ([bill_id] ASC),
   FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment] ([appointment_id]),
   FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id])
);

-- Table BillServices để lưu chi tiết dịch vụ trong hóa đơn
CREATE TABLE [dbo].[BillServices] (
   [id] INT IDENTITY(1,1) NOT NULL,
   [bill_id] INT NOT NULL,
   [service_id] INT NOT NULL,
   [service_name] NVARCHAR(255) NOT NULL,
   [price] DECIMAL(10,2) NOT NULL,
   [quantity] INT DEFAULT(1) NOT NULL,
   [total] DECIMAL(10,2) NOT NULL,
   PRIMARY KEY CLUSTERED ([id] ASC),
   FOREIGN KEY ([bill_id]) REFERENCES [dbo].[Bills] ([bill_id]),
   FOREIGN KEY ([service_id]) REFERENCES [dbo].[Services] ([service_id])
);

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors](
   [doctor_id] [bigint] IDENTITY(1,1) NOT NULL,
   [user_id] [bigint] NOT NULL,
   [full_name] [nvarchar](255) NOT NULL,
   [phone] [nvarchar](20) NOT NULL,
   [address] [nvarchar](max) NULL,
   [date_of_birth] [date] NULL,
   [gender] [nvarchar](10) NULL,
   [specialty] [nvarchar](255) NOT NULL,
   [license_number] [nvarchar](50) NOT NULL,
   [created_at] [datetime] NULL,
   [status] [nvarchar](50) NOT NULL,
   [avatar] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Doctors] ADD PRIMARY KEY CLUSTERED
(
   [doctor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Doctors] ADD UNIQUE NONCLUSTERED
(
   [user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Doctors] ADD UNIQUE NONCLUSTERED
(
   [license_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Doctors] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Doctors] ADD  DEFAULT (N'active') FOR [status]
GO
ALTER TABLE [dbo].[Doctors]  WITH CHECK ADD CHECK  (([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'))
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorSchedule](
   [schedule_id] [int] IDENTITY(1,1) NOT NULL,
   [doctor_id] [bigint] NULL,
   [work_date] [date] NULL,
   [slot_id] [int] NULL,
   [status] [nvarchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DoctorSchedule] ADD PRIMARY KEY CLUSTERED
(
   [schedule_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctors] ([doctor_id])
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD FOREIGN KEY([slot_id])
REFERENCES [dbo].[TimeSlot] ([slot_id])
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
   [patient_id] [int] IDENTITY(1,1) NOT NULL,
   [user_id] [int] NOT NULL,
   [full_name] [nvarchar](255) NOT NULL,
   [phone] [nvarchar](20) NULL,
   [date_of_birth] [date] NULL,
   [gender] [nvarchar](10) NULL,
   [created_at] [datetime] NULL,
   [avatar] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD PRIMARY KEY CLUSTERED
(
   [patient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD UNIQUE NONCLUSTERED
(
   [user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Patients]  WITH CHECK ADD CHECK  (([gender]='other' OR [gender]='female' OR [gender]='male'))
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
   [staff_id] [bigint] IDENTITY(1,1) NOT NULL,
   [id] [bigint] NOT NULL,
   [full_name] [nvarchar](255) NOT NULL,
   [phone] [nvarchar](20) NOT NULL,
   [address] [nvarchar](max) NULL,
   [date_of_birth] [date] NULL,
   [gender] [nvarchar](10) NULL,
   [position] [nvarchar](100) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff] ADD PRIMARY KEY CLUSTERED
(
   [staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff] ADD UNIQUE NONCLUSTERED
(
   [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD CHECK  (([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'))
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD CHECK  (([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'))
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSlot](
   [slot_id] [int] IDENTITY(1,1) NOT NULL,
   [start_time] [time](7) NULL,
   [end_time] [time](7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TimeSlot] ADD PRIMARY KEY CLUSTERED
(
   [slot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
   [user_id] [int] IDENTITY(1,1) NOT NULL,
   [username] [nvarchar](50) NOT NULL,
   [password_hash] [nvarchar](255) NOT NULL,
   [email] [nvarchar](100) NOT NULL,
   [role] [nvarchar](20) NOT NULL,
   [created_at] [datetime] NULL,
   [avatar] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[users] ADD PRIMARY KEY CLUSTERED
(
   [user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED
(
   [email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED
(
   [username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [CHK_Role] CHECK  (([role]='MANAGER' OR [role]='DOCTOR' OR [role]='PATIENT' OR [role]='STAFF'))
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [CHK_Role]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
   [service_id] [int] IDENTITY(1,1) NOT NULL,
   [service_name] [nvarchar](255) NOT NULL,
   [description] [nvarchar](max) NULL,
   [price] [float] NOT NULL,
   [status] [nvarchar](50) NOT NULL,
   [category] [nvarchar](100) NULL,
   [image] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services] ADD PRIMARY KEY CLUSTERED
(
   [service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT ('active') FOR [status]
GO
ALTER TABLE [dbo].[Services]  WITH CHECK ADD  CONSTRAINT [CHK_Price] CHECK  (([price]>=(0)))
GO
ALTER TABLE [dbo].[Services] CHECK CONSTRAINT [CHK_Price]
GO
ALTER TABLE [dbo].[Services]  WITH CHECK ADD  CONSTRAINT [CHK_Status] CHECK  (([status]='suspended' OR [status]='inactive' OR [status]='active'))
GO
ALTER TABLE [dbo].[Services] CHECK CONSTRAINT [CHK_Status]
GO


-- Script thêm dữ liệu mẫu cho hệ thống đặt lịch khám nha khoa
-- Database: BenhVien (Phòng khám nha khoa tư nhân)


USE BenhVien;


-- Thêm dữ liệu User mẫu (nếu chưa có) - sử dụng bảng users và password_hash
INSERT INTO users (username, password_hash, email, role) VALUES
('dentist1', '123456', 'dentist1@nhakhoa.vn', 'DOCTOR'),
('dentist2', '123456', 'dentist2@nhakhoa.vn', 'DOCTOR'),
('dentist3', '123456', 'dentist3@nhakhoa.vn', 'DOCTOR'),
('patient1', '123456', 'patient1@email.vn', 'PATIENT'),
('patient2', '123456', 'patient2@email.vn', 'PATIENT');


-- Thêm dữ liệu Bác sĩ Nha khoa mẫu
insert into doctors ( [user_id] , [full_name] , [phone] , [address] , [date_of_birth] , [gender] , [specialty] , [license_number] , [created_at] , [status] , [avatar] ) 
values ( /* user_id */ 68 ,/* full_name */ N'Nguyen Do Phuc Toan' ,/* phone */ N'0123456789' ,/* address */ N'123 Đường ABC, Quận 1, TP.HCM' ,/* date_of_birth */ '1985-06-15' ,/* gender */ N'male' ,/* specialty */ N'Chuyên khoa răng miệng ' ,/* license_number */ N'BACSITOAN001' ,/* created_at */ '2025-05-24 03:25:49.890' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 1 ,/* full_name */ N'BS. Nguyễn Văn An' ,/* phone */ N'0901234567' ,/* address */ N'123 Đường Nguyễn Trãi, Q1, HCM' ,/* date_of_birth */ '1980-01-15' ,/* gender */ N'male' ,/* specialty */ N'Nha khoa tổng quát' ,/* license_number */ N'NK001' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2 ,/* full_name */ N'BS. Trần Thị Bích' ,/* phone */ N'0912345678' ,/* address */ N'456 Đường Lê Văn Sỹ, Q3, HCM' ,/* date_of_birth */ '1985-05-20' ,/* gender */ N'female' ,/* specialty */ N'Chỉnh nha - Niềng răng' ,/* license_number */ N'NK002' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 3 ,/* full_name */ N'BS. Lê Minh Cường' ,/* phone */ N'0923456789' ,/* address */ N'789 Đường Võ Văn Tần, Q3, HCM' ,/* date_of_birth */ '1978-12-10' ,/* gender */ N'male' ,/* specialty */ N'Phẫu thuật hàm mặt' ,/* license_number */ N'NK003' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  );
-- Thêm dữ liệu Patients mẫu (không có trường address trong bảng Patients)
INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender) VALUES
(4, N'Nguyễn Thị Mai', '0934567890', '1990-03-25', 'female'),
(5, N'Phạm Văn Hùng', '0945678901', '1988-07-08', 'male');


-- Thêm dữ liệu TimeSlot (ca làm việc) - chỉ có start_time và end_time
insert into timeslot ( [start_time] , [end_time] ) 
values (   
/* start_time */ '08:00:00' ,/* end_time */ '12:00:00'  ), 
( /* start_time */ '13:00:00' ,/* end_time */ '17:00:00'  ), 
( /* start_time */ '08:00:00' ,/* end_time */ '17:00:00'  ), 
( /* start_time */ '08:00:00' ,/* end_time */ '08:30:00'  ), 
( /* start_time */ '08:30:00' ,/* end_time */ '09:00:00'  ), 
( /* start_time */ '09:00:00' ,/* end_time */ '09:30:00'  ), 
( /* start_time */ '09:30:00' ,/* end_time */ '10:00:00'  ), 
( /* start_time */ '10:00:00' ,/* end_time */ '10:30:00'  ), 
( /* start_time */ '10:30:00' ,/* end_time */ '11:00:00'  ), 
( /* start_time */ '11:00:00' ,/* end_time */ '11:30:00'  ), 
( /* start_time */ '11:30:00' ,/* end_time */ '12:00:00'  ), 
( /* start_time */ '12:00:00' ,/* end_time */ '12:30:00'  ), 
( /* start_time */ '12:30:00' ,/* end_time */ '13:00:00'  ), 
( /* start_time */ '13:00:00' ,/* end_time */ '13:30:00'  ), 
( /* start_time */ '13:30:00' ,/* end_time */ '14:00:00'  ), 
( /* start_time */ '14:00:00' ,/* end_time */ '14:30:00'  ), 
( /* start_time */ '14:30:00' ,/* end_time */ '15:00:00'  ), 
( /* start_time */ '15:00:00' ,/* end_time */ '15:30:00'  ), 
( /* start_time */ '15:30:00' ,/* end_time */ '16:00:00'  ), 
( /* start_time */ '16:00:00' ,/* end_time */ '16:30:00'  ), 
( /* start_time */ '16:30:00' ,/* end_time */ '17:00:00'  );


-- Thêm dữ liệu Services nha khoa
INSERT INTO Services (service_name, description, price, status, category) VALUES
(N'Khám tổng quát', N'Khám răng tổng quát, tư vấn chăm sóc răng miệng', 100000, 'active', N'Khám cơ bản'),
(N'Lấy cao răng', N'Vệ sinh răng miệng, lấy cao răng, đánh bóng răng', 200000, 'active', N'Vệ sinh răng'),
(N'Trám răng sâu', N'Điều trị và trám răng bị sâu với vật liệu composite', 300000, 'active', N'Điều trị'),
(N'Nhổ răng khôn', N'Phẫu thuật nhổ răng khôn an toàn', 800000, 'active', N'Phẫu thuật'),
(N'Niềng răng kim loại', N'Chỉnh nha với mắc cài kim loại truyền thống', 15000000, 'active', N'Chỉnh nha'),
(N'Niềng răng invisalign', N'Chỉnh nha trong suốt hiện đại', 45000000, 'active', N'Chỉnh nha'),
(N'Tư vấn niềng răng', N'Khám và tư vấn phương pháp chỉnh nha phù hợp', 150000, 'active', N'Tư vấn');


-- Thêm lịch làm việc mẫu cho bác sĩ nha khoa (tháng hiện tại và tháng sau)
INSERT INTO DoctorSchedule (doctor_id, work_date, slot_id, status) VALUES
-- BS. Nguyễn Văn An - Nha khoa tổng quát (doctor_id = 1)
(1, '2024-12-20', 1, 'approved'), -- Sáng
(1, '2024-12-21', 2, 'approved'), -- Chiều
(1, '2024-12-22', 1, 'approved'), -- Sáng
(1, '2024-12-23', 2, 'approved'), -- Chiều
(1, '2024-12-24', 1, 'approved'), -- Sáng


-- BS. Trần Thị Bích - Chỉnh nha (doctor_id = 2)
(2, '2024-12-20', 2, 'approved'), -- Chiều
(2, '2024-12-21', 1, 'approved'), -- Sáng
(2, '2024-12-22', 3, 'approved'), -- Tối
(2, '2024-12-25', 2, 'approved'), -- Chiều
(2, '2024-12-26', 1, 'approved'), -- Sáng


-- BS. Lê Minh Cường - Phẫu thuật hàm mặt (doctor_id = 3)
(3, '2024-12-23', 1, 'approved'), -- Sáng
(3, '2024-12-24', 2, 'approved'), -- Chiều
(3, '2024-12-25', 1, 'approved'), -- Sáng
(3, '2024-12-27', 2, 'approved'), -- Chiều
(3, '2024-12-28', 1, 'approved'); -- Sáng


-- Thêm một số appointment nha khoa mẫu
-- (Lưu ý: start_time và end_time trong bảng Appointment có kiểu DATE, không phải TIME)
INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, doctor_name, start_time, end_time) VALUES
(1, 1, '2024-12-20', 1, N'Đã đặt', N'Khám tổng quát - Lấy cao răng', N'BS. Nguyễn Văn An', '2024-12-20', '2024-12-20'),
(2, 2, '2024-12-21', 1, N'Đã đặt', N'Tư vấn niềng răng cho con', N'BS. Trần Thị Bích', '2024-12-21', '2024-12-21'),
(1, 3, '2024-12-23', 1, N'Đã đặt', N'Nhổ răng khôn', N'BS. Lê Minh Cường', '2024-12-23', '2024-12-23'),
(2, 1, '2024-12-24', 1, N'Đã đặt', N'Trám răng sâu', N'BS. Nguyễn Văn An', '2024-12-24', '2024-12-24'),
(1, 2, '2024-12-25', 2, N'Đã đặt', N'Tái khám niềng răng', N'BS. Trần Thị Bích', '2024-12-25', '2024-12-25');


PRINT 'Dữ liệu mẫu phòng khám nha khoa đã được thêm thành công!';
PRINT 'Bao gồm:';
PRINT '- 5 Users (3 dentist, 2 patient)';
PRINT '- 3 Bác sĩ Nha khoa với chuyên môn khác nhau';
PRINT '- 2 Bệnh nhân';
PRINT '- 3 Ca làm việc (Sáng, Chiều, Tối)';
PRINT '- 7 Dịch vụ nha khoa';
PRINT '- 15 Lịch làm việc được duyệt';
PRINT '- 5 Cuộc hẹn nha khoa mẫu';


-- Lưu ý quan trọng:
PRINT '';
PRINT '⚠️  LƯU Ý QUAN TRỌNG:';
PRINT '1. Bảng TimeSlot không có trường slot_name - cần thêm nếu muốn hiển thị tên ca';
PRINT '2. Trường start_time/end_time trong Appointment có kiểu DATE thay vì TIME';
PRINT '3. Bảng Patients không có trường address';
PRINT '4. Cần kiểm tra user_id trong các bảng có khớp với users.user_id không';


-- Thêm bảng Medicine
CREATE TABLE [dbo].[Medicine] (
    [medicine_id] INT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [unit] NVARCHAR(50),
    [quantity_in_stock] INT NOT NULL,
    [description] NVARCHAR(1000),
    PRIMARY KEY CLUSTERED ([medicine_id] ASC)
);

-- Thêm bảng MedicalReport
CREATE TABLE [dbo].[MedicalReport] (
    [report_id] INT IDENTITY(1,1) NOT NULL,
    [appointment_id] INT NOT NULL,
    [doctor_id] BIGINT NOT NULL,  -- Sử dụng BIGINT để khớp với Doctors.doctor_id
    [patient_id] INT NOT NULL,
    [diagnosis] NVARCHAR(500),
    [treatment_plan] NVARCHAR(1000),
    [note] NVARCHAR(1000),
    [created_at] DATETIME DEFAULT GETDATE(),
    [sign] NVARCHAR(MAX),
    PRIMARY KEY CLUSTERED ([report_id] ASC),
    FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment] ([appointment_id]),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id])
);

-- Thêm bảng Prescription
CREATE TABLE [dbo].[Prescription] (
    [prescription_id] INT IDENTITY(1,1) NOT NULL,
    [report_id] INT NOT NULL,
    [medicine_id] INT NOT NULL,
    [quantity] INT NOT NULL,
    [usage] NVARCHAR(500),
    PRIMARY KEY CLUSTERED ([prescription_id] ASC),
    FOREIGN KEY ([report_id]) REFERENCES [dbo].[MedicalReport] ([report_id]),
    FOREIGN KEY ([medicine_id]) REFERENCES [dbo].[Medicine] ([medicine_id])
);

-- Thêm dữ liệu mẫu cho Medicine
INSERT INTO [dbo].[Medicine] ([name], [unit], [quantity_in_stock], [description]) VALUES
(N'Paracetamol 500mg', N'Viên', 1000, N'Thuốc giảm đau, hạ sốt'),
(N'Amoxicillin 500mg', N'Viên', 800, N'Kháng sinh điều trị nhiễm khuẩn'),
(N'Ibuprofen 400mg', N'Viên', 500, N'Thuốc giảm đau, chống viêm'),
(N'Metronidazole 250mg', N'Viên', 600, N'Kháng sinh điều trị nhiễm khuẩn kỵ khí'),
(N'Diclofenac 50mg', N'Viên', 400, N'Thuốc giảm đau, chống viêm không steroid');

PRINT '';
PRINT 'Đã thêm các bảng mới:';
PRINT '- Bảng Medicine (Thuốc)';
PRINT '- Bảng MedicalReport (Báo cáo y tế)';
PRINT '- Bảng Prescription (Đơn thuốc)';
PRINT 'Và dữ liệu mẫu cho 5 loại thuốc cơ bản';

   -- Bảng Notifications để lưu thông báo
   CREATE TABLE [dbo].[Notifications] (
      [notification_id] INT IDENTITY(1,1) NOT NULL,
      [user_id] INT NOT NULL,  -- Người nhận thông báo
      [title] NVARCHAR(255) NOT NULL,  -- Tiêu đề thông báo
      [content] NVARCHAR(MAX) NOT NULL,  -- Nội dung thông báo
      [type] NVARCHAR(50) NOT NULL,  -- Loại thông báo: APPOINTMENT, PAYMENT, MEDICINE, SYSTEM
      [reference_id] INT NULL,  -- ID tham chiếu (ví dụ: appointment_id, payment_id)
      [is_read] BIT DEFAULT 0,  -- Đã đọc chưa
      [created_at] DATETIME DEFAULT GETDATE(),
      [read_at] DATETIME NULL,  -- Thời điểm đọc
      [status] NVARCHAR(20) DEFAULT N'ACTIVE',  -- ACTIVE, DELETED
      PRIMARY KEY CLUSTERED ([notification_id] ASC),
      FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id])
   );

   -- Bảng NotificationTemplates để lưu mẫu thông báo
   CREATE TABLE [dbo].[NotificationTemplates] (
      [template_id] INT IDENTITY(1,1) NOT NULL,
      [type] NVARCHAR(50) NOT NULL,
      [title_template] NVARCHAR(255) NOT NULL,
      [content_template] NVARCHAR(MAX) NOT NULL,
      [is_active] BIT DEFAULT 1,
      PRIMARY KEY CLUSTERED ([template_id] ASC)
   );

-- Thêm mẫu thông báo
INSERT INTO NotificationTemplates (type, title_template, content_template, is_active) VALUES
('APPOINTMENT_CREATED', N'Đặt lịch khám thành công', N'Bạn đã đặt lịch khám với bác sĩ {doctor_name} vào ngày {appointment_date} lúc {appointment_time}. Vui lòng đến đúng giờ.', 1),
('APPOINTMENT_REMINDER', N'Nhắc lịch khám', N'Nhắc nhở: Bạn có lịch khám với bác sĩ {doctor_name} vào {time_remaining}. Vui lòng đến đúng giờ.', 1),
('APPOINTMENT_CANCELED', N'Hủy lịch khám', N'Lịch khám của bạn với bác sĩ {doctor_name} vào ngày {appointment_date} đã bị hủy. Lý do: {reason}', 1),
('PAYMENT_SUCCESS', N'Thanh toán thành công', N'Bạn đã thanh toán thành công số tiền {amount} cho lịch khám ngày {appointment_date}. Mã giao dịch: {transaction_id}', 1),
('PAYMENT_PENDING', N'Chờ thanh toán', N'Vui lòng thanh toán số tiền {amount} cho lịch khám ngày {appointment_date}. Link thanh toán: {payment_link}', 1),
('MEDICINE_REMINDER', N'Nhắc uống thuốc', N'Đã đến giờ uống thuốc {medicine_name}. Liều lượng: {dosage}. Lưu ý: {note}', 1),
('SYSTEM_MAINTENANCE', N'Bảo trì hệ thống', N'Hệ thống sẽ bảo trì từ {start_time} đến {end_time}. {message}', 1);

PRINT 'Đã thêm dữ liệu mẫu cho bảng NotificationTemplates';