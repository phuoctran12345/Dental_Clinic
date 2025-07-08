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


GO

