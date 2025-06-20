# 🔐 Hướng Dẫn Cấu Hình Google OAuth

## 📋 Các Bước Cấu Hình

### 1. Tạo Google OAuth Credentials
1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo hoặc chọn project
3. Kích hoạt Google Calendar API
4. Tạo OAuth 2.0 Client ID

### 2. Cấu Hình Local
1. Copy file template:
   ```bash
   cd RoleStaff/src/main/java/com/mycompany/role_staff/java/
   cp calandar_loginGG.json.template calandar_loginGG.json
   ```

2. Chỉnh sửa file `calandar_loginGG.json`:
   ```json
   {
     "web": {
       "client_id": "YOUR_REAL_CLIENT_ID_HERE",
       "project_id": "YOUR_PROJECT_ID", 
       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
       "token_uri": "https://oauth2.googleapis.com/token",
       "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
       "client_secret": "YOUR_REAL_CLIENT_SECRET_HERE",
       "redirect_uris": [
         "http://localhost:8080/LoginGG/LoginGoogleHandler",
         "http://localhost:8080/LoginGG/login"
       ]
     }
   }
   ```

### 3. ⚠️ Bảo Mật
- **KHÔNG BAO GIỜ** commit file `calandar_loginGG.json` thật
- File này đã được thêm vào `.gitignore`
- Chỉ chia sẻ thông tin OAuth qua kênh bảo mật

### 4. Kiểm Tra
- File `calandar_loginGG.json` không xuất hiện trong `git status`
- Chức năng Google Login hoạt động bình thường

## 🔍 Khắc Phục Sự Cố
- Kiểm tra redirect URIs trong Google Console
- Xác minh project ID và domain
- Đảm bảo APIs được kích hoạt

---
*Lưu ý: File này được tạo tự động để bảo vệ thông tin bí mật khỏi GitHub.* 