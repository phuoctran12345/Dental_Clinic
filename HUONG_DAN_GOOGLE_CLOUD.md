# 🌟 HƯỚNG DẪN CHI TIẾT THIẾT LẬP GOOGLE CLOUD VISION API

## 📝 Các bước thực hiện

### **Bước 1: Tạo Google Cloud Project**

1. **Truy cập Google Cloud Console:**
   - Vào: https://console.cloud.google.com/
   - Đăng nhập bằng tài khoản Google

2. **Tạo project mới:**
   - Click "Select a project" → "New Project"
   - Project name: `dental-clinic-face-recognition`
   - Location: để mặc định
   - Click "CREATE"

### **Bước 2: Enable Cloud Vision API**

1. **Vào API Library:**
   - Sidebar → "APIs & Services" → "Library"
   - Tìm kiếm: "Cloud Vision API"
   - Click vào "Cloud Vision API"
   - Click "ENABLE"

2. **Đợi API được kích hoạt** (1-2 phút)

### **Bước 3: Tạo Service Account**

1. **Vào IAM & Admin:**
   - Sidebar → "IAM & Admin" → "Service Accounts"
   - Click "CREATE SERVICE ACCOUNT"

2. **Điền thông tin:**
   - Service account name: `dental-clinic-face-service`
   - Service account ID: `dental-clinic-face-service` (tự động tạo)
   - Description: `Face recognition service for dental clinic`
   - Click "CREATE AND CONTINUE"

3. **Gán quyền:**
   - Role: chọn "Cloud Vision AI Service Agent"
   - Click "CONTINUE" → "DONE"

### **Bước 4: Tạo và tải JSON Key**

1. **Vào Service Account vừa tạo:**
   - Click vào "dental-clinic-face-service@..."
   - Tab "KEYS"
   - "ADD KEY" → "Create new key"
   - Type: chọn "JSON"
   - Click "CREATE"

2. **File JSON sẽ tự động download** về máy

### **Bước 5: Copy file JSON vào project**

1. **Rename file JSON:**
   - Đổi tên từ: `dental-clinic-face-recognition-xxxxx.json`
   - Thành: `dental-clinic-face-service.json`

2. **Copy vào project:**
   ```bash
   # Copy file vào thư mục src/java/
   src/java/dental-clinic-face-service.json
   ```

3. **Verify file đã đúng vị trí:**
   - File structure:
   ```
   TestFull/
   ├── src/
   │   ├── java/
   │   │   ├── dental-clinic-face-service.json  ← File này
   │   │   ├── controller/
   │   │   ├── dao/
   │   │   └── utils/
   ```

### **Bước 6: Thêm thư viện vào NetBeans**

1. **Right-click project → Properties**

2. **Categories → Libraries**

3. **Click "Add JAR/Folder"**

4. **Navigate tới `library_Assignment/` và chọn các file:**
   - ✅ `google-cloud-vision-3.30.0.jar`
   - ✅ `google-auth-library-oauth2-http-1.0.0.jar`
   - ✅ `protobuf-java-3.25.1.jar`
   - ✅ `grpc-api-1.60.1.jar`
   - ✅ `grpc-core-1.60.1.jar`
   - ✅ `grpc-context-1.60.1.jar`

5. **Click "Apply" → "OK"**

### **Bước 7: Kiểm tra setup**

1. **Build project để check lỗi import:**
   - F11 hoặc Clean and Build

2. **Nếu vẫn còn lỗi import:** thêm thêm các JAR files:
   - `google-api-client-*.jar`
   - `google-http-client-*.jar`
   - `guava-*.jar`

### **Bước 8: Test thử Face ID**

1. **Chạy project**
2. **Vào trang login → "Đăng nhập bằng khuôn mặt"**
3. **Nếu báo lỗi credentials:** check lại file JSON path

## 🔧 Troubleshooting

### **Lỗi "Import cannot be resolved":**
```
Solution: Thêm đầy đủ JAR files vào Libraries
```

### **Lỗi "Credentials not found":**
```
Solution: 
- Check file dental-clinic-face-service.json ở đúng vị trí
- Verify file JSON có đúng format không
```

### **Lỗi "API not enabled":**
```
Solution:
- Vào Google Cloud Console
- Enable lại Cloud Vision API
- Đợi 5-10 phút
```

### **Lỗi "Quota exceeded":**
```
Solution:
- Google Vision API có 1000 requests/month miễn phí
- Check usage tại Cloud Console
```

## 💰 Chi phí

- **Miễn phí:** 1000 requests đầu tiên mỗi tháng
- **Sau đó:** $1.50 per 1000 requests
- **Dự kiến cho dental clinic:** ~100-200 requests/tháng = FREE

## 🎯 Kết quả mong đợi

Sau khi setup xong:
- ✅ Import Google Vision classes không còn lỗi
- ✅ Face detection hoạt động mượt mà
- ✅ Login bằng Face ID thành công
- ✅ UX countdown, flash effect đầy đủ

**Chúc bạn setup thành công! 🚀** 