# 📊 BẢNG TỔNG HỢP LUỒNG THANH TOÁN & EMAIL

## 🔄 LUỒNG XỬ LÝ CHÍNH

| Bước | Servlet/Class | Chức năng | Input | Output |
|------|---------------|-----------|-------|--------|
| 1 | `BookingPageServlet` | Hiển thị dịch vụ/bác sĩ | - | Danh sách services, doctors, slots |
| 2 | `PayOSServlet.createPayment()` | Tạo thanh toán | serviceId, doctorId, slotId | Bill + QR Code |
| 3 | `AppointmentDAO.createReservation()` | Tạm khóa slot | doctorId, date, slotId | SlotReservation |
| 4 | JavaScript Polling | Kiểm tra thanh toán | orderId | Payment status |
| 5 | `PayOSServlet.checkStatus()` | Detect payment | orderId | Success/Failed |
| 6 | `AppointmentDAO.completeReservation()` | Hoàn tất lịch hẹn | appointmentId | Appointment record |
| 7 | `N8nWebhookService.sendPaymentSuccessWithCalendar()` | Gửi email + calendar | User/Doctor info | Email + Calendar event |

---

## 📁 CÁC FILE LIÊN QUAN

### 🎯 **SERVLETS**

| File | Vị trí | Chức năng | Methods chính |
|------|--------|-----------|---------------|
| `PayOSServlet.java` | `src/java/controller/` | Xử lý thanh toán chính | `handleCreatePayment()`, `handlePaymentSuccess()`, `handleCheckPaymentStatus()` |
| `BookingPageServlet.java` | `src/java/controller/` | Trang đặt lịch | `doGet()`, `doPost()` |
| `PaymentConfirmServlet.java` | `src/java/controller/` | Xác nhận thanh toán | `doGet()` |
| `WebhookTestServlet.java` | `src/java/controller/` | Test webhook | `doGet()` |

### 🗄️ **DAO CLASSES**

| File | Vị trí | Chức năng | Methods chính |
|------|--------|-----------|---------------|
| `BillDAO.java` | `src/java/dao/` | Quản lý hóa đơn | `createBill()`, `updatePaymentStatus()`, `getBillByOrderId()` |
| `AppointmentDAO.java` | `src/java/dao/` | Quản lý lịch hẹn | `createReservation()`, `completeReservation()`, `insertAppointmentBySlotId()` |
| `PatientDAO.java` | `src/java/dao/` | Quản lý bệnh nhân | `getPatientByUserId()`, `getPatientById()` |
| `DoctorDAO.java` | `src/java/dao/` | Quản lý bác sĩ | `getDoctorEmailByDoctorId()`, `getDoctorNameById()` |
| `ServiceDAO.java` | `src/java/dao/` | Quản lý dịch vụ | `getServiceById()`, `getAllServices()` |
| `TimeSlotDAO.java` | `src/java/dao/` | Quản lý slot thời gian | `getTimeSlotById()`, `getAvailableSlots()` |
| `UserDAO.java` | `src/java/dao/` | Quản lý user | `getUserById()`, `getUserByEmail()` |
| `RelativesDAO.java` | `src/java/dao/` | Quản lý người thân | `updateRelative()`, `getOrCreateRelative()` |

### 📋 **MODEL CLASSES**

| File | Vị trí | Chức năng | Fields chính |
|------|--------|-----------|--------------|
| `Bill.java` | `src/java/model/` | Model hóa đơn | `billId`, `orderId`, `amount`, `paymentStatus`, `doctorId`, `appointmentDate` |
| `Appointment.java` | `src/java/model/` | Model lịch hẹn | `appointmentId`, `patientId`, `doctorId`, `slotId`, `workDate`, `status` |
| `Patients.java` | `src/java/model/` | Model bệnh nhân | `patientId`, `userId`, `fullName`, `phone`, `email` |
| `User.java` | `src/java/model/` | Model user | `id`, `username`, `email`, `password`, `role` |
| `Service.java` | `src/java/model/` | Model dịch vụ | `serviceId`, `serviceName`, `description`, `price` |
| `TimeSlot.java` | `src/java/model/` | Model slot thời gian | `slotId`, `startTime`, `endTime`, `isAvailable` |
| `SlotReservation.java` | `src/java/model/` | Model đặt chỗ tạm thời | `appointmentId`, `doctorId`, `slotId`, `workDate`, `status` |

### 🌐 **JSP PAGES**

| File | Vị trí | Chức năng | Servlet gọi |
|------|--------|-----------|-------------|
| `payment.jsp` | `web/` | Trang thanh toán | `PayOSServlet?action=create` |
| `payment-success.jsp` | `web/` | Trang thành công | `PayOSServlet?action=success` |
| `payment-cancel.jsp` | `web/` | Trang hủy thanh toán | `PayOSServlet?action=cancel` |
| `booking.jsp` | `web/` | Trang đặt lịch | `BookingPageServlet` |
| `datlich-thanhcong.jsp` | `web/jsp/patient/` | Thông báo đặt lịch thành công | - |
| `medicalreportdetail.jsp` | `web/jsp/patient/` | Chi tiết báo cáo y tế | - |
| `doctor_trongngay.jsp` | `web/jsp/doctor/` | Danh sách lịch hẹn bác sĩ | - |

### 🛠️ **UTILITY CLASSES**

| File | Vị trí | Chức năng | Methods chính |
|------|--------|-----------|---------------|
| `N8nWebhookService.java` | `src/java/utils/` | Service gửi email/calendar | `sendPaymentSuccessWithCalendar()`, `createGoogleCalendarEventDirect()` |
| `PayOSConfig.java` | `src/java/utils/` | Cấu hình PayOS | `CLIENT_ID`, `API_KEY`, `CHECKSUM_KEY` |
| `DBContext.java` | `src/java/utils/` | Kết nối database | `getConnection()` |
| `CloudflareService.java` | `src/java/utils/` | Service CDN | - |

---

## 📧 LUỒNG GỬI EMAIL

### 🎯 **CÁC METHOD GỬI EMAIL**

| Method | Trigger | N8N Workflow | Chức năng |
|--------|---------|--------------|-----------|
| `sendPaymentSuccessWithCalendar()` | Thanh toán thành công | `send-appointment-email` | Gửi email + tạo calendar |
| `createGoogleCalendarEventDirect()` | Test payment | `create-google-calendar-event` | Chỉ tạo calendar |
| `sendAppointmentReminderToN8n()` | Nhắc nhở lịch hẹn | `send-appointment-email` | Gửi reminder |

### 🔗 **N8N WEBHOOK URLs**

| Workflow | URL | Chức năng | JSON Fields |
|----------|-----|-----------|-------------|
| `send-appointment-email` | `https://kinggg123.app.n8n.cloud/webhook/send-appointment-email` | Email + Calendar | `type`, `to`, `userName`, `doctorEmail`, `appointmentDate`, `billAmount` |
| `create-google-calendar-event` | `https://kinggg123.app.n8n.cloud/webhook/create-google-calendar-event` | Chỉ Calendar | `userEmail`, `doctorEmail`, `startDateTime`, `endDateTime`, `attendees` |

---

## 🗄️ **DATABASE TABLES**

### 📊 **BẢNG CHÍNH**

| Bảng | Chức năng | Fields quan trọng | Quan hệ |
|------|-----------|-------------------|---------|
| `Bills` | Lưu hóa đơn | `billId`, `orderId`, `amount`, `paymentStatus`, `doctorId`, `appointmentDate` | FK: `serviceId`, `patientId`, `userId` |
| `Appointment` | Lưu lịch hẹn | `appointmentId`, `patientId`, `doctorId`, `slotId`, `workDate`, `status` | FK: `patientId`, `doctorId`, `slotId` |
| `TimeSlot` | Quản lý slot thời gian | `slotId`, `startTime`, `endTime`, `isAvailable` | - |
| `Patients` | Thông tin bệnh nhân | `patientId`, `userId`, `fullName`, `phone`, `email` | FK: `userId` |
| `users` | Thông tin user | `id`, `username`, `email`, `password`, `role` | - |
| `Doctors` | Thông tin bác sĩ | `doctorId`, `userId`, `fullName`, `email`, `phone` | FK: `userId` |
| `Services` | Thông tin dịch vụ | `serviceId`, `serviceName`, `description`, `price` | - |

### 🔗 **QUAN HỆ BẢNG**

```
users (1) ←→ (1) Patients
users (1) ←→ (1) Doctors
Services (1) ←→ (N) Bills
Patients (1) ←→ (N) Bills
Patients (1) ←→ (N) Appointment
Doctors (1) ←→ (N) Appointment
TimeSlot (1) ←→ (N) Appointment
```

---

## 🚀 **TRIGGER POINTS**

### 📍 **ĐIỂM GỬI EMAIL**

| Trigger | Location | Method | Điều kiện |
|---------|----------|--------|-----------|
| Thanh toán thành công | `PayOSServlet.java:580` | `sendPaymentSuccessWithCalendar()` | `reservationCompleted == true` |
| Test payment | `PayOSServlet.java:1500` | `sendPaymentSuccessWithCalendar()` | `updated == true` |
| Auto-detection | `PayOSServlet.java:1000` | `sendPaymentSuccessWithCalendar()` | `paymentDetected == true` |

### 🔍 **ANTI-SPAM CACHE**

| Cache Type | Key Format | Location | Purpose |
|------------|------------|----------|---------|
| Email Cache | `billId + "_" + userEmail` | `N8nWebhookService.java:20` | Tránh gửi email duplicate |
| Calendar Cache | `billId + "_calendar"` | `N8nWebhookService.java:25` | Tránh tạo calendar duplicate |

---

## 🛠️ **TROUBLESHOOTING**

### ❌ **LỖI THƯỜNG GẶP**

| Lỗi | Nguyên nhân | Giải pháp | File kiểm tra |
|-----|-------------|-----------|---------------|
| Email không gửi | N8N workflow URL sai | Kiểm tra URL trong `N8nWebhookService.java` | `N8nWebhookService.java:15` |
| Calendar không tạo | Google API credentials sai | Kiểm tra N8N Google Calendar node | N8N Workflow |
| Thanh toán không detect | PayOS config sai | Kiểm tra `PayOSConfig.java` | `PayOSConfig.java` |
| Database error | Connection string sai | Kiểm tra `DBContext.java` | `DBContext.java` |

### 🔧 **DEBUG LOGS**

| Log Type | Location | Format | Purpose |
|----------|----------|--------|---------|
| Payment Logs | `PayOSServlet.java` | `System.out.println()` | Debug thanh toán |
| Email Logs | `N8nWebhookService.java` | `System.out.println()` | Debug email sending |
| Database Logs | Các DAO classes | `System.err.println()` | Debug database |

---

## 📝 **GHI CHÚ QUAN TRỌNG**

| Yếu tố | Yêu cầu | File liên quan |
|--------|---------|----------------|
| Timezone | +07:00 (Việt Nam) | `N8nWebhookService.java` |
| Email Format | RFC 5322 | `N8nWebhookService.java:150` |
| JSON Escape | Escape ký tự đặc biệt | `N8nWebhookService.java:140` |
| Session Management | Lưu payment info | `PayOSServlet.java` |
| Error Handling | Try-catch everywhere | Tất cả files |
| Database Transaction | Consistency | Các DAO classes |

---

## 🔄 **LUỒNG HOÀN CHỈNH (FLOWCHART)**

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   User      │    │ BookingPage │    │ PayOS       │    │ N8N         │
│   Action    │───►│ Servlet     │───►│ Servlet     │───►│ Workflow    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   JSP       │    │   DAO       │    │   Database  │    │   Email     │
│   Pages     │    │   Classes   │    │   (MySQL)   │    │   + Calendar│
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

**Hệ thống đảm bảo:**
- ✅ Thanh toán an toàn với PayOS
- ✅ Email xác nhận tự động  
- ✅ Google Calendar integration
- ✅ Anti-spam protection
- ✅ Error handling đầy đủ
- ✅ Real-time payment detection 