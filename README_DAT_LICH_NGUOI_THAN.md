# Tóm tắt giải pháp: Đặt lịch cho người thân

## 1. Luồng xử lý tổng quát
- Người dùng chọn chức năng "Đặt lịch cho người thân" trên giao diện.
- Nhập thông tin người thân (họ tên, ngày sinh, số điện thoại...)
- Chọn bác sĩ, ngày, giờ khám.
- Xác nhận và lưu lịch hẹn vào database.

## 2. Các bước xử lý trong code
1. **JSP hiển thị form đặt lịch cho người thân**
   - Form nhập thông tin người thân + chọn lịch hẹn.
2. **Servlet nhận dữ liệu đặt lịch**
   - Nhận dữ liệu từ form (thông tin người thân + lịch hẹn).
   - Kiểm tra thông tin, validate dữ liệu.
   - Nếu người thân chưa có trong database: tạo mới.
   - Lưu lịch hẹn vào bảng Appointment (liên kết với người thân).
3. **DAO thao tác với database**
   - Thêm/sửa thông tin người thân.
   - Thêm lịch hẹn mới.
4. **Hiển thị kết quả**
   - Thông báo đặt lịch thành công hoặc lỗi.

## 3. Lưu ý khi triển khai
- Đảm bảo mỗi người thân có mã định danh riêng (ID).
- Kiểm tra trùng lặp số điện thoại/ngày sinh để tránh tạo nhiều bản ghi cho cùng một người.
- Có thể cho phép người dùng xem lại lịch sử đặt lịch cho người thân.

---
**Tóm lại:**
- Nhận thông tin người thân từ form → kiểm tra/tạo mới người thân → lưu lịch hẹn → thông báo kết quả.
- Code chủ yếu dùng JSP để lấy dữ liệu, Servlet để xử lý, DAO để thao tác database. 