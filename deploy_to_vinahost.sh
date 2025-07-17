#!/bin/bash

echo "🚀 BẮT ĐẦU DEPLOY LÊN VINAHOST"
echo "=================================="

# Kiểm tra Java
echo "📋 Kiểm tra Java..."
java -version
if [ $? -ne 0 ]; then
    echo "❌ Java chưa được cài đặt!"
    exit 1
fi

# Kiểm tra Ant
echo "📋 Kiểm tra Apache Ant..."
ant -version
if [ $? -ne 0 ]; then
    echo "❌ Apache Ant chưa được cài đặt!"
    exit 1
fi

# Clean và build project
echo "🔨 Đang build project..."
ant clean
ant dist

# Kiểm tra file WAR đã tạo
if [ ! -f "dist/TestFull.war" ]; then
    echo "❌ Không tìm thấy file WAR!"
    exit 1
fi

echo "✅ Build thành công!"
echo "📁 File WAR: dist/TestFull.war"

# Tạo thư mục deploy
echo "📁 Tạo thư mục deploy..."
mkdir -p deploy
cp dist/TestFull.war deploy/
cp -r web/uploads deploy/
cp -r web/img deploy/

echo "✅ Chuẩn bị deploy hoàn tất!"
echo "📂 Thư mục deploy: ./deploy/"
echo ""
echo "📝 HƯỚNG DẪN TIẾP THEO:"
echo "1. Upload thư mục 'deploy' lên VinaHost qua FTP"
echo "2. Đổi tên TestFull.war thành ROOT.war"
echo "3. Liên hệ Support để cấu hình Tomcat"
echo ""
echo "🔗 FTP Info (sẽ được cung cấp bởi VinaHost):"
echo "   Host: ftp.yourdomain.com"
echo "   Username: your_username"
echo "   Password: your_password"
echo "   Port: 21" 