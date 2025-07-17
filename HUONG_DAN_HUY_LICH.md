# NGHIỆP VỤ HUỶ LỊCH HẸN (CANCEL APPOINTMENT)

| Mục | Nội dung |
|-----|----------|
| **1. Mục đích** | Cho phép bệnh nhân hoặc nhân viên huỷ lịch hẹn khám đã đặt trước khi đến thời gian khám. |
| **2. Luồng xử lý tổng quát** | 1. Người dùng chọn lịch hẹn muốn huỷ trên giao diện.<br>2. Nhấn nút "Huỷ lịch".<br>3. Hệ thống hiển thị hộp thoại xác nhận.<br>4. Nếu xác nhận, gửi yêu cầu huỷ đến Servlet.<br>5. Servlet kiểm tra điều kiện (chưa đến giờ khám, chưa bị huỷ trước đó).<br>6. Nếu hợp lệ, cập nhật trạng thái lịch hẹn thành "Đã huỷ".<br>7. Thông báo kết quả cho người dùng. |
| **3. Thành phần liên quan** | - JSP: Hiển thị danh sách lịch hẹn, nút huỷ, popup xác nhận.<br>- Servlet: Xử lý logic huỷ lịch, cập nhật database.<br>- DAO: Thực hiện truy vấn cập nhật trạng thái.<br>- Database: Bảng `Appointment` có cột trạng thái (status). |
| **4. Tham số truyền** | - appointment_id: ID của lịch hẹn cần huỷ<br>- user_id: ID người thực hiện huỷ (nếu cần) |
| **5. Gợi ý code** | - JSP: Gửi form POST với appointment_id đến Servlet huỷ lịch<br>- Servlet: Lấy appointment_id, gọi DAO cập nhật trạng thái |
| **6. Lưu ý** | - Chỉ cho phép huỷ khi chưa đến giờ khám<br>- Ghi log lại thao tác huỷ (nếu cần)<br>- Thông báo rõ ràng cho người dùng |

---
*File này dành cho người mới học JSP/Servlet, không dùng JSTL, chỉ dùng code cơ bản.* 