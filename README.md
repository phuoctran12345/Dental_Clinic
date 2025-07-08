# Báo cáo chỉnh sửa nhánh PHUOC/MergeUserProfileCTung-StaffProfile

## 1. Chức năng: Quản lý và cập nhật thông tin hồ sơ (profile) cho Staff/User

---

## 2. Các file JSP liên quan:
- web/jsp/staff/staff_taikhoan.jsp  *(Hiển thị và cập nhật thông tin staff)*
- web/jsp/staff/staff_menu.jsp      *(Menu staff, liên kết đến trang profile)*
- web/jsp/patient/user_taikhoan.jsp *(Hiển thị và cập nhật thông tin user)*
- web/jsp/patient/user_menu.jsp     *(Menu user, liên kết đến trang profile)*

---

## 3. Các Servlet liên quan:
- src/java/controller/StaffProfileServlet.java *(Xử lý hiển thị/cập nhật profile staff)*
- src/java/controller/UserAccountServlet.java *(Xử lý hiển thị/cập nhật profile user)*
- src/java/controller/UpdateUserServlet.java  *(Xử lý cập nhật thông tin user)*

---

## 4. Các class DAO liên quan trực tiếp:
- src/java/dao/StaffDAO.java
  - Hàm: `updateStaff(Staff staff)`
  - Chức năng: Cập nhật thông tin nhân viên (staff)
  - Truy vấn SQL: Biến `UPDATE` trong class này

- src/java/dao/UserDAO.java
  - Hàm: `updateUser(User user)`
  - Chức năng: Cập nhật thông tin user
  - Truy vấn SQL: Biến `UPDATE` trong class này

---

## 5. Model liên quan:
- src/java/model/Staff.java
- src/java/model/User.java

---

## 6. Ghi chú:
- Chỉ liệt kê các file, class, hàm và truy vấn thực sự liên quan đến chức năng cập nhật/thông tin profile staff/user.
- Nếu cần chi tiết từng thay đổi, hãy xem lại commit history trên nhánh này. 