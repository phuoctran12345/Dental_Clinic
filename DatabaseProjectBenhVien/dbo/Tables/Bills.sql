CREATE TABLE [dbo].[Bills] (
    [bill_id]                  NVARCHAR (50)   NOT NULL,
    [order_id]                 NVARCHAR (50)   NOT NULL,
    [service_id]               INT             NOT NULL,
    [patient_id]               INT             NULL,
    [user_id]                  INT             NULL,
    [amount]                   MONEY           NOT NULL,
    [original_price]           MONEY           NOT NULL,
    [discount_amount]          MONEY           DEFAULT ((0)) NULL,
    [tax_amount]               MONEY           DEFAULT ((0)) NULL,
    [payment_method]           NVARCHAR (50)   DEFAULT ('PayOS') NOT NULL,
    [payment_status]           NVARCHAR (50)   DEFAULT ('pending') NOT NULL,
    [customer_name]            NVARCHAR (255)  NOT NULL,
    [customer_phone]           NVARCHAR (20)   NULL,
    [customer_email]           NVARCHAR (255)  NULL,
    [doctor_id]                INT             NULL,
    [appointment_date]         DATE            NULL,
    [appointment_time]         TIME (7)        NULL,
    [appointment_notes]        NVARCHAR (1000) NULL,
    [payos_order_id]           NVARCHAR (100)  NULL,
    [payos_transaction_id]     NVARCHAR (100)  NULL,
    [payos_signature]          NVARCHAR (500)  NULL,
    [payment_gateway_response] NVARCHAR (MAX)  NULL,
    [created_at]               DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [updated_at]               DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [paid_at]                  DATETIME2 (7)   NULL,
    [cancelled_at]             DATETIME2 (7)   NULL,
    [refunded_at]              DATETIME2 (7)   NULL,
    [notes]                    NVARCHAR (1000) NULL,
    [internal_notes]           NVARCHAR (1000) NULL,
    [is_deleted]               BIT             DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([bill_id] ASC),
    CHECK ([amount]>(0)),
    CHECK ([discount_amount]>=(0)),
    CHECK ([original_price]>(0)),
    CHECK ([tax_amount]>=(0)),
    CONSTRAINT [FK_Bills_Services] FOREIGN KEY ([service_id]) REFERENCES [dbo].[Services] ([service_id]),
    UNIQUE NONCLUSTERED ([order_id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_ServiceId]
    ON [dbo].[Bills]([service_id] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_Method]
    ON [dbo].[Bills]([payment_method] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_Amount]
    ON [dbo].[Bills]([amount] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_OrderId]
    ON [dbo].[Bills]([order_id] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_Status]
    ON [dbo].[Bills]([payment_status] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_PatientId]
    ON [dbo].[Bills]([patient_id] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Bills_CreatedAt]
    ON [dbo].[Bills]([created_at] ASC);


GO

CREATE TRIGGER TR_Bills_UpdatedAt
ON dbo.Bills
AFTER UPDATE
AS
BEGIN
    UPDATE dbo.Bills 
    SET updated_at = GETDATE()
    WHERE bill_id IN (SELECT bill_id FROM inserted);
END;

GO

