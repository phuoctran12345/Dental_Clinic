# 📋 Hướng Dẫn Sử Dụng - Servlet Staff System

## 🎯 Danh sách Servlet và Chức năng

### 💰 1. StaffPaymentServlet  
**📍 Path:** `/StaffPaymentServlet`  
**🎯 Chức năng:** Quản lý thanh toán và hóa đơn
- Tạo hóa đơn cho bệnh nhân
- Theo dõi trạng thái thanh toán  
- Quản lý kế hoạch trả góp
- Gửi thông báo nhắc nhở

---

### 📅 2. StaffBookingServlet
**📍 Path:** `/StaffBookingServlet`  
**🎯 Chức năng:** Đặt lịch hẹn cho bệnh nhân
- Tìm kiếm bệnh nhân theo SĐT/tên
- Hiển thị lịch bác sĩ available
- Đặt lịch hẹn cho bệnh nhân
- Quản lý lịch hẹn trong ngày

---

### 👥 3. StaffViewPatientServlet  
**📍 Path:** `/StaffViewPatientServlet`  
**🎯 Chức năng:** Xem và quản lý thông tin bệnh nhân
- Xem danh sách tất cả bệnh nhân
- Tìm kiếm bệnh nhân theo nhiều tiêu chí
- Lọc bệnh nhân theo giới tính

---

### 👨‍💼 4. StaffInfoServlet
**📍 Path:** `/StaffInfoServlet`  
**🎯 Chức năng:** Hiển thị thông tin nhân viên
- Hiển thị profile nhân viên (ID, tên, SĐT, địa chỉ, chức vụ)
- Kiểm tra session authentication

---

### 🚶‍♂️ 5. StaffHandleQueueServlet
**📍 Path:** `/StaffHandleQueueServlet`  
**🎯 Chức năng:** Quản lý hàng đợi bệnh nhân
- Xem danh sách bệnh nhân chờ khám
- Cập nhật trạng thái hàng đợi
- Gọi bệnh nhân vào khám
- Quản lý lượt khám theo thứ tự

---

### 💊 6. StaffSellMedicineServlet
**📍 Path:** `/StaffSellMedicineServlet`  
**🎯 Chức năng:** Bán thuốc và tạo hóa đơn
- Hiển thị danh sách thuốc available
- Tạo hóa đơn bán thuốc
- Quản lý tồn kho thuốc
- Tính toán tổng tiền tự động

---

### ✏️ 7. UpdateStaffInfoServlet
**📍 Path:** `/UpdateStaffInfoServlet`  
**🎯 Chức năng:** Cập nhật thông tin nhân viên
- Cập nhật họ tên, SĐT, ngày sinh, giới tính, địa chỉ, email
- Validation dữ liệu đầu vào
- Cập nhật bảng `users` và `staff`

---

### 🔗 8. TwilioCallServlet (Tích hợp)
**📍 Path:** `/twilio-call`  
**🎯 Chức năng:** Gọi điện tự động cho bệnh nhân
- Tích hợp Twilio API
- Gọi điện nhắc nhở lịch hẹn
- Gọi thông báo kết quả khám

---

**📧 Contact:** Liên hệ team lead nếu cần hỗ trợ kỹ thuật! 