# HỆ THỐNG QUẢN LÝ LỊCH LÀM VIỆC NHÂN VIÊN - PHÒNG KHÁM NHA KHOA

## 📋 TỔNG QUAN

Hệ thống quản lý lịch làm việc nhân viên được thiết kế để xử lý 2 loại nhân viên với nghiệp vụ khác nhau:
- **Nhân viên Full-time**: Đăng ký ngày nghỉ phép (tối đa 6 ngày/tháng)
- **Nhân viên Part-time**: Đăng ký ca làm việc (tương tự bác sĩ)

## 🎯 MỤC TIÊU NGHIỆP VỤ

### 1. Quản lý nhân viên Full-time
- Cho phép đăng ký nghỉ phép với hạn mức 6 ngày/tháng
- Yêu cầu phê duyệt từ quản lý
- Theo dõi số ngày nghỉ đã sử dụng/còn lại

### 2. Quản lý nhân viên Part-time  
- Đăng ký ca làm việc: Sáng (8h-12h), Chiều (13h-17h), Cả ngày (8h-17h)
- Logic tương tự hệ thống đăng ký lịch bác sĩ
- Linh hoạt trong việc chọn ca làm

### 3. Phê duyệt quản lý
- Giao diện thống nhất cho phê duyệt lịch bác sĩ và nhân viên
- Hiển thị số lượng yêu cầu chờ phê duyệt
- Phân loại rõ ràng giữa các loại yêu cầu

## 🏗️ THIẾT KẾ DATABASE

### Bảng Staff (Cập nhật)
```sql
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE NOT NULL,
    full_name NVARCHAR(255) NOT NULL,
    phone_number NVARCHAR(20),
    email NVARCHAR(255),
    employment_type NVARCHAR(20) NOT NULL CHECK (employment_type IN ('fulltime', 'parttime')),
    salary DECIMAL(15,2),
    hire_date DATE,
    manager_id INT,
    department NVARCHAR(100),
    work_schedule NVARCHAR(255),
    status NVARCHAR(20) DEFAULT 'active',
    notes NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (manager_id) REFERENCES Staff(staff_id)
);
```

### Bảng StaffSchedule (Mới)
```sql
CREATE TABLE StaffSchedule (
    schedule_id INT PRIMARY KEY IDENTITY(1,1),
    staff_id INT NOT NULL,
    work_date DATE NOT NULL,
    slot_id INT,
    request_type NVARCHAR(10) NOT NULL CHECK (request_type IN ('work', 'leave')),
    status NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    reason NVARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    approved_by INT,
    approved_at DATETIME2,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (slot_id) REFERENCES TimeSlot(slot_id),
    FOREIGN KEY (approved_by) REFERENCES Staff(staff_id)
);
```

## 📊 CẤU TRÚC TẦNG MÔ HÌNH

### Model Layer
```java
// StaffSchedule.java
public class StaffSchedule {
    private int scheduleId;
    private int staffId;
    private Date workDate;
    private Integer slotId;
    private String requestType; // 'work' hoặc 'leave'
    private String status;      // 'pending', 'approved', 'rejected'
    private String reason;
    private Date createdAt;
    private Integer approvedBy;
    private Date approvedAt;
    
    // Thông tin bổ sung từ JOIN
    private String staffName;
    private String slotName;
    private String employmentType;
}
```

### DAO Layer
```java
// StaffScheduleDAO.java
public class StaffScheduleDAO {
    // Lấy yêu cầu chờ phê duyệt
    public List<StaffSchedule> getPendingRequests()
    
    // Lấy lịch nhân viên theo tháng
    public List<StaffSchedule> getStaffSchedulesByMonth(int staffId, int month, int year)
    
    // Đếm ngày nghỉ đã được phê duyệt (cho fulltime)
    public int getApprovedLeaveDaysInMonth(int staffId, int month, int year)
    
    // Thêm yêu cầu mới
    public boolean addScheduleRequest(StaffSchedule schedule)
    
    // Cập nhật trạng thái yêu cầu
    public boolean updateRequestStatus(int scheduleId, String status, int approvedBy)
    
    // Kiểm tra fulltime có thể nghỉ thêm không
    public boolean canTakeMoreLeave(int staffId, int month, int year)
}
```

## 🔄 LUỒNG XỬ LÝ NGHIỆP VỤ

### 1. Nhân viên Full-time (Nghỉ phép)

#### Bước 1: Hiển thị form nghỉ phép
```
GET /StaffScheduleServlet
├── Lấy thông tin nhân viên từ session
├── Kiểm tra employment_type = 'fulltime'  
├── Tính số ngày nghỉ đã sử dụng trong tháng
├── Hiển thị staff_xinnghi.jsp
└── Form: chọn ngày + lý do nghỉ
```

#### Bước 2: Xử lý đăng ký nghỉ phép
```
POST /StaffScheduleServlet
├── Validate dữ liệu đầu vào
├── Kiểm tra còn được nghỉ bao nhiêu ngày (max 6/tháng)
├── Kiểm tra trùng lặp ngày nghỉ
├── Lưu yêu cầu với status = 'pending'
└── Redirect về trang chính với thông báo
```

### 2. Nhân viên Part-time (Đăng ký ca)

#### Bước 1: Hiển thị form đăng ký ca
```
GET /StaffScheduleServlet  
├── Lấy thông tin nhân viên từ session
├── Kiểm tra employment_type = 'parttime'
├── Lấy danh sách TimeSlot available
├── Lấy lịch đã đăng ký trong tháng
├── Hiển thị staff_dangkilich.jsp
└── Form: chọn ngày + ca làm việc
```

#### Bước 2: Xử lý đăng ký ca làm
```
POST /StaffScheduleServlet
├── Validate dữ liệu đầu vào  
├── Kiểm tra trùng lặp ca làm việc
├── Lưu yêu cầu với request_type = 'work'
└── Redirect về trang chính với thông báo
```

### 3. Quản lý phê duyệt

#### Bước 1: Hiển thị danh sách yêu cầu
```
GET /manager_phancong.jsp
├── Lấy danh sách yêu cầu bác sĩ chờ phê duyệt
├── Lấy danh sách yêu cầu nhân viên chờ phê duyệt  
├── Hiển thị tabs với badge đếm số lượng
└── Tự động chuyển tab nếu có yêu cầu
```

#### Bước 2: Phê duyệt/từ chối
```
POST /StaffScheduleApprovalServlet
├── Lấy scheduleId và action (approve/reject)
├── Cập nhật status và approved_by
├── Ghi log thời gian phê duyệt
└── Redirect về trang quản lý với thông báo
```

## 🖥️ GIAO DIỆN NGƯỜI DÙNG

### 1. Nhân viên Full-time (`staff_xinnghi.jsp`)
```jsp
<!-- Hiển thị số ngày nghỉ -->
<div class="leave-counter">
    <span class="used">${usedDays}</span> / 
    <span class="total">6</span> ngày nghỉ trong tháng
    <span class="remaining">(Còn lại: ${6 - usedDays} ngày)</span>
</div>

<!-- Form đăng ký nghỉ -->
<form method="post">
    <input type="date" name="leaveDate" required>
    <textarea name="reason" placeholder="Lý do nghỉ phép"></textarea>
    <button type="submit">Gửi yêu cầu nghỉ phép</button>
</form>

<!-- Lịch sử yêu cầu -->
<table class="request-history">
    <c:forEach var="request" items="${scheduleRequests}">
        <tr class="status-${request.status}">
            <td>${request.workDate}</td>
            <td>${request.reason}</td>
            <td><span class="badge ${request.status}">${request.status}</span></td>
        </tr>
    </c:forEach>
</table>
```

### 2. Nhân viên Part-time (`staff_dangkilich.jsp`)
```jsp
<!-- Calendar view tương tự doctor -->
<div class="calendar-container">
    <div class="month-year-selector">
        <select name="month">${currentMonth}</select>
        <select name="year">${currentYear}</select>
    </div>
    
    <div class="calendar-grid">
        <c:forEach var="day" items="${calendarDays}">
            <div class="calendar-day ${day.hasSchedule ? 'scheduled' : ''}">
                <span class="day-number">${day.dayNumber}</span>
                <c:if test="${day.hasSchedule}">
                    <div class="schedule-info">${day.slotName}</div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Form đăng ký ca -->
<form method="post" class="schedule-form">
    <input type="date" name="workDate" required>
    <select name="slotId" required>
        <option value="">Chọn ca làm việc</option>
        <c:forEach var="slot" items="${timeSlots}">
            <option value="${slot.slotId}">${slot.slotName}</option>
        </c:forEach>
    </select>
    <button type="submit">Đăng ký ca làm</button>
</form>
```

### 3. Quản lý phê duyệt (`manager_phancong.jsp`)
```jsp
<!-- Tab navigation với badge -->
<ul class="nav nav-tabs">
    <li class="nav-item">
        <a class="nav-link" href="#doctor-tab">
            Bác sĩ 
            <span class="badge badge-primary">${doctorPendingCount}</span>
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="#staff-tab">
            Nhân viên
            <span class="badge badge-info">${staffPendingCount}</span>
        </a>
    </li>
</ul>

<!-- Staff approval table -->
<div id="staff-tab" class="tab-pane">
    <table class="table">
        <thead>
            <tr>
                <th>Nhân viên</th>
                <th>Loại yêu cầu</th>
                <th>Ngày</th>
                <th>Ca làm việc</th>
                <th>Lý do</th>
                <th>Ngày tạo</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="request" items="${staffPendingRequests}">
                <tr>
                    <td>${request.staffName}</td>
                    <td>
                        <span class="badge ${request.requestType == 'leave' ? 'badge-warning' : 'badge-info'}">
                            ${request.requestType == 'leave' ? 'Nghỉ phép' : 'Đăng ký ca'}
                        </span>
                    </td>
                    <td>${request.workDate}</td>
                    <td>${request.slotName}</td>
                    <td>${request.reason}</td>
                    <td>${request.createdAt}</td>
                    <td>
                        <form method="post" action="StaffScheduleApprovalServlet" style="display:inline;">
                            <input type="hidden" name="scheduleId" value="${request.scheduleId}">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn btn-success btn-sm">Phê duyệt</button>
                        </form>
                        <form method="post" action="StaffScheduleApprovalServlet" style="display:inline;">
                            <input type="hidden" name="scheduleId" value="${request.scheduleId}">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn btn-danger btn-sm">Từ chối</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
```

## ⚙️ CẤU HÌNH VÀ VALIDATION

### 1. Validation Rules
```java
// Fulltime staff validation
public boolean canTakeLeave(int staffId, Date leaveDate) {
    // Kiểm tra trong tháng đã nghỉ bao nhiêu ngày
    int usedDays = getApprovedLeaveDaysInMonth(staffId, month, year);
    if (usedDays >= 6) {
        return false; // Đã hết quota
    }
    
    // Kiểm tra không trùng ngày đã đăng ký
    return !isDuplicateLeaveRequest(staffId, leaveDate);
}

// Parttime staff validation  
public boolean canRegisterShift(int staffId, Date workDate, int slotId) {
    // Kiểm tra không trùng ca đã đăng ký
    return !isDuplicateWorkRequest(staffId, workDate, slotId);
}
```

### 2. Business Constants
```java
public class StaffScheduleConstants {
    public static final int MAX_LEAVE_DAYS_PER_MONTH = 6;
    public static final String REQUEST_TYPE_WORK = "work";
    public static final String REQUEST_TYPE_LEAVE = "leave";
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_APPROVED = "approved";
    public static final String STATUS_REJECTED = "rejected";
    public static final String EMPLOYMENT_FULLTIME = "fulltime";
    public static final String EMPLOYMENT_PARTTIME = "parttime";
}
```

## 🔍 KIỂM THỬ VÀ DEBUG

### 1. Test Cases chính
- **Fulltime staff**: Đăng ký nghỉ phép vượt quota (expect: error)
- **Fulltime staff**: Đăng ký nghỉ trùng ngày (expect: error)  
- **Parttime staff**: Đăng ký ca trùng lặp (expect: error)
- **Manager**: Phê duyệt/từ chối yêu cầu
- **Database**: Tính toán số ngày nghỉ chính xác

### 2. Logging Points
```java
// Log các action quan trọng
Logger.info("Staff " + staffId + " requested " + requestType + " for date " + workDate);
Logger.info("Manager " + managerId + " " + action + " request " + scheduleId);
Logger.warn("Staff " + staffId + " exceeded leave quota: " + usedDays + "/6");
```

## 📈 TÍNH NĂNG MỞ RỘNG

### 1. Tính năng có thể thêm
- **Notification**: Thông báo khi có yêu cầu mới/được phê duyệt
- **Calendar Integration**: Sync với Google Calendar
- **Report**: Báo cáo thống kê nghỉ phép theo tháng/quý
- **Mobile App**: Ứng dụng mobile cho nhân viên

### 2. Cải tiến performance
- **Caching**: Cache danh sách TimeSlot
- **Pagination**: Phân trang cho lịch sử yêu cầu
- **Indexing**: Tạo index cho các truy vấn thường dùng

## 🏆 KẾT LUẬN

Hệ thống đã được thiết kế để:
- ✅ Phân biệt rõ ràng nghiệp vụ fulltime vs parttime
- ✅ Tích hợp mượt mà với hệ thống hiện tại
- ✅ Giao diện thân thiện và dễ sử dụng
- ✅ Quản lý tập trung cho manager
- ✅ Validation chặt chẽ và bảo mật
- ✅ Có thể mở rộng trong tương lai

Hệ thống hoạt động ổn định và đáp ứng đầy đủ yêu cầu nghiệp vụ của phòng khám nha khoa. 