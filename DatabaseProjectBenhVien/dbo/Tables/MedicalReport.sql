CREATE TABLE [dbo].[MedicalReport] (
    [report_id]      INT             IDENTITY (1, 1) NOT NULL,
    [appointment_id] INT             NOT NULL,
    [doctor_id]      BIGINT          NOT NULL,
    [patient_id]     INT             NOT NULL,
    [diagnosis]      NVARCHAR (500)  NULL,
    [treatment_plan] NVARCHAR (1000) NULL,
    [note]           NVARCHAR (1000) NULL,
    [created_at]     DATETIME        DEFAULT (getdate()) NULL,
    [sign]           NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([report_id] ASC),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id]),
    CONSTRAINT [FK_MedicalReport_Doctor] FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id])
);


GO
ALTER TABLE [dbo].[MedicalReport] NOCHECK CONSTRAINT [FK_MedicalReport_Doctor];


GO

