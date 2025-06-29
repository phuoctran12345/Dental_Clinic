CREATE TABLE [dbo].[users] (
    [user_id]       INT            IDENTITY (1, 1) NOT NULL,
    [password_hash] NVARCHAR (255) NOT NULL,
    [email]         NVARCHAR (100) NOT NULL,
    [role]          NVARCHAR (20)  NOT NULL,
    [created_at]    DATETIME       DEFAULT (getdate()) NULL,
    [avatar]        NVARCHAR (MAX) NULL,
    [updated_at]    DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([user_id] ASC),
    CONSTRAINT [CHK_Role] CHECK ([role]='MANAGER' OR [role]='DOCTOR' OR [role]='PATIENT' OR [role]='STAFF'),
    UNIQUE NONCLUSTERED ([email] ASC)
);
insert into users ( [password_hash] , [email] , [role] , [created_at] , [avatar] , [updated_at] ) 
values ( /* password_hash */ N'12345' ,/* email */ N'manager@gmail.com' ,/* role */ N'MANAGER' ,/* created_at */ '2025-05-27 17:19:59.727' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'user@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-27 17:22:05.533' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'staff@gmail.com' ,/* role */ N'STAFF' ,/* created_at */ '2025-05-27 17:22:37.053' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'doctor@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-05-27 17:23:29.700' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'PATIENT' ,/* email */ N'hashed_password_123' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-27 17:25:44.323' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'userr@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-28 12:37:52.760' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'phuocthde180577@fpt.edu.vn' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-28 19:21:52.967' ,/* avatar */ null ,/* updated_at */ '2025-06-18 06:32:22.337'  ), 
( /* password_hash */ N'12345' ,/* email */ N'doctor1@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-02 06:22:04.120' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'123456' ,/* email */ N'dentist1@nhakhoa.vn' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'123456' ,/* email */ N'dentist2@nhakhoa.vn' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'123456' ,/* email */ N'dentist3@nhakhoa.vn' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'123456' ,/* email */ N'patient1@email.vn' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'123456' ,/* email */ N'patient2@email.vn' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'king123456789@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-17 09:59:08.440' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'doctor2@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-21 08:31:36.550' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'doctor3@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-21 08:32:09.873' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'doctor4@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-21 08:32:48.903' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'user6@gmail.com' ,/* role */ N'patient' ,/* created_at */ '2025-06-23 14:37:47.390' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'user20@gmail.com' ,/* role */ N'patient' ,/* created_at */ '2025-06-23 14:57:29.630' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* password_hash */ N'12345' ,/* email */ N'de180577tranhongphuoc@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-27 14:18:55.360' ,/* avatar */ null ,/* updated_at */ null  );


CREATE TABLE [dbo].[Appointment] (
    [appointment_id]          INT            IDENTITY (1, 1) NOT NULL,
    [patient_id]              INT            NULL,
    [doctor_id]               BIGINT         NULL,
    [work_date]               DATE           NULL,
    [slot_id]                 INT            NULL,
    [status]                  NVARCHAR (50)  DEFAULT (N'Đã đặt') NULL,
    [reason]                  NVARCHAR (MAX) NULL,
    [doctor_name]             NVARCHAR (50)  NULL,
    [previous_appointment_id] INT            NULL,
    PRIMARY KEY CLUSTERED ([appointment_id] ASC),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id]),
    FOREIGN KEY ([previous_appointment_id]) REFERENCES [dbo].[Appointment] ([appointment_id]),
    FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id])
);


-- database mẫu cho C.Trung
insert into appointment ( [patient_id] , [doctor_id] , [work_date] , [slot_id] , [status] , [reason] , [doctor_name] , [previous_appointment_id] ) 
values ( /* patient_id */ 5 ,/* doctor_id */ 1 ,/* work_date */ '2025-06-23' ,/* slot_id */ 3019 ,/* status */ N'Đã Khám ' ,/* reason */ N'.
' ,/* doctor_name */ null ,/* previous_appointment_id */ null  ), 
( /* patient_id */ 5 ,/* doctor_id */ 1 ,/* work_date */ '2025-06-24' ,/* slot_id */ 3003 ,/* status */ N'ĐÃ ĐẶT' ,/* reason */ N'RESERVATION|2025-06-23 22:43:13.139032|.' ,/* doctor_name */ null ,/* previous_appointment_id */ null  ), 
( /* patient_id */ 5 ,/* doctor_id */ 1 ,/* work_date */ '2025-06-24' ,/* slot_id */ 3002 ,/* status */ N'ĐÃ ĐẶT' ,/* reason */ N'RESERVATION|2025-06-23 22:44:59.520862|.' ,/* doctor_name */ null ,/* previous_appointment_id */ null  ), 
( /* patient_id */ 5 ,/* doctor_id */ 1 ,/* work_date */ '2025-06-24' ,/* slot_id */ 3019 ,/* status */ N'ĐÃ ĐẶT' ,/* reason */ N'RESERVATION|2025-06-24 17:50:52.193079|.' ,/* doctor_name */ null ,/* previous_appointment_id */ null  ), 
( /* patient_id */ 5 ,/* doctor_id */ 1 ,/* work_date */ '2025-06-25' ,/* slot_id */ 3004 ,/* status */ N'ĐÃ ĐẶT' ,/* reason */ N'RESERVATION|2025-06-24 18:10:08.71547|.' ,/* doctor_name */ null ,/* previous_appointment_id */ null  );

-- Table Bills để lưu thông tin hóa đơn PayOS
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bills](
	[bill_id] [nvarchar](50) NOT NULL,
	[order_id] [nvarchar](50) NOT NULL,
	[service_id] [int] NOT NULL,
	[patient_id] [int] NULL,
	[user_id] [int] NULL,
	[amount] [money] NOT NULL,
	[original_price] [money] NOT NULL,
	[discount_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[payment_method] [nvarchar](50) NOT NULL,
	[payment_status] [nvarchar](50) NOT NULL,
	[customer_name] [nvarchar](255) NOT NULL,
	[customer_phone] [nvarchar](20) NULL,
	[customer_email] [nvarchar](255) NULL,
	[doctor_id] [int] NULL,
	[appointment_date] [date] NULL,
	[appointment_time] [time](7) NULL,
	[appointment_notes] [nvarchar](1000) NULL,
	[payos_order_id] [nvarchar](100) NULL,
	[payos_transaction_id] [nvarchar](100) NULL,
	[payos_signature] [nvarchar](500) NULL,
	[payment_gateway_response] [nvarchar](max) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NOT NULL,
	[paid_at] [datetime2](7) NULL,
	[cancelled_at] [datetime2](7) NULL,
	[refunded_at] [datetime2](7) NULL,
	[notes] [nvarchar](1000) NULL,
	[internal_notes] [nvarchar](1000) NULL,
	[is_deleted] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Bills] ADD PRIMARY KEY CLUSTERED 
(
	[bill_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Bills] ADD UNIQUE NONCLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Bills_Amount] ON [dbo].[Bills]
(
	[amount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Bills_CreatedAt] ON [dbo].[Bills]
(
	[created_at] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Bills_Method] ON [dbo].[Bills]
(
	[payment_method] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Bills_OrderId] ON [dbo].[Bills]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Bills_PatientId] ON [dbo].[Bills]
(
	[patient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Bills_ServiceId] ON [dbo].[Bills]
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Bills_Status] ON [dbo].[Bills]
(
	[payment_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT ((0)) FOR [discount_amount]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT ((0)) FOR [tax_amount]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT ('PayOS') FOR [payment_method]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT ('pending') FOR [payment_status]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Services] FOREIGN KEY([service_id])
REFERENCES [dbo].[Services] ([service_id])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Services]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD CHECK  (([amount]>(0)))
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD CHECK  (([discount_amount]>=(0)))
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD CHECK  (([original_price]>(0)))
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD CHECK  (([tax_amount]>=(0)))
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_Bills_UpdatedAt]
ON [dbo].[Bills]
AFTER UPDATE
AS
BEGIN
    UPDATE dbo.Bills 
    SET updated_at = GETDATE()
    WHERE bill_id IN (SELECT bill_id FROM inserted);
END;
GO
ALTER TABLE [dbo].[Bills] ENABLE TRIGGER [TR_Bills_UpdatedAt]
GO


-- -- Table BillServices để lưu chi tiết dịch vụ trong hóa đơn
-- CREATE TABLE [dbo].[BillServices] (
--    [id] INT IDENTITY(1,1) NOT NULL,
--    [bill_id] INT NOT NULL,
--    [service_id] INT NOT NULL,
--    [service_name] NVARCHAR(255) NOT NULL,
--    [price] DECIMAL(10,2) NOT NULL,
--    [quantity] INT DEFAULT(1) NOT NULL,
--    [total] DECIMAL(10,2) NOT NULL,
--    PRIMARY KEY CLUSTERED ([id] ASC),
--    FOREIGN KEY ([bill_id]) REFERENCES [dbo].[Bills] ([bill_id]),
--    FOREIGN KEY ([service_id]) REFERENCES [dbo].[Services] ([service_id])
-- );

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

insert into doctors ( [user_id] , [full_name] , [phone] , [address] , [date_of_birth] , [gender] , [specialty] , [license_number] , [created_at] , [status] , [avatar] ) 
values ( /* user_id */ 68 ,/* full_name */ N'Nguyen Do Phuc Toan' ,/* phone */ N'0123456789' ,/* address */ N'123 Đường ABC, Quận 1, TP.HCM' ,/* date_of_birth */ '1985-06-15' ,/* gender */ N'male' ,/* specialty */ N'Chuyên khoa răng miệng ' ,/* license_number */ N'BACSITOAN001' ,/* created_at */ '2025-05-24 03:25:49.890' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2007 ,/* full_name */ N'BS. Nguyễn Văn An' ,/* phone */ N'0901234567' ,/* address */ N'123 Đường Nguyễn Trãi, Q1, HCM' ,/* date_of_birth */ '1980-01-15' ,/* gender */ N'male' ,/* specialty */ N'Nha khoa tổng quát' ,/* license_number */ N'NK001' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2008 ,/* full_name */ N'BS. Trần Thị Bích' ,/* phone */ N'0912345678' ,/* address */ N'456 Đường Lê Văn Sỹ, Q3, HCM' ,/* date_of_birth */ '1985-05-20' ,/* gender */ N'female' ,/* specialty */ N'Chỉnh nha - Niềng răng' ,/* license_number */ N'NK002' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2009 ,/* full_name */ N'BS. Lê Minh Cường' ,/* phone */ N'0923456789' ,/* address */ N'789 Đường Võ Văn Tần, Q3, HCM' ,/* date_of_birth */ '1978-12-10' ,/* gender */ N'male' ,/* specialty */ N'Phẫu thuật hàm mặt' ,/* license_number */ N'NK003' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  );

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

CREATE TABLE [dbo].[users] (
    [user_id]       INT            IDENTITY (1, 1) NOT NULL,
    [password_hash] NVARCHAR (255) NOT NULL,
    [email]         NVARCHAR (100) NOT NULL,
    [role]          NVARCHAR (20)  NOT NULL,
    [created_at]    DATETIME       DEFAULT (getdate()) NULL,
    [avatar]        NVARCHAR (MAX) NULL,
    [updated_at]    DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([user_id] ASC),
    CONSTRAINT [CHK_Role] CHECK ([role]='MANAGER' OR [role]='DOCTOR' OR [role]='PATIENT' OR [role]='STAFF'),
    UNIQUE NONCLUSTERED ([email] ASC),
    UNIQUE NONCLUSTERED ([username] ASC)
);


insert into users ( [username] , [password_hash] , [email] , [role] , [created_at] , [avatar] , [updated_at] ) 
values ( /* username */ N'MANAGER' ,/* password_hash */ N'12345' ,/* email */ N'manager@gmail.com' ,/* role */ N'MANAGER' ,/* created_at */ '2025-05-27 17:19:59.727' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'THP' ,/* password_hash */ N'12345' ,/* email */ N'user@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-27 17:22:05.533' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'STAFF' ,/* password_hash */ N'12345' ,/* email */ N'staff@gmail.com' ,/* role */ N'STAFF' ,/* created_at */ '2025-05-27 17:22:37.053' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'DOCTOR' ,/* password_hash */ N'12345' ,/* email */ N'doctor@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-05-27 17:23:29.700' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'test@gmail.com' ,/* password_hash */ N'PATIENT' ,/* email */ N'hashed_password_123' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-27 17:25:44.323' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'An' ,/* password_hash */ N'12345' ,/* email */ N'userr@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-28 12:37:52.760' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'PhuocTHDev' ,/* password_hash */ N'Phuoc12345#' ,/* email */ N'phuocthde180577@fpt.edu.vn' ,/* role */ N'PATIENT' ,/* created_at */ '2025-05-28 19:21:52.967' ,/* avatar */ null ,/* updated_at */ '2025-06-18 06:32:22.337'  ), 
( /* username */ N'Nguyen Do Phuc Toan' ,/* password_hash */ N'12345' ,/* email */ N'doctor1@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-02 06:22:04.120' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'dentist1' ,/* password_hash */ N'123456' ,/* email */ N'dentist1@nhakhoa.vn' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'dentist2' ,/* password_hash */ N'123456' ,/* email */ N'dentist2@nhakhoa.vn' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'dentist3' ,/* password_hash */ N'123456' ,/* email */ N'dentist3@nhakhoa.vn' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'patient1' ,/* password_hash */ N'123456' ,/* email */ N'patient1@email.vn' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'patient2' ,/* password_hash */ N'123456' ,/* email */ N'patient2@email.vn' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-10 17:09:53.240' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'king' ,/* password_hash */ N'12345' ,/* email */ N'king123456789@gmail.com' ,/* role */ N'PATIENT' ,/* created_at */ '2025-06-17 09:59:08.440' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'BS. Nguyễn Văn An' ,/* password_hash */ N'12345' ,/* email */ N'doctor2@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-21 08:31:36.550' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'BS. Trần Thị Bích' ,/* password_hash */ N'12345' ,/* email */ N'doctor3@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-21 08:32:09.873' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'BS. Lê Minh Cường' ,/* password_hash */ N'12345' ,/* email */ N'doctor4@gmail.com' ,/* role */ N'DOCTOR' ,/* created_at */ '2025-06-21 08:32:48.903' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'Long' ,/* password_hash */ N'12345' ,/* email */ N'user6@gmail.com' ,/* role */ N'patient' ,/* created_at */ '2025-06-23 14:37:47.390' ,/* avatar */ null ,/* updated_at */ null  ), 
( /* username */ N'messi' ,/* password_hash */ N'12345' ,/* email */ N'user20@gmail.com' ,/* role */ N'patient' ,/* created_at */ '2025-06-23 14:57:29.630' ,/* avatar */ null ,/* updated_at */ null  );


CREATE TABLE [dbo].[Services] (
    [service_id]   INT             IDENTITY (1, 1) NOT NULL,
    [service_name] NVARCHAR (255)  NOT NULL,
    [description]  NVARCHAR (1000) NULL,
    [price]        MONEY           NOT NULL,
    [status]       NVARCHAR (50)   DEFAULT ('active') NOT NULL,
    [category]     NVARCHAR (100)  NOT NULL,
    [created_at]   DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [updated_at]   DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [created_by]   NVARCHAR (100)  NULL,
    [image]        NVARCHAR (500)  NULL,
    PRIMARY KEY CLUSTERED ([service_id] ASC),
    CHECK ([price]>=(0)),
    CHECK ([status]='discontinued' OR [status]='inactive' OR [status]='active')
);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Category]
    ON [dbo].[Services]([category] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Status]
    ON [dbo].[Services]([status] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Price]
    ON [dbo].[Services]([price] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Name]
    ON [dbo].[Services]([service_name] ASC);


insert into services ( [service_name] , [description] , [price] , [status] , [category] , [created_at] , [updated_at] , [created_by] , [image] ) 
values ( /* service_name */ N'Khám tổng quát răng miệng' ,/* description */ N'Kiểm tra sức khỏe răng miệng tổng quát, tư vấn chăm sóc răng' ,/* price */ 200000 ,/* status */ N'active' ,/* category */ N'Khám cơ bản' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://b2976109.smushcdn.com/2976109/wp-content/uploads/2019/04/tooth_anatomy.jpg?lossy=2&strip=1&webp=1'  ), 
( /* service_name */ N'Khám tổng quát' ,/* description */ N'Khám răng tổng quát, tư vấn chăm sóc răng miệng' ,/* price */ 100000 ,/* status */ N'active' ,/* category */ N'Khám cơ bản' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://www.vinmec.com/static/uploads/medium_20190626_104545_053307_kham_rang_max_1800x1800_jpg_809c6546f2.jpg'  ), 
( /* service_name */ N'Cạo vôi răng' ,/* description */ N'Làm sạch mảng bám, vôi răng, đánh bóng răng' ,/* price */ 10000 ,/* status */ N'active' ,/* category */ N'Vệ sinh răng' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://nhakhoadrgreen.vn/wp-content/uploads/2025/04/cach-lam-sach-cao-rang-tai-nha-1-1024x684.jpg'  ), 
( /* service_name */ N'Lấy cao răng' ,/* description */ N'Vệ sinh răng miệng, lấy cao răng, đánh bóng răng' ,/* price */ 200000 ,/* status */ N'active' ,/* category */ N'Vệ sinh răng' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://www.nhakhoavietducdn.vn/wp-content/uploads/2019/12/co-nen-lay-cao-rang-thuong-xuyen-khong-180-1.jpg'  ), 
( /* service_name */ N'Trám răng sâu' ,/* description */ N'Trám răng sâu bằng composite, amalgam' ,/* price */ 500000 ,/* status */ N'active' ,/* category */ N'Điều trị' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://nhakhoaviethan.vn/wp-content/uploads/2022/12/Thiet-ke-chua-co-ten-4.png'  ), 
( /* service_name */ N'Trám răng sâu composite' ,/* description */ N'Điều trị và trám răng bị sâu với vật liệu composite' ,/* price */ 300000 ,/* status */ N'active' ,/* category */ N'Điều trị' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://nhakhoamientay.com/wp-content/uploads/2021/04/tram-rang-composite-la-gi.jpg'  ), 
( /* service_name */ N'Điều trị tủy răng' ,/* description */ N'Điều trị viêm tủy, chữa tủy răng' ,/* price */ 1000000 ,/* status */ N'active' ,/* category */ N'Điều trị' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'https://login.medlatec.vn//ImagePath/images/20210819/20210819_tai-sao-can-phai-dieu-tri-tuy-rang-1.jpg'  ), 
( /* service_name */ N'Nhổ răng khôn' ,/* description */ N'Nhổ răng khôn mọc lệch, mọc ngầm' ,/* price */ 1500000 ,/* status */ N'active' ,/* category */ N'Phẫu thuật' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'/images/wisdom-tooth.jpg'  ), 
( /* service_name */ N'Nhổ răng khôn an toàn' ,/* description */ N'Phẫu thuật nhổ răng khôn an toàn' ,/* price */ 800000 ,/* status */ N'active' ,/* category */ N'Phẫu thuật' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ null  ), 
( /* service_name */ N'Bọc răng sứ' ,/* description */ N'Bọc răng sứ thẩm mỹ, phục hồi răng hư tổn' ,/* price */ 3000000 ,/* status */ N'active' ,/* category */ N'Thẩm mỹ' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'/images/dental-crown.jpg'  ), 
( /* service_name */ N'Tẩy trắng răng' ,/* description */ N'Tẩy trắng răng bằng công nghệ laser' ,/* price */ 2000000 ,/* status */ N'active' ,/* category */ N'Thẩm mỹ' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'/images/teeth-whitening.jpg'  ), 
( /* service_name */ N'Niềng răng' ,/* description */ N'Niềng răng chỉnh nha, điều chỉnh khớp cắn' ,/* price */ 5000000 ,/* status */ N'active' ,/* category */ N'Chỉnh nha' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'/images/braces.jpg'  ), 
( /* service_name */ N'Niềng răng kim loại' ,/* description */ N'Chỉnh nha với mắc cài kim loại truyền thống' ,/* price */ 15000000 ,/* status */ N'active' ,/* category */ N'Chỉnh nha' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ null  ), 
( /* service_name */ N'Niềng răng invisalign' ,/* description */ N'Chỉnh nha trong suốt hiện đại' ,/* price */ 45000000 ,/* status */ N'active' ,/* category */ N'Chỉnh nha' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ null  ), 
( /* service_name */ N'Chụp X-quang răng' ,/* description */ N'Chụp X-quang răng toàn cảnh, chẩn đoán bệnh lý' ,/* price */ 300000 ,/* status */ N'active' ,/* category */ N'Chẩn đoán' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'/images/dental-xray.jpg'  ), 
( /* service_name */ N'Làm răng giả tháo lắp' ,/* description */ N'Làm răng giả tháo lắp, phục hồi răng mất' ,/* price */ 2000000 ,/* status */ N'active' ,/* category */ N'Phục hình' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ N'/images/dentures.jpg'  ), 
( /* service_name */ N'Tư vấn niềng răng' ,/* description */ N'Khám và tư vấn phương pháp chỉnh nha phù hợp' ,/* price */ 150000 ,/* status */ N'active' ,/* category */ N'Tư vấn' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ null  );


-- Script thêm dữ liệu mẫu cho hệ thống đặt lịch khám nha khoa
-- Database: BenhVien (Phòng khám nha khoa tư nhân)


USE BenhVien;





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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[message_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[message_content] [nvarchar](max) NOT NULL,
	[receiver_id] [int] NULL,
	[timestamp] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChatMessages] ADD PRIMARY KEY CLUSTERED 
(
	[message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChatMessages] ADD  DEFAULT (getdate()) FOR [timestamp]
GO
ALTER TABLE [dbo].[ChatMessages]  WITH CHECK ADD FOREIGN KEY([receiver_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[ChatMessages]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO


CREATE TABLE [dbo].[PaymentInstallments] (
    [installment_id]     INT             IDENTITY (1, 1) NOT NULL,
    [bill_id]            NVARCHAR (50)   NOT NULL,
    [total_amount]       MONEY           NOT NULL,
    [down_payment]       MONEY           NOT NULL,
    [installment_count]  INT             NOT NULL,
    [interest_rate]      DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [installment_number] INT             NOT NULL,
    [due_date]           DATE            NOT NULL,
    [amount_due]         MONEY           NOT NULL,
    [amount_paid]        MONEY           DEFAULT ((0)) NULL,
    [remaining_amount]   MONEY           DEFAULT ((0)) NULL,
    [payment_date]       DATE            NULL,
    [status]             NVARCHAR (20)   DEFAULT ('PENDING') NULL,
    [payment_method]     NVARCHAR (50)   NULL,
    [transaction_id]     NVARCHAR (100)  NULL,
    [late_fee]           MONEY           DEFAULT ((0)) NULL,
    [last_reminder_date] DATE            NULL,
    [reminder_count]     INT             DEFAULT ((0)) NULL,
    [next_reminder_date] DATE            NULL,
    [created_at]         DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [updated_at]         DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [notes]              NVARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([installment_id] ASC),
    CHECK ([amount_paid]<=[amount_due]),
    CHECK ([down_payment]>=[total_amount]*(0.3)),
    CHECK ([installment_count]>=(3) AND [installment_count]<=(12)),
    CHECK ([installment_number]<=[installment_count]),
    CONSTRAINT [FK_PaymentInstallments_Bills] FOREIGN KEY ([bill_id]) REFERENCES [dbo].[Bills] ([bill_id])
);



-- Thêm cái ni để tạo các dịch vụ trong iệc buôn bán thuốc 
-- Script thêm Service "Bán thuốc" vào hệ thống
-- Database: BenhVien
-- Author: Dental Clinic System

USE BenhVien;
GO

-- Kiểm tra xem service đã tồn tại chưa
IF NOT EXISTS (SELECT 1 FROM Services WHERE service_name = N'Bán thuốc trực tiếp')
BEGIN
    -- Thêm Service Bán thuốc
    INSERT INTO Services (
        service_name, 
        description, 
        price, 
        status, 
        category, 
        created_at, 
        updated_at,
        created_by,
        image
    ) 
    VALUES (
        N'Bán thuốc trực tiếp',
        N'Dịch vụ bán thuốc trực tiếp tại quầy nhà thuốc. Khách hàng có thể mua thuốc theo đơn thuốc hoặc mua lẻ các loại thuốc không kê đơn.',
        0, -- Giá = 0 vì sẽ tính theo từng loại thuốc
        'active',
        N'PHARMACY',
        GETDATE(),
        GETDATE(),
        'SYSTEM',
        N'https://cdn-icons-png.flaticon.com/512/883/883356.png'
    );
    
    PRINT '✅ Đã thêm Service "Bán thuốc trực tiếp" thành công!';
    
    -- Lấy service_id vừa tạo
    DECLARE @service_id INT;
    SELECT @service_id = service_id FROM Services WHERE service_name = N'Bán thuốc trực tiếp';
    PRINT '📋 Service ID: ' + CAST(@service_id AS NVARCHAR(10));
END
ELSE
BEGIN
    PRINT '⚠️  Service "Bán thuốc trực tiếp" đã tồn tại trong hệ thống!';
    
    -- Hiển thị thông tin service hiện có
    SELECT service_id, service_name, category, status, created_at 
    FROM Services 
    WHERE service_name = N'Bán thuốc trực tiếp';
END

-- Kiểm tra kết quả
PRINT '';
PRINT '📊 DANH SÁCH TẤT CẢ SERVICES HIỆN TẠI:';
SELECT 
    service_id,
    service_name,
    category,
    price,
    status
FROM Services 
ORDER BY service_id DESC;

PRINT '';
PRINT '🏥 HỆ THỐNG ĐÃ SẴN SÀNG CHO CHỨC NĂNG BÁN THUỐC!';
GO 