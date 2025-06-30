FROM tomcat:10.1-jdk11-openjdk

# Set maintainer
LABEL maintainer="Dental Clinic Team"
LABEL version="1.0"
LABEL description="Dental Clinic Management System - 70% Ready"

# Set working directory
WORKDIR /usr/local/tomcat

# Remove default webapps để clean install
RUN rm -rf webapps/*

# Create necessary directories
RUN mkdir -p webapps/RoleStaff/WEB-INF/classes
RUN mkdir -p webapps/RoleStaff/WEB-INF/lib

# Copy web application files
COPY web/ webapps/RoleStaff/

# Copy compiled Java classes (nếu có build directory)
COPY src/java/ webapps/RoleStaff/WEB-INF/classes/

# Copy JAR dependencies
COPY web/WEB-INF/lib/*.jar webapps/RoleStaff/WEB-INF/lib/

# Copy Cloudflare optimized Tomcat config
COPY cloudflare-tomcat-config.xml conf/server.xml

# Copy database initialization script
COPY src/dental_clinic.sql /docker-entrypoint-initdb.d/

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set proper permissions
RUN chmod -R 755 webapps/
RUN chmod +x bin/*.sh

# Environment variables for Azure deployment
ENV AZURE_SQL_SERVER=""
ENV AZURE_SQL_DATABASE="BenhVien"
ENV AZURE_SQL_USER=""
ENV AZURE_SQL_PASSWORD=""
ENV CLOUDFLARE_API_TOKEN=""
ENV DB_HOST="localhost"
ENV DB_PORT="3306"
ENV DB_NAME="BenhVien"
ENV DB_USER="sa"
ENV DB_PASSWORD="Phuoc12345@"

# JVM optimization for Azure F1 tier (limited memory)
ENV CATALINA_OPTS="-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# Health check để Azure biết app đã ready
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/RoleStaff/ || exit 1

# Expose port
EXPOSE 8080

# Create startup script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Start application
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"] 