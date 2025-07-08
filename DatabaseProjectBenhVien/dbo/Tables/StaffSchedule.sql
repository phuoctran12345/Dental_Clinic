CREATE TABLE [dbo].[StaffSchedule] (
    [schedule_id]  INT            IDENTITY (1, 1) NOT NULL,
    [staff_id]     INT            NOT NULL,
    [work_date]    DATE           NOT NULL,
    [slot_id]      INT            NULL,
    [request_type] NVARCHAR (20)  NOT NULL,
    [status]       NVARCHAR (20)  DEFAULT ('pending') NOT NULL,
    [reason]       NVARCHAR (500) NULL,
    [created_at]   DATETIME       DEFAULT (getdate()) NULL,
    [approved_by]  INT            NULL,
    [approved_at]  DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([schedule_id] ASC),
    CHECK ([request_type]='leave' OR [request_type]='work'),
    CHECK ([status]='rejected' OR [status]='approved' OR [status]='pending'),
    FOREIGN KEY ([slot_id]) REFERENCES [dbo].[TimeSlot] ([slot_id]),
    FOREIGN KEY ([staff_id]) REFERENCES [dbo].[Staff] ([staff_id])
);


GO

