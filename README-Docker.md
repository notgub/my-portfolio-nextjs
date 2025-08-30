# Docker Deployment Guide

This guide explains how to deploy your Next.js portfolio to Docker Hub.

## Prerequisites

1. Docker installed and running
2. Docker Hub account
3. Logged in to Docker Hub (`docker login`)

## Quick Deployment

### Option 1: Using the deployment script
```bash
# Make sure you're logged in to Docker Hub
docker login

# Run the deployment script
./deploy.sh
```

### Option 2: Manual deployment
```bash
# Build the image
docker build -t notgub/my-portfolio-nextjs:latest .

# Push to Docker Hub
docker push notgub/my-portfolio-nextjs:latest
```

## Running the Container

### Using Docker Compose (recommended)
```bash
# Pull and run using docker-compose
docker-compose up -d
```

### Using Docker directly
```bash
# Pull the image
docker pull notgub/my-portfolio-nextjs:latest

# Run the container
docker run -d --name portfolio -p 3000:3000 notgub/my-portfolio-nextjs:latest
```

## Docker Hub Repository

Your image will be available at:
- **Repository**: `notgub/my-portfolio-nextjs`
- **URL**: https://hub.docker.com/r/notgub/my-portfolio-nextjs
- **Pull command**: `docker pull notgub/my-portfolio-nextjs:latest`

## Environment Variables

The following environment variables can be configured:

- `NODE_ENV`: Set to `production` (default)
- `NEXT_TELEMETRY_DISABLED`: Set to `1` (default)
- `PORT`: Port number (default: 3000)

## Health Check

The container includes a health check endpoint at `/api/health` that returns:
```json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Troubleshooting

### Build Issues
- Make sure all dependencies are properly installed
- Check that the Dockerfile is in the root directory
- Verify that `.dockerignore` is properly configured

### Push Issues
- Ensure you're logged in to Docker Hub (`docker login`)
- Check your internet connection
- Verify you have write permissions to the repository

### Runtime Issues
- Check container logs: `docker logs <container-name>`
- Verify port 3000 is not already in use
- Ensure the health check endpoint is accessible
