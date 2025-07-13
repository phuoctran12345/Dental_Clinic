-- Script tạo sample data cho lịch hẹn người thân (SỬA LỖI FOREIGN KEY)
-- Sử dụng dữ liệu thực tế từ database hiện có

-- Bước 1: Kiểm tra dữ liệu có sẵn
-- Lấy patient_id, doctor_id, slot_id từ bảng hiện có để tránh lỗi FOREIGN KEY

-- Cách 1: Sử dụng appointment ID có sẵn và chỉ update booked_by_user_id
-- Update một số appointment hiện có thành "được đặt bởi user 7 cho người thân"

-- Lấy 3 appointment đầu tiên và set booked_by_user_id = 7
UPDATE Appointment 
SET booked_by_user_id = 7, 
    reason = 'Khám cho người thân - ' + ISNULL(reason, 'Không có lý do')
WHERE appointment_id IN (
    SELECT TOP 3 appointment_id 
    FROM Appointment 
    WHERE booked_by_user_id IS NULL 
    ORDER BY appointment_id
);

-- Lấy 2 appointment tiếp theo và set booked_by_user_id = 2017  
UPDATE Appointment 
SET booked_by_user_id = 2017,
    reason = 'Đặt lịch cho gia đình - ' + ISNULL(reason, 'Không có lý do')
WHERE appointment_id IN (
    SELECT TOP 2 appointment_id 
    FROM Appointment 
    WHERE booked_by_user_id IS NULL 
    ORDER BY appointment_id DESC
);

-- Kiểm tra kết quả
SELECT 
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    a.booked_by_user_id,
    a.work_date,
    a.status,
    a.reason,
    p.full_name as patient_name,
    u.email as booked_by_email
FROM Appointment a
LEFT JOIN Patients p ON a.patient_id = p.patient_id
LEFT JOIN users u ON a.booked_by_user_id = u.user_id
WHERE a.booked_by_user_id IS NOT NULL
ORDER BY a.appointment_id DESC; 