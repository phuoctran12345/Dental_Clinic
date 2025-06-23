-- =====================================================
-- SIMPLIFIED PAYMENT INSTALLMENTS - HỆ THỐNG TRẢ GÓP ĐƠN GIẢN
-- CHỈ 1 BẢNG DUY NHẤT
-- =====================================================

CREATE TABLE [dbo].[PaymentInstallments] (
    [installment_id]        INT IDENTITY(1,1) PRIMARY KEY,
    [bill_id]               NVARCHAR(50) NOT NULL,
    
    -- Thông tin kế hoạch trả góp
    [total_amount]          MONEY NOT NULL,           -- Tổng số tiền dịch vụ
    [down_payment]          MONEY NOT NULL,           -- Tiền đã trả trước (30%)
    [installment_count]     INT NOT NULL,             -- Tổng số kỳ (6-12 tháng)
    [interest_rate]         DECIMAL(5,2) DEFAULT(0),  -- Lãi suất %/tháng
    
    -- Thông tin kỳ thanh toán hiện tại
    [installment_number]    INT NOT NULL,             -- Kỳ thứ mấy (1, 2, 3...)
    [due_date]              DATE NOT NULL,            -- Ngày đến hạn
    [amount_due]            MONEY NOT NULL,           -- Số tiền phải trả kỳ này
    [amount_paid]           MONEY DEFAULT(0),         -- Số tiền đã trả kỳ này
    [remaining_amount]      MONEY DEFAULT(0),         -- Số tiền còn thiếu kỳ này
    [payment_date]          DATE NULL,                -- Ngày thanh toán thực tế
    
    -- Trạng thái
    [status]                NVARCHAR(20) DEFAULT('PENDING'), 
    -- PENDING: Chưa trả
    -- PAID: Đã trả đủ kỳ này  
    -- PARTIAL: Trả một phần kỳ này
    -- OVERDUE: Quá hạn
    -- COMPLETED: Hoàn thành toàn bộ kế hoạch
    
    -- Thông tin thanh toán
    [payment_method]        NVARCHAR(50),             -- cash, card, transfer
    [transaction_id]        NVARCHAR(100),            -- Mã giao dịch
    [late_fee]              MONEY DEFAULT(0),         -- Phí trễ hạn
    
    -- Thông tin nhắc nợ
    [last_reminder_date]    DATE NULL,                -- Lần nhắc cuối
    [reminder_count]        INT DEFAULT(0),           -- Số lần đã nhắc
    [next_reminder_date]    DATE NULL,                -- Lần nhắc tiếp theo
    
    -- Audit
    [created_at]            DATETIME2(7) DEFAULT(GETDATE()),
    [updated_at]            DATETIME2(7) DEFAULT(GETDATE()),
    [notes]                 NVARCHAR(1000),
    
    -- Foreign Key
    CONSTRAINT [FK_PaymentInstallments_Bills] FOREIGN KEY ([bill_id]) REFERENCES [dbo].[Bills]([bill_id]),
    
    -- Constraints
    CHECK ([down_payment] >= [total_amount] * 0.3),   -- Tối thiểu 30%
    CHECK ([installment_count] BETWEEN 3 AND 12),     -- 3-12 tháng
    CHECK ([amount_paid] <= [amount_due]),
    CHECK ([installment_number] <= [installment_count])
);

-- Indexes
CREATE NONCLUSTERED INDEX [IX_PaymentInstallments_BillId] ON [dbo].[PaymentInstallments]([bill_id]);
CREATE NONCLUSTERED INDEX [IX_PaymentInstallments_DueDate] ON [dbo].[PaymentInstallments]([due_date]);
CREATE NONCLUSTERED INDEX [IX_PaymentInstallments_Status] ON [dbo].[PaymentInstallments]([status]);
CREATE NONCLUSTERED INDEX [IX_PaymentInstallments_NextReminder] ON [dbo].[PaymentInstallments]([next_reminder_date]);

-- Trigger tự động cập nhật thời gian
CREATE TRIGGER TR_PaymentInstallments_UpdatedAt
ON dbo.PaymentInstallments
AFTER UPDATE
AS
BEGIN
    UPDATE dbo.PaymentInstallments 
    SET updated_at = GETDATE()
    WHERE installment_id IN (SELECT installment_id FROM inserted);
END;

-- =====================================================
-- STORED PROCEDURES ĐƠN GIẢN
-- =====================================================

-- 1. Tạo kế hoạch trả góp mới
CREATE PROCEDURE sp_CreateInstallmentPlan
    @bill_id NVARCHAR(50),
    @total_amount MONEY,
    @down_payment MONEY,
    @installment_count INT,
    @interest_rate DECIMAL(5,2) = 0.0
AS
BEGIN
    DECLARE @remaining_amount MONEY = @total_amount - @down_payment;
    DECLARE @monthly_amount MONEY = @remaining_amount / @installment_count;
    DECLARE @start_date DATE = GETDATE();
    
    -- Tạo từng kỳ thanh toán
    DECLARE @i INT = 1;
    DECLARE @due_date DATE = DATEADD(MONTH, 1, @start_date);
    
    WHILE @i <= @installment_count
    BEGIN
        INSERT INTO PaymentInstallments 
        (bill_id, total_amount, down_payment, installment_count, interest_rate,
         installment_number, due_date, amount_due, remaining_amount, next_reminder_date)
        VALUES 
        (@bill_id, @total_amount, @down_payment, @installment_count, @interest_rate,
         @i, @due_date, @monthly_amount, @monthly_amount, DATEADD(DAY, -7, @due_date));
        
        SET @i = @i + 1;
        SET @due_date = DATEADD(MONTH, 1, @due_date);
    END;
    
    SELECT 'SUCCESS' as result, @installment_count as installments_created;
END;

-- 2. Thanh toán một kỳ
CREATE PROCEDURE sp_PayInstallment
    @installment_id INT,
    @amount_paid MONEY,
    @payment_method NVARCHAR(50),
    @transaction_id NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @amount_due MONEY;
    SELECT @amount_due = amount_due FROM PaymentInstallments WHERE installment_id = @installment_id;
    
    UPDATE PaymentInstallments 
    SET 
        amount_paid = @amount_paid,
        remaining_amount = @amount_due - @amount_paid,
        payment_date = GETDATE(),
        status = CASE 
            WHEN @amount_paid >= @amount_due THEN 'PAID'
            WHEN @amount_paid > 0 THEN 'PARTIAL'
            ELSE 'PENDING' 
        END,
        payment_method = @payment_method,
        transaction_id = @transaction_id
    WHERE installment_id = @installment_id;
    
    -- Cập nhật status cho toàn bộ plan nếu đã trả hết
    DECLARE @bill_id NVARCHAR(50);
    SELECT @bill_id = bill_id FROM PaymentInstallments WHERE installment_id = @installment_id;
    
    IF NOT EXISTS (
        SELECT 1 FROM PaymentInstallments 
        WHERE bill_id = @bill_id AND status IN ('PENDING', 'PARTIAL', 'OVERDUE')
    )
    BEGIN
        UPDATE PaymentInstallments 
        SET status = 'COMPLETED'
        WHERE bill_id = @bill_id;
        
        -- Cập nhật Bills table
        UPDATE Bills 
        SET payment_status = 'PAID'
        WHERE bill_id = @bill_id;
    END;
    
    SELECT 'SUCCESS' as result;
END;

-- 3. Cập nhật trạng thái quá hạn
CREATE PROCEDURE sp_UpdateOverdueInstallments
AS
BEGIN
    UPDATE PaymentInstallments 
    SET 
        status = 'OVERDUE',
        late_fee = CASE 
            WHEN DATEDIFF(DAY, due_date, GETDATE()) > 30 THEN amount_due * 0.05  -- 5% phí sau 30 ngày
            WHEN DATEDIFF(DAY, due_date, GETDATE()) > 7 THEN amount_due * 0.02   -- 2% phí sau 7 ngày
            ELSE 0
        END
    WHERE due_date < GETDATE() 
      AND status IN ('PENDING', 'PARTIAL')
      AND status != 'COMPLETED';
      
    SELECT @@ROWCOUNT as overdue_installments_updated;
END;

-- 4. Lấy danh sách cần nhắc nợ
CREATE PROCEDURE sp_GetRemindersNeeded
AS
BEGIN
    SELECT 
        pi.installment_id,
        pi.bill_id,
        b.customer_name,
        b.customer_phone,
        pi.installment_number,
        pi.due_date,
        pi.amount_due,
        pi.remaining_amount,
        DATEDIFF(DAY, GETDATE(), pi.due_date) as days_until_due,
        CASE 
            WHEN pi.due_date < GETDATE() THEN 'OVERDUE'
            WHEN DATEDIFF(DAY, GETDATE(), pi.due_date) <= 3 THEN 'URGENT'
            WHEN DATEDIFF(DAY, GETDATE(), pi.due_date) <= 7 THEN 'REMINDER'
            ELSE 'EARLY'
        END as reminder_type
    FROM PaymentInstallments pi
    INNER JOIN Bills b ON pi.bill_id = b.bill_id
    WHERE pi.status IN ('PENDING', 'PARTIAL')
      AND (
          pi.next_reminder_date <= GETDATE()
          OR pi.due_date < GETDATE()  -- Quá hạn
          OR DATEDIFF(DAY, GETDATE(), pi.due_date) <= 7  -- Sắp đến hạn
      )
    ORDER BY pi.due_date ASC;
END;

-- =====================================================
-- SAMPLE DATA ĐƠN GIẢN
-- =====================================================

-- Test data: Tạo kế hoạch trả góp cho một bill
EXEC sp_CreateInstallmentPlan 
    @bill_id = 'HD001',
    @total_amount = 5000000,
    @down_payment = 1500000,
    @installment_count = 6,
    @interest_rate = 0.0;

-- Giả lập thanh toán kỳ 1
DECLARE @first_installment INT;
SELECT TOP 1 @first_installment = installment_id 
FROM PaymentInstallments 
WHERE bill_id = 'HD001' AND installment_number = 1;

EXEC sp_PayInstallment 
    @installment_id = @first_installment,
    @amount_paid = 583333,
    @payment_method = 'cash',
    @transaction_id = 'TXN001';

-- =====================================================
-- VIEW ĐƠN GIẢN CHO BÁO CÁO
-- =====================================================

CREATE VIEW vw_InstallmentSummary AS
SELECT 
    bill_id,
    MAX(total_amount) as total_amount,
    MAX(down_payment) as down_payment,
    MAX(installment_count) as total_installments,
    COUNT(*) as installments_created,
    SUM(CASE WHEN status = 'PAID' THEN 1 ELSE 0 END) as paid_installments,
    SUM(CASE WHEN status = 'OVERDUE' THEN 1 ELSE 0 END) as overdue_installments,
    SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_installments,
    SUM(amount_paid) as total_paid,
    SUM(remaining_amount) as total_remaining,
    SUM(late_fee) as total_late_fees,
    MIN(CASE WHEN status = 'PENDING' THEN due_date END) as next_due_date,
    CASE 
        WHEN COUNT(*) = SUM(CASE WHEN status = 'PAID' THEN 1 ELSE 0 END) THEN 'COMPLETED'
        WHEN SUM(CASE WHEN status = 'OVERDUE' THEN 1 ELSE 0 END) > 0 THEN 'OVERDUE'
        ELSE 'ACTIVE'
    END as plan_status
FROM PaymentInstallments
GROUP BY bill_id; 