use BenhVien;

CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1), -- Tự động tăng
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    role NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    avatar NVARCHAR(MAX)
);
