select * from users
select * from Patients
select * from Doctors
select * from Staff
select * from Services
select * from Medicine
select * from TimeSlot


CREATE TABLE [dbo].[Appointment] (
    [appointment_id]          INT            IDENTITY (1, 1) NOT NULL,
    [patient_id]              INT            NULL,
    [doctor_id]               BIGINT         NULL,
    [work_date]               DATE           NULL,
    [slot_id]                 INT            NULL,
    [status]                  NVARCHAR (50)  DEFAULT (N'BOOKED') NULL
        CHECK ([status] IN (
            'BOOKED',         -- Đã đặt lịch (thay thế cho "Đã đặt", "CONFIRMED")
            'COMPLETED',      -- Hoàn thành
            'CANCELLED',      -- Đã hủy
            'WAITING_PAYMENT' -- Chờ thanh toán
        )),
    [reason]                  NVARCHAR (MAX) NULL,
    [doctor_name]             NVARCHAR (50)  NULL,
    [previous_appointment_id] INT            NULL, --  khác 0 ->  tái khám ||  0 -> k  tái khám  || mỗi lần tái khám là tăng lên 1 
    [booked_by_user_id]       INT            NULL, -- Book lịch khám bởi  người thân (user_id )
    PRIMARY KEY CLUSTERED ([appointment_id] ASC),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id]),
    FOREIGN KEY ([previous_appointment_id]) REFERENCES [dbo].[Appointment] ([appointment_id]),
    FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id])
);
CREATE TABLE [dbo].[Bills] (
    [bill_id]                  NVARCHAR (50)   NOT NULL,
    [order_id]                 NVARCHAR (50)   NOT NULL,
    [service_id]               INT             NOT NULL,
    [patient_id]               INT             NULL,
    [user_id]                  INT             NULL,
    [amount]                   MONEY           NOT NULL,
    [original_price]           MONEY           NOT NULL,
    [discount_amount]          MONEY           DEFAULT ((0)) NULL,
    [tax_amount]               MONEY           DEFAULT ((0)) NULL,
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


GO
CREATE NONCLUSTERED INDEX [IX_Bills_CreatedAt]
    ON [dbo].[Bills]([created_at] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Bills_Method]
    ON [dbo].[Bills]([payment_method] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Bills_Status]
    ON [dbo].[Bills]([payment_status] ASC);


GO
CREATE TRIGGER TR_Bills_UpdatedAt
ON dbo.Bills
AFTER UPDATE
AS
BEGIN
    UPDATE dbo.Bills 
    SET updated_at = GETDATE()
    WHERE bill_id IN (SELECT bill_id FROM inserted);
END;
GO
CREATE NONCLUSTERED INDEX [IX_Bills_PatientId]
    ON [dbo].[Bills]([patient_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Bills_OrderId]
    ON [dbo].[Bills]([order_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Bills_ServiceId]
    ON [dbo].[Bills]([service_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Bills_Amount]
    ON [dbo].[Bills]([amount] ASC);

CREATE TABLE [dbo].[ChatMessages] (
    [message_id]      INT            IDENTITY (1, 1) NOT NULL,
    [user_id]         INT            NOT NULL,
    [message_content] NVARCHAR (MAX) NOT NULL,
    [receiver_id]     INT            NULL,
    [timestamp]       DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([message_id] ASC),
    FOREIGN KEY ([receiver_id]) REFERENCES [dbo].[users] ([user_id]),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id])
);

CREATE TABLE [dbo].[Doctors] (
    [doctor_id]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [user_id]        BIGINT         NOT NULL,
    [full_name]      NVARCHAR (255) NOT NULL,
    [phone]          NVARCHAR (20)  NOT NULL,
    [address]        NVARCHAR (MAX) NULL,
    [date_of_birth]  DATE           NULL,
    [gender]         NVARCHAR (10)  NULL,
    [specialty]      NVARCHAR (255) NOT NULL,
    [license_number] NVARCHAR (50)  NOT NULL,
    [created_at]     DATETIME       DEFAULT (getdate()) NULL,
    [status]         NVARCHAR (50)  DEFAULT (N'active') NOT NULL,
    [avatar]         NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([doctor_id] ASC),
    CHECK ([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'),
    UNIQUE NONCLUSTERED ([license_number] ASC),
    UNIQUE NONCLUSTERED ([user_id] ASC)
);

insert into doctors ( [user_id] , [full_name] , [phone] , [address] , [date_of_birth] , [gender] , [specialty] , [license_number] , [created_at] , [status] , [avatar] ) 
values ( /* user_id */ 68 ,/* full_name */ N'Nguyen Do Phuc Toan' ,/* phone */ N'0123456789' ,/* address */ N'123 Đường ABC, Quận 1, TP.HCM' ,/* date_of_birth */ '1985-06-15' ,/* gender */ N'male' ,/* specialty */ N'Chuyên khoa răng miệng ' ,/* license_number */ N'BACSITOAN001' ,/* created_at */ '2025-05-24 03:25:49.890' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2007 ,/* full_name */ N'BS. Nguyễn Văn An' ,/* phone */ N'0901234567' ,/* address */ N'123 Đường Nguyễn Trãi, Q1, HCM' ,/* date_of_birth */ '1980-01-15' ,/* gender */ N'male' ,/* specialty */ N'Nha khoa tổng quát' ,/* license_number */ N'NK001' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2008 ,/* full_name */ N'BS. Trần Thị Bích' ,/* phone */ N'0912345678' ,/* address */ N'456 Đường Lê Văn Sỹ, Q3, HCM' ,/* date_of_birth */ '1985-05-20' ,/* gender */ N'female' ,/* specialty */ N'Chỉnh nha - Niềng răng' ,/* license_number */ N'NK002' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  ), 
( /* user_id */ 2009 ,/* full_name */ N'BS. Lê Minh Cường' ,/* phone */ N'0923456789' ,/* address */ N'789 Đường Võ Văn Tần, Q3, HCM' ,/* date_of_birth */ '1978-12-10' ,/* gender */ N'male' ,/* specialty */ N'Phẫu thuật hàm mặt' ,/* license_number */ N'NK003' ,/* created_at */ '2025-06-10 17:09:53.247' ,/* status */ N'active' ,/* avatar */ null  );

CREATE TABLE [dbo].[DoctorSchedule] (
    [schedule_id] INT           IDENTITY (1, 1) NOT NULL,
    [doctor_id]   BIGINT        NULL,
    [work_date]   DATE          NULL,
    [slot_id]     INT           NULL,
    [status]      NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([schedule_id] ASC),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id])
);

CREATE TABLE [dbo].[MedicalReport] (
    [report_id]      INT             IDENTITY (1, 1) NOT NULL,
    [appointment_id] INT             NOT NULL,
    [doctor_id]      BIGINT          NOT NULL,
    [patient_id]     INT             NOT NULL,
    [diagnosis]      NVARCHAR (500)  NULL,
    [treatment_plan] NVARCHAR (1000) NULL,
    [note]           NVARCHAR (1000) NULL,
    [created_at]     DATETIME        DEFAULT (getdate()) NULL,
    [sign]           NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([report_id] ASC),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id]),
    CONSTRAINT [FK_MedicalReport_Doctor] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id])
);


GO
ALTER TABLE [dbo].[MedicalReport] NOCHECK CONSTRAINT [FK_MedicalReport_Doctor];

CREATE TABLE [dbo].[Medicine] (
    [medicine_id]       INT             IDENTITY (1, 1) NOT NULL,
    [name]              NVARCHAR (255)  NOT NULL,
    [unit]              NVARCHAR (50)   NULL,
    [quantity_in_stock] INT             NOT NULL,
    [description]       NVARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([medicine_id] ASC)
);

insert into medicine ( [name] , [unit] , [quantity_in_stock] , [description] ) 
values ( /* name */ N'Paracetamol 500mg' ,/* unit */ N'Viên' ,/* quantity_in_stock */ 984 ,/* description */ N'Thuốc giảm đau, hạ sốt'  ), 
( /* name */ N'Amoxicillin 500mg' ,/* unit */ N'Viên' ,/* quantity_in_stock */ 799 ,/* description */ N'Kháng sinh điều trị nhiễm khuẩn'  ), 
( /* name */ N'Ibuprofen 400mg' ,/* unit */ N'Viên' ,/* quantity_in_stock */ 500 ,/* description */ N'Thuốc giảm đau, chống viêm'  ), 
( /* name */ N'Metronidazole 250mg' ,/* unit */ N'Viên' ,/* quantity_in_stock */ 600 ,/* description */ N'Kháng sinh điều trị nhiễm khuẩn kỵ khí'  ), 
( /* name */ N'Diclofenac 50mg' ,/* unit */ N'Viên' ,/* quantity_in_stock */ 400 ,/* description */ N'Thuốc giảm đau, chống viêm không steroid'  );

CREATE TABLE [dbo].[Notifications] (
    [notification_id] INT            IDENTITY (1, 1) NOT NULL,
    [user_id]         INT            NOT NULL,
    [title]           NVARCHAR (255) NOT NULL,
    [content]         NVARCHAR (MAX) NOT NULL,
    [type]            NVARCHAR (50)  NOT NULL,
    [reference_id]    INT            NULL,
    [is_read]         BIT            DEFAULT ((0)) NULL,
    [created_at]      DATETIME       DEFAULT (getdate()) NULL,
    [read_at]         DATETIME       NULL,
    [status]          NVARCHAR (20)  DEFAULT (N'ACTIVE') NULL,
    PRIMARY KEY CLUSTERED ([notification_id] ASC),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id])
);

CREATE TABLE [dbo].[NotificationTemplates] (
    [template_id]      INT            IDENTITY (1, 1) NOT NULL,
    [type]             NVARCHAR (50)  NOT NULL,
    [title_template]   NVARCHAR (255) NOT NULL,
    [content_template] NVARCHAR (MAX) NOT NULL,
    [is_active]        BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([template_id] ASC)
);

CREATE TABLE [dbo].[Patients] (
    [patient_id]    INT            IDENTITY (1, 1) NOT NULL,
    [user_id]       INT            NULL,
    [full_name]     NVARCHAR (255) NOT NULL,
    [phone]         NVARCHAR (20)  NULL,
    [date_of_birth] DATE           NULL,
    [gender]        NVARCHAR (10)  NULL,
    [created_at]    DATETIME       DEFAULT (getdate()) NULL,
    [avatar]        NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([patient_id] ASC),
    CHECK ([gender]='other' OR [gender]='female' OR [gender]='male'),
    UNIQUE NONCLUSTERED ([user_id] ASC)
);

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


CREATE TABLE [dbo].[Patients] (
    [patient_id]    INT            IDENTITY (1, 1) NOT NULL,
    [user_id]       INT            NULL,
    [full_name]     NVARCHAR (255) NOT NULL,
    [phone]         NVARCHAR (20)  NULL,
    [date_of_birth] DATE           NULL,
    [gender]        NVARCHAR (10)  NULL,
    [created_at]    DATETIME       DEFAULT (getdate()) NULL,
    [avatar]        NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([patient_id] ASC),
    CHECK ([gender]='other' OR [gender]='female' OR [gender]='male'),
    UNIQUE NONCLUSTERED ([user_id] ASC)
);

insert into patients ( [user_id] , [full_name] , [phone] , [date_of_birth] , [gender] , [created_at] , [avatar] ) 
values ( /* user_id */ 2 ,/* full_name */ N'THP' ,/* phone */ N'0358014258' ,/* date_of_birth */ '2024-05-24' ,/* gender */ N'male' ,/* created_at */ '2025-05-26 11:15:35.770' ,/* avatar */ null  ), 
( /* user_id */ 49 ,/* full_name */ N'Tran Hong Phuoc' ,/* phone */ N'0936929381' ,/* date_of_birth */ '2025-05-02' ,/* gender */ N'male' ,/* created_at */ '2025-05-26 11:40:27.040' ,/* avatar */ null  ), 
( /* user_id */ 6 ,/* full_name */ N'Tran Hong Phuoc' ,/* phone */ N'0936929381' ,/* date_of_birth */ '2025-05-28' ,/* gender */ N'male' ,/* created_at */ '2025-05-28 12:38:03.547' ,/* avatar */ null  ), 
( /* user_id */ 7 ,/* full_name */ N'PhuocTHDev' ,/* phone */ N'0936929381' ,/* date_of_birth */ '2025-05-29' ,/* gender */ N'male' ,/* created_at */ '2025-05-28 19:22:00.753' ,/* avatar */ null  ), 
( /* user_id */ 4 ,/* full_name */ N'Nguyễn Thị Mai' ,/* phone */ N'0934567890' ,/* date_of_birth */ '1990-03-25' ,/* gender */ N'female' ,/* created_at */ '2025-06-10 17:09:53.250' ,/* avatar */ null  ), 
( /* user_id */ 5 ,/* full_name */ N'Phạm Văn Hùng' ,/* phone */ N'0945678901' ,/* date_of_birth */ '1988-07-08' ,/* gender */ N'male' ,/* created_at */ '2025-06-10 17:09:53.250' ,/* avatar */ null  ), 
( /* user_id */ 2011 ,/* full_name */ N'king' ,/* phone */ N'0936929381' ,/* date_of_birth */ '2025-06-23' ,/* gender */ N'male' ,/* created_at */ '2025-06-23 14:57:43.747' ,/* avatar */ null  ), 
( /* user_id */ 2012 ,/* full_name */ N'Trương Gia Bình ' ,/* phone */ N'0936929382' ,/* date_of_birth */ '2004-06-05' ,/* gender */ N'male' ,/* created_at */ '2025-06-27 14:19:27.610' ,/* avatar */ null  );


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

CREATE TABLE [dbo].[Prescription] (
    [prescription_id] INT            IDENTITY (1, 1) NOT NULL,
    [report_id]       INT            NOT NULL,
    [medicine_id]     INT            NOT NULL,
    [quantity]        INT            NOT NULL,
    [usage]           NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([prescription_id] ASC),
    FOREIGN KEY ([medicine_id]) REFERENCES [dbo].[Medicine] ([medicine_id]),
    FOREIGN KEY ([report_id]) REFERENCES [dbo].[MedicalReport] ([report_id])
);

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
CREATE NONCLUSTERED INDEX [IX_Services_Name]
    ON [dbo].[Services]([service_name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Price]
    ON [dbo].[Services]([price] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Status]
    ON [dbo].[Services]([status] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Services_Category]
    ON [dbo].[Services]([category] ASC);


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
( /* service_name */ N'Tư vấn niềng răng' ,/* description */ N'Khám và tư vấn phương pháp chỉnh nha phù hợp' ,/* price */ 150000 ,/* status */ N'active' ,/* category */ N'Tư vấn' ,/* created_at */ '2025-06-11 18:37:32.0733333' ,/* updated_at */ '2025-06-11 18:37:32.0733333' ,/* created_by */ null ,/* image */ null  ), 
( /* service_name */ N'Bán thuốc trực tiếp' ,/* description */ N'Dịch vụ bán thuốc trực tiếp tại quầy nhà thuốc. Khách hàng có thể mua thuốc theo đơn thuốc hoặc mua lẻ các loại thuốc không kê đơn.' ,/* price */ 0 ,/* status */ N'active' ,/* category */ N'PHARMACY' ,/* created_at */ '2025-06-27 14:58:28.8733333' ,/* updated_at */ '2025-06-27 14:58:28.8733333' ,/* created_by */ N'SYSTEM' ,/* image */ N'https://cdn-icons-png.flaticon.com/512/883/883356.png'  ); 

CREATE TABLE [dbo].[Staff] (
    [staff_id]        INT             IDENTITY (1, 1) NOT NULL,
    [user_id]         INT             NOT NULL,
    [full_name]       NVARCHAR (255)  NOT NULL,
    [phone]           NVARCHAR (20)   NOT NULL,
    [address]         NVARCHAR (MAX)  NULL,
    [date_of_birth]   DATE            NULL,
    [gender]          NVARCHAR (10)   NULL,
    [position]        NVARCHAR (100)  NOT NULL,
    [employment_type] NVARCHAR (20)   DEFAULT ('fulltime') NOT NULL,
    [created_at]      DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [updated_at]      DATETIME2 (7)   NULL,
    [status]          NVARCHAR (20)   DEFAULT ('active') NOT NULL,
    [hire_date]       DATE            NULL,
    [salary]          DECIMAL (15, 2) NULL,
    [manager_id]      INT             NULL,
    [department]      NVARCHAR (100)  NULL,
    [work_schedule]   NVARCHAR (50)   NULL,
    [notes]           NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([staff_id] ASC),
    CHECK ([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'),
    CHECK ([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'),
    CONSTRAINT [CHK_Staff_EmploymentType] CHECK ([employment_type]='parttime' OR [employment_type]='fulltime'),
    CONSTRAINT [CHK_Staff_Status] CHECK ([status]='terminated' OR [status]='suspended' OR [status]='inactive' OR [status]='active'),
    CONSTRAINT [CHK_Staff_WorkSchedule] CHECK ([work_schedule]='flexible' OR [work_schedule]='full_day' OR [work_schedule]='afternoon' OR [work_schedule]='morning' OR [work_schedule] IS NULL),
    CONSTRAINT [FK_Staff_Manager] FOREIGN KEY ([manager_id]) REFERENCES [dbo].[Staff] ([staff_id]),
    CONSTRAINT [FK_Staff_User] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id]),
    UNIQUE NONCLUSTERED ([user_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Staff_HireDate]
    ON [dbo].[Staff]([hire_date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Staff_Department]
    ON [dbo].[Staff]([department] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Staff_Status]
    ON [dbo].[Staff]([status] ASC);

insert into staff ( [user_id] , [full_name] , [phone] , [address] , [date_of_birth] , [gender] , [position] , [employment_type] , [created_at] , [updated_at] , [status] , [hire_date] , [salary] , [manager_id] , [department] , [work_schedule] , [notes] ) 
values ( /* user_id */ 2 ,/* full_name */ N'STAFF' ,/* phone */ N'0936929381' ,/* address */ N'16 chuong duong' ,/* date_of_birth */ '2024-05-24' ,/* gender */ N'male' ,/* position */ N'TIEP TAN' ,/* employment_type */ N'fulltime' ,/* created_at */ '2025-06-30 09:40:42.4266667' ,/* updated_at */ '2025-06-30 09:40:42.7966667' ,/* status */ N'active' ,/* hire_date */ '2025-06-30' ,/* salary */ null ,/* manager_id */ null ,/* department */ N'General' ,/* work_schedule */ N'full_day' ,/* notes */ null  );

-- Thêm record Staff cho user_id = 3 để khắc phục lỗi "Staff not found"
insert into staff ( [user_id] , [full_name] , [phone] , [address] , [date_of_birth] , [gender] , [position] , [employment_type] , [created_at] , [updated_at] , [status] , [hire_date] , [salary] , [manager_id] , [department] , [work_schedule] , [notes] ) 
values ( /* user_id */ 3 ,/* full_name */ N'STAFF USER 3' ,/* phone */ N'0936929382' ,/* address */ N'Địa chỉ Staff 3' ,/* date_of_birth */ '1990-01-01' ,/* gender */ N'male' ,/* position */ N'TIEP TAN' ,/* employment_type */ N'parttime' ,/* created_at */ '2025-07-02 21:30:00.0000000' ,/* updated_at */ '2025-07-02 21:30:00.0000000' ,/* status */ N'active' ,/* hire_date */ '2025-07-02' ,/* salary */ 8000000 ,/* manager_id */ null ,/* department */ N'General' ,/* work_schedule */ N'flexible' ,/* notes */ N'Staff được tạo để khắc phục lỗi user_id = 3'  );

GO



-- 7. Tạo trigger tự động cập nhật updated_at
CREATE TRIGGER TR_Staff_UpdatedAt
ON [dbo].[Staff]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [dbo].[Staff]
    SET [updated_at] = GETDATE()
    FROM [dbo].[Staff] s
    INNER JOIN inserted i ON s.[staff_id] = i.[staff_id];
END;
GO
CREATE NONCLUSTERED INDEX [IX_Staff_Position]
    ON [dbo].[Staff]([position] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Staff_EmploymentType]
    ON [dbo].[Staff]([employment_type] ASC);

CREATE TABLE [dbo].[StaffSchedule] (
    [schedule_id] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [staff_id] INT NOT NULL,
    [work_date] DATE NOT NULL,
    [slot_id] INT NULL, -- NULL nếu là nghỉ phép
    [status] NVARCHAR(20) DEFAULT 'pending' NOT NULL,
    [approved_by] INT NULL,
    [approved_at] DATETIME2 NULL,
    [created_at] DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT [FK_StaffSchedule_Staff] FOREIGN KEY ([staff_id]) REFERENCES [dbo].[Staff] ([staff_id]),
    CONSTRAINT [FK_StaffSchedule_TimeSlot] FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id]),
    CONSTRAINT [FK_StaffSchedule_Approver] FOREIGN KEY ([approved_by]) REFERENCES [dbo].[Staff] ([staff_id]),
    CONSTRAINT [CHK_StaffSchedule_Status] CHECK ([status] IN ('pending', 'approved', 'rejected')),
    CONSTRAINT [UQ_StaffSchedule_Date_Slot] UNIQUE ([staff_id], [work_date], [slot_id])
);

CREATE NONCLUSTERED INDEX [IX_StaffSchedule_Status]
    ON [dbo].[StaffSchedule]([status] ASC);

CREATE NONCLUSTERED INDEX [IX_StaffSchedule_WorkDate]
    ON [dbo].[StaffSchedule]([work_date] ASC);

CREATE TRIGGER [TR_StaffSchedule_ApprovedAt]
ON [dbo].[StaffSchedule]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF UPDATE(status)
    BEGIN
        UPDATE [dbo].[StaffSchedule]
        SET [approved_at] = CASE 
            WHEN i.[status] IN ('approved', 'rejected') THEN GETDATE()
            ELSE NULL
        END
        FROM [dbo].[StaffSchedule] s
        INNER JOIN inserted i ON s.[schedule_id] = i.[schedule_id]
        WHERE i.[status] <> d.[status];
    END
END;

CREATE TABLE [dbo].[TimeSlot] (
    [slot_id]    INT      IDENTITY (1, 1) NOT NULL,
    [start_time] TIME (7) NULL,
    [end_time]   TIME (7) NULL,
    PRIMARY KEY CLUSTERED ([slot_id] ASC)
);

insert into timeslot ( [start_time] , [end_time] ) 
values ( /* start_time */ '08:00:00' ,/* end_time */ '12:00:00'  ), 
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


-- cập nhật thêm cái ni 
-- Thêm dữ liệu mẫu cho bảng Staff
INSERT INTO Staff ([user_id], [full_name], [phone], [address], [date_of_birth], [gender], [position], [employment_type], [created_at], [updated_at], [status], [hire_date], [salary], [manager_id], [department], [work_schedule], [notes])
VALUES (2013, N'Nguyễn Văn A', '0901234567', N'123 Đường A, Q1', '1990-01-01', N'male', N'Lễ tân', N'fulltime', GETDATE(), NULL, N'active', '2020-01-01', 8000000, NULL, N'Quản trị', N'full_day', N'Nhân viên gắn bó');
