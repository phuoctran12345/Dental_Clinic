# 🚀 Deployment Guide - Phòng khám nha khoa

## 📊 Deployment Readiness Checklist

### 🔍 **Đánh giá dự án hiện tại (70%)**

#### ✅ **Đã hoàn thành:**
- [x] Core functionality (login, booking, doctor management)
- [x] Database structure và basic CRUD
- [x] UI/UX improvements
- [x] Cloudflare integration
- [x] Basic security (authentication, session)

#### ⚠️ **Cần hoàn thiện trước Production:**
- [ ] Payment system testing (PayOS)
- [ ] Email notification system
- [ ] Data backup và recovery plan
- [ ] Error handling và logging
- [ ] Performance testing
- [ ] Security audit

#### 📋 **Recommendation:** Deploy to **Staging** environment first!

## 🛠️ Deployment Options

### 1. 🖥️ **Local Development (Current - 70% Ready)**

**✅ Phù hợp cho:**
- Development và testing
- Demo cho client
- Internal team review

```bash
# Current setup
./apache-tomcat-10.1.36/bin/startup.sh
# Access: http://localhost:8080/RoleStaff
```

### 2. 🌐 **Staging Server (Recommended cho 70%)**

**✅ Phù hợp cho:**
- Testing với data thật
- User acceptance testing
- Performance testing
- Bug fixing

### 3. 🏥 **Production Server (Khi 95%+ ready)**

**✅ Phù hợp cho:**
- Live environment cho bệnh nhân
- Real transactions
- 24/7 availability

## 🔧 Deployment Methods

### **Method 1: Manual Deployment (Simple)**

#### Step 1: Chuẩn bị Server
```bash
# Ubuntu/CentOS server
sudo apt update && sudo apt upgrade -y

# Install Java 11+
sudo apt install openjdk-11-jdk -y

# Install MySQL
sudo apt install mysql-server -y

# Install Tomcat
wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.36/bin/apache-tomcat-10.1.36.tar.gz
tar -xzf apache-tomcat-10.1.36.tar.gz
```

#### Step 2: Deploy Application
```bash
# Copy project files
scp -r RoleStaff user@server:/opt/tomcat/webapps/

# Copy configuration
scp cloudflare-tomcat-config.xml user@server:/opt/tomcat/conf/server.xml

# Start Tomcat
/opt/tomcat/bin/startup.sh
```

#### Step 3: Setup Database
```bash
# Import database
mysql -u root -p < src/dental_clinic.sql

# Update connection strings
nano webapps/RoleStaff/WEB-INF/classes/utils/DBContext.java
```

### **Method 2: Docker Deployment (Recommended)**

#### Create Dockerfile
```dockerfile
FROM tomcat:10.1-jdk11

# Copy application
COPY web/ /usr/local/tomcat/webapps/RoleStaff/
COPY src/java/ /usr/local/tomcat/webapps/RoleStaff/WEB-INF/classes/

# Copy configuration
COPY cloudflare-tomcat-config.xml /usr/local/tomcat/conf/server.xml

# Expose port
EXPOSE 8080

CMD ["catalina.sh", "run"]
```

#### Docker Compose Setup
```yaml
version: '3.8'
services:
  dental-app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=mysql
      - DB_USER=dental_user
      - DB_PASS=secure_password
    depends_on:
      - mysql
      
  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_DATABASE=dental_clinic
      - MYSQL_USER=dental_user
      - MYSQL_PASSWORD=secure_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./src/dental_clinic.sql:/docker-entrypoint-initdb.d/init.sql

volumes:
  mysql_data:
```

#### Deploy với Docker
```bash
# Build và run
docker-compose up -d

# Check logs
docker-compose logs -f dental-app
```

### **Method 3: Cloud Platform Deployment**

#### 🌊 **Digital Ocean Droplet**
```bash
# Create droplet (Ubuntu 22.04)
# 2GB RAM, 1 vCPU, 50GB SSD = $12/month

# SSH vào server
ssh root@your-server-ip

# Run deployment script
curl -O https://raw.githubusercontent.com/your-repo/deploy-script.sh
chmod +x deploy-script.sh
./deploy-script.sh
```

#### ☁️ **AWS EC2**
```bash
# Launch EC2 instance (t3.small)
# 2GB RAM, 1 vCPU = ~$15/month

# Security Groups:
# - HTTP (80)
# - HTTPS (443) 
# - SSH (22)
# - Custom (8080) for Tomcat

# Deploy using AWS CLI hoặc CodeDeploy
```

#### 🚀 **Heroku (Easy but more expensive)**
```bash
# Create Procfile
echo "web: sh target/bin/webapp" > Procfile

# Deploy
heroku create dental-clinic-app
git push heroku main
```

## 🗃️ Database Deployment

### **Development → Production Migration**

#### Step 1: Export Current Data
```bash
# Export structure + data
mysqldump -u root -p --routines --triggers dental_clinic > dental_clinic_backup.sql

# Export structure only (for fresh production)
mysqldump -u root -p --no-data dental_clinic > dental_clinic_structure.sql
```

#### Step 2: Setup Production Database
```bash
# Create production database
mysql -u root -p -e "CREATE DATABASE dental_clinic_prod;"

# Import structure
mysql -u root -p dental_clinic_prod < dental_clinic_structure.sql

# Import sample data (optional)
mysql -u root -p dental_clinic_prod < sample_data.sql
```

#### Step 3: Update Configuration
```properties
# Production database config
db.url=jdbc:mysql://production-server:3306/dental_clinic_prod
db.username=dental_prod_user
db.password=super_secure_password

# Enable SSL for production
db.useSSL=true
db.requireSSL=true
```

## 🔒 Security for Production

### **SSL Certificate Setup**
```bash
# Let's Encrypt (Free SSL)
sudo apt install certbot -y
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### **Firewall Configuration**
```bash
# UFW Firewall
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8080  # Temporary, should proxy through Apache/Nginx
```

### **Environment Variables**
```bash
# Set production environment variables
export DB_PASSWORD="super_secure_password"
export CLOUDFLARE_API_TOKEN="your_cf_token"
export PAYOS_CLIENT_ID="your_payos_id"
export EMAIL_PASSWORD="app_specific_password"

# Add to /etc/environment for persistence
echo 'DB_PASSWORD="super_secure_password"' >> /etc/environment
```

## 📊 Monitoring Setup

### **Application Monitoring**
```bash
# Install monitoring tools
sudo apt install htop iotop nethogs -y

# Setup log rotation
sudo nano /etc/logrotate.d/tomcat
```

### **Database Monitoring**
```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

-- Monitor connections
SHOW PROCESSLIST;
SHOW STATUS LIKE 'Threads_connected';
```

### **Cloudflare Monitoring**
```bash
# Test Cloudflare integration
curl -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 🚨 Common Deployment Issues

### **1. Memory Issues (OutOfMemoryError)**
```bash
# Increase Tomcat memory
export CATALINA_OPTS="-Xms512m -Xmx2048m -XX:PermSize=256m"

# Add to setenv.sh
echo 'CATALINA_OPTS="-Xms512m -Xmx2048m"' > $TOMCAT_HOME/bin/setenv.sh
```

### **2. Database Connection Issues**
```java
// Check connection pool settings
maxTotal="20"
maxIdle="10" 
maxWaitMillis="10000"
testOnBorrow="true"
validationQuery="SELECT 1"
```

### **3. Port Conflicts**
```bash
# Check port usage
sudo netstat -tulpn | grep :8080

# Kill conflicting process
sudo kill -9 PID

# Change Tomcat port if needed
nano conf/server.xml
# Change: <Connector port="8080" to port="8090"
```

### **4. Permission Issues**
```bash
# Fix file permissions
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod +x /opt/tomcat/bin/*.sh
```

## 📋 Pre-Deployment Testing

### **Functional Testing**
```bash
# Test core features
✅ User registration/login
✅ Appointment booking
✅ Doctor schedule management
✅ Payment processing (sandbox)
✅ Email notifications
```

### **Performance Testing**
```bash
# Apache Bench testing
ab -n 1000 -c 10 http://localhost:8080/RoleStaff/

# Expected results for 70% project:
# - Response time < 2 seconds
# - No memory leaks
# - Database connections stable
```

### **Security Testing**
```bash
# Basic security checks
✅ SQL injection prevention
✅ XSS protection
✅ CSRF tokens
✅ Session management
✅ Input validation
```

## 🎯 Deployment Strategy cho 70% Project

### **Phase 1: Staging Deployment (Recommended NOW)**
```bash
# Deploy to staging server
# URL: https://staging.phongkhamnhakhoa.com
# Features: All current features (70%)
# Users: Internal team + selected beta users
# Purpose: Testing & bug fixing
```

### **Phase 2: Soft Launch (85% ready)**
```bash
# Deploy to production với limited features
# URL: https://phongkhamnhakhoa.com  
# Features: Core functionality only
# Users: Limited patient base
# Purpose: Real-world testing
```

### **Phase 3: Full Launch (95%+ ready)**
```bash
# Full production deployment
# All features enabled
# Marketing campaign
# 24/7 support ready
```

## 💰 Deployment Costs

### **Staging Environment**
```
Digital Ocean Droplet: $12/month
Domain name: $10/year
SSL Certificate: Free (Let's Encrypt)
Total: ~$15/month
```

### **Production Environment**
```
VPS Server (4GB RAM): $25/month
Database backup: $5/month
CDN (Cloudflare Pro): $20/month
Domain + SSL: $15/year
Monitoring: $10/month
Total: ~$65/month
```

### **Enterprise Setup**
```
Dedicated server: $100+/month
Load balancer: $30/month
Database cluster: $50/month
Professional support: $100/month
Total: $280+/month
```

## 🚀 Quick Deploy Script cho 70% Project

### **Staging Deployment Script**
```bash
#!/bin/bash
# Quick staging deployment

echo "🚀 Deploying Dental Clinic to Staging..."

# Build project
echo "📦 Building project..."
ant clean compile

# Stop existing Tomcat
echo "🛑 Stopping Tomcat..."
./apache-tomcat-10.1.36/bin/shutdown.sh

# Backup current deployment
echo "💾 Creating backup..."
cp -r apache-tomcat-10.1.36/webapps/RoleStaff apache-tomcat-10.1.36/webapps/RoleStaff.backup.$(date +%Y%m%d)

# Deploy new version
echo "📤 Deploying new version..."
cp -r web/* apache-tomcat-10.1.36/webapps/RoleStaff/
cp -r build/classes/* apache-tomcat-10.1.36/webapps/RoleStaff/WEB-INF/classes/

# Start Tomcat
echo "🚀 Starting Tomcat..."
./apache-tomcat-10.1.36/bin/startup.sh

# Wait for startup
sleep 10

# Health check
echo "🏥 Health checking..."
if curl -f http://localhost:8080/RoleStaff/ > /dev/null 2>&1; then
    echo "✅ Deployment successful!"
    echo "🌐 Application available at: http://localhost:8080/RoleStaff/"
else
    echo "❌ Deployment failed! Check logs:"
    tail -f apache-tomcat-10.1.36/logs/catalina.out
fi
```

## ⚠️ **Khuyến nghị cho dự án 70%**

### **✅ NÊN deploy Staging:**
- Test với người dùng thật
- Tìm bugs sớm
- Validate business logic
- Performance testing
- Collect feedback

### **❌ CHƯA nên deploy Production:**
- Payment chưa test kỹ
- Security audit chưa complete
- Backup strategy chưa có
- Monitoring chưa setup
- Support team chưa sẵn sàng

### **🎯 Focus tiếp theo:**
1. **Hoàn thiện Payment system** (PayOS testing)
2. **Security hardening** (penetration testing)
3. **Performance optimization** (caching, queries)
4. **Error handling** (user-friendly messages)
5. **Backup & recovery** procedures

---

## 🎉 **Kết luận**

**70% completion** là **perfect** cho **Staging deployment**! 

Bạn nên:
1. ✅ **Deploy Staging** ngay để test
2. ✅ **Collect feedback** từ users
3. ✅ **Fix bugs** và improve
4. ✅ **Hoàn thiện thêm 20%** 
5. ✅ **Deploy Production** khi 90%+

**Staging deployment sẽ giúp phát hiện issues sớm và cải thiện chất lượng sản phẩm!** 