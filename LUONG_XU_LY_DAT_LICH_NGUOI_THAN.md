# LUỒNG XỬ LÝ ĐẶT LỊCH CHO NGƯỜI THÂN

## 1. Tổng Quan Luồng Xử Lý

### 1.1. Hiển thị form đặt lịch
- **URL:** `/booking`
- **File:** `user_datlich.jsp`
- **Thông tin cần nhập:**
  + Thông tin người thân (tên, SĐT, ngày sinh, giới tính)
  + Chọn bác sĩ
  + Chọn ngày khám
  + Chọn giờ khám
  + Chọn dịch vụ
  + Lý do khám

### 1.2. Xử lý đặt lịch
- **File:** `BookingPageServlet.java`
- **Chức năng:**
  + Nhận thông tin form
  + Kiểm tra slot trống
  + Lưu thông tin người thân vào bảng Patients
  + Tạo appointment mới với booked_by_user_id

### 1.3. Xác nhận đặt lịch
- **File:** `ConfirmRelativeServlet.java`
- **Chức năng:**
  + Hiển thị thông tin xác nhận
  + Chuyển đến thanh toán

### 1.4. Thanh toán PAYOS
- **File:** `PayOSServlet.java`
- **Chức năng:**
  + Tạo link thanh toán PAYOS
  + Xử lý callback sau thanh toán
  + Cập nhật trạng thái appointment
  + Lưu bill với:
    * patient_id: ID người thân
    * user_id: ID người đặt lịch
    * payment_method: "PAYOS"

## 2. Cấu Trúc Database

### 2.1. Bảng Patients
```sql
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    user_id INT NULL, -- NULL cho người thân
    full_name NVARCHAR(255),
    phone NVARCHAR(20),
    date_of_birth DATE,
    gender NVARCHAR(10)
);
```

### 2.2. Bảng Appointments
```sql
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    booked_by_user_id INT, -- ID người đặt lịch
    doctor_id INT,
    service_id INT,
    work_date DATE,
    slot_id INT,
    status VARCHAR(50)
);
```

### 2.3. Bảng Bills
```sql
CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,
    appointment_id INT,
    patient_id INT,
    user_id INT, -- ID người thanh toán
    amount DECIMAL,
    payment_method VARCHAR(50),
    status VARCHAR(50)
);
```

## 3. Các File Chính

1. `user_datlich.jsp`: Form đặt lịch
2. `BookingPageServlet.java`: Xử lý đặt lịch
3. `ConfirmRelativeServlet.java`: Xác nhận thông tin
4. `PayOSServlet.java`: Xử lý thanh toán
5. `PatientDAO.java`: Thao tác với bảng Patients
6. `AppointmentDAO.java`: Thao tác với bảng Appointments
7. `BillDAO.java`: Thao tác với bảng Bills

## 4. Quy Trình Thực Hiện

1. **Bước 1: Hiển thị form**
   - Truy cập `/booking`
   - Điền thông tin người thân và lịch khám

2. **Bước 2: Xử lý đặt lịch**
   - Gửi form đến `BookingPageServlet`
   - Kiểm tra và lưu thông tin

3. **Bước 3: Xác nhận**
   - Hiển thị trang xác nhận
   - Chuyển đến thanh toán

4. **Bước 4: Thanh toán**
   - Tạo link PAYOS
   - Xử lý callback
   - Lưu bill và cập nhật trạng thái

## 5. Lưu Ý

1. Người thân sẽ được lưu vào bảng `Patients` với `user_id = NULL`
2. Appointment sẽ lưu cả `patient_id` (người được khám) và `booked_by_user_id` (người đặt lịch)
3. Bill sẽ lưu `user_id` là ID của người thanh toán
4. Trạng thái appointment sẽ được cập nhật sau khi thanh toán thành công 