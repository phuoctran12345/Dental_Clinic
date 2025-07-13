# 🧪 Test Logic Hiển Thị Lịch Nghỉ Phép

## 🔍 Vấn đề hiện tại:
- ✅ Đăng ký nghỉ phép thành công (Insert result: 1)
- ❌ Manager approval page hiển thị "Doctor schedules: 0"

## 🔧 Đã sửa:

### 1. Cập nhật SQL query:
```sql
-- Cũ: chỉ tìm status = 'pending'
SELECT * FROM DoctorSchedule WHERE status = 'pending'

-- Mới: tìm nhiều status khác nhau
SELECT * FROM DoctorSchedule WHERE status IN ('pending', 'Chờ xác nhận', 'Chờ duyệt')
```

### 2. Thêm hàm mới:
```java
public List<DoctorSchedule> getAllPendingSchedulesIncludingLeaves() {
    // SQL lấy tất cả lịch chờ phê duyệt, bao gồm cả nghỉ phép
    String sql = "SELECT * FROM DoctorSchedule " +
               "WHERE status IN ('pending', 'Chờ xác nhận', 'Chờ duyệt', 'Chờ phê duyệt') " +
               "OR (slot_id IS NULL AND status LIKE N'%nghỉ%') " +
               "ORDER BY work_date ASC, doctor_id ASC";
}
```

### 3. Cập nhật ManagerApprovalDoctorSchedulerServlet:
```java
// Sử dụng hàm mới để lấy tất cả lịch chờ phê duyệt
pendingDoctorSchedules = doctorScheduleDAO.getAllPendingSchedulesIncludingLeaves();
```

## 🧪 Cách test:

### 1. Đăng ký nghỉ phép:
```
[DEBUG] Đăng ký nghỉ phép cho doctorId=1, workDate=2025-07-14
Insert result: 1
```

### 2. Kiểm tra database:
```sql
SELECT * FROM DoctorSchedule 
WHERE doctor_id = 1 
AND work_date = '2025-07-14';
```

### 3. Vào trang Manager Approval:
- Đăng nhập với tài khoản MANAGER
- Vào trang phê duyệt lịch
- Kiểm tra log: `📋 [MANAGER] Found X pending schedules (including leaves)`

### 4. Kết quả mong đợi:
```
📋 [MANAGER] Found 1 pending schedules (including leaves)
   - Doctor 1 | Date: 2025-07-14 | Status: Chờ xác nhận | Slot: null
```

## ✅ Kết luận:
Sau khi sửa, trang Manager Approval sẽ hiển thị đúng lịch nghỉ phép đã đăng ký! 