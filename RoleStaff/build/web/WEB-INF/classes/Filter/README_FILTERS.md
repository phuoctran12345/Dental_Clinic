# 🏥 DENTAL CLINIC FILTERS SYSTEM

Hệ thống Filter tổng quát và có thể tái sử dụng cho phòng khám nha khoa.

## 📋 DANH SÁCH FILTERS

### 1. 🔤 **EncodingFilter**
- **Mục đích**: Đảm bảo encoding UTF-8 cho toàn bộ ứng dụng
- **Chức năng**: 
  - Set encoding UTF-8 cho request/response
  - Hỗ trợ tiếng Việt hiển thị đúng
  - Set cache headers
- **Thứ tự**: 1 (chạy đầu tiên)

### 2. 🛡️ **SecurityFilter**
- **Mục đích**: Bảo mật ứng dụng chống các cuộc tấn công
- **Chức năng**:
  - Chống XSS (Cross-Site Scripting)
  - Chống SQL Injection
  - CSRF Protection cơ bản
  - Set Security Headers
  - Rate Limiting cơ bản
- **Thứ tự**: 2

### 3. 🔐 **AuthenticationFilter** (Tùy chọn)
- **Mục đích**: Kiểm tra xác thực người dùng
- **Chức năng**:
  - Kiểm tra session và user login
  - Redirect đến login nếu chưa đăng nhập
  - Lưu URL gốc để redirect sau login
- **Thứ tự**: 3
- **Trạng thái**: Tạm thời tắt để tránh conflict với RoleFilter

### 4. 🏥 **RoleFilter**
- **Mục đích**: Kiểm tra quyền truy cập theo role
- **Chức năng**:
  - Phân quyền cho PATIENT, DOCTOR, STAFF, MANAGER
  - Kiểm tra quyền truy cập từng trang/servlet
  - Redirect về trang chủ phù hợp với role
- **Thứ tự**: 4 (chạy cuối cùng)

## 🔧 CẤU HÌNH

### Thứ tự Filter Chain:
```
Request → EncodingFilter → SecurityFilter → (AuthenticationFilter) → RoleFilter → Servlet
```

### Cấu hình trong web.xml:
```xml
<!-- 1. Encoding Filter -->
<filter>
    <filter-name>EncodingFilter</filter-name>
    <filter-class>Filter.EncodingFilter</filter-class>
</filter>

<!-- 2. Security Filter -->
<filter>
    <filter-name>SecurityFilter</filter-name>
    <filter-class>Filter.SecurityFilter</filter-class>
</filter>

<!-- 3. Role Filter (sử dụng @WebFilter annotation) -->
```

## 🎯 ROLE PERMISSIONS

### 👤 PATIENT (Bệnh nhân)
- `/jsp/patient/` - Trang bệnh nhân
- `/BookingPageServlet`, `/BookingServlet` - Đặt lịch
- `/payment`, `/PayOSServlet` - Thanh toán
- `/services` - Xem dịch vụ
- Các servlet cơ bản: Avatar, UpdateInfo, ChangePassword, Logout

### 👨‍⚕️ DOCTOR (Bác sĩ)
- `/doctor/`, `/jsp/doctor/` - Trang bác sĩ
- `/DoctorScheduleServlet` - Quản lý lịch làm việc
- `/DoctorAppointmentsServlet` - Xem lịch hẹn
- `/MedicalReport` - Báo cáo y tế
- Các servlet cơ bản

### 👩‍💼 STAFF (Nhân viên)
- `/staff_*.jsp` - Trang nhân viên
- `/StaffInfoServlet`, `/StaffViewPatientServlet` - Quản lý thông tin
- Các servlet cơ bản

### 👨‍💼 MANAGER (Quản lý)
- `/manager_*.jsp` - Trang quản lý
- `/Medicine`, `/ScheduleApprovalServlet` - Quản lý hệ thống
- Các servlet cơ bản

## 🔓 PUBLIC PAGES (Không cần đăng nhập)

### Trang công khai:
- `/login.jsp`, `/signup.jsp`, `/home.jsp`
- `/services` - Trang dịch vụ
- `/LoginServlet`, `/SignUpServlet`, `/RegisterServlet`
- `/payment-success.jsp`, `/payment-cancel.jsp`

### Resources công khai:
- `/images/`, `/styles/`, `/js/`, `/css/`
- `/META-INF/`, `/WEB-INF/`, `/includes/`, `/common/`
- Static files: `.css`, `.js`, `.png`, `.jpg`, `.ico`

## 🛡️ SECURITY FEATURES

### XSS Protection:
- Kiểm tra `<script>`, `javascript:`, `onload=`, etc.
- Kiểm tra `eval()`, `alert()`, `confirm()`, `prompt()`

### SQL Injection Protection:
- Kiểm tra `union`, `select`, `insert`, `delete`, `update`
- Kiểm tra `or`, `and` với pattern đặc biệt
- Kiểm tra comment SQL `--`, `;`

### Security Headers:
- `X-Frame-Options: DENY` - Chống clickjacking
- `X-XSS-Protection: 1; mode=block` - Chống XSS
- `X-Content-Type-Options: nosniff` - Chống MIME sniffing
- `Content-Security-Policy` - CSP cơ bản
- `Referrer-Policy` - Kiểm soát referrer

### CSRF Protection:
- Kiểm tra Referer header cho POST requests
- Áp dụng cho: `/payment`, `/BookingServlet`, `/UpdateStaffInfoServlet`

## 🚀 CÁCH SỬ DỤNG

### 1. Bật/Tắt Filter:
```java
// Trong filter class
private static final boolean DEBUG = true; // Bật debug log
```

### 2. Thêm trang công khai:
```java
// Trong RoleFilter.java
PUBLIC_PAGES.add("/new-public-page.jsp");
```

### 3. Thêm quyền cho role:
```java
// Trong RoleFilter.java
ROLE_ACCESS_MAP.get("PATIENT").add("/new-patient-servlet");
```

### 4. Thêm CSRF protection:
```java
// Trong SecurityFilter.java
CSRF_PROTECTED_PAGES.add("/new-protected-servlet");
```

## 🔧 TROUBLESHOOTING

### Lỗi thường gặp:

1. **Tiếng Việt bị lỗi font**:
   - Kiểm tra EncodingFilter có chạy không
   - Đảm bảo JSP có `<%@ page contentType="text/html;charset=UTF-8" %>`

2. **Bị chặn truy cập**:
   - Kiểm tra role của user
   - Kiểm tra đường dẫn có trong ROLE_ACCESS_MAP không
   - Xem log debug để trace

3. **Security filter chặn request hợp lệ**:
   - Kiểm tra input có chứa pattern đặc biệt không
   - Tạm thời tắt SecurityFilter để test
   - Thêm exception cho pattern cụ thể

4. **CSRF error**:
   - Kiểm tra Referer header
   - Đảm bảo request từ cùng domain
   - Tạm thời tắt CSRF cho testing

## 📝 LOGS

### Debug logs:
```
🔤 EncodingFilter: GET /services | Encoding: UTF-8
🛡️ SecurityFilter: GET /services
✅ Security check passed: /services
🔍 RoleFilter: GET /services
✅ Public page: /services
```

### Error logs:
```
🚫 XSS attack detected: /search?q=<script>alert(1)</script>
🚫 SQL Injection attack detected: /user?id=1' OR '1'='1
❌ Access denied for PATIENT to /manager_tongquan.jsp
```

## 🔄 UPDATES

### Version 1.0:
- ✅ Basic RoleFilter
- ✅ EncodingFilter for UTF-8
- ✅ SecurityFilter with XSS/SQL protection
- ✅ AuthenticationFilter (optional)

### Planned Features:
- 🔄 Advanced Rate Limiting with Redis
- 🔄 JWT Token Authentication
- 🔄 Advanced CSRF with tokens
- 🔄 Session Management
- 🔄 Audit Logging

---

**📞 Support**: TranHongPhuoc  
**🏥 Project**: Dental Clinic Management System  
**📅 Last Updated**: 2025-06-14 