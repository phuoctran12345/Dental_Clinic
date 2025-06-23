-- Kiểm tra cấu trúc database thực tế
-- Chạy trong SQL Server Management Studio

PRINT '=== CHECKING DATABASE STRUCTURE ===';

-- 1. Kiểm tra bảng Appointment có tồn tại không
IF OBJECT_ID('dbo.Appointment', 'U') IS NOT NULL
    PRINT '✅ Table Appointment exists'
ELSE
    PRINT '❌ Table Appointment does NOT exist';

-- 2. Hiển thị cấu trúc bảng Appointment
PRINT 'Appointment table structure:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Appointment'
ORDER BY ORDINAL_POSITION;

-- 3. Kiểm tra bảng Bills
IF OBJECT_ID('dbo.Bills', 'U') IS NOT NULL
    PRINT '✅ Table Bills exists'
ELSE
    PRINT '❌ Table Bills does NOT exist';

-- 4. Kiểm tra dữ liệu sample
PRINT 'Sample data from Appointment table:';
SELECT TOP 5 
    appointment_id,
    patient_id,
    doctor_id,
    work_date,
    slot_id,
    status,
    LEFT(reason, 30) as reason_short
FROM Appointment
ORDER BY appointment_id DESC;

-- 5. Đếm appointments theo ngày
DECLARE @today DATE = CAST(GETDATE() AS DATE);
PRINT 'Appointment counts by date:';
SELECT 
    work_date,
    COUNT(*) as count
FROM Appointment 
GROUP BY work_date 
ORDER BY work_date DESC; 