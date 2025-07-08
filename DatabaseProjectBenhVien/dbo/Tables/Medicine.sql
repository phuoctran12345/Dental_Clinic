CREATE TABLE [dbo].[Medicine] (
    [medicine_id]       INT             IDENTITY (1, 1) NOT NULL,
    [name]              NVARCHAR (255)  NOT NULL,
    [unit]              NVARCHAR (50)   NULL,
    [quantity_in_stock] INT             NOT NULL,
    [description]       NVARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([medicine_id] ASC)
);


GO

