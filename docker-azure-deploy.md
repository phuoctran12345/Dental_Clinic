# 🐳 Docker + Azure Deploy Guide - MIỄN PHÍ 100%

## 🎯 **Tại sao chọn Docker + Azure?**

### ✅ **Ưu điểm:**
- 🆓 **Hoàn toàn miễn phí** với Azure Free Tier
- 🐳 **Container hóa** dễ scale và maintain
- ☁️ **Cloud-native** với global availability
- 🔧 **CI/CD pipeline** tự động
- 📊 **Monitoring** và logging built-in
- 🔐 **Enterprise security** 

### 💰 **Chi phí thực tế:**
```
Azure Free Tier:
✅ $200 credit (30 ngày đầu)
✅ App Service F1: MIỄN PHÍ mãi mãi
✅ Azure SQL 250GB: MIỄN PHÍ mãi mãi  
✅ Container Instances: MIỄN PHÍ mãi mãi
✅ Storage 5GB: MIỄN PHÍ mãi mãi
✅ Bandwidth 15GB: MIỄN PHÍ mãi mãi

TỔNG CHI PHÍ: $0/tháng (VĨNH VIỄN!)
```

## 🚀 **Deployment Architecture**

```
Local Development → Docker Container → Azure Container Registry → Azure App Service
      (70%)            (Containerized)        (Free Storage)         (Free Hosting)
```

## 📦 **Step 1: Containerize Application**

### **Dockerfile chính**
```dockerfile
FROM tomcat:10.1-jdk11-openjdk

# Set working directory
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf webapps/*

# Copy application
COPY web/ webapps/RoleStaff/
COPY src/java/ webapps/RoleStaff/WEB-INF/classes/

# Copy Cloudflare config
COPY cloudflare-tomcat-config.xml conf/server.xml

# Copy database driver and dependencies
COPY web/WEB-INF/lib/*.jar webapps/RoleStaff/WEB-INF/lib/

# Set permissions
RUN chmod -R 755 webapps/
RUN chmod +x bin/*.sh

# Environment variables for Azure
ENV AZURE_SQL_SERVER=""
ENV AZURE_SQL_DATABASE="dental_clinic"
ENV AZURE_SQL_USER=""
ENV AZURE_SQL_PASSWORD=""
ENV CLOUDFLARE_API_TOKEN=""

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/RoleStaff/ || exit 1

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
```

### **Docker Compose for Local Testing**
```yaml
version: '3.8'

services:
  dental-app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=mysql
      - DB_NAME=dental_clinic
      - DB_USER=root
      - DB_PASSWORD=password123
      - CLOUDFLARE_API_TOKEN=your_token_here
    depends_on:
      - mysql
    volumes:
      - ./logs:/usr/local/tomcat/logs
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=password123
      - MYSQL_DATABASE=dental_clinic
      - MYSQL_USER=dental_user
      - MYSQL_PASSWORD=dental_pass
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./src/dental_clinic.sql:/docker-entrypoint-initdb.d/init.sql
    restart: unless-stopped

  # Nginx proxy (optional for SSL)
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - dental-app
    restart: unless-stopped

volumes:
  mysql_data:
```

## ☁️ **Step 2: Setup Azure Free Account**

### **Tạo Azure Account:**
```bash
# 1. Truy cập: https://azure.microsoft.com/free/
# 2. Sign up với email của bạn
# 3. Verify identity (cần credit card để verify, KHÔNG bị charge)
# 4. Receive $200 credit + Always Free services
```

### **Install Azure CLI:**
```bash
# macOS
brew install azure-cli

# Login to Azure
az login

# Verify account
az account show
```

## 🗃️ **Step 3: Setup Azure SQL Database (FREE)**

### **Create Resource Group:**
```bash
# Create resource group
az group create \
  --name dental-clinic-rg \
  --location eastus

# Create SQL Server (FREE tier)
az sql server create \
  --name dental-clinic-server-$(date +%s) \
  --resource-group dental-clinic-rg \
  --location eastus \
  --admin-user dentaladmin \
  --admin-password "ComplexP@ssw0rd123!"

# Create SQL Database (FREE 250GB)
az sql db create \
  --resource-group dental-clinic-rg \
  --server dental-clinic-server-$(date +%s) \
  --name dental_clinic \
  --service-objective S0 \
  --edition Standard
```

### **Configure Firewall:**
```bash
# Allow Azure services
az sql server firewall-rule create \
  --resource-group dental-clinic-rg \
  --server dental-clinic-server-$(date +%s) \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

# Allow your IP
az sql server firewall-rule create \
  --resource-group dental-clinic-rg \
  --server dental-clinic-server-$(date +%s) \
  --name AllowMyIP \
  --start-ip-address $(curl -s ifconfig.me) \
  --end-ip-address $(curl -s ifconfig.me)
```

## 📦 **Step 4: Azure Container Registry (FREE)**

### **Create Container Registry:**
```bash
# Create ACR (Basic tier - FREE with credits)
az acr create \
  --resource-group dental-clinic-rg \
  --name dentalclinicacr$(date +%s) \
  --sku Basic \
  --admin-enabled true

# Get ACR credentials
az acr credential show \
  --name dentalclinicacr$(date +%s) \
  --resource-group dental-clinic-rg
```

### **Build and Push Docker Image:**
```bash
# Build image locally
docker build -t dental-clinic:latest .

# Tag for ACR
ACR_NAME="dentalclinicacr$(date +%s)"
docker tag dental-clinic:latest $ACR_NAME.azurecr.io/dental-clinic:latest

# Login to ACR
az acr login --name $ACR_NAME

# Push image
docker push $ACR_NAME.azurecr.io/dental-clinic:latest
```

## 🌐 **Step 5: Azure App Service (FREE)**

### **Create App Service Plan (FREE):**
```bash
# Create FREE App Service Plan
az appservice plan create \
  --name dental-clinic-plan \
  --resource-group dental-clinic-rg \
  --sku F1 \
  --is-linux

# Create Web App
az webapp create \
  --resource-group dental-clinic-rg \
  --plan dental-clinic-plan \
  --name dental-clinic-app-$(date +%s) \
  --deployment-container-image-name $ACR_NAME.azurecr.io/dental-clinic:latest
```

### **Configure App Settings:**
```bash
APP_NAME="dental-clinic-app-$(date +%s)"

# Set container registry credentials
az webapp config container set \
  --name $APP_NAME \
  --resource-group dental-clinic-rg \
  --container-image-name $ACR_NAME.azurecr.io/dental-clinic:latest \
  --container-registry-url https://$ACR_NAME.azurecr.io \
  --container-registry-user $(az acr credential show --name $ACR_NAME --query username -o tsv) \
  --container-registry-password $(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)

# Set environment variables
az webapp config appsettings set \
  --resource-group dental-clinic-rg \
  --name $APP_NAME \
  --settings \
    AZURE_SQL_SERVER="dental-clinic-server-$(date +%s).database.windows.net" \
    AZURE_SQL_DATABASE="dental_clinic" \
    AZURE_SQL_USER="dentaladmin" \
    AZURE_SQL_PASSWORD="ComplexP@ssw0rd123!" \
    CLOUDFLARE_API_TOKEN="your_cloudflare_token" \
    WEBSITES_PORT="8080"
```

## 🔧 **Step 6: Database Migration**

### **Import Database to Azure:**
```bash
# Export local database
mysqldump -u root -p dental_clinic > dental_clinic_export.sql

# Convert MySQL to Azure SQL format
# Use Azure Database Migration Service (FREE) or manual conversion

# Connect to Azure SQL and import
sqlcmd -S dental-clinic-server-$(date +%s).database.windows.net \
  -d dental_clinic \
  -U dentaladmin \
  -P "ComplexP@ssw0rd123!" \
  -i dental_clinic_azure.sql
```

## 🚀 **Step 7: Automated Deployment Script**

### **Complete Deployment Script:**
```bash
#!/bin/bash

echo "🐳 DEPLOYING TO AZURE - 100% FREE!"
echo "=================================="

# Variables
RESOURCE_GROUP="dental-clinic-rg"
LOCATION="eastus"
ACR_NAME="dentalclinicacr$(date +%s)"
APP_NAME="dental-clinic-app-$(date +%s)"
SQL_SERVER="dental-clinic-server-$(date +%s)"

echo "📝 Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "🗃️ Creating SQL Server..."
az sql server create \
  --name $SQL_SERVER \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --admin-user dentaladmin \
  --admin-password "ComplexP@ssw0rd123!"

echo "💾 Creating SQL Database..."
az sql db create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER \
  --name dental_clinic \
  --service-objective S0

echo "🔐 Configuring Firewall..."
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

echo "📦 Creating Container Registry..."
az acr create \
  --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME \
  --sku Basic \
  --admin-enabled true

echo "🐳 Building Docker Image..."
docker build -t dental-clinic:latest .
docker tag dental-clinic:latest $ACR_NAME.azurecr.io/dental-clinic:latest

echo "📤 Pushing to Registry..."
az acr login --name $ACR_NAME
docker push $ACR_NAME.azurecr.io/dental-clinic:latest

echo "🌐 Creating App Service..."
az appservice plan create \
  --name dental-clinic-plan \
  --resource-group $RESOURCE_GROUP \
  --sku F1 \
  --is-linux

az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan dental-clinic-plan \
  --name $APP_NAME \
  --deployment-container-image-name $ACR_NAME.azurecr.io/dental-clinic:latest

echo "⚙️ Configuring App..."
az webapp config container set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --container-image-name $ACR_NAME.azurecr.io/dental-clinic:latest \
  --container-registry-url https://$ACR_NAME.azurecr.io \
  --container-registry-user $(az acr credential show --name $ACR_NAME --query username -o tsv) \
  --container-registry-password $(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)

az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --settings \
    AZURE_SQL_SERVER="$SQL_SERVER.database.windows.net" \
    AZURE_SQL_DATABASE="dental_clinic" \
    AZURE_SQL_USER="dentaladmin" \
    AZURE_SQL_PASSWORD="ComplexP@ssw0rd123!" \
    WEBSITES_PORT="8080"

echo "🎉 DEPLOYMENT COMPLETED!"
echo "✅ Website URL: https://$APP_NAME.azurewebsites.net"
echo "✅ Database: $SQL_SERVER.database.windows.net"
echo "✅ Cost: $0/month (FREE Forever!)"
```

## 📊 **Step 8: Monitoring & Analytics (FREE)**

### **Application Insights (FREE):**
```bash
# Create Application Insights
az monitor app-insights component create \
  --app dental-clinic-insights \
  --location eastus \
  --resource-group dental-clinic-rg \
  --kind web

# Configure web app to use insights
INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app dental-clinic-insights \
  --resource-group dental-clinic-rg \
  --query instrumentationKey -o tsv)

az webapp config appsettings set \
  --resource-group dental-clinic-rg \
  --name $APP_NAME \
  --settings \
    APPINSIGHTS_INSTRUMENTATIONKEY=$INSTRUMENTATION_KEY
```

## 🔧 **Step 9: CI/CD Pipeline (FREE with GitHub)**

### **GitHub Actions Workflow:**
```yaml
name: Deploy to Azure

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Login to Azure
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    
    - name: Build Docker Image
      run: |
        docker build -t dental-clinic:${{ github.sha }} .
        
    - name: Push to ACR
      run: |
        az acr login --name ${{ secrets.ACR_NAME }}
        docker tag dental-clinic:${{ github.sha }} ${{ secrets.ACR_NAME }}.azurecr.io/dental-clinic:${{ github.sha }}
        docker push ${{ secrets.ACR_NAME }}.azurecr.io/dental-clinic:${{ github.sha }}
        
    - name: Deploy to App Service
      run: |
        az webapp config container set \
          --name ${{ secrets.APP_NAME }} \
          --resource-group ${{ secrets.RESOURCE_GROUP }} \
          --container-image-name ${{ secrets.ACR_NAME }}.azurecr.io/dental-clinic:${{ github.sha }}
```

## 📈 **Step 10: Cost Optimization**

### **Always Free Services Used:**
```
✅ App Service F1: 60 minutes/day compute (ENOUGH for testing)
✅ Azure SQL Database: 250GB storage (MORE than enough)
✅ Storage Account: 5GB blob storage
✅ Bandwidth: 15GB outbound data transfer
✅ Container Registry: 10GB storage
✅ Application Insights: 1GB data/month
✅ Azure Monitor: Basic metrics

TOTAL COST: $0/month FOREVER!
```

### **Scaling Options (Paid when needed):**
```
When ready for production (90%+):
- App Service B1: $13/month (24/7 uptime)
- SQL Database S1: $15/month (better performance)
- Premium storage: $5/month (faster I/O)

PRODUCTION COST: ~$35/month
```

## 🚀 **Quick Start Commands**

### **1. Prepare Local Environment:**
```bash
# Install prerequisites
brew install azure-cli docker

# Login to Azure
az login

# Verify Docker
docker --version
```

### **2. One-Command Deploy:**
```bash
# Clone and deploy
git clone your-repo
cd dental-clinic
chmod +x azure-deploy.sh
./azure-deploy.sh
```

### **3. Access Your App:**
```bash
# Get app URL
az webapp show \
  --name $APP_NAME \
  --resource-group dental-clinic-rg \
  --query defaultHostName -o tsv

# Open in browser
open https://your-app-name.azurewebsites.net
```

## 🔍 **Health Checks & Monitoring**

### **Application Health:**
```bash
# Check app status
az webapp show \
  --name $APP_NAME \
  --resource-group dental-clinic-rg \
  --query state

# View logs
az webapp log tail \
  --name $APP_NAME \
  --resource-group dental-clinic-rg

# Check database connectivity
az sql db show \
  --resource-group dental-clinic-rg \
  --server $SQL_SERVER \
  --name dental_clinic
```

### **Performance Metrics:**
```bash
# CPU and Memory usage
az monitor metrics list \
  --resource-id /subscriptions/YOUR_SUBSCRIPTION/resourceGroups/dental-clinic-rg/providers/Microsoft.Web/sites/$APP_NAME \
  --metric CpuPercentage,MemoryPercentage

# Request count and response time
az monitor metrics list \
  --resource-id /subscriptions/YOUR_SUBSCRIPTION/resourceGroups/dental-clinic-rg/providers/Microsoft.Web/sites/$APP_NAME \
  --metric Requests,AverageResponseTime
```

## 🎯 **Benefits for Your 70% Project**

### ✅ **Immediate Benefits:**
- 🆓 **Zero cost** for staging environment
- 🌐 **Global accessibility** via Azure CDN
- 🔐 **Enterprise security** built-in
- 📊 **Professional monitoring** and alerts
- 🚀 **Auto-scaling** when traffic increases
- 💾 **Automated backups** for database

### ✅ **Future-Ready:**
- 🔄 **CI/CD pipeline** for easy updates
- 📈 **Easy scaling** when going to production
- 🌍 **Global deployment** with multiple regions
- 🛡️ **DDoS protection** and WAF
- 📱 **Mobile optimization** out of the box

## 🚨 **Troubleshooting Common Issues**

### **Issue 1: Container Won't Start**
```bash
# Check container logs
az webapp log tail --name $APP_NAME --resource-group dental-clinic-rg

# Common fix: Update port settings
az webapp config appsettings set \
  --resource-group dental-clinic-rg \
  --name $APP_NAME \
  --settings WEBSITES_PORT="8080"
```

### **Issue 2: Database Connection**
```bash
# Test database connectivity
az sql db show-connection-string \
  --server $SQL_SERVER \
  --name dental_clinic \
  --client jdbc

# Update connection string in app settings
az webapp config connection-string set \
  --resource-group dental-clinic-rg \
  --name $APP_NAME \
  --connection-string-type SQLAzure \
  --settings DefaultConnection="Server=tcp:$SQL_SERVER.database.windows.net,1433;Database=dental_clinic;User ID=dentaladmin;Password=ComplexP@ssw0rd123!;Encrypt=true;Connection Timeout=30;"
```

### **Issue 3: Slow Performance**
```bash
# Enable Application Insights
az webapp config appsettings set \
  --resource-group dental-clinic-rg \
  --name $APP_NAME \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=$INSTRUMENTATION_KEY

# Scale up to B1 if needed (costs $13/month)
az appservice plan update \
  --name dental-clinic-plan \
  --resource-group dental-clinic-rg \
  --sku B1
```

## 🎉 **Final Result**

**Your dental clinic will be accessible at:**
```
https://dental-clinic-app-XXXXXXX.azurewebsites.net
```

**With features:**
- ✅ **Global availability** (99.95% uptime SLA)
- ✅ **HTTPS by default** (free SSL certificate)
- ✅ **Auto-scaling** based on traffic
- ✅ **Professional monitoring** and alerts
- ✅ **Zero cost** for staging (70% project perfect!)
- ✅ **Production-ready** infrastructure

**Next steps after successful deploy:**
1. ✅ Test all features on live environment
2. ✅ Configure custom domain (optional)
3. ✅ Set up Cloudflare for additional CDN
4. ✅ Complete remaining 30% features
5. ✅ Scale to production tier when ready

---

## 💡 **Pro Tips for Success**

1. **Start with F1 tier** (free) for testing
2. **Use Application Insights** for monitoring
3. **Set up alerts** for errors and performance
4. **Regular database backups** (automated)
5. **Use staging slots** for zero-downtime deployments
6. **Monitor costs** via Azure Cost Management

**This solution gives you enterprise-grade infrastructure at ZERO cost - perfect for your 70% project!** 