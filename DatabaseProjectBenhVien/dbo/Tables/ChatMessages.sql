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


GO

