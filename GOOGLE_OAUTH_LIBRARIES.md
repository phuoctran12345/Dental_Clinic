# Hướng dẫn cài đặt thư viện Google OAuth

## Thư viện cần thiết

Thêm các thư viện sau vào thư mục `library_Assignment`:

1. Google OAuth Client Library for Java:
```xml
<dependency>
    <groupId>com.google.oauth-client</groupId>
    <artifactId>google-oauth-client-java6</artifactId>
    <version>1.34.1</version>
</dependency>
```

2. Jetty Server và Util:
```xml
<dependency>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-server</artifactId>
    <version>9.4.44.v20210927</version>
</dependency>
<dependency>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-util</artifactId>
    <version>9.4.44.v20210927</version>
</dependency>
```

## Cách tải thư viện

1. Truy cập https://mvnrepository.com
2. Tìm kiếm tên thư viện
3. Chọn phiên bản phù hợp
4. Tải file JAR
5. Copy vào thư mục `library_Assignment`
6. Add JAR vào project trong NetBeans

## Kiểm tra cài đặt

Sau khi thêm thư viện, clean và build lại project để đảm bảo không có lỗi compile. 