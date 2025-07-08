CREATE TABLE [dbo].[TimeSlot] (
    [slot_id]    INT      IDENTITY (1, 1) NOT NULL,
    [start_time] TIME (7) NULL,
    [end_time]   TIME (7) NULL,
    PRIMARY KEY CLUSTERED ([slot_id] ASC)
);


GO

