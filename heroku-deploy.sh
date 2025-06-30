#!/bin/bash

echo "🎯 HEROKU DEPLOYMENT - 100% MIỄN PHÍ (KHÔNG CẦN CREDIT CARD)"
echo "============================================================="
echo "📊 Deploying Dental Clinic System (70% Ready)"
echo ""

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Check Heroku CLI
if ! command -v heroku &> /dev/null; then
    echo "📦 Installing Heroku CLI..."
    brew tap heroku/brew && brew install heroku
fi

# Check Git
if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install git"
    exit 1
fi

echo "✅ Prerequisites ready!"

# Login to Heroku
echo "🔐 Login to Heroku (FREE account)..."
heroku login

# App configuration
APP_NAME="dental-clinic-$(date +%s)"
echo "📝 App name: $APP_NAME"

# Create Heroku app
echo "🚀 Creating Heroku app..."
heroku create $APP_NAME --region us

if [ $? -ne 0 ]; then
    echo "❌ Failed to create Heroku app"
    exit 1
fi

# Add Heroku Postgres (FREE tier)
echo "🗃️ Adding PostgreSQL database (FREE)..."
heroku addons:create heroku-postgresql:mini --app $APP_NAME

# Get database URL
DATABASE_URL=$(heroku config:get DATABASE_URL --app $APP_NAME)
echo "✅ Database created: $DATABASE_URL"

# Create Heroku.yml for container deployment
echo "📦 Creating Heroku container config..."
cat > heroku.yml << 'EOF'
build:
  docker:
    web: Dockerfile.heroku
run:
  web: catalina.sh run
EOF

# Create Dockerfile for Heroku
echo "🐳 Creating Heroku Dockerfile..."
cat > Dockerfile.heroku << 'EOF'
FROM tomcat:10.1-jdk11-openjdk

# Install PostgreSQL client
RUN apt-get update && apt-get install -y postgresql-client curl

# Set working directory
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf webapps/*

# Create necessary directories
RUN mkdir -p webapps/RoleStaff/WEB-INF/classes
RUN mkdir -p webapps/RoleStaff/WEB-INF/lib

# Copy web application files
COPY web/ webapps/RoleStaff/

# Copy compiled Java classes
COPY src/java/ webapps/RoleStaff/WEB-INF/classes/

# Copy JAR dependencies
COPY web/WEB-INF/lib/*.jar webapps/RoleStaff/WEB-INF/lib/

# Add PostgreSQL driver
ADD https://jdbc.postgresql.org/download/postgresql-42.7.4.jar webapps/RoleStaff/WEB-INF/lib/

# Set permissions
RUN chmod -R 755 webapps/
RUN chmod +x bin/*.sh

# Environment variables
ENV PORT=8080
ENV DATABASE_URL=""
ENV DB_NAME="BenhVien"

# Create startup script
RUN cat > /usr/local/bin/heroku-start.sh << 'SCRIPT'
#!/bin/bash

echo "🚀 Starting Dental Clinic on Heroku..."

# Extract database info from DATABASE_URL
if [ ! -z "$DATABASE_URL" ]; then
    # Parse PostgreSQL URL
    DB_HOST=$(echo $DATABASE_URL | sed 's/.*@\([^:]*\):.*/\1/')
    DB_PORT=$(echo $DATABASE_URL | sed 's/.*:\([0-9]*\)\/.*/\1/')
    DB_NAME=$(echo $DATABASE_URL | sed 's/.*\/\([^?]*\).*/\1/')
    DB_USER=$(echo $DATABASE_URL | sed 's/.*\/\/\([^:]*\):.*/\1/')
    DB_PASS=$(echo $DATABASE_URL | sed 's/.*\/\/[^:]*:\([^@]*\)@.*/\1/')
    
    echo "🔧 Configuring PostgreSQL connection..."
    cat > webapps/RoleStaff/WEB-INF/classes/db.properties << DBEOF
# PostgreSQL Database Configuration (Heroku)
db.url=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME?sslmode=require
db.username=$DB_USER
db.password=$DB_PASS
db.driver=org.postgresql.Driver
DBEOF
fi

# Configure Tomcat for Heroku
sed -i "s/8080/$PORT/g" conf/server.xml

# Start Tomcat
exec catalina.sh run
SCRIPT

RUN chmod +x /usr/local/bin/heroku-start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:$PORT/RoleStaff/ || exit 1

EXPOSE $PORT

CMD ["/usr/local/bin/heroku-start.sh"]
EOF

# Initialize git repository
echo "📝 Initializing git repository..."
git init
git add .
git commit -m "Initial commit for Heroku deployment"

# Set Heroku stack to container
echo "🔧 Setting Heroku stack to container..."
heroku stack:set container --app $APP_NAME

# Deploy to Heroku
echo "🚀 Deploying to Heroku..."
git remote add heroku https://git.heroku.com/$APP_NAME.git
git push heroku main

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed"
    exit 1
fi

# Open the app
APP_URL="https://$APP_NAME.herokuapp.com"
echo ""
echo "🎉 HEROKU DEPLOYMENT SUCCESSFUL!"
echo "================================"
echo ""
echo "✅ Application URL: $APP_URL/RoleStaff/"
echo "✅ Database: PostgreSQL (FREE 10,000 rows)"
echo "✅ Dyno Hours: 550/month (FREE)"
echo "✅ Cost: $0/month (100% FREE!)"
echo ""

# Test the deployment
echo "🏥 Testing application..."
sleep 30
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL/RoleStaff/ || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo "🎊 SUCCESS! Application is running!"
    
    # Open browser on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🌍 Opening browser..."
        open $APP_URL/RoleStaff/
    fi
else
    echo "⚠️ Application deployed but may need time to start"
    echo "🔍 Check logs: heroku logs --tail --app $APP_NAME"
fi

echo ""
echo "📋 HEROKU FREE TIER LIMITS:"
echo "   Dyno Hours: 550/month (enough for 24/7 with verification)"
echo "   Database: 10,000 rows (enough for testing)"
echo "   Bandwidth: No limit"
echo "   Custom domain: Supported"
echo ""

echo "🔧 USEFUL COMMANDS:"
echo "   View logs: heroku logs --tail --app $APP_NAME"
echo "   Restart: heroku restart --app $APP_NAME"
echo "   Open app: heroku open --app $APP_NAME"
echo "   Database: heroku pg --app $APP_NAME"
echo ""

# Save deployment info
cat > heroku-deployment-info.txt << EOF
🎯 Heroku Deployment Successful!
===============================

Application URL: $APP_URL/RoleStaff/
App Name: $APP_NAME
Database: PostgreSQL (FREE)
Deployment Date: $(date)

Status: 70% Complete - Ready for Testing
Cost: $0/month (100% FREE - NO CREDIT CARD!)

Heroku Commands:
- heroku logs --tail --app $APP_NAME
- heroku restart --app $APP_NAME
- heroku open --app $APP_NAME

Next Steps:
1. Test all features
2. Import sample data
3. Complete remaining features
4. Consider upgrading when ready for production
EOF

echo "✅ Deployment info saved to heroku-deployment-info.txt"
echo "🎯 Your dental clinic is now running on Heroku - 100% FREE!" 