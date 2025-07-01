# 🔒 SECURITY TOGGLE - HƯỚNG DẪN BẬT/TẮT BẢO MẬT

## 📋 TÌNH TRẠNG HIỆN TẠI
```
🔴 TẤT CẢ SECURITY FILTERS ĐÃ BỊ TẮT
✅ Phù hợp cho DEVELOPMENT/TESTING
❌ KHÔNG ĐƯỢC DÙNG CHO PRODUCTION
```

## 🔧 CÁCH BẬT/TẮT SECURITY

### 1. 🔴 TẮT SECURITY (HIỆN TẠI)

**File: `web/WEB-INF/web.xml`**
```xml
<!-- 🔴 DISABLED FOR DEVELOPMENT -->
<!--
<filter>
    <filter-name>SecurityFilter</filter-name>
    <filter-class>Filter.SecurityFilter</filter-class>
</filter>
-->
```

**File: `src/java/Filter/AuthenticationFilter.java`**
```java
// @WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})  // Tạm thời disable
```

**File: `src/java/Filter/RoleFilter.java`**
```java
// @WebFilter("/*")  // Tạm thời disable
```

### 2. 🟢 BẬT SECURITY (CHO PRODUCTION)

**Bước 1: Bật SecurityFilter trong web.xml**
```xml
<!-- 🟢 ENABLED FOR PRODUCTION -->
<filter>
    <filter-name>SecurityFilter</filter-name>
    <filter-class>Filter.SecurityFilter</filter-class>
    <init-param>
        <param-name>debug</param-name>
        <param-value>false</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>SecurityFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
</filter-mapping>
```

**Bước 2: Bật AuthenticationFilter**
```java
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {
```

**Bước 3: Bật RoleFilter**
```java
@WebFilter("/*")
public class RoleFilter implements Filter {
```

## 🚀 QUICK TOGGLE COMMANDS

### TẮT SECURITY (Development)
```bash
# 1. Comment @WebFilter trong AuthenticationFilter.java
sed -i '' 's/@WebFilter/\/\/ @WebFilter/' src/java/Filter/AuthenticationFilter.java

# 2. Comment @WebFilter trong RoleFilter.java  
sed -i '' 's/@WebFilter/\/\/ @WebFilter/' src/java/Filter/RoleFilter.java

# 3. Build lại
mvn clean compile
```

### BẬT SECURITY (Production)
```bash
# 1. Uncomment @WebFilter trong AuthenticationFilter.java
sed -i '' 's/\/\/ @WebFilter/@WebFilter/' src/java/Filter/AuthenticationFilter.java

# 2. Uncomment @WebFilter trong RoleFilter.java
sed -i '' 's/\/\/ @WebFilter/@WebFilter/' src/java/Filter/RoleFilter.java

# 3. Build lại
mvn clean compile
```

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Development**: Tắt security để test dễ dàng
2. **Production**: PHẢI bật security để bảo mật
3. **Testing**: Có thể tắt tạm thời để debug
4. **Deployment**: Kiểm tra lại security trước khi deploy

## 🔍 KIỂM TRA TRẠNG THÁI

**Cách kiểm tra security có bật không:**
```bash
# Kiểm tra AuthenticationFilter
grep -n "@WebFilter" src/java/Filter/AuthenticationFilter.java

# Kiểm tra RoleFilter  
grep -n "@WebFilter" src/java/Filter/RoleFilter.java

# Nếu có dòng bắt đầu bằng "//" = DISABLED
# Nếu không có "//" = ENABLED
```

## 📞 LIÊN HỆ
- **Developer**: TranHongPhuoc
- **Project**: RoleStaff - Dental Clinic Management
- **Last Updated**: 2025-06-15 