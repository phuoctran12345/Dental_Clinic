CREATE TABLE [dbo].[DoctorSchedule] (
    [schedule_id] INT           IDENTITY (1, 1) NOT NULL,
    [doctor_id]   BIGINT        NULL,
    [work_date]   DATE          NULL,
    [slot_id]     INT           NULL,
    [status]      NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([schedule_id] ASC),
    FOREIGN KEY ([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id]),
    FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id])
);


GO

