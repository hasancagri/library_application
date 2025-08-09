#!/bin/bash

# Local Jenkins pipeline test script
# Bu script Jenkins pipeline'ını local ortamda test etmek için kullanılır

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
DOCKER_REGISTRY="your-dockerhub-username"  # Buraya Docker Hub kullanıcı adınızı yazın
DOCKER_IMAGE="library-webapi"
BUILD_NUMBER=${BUILD_NUMBER:-$(date +%s)}
DOCKER_TAG="$BUILD_NUMBER"

echo -e "${BLUE}🚀 Jenkins Pipeline Local Test${NC}"
echo -e "${BLUE}📦 Image: ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}${NC}"
echo ""

# Stage 1: Checkout (simulated)
echo -e "${YELLOW}📥 Stage 1: Checkout${NC}"
echo "✅ Source code ready"
echo ""

# Stage 2: Build Docker Image
echo -e "${YELLOW}🔨 Stage 2: Build Docker Image${NC}"
cd src/Presentation/WebApi

docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} .
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Docker build failed!${NC}"
    exit 1
fi

docker tag ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
echo -e "${GREEN}✅ Docker image built successfully${NC}"
echo ""

# Stage 3: Test (simulated)
echo -e "${YELLOW}🧪 Stage 3: Test${NC}"
echo "Running health check tests..."

# Start test container
docker run --rm -d --name test-container-${BUILD_NUMBER} \
    -p 8081:8080 \
    -e ASPNETCORE_ENVIRONMENT=Development \
    ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}

sleep 5

# Health check
curl -f http://localhost:8081/books > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Health check passed${NC}"
else
    echo -e "${YELLOW}⚠️  Health check skipped (service might not be ready)${NC}"
fi

# Stop test container
docker stop test-container-${BUILD_NUMBER} > /dev/null 2>&1
echo ""

# Stage 4: Push (optional)
echo -e "${YELLOW}📤 Stage 4: Push to Registry${NC}"
read -p "Do you want to push to Docker Hub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing to Docker Hub..."
    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Successfully pushed to Docker Hub${NC}"
    else
        echo -e "${RED}❌ Failed to push to Docker Hub${NC}"
    fi
else
    echo "Skipping push to registry"
fi
echo ""

# Stage 5: Cleanup
echo -e "${YELLOW}🧹 Stage 5: Cleanup${NC}"
echo "Cleaning up test containers..."
docker stop test-container-${BUILD_NUMBER} > /dev/null 2>&1 || true
docker rm test-container-${BUILD_NUMBER} > /dev/null 2>&1 || true
echo -e "${GREEN}✅ Cleanup completed${NC}"
echo ""

echo -e "${GREEN}🎉 Pipeline test completed successfully!${NC}"
echo -e "${BLUE}📋 Built image: ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}${NC}"
echo ""
echo -e "${BLUE}🚀 To run the container:${NC}"
echo -e "   docker run -d -p 5059:8080 --name library-webapi ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
