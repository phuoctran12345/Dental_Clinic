create database BenhVien;

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
   [created_at] [datetime] NULL
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
ALTER TABLE [dbo].[Doctors]  WITH CHECK ADD CHECK  (([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'))
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
   [patient_id] [int] IDENTITY(1,1) NOT NULL,
   [id] [int] NOT NULL,
   [full_name] [nvarchar](255) NOT NULL,
   [phone] [nvarchar](20) NULL,
   [date_of_birth] [date] NULL,
   [gender] [nvarchar](10) NULL,
   [created_at] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD PRIMARY KEY CLUSTERED
(
   [patient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD UNIQUE NONCLUSTERED
(
   [id] ASC
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
   [user_id] [bigint] NOT NULL,
   [full_name] [nvarchar](255) NOT NULL,
   [phone] [nvarchar](20) NOT NULL,
   [address] [nvarchar](max) NULL,
   [date_of_birth] [date] NULL,
   [gender] [nvarchar](10) NULL,
   [position] [nvarchar](100) NOT NULL,
   [created_at] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff] ADD PRIMARY KEY CLUSTERED
(
   [staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff] ADD UNIQUE NONCLUSTERED
(
   [user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD CHECK  (([gender]=N'other' OR [gender]=N'female' OR [gender]=N'male'))
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
   [id] [int] IDENTITY(1,1) NOT NULL,
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
   [id] ASC
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
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [CHK_Role] CHECK  (([role]='ADMIN' OR [role]='DOCTOR' OR [role]='PATIENT' OR [role]='STAFF'))
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [CHK_Role]
GO



