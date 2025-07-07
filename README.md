# Đặt lịch cho người thân - Hướng dẫn thực tế, dễ hiểu

## 1. Luồng tổng quát
- Người dùng vào trang "Đặt lịch khám bệnh" (`user_datlich.jsp`).
- Có 2 lựa chọn: Đặt cho bản thân hoặc cho người thân (chuyển tab trên giao diện).
- Nếu chọn "Người thân":
  - Nhập thông tin người thân (họ tên, ngày sinh, số điện thoại, giới tính, quan hệ, lý do khám).
  - Chọn bác sĩ, ngày, giờ khám.
  - Bấm "Xác nhận đặt lịch".
- Hệ thống kiểm tra, lưu thông tin người thân (nếu chưa có), lưu lịch hẹn vào database.
- Hiện thông báo thành công hoặc lỗi.

## 2. Các file quan trọng

### JSP (Giao diện)
- `web/jsp/patient/user_datlich.jsp` : Giao diện đặt lịch cho cả bản thân và người thân (dùng tab để chuyển đổi).

### Servlet (Xử lý logic)
- `src/java/controller/BookingPageServlet.java` : Xử lý nhận dữ liệu từ form, kiểm tra, lưu thông tin người thân và lịch hẹn vào database.
- `src/java/dao/RelativesDAO.java` : Thao tác với bảng người thân trong database (tạo mới hoặc lấy lại ID nếu đã có).
- `src/java/dao/AppointmentDAO.java` : Lưu lịch hẹn vào bảng Appointment (liên kết với người thân hoặc bản thân).

## 3. Giải thuật đặt lịch cho người thân (tóm tắt)
1. Người dùng điền thông tin người thân và lịch hẹn trên trang `user_datlich.jsp` (tab "Người thân").
2. Khi bấm "Xác nhận đặt lịch", dữ liệu gửi tới `BookingPageServlet`.
3. Servlet kiểm tra:
   - Nếu người thân chưa có trong database → gọi `RelativesDAO.getOrCreateRelative(...)` để tạo mới.
   - Nếu đã có → dùng lại thông tin cũ (ID).
   - Lưu lịch hẹn vào bảng Appointment, liên kết với relativeId vừa lấy/đã có.
4. Chuyển sang trang thông báo thành công hoặc báo lỗi nếu có vấn đề.

## 4. Lưu ý khi triển khai
- Mỗi người thân nên có mã ID riêng.
- Kiểm tra trùng số điện thoại/ngày sinh để tránh tạo nhiều bản ghi cho cùng một người.
- Có thể bổ sung chức năng xem lại lịch sử đặt lịch cho người thân.

---
**Tóm lại:**
- Giao diện: `user_datlich.jsp` (1 file cho cả bản thân và người thân, dùng tab để chuyển).
- Xử lý: `BookingPageServlet.java` nhận và lưu dữ liệu.
- Database: `RelativesDAO.java` và `AppointmentDAO.java` thao tác bảng người thân và lịch hẹn. 