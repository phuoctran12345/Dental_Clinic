CREATE TABLE [dbo].[Appointment] (
    [appointment_id]          INT            IDENTITY (1, 1) NOT NULL,
    [patient_id]              INT            NULL,
    [doctor_id]               BIGINT         NULL,
    [work_date]               DATE           NULL,
    [slot_id]                 INT            NULL,
    [status]                  NVARCHAR (50)  DEFAULT (N'BOOKED') NULL,
    [reason]                  NVARCHAR (MAX) NULL,
    [doctor_name]             NVARCHAR (50)  NULL,
    [previous_appointment_id] INT            NULL,
    [booked_by_user_id]       INT            NULL,
    PRIMARY KEY CLUSTERED ([appointment_id] ASC),
    CHECK ([status]='WAITING_PAYMENT' OR [status]='CANCELLED' OR [status]='COMPLETED' OR [status]='BOOKED'),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([patient_id]) REFERENCES [dbo].[Patients] ([patient_id]),
    FOREIGN KEY ([previous_appointment_id]) REFERENCES [dbo].[Appointment] ([appointment_id]),
    FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id])
);


GO

