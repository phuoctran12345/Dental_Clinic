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


GO

