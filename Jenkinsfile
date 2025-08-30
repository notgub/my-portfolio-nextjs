pipeline {
  agent any
  
  environment {
    DOCKER_IMAGE = 'notgub/my-portfolio-nextjs'
    DOCKER_TAG = "${env.BUILD_NUMBER}"
  }
  
  stages {
    stage('Checkout') {
      steps {
        // Checkout code from SCM (Git)
        checkout scm
        
        script {
          // Get the current git commit hash for tagging
          env.GIT_COMMIT_HASH = sh(
            script: 'git rev-parse --short HEAD',
            returnStdout: true
          ).trim()
          
          // Set additional tags
          env.DOCKER_TAG_LATEST = 'latest'
          env.DOCKER_TAG_COMMIT = "${env.GIT_COMMIT_HASH}"
        }
      }
    }
    
    stage('Build Docker Image') {
      steps {
        script {
          // Build the Docker image
          docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
          
          // Also tag as latest
          sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:${DOCKER_TAG_LATEST}"
          
          // Tag with commit hash
          sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:${DOCKER_TAG_COMMIT}"
        }
      }
    }
    
    stage('Push to Docker Hub') {
      steps {
        script {
          // Login to Docker Hub (credentials should be configured in Jenkins)
          withCredentials([usernamePassword(
            credentialsId: 'docker-hub-credentials',
            usernameVariable: 'DOCKER_USERNAME',
            passwordVariable: 'DOCKER_PASSWORD'
          )]) {
            sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
            
            // Push all tags
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG_LATEST}"
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG_COMMIT}"
            
            // Logout from Docker Hub
            sh "docker logout"
          }
        }
      }
    }
  }
  
  post {
    always {
      // Clean up Docker images to save space
      script {
        sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
        sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG_LATEST} || true"
        sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG_COMMIT} || true"
      }
    }
    
    success {
      echo "Pipeline completed successfully!"
      echo "Docker image pushed: ${DOCKER_IMAGE}:${DOCKER_TAG}"
      echo "Docker image pushed: ${DOCKER_IMAGE}:${DOCKER_TAG_LATEST}"
      echo "Docker image pushed: ${DOCKER_IMAGE}:${DOCKER_TAG_COMMIT}"
    }
    
    failure {
      echo "Pipeline failed!"
    }
  }
}
