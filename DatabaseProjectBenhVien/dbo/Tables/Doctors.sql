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


GO

