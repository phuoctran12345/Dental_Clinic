-- Tạo database
CREATE DATABASE Bida_PRJ;
USE Bida_PRJ;

-- Tạo bảng Role
CREATE TABLE Role (
    Role_ID INT IDENTITY(1,1) PRIMARY KEY,
    Role_Name NVARCHAR(20) NOT NULL
);

-- Tạo bảng Customer với Role_ID là khóa ngoại
CREATE TABLE Customer (
    Customer_ID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(15) UNIQUE,
    Password NVARCHAR(255),
    Role_ID INT,  -- Khóa ngoại tham chiếu đến bảng Role
    Created_At DATETIME DEFAULT GETDATE(),
    Status BIT DEFAULT 1,  -- 1: active, 0: inactive
    FOREIGN KEY (Role_ID) REFERENCES Role(Role_ID)
);

-- Tạo bảng BillardTable
CREATE TABLE BillardTable (
    Table_ID INT IDENTITY PRIMARY KEY,
    Category NVARCHAR(50),
    Quality NVARCHAR(50),
    Price INT,
    Quantity INT DEFAULT 1,
    image NVARCHAR(255)
);

-- Tạo bảng Bill
CREATE TABLE Bill (
    Bill_ID INT IDENTITY PRIMARY KEY,
    Customer_ID INT,
    Start_Time DATETIME,
    Date DATE,
    Status_bill NVARCHAR(50), 
	Receipt_Image NVARCHAR(MAX),
    Total_Bill DECIMAL(10,2),   
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);


CREATE TABLE BillDetails (
    BillDetail_ID INT IDENTITY PRIMARY KEY,
    Bill_ID INT,
    Table_ID INT,
    Selected INT, -- Số lượng bàn cùng loại
    Price DECIMAL(10,2), -- Giá bàn
    Total DECIMAL(10,2), -- Thành tiền (Quantity * Price)
    FOREIGN KEY (Bill_ID) REFERENCES Bill(Bill_ID),
    FOREIGN KEY (Table_ID) REFERENCES BillardTable(Table_ID)
);


-- Chèn dữ liệu vào bảng Role
INSERT INTO Role (Role_Name) VALUES
('Admin'),
('Customer');

-- Chèn dữ liệu vào bảng Customer
INSERT INTO Customer (Name, Email, PhoneNumber, Password, Role_ID) VALUES
('Admin', 'admin@bida.com', '0123456789', 'hashed_password', 1),
('Chau', 'chau@123', '123', 'hashed_password', 2);

-- Chèn dữ liệu vào bảng BillardTable
INSERT INTO BillardTable (Category, Quality, Price, image) VALUES
('Pool', 'Normal', 60000, 'images/Pool1.png'),
('Pool', 'VIP', 120000, 'images/Carom1.png'),
('Carom', 'Normal', 50000, 'images/Pool2.png'),
('Carom', 'VIP', 100000, 'images/Carom2.png');

-- Kiểm tra dữ liệu bảng BillardTable
SELECT * FROM Customer;
SELECT * FROM Bill;
SELECT * FROM BillardTable;
SELECT * FROM BillDetails;
SELECT * FROM Bill WHERE Customer_ID=3;





