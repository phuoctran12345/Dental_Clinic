CREATE TABLE [dbo].[Prescription] (
    [prescription_id] INT            IDENTITY (1, 1) NOT NULL,
    [report_id]       INT            NOT NULL,
    [medicine_id]     INT            NOT NULL,
    [quantity]        INT            NOT NULL,
    [usage]           NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([prescription_id] ASC),
    FOREIGN KEY ([medicine_id]) REFERENCES [dbo].[Medicine] ([medicine_id]),
    FOREIGN KEY ([report_id]) REFERENCES [dbo].[MedicalReport] ([report_id])
);


GO

