#!/bin/bash

# Docker Hub deployment script for my-portfolio-nextjs

# Configuration
DOCKER_USERNAME="notgub"
IMAGE_NAME="my-portfolio-nextjs"
TAG="latest"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting Docker Hub deployment...${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Build the Docker image
echo -e "${YELLOW}📦 Building Docker image...${NC}"
docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG} .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build completed successfully!${NC}"

# Tag the image with latest
echo -e "${YELLOW}🏷️  Tagging image...${NC}"
docker tag ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG} ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

# Push to Docker Hub
echo -e "${YELLOW}📤 Pushing to Docker Hub...${NC}"
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Push failed! Make sure you're logged in to Docker Hub.${NC}"
    echo -e "${YELLOW}💡 Run 'docker login' to authenticate with Docker Hub.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Successfully pushed to Docker Hub!${NC}"
echo -e "${GREEN}🌐 Image: ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}${NC}"
echo -e "${GREEN}🔗 Docker Hub URL: https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}${NC}"

# Optional: Run the container locally to test
echo -e "${YELLOW}🧪 Testing the pushed image locally...${NC}"
docker run -d --name test-portfolio -p 3000:3000 ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Container started successfully!${NC}"
    echo -e "${GREEN}🌐 Your portfolio is running at: http://localhost:3000${NC}"
    echo -e "${YELLOW}💡 To stop the test container: docker stop test-portfolio && docker rm test-portfolio${NC}"
else
    echo -e "${RED}❌ Failed to start test container${NC}"
fi
