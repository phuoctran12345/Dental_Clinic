CREATE PROCEDURE SP_UpdatePaymentStatus
    @bill_id NVARCHAR(50),
    @payment_status NVARCHAR(50),
    @payos_transaction_id NVARCHAR(100) = NULL,
    @payment_gateway_response NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Bills 
    SET 
        payment_status = @payment_status,
        payos_transaction_id = @payos_transaction_id,
        payment_gateway_response = @payment_gateway_response,
        paid_at = CASE WHEN @payment_status = 'success' THEN GETDATE() ELSE paid_at END,
        cancelled_at = CASE WHEN @payment_status = 'cancelled' THEN GETDATE() ELSE cancelled_at END
    WHERE bill_id = @bill_id;
    SELECT * FROM dbo.Bills WHERE bill_id = @bill_id;
END;

GO

