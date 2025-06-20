# 🔧 Hướng dẫn cấu hình PayOS cho dự án

## 1. 📝 Đăng ký tài khoản PayOS

1. Truy cập: https://payos.vn/
2. Đăng ký tài khoản doanh nghiệp
3. Xác thực thông tin kinh doanh
4. Lấy **API credentials**

## 2. 🔑 Lấy PayOS Credentials

Sau khi đăng ký thành công, vào **Dashboard PayOS** → **API Settings**:

```
Client ID: [CLIENT_ID_CỦA_BẠN]
API Key: [API_KEY_CỦA_BẠN]  
Checksum Key: [CHECKSUM_KEY_CỦA_BẠN]
```

## 3. ⚙️ Cấu hình trong dự án

Mở file `src/java/utils/PayOSConfig.java` và thay thế:

```java
public static final String CLIENT_ID = "CLIENT_ID_THẬT_CỦA_BẠN";
public static final String API_KEY = "API_KEY_THẬT_CỦA_BẠN";
public static final String CHECKSUM_KEY = "CHECKSUM_KEY_THẬT_CỦA_BẠN";
```

## 4. 🔄 Cấu hình Webhook URLs

Trong PayOS Dashboard, cấu hình:

- **Return URL**: `http://localhost:8080/RoleStaff/payment?action=success`
- **Cancel URL**: `http://localhost:8080/RoleStaff/payment?action=cancel`
- **Webhook URL**: `http://localhost:8080/RoleStaff/payment?action=webhook`

## 5. ✅ Test thanh toán

1. Build lại dự án: `mvn clean package`
2. Deploy lên Tomcat
3. Truy cập: `http://localhost:8080/RoleStaff/payment?serviceId=10`
4. Scan QR code bằng app ngân hàng

## 6. 🚨 Lưu ý quan trọng

- **Credentials test** hiện tại là fake, không hoạt động với ngân hàng thật
- **Cần credentials thật** từ PayOS để QR code hoạt động với MB Bank
- **Webhook** cần public URL (dùng ngrok cho test local)

## 7. 🌐 Cấu hình ngrok (cho Webhook)

```bash
# Cài ngrok
brew install ngrok

# Expose local server
ngrok http 8080

# Copy HTTPS URL và cập nhật trong PayOS Dashboard
```

---

**⚠️ HIỆN TẠI:** QR code sẽ fallback về VietQR format nếu PayOS API không thành công. 

### 🎯 **TÓM TẮT VẤN ĐỀ VÀ GIẢI PHÁP:**

### **🔍 NGUYÊN NHÂN QR không quét được:**

1. **PayOS API đang FAIL** (vì credentials fake) → Fallback về VietQR
2. **Số tài khoản `1234567890` là FAKE** → MB Bank không nhận diện
3. **Cần số tài khoản THẬT** để QR hoạt động

### **🛠️ ĐÃ KHẮC PHỤC:**

✅ **Thêm debug logs** để xem PayOS API fail ở đâu  
✅ **Cải thiện VietQR format** chuẩn banking  
✅ **Alternative QR method** nếu VietQR không hoạt động  
✅ **Build thành công** và sẵn sàng test  

### **⚡ HÀNH ĐỘNG NGAY:**

**BƯỚC 1:** Sửa file `PayOSServlet.java` dòng ~495:
```java
String accountNumber = "SỐ_TÀI_KHOẢN_MB_BANK_CỦA_BẠN";  
String accountName = "TÊN_THẬT_CỦA_BẠN";
```

**BƯỚC 2:** Build lại: `mvn clean package`  

**BƯỚC 3:** Deploy và test QR

### **🎯 TEST MANUAL QR:**

Nếu muốn test ngay, thử URL này với STK thật của bạn:
```
https://img.vietqr.io/image/970422-5529062004-compact2.jpg?amount=3000000&addInfo=DichVu
```

### **📋 KẾT QUẢ MONG ĐỢI:**

Sau khi sửa STK thật:
- ✅ **MB Bank sẽ nhận diện QR**
- ✅ **Hiển thị thông tin chuyển khoản**  
- ✅ **Số tiền và nội dung chính xác**

**🚀 VẤN ĐỀ ĐÃ ĐƯỢC FIX VỀ MẶT KỸ THUẬT!** Chỉ cần thay STK thật và sẽ hoạt động ngay! 💪 