# Chức năng dành cho Bác sĩ (Doctor)

## 1. Chức năng chính
- Xem tổng quan công việc, lịch hẹn, thống kê
- Xem và chỉnh sửa hồ sơ cá nhân
- Đổi mật khẩu
- Xem lịch làm việc theo tuần/ngày/tháng
- Đăng ký lịch làm việc (fulltime/parttime, xin nghỉ)
- Xem danh sách cuộc hẹn trong ngày, đã hoàn thành, đã hủy
- Xem chi tiết, tạo, cập nhật phiếu khám/báo cáo y tế
- Xem danh sách bệnh nhân, đơn thuốc, lịch sử khám
- Trò chuyện với bệnh nhân (nếu có)

## 2. Các Servlet phục vụ Doctor
| Tên Servlet | Đường dẫn | Chức năng chính |
|-------------|-----------|-----------------|
| `DoctorHomePageServlet` | /jsp/doctor/doctor_tongquan.jsp | Trang tổng quan, thống kê, danh sách hẹn hôm nay |
| `DoctorProfileServlet` | /doctor_trangcanhan | Xem hồ sơ cá nhân bác sĩ |
| `EditDoctorServlet` | /EditDoctorServlet | Chỉnh sửa thông tin cá nhân bác sĩ |
| `DoctorChangePasswordServlet` | /DoctorChangePasswordServlet | Đổi mật khẩu |
| `DoctorScheduleServlet` | /doctor-schedule | Xem lịch làm việc cá nhân (tuần/ngày) |
| `DoctorRegisterScheduleServlet` | /DoctorRegisterScheduleServlet | Đăng ký lịch làm việc, xin nghỉ |
| `DoctorScheduleConfirmServlet` | (nội bộ) | Xác nhận lịch làm việc, lấy lịch trống |
| `DoctorAppointmentsServlet` | (nội bộ) | Xem danh sách cuộc hẹn trong ngày |
| `CompletedAppointmentsServlet` | /completedAppointments | Xem danh sách cuộc hẹn đã hoàn thành |
| `CreateMedicalReportServlet` | (nội bộ) | Hiển thị form tạo phiếu khám |
| `MedicalReportServlet` | (nội bộ) | Tạo báo cáo y tế, đơn thuốc |
| `ViewReportServlet` | /ViewReportServlet | Xem chi tiết báo cáo y tế |
| ... | ... | ... |

## 3. Các file JSP giao diện Doctor
- `doctor_tongquan.jsp`: Trang tổng quan
- `doctor_trangcanhan.jsp`: Hồ sơ cá nhân
- `doctor_caidat.jsp`: Cài đặt thông tin cá nhân
- `doctor_changepassword.jsp`: Đổi mật khẩu
- `doctor_trongngay.jsp`: Danh sách cuộc hẹn trong ngày
- `doctor_ketqua.jsp`: Danh sách cuộc hẹn đã hoàn thành
- `doctor_bihuy.jsp`: Danh sách cuộc hẹn đã hủy
- `doctor_trongtuan.jsp`: Lịch làm việc theo tuần/ngày
- `doctor_lichtrongthang.jsp`: Lịch làm việc theo tháng
- `doctor_dangkilich.jsp`: Đăng ký lịch làm việc/đăng ký nghỉ
- `doctor_phieukham.jsp`: Form tạo phiếu khám
- `doctor_viewMedicalReport.jsp`: Xem chi tiết báo cáo y tế
- `doctor_no_report_found.jsp`: Không tìm thấy báo cáo
- `doctor_thembaocao.jsp`: Thêm báo cáo y tế
- `doctor_taikham.jsp`: Quản lý tái khám
- `doctor_menu.jsp`, `doctor_header.jsp`: Menu, header chung
- `success.jsp`, `error_page.jsp`, ...

## 4. Một số method tiêu biểu trong các servlet
### DoctorHomePageServlet
- `doGet`, `doPost`: Xử lý request tổng quan
- `prepareDoctorInfo`: Chuẩn bị thông tin bác sĩ
- `prepareStatisticsData`: Chuẩn bị dữ liệu thống kê, danh sách hẹn

### DoctorProfileServlet
- `doGet`: Lấy thông tin hồ sơ cá nhân bác sĩ

### EditDoctorServlet
- `doGet`: Hiển thị form chỉnh sửa thông tin
- `doPost`: Xử lý cập nhật thông tin cá nhân

### DoctorChangePasswordServlet
- `doPost`: Xử lý đổi mật khẩu

### DoctorScheduleServlet
- `doGet`: Xử lý xem lịch làm việc (tuần/ngày)
- `showPersonalSchedule`: Hiển thị toàn bộ lịch
- `showSchedulesByDate`: Hiển thị lịch theo ngày

### DoctorRegisterScheduleServlet
- `doGet`: Hiển thị form đăng ký lịch làm việc
- `doPost`: Xử lý đăng ký lịch làm việc/đăng ký nghỉ

### DoctorAppointmentsServlet
- `doGet`: Lấy danh sách cuộc hẹn trong ngày

### CompletedAppointmentsServlet
- `doGet`: Lấy danh sách cuộc hẹn đã hoàn thành

### CreateMedicalReportServlet
- `doGet`: Hiển thị form tạo phiếu khám

### MedicalReportServlet
- `doPost`: Tạo báo cáo y tế, đơn thuốc

### ViewReportServlet
- `doGet`: Xem chi tiết báo cáo y tế

### (và nhiều servlet khác hỗ trợ các chức năng chuyên sâu)

## 5. Các method DAO tiêu biểu cho Doctor

### DoctorDAO
- `getDoctorInfo(int doctorId)`: Lấy thông tin chi tiết bác sĩ theo ID
- `getDoctorByUserId(int userId)`: Lấy thông tin bác sĩ theo userId
- `getAllDoctors()`, `getAllDoctorsOnline()`: Lấy danh sách bác sĩ
- `getWorkDaysOfDoctor(long doctorId, int year, int month)`: Lấy các ngày làm việc của bác sĩ
- `getAppointmentsByUserId(Integer userId)`: Lấy danh sách lịch hẹn theo userId
- `getDoctorById(long doctorId)`: Lấy thông tin bác sĩ theo doctorId
- `updateDoctor(Doctors doctor)`: Cập nhật thông tin bác sĩ
- `updateDoctorStatus(long doctorId, String status)`: Cập nhật trạng thái bác sĩ
- `updatePassword(int userId, String hashedPassword)`: Đổi mật khẩu
- `insertMedicalReport(...)`: Thêm báo cáo y tế
- `insertPrescription(...)`: Thêm đơn thuốc
- `getMedicalReportById(int reportId)`, `getMedicalReportByAppointmentId(int appointmentId)`: Lấy báo cáo y tế
- `getPrescriptionsByReportId(int reportId)`: Lấy đơn thuốc theo báo cáo
- `getTimeSlotByAppointmentId(int appointmentId)`: Lấy khung giờ khám
- `getMedicalReportsByDoctorId(long doctorId)`: Lấy danh sách báo cáo y tế của bác sĩ
- ...

### DoctorScheduleDAO
- `getSchedulesByDoctorId(long doctorId)`: Lấy lịch làm việc của bác sĩ
- `getAllPendingSchedules()`: Lấy các lịch chờ xác nhận
- `getApprovedSchedulesByDoctorId(long doctorId)`: Lấy lịch đã duyệt của bác sĩ
- `addSchedule(DoctorSchedule schedule)`: Thêm lịch làm việc/đăng ký nghỉ
- `updateScheduleStatus(int scheduleId, String status)`: Cập nhật trạng thái lịch
- `deleteSchedule(int scheduleId)`: Xóa lịch làm việc
- `getAvailableSchedulesByDoctor(int doctorId)`: Lấy lịch trống để đặt hẹn
- ...

### AppointmentDAO
- `getAll()`: Lấy tất cả lịch hẹn
- `getAppointmentById(int appointmentId)`: Lấy chi tiết lịch hẹn
- `getAppointmentsByDate(java.sql.Date date)`: Lấy lịch hẹn theo ngày
- `getAppointmentsByDoctorId(long doctorId)`: Lấy lịch hẹn theo bác sĩ
- `getAppointmentsByUserId(int userId)`: Lấy lịch hẹn theo userId
- `createAppointment(Appointment appointment)`: Tạo lịch hẹn mới
- `updateAppointment(Appointment appointment)`: Cập nhật lịch hẹn
- `updateAppointmentStatus(int appointmentId, String status)`: Đổi trạng thái lịch hẹn
- ...

### PatientDAO
- `getPatientById(int id)`: Lấy thông tin bệnh nhân theo ID
- `getPatientByUserId(int userId)`: Lấy thông tin bệnh nhân theo userId
- `getAll()`, `getAllPatients()`: Lấy danh sách bệnh nhân
- `searchPatients(String keyword)`: Tìm kiếm bệnh nhân
- ...

### MedicineDAO
- `getAllMedicine()`: Lấy danh sách thuốc
- `hasEnoughStock(int medicineId, int requiredQty)`: Kiểm tra tồn kho
- `reduceMedicineStock(int medicineId, int quantity)`: Trừ kho thuốc
- `insertMedicalReport(...)`, `insertPrescription(...)`: Thêm báo cáo y tế, đơn thuốc
- ...

### NotificationDAO
- `createNotification(Notification notification)`: Tạo thông báo
- `getNotificationsByUserId(int userId)`: Lấy thông báo theo user
- ...

### Một số DAO khác hỗ trợ: BillDAO, ServiceDAO, StaffDAO, ...

> **Lưu ý:**
> - Các method trên chỉ là tiêu biểu, bạn có thể xem chi tiết trong từng file DAO tương ứng.

---
**Lưu ý:**
- Các chức năng đều kiểm tra session, phân quyền, và chuyển hướng hợp lý.
- Các JSP đều nằm trong `web/jsp/doctor/`.
- Các DAO hỗ trợ truy xuất dữ liệu cho các chức năng trên.

Bạn có thể mở rộng file này khi bổ sung chức năng mới cho Doctor. 