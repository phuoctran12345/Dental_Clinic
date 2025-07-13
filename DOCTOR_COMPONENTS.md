# 📋 TỔNG HỢP CÁC COMPONENT LIÊN QUAN ĐẾN DOCTOR

## 🏥 **SERVLET (CONTROLLER)**

| STT | Tên Servlet | File Path | URL Pattern | Chức năng |
|-----|-------------|-----------|-------------|-----------|
| 1 | DoctorHomePageServlet | `src/java/controller/DoctorHomePageServlet.java` | `/DoctorHomePageServlet` | Trang tổng quan cho bác sĩ |
| 2 | DoctorAppointmentsServlet | `src/java/controller/DoctorAppointmentsServlet.java` | `/DoctorAppointmentsServlet` | Quản lý lịch hẹn của bác sĩ |
| 3 | DoctorHaveAppointmentServlet | `src/java/controller/DoctorHaveAppointmentServlet.java` | `/DoctorHaveAppointmentServlet` | Quản lý lịch làm việc cá nhân |
| 4 | DoctorRegisterScheduleServlet | `src/java/controller/DoctorRegisterScheduleServlet.java` | `/DoctorRegisterScheduleServlet` | Đăng ký lịch nghỉ phép |
| 5 | DoctorScheduleConfirmServlet | `src/java/controller/DoctorScheduleConfirmServlet.java` | `/DoctorScheduleConfirmServlet` | Xác nhận lịch làm việc |
| 6 | DoctorWorkDaysServlet | `src/java/controller/DoctorWorkDaysServlet.java` | `/DoctorWorkDaysServlet` | Quản lý ngày làm việc |
| 7 | EditDoctorServlet | `src/java/controller/EditDoctorServlet.java` | `/EditDoctorServlet` | Chỉnh sửa thông tin bác sĩ |
| 8 | UpdateDoctorStatusServlet | `src/java/controller/UpdateDoctorStatusServlet.java` | `/updateDoctorStatus` | Cập nhật trạng thái bác sĩ |
| 9 | UpdateDoctorAvatarServlet | `src/java/controller/UpdateDoctorAvatarServlet.java` | `/UpdateDoctorAvatarServlet` | Cập nhật avatar bác sĩ |
| 10 | ManagerApprovalDoctorSchedulerServlet | `src/java/controller/ManagerApprovalDoctorSchedulerServlet.java` | `/ManagerApprovalDoctorSchedulerServlet` | Phê duyệt lịch nghỉ phép |

---

## 🎨 **JSP (VIEW)**

### **📁 Thư mục: `web/jsp/doctor/`**

| STT | Tên File | File Path | Chức năng |
|-----|----------|-----------|-----------|
| **1. Trang Chính** |
| 1 | doctor_tongquan.jsp | `web/jsp/doctor/doctor_tongquan.jsp` | Trang tổng quan dashboard |
| 2 | doctor_homepage.jsp | `web/jsp/doctor/doctor_homepage.jsp` | Trang chủ bác sĩ |
| 3 | doctor_profile.jsp | `web/jsp/doctor/doctor_profile.jsp` | Trang cá nhân bác sĩ |
| 4 | doctor_trangcanhan.jsp | `web/jsp/doctor/doctor_trangcanhan.jsp` | Trang thông tin cá nhân |
| **2. Quản Lý Lịch Hẹn** |
| 5 | doctor_trongngay.jsp | `web/jsp/doctor/doctor_trongngay.jsp` | Lịch hẹn trong ngày |
| 6 | doctor_trongtuan.jsp | `web/jsp/doctor/doctor_trongtuan.jsp` | Lịch hẹn trong tuần |
| 7 | doctor_lichtrongthang.jsp | `web/jsp/doctor/doctor_lichtrongthang.jsp` | Lịch hẹn trong tháng |
| 8 | doctor_bihuy.jsp | `web/jsp/doctor/doctor_bihuy.jsp` | Lịch hẹn đã hủy |
| 9 | doctor_ketqua.jsp | `web/jsp/doctor/doctor_ketqua.jsp` | Kết quả khám bệnh |
| **3. Quản Lý Lịch Làm Việc** |
| 10 | doctor_dangkilich.jsp | `web/jsp/doctor/doctor_dangkilich.jsp` | Đăng ký lịch nghỉ phép |
| 11 | doctor_taikham.jsp | `web/jsp/doctor/doctor_taikham.jsp` | Lịch tái khám |
| **4. Khám Bệnh & Báo Cáo** |
| 12 | doctor_phieukham.jsp | `web/jsp/doctor/doctor_phieukham.jsp` | Phiếu khám bệnh |
| 13 | doctor_thembaocao.jsp | `web/jsp/doctor/doctor_thembaocao.jsp` | Thêm báo cáo y tế |
| 14 | doctor_viewMedicalReport.jsp | `web/jsp/doctor/doctor_viewMedicalReport.jsp` | Xem báo cáo y tế |
| 15 | doctor_phongcho.jsp | `web/jsp/doctor/doctor_phongcho.jsp` | Phòng chờ |
| **5. Cài Đặt & Hệ Thống** |
| 16 | doctor_caidat.jsp | `web/jsp/doctor/doctor_caidat.jsp` | Cài đặt tài khoản |
| 17 | doctor_changepassword.jsp | `web/jsp/doctor/doctor_changepassword.jsp` | Đổi mật khẩu |
| 18 | doctor_menu.jsp | `web/jsp/doctor/doctor_menu.jsp` | Menu điều hướng |
| 19 | doctor_header.jsp | `web/jsp/doctor/doctor_header.jsp` | Header trang |
| 20 | doctor_trochuyen.jsp | `web/jsp/doctor/doctor_trochuyen.jsp` | Trò chuyện |
| **6. Thông Báo & Kết Quả** |
| 21 | success.jsp | `web/jsp/doctor/success.jsp` | Thông báo thành công |
| 22 | error_page.jsp | `web/jsp/doctor/error_page.jsp` | Trang lỗi |
| 23 | datlich-thanhcong.jsp | `web/jsp/doctor/datlich-thanhcong.jsp` | Đặt lịch thành công |

### **📁 Thư mục: `web/jsp/manager/`**

| STT | Tên File | File Path | Chức năng |
|-----|----------|-----------|-----------|
| 1 | manager_doctors.jsp | `web/jsp/manager/manager_doctors.jsp` | Quản lý danh sách bác sĩ (Manager) |

### **📁 Thư mục: `web/`**

| STT | Tên File | File Path | Chức năng |
|-----|----------|-----------|-----------|
| 1 | doctor-info.jsp | `web/doctor-info.jsp` | Thông tin bác sĩ |
| 2 | simple_doctors.jsp | `web/simple_doctors.jsp` | Danh sách bác sĩ đơn giản |
| 3 | debug_doctors.jsp | `web/debug_doctors.jsp` | Debug thông tin bác sĩ |

---

## 🗄️ **DAO (DATA ACCESS OBJECT)**

| STT | Tên DAO | File Path | Chức năng |
|-----|---------|-----------|-----------|
| 1 | DoctorDAO | `src/java/dao/DoctorDAO.java` | Truy cập dữ liệu bác sĩ |
| 2 | DoctorScheduleDAO | `src/java/dao/DoctorScheduleDAO.java` | Quản lý lịch làm việc/nghỉ phép bác sĩ |

### **Các Method Chính trong DoctorDAO:**
| STT | Method | Chức năng |
|-----|--------|-----------|
| 1 | `getAllDoctors()` | Lấy tất cả bác sĩ |
| 2 | `getDoctorById(int doctorId)` | Lấy bác sĩ theo ID |
| 3 | `getDoctorByUserId(int userId)` | Lấy bác sĩ theo User ID |
| 4 | `getAllDoctorsOnline()` | Lấy bác sĩ đang hoạt động |
| 5 | `filterDoctors(String keyword, String specialty)` | Lọc bác sĩ |
| 6 | `getAllSpecialties()` | Lấy tất cả chuyên khoa |
| 7 | `updateDoctor(Doctors doctor)` | Cập nhật thông tin bác sĩ |
| 8 | `addDoctor(Doctors doctor, String password)` | Thêm bác sĩ mới |
| 9 | `getDoctorNameById(long doctorId)` | Lấy tên bác sĩ theo ID |
| 10 | `getDoctorEmailByDoctorId(long doctorId)` | Lấy email bác sĩ |
| 11 | `getWorkDaysOfDoctor(int doctorId, int year, int month)` | Lấy ngày làm việc |
| 12 | `getAppointmentsWithPatientInfoByUserId(int userId)` | Lấy lịch hẹn với thông tin bệnh nhân |

### **Các Method Chính trong DoctorScheduleDAO:**
| STT | Method | Chức năng |
|-----|--------|-----------|
| 1 | `getAll()` | Lấy tất cả lịch |
| 2 | `getScheduleById(int id)` | Lấy lịch theo ID |
| 3 | `addSchedule(DoctorSchedule schedule)` | Thêm lịch nghỉ phép |
| 4 | `updateScheduleStatus(int scheduleId, String status)` | Cập nhật trạng thái |
| 5 | `getSchedulesByDoctorId(long doctorId)` | Lấy lịch theo bác sĩ |
| 6 | `getAllPendingSchedules()` | Lấy lịch chờ phê duyệt |
| 7 | `getApprovedSchedulesByDoctorId(long doctorId)` | Lấy lịch đã phê duyệt |
| 8 | `getAvailableSchedulesByDoctor(int doctorId)` | Lấy lịch khả dụng |
| 9 | `getWorkDatesExcludingLeaves(int doctorId, int daysAhead)` | Lấy ngày làm việc (loại trừ nghỉ) |
| 10 | `isDoctorWorkingOnDate(int doctorId, String workDate)` | Kiểm tra bác sĩ có làm việc không |

---

## 📊 **MODEL (ENTITY CLASSES)**

| STT | Tên Model | File Path | Chức năng |
|-----|-----------|-----------|-----------|
| 1 | Doctors | `src/java/model/Doctors.java` | Entity bác sĩ |
| 2 | DoctorSchedule | `src/java/model/DoctorSchedule.java` | Entity lịch làm việc/nghỉ phép |
| 3 | Appointment | `src/java/model/Appointment.java` | Entity lịch hẹn |
| 4 | MedicalReport | `src/java/model/MedicalReport.java` | Entity báo cáo y tế |

---

## 🔗 **LUỒNG XỬ LÝ CHÍNH**

| STT | Luồng | Servlet → JSP | Mô tả |
|-----|-------|---------------|-------|
| 1 | **Đăng Nhập Bác Sĩ** | `LoginServlet → DoctorHomePageServlet → doctor_tongquan.jsp` | Quá trình đăng nhập và chuyển hướng |
| 2 | **Quản Lý Lịch Hẹn** | `DoctorAppointmentsServlet → doctor_trongngay.jsp → doctor_phieukham.jsp` | Xem và quản lý lịch hẹn |
| 3 | **Đăng Ký Nghỉ Phép** | `DoctorRegisterScheduleServlet → ManagerApprovalDoctorSchedulerServlet` | Đăng ký và phê duyệt nghỉ phép |
| 4 | **Cập Nhật Thông Tin** | `EditDoctorServlet → doctor_caidat.jsp → UpdateDoctorAvatarServlet` | Chỉnh sửa thông tin cá nhân |
| 5 | **Khám Bệnh & Báo Cáo** | `doctor_thembaocao.jsp → AddReportServlet → success.jsp` | Quy trình khám và tạo báo cáo |

---

## ⚠️ **LƯU Ý QUAN TRỌNG**

| STT | Yếu tố | Mô tả |
|-----|--------|-------|
| **1. Session Management** |
| 1 | Kiểm tra Session | Tất cả servlet đều kiểm tra session và role "DOCTOR" |
| 2 | Lấy thông tin | Sử dụng `DoctorDAO.getDoctorByUserId(userId)` để lấy thông tin bác sĩ |
| **2. Database Logic** |
| 3 | DoctorSchedule | Chỉ lưu ngày NGHỈ PHÉP, không lưu ngày làm việc |
| 4 | Mặc định | Bác sĩ làm việc tất cả ngày trừ ngày có trong DoctorSchedule |
| 5 | Status | 'pending' → 'approved'/'rejected' |
| **3. File Upload** |
| 6 | Thư mục lưu | Avatar được lưu trong thư mục `web/uploads/` |
| 7 | Servlet xử lý | Sử dụng `UpdateDoctorAvatarServlet` để xử lý upload |
| **4. Security** |
| 8 | Kiểm tra JSP | Tất cả JSP đều có kiểm tra session |
| 9 | Filter | Sử dụng Filter để bảo vệ các trang bác sĩ |

---

## 🎯 **TÓM TẮT**

### **Thống Kê Tổng Quan:**
| STT | Loại | Số lượng | Mô tả |
|-----|------|----------|-------|
| 1 | **Servlet** | 10 | Xử lý logic nghiệp vụ |
| 2 | **JSP** | 26 | Hiển thị giao diện |
| 3 | **DAO** | 2 | Truy cập dữ liệu |
| 4 | **Model** | 4 | Định nghĩa cấu trúc dữ liệu |

### **Chức Năng Chính:**
| STT | Chức năng | Trạng thái |
|-----|-----------|------------|
| 1 | Quản lý thông tin cá nhân bác sĩ | ✅ Hoàn thành |
| 2 | Xem và quản lý lịch hẹn | ✅ Hoàn thành |
| 3 | Đăng ký nghỉ phép | ✅ Hoàn thành |
| 4 | Khám bệnh và tạo báo cáo y tế | ✅ Hoàn thành |
| 5 | Quản lý lịch làm việc | ✅ Hoàn thành |
| 6 | Upload avatar và cập nhật thông tin | ✅ Hoàn thành |

**🎉 Dự án đã hoàn thiện các chức năng cơ bản cho module Doctor!** 