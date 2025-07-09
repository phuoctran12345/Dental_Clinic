# 🧪 TEST ĐẶT LỊCH CHO NGƯỜI THÂN

## **Mục tiêu:**
- Đặt lịch cho người thân thành công
- Thông tin người thân lưu đúng vào database (không còn "Người thân của...")
- Database có đầy đủ: patient_id, relative_id, booked_by_user_id

---

## **Các bước test:**

### **1. Chuẩn bị dữ liệu**
```sql
-- Kiểm tra user hiện tại
SELECT * FROM users WHERE email = 'phuocthde180577@fpt.edu.vn';

-- Kiểm tra patient_id của user
SELECT * FROM Patients WHERE user_id = 7;

-- Xem các relatives hiện có
SELECT * FROM Relatives WHERE user_id = 7;
```

### **2. Thực hiện đặt lịch**
1. **Đăng nhập:** `phuocthde180577@fpt.edu.vn` / `12345`
2. **Vào trang đặt lịch:** `/BookingPageServlet`
3. **Chọn "Đặt cho người thân"**
4. **Điền thông tin người thân:**
   - Họ và tên: `Nguyễn Văn Nam`
   - Số điện thoại: `0987654321`
   - Ngày sinh: `1985-03-15`
   - Giới tính: `Nam`
   - Mối quan hệ: `Anh`
5. **Chọn dịch vụ:** Bọc răng sứ (3.000.000 VNĐ)
6. **Chọn bác sĩ:** Nguyen Do Phuc Toan
7. **Chọn ngày:** 2025-07-11
8. **Chọn slot:** 11:30 - 12:00 (slot 3009)
9. **Lý do khám:** `Đau răng cần điều trị`
10. **Nhấn "Xác nhận đặt lịch"**

### **3. Kiểm tra kết quả trong database**

#### **A. Bảng Relatives:**
```sql
SELECT * FROM Relatives WHERE user_id = 7 ORDER BY relative_id DESC;
```
**Kỳ vọng:** 
- `full_name` = "Nguyễn Văn Nam" (KHÔNG phải "Người thân của...")
- `phone` = "0987654321"
- `date_of_birth` = "1985-03-15"
- `gender` = "Nam"
- `relationship` = "Anh"

#### **B. Bảng Appointment:**
```sql
SELECT TOP 1 * FROM Appointment ORDER BY appointment_id DESC;
```
**Kỳ vọng:**
- `patient_id` = 5 (patient của user_id=7)
- `relative_id` = [ID vừa tạo] (KHÔNG NULL)
- `booked_by_user_id` = 7 (user đặt lịch)
- `doctor_id` = 1
- `work_date` = "2025-07-11"
- `slot_id` = 3009
- `status` = "BOOKED" hoặc "COMPLETED"

#### **C. Bảng Bills:**
```sql
SELECT TOP 1 * FROM Bills ORDER BY created_at DESC;
```
**Kỳ vọng:**
- `service_id` = 10
- `patient_id` = 5
- `user_id` = 7
- `amount` = 3000000
- `payment_status` = "success"

---

## **URL để test:**
```
http://localhost:8080/TestFull/BookingPageServlet
```

## **Logs quan trọng cần theo dõi:**
```
✅ Tạo người thân mới từ form: [ID] | Nguyễn Văn Nam
✅ TẠO LỊCH HẸN CHO NGƯỜI THÂN THÀNH CÔNG - RelativeId: [ID]
🎯 BOOKING REQUEST -> PAYMENT
📧 ĐÃ GỬI EMAIL THANH TOÁN THÀNH CÔNG QUA N8N
```

---

## **Kết quả mong đợi:**
1. ✅ Người thân được tạo với tên thật "Nguyễn Văn Nam"
2. ✅ Appointment có đầy đủ: patient_id, relative_id, booked_by_user_id
3. ✅ Email thông báo được gửi thành công
4. ✅ Payment hoàn tất
5. ✅ Không còn hiện tượng "Người thân của..." 