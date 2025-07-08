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


GO

