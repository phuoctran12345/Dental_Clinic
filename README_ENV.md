# 🔐 Environment Variables Setup

## 📋 Giới thiệu
File này hướng dẫn cách thiết lập các biến môi trường (environment variables) cho dự án Dental Clinic Management System.

## 🚀 Cách setup

### 1. Copy file template
```bash
cp .env.example .env
```

### 2. Cập nhật thông tin thực tế trong file `.env`

#### 🔹 Twilio API (Gọi điện tự động)
- Đăng ký tài khoản tại: https://www.twilio.com/
- Lấy Account SID và Auth Token từ Console Dashboard
- Mua số điện thoại Twilio

#### 🔹 Google OAuth (Đăng nhập Google + Calendar)
- Tạo project tại: https://console.developers.google.com/
- Enable Google+ API và Calendar API
- Tạo OAuth 2.0 Client IDs
- Thêm redirect URI: `http://localhost:8080/google-callback`

#### 🔹 PayOS (Thanh toán)
- Đăng ký merchant tại: https://payos.vn/
- Lấy Client ID, API Key, Checksum Key từ dashboard

#### 🔹 Gemini AI (Chat Assistant)
- Tạo API key tại: https://ai.google.dev/
- Lấy API key từ Google AI Studio

#### 🔹 Email SMTP (Gửi email thông báo)
- Sử dụng Gmail: Bật 2FA và tạo App Password
- Hoặc dùng SMTP server khác

### 3. Cập nhật code để đọc từ environment

```java
// Thay vì hardcode:
public static final String ACCOUNT_SID = "ACxxx...";

// Sử dụng:
public static final String ACCOUNT_SID = System.getenv("TWILIO_ACCOUNT_SID");
```

## ⚠️ Lưu ý bảo mật

- ✅ **KHÔNG BAO GIỜ** commit file `.env` lên Git
- ✅ File `.env` chỉ tồn tại trên máy local
- ✅ Chia sẻ file `.env.example` thay vì `.env`
- ✅ Rotate (thay đổi) API keys định kỳ
- ✅ Sử dụng different keys cho development/production

## 📝 Production Deployment

Khi deploy lên server:
```bash
# Thiết lập environment variables trực tiếp
export TWILIO_ACCOUNT_SID="your_sid"
export TWILIO_AUTH_TOKEN="your_token"

# Hoặc sử dụng platform-specific methods:
# - Heroku: heroku config:set
# - Azure: Application Settings
# - AWS: Systems Manager Parameter Store
```

## 🆘 Troubleshooting

### Lỗi "Environment variable not found"
- Kiểm tra file `.env` có tồn tại không
- Đảm bảo tên biến đúng (case-sensitive)
- Restart application sau khi thay đổi .env

### Lỗi API authentication
- Kiểm tra API keys có đúng không
- Verify account status (active/suspended)
- Check rate limits và quotas

## 📞 Liên hệ
Nếu cần hỗ trợ setup, liên hệ team lead hoặc tạo issue trên repository. 