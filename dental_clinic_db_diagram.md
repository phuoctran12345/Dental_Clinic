# DB Diagram - Hệ Thống Phòng Khám Nha Khoa

## Tổng Quan
Hệ thống quản lý phòng khám nha khoa với các chức năng chính:
- Quản lý người dùng (Users, Patients, Doctors, Staff)
- Đặt lịch hẹn (Appointments)
- Quản lý dịch vụ và thuốc (Services, Medicine)
- Báo cáo y tế (MedicalReport, Prescription)
- Thanh toán (Bills, PaymentInstallments)
- Lịch làm việc (DoctorSchedule, StaffSchedule)

## Cấu Trúc Bảng

### 1. Bảng Người Dùng (Users & Profiles)

```mermaid
erDiagram
    users {
        int user_id PK
        nvarchar password_hash
        nvarchar email UK
        nvarchar role
        datetime created_at
        nvarchar avatar
        datetime updated_at
    }
    
    patients {
        int patient_id PK
        int user_id FK
        nvarchar full_name
        nvarchar phone
        date date_of_birth
        nvarchar gender
        datetime created_at
        nvarchar avatar
    }
    
    doctors {
        bigint doctor_id PK
        bigint user_id FK
        nvarchar full_name
        nvarchar phone
        nvarchar address
        date date_of_birth
        nvarchar gender
        nvarchar specialty
        nvarchar license_number UK
        datetime created_at
        nvarchar status
        nvarchar avatar
    }
    
    staff {
        int staff_id PK
        int user_id FK
        nvarchar full_name
        nvarchar phone
        nvarchar address
        date date_of_birth
        nvarchar gender
        nvarchar position
        nvarchar employment_type
        datetime2 created_at
        datetime2 updated_at
        nvarchar status
        date hire_date
        decimal salary
        int manager_id FK
        nvarchar department
        nvarchar work_schedule
        nvarchar notes
    }
    
    relatives {
        int relative_id PK
        int user_id FK
        nvarchar full_name
        nvarchar phone
        date date_of_birth
        nvarchar gender
        nvarchar relationship
        datetime created_at
    }
    
    userfaceimages {
        int id PK
        int user_id FK
        nvarchar face_image
        nvarchar face_encoding
        float confidence_score
        datetime registered_at
        bit is_active
    }
    
    users ||--o{ patients : "has"
    users ||--o{ doctors : "has"
    users ||--o{ staff : "has"
    users ||--o{ relatives : "has"
    users ||--o{ userfaceimages : "has"
    staff ||--o{ staff : "manages"
```

### 2. Bảng Dịch Vụ & Thuốc

```mermaid
erDiagram
    services {
        int service_id PK
        nvarchar service_name
        nvarchar description
        money price
        nvarchar status
        nvarchar category
        datetime2 created_at
        datetime2 updated_at
        nvarchar created_by
        nvarchar image
    }
    
    medicine {
        int medicine_id PK
        nvarchar name
        nvarchar unit
        int quantity_in_stock
        nvarchar description
    }
    
    timeslot {
        int slot_id PK
        time start_time
        time end_time
    }
```

### 3. Bảng Lịch Hẹn & Lịch Làm Việc

```mermaid
erDiagram
    appointment {
        int appointment_id PK
        int patient_id FK
        bigint doctor_id FK
        date work_date
        int slot_id FK
        nvarchar status
        nvarchar reason
        nvarchar doctor_name
        int previous_appointment_id FK
        int booked_by_user_id FK
        int relative_id FK
    }
    
    doctorschedule {
        int schedule_id PK
        bigint doctor_id FK
        date work_date
        int slot_id FK
        nvarchar status
    }
    
    staffschedule {
        bigint schedule_id PK
        int staff_id FK
        date work_date
        int slot_id FK
        nvarchar status
        int approved_by FK
        datetime2 approved_at
        datetime2 created_at
    }
    
    reexamination {
        int reexam_id PK
        int appointment_id FK
        int reexam_count
        nvarchar note
        int created_by FK
        datetime created_at
        int approved_by FK
        datetime approved_at
        int scheduled_appointment_id FK
        nvarchar status
    }
    
    appointment ||--o{ appointment : "previous"
    appointment ||--o{ reexamination : "has"
    doctors ||--o{ doctorschedule : "has"
    staff ||--o{ staffschedule : "has"
    timeslot ||--o{ appointment : "used_in"
    timeslot ||--o{ doctorschedule : "used_in"
    timeslot ||--o{ staffschedule : "used_in"
```

### 4. Bảng Báo Cáo Y Tế & Đơn Thuốc

```mermaid
erDiagram
    medicalreport {
        int report_id PK
        int appointment_id FK
        bigint doctor_id FK
        int patient_id FK
        nvarchar diagnosis
        nvarchar treatment_plan
        nvarchar note
        datetime created_at
        nvarchar sign
    }
    
    prescription {
        int prescription_id PK
        int report_id FK
        int medicine_id FK
        int quantity
        nvarchar usage
    }
    
    appointment ||--|| medicalreport : "generates"
    medicalreport ||--o{ prescription : "contains"
    medicine ||--o{ prescription : "prescribed_in"
    doctors ||--o{ medicalreport : "creates"
    patients ||--o{ medicalreport : "receives"
```

### 5. Bảng Thanh Toán & Hóa Đơn

```mermaid
erDiagram
    bills {
        nvarchar bill_id PK
        nvarchar order_id UK
        int service_id FK
        int patient_id FK
        int user_id FK
        money amount
        money original_price
        money discount_amount
        money tax_amount
        nvarchar payment_method
        nvarchar payment_status
        nvarchar customer_name
        nvarchar customer_phone
        nvarchar customer_email
        int doctor_id FK
        date appointment_date
        time appointment_time
        nvarchar appointment_notes
        nvarchar payos_order_id
        nvarchar payos_transaction_id
        nvarchar payos_signature
        nvarchar payment_gateway_response
        datetime2 created_at
        datetime2 updated_at
        datetime2 paid_at
        datetime2 cancelled_at
        datetime2 refunded_at
        nvarchar notes
        nvarchar internal_notes
        bit is_deleted
    }
    
    paymentinstallments {
        int installment_id PK
        nvarchar bill_id FK
        money total_amount
        money down_payment
        int installment_count
        decimal interest_rate
        int installment_number
        date due_date
        money amount_due
        money amount_paid
        money remaining_amount
        date payment_date
        nvarchar status
        nvarchar payment_method
        nvarchar transaction_id
        money late_fee
        date last_reminder_date
        int reminder_count
        date next_reminder_date
        datetime2 created_at
        datetime2 updated_at
        nvarchar notes
    }
    
    bills ||--o{ paymentinstallments : "has"
    services ||--o{ bills : "billed_for"
    patients ||--o{ bills : "pays"
    users ||--o{ bills : "pays"
    doctors ||--o{ bills : "provides"
```

### 6. Bảng Thông Báo & Chat

```mermaid
erDiagram
    notifications {
        int notification_id PK
        int user_id FK
        nvarchar title
        nvarchar content
        nvarchar type
        int reference_id
        bit is_read
        datetime created_at
        datetime read_at
        nvarchar status
    }
    
    notificationtemplates {
        int template_id PK
        nvarchar type
        nvarchar title_template
        nvarchar content_template
        bit is_active
    }
    
    chatmessages {
        int message_id PK
        int user_id FK
        nvarchar message_content
        int receiver_id FK
        datetime timestamp
    }
    
    users ||--o{ notifications : "receives"
    users ||--o{ chatmessages : "sends"
    users ||--o{ chatmessages : "receives"
```

### 7. Bảng Blog & Nội Dung

```mermaid
erDiagram
    blog {
        int blog_id PK
        nvarchar title
        ntext content
        nvarchar image_url
        datetime created_at
    }
```

## Mối Quan Hệ Chính

### Quan Hệ 1-1:
- `users` ↔ `patients` (qua user_id)
- `users` ↔ `doctors` (qua user_id)  
- `users` ↔ `staff` (qua user_id)
- `appointment` ↔ `medicalreport` (1 lịch hẹn = 1 báo cáo)

### Quan Hệ 1-Nhiều:
- `users` → `relatives` (1 user có thể có nhiều người thân)
- `users` → `userfaceimages` (1 user có thể có nhiều ảnh khuôn mặt)
- `doctors` → `doctorschedule` (1 bác sĩ có nhiều lịch làm việc)
- `staff` → `staffschedule` (1 nhân viên có nhiều lịch làm việc)
- `appointment` → `reexamination` (1 lịch hẹn có thể có nhiều yêu cầu tái khám)
- `medicalreport` → `prescription` (1 báo cáo có thể có nhiều đơn thuốc)
- `bills` → `paymentinstallments` (1 hóa đơn có thể trả góp nhiều đợt)

### Quan Hệ Nhiều-Nhiều:
- `appointment` ↔ `timeslot` (qua slot_id)
- `doctorschedule` ↔ `timeslot` (qua slot_id)
- `staffschedule` ↔ `timeslot` (qua slot_id)

## Các Ràng Buộc Quan Trọng

### Check Constraints:
- `appointment.status`: 'BOOKED', 'COMPLETED', 'CANCELLED', 'WAITING_PAYMENT'
- `bills.payment_status`: 'pending', 'paid', 'cancelled', 'refunded'
- `users.role`: 'MANAGER', 'DOCTOR', 'PATIENT', 'STAFF'
- `staff.employment_type`: 'fulltime', 'parttime'
- `staff.status`: 'active', 'inactive', 'suspended', 'terminated'

### Unique Constraints:
- `users.email` - Email duy nhất
- `doctors.license_number` - Số giấy phép bác sĩ duy nhất
- `doctors.user_id` - 1 user chỉ có thể là 1 doctor
- `patients.user_id` - 1 user chỉ có thể là 1 patient
- `staff.user_id` - 1 user chỉ có thể là 1 staff
- `bills.order_id` - Mã đơn hàng duy nhất

### Foreign Key Constraints:
- Tất cả các khóa ngoại đều có ràng buộc tham chiếu
- Có trigger tự động cập nhật `updated_at` cho `bills` và `staff`

## Indexes Quan Trọng

### Performance Indexes:
- `IX_Bills_CreatedAt` - Tìm kiếm hóa đơn theo ngày tạo
- `IX_Bills_Status` - Lọc hóa đơn theo trạng thái
- `IX_Services_Category` - Lọc dịch vụ theo danh mục
- `IX_Staff_Department` - Lọc nhân viên theo phòng ban
- `IX_UserFaceImages_UserId` - Tìm kiếm ảnh khuôn mặt theo user

## Ghi Chú Thiết Kế

1. **Phân Quyền**: Hệ thống sử dụng role-based access control với 4 vai trò chính
2. **Lịch Hẹn**: Hỗ trợ đặt lịch cho người thân và tái khám
3. **Thanh Toán**: Hỗ trợ trả góp và tích hợp PayOS
4. **Face ID**: Lưu trữ ảnh khuôn mặt và vector đặc trưng cho xác thực
5. **Lịch Làm Việc**: Quản lý lịch bác sĩ và nhân viên với phê duyệt
6. **Báo Cáo Y Tế**: Tích hợp chữ ký số và đơn thuốc
7. **Thông Báo**: Hệ thống template và real-time chat 