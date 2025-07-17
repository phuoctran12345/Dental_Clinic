# 🚀 HƯỚNG DẪN TỰ ĐỘNG DEPLOY LÊN VINAHOST

## 📋 **BƯỚC 1: MUA HOSTING VINAHOST**

### 1.1 Đăng ký gói LH2 (40,000 VND/tháng)
- Truy cập: https://secure.vinahost.vn
- Chọn gói **LH2** (7GB Disk, 2GB RAM, 1.5 CPU)
- Thanh toán và kích hoạt

### 1.2 Lấy thông tin FTP
Sau khi mua, VinaHost sẽ gửi email với:
- **FTP Host**: ftp.yourdomain.com
- **FTP Username**: your_username  
- **FTP Password**: your_password
- **FTP Port**: 21

---

## 🔧 **BƯỚC 2: CHUẨN BỊ CODE (TỰ ĐỘNG)**

### 2.1 Chạy script tự động
```bash
# Mở Terminal trên MacBook
cd /Users/tranhongphuoc/NetBeansProjects/PM/TestFull

# Cấp quyền thực thi
chmod +x deploy_to_vinahost.sh

# Chạy script tự động
./deploy_to_vinahost.sh
```

### 2.2 Kết quả mong đợi
```
🚀 BẮT ĐẦU DEPLOY LÊN VINAHOST
==================================
📋 Kiểm tra Java...
✅ Java OK
📋 Kiểm tra Apache Ant...
✅ Ant OK
🔨 Đang build project...
✅ Build thành công!
📁 File WAR: dist/TestFull.war
📁 Tạo thư mục deploy...
✅ Chuẩn bị deploy hoàn tất!
```

---

## 📤 **BƯỚC 3: UPLOAD CODE (TỰ ĐỘNG)**

### 3.1 Cài đặt FTP Client
```bash
# Cài đặt FileZilla (miễn phí)
brew install --cask filezilla
```

### 3.2 Upload tự động
1. Mở **FileZilla**
2. Nhập thông tin FTP từ VinaHost:
   - Host: `ftp.yourdomain.com`
   - Username: `your_username`
   - Password: `your_password`
   - Port: `21`
3. Kết nối thành công
4. Upload thư mục `deploy/` lên `/public_html/`
5. Đổi tên `TestFull.war` thành `ROOT.war`

---

## 🗄️ **BƯỚC 4: CẤU HÌNH DATABASE (TỰ ĐỘNG)**

### 4.1 Tạo database trên VinaHost
1. Đăng nhập **cPanel** của VinaHost
2. Vào **MySQL Databases**
3. Tạo database: `dental_clinic_db`
4. Tạo user: `dental_user`
5. Gán quyền cho user

### 4.2 Import dữ liệu
1. Vào **phpMyAdmin**
2. Chọn database `dental_clinic_db`
3. Import file `dental_clinic.sql` từ dự án

---

## 🆘 **BƯỚC 5: LIÊN HỆ SUPPORT (TỰ ĐỘNG)**

### 5.1 Copy đoạn tin nhắn này gửi Support:

```
Chào Support VinaHost,

Tôi cần hỗ trợ cấu hình Java Servlet/JSP cho dự án Dental Clinic.

THÔNG TIN DỰ ÁN:
- Framework: Java Servlet/JSP với Jakarta EE 5.0
- Build tool: Apache Ant
- Database: MySQL (đã tạo dental_clinic_db)
- Web container: Tomcat 10+ (hỗ trợ Jakarta EE 5.0)
- File WAR: ROOT.war (đã upload lên public_html)

YÊU CẦU CẤU HÌNH:
1. Cài đặt Tomcat 10+ (hỗ trợ Jakarta EE 5.0)
2. Cấu hình Java 11+ 
3. Deploy ROOT.war lên Tomcat
4. Cấu hình SSL certificate
5. Test website hoạt động

Gói hosting: LH2 (40,000 VND/tháng)

Cảm ơn Support!
```

### 5.2 Kênh liên hệ Support:
- **Live Chat**: Trên website VinaHost
- **Email**: support@vinahost.vn
- **Hotline**: 1900 6046

---

## ✅ **BƯỚC 6: KIỂM TRA HOÀN THÀNH**

### 6.1 Test website
- Truy cập: `https://yourdomain.com`
- Kiểm tra các tính năng:
  - ✅ Đăng nhập/Đăng ký
  - ✅ Booking lịch hẹn
  - ✅ Chat
  - ✅ Payment
  - ✅ Upload files

### 6.2 Test database
- Kiểm tra kết nối database
- Test các chức năng CRUD
- Kiểm tra email gửi

---

## 🆘 **XỬ LÝ LỖI THƯỜNG GẶP**

### Lỗi 1: "Java not found"
```bash
# Cài đặt Java
brew install openjdk@11
```

### Lỗi 2: "Ant not found"
```bash
# Cài đặt Ant
brew install ant
```

### Lỗi 3: "Database connection failed"
- Kiểm tra thông tin database trong `vinahost_connection_config.properties`
- Đảm bảo user có quyền truy cập

### Lỗi 4: "404 Not Found"
- Đảm bảo file đã đổi tên thành `ROOT.war`
- Liên hệ Support để deploy lên Tomcat

---

## 📞 **HỖ TRỢ KHẨN CẤP**

Nếu gặp vấn đề, liên hệ ngay:
- **VinaHost Support**: 1900 6046
- **Email**: support@vinahost.vn
- **Live Chat**: Trên website VinaHost

---

## 🎉 **HOÀN THÀNH!**

Sau khi hoàn thành tất cả bước trên:
- ✅ Website chạy trên: `https://yourdomain.com`
- ✅ Database hoạt động ổn định
- ✅ Email gửi được
- ✅ SSL bảo mật
- ✅ Backup tự động

**Chúc bạn thành công! 🚀** 