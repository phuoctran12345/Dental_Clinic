CREATE PROCEDURE SP_CreateBill
    @bill_id NVARCHAR(50),
    @order_id NVARCHAR(50),
    @service_id INT,
    @customer_name NVARCHAR(255),
    @customer_phone NVARCHAR(20) = NULL,
    @amount MONEY,
    @payment_method NVARCHAR(50) = 'PayOS'
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Bills 
    (bill_id, order_id, service_id, customer_name, customer_phone, amount, original_price, payment_method)
    VALUES 
    (@bill_id, @order_id, @service_id, @customer_name, @customer_phone, @amount, @amount, @payment_method);
    SELECT * FROM dbo.Bills WHERE bill_id = @bill_id;
END;

GO

