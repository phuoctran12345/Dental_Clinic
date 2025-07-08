CREATE TABLE [dbo].[PaymentInstallments] (
    [installment_id]     INT             IDENTITY (1, 1) NOT NULL,
    [bill_id]            NVARCHAR (50)   NOT NULL,
    [total_amount]       MONEY           NOT NULL,
    [down_payment]       MONEY           NOT NULL,
    [installment_count]  INT             NOT NULL,
    [interest_rate]      DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [installment_number] INT             NOT NULL,
    [due_date]           DATE            NOT NULL,
    [amount_due]         MONEY           NOT NULL,
    [amount_paid]        MONEY           DEFAULT ((0)) NULL,
    [remaining_amount]   MONEY           DEFAULT ((0)) NULL,
    [payment_date]       DATE            NULL,
    [status]             NVARCHAR (20)   DEFAULT ('PENDING') NULL,
    [payment_method]     NVARCHAR (50)   NULL,
    [transaction_id]     NVARCHAR (100)  NULL,
    [late_fee]           MONEY           DEFAULT ((0)) NULL,
    [last_reminder_date] DATE            NULL,
    [reminder_count]     INT             DEFAULT ((0)) NULL,
    [next_reminder_date] DATE            NULL,
    [created_at]         DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [updated_at]         DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [notes]              NVARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([installment_id] ASC),
    CHECK ([amount_paid]<=[amount_due]),
    CHECK ([down_payment]>=[total_amount]*(0.3)),
    CHECK ([installment_count]>=(3) AND [installment_count]<=(12)),
    CHECK ([installment_number]<=[installment_count]),
    CONSTRAINT [FK_PaymentInstallments_Bills] FOREIGN KEY ([bill_id]) REFERENCES [dbo].[Bills] ([bill_id])
);


GO

