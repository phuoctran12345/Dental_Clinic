CREATE TABLE [dbo].[UserFaceImages] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [user_id]          INT            NOT NULL,
    [face_image]       NVARCHAR (MAX) NOT NULL,
    [face_encoding]    NVARCHAR (MAX) NOT NULL,
    [confidence_score] FLOAT (53)     DEFAULT ((0)) NULL,
    [registered_at]    DATETIME       DEFAULT (getdate()) NULL,
    [is_active]        BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id])
);


GO

CREATE NONCLUSTERED INDEX [IX_UserFaceImages_Active]
    ON [dbo].[UserFaceImages]([is_active] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_UserFaceImages_UserId]
    ON [dbo].[UserFaceImages]([user_id] ASC);


GO

