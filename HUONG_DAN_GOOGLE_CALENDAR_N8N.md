# 📅 HƯỚNG DẪN CẤU HÌNH N8N GOOGLE CALENDAR WORKFLOW

## 🎯 TỔNG QUAN
Hướng dẫn này sẽ giúp bạn tạo N8N workflow để tự động tạo lịch hẹn trên Google Calendar cho cả **User** và **Doctor** khi thanh toán thành công.

## 🔧 THIẾT LẬP TRƯỚC KHI BẮT ĐẦU

### 1. Cấu hình Google Calendar API
1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project hiện có
3. Bật Google Calendar API:
   - Vào **APIs & Services** > **Library**
   - Tìm "Google Calendar API" và bật
4. Tạo Service Account hoặc OAuth2 credentials:
   - Vào **APIs & Services** > **Credentials**
   - Tạo **Service Account** cho server-to-server
   - Tải file JSON credentials

### 2. Tạo Webhook Endpoint mới trong N8N
```
URL: https://kinggg123.app.n8n.cloud/webhook/create-calendar-event
Method: POST
```

## 🔄 N8N WORKFLOW CẤU HÌNH

### BƯỚC 1: Webhook Trigger Node
```json
{
  "name": "Webhook - Calendar Event",
  "type": "n8n-nodes-base.webhook",
  "parameters": {
    "path": "create-calendar-event",
    "httpMethod": "POST",
    "responseMode": "responseNode"
  }
}
```

### BƯỚC 2: Code Node - Xử lý dữ liệu
```javascript
// Lấy dữ liệu từ webhook
const webhookData = $json.body;

// Kiểm tra loại webhook
if (webhookData.type !== 'calendar_event') {
  return [{
    json: {
      error: "Invalid webhook type",
      expected: "calendar_event",
      received: webhookData.type
    }
  }];
}

// Tạo object calendar event
const calendarEvent = {
  summary: webhookData.eventTitle || `Lịch khám - ${webhookData.serviceName}`,
  description: webhookData.eventDescription || `
🏥 Dịch vụ: ${webhookData.serviceName}
👤 Bệnh nhân: ${webhookData.userName}
📞 SĐT: ${webhookData.userPhone}
👨‍⚕️ Bác sĩ: ${webhookData.doctorName}
📍 Địa điểm: ${webhookData.location}
📝 Lý do: ${webhookData.reason}
💼 Mã hóa đơn: ${webhookData.billId}
  `,
  start: {
    dateTime: webhookData.startDateTime,
    timeZone: 'Asia/Ho_Chi_Minh'
  },
  end: {
    dateTime: webhookData.endDateTime,
    timeZone: 'Asia/Ho_Chi_Minh'
  },
  location: webhookData.location,
  attendees: [
    { email: webhookData.userEmail, displayName: webhookData.userName },
    { email: webhookData.doctorEmail, displayName: webhookData.doctorName }
  ],
  reminders: {
    useDefault: false,
    overrides: [
      { method: 'email', minutes: 1440 }, // 1 day before
      { method: 'popup', minutes: 30 }    // 30 minutes before
    ]
  }
};

return [{
  json: {
    calendarEvent: calendarEvent,
    userEmail: webhookData.userEmail,
    doctorEmail: webhookData.doctorEmail,
    userName: webhookData.userName,
    doctorName: webhookData.doctorName,
    billId: webhookData.billId
  }
}];
```

### BƯỚC 3: Google Calendar Node - Tạo Event trên Calendar User
```json
{
  "name": "Create User Calendar Event",
  "type": "n8n-nodes-base.googleCalendar",
  "parameters": {
    "operation": "create",
    "calendarId": "{{ $json.userEmail }}",
    "summary": "{{ $json.calendarEvent.summary }}",
    "description": "{{ $json.calendarEvent.description }}",
    "start": {
      "dateTime": "{{ $json.calendarEvent.start.dateTime }}",
      "timeZone": "{{ $json.calendarEvent.start.timeZone }}"
    },
    "end": {
      "dateTime": "{{ $json.calendarEvent.end.dateTime }}",
      "timeZone": "{{ $json.calendarEvent.end.timeZone }}"
    },
    "location": "{{ $json.calendarEvent.location }}",
    "attendees": "{{ $json.calendarEvent.attendees }}",
    "reminders": "{{ $json.calendarEvent.reminders }}"
  }
}
```

### BƯỚC 4: Google Calendar Node - Tạo Event trên Calendar Doctor
```json
{
  "name": "Create Doctor Calendar Event",
  "type": "n8n-nodes-base.googleCalendar",
  "parameters": {
    "operation": "create",
    "calendarId": "{{ $json.doctorEmail }}",
    "summary": "{{ $json.calendarEvent.summary }}",
    "description": "{{ $json.calendarEvent.description }}",
    "start": {
      "dateTime": "{{ $json.calendarEvent.start.dateTime }}",
      "timeZone": "{{ $json.calendarEvent.start.timeZone }}"
    },
    "end": {
      "dateTime": "{{ $json.calendarEvent.end.dateTime }}",
      "timeZone": "{{ $json.calendarEvent.end.timeZone }}"
    },
    "location": "{{ $json.calendarEvent.location }}",
    "attendees": "{{ $json.calendarEvent.attendees }}",
    "reminders": "{{ $json.calendarEvent.reminders }}"
  }
}
```

### BƯỚC 5: Response Node - Trả về kết quả
```javascript
// Success response
return [{
  json: {
    success: true,
    message: "Calendar events created successfully",
    userEventId: $('Create User Calendar Event').first().json.id,
    doctorEventId: $('Create Doctor Calendar Event').first().json.id,
    billId: $json.billId,
    timestamp: new Date().toISOString()
  }
}];
```

## 🔑 CẤU HÌNH GOOGLE CALENDAR CREDENTIALS

### 1. Service Account Method (Khuyến nghị)
```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "your-service-account@your-project.iam.gserviceaccount.com",
  "client_id": "your-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token"
}
```

### 2. Cấp quyền cho Service Account
1. Với **User Calendar**: User phải share calendar với service account email
2. Với **Doctor Calendar**: Doctor phải share calendar với service account email

```
Cách share:
1. Mở Google Calendar
2. Vào Settings & sharing của calendar cần share  
3. Thêm service account email vào "Share with specific people"
4. Cấp quyền "Make changes to events"
```

## 📊 DỮ LIỆU WEBHOOK GỬI TỪ JAVA

### Cấu trúc JSON từ N8nWebhookService.createGoogleCalendarEvent():
```json
{
  "type": "calendar_event",
  "userEmail": "user@example.com",
  "userName": "Nguyễn Văn A",
  "userPhone": "0901234567",
  "doctorEmail": "doctor@clinic.com",
  "doctorName": "BS. Trần Văn B",
  "eventTitle": "Lịch khám - Nhổ răng khôn",
  "eventDescription": "🏥 Dịch vụ: Nhổ răng khôn\n👤 Bệnh nhân: Nguyễn Văn A\n📞 SĐT: 0901234567\n👨‍⚕️ Bác sĩ: BS. Trần Văn B\n📍 Địa điểm: FPT University Đà Nẵng\n📝 Lý do: Răng khôn mọc lệch\n💼 Mã hóa đơn: BILL_123456",
  "startDateTime": "2024-12-06T08:00:00",
  "endDateTime": "2024-12-06T08:30:00", 
  "location": "FPT University Đà Nẵng",
  "attendeeEmails": ["user@example.com", "doctor@clinic.com"],
  "appointmentDate": "2024-12-06",
  "appointmentTime": "08:00 - 08:30",
  "serviceName": "Nhổ răng khôn",
  "billId": "BILL_123456",
  "clinicName": "Phòng khám Nha khoa DentalClinic",
  "reason": "Răng khôn mọc lệch",
  "timestamp": "2024-12-05T10:30:45.123"
}
```

## 🔧 WORKFLOW HOÀN CHỈNH

### Tổng kết luồng xử lý:
```
1. Java Backend → POST webhook data
2. N8N Webhook Node → nhận data
3. Code Node → xử lý và format data
4. Google Calendar Node (User) → tạo event cho user
5. Google Calendar Node (Doctor) → tạo event cho doctor  
6. Response Node → trả về success/error
```

## 🚀 TEST WORKFLOW

### 1. Test từ N8N UI
```json
{
  "type": "calendar_event",
  "userEmail": "test.user@gmail.com",
  "userName": "Test User",
  "userPhone": "0901234567", 
  "doctorEmail": "test.doctor@gmail.com",
  "doctorName": "Test Doctor",
  "startDateTime": "2024-12-10T09:00:00",
  "endDateTime": "2024-12-10T09:30:00",
  "serviceName": "Test Service",
  "billId": "TEST_001",
  "location": "Test Clinic",
  "reason": "Test appointment"
}
```

### 2. Test từ Java Application
```bash
# Đặt lịch và thanh toán thử nghiệm
# Hệ thống sẽ tự động gửi cả email và calendar webhook
```

## ⚠️ LƯU Ý QUAN TRỌNG

### 1. Quyền truy cập Calendar
- User và Doctor phải cấp quyền cho Service Account
- Calendar phải được set "public" hoặc shared properly

### 2. Timezone
- Luôn sử dụng `Asia/Ho_Chi_Minh` cho Việt Nam
- Đảm bảo format datetime đúng ISO 8601

### 3. Error Handling
```javascript
// Thêm try-catch trong các Code Node
try {
  // Calendar creation logic
} catch (error) {
  return [{
    json: {
      error: true,
      message: error.message,
      billId: $json.billId
    }
  }];
}
```

### 4. Webhook Security  
```javascript
// Validate webhook source trong N8N
const validSources = ['localhost:8080', 'your-domain.com'];
const origin = $request.headers.origin;

if (!validSources.includes(origin)) {
  return [{ json: { error: "Unauthorized" } }];
}
```

## 📱 KẾT QUẢ MONG ĐỢI

Sau khi cấu hình thành công:

1. **User thanh toán** → Hệ thống tự động:
   - ✅ Gửi email xác nhận
   - ✅ Tạo event trên Google Calendar của User
   - ✅ Tạo event trên Google Calendar của Doctor
   - ✅ Gửi invite notification cho cả hai

2. **Calendar Events bao gồm**:
   - 📅 Thời gian chính xác
   - 📍 Địa điểm phòng khám
   - 👥 Attendees (User + Doctor)
   - 🔔 Reminder notifications
   - 📝 Thông tin chi tiết appointment

## 🔗 LIÊN KẾT QUAN TRỌNG

- [Google Calendar API Documentation](https://developers.google.com/calendar/api)
- [N8N Google Calendar Node](https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlecalendar/)
- [Service Account Setup](https://developers.google.com/identity/protocols/oauth2/service-account)

---

**🎉 Chúc bạn cấu hình thành công! Hệ thống sẽ tự động tạo lịch Google Calendar cho mọi appointment.** 