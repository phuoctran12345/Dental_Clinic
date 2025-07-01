#!/bin/bash

echo "🐳 TESTING DOCKER SETUP - Before Azure Deploy"
echo "=============================================="
echo "📊 Testing Dental Clinic System (70% Ready)"
echo ""

# Stop any running containers
echo "🛑 Stopping any running containers..."
docker-compose down 2>/dev/null

# Clean up old images
echo "🧹 Cleaning up old images..."
docker image prune -f

# Build the application
echo "🔨 Building Docker image..."
docker build -t dental-clinic:test .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed! Fix the issues before Azure deployment."
    exit 1
fi

echo "✅ Docker image built successfully!"

# Test with basic container (no database for quick test)
echo "🚀 Starting test container..."
docker run -d \
    --name dental-test \
    -p 8080:8080 \
    -e ENVIRONMENT=test \
    dental-clinic:test

# Wait for container to start
echo "⏳ Waiting for container startup..."
sleep 15

# Health check
echo "🏥 Testing application health..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/RoleStaff/ 2>/dev/null || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo "🎉 SUCCESS! Docker container is working!"
    echo "✅ HTTP Status: $HTTP_CODE"
    echo "✅ Application URL: http://localhost:8080/RoleStaff/"
    
    # Show container logs
    echo ""
    echo "📋 Container logs (last 10 lines):"
    docker logs dental-test --tail 10
    
    echo ""
    echo "🎯 Docker test PASSED! Ready for Azure deployment."
    echo "🚀 To deploy to Azure, run: ./azure-deploy.sh"
    
else
    echo "❌ FAILED! Docker container not responding"
    echo "❌ HTTP Status: $HTTP_CODE"
    echo ""
    echo "📋 Container logs:"
    docker logs dental-test
    echo ""
    echo "🔍 Debug suggestions:"
    echo "   1. Check Dockerfile configuration"
    echo "   2. Verify application files are copied correctly"
    echo "   3. Check port mapping and health checks"
fi

# Cleanup
echo ""
echo "🧹 Cleaning up test container..."
docker stop dental-test 2>/dev/null
docker rm dental-test 2>/dev/null

echo ""
echo "💡 Next steps:"
echo "   ✅ If test passed: ./azure-deploy.sh"
echo "   ❌ If test failed: Fix issues and run ./test-docker.sh again" 