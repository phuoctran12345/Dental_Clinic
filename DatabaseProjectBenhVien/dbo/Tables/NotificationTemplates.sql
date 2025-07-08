CREATE TABLE [dbo].[NotificationTemplates] (
    [template_id]      INT            IDENTITY (1, 1) NOT NULL,
    [type]             NVARCHAR (50)  NOT NULL,
    [title_template]   NVARCHAR (255) NOT NULL,
    [content_template] NVARCHAR (MAX) NOT NULL,
    [is_active]        BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([template_id] ASC)
);


GO

