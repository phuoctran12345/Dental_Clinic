# Test Real-time Booking System

## Mô tả tính năng
Hệ thống đặt lịch real-time sẽ tự động kiểm tra thời gian hiện tại và không cho phép đặt lịch các slot đã qua thời gian.

## Các trường hợp test

### 1. Test ngày trong quá khứ
- **Mô tả**: Không thể đặt lịch cho ngày hôm qua
- **Kết quả mong đợi**: Tất cả slot hiển thị màu xám với icon ⏰ và text "Ngày trong quá khứ"

### 2. Test slot đã qua thời gian (ngày hôm nay)
- **Mô tả**: Nếu hiện tại là 17:10, không thể đặt slot 16:30-17:00
- **Kết quả mong đợi**: Slot 16:30-17:00 hiển thị màu xám với icon ⏰ và text "Đã qua thời gian"

### 3. Test slot chưa đến thời gian (ngày hôm nay)
- **Mô tả**: Nếu hiện tại là 12:30, có thể đặt slot 13:00-13:30
- **Kết quả mong đợi**: Slot 13:00-13:30 hiển thị màu xanh và có thể click

### 4. Test ngày tương lai
- **Mô tả**: Đặt lịch cho ngày mai
- **Kết quả mong đợi**: Tất cả slot hiển thị bình thường và có thể đặt

## Cách test

### Bước 1: Kiểm tra console log
Khi load trang đặt lịch, kiểm tra console để xem:
```
⏰ Current time: 17:10:30
📅 Current date: 2025-01-15
📅 Selected date: 2025-01-15
❌ Slot 3008 (16:30) đã hết hạn: Đã qua thời gian
✅ Slot 3010 (13:00) khả dụng
```

### Bước 2: Kiểm tra giao diện
- Slot đã hết hạn: Màu xám, icon ⏰, không thể click
- Slot còn trống: Màu xanh, có thể click
- Slot đã đặt: Màu đỏ, icon 🚫

### Bước 3: Test validation
- Click vào slot đã hết hạn → Hiển thị alert "Khung giờ này đã hết hạn"
- Click vào slot còn trống → Bình thường

## Files đã cập nhật

### 1. BookingPageServlet.java
- Thêm logic kiểm tra thời gian real-time trong `handleGetTimeSlots()`
- Trả về thông tin `isExpired` và `expiredReason` cho mỗi slot

### 2. AppointmentDAO.java
- Cập nhật hàm `isSlotAvailable()` để kiểm tra thời gian
- Thêm hàm mới `isSlotExpired()` để kiểm tra slot hết hạn

### 3. user_datlich.jsp
- Thêm CSS cho slot hết hạn (màu xám, icon ⏰)
- Cập nhật JavaScript để xử lý slot hết hạn
- Thêm validation khi click slot hết hạn

## Lưu ý quan trọng

1. **Timezone**: Hệ thống sử dụng timezone của server
2. **Precision**: Kiểm tra theo phút (không theo giây)
3. **Performance**: Logic real-time chỉ chạy khi load timeslots, không ảnh hưởng performance
4. **User Experience**: Slot hết hạn vẫn hiển thị nhưng không thể click

## Kết quả mong đợi

✅ **17:10 chiều sẽ không đặt được ca từ 16:30 -> 17:00**
✅ **12:30 sẽ không đặt được lịch 11:30 -> 12:00**
✅ **Slot đã hết hạn hiển thị màu xám với icon ⏰**
✅ **Alert thông báo khi click slot hết hạn**
✅ **Console log chi tiết để debug** 