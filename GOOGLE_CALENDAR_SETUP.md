# 📅 Hướng Dẫn Setup Google Calendar Integration

## 🎯 Tổng Quan
Hệ thống sẽ tự động tạo Google Calendar event cho cả bệnh nhân và bác sĩ sau khi thanh toán thành công.

## 🔧 Setup N8N Workflow

### Bước 1: Cấu hình Code Node
1. Mở N8N workflow: `https://kinggg123.app.n8n.cloud/`
2. Thêm **Code Node** giữa "Send a message" và "Google Calendar"
3. Copy toàn bộ nội dung từ file `web/n8n_code_node.js` vào Code Node
4. Save workflow

### Bước 2: Cấu hình Google Calendar Node
1. **Calendar**: Chọn `de180577tranhongphuoc@gmail.com`
2. **Summary**: `{{$json.summary}}`
3. **Description**: `{{$json.description}}`
4. **Start**: `{{$json.start}}`
5. **End**: `{{$json.end}}`
6. **Location**: `{{$json.location}}`
7. **Attendees**: `{{$json.attendees}}`

## 🚀 Test Workflow

### Option 1: Sử dụng Test Page
1. Truy cập: `http://localhost:8080/TestFull/test_calendar.jsp`
2. Nhấn **"Test N8N Direct"** để test trực tiếp
3. Kiểm tra console và Google Calendar

### Option 2: Test qua Payment Flow
1. Đặt lịch khám bình thường qua website
2. Hoàn thành thanh toán (hoặc dùng Test Payment)
3. Kiểm tra email và Google Calendar

### Option 3: Manual Test qua PayOS
1. Truy cập: `http://localhost:8080/TestFull/payment?action=testPayment`
2. Với params: `billId=BILL_TEST&orderId=ORDER_TEST`

## 📊 Luồng Dữ Liệu

```
Java Backend → N8N Webhook → Send Email → Code Node → Google Calendar
```

### Data Format từ Java:
```json
{
  "type": "payment_success",
  "userEmail": "phuocthde180577@fpt.edu.vn",
  "doctorEmail": "de180577tranhongphuoc@gmail.com",
  "userName": "Tên Bệnh Nhân",
  "doctorName": "Tên Bác Sĩ",
  "appointmentDate": "2025-07-12",
  "appointmentTime": "08:00 - 09:00",
  "serviceName": "Khám răng định kỳ",
  "billId": "BILL_ABC123",
  "startDateTime": "2025-07-12T08:00:00",
  "endDateTime": "2025-07-12T09:00:00",
  "attendees": [
    {"email": "phuocthde180577@fpt.edu.vn"},
    {"email": "de180577tranhongphuoc@gmail.com"}
  ]
}
```

### Data Output từ Code Node:
```json
{
  "summary": "Lịch khám - Khám răng định kỳ",
  "description": "🏥 Dịch vụ: Khám răng...",
  "start": {
    "dateTime": "2025-07-12T08:00:00+07:00",
    "timeZone": "Asia/Ho_Chi_Minh"
  },
  "end": {
    "dateTime": "2025-07-12T09:00:00+07:00",
    "timeZone": "Asia/Ho_Chi_Minh"
  },
  "location": "FPT University Đà Nẵng",
  "attendees": [
    {"email": "phuocthde180577@fpt.edu.vn"},
    {"email": "de180577tranhongphuoc@gmail.com"}
  ]
}
```

## 🔍 Debug và Kiểm Tra

### Kiểm tra Backend Log:
```
🚀 === GỬI EMAIL + CALENDAR THÔNG QUA N8N WORKFLOW ===
📧 Email khách hàng: phuocthde180577@fpt.edu.vn
📧 Email bác sĩ: de180577tranhongphuoc@gmail.com
📅 Start: 2025-07-12T08:00:00
📅 End: 2025-07-12T09:00:00
📨 N8N All-in-One response: 200
✅ ĐÃ GỬI THÀNH CÔNG: Email xác nhận + Google Calendar event!
```

### Kiểm tra N8N Log:
- Webhook node: Nhận được data từ Java
- Code node: Process data thành calendar format
- Google Calendar node: Tạo event thành công

### Kiểm tra Google Calendar:
1. Truy cập: `https://calendar.google.com`
2. Chọn ngày đã test (VD: 12/7/2025)
3. Tìm event với title: "Lịch khám - [Tên dịch vụ]"
4. Click vào event → Check attendees

## ❗ Troubleshooting

### Lỗi: "Cannot read properties of undefined (reading 'split')"
- **Nguyên nhân**: Data format không đúng từ Java
- **Giải pháp**: Kiểm tra format `startDateTime` và `endDateTime`

### Lỗi: Calendar event không xuất hiện
- **Nguyên nhân**: Attendees email không đúng
- **Giải pháp**: Kiểm tra email format trong Java code

### Lỗi: N8N response 400
- **Nguyên nhân**: Google Calendar API credentials
- **Giải pháp**: Re-authenticate Google Calendar trong N8N

## 📧 Contact Support
- Email: phuocthde180577@fpt.edu.vn
- Doctor: de180577tranhongphuoc@gmail.com

## 🎉 Kết Quả Mong Đợi
Sau khi setup thành công:
1. ✅ Email xác nhận thanh toán được gửi
2. ✅ Google Calendar event được tạo cho cả bệnh nhân và bác sĩ  
3. ✅ Event hiển thị đúng thời gian, địa điểm, attendees
4. ✅ Both parties receive calendar invitation 