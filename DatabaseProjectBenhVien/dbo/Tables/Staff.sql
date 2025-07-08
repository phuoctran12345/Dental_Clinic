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

CREATE NONCLUSTERED INDEX [IX_Staff_EmploymentType]
    ON [dbo].[Staff]([employment_type] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Staff_Department]
    ON [dbo].[Staff]([department] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Staff_Position]
    ON [dbo].[Staff]([position] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Staff_Status]
    ON [dbo].[Staff]([status] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Staff_HireDate]
    ON [dbo].[Staff]([hire_date] ASC);


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

