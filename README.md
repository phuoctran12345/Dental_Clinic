# 📋 TÓM TẮT CHỨC NĂNG - SERVLET - JSP

## 🎯 Hệ thống quản lý lịch làm việc & nghỉ phép

---

## 👨‍⚕️ **DOCTOR (Bác sĩ)**

### 🔹 **Chức năng:** Đăng ký lịch nghỉ phép
- **Servlet:** `DoctorRegisterScheduleServlet.java`
- **JSP:** `doctor_dangkilich.jsp`
- **Mô tả:** Bác sĩ có thể đăng ký nghỉ phép, xem lịch nghỉ đã đăng ký và trạng thái phê duyệt

---

## 👥 **STAFF (Nhân viên)**

### 🔹 **Chức năng 1:** Đăng ký lịch làm việc/nghỉ phép
- **Servlet:** `StaffRegisterSecheduleServlet.java`
- **JSP:** `staff_dangkilich.jsp`
- **Mô tả:** 
  - **Staff Fulltime:** Đăng ký nghỉ phép
  - **Staff Parttime:** Đăng ký ca làm việc (Sáng/Chiều/Cả ngày)

### 🔹 **Chức năng 2:** Xem lịch đã đăng ký
- **Servlet:** `StaffScheduleServlet.java`
- **JSP:** `staff_dangkilich.jsp` (cùng page)
- **Mô tả:** Hiển thị danh sách lịch đã đăng ký và trạng thái

### 🔹 **Chức năng 3:** Đăng ký nghỉ phép (page riêng)
- **Servlet:** `StaffRegisterSecheduleServlet.java` 
- **JSP:** `staff_xinnghi.jsp`
- **Mô tả:** Form riêng để đăng ký nghỉ phép cho staff

---

## 👑 **MANAGER (Quản lý)**

### 🔹 **Chức năng 1:** Phê duyệt lịch Bác sĩ
- **Servlet:** `ManagerApprovalDoctorSchedulerServlet.java`
- **JSP:** `manager_phancong.jsp` (tab Bác sĩ)
- **Mô tả:** Xem và phê duyệt/từ chối lịch nghỉ phép của bác sĩ

### 🔹 **Chức năng 2:** Phê duyệt lịch Staff
- **Servlet:** `ManagerApprovalStaffScheduleServlet.java`
- **JSP:** `manager_phancong.jsp` (tab Nhân viên)
- **Mô tả:** Xem và phê duyệt/từ chối lịch làm việc/nghỉ phép của staff

### 🔹 **Chức năng 3:** Xử lý phê duyệt Staff
- **Servlet:** `StaffScheduleApprovalServlet.java`
- **JSP:** Không có (chỉ xử lý logic)
- **Mô tả:** Backend logic để approve/reject lịch staff

---

## 🏥 **PATIENT/USER (Bệnh nhân)**

### 🔹 **Chức năng:** Xem lịch làm việc bác sĩ & đặt lịch
- **Servlet:** `BookingPageServlet.java`
- **JSP:** `user_datlich.jsp`
- **Mô tả:** 
  - Xem lịch làm việc thực tế của bác sĩ (đã loại bỏ ngày nghỉ)
  - Đặt lịch khám với bác sĩ

---

## 📊 **DATABASE & MODELS**

### 🔹 **Staff Schedule Management**
- **DAO:** `StaffScheduleDAO.java`
- **Model:** `StaffSchedule.java`
- **Table:** `StaffSchedule`

### 🔹 **Doctor Schedule Management**
- **DAO:** `DoctorScheduleDAO.java` (đã có sẵn, được cập nhật)
- **Model:** `DoctorSchedule.java` (đã có sẵn)
- **Table:** `DoctorSchedule`

---

## 🔄 **LUỒNG XỬ LÝ CHÍNH**

### **1. Doctor Flow:**
```
Doctor → DoctorRegisterScheduleServlet → doctor_dangkilich.jsp
Manager → ManagerApprovalDoctorSchedulerServlet → manager_phancong.jsp
```

### **2. Staff Flow:**
```
Staff → StaffRegisterSecheduleServlet → staff_dangkilich.jsp
Staff → StaffScheduleServlet → (xem lịch đã đăng ký)
Manager → ManagerApprovalStaffScheduleServlet → manager_phancong.jsp
Manager → StaffScheduleApprovalServlet → (xử lý approve/reject)
```

### **3. Patient Flow:**
```
Patient → BookingPageServlet → user_datlich.jsp
(Xem lịch bác sĩ đã loại bỏ ngày nghỉ)
```

---

## 🎯 **PHÂN BIỆT THEO VAI TRÒ**

| Vai trò | Chức năng chính | Servlet chính | JSP chính |
|---------|----------------|---------------|-----------|
| 👨‍⚕️ **Doctor** | Đăng ký nghỉ phép | `DoctorRegisterScheduleServlet` | `doctor_dangkilich.jsp` |
| 👥 **Staff Fulltime** | Đăng ký nghỉ phép | `StaffRegisterSecheduleServlet` | `staff_dangkilich.jsp`<br/>`staff_xinnghi.jsp` |
| 👷 **Staff Parttime** | Đăng ký ca làm việc | `StaffRegisterSecheduleServlet` | `staff_dangkilich.jsp` |
| 👑 **Manager** | Phê duyệt lịch Bác sĩ | `ManagerApprovalDoctorSchedulerServlet` | `manager_phancong.jsp` (tab Bác sĩ) |
| 👑 **Manager** | Phê duyệt lịch Staff | `ManagerApprovalStaffScheduleServlet` | `manager_phancong.jsp` (tab Nhân viên) |
| 🏥 **Patient/User** | Xem & đặt lịch | `BookingPageServlet` | `user_datlich.jsp` |

---

## 🔍 **CHI TIẾT THEO LOẠI STAFF**

### 👥 **Staff Fulltime (Nhân viên toàn thời gian)**
- **Chức năng:** Chỉ đăng ký **NGHỈ PHÉP**
- **Logic:** `slot_id = null` (không có ca cụ thể)
- **Servlet:** `StaffRegisterSecheduleServlet.java`
- **JSP:** 
  - `staff_dangkilich.jsp` (form chính)
  - `staff_xinnghi.jsp` (form nghỉ phép riêng)
- **Mô tả:** Staff fulltime mặc định làm việc tất cả ngày, chỉ đăng ký khi cần nghỉ

### 👷 **Staff Parttime (Nhân viên bán thời gian)**  
- **Chức năng:** Đăng ký **CA LÀM VIỆC**
- **Logic:** `slot_id = 1,2,3` (Ca Sáng/Chiều/Cả ngày)
- **Servlet:** `StaffRegisterSecheduleServlet.java`
- **JSP:** `staff_dangkilich.jsp`
- **Mô tả:** Staff parttime phải đăng ký ca cụ thể muốn làm việc

---

## 🎯 **BẢNG TÓM TẮT CHI TIẾT**

| **Vai trò** | **Employment Type** | **Chức năng** | **slot_id** | **Servlet** | **JSP** |
|-------------|---------------------|---------------|-------------|-------------|---------|
| 👨‍⚕️ **Doctor** | - | Nghỉ phép | `null` | `DoctorRegisterScheduleServlet` | `doctor_dangkilich.jsp` |
| 👥 **Staff** | **Fulltime** | Nghỉ phép | `null` | `StaffRegisterSecheduleServlet` | `staff_dangkilich.jsp`<br/>`staff_xinnghi.jsp` |
| 👷 **Staff** | **Parttime** | Ca làm việc | `1,2,3` | `StaffRegisterSecheduleServlet` | `staff_dangkilich.jsp` |
| 👑 **Manager** | - | Phê duyệt Doctor | - | `ManagerApprovalDoctorSchedulerServlet` | `manager_phancong.jsp` |
| 👑 **Manager** | - | Phê duyệt Staff | - | `ManagerApprovalStaffScheduleServlet` | `manager_phancong.jsp` |
| 🏥 **Patient** | - | Xem & đặt lịch | - | `BookingPageServlet` | `user_datlich.jsp` |

---

## 🔧 **CÁC SERVLET HỖ TRỢ**

1. **`StaffScheduleApprovalServlet`** - Xử lý approve/reject (backend only)
2. **`StaffScheduleServlet`** - Hiển thị lịch staff đã đăng ký
3. **`DoctorScheduleDAO`** - Cập nhật logic mới (lịch nghỉ thay vì lịch làm)

---

## 📝 **LOGIC QUAN TRỌNG**

### **DoctorSchedule Table:**
- ❌ **Cũ:** Lưu lịch làm việc
- ✅ **Mới:** Lưu lịch NGHỈ PHÉP
- **Mặc định:** Bác sĩ làm việc tất cả ngày, trừ ngày có trong DoctorSchedule

### **StaffSchedule Table:**
- **Fulltime:** `slot_id = null` (nghỉ phép)
- **Parttime:** `slot_id = 1,2,3` (ca làm việc)

---

**📌 Tóm tắt: 6 Servlets chính, 4 JSP chính, 2 DAO mới, phục vụ 4 nhóm người dùng khác nhau với các chức năng quản lý lịch hoàn chỉnh.** 