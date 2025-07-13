-- Tạo data cho User ID = 7 (phuocthde180577@fpt.edu.vn)
-- Dựa trên log: User này đã có appointment ID = 149

-- Bước 1: Tạo thêm appointments với booked_by_user_id = 7
-- Update appointment có sẵn thành "được đặt cho người thân"

UPDATE Appointment 
SET booked_by_user_id = 7, 
    reason = 'Khám cho người thân - Phúc Toàn đặt lịch'
WHERE appointment_id = 149;

-- Bước 2: Tạo thêm một vài appointments nữa với dữ liệu thực tế
-- Lấy patient_id và doctor_id từ appointment có sẵn

INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, booked_by_user_id)
SELECT 
    patient_id,     -- Dùng patient_id từ appointment 149
    doctor_id,      -- Dùng doctor_id từ appointment 149  
    '2025-07-15',   -- Ngày khám mới
    slot_id,        -- Dùng slot_id từ appointment 149
    'BOOKED',       -- Status
    'Khám định kỳ cho con em - Đặt bởi Phúc Toàn',  -- Reason
    7               -- booked_by_user_id = 7
FROM Appointment 
WHERE appointment_id = 149;

INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, booked_by_user_id)
SELECT 
    patient_id,     
    doctor_id,      
    '2025-07-16',   
    slot_id,        
    'WAITING_PAYMENT',
    'Tái khám cho bố mẹ - Phúc Toàn đặt lịch',
    7               
FROM Appointment 
WHERE appointment_id = 149;

INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, booked_by_user_id)
SELECT 
    patient_id,     
    doctor_id,      
    '2025-07-18',   
    slot_id,        
    'COMPLETED',
    'Khám chuyên khoa cho gia đình',
    7               
FROM Appointment 
WHERE appointment_id = 149;

-- Bước 3: Kiểm tra kết quả
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
WHERE a.booked_by_user_id = 7
ORDER BY a.appointment_id DESC; 