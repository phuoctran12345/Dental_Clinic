# 🔄 LUỒNG XỬ LÝ THANH TOÁN & GỬI EMAIL

## 📋 TỔNG QUAN HỆ THỐNG

Hệ thống thanh toán và gửi email được xây dựng với 2 thành phần chính:
- **PayOSServlet**: Xử lý thanh toán PayOS + tạo lịch hẹn
- **N8nWebhookService**: Gửi email + tạo Google Calendar thông qua N8N workflow

---

## 🏗️ KIẾN TRÚC TỔNG THỂ

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   External      │
│   (JSP Pages)   │◄──►│   (Servlets)    │◄──►│   (N8N + APIs)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Database      │    │   Email Service │    │   Google        │
│   (MySQL)       │    │   (N8N)         │    │   Calendar      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 🔄 LUỒNG XỬ LÝ CHI TIẾT

### 1. 📅 LUỒNG ĐẶT LỊCH & THANH TOÁN

#### **Bước 1: Chọn dịch vụ và bác sĩ**
- **JSP**: `booking.jsp` → `BookingPageServlet`
- **DAO**: `ServiceDAO`, `DoctorDAO`, `TimeSlotDAO`
- **Chức năng**: Hiển thị danh sách dịch vụ, bác sĩ, slot thời gian

#### **Bước 2: Tạo thanh toán**
- **JSP**: `payment.jsp` ← `PayOSServlet?action=create`
- **DAO**: `BillDAO`, `AppointmentDAO`, `PatientDAO`
- **Chức năng**: 
  - Tạo Bill record
  - Tạo SlotReservation (tạm khóa slot 5 phút)
  - Tạo QR code PayOS
  - Lưu thông tin vào session

#### **Bước 3: Thanh toán**
- **Frontend**: JavaScript polling `PayOSServlet?action=checkStatus`
- **Backend**: `PayOSServlet.handleCheckPaymentStatus()`
- **Chức năng**: Kiểm tra trạng thái thanh toán real-time

#### **Bước 4: Xử lý thành công**
- **Servlet**: `PayOSServlet.handlePaymentSuccess()`
- **DAO**: `BillDAO.updatePaymentStatus()`, `AppointmentDAO.completeReservation()`
- **Chức năng**: 
  - Cập nhật trạng thái thanh toán
  - Tạo appointment record
  - Gửi email + tạo calendar

---

### 2. 📧 LUỒNG GỬI EMAIL & CALENDAR

#### **A. GỬI EMAIL THÔNG BÁO THANH TOÁN**

**Trigger**: Khi thanh toán thành công
**Method**: `N8nWebhookService.sendPaymentSuccessWithCalendar()`

```java
// PayOSServlet.java - Dòng 580-620
N8nWebhookService.sendPaymentSuccessWithCalendar(
    userEmail,           // Email khách hàng
    userName,            // Tên khách hàng  
    userPhone,           // SĐT khách hàng
    doctorEmail,         // Email bác sĩ
    doctorName,          // Tên bác sĩ
    appointmentDate,     // Ngày khám
    appointmentTime,     // Giờ khám
    serviceName,         // Tên dịch vụ
    billId,              // Mã hóa đơn
    orderId,             // Mã đơn hàng
    billAmount,          // Số tiền
    clinicName,          // Tên phòng khám
    clinicAddress,       // Địa chỉ
    clinicPhone,         // SĐT phòng khám
    reason               // Lý do khám
);
```

**N8N Workflow**: `send-appointment-email`
- **URL**: `https://kinggg123.app.n8n.cloud/webhook/send-appointment-email`
- **Chức năng**: Gửi email xác nhận thanh toán + tạo Google Calendar event

#### **B. TẠO GOOGLE CALENDAR EVENT**

**Method**: `N8nWebhookService.createGoogleCalendarEventDirect()`

```java
// PayOSServlet.java - Dòng 650-680 (Test Payment)
N8nWebhookService.createGoogleCalendarEventDirect(
    userEmail,           // Email bệnh nhân
    userName,            // Tên bệnh nhân
    userPhone,           // SĐT bệnh nhân
    doctorEmail,         // Email bác sĩ
    doctorName,          // Tên bác sĩ
    appointmentDate,     // Ngày khám
    appointmentTime,     // Giờ khám
    serviceName,         // Dịch vụ
    billId,              // Mã hóa đơn
    billAmount,          // Số tiền
    location             // Địa điểm
);
```

**N8N Workflow**: `create-google-calendar-event`
- **URL**: `https://kinggg123.app.n8n.cloud/webhook/create-google-calendar-event`
- **Chức năng**: Tạo event trong Google Calendar cho cả bệnh nhân và bác sĩ

---

## 📁 CÁC FILE LIÊN QUAN

### **Servlets**
```
src/java/controller/
├── PayOSServlet.java              # Xử lý thanh toán chính
├── BookingPageServlet.java        # Trang đặt lịch
├── PaymentConfirmServlet.java     # Xác nhận thanh toán
└── WebhookTestServlet.java        # Test webhook
```

### **DAO Classes**
```
src/java/dao/
├── BillDAO.java                   # Quản lý hóa đơn
├── AppointmentDAO.java            # Quản lý lịch hẹn
├── PatientDAO.java                # Quản lý bệnh nhân
├── DoctorDAO.java                 # Quản lý bác sĩ
├── ServiceDAO.java                # Quản lý dịch vụ
├── TimeSlotDAO.java               # Quản lý slot thời gian
├── UserDAO.java                   # Quản lý user
└── RelativesDAO.java              # Quản lý người thân
```

### **Model Classes**
```
src/java/model/
├── Bill.java                      # Model hóa đơn
├── Appointment.java               # Model lịch hẹn
├── Patients.java                  # Model bệnh nhân
├── User.java                      # Model user
├── Service.java                   # Model dịch vụ
├── TimeSlot.java                  # Model slot thời gian
└── SlotReservation.java           # Model đặt chỗ tạm thời
```

### **JSP Pages**
```
web/
├── payment.jsp                    # Trang thanh toán
├── payment-success.jsp            # Trang thành công
├── payment-cancel.jsp             # Trang hủy thanh toán
├── booking.jsp                    # Trang đặt lịch
└── jsp/
    ├── patient/
    │   ├── datlich-thanhcong.jsp  # Thông báo đặt lịch thành công
    │   └── medicalreportdetail.jsp # Chi tiết báo cáo y tế
    └── doctor/
        └── doctor_trongngay.jsp   # Danh sách lịch hẹn bác sĩ
```

### **Utility Classes**
```
src/java/utils/
├── N8nWebhookService.java         # Service gửi email/calendar
├── PayOSConfig.java               # Cấu hình PayOS
├── DBContext.java                 # Kết nối database
└── CloudflareService.java         # Service CDN
```

---

## 🔧 CẤU HÌNH N8N WORKFLOW

### **Workflow 1: send-appointment-email**
```json
{
  "type": "payment_success",
  "to": "user@email.com",
  "userName": "Tên khách hàng",
  "userPhone": "0123456789",
  "doctorEmail": "doctor@email.com", 
  "doctorName": "Tên bác sĩ",
  "appointmentDate": "2024-01-15",
  "appointmentTime": "09:00 - 09:30",
  "serviceName": "Khám tổng quát",
  "billId": "BILL_ABC123",
  "orderId": "ORDER_123456",
  "billAmount": 100000,
  "formattedAmount": "100,000 VNĐ",
  "clinicName": "Phòng khám Nha khoa",
  "clinicAddress": "FPT University Đà Nẵng",
  "clinicPhone": "0936929382",
  "startDateTime": "2024-01-15T09:00:00+07:00",
  "endDateTime": "2024-01-15T09:30:00+07:00",
  "eventTitle": "Lịch khám - Khám tổng quát",
  "eventDescription": "🏥 Dịch vụ: Khám tổng quát\n👤 Bệnh nhân: Tên khách hàng\n📞 SĐT: 0123456789\n👨‍⚕️ Bác sĩ: Tên bác sĩ\n📍 Địa điểm: FPT University Đà Nẵng\n📝 Lý do: Khám tổng quát\n💼 Mã hóa đơn: BILL_ABC123",
  "location": "FPT University Đà Nẵng",
  "attendees": [
    {"email": "user@email.com"},
    {"email": "doctor@email.com"}
  ],
  "reason": "Khám tổng quát",
  "timestamp": "2024-01-15T08:30:00"
}
```

### **Workflow 2: create-google-calendar-event**
```json
{
  "userEmail": "user@email.com",
  "userName": "Tên khách hàng", 
  "userPhone": "0123456789",
  "doctorEmail": "doctor@email.com",
  "doctorName": "Tên bác sĩ",
  "appointmentDate": "2024-01-15",
  "appointmentTime": "09:00 - 09:30",
  "serviceName": "Khám tổng quát",
  "billId": "BILL_ABC123",
  "formattedAmount": "100,000 VNĐ",
  "startDateTime": "2024-01-15T09:00:00+07:00",
  "endDateTime": "2024-01-15T09:30:00+07:00",
  "eventTitle": "🦷 Khám tổng quát - Tên khách hàng",
  "location": "FPT University Đà Nẵng",
  "attendees": [
    {"email": "user@email.com"},
    {"email": "doctor@email.com"}
  ]
}
```

---

## 🚀 CÁC TRIGGER ĐIỂM GỬI EMAIL

### **1. Thanh toán thành công (PayOSServlet)**
```java
// Dòng 580-620 trong PayOSServlet.java
if (reservationCompleted) {
    // Gửi email + calendar
    N8nWebhookService.sendPaymentSuccessWithCalendar(...);
}
```

### **2. Test payment (Demo)**
```java
// Dòng 1500-1550 trong PayOSServlet.java
if (updated) {
    // Gửi email test
    N8nWebhookService.sendPaymentSuccessWithCalendar(...);
    // Tạo calendar riêng
    N8nWebhookService.createGoogleCalendarEventDirect(...);
}
```

### **3. Auto-detection payment**
```java
// Dòng 1000-1050 trong PayOSServlet.java
if (paymentDetected) {
    // Gửi email khi phát hiện thanh toán tự động
    N8nWebhookService.sendPaymentSuccessWithCalendar(...);
}
```

---

## 🔍 ANTI-SPAM MECHANISM

### **Cache System**
```java
// N8nWebhookService.java - Dòng 20-25
private static final Set<String> sentEmails = ConcurrentHashMap.newKeySet();
private static final Set<String> createdEvents = ConcurrentHashMap.newKeySet();
```

### **Duplicate Prevention**
```java
// Kiểm tra email đã gửi
String emailKey = billId + "_" + userEmail;
if (sentEmails.contains(emailKey)) {
    System.out.println("🚫 ANTI-SPAM: Email đã được gửi cho " + billId);
    return;
}

// Kiểm tra calendar đã tạo
String eventKey = billId + "_calendar";
if (createdEvents.contains(eventKey)) {
    System.out.println("🚫 ANTI-SPAM: Calendar event đã được tạo cho " + billId);
    return;
}
```

---

## 📊 DATABASE TABLES

### **Bảng chính liên quan**
```sql
-- Bảng hóa đơn
Bills (billId, orderId, serviceId, patientId, userId, amount, paymentStatus, doctorId, appointmentDate, appointmentNotes)

-- Bảng lịch hẹn  
Appointment (appointmentId, patientId, doctorId, slotId, workDate, startTime, status, reason, relativeId, bookedByUserId)

-- Bảng slot thời gian
TimeSlot (slotId, startTime, endTime, isAvailable)

-- Bảng bệnh nhân
Patients (patientId, userId, fullName, phone, email, dateOfBirth, gender)

-- Bảng user
users (id, username, email, password, role)

-- Bảng bác sĩ
Doctors (doctorId, userId, fullName, email, phone, specialization)

-- Bảng dịch vụ
Services (serviceId, serviceName, description, price)
```

---

## 🛠️ TROUBLESHOOTING

### **Lỗi thường gặp**

1. **Email không gửi được**
   - Kiểm tra N8N workflow URL
   - Kiểm tra email format
   - Kiểm tra anti-spam cache

2. **Calendar không tạo được**
   - Kiểm tra Google Calendar API credentials
   - Kiểm tra datetime format (ISO 8601)
   - Kiểm tra attendees email

3. **Thanh toán không detect**
   - Kiểm tra PayOS API configuration
   - Kiểm tra webhook endpoint
   - Kiểm tra database connection

### **Debug Logs**
```java
// Bật debug logs trong N8nWebhookService
System.out.println("📤 === GỬI THÔNG BÁO THANH TOÁN THÀNH CÔNG ĐẾN N8N ===");
System.out.println("📧 Email khách hàng: " + userEmail);
System.out.println("📤 JSON payload: " + jsonInputString);
System.out.println("🔗 Webhook URL: " + WEBHOOK_URL);
```

---

## 📝 GHI CHÚ QUAN TRỌNG

1. **Timezone**: Tất cả datetime phải có timezone +07:00 (Việt Nam)
2. **Email Validation**: Sử dụng regex RFC 5322 để validate email
3. **JSON Escape**: Escape đặc biệt ký tự trong JSON payload
4. **Error Handling**: Luôn có try-catch và fallback mechanism
5. **Session Management**: Lưu trữ thông tin thanh toán trong session
6. **Database Transaction**: Sử dụng transaction để đảm bảo consistency

---

## 🔄 LUỒNG HOÀN CHỈNH

```
1. User chọn dịch vụ → BookingPageServlet
2. User thanh toán → PayOSServlet.createPayment()
3. Tạo Bill + Reservation → Database
4. User scan QR → PayOS/MB Bank
5. Check payment status → PayOSServlet.checkStatus()
6. Payment success → Update database
7. Create appointment → AppointmentDAO
8. Send email + calendar → N8nWebhookService
9. N8N workflow → Email + Google Calendar
10. Success page → payment-success.jsp
```

Hệ thống này đảm bảo:
- ✅ Thanh toán an toàn với PayOS
- ✅ Email xác nhận tự động
- ✅ Google Calendar integration
- ✅ Anti-spam protection
- ✅ Error handling đầy đủ
- ✅ Real-time payment detection 