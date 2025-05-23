use Doctor;

CREATE TABLE Doctors (
    doctor_id BIGINT PRIMARY KEY IDENTITY,                 -- ID tự tăng
    user_id BIGINT UNIQUE NOT NULL,                        -- Liên kết với bảng Users (foreign key)
    
    full_name NVARCHAR(255) NOT NULL,                      -- Họ tên (không mã hóa, cần hiển thị)
    phone NVARCHAR(20) NOT NULL,                           -- Số điện thoại (công khai)
    address NVARCHAR(MAX) NULL,                            -- Địa chỉ (nếu cần mã hóa thì xử lý trong app)
    date_of_birth DATE NULL,                               -- Ngày sinh (tùy hiển thị tuổi)
    
    gender NVARCHAR(10) CHECK (gender IN (N'male', N'female', N'other')),  -- Giới tính
    specialty NVARCHAR(255) NOT NULL,                      -- Chuyên môn (VD: chỉnh nha, phục hình…)
    license_number NVARCHAR(50) UNIQUE NOT NULL,           -- Số giấy phép hành nghề

    created_at DATETIME DEFAULT GETDATE()                  -- Thờ	i gian tạo
);

INSERT INTO Doctors (user_id, full_name, phone, address, date_of_birth, gender, specialty, license_number)
VALUES (1,
        N'Nguyen Do Phuc Toan',
        '0123456789', 
        N'123 Đường ABC, Quận 1, TP.HCM', 
        '1985-06-15',
		N'male',
        N'Nội tim mạch', 
        'BACSITOAN001');



		select*from Doctors;