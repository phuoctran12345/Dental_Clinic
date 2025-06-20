-- Dữ liệu mẫu Appointment cho patient_id = 5
-- Đảm bảo có dữ liệu trong các bảng liên quan trước

-- 1. Kiểm tra patient_id = 5 có tồn tại không
SELECT 'Checking Patient ID 5:' as Info;
SELECT patient_id, full_name FROM Patients WHERE patient_id = 5;

-- 2. Kiểm tra doctors có sẵn
SELECT 'Available Doctors:' as Info;
SELECT TOP 3 doctor_id, full_name, specialty FROM Doctors;

-- 3. Kiểm tra time slots có sẵn  
SELECT 'Available Time Slots:' as Info;
SELECT TOP 5 slot_id, start_time, end_time FROM TimeSlot ORDER BY start_time;

-- 4. Insert dữ liệu mẫu appointments cho patient_id = 5
INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason) VALUES
-- Lịch hẹn trong tương lai (sắp tới)
(5, 1, '2025-06-20', 3001, N'Đã đặt', N'Khám tổng quát định kỳ'),
(5, 2, '2025-06-25', 3002, N'Đã đặt', N'Tái khám sau điều trị'),
(5, 3, '2025-07-01', 3003, N'ĐANG GIỮ CHỖ', N'Khám chuyên khoa tim mạch'),

-- Lịch hẹn trong quá khứ (lịch sử)
(5, 1, '2025-06-10', 3001, N'Đã khám', N'Khám sức khỏe tổng quát'),
(5, 2, '2025-06-05', 3002, N'Đã khám', N'Điều trị răng miệng'),
(5, 4, '2025-05-28', 3004, N'Đã hủy', N'Khám da liễu - đã hủy do bận'),

-- Lịch hẹn hôm nay hoặc gần đây
(5, 1, '2025-06-15', 3005, N'Đã đặt', N'Khám kiểm tra kết quả xét nghiệm'),
(5, 3, '2025-06-18', 3006, N'HẾT HẠN', N'Lịch hẹn đã hết hạn');

-- 5. Kiểm tra kết quả sau khi insert
SELECT 'Appointments for Patient ID 5:' as Info;
SELECT 
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    d.full_name as doctor_name,
    a.work_date,
    a.slot_id,
    ts.start_time,
    ts.end_time,
    a.status,
    a.reason
FROM Appointment a
LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id  
LEFT JOIN TimeSlot ts ON a.slot_id = ts.slot_id
WHERE a.patient_id = 5
ORDER BY a.work_date DESC;

-- 6. Thống kê
SELECT 'Summary:' as Info;
SELECT 
    status,
    COUNT(*) as count
FROM Appointment 
WHERE patient_id = 5 
GROUP BY status; 