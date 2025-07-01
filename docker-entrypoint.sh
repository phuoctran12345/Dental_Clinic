#!/bin/bash

echo "🐳 Starting Dental Clinic Application..."
echo "======================================="

# Wait for database to be ready
if [ ! -z "$DB_HOST" ]; then
    echo "⏳ Waiting for database at $DB_HOST:${DB_PORT:-3306}..."
    
    # Wait up to 60 seconds for database
    timeout=60
    while [ $timeout -gt 0 ]; do
        if nc -z "$DB_HOST" "${DB_PORT:-3306}" 2>/dev/null; then
            echo "✅ Database is ready!"
            break
        fi
        echo "⏳ Database not ready yet, waiting... ($timeout seconds left)"
        sleep 2
        timeout=$((timeout-2))
    done
    
    if [ $timeout -le 0 ]; then
        echo "❌ Database connection timeout!"
        exit 1
    fi
fi

# Set database connection properties if environment variables are provided
if [ ! -z "$AZURE_SQL_SERVER" ]; then
    echo "🔧 Configuring Azure SQL connection..."
    
    # Create database connection properties file
    cat > /usr/local/tomcat/webapps/RoleStaff/WEB-INF/classes/db.properties << EOF
# Azure SQL Database Configuration
db.url=jdbc:sqlserver://${AZURE_SQL_SERVER}:1433;database=${AZURE_SQL_DATABASE};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
db.username=${AZURE_SQL_USER}
db.password=${AZURE_SQL_PASSWORD}
db.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
EOF

elif [ ! -z "$DB_HOST" ]; then
    echo "🔧 Configuring MySQL connection..."
    
    # Create database connection properties file
    cat > /usr/local/tomcat/webapps/RoleStaff/WEB-INF/classes/db.properties << EOF
# MySQL Database Configuration
db.url=jdbc:mysql://${DB_HOST}:${DB_PORT:-3306}/${DB_NAME}?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.username=${DB_USER}
db.password=${DB_PASSWORD}
db.driver=com.mysql.cj.jdbc.Driver
EOF
fi

# Set Cloudflare configuration if token is provided
if [ ! -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "☁️ Configuring Cloudflare integration..."
    
    cat > /usr/local/tomcat/webapps/RoleStaff/WEB-INF/classes/cloudflare.properties << EOF
# Cloudflare Configuration
cloudflare.api.token=${CLOUDFLARE_API_TOKEN}
cloudflare.zone.id=${CLOUDFLARE_ZONE_ID:-}
cloudflare.enabled=true
EOF
fi

# Create application.properties with environment-specific settings
echo "⚙️ Creating application configuration..."
cat > /usr/local/tomcat/webapps/RoleStaff/WEB-INF/classes/application.properties << EOF
# Application Configuration
app.name=Dental Clinic Management System
app.version=1.0-${BUILD_NUMBER:-dev}
app.environment=${ENVIRONMENT:-development}

# Logging configuration
log.level=${LOG_LEVEL:-INFO}
log.file=/usr/local/tomcat/logs/dental-clinic.log

# Session configuration
session.timeout=30

# File upload configuration
upload.max.size=10MB
upload.temp.dir=/tmp

# Email configuration (if needed)
email.smtp.host=${SMTP_HOST:-}
email.smtp.port=${SMTP_PORT:-587}
email.smtp.username=${SMTP_USERNAME:-}
email.smtp.password=${SMTP_PASSWORD:-}

# PayOS configuration (for payment processing)
payos.client.id=${PAYOS_CLIENT_ID:-}
payos.api.key=${PAYOS_API_KEY:-}
payos.checksum.key=${PAYOS_CHECKSUM_KEY:-}
payos.sandbox=${PAYOS_SANDBOX:-true}
EOF

# Set JVM options based on environment
if [ "$ENVIRONMENT" = "production" ]; then
    export CATALINA_OPTS="$CATALINA_OPTS -server -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
    echo "🚀 Production mode: Optimized JVM settings applied"
else
    export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
    echo "🔧 Development mode: Standard JVM settings applied"
fi

# Create logs directory if it doesn't exist
mkdir -p /usr/local/tomcat/logs

# Set timezone
export TZ=${TZ:-Asia/Ho_Chi_Minh}
echo "🕐 Timezone set to: $TZ"

# Print startup information
echo ""
echo "📊 Application Information:"
echo "   Name: Dental Clinic Management System"
echo "   Version: 1.0 (70% Complete)"
echo "   Environment: ${ENVIRONMENT:-development}"
echo "   Database: ${DB_HOST:-Azure SQL}"
echo "   Cloudflare: ${CLOUDFLARE_API_TOKEN:+Enabled}"
echo ""
echo "🌐 Application will be available at:"
echo "   Local: http://localhost:8080/RoleStaff/"
echo "   Health Check: http://localhost:8080/RoleStaff/health"
echo ""
echo "🚀 Starting Tomcat server..."

# Execute the main command
exec "$@" 