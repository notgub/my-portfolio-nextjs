pipeline {
  agent {
    docker {
      image 'docker:latest'
      args '-v /var/run/docker.sock:/var/run/docker.sock -u root'
    }
  }
  
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
          // Build the Docker image using Docker Pipeline plugin
          def dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
          
          // Also tag as latest
          dockerImage.tag("${DOCKER_TAG_LATEST}")
          
          // Tag with commit hash
          dockerImage.tag("${DOCKER_TAG_COMMIT}")
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
            
            // Push all tags using Docker Pipeline plugin
            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
              docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
              docker.image("${DOCKER_IMAGE}:${DOCKER_TAG_LATEST}").push()
              docker.image("${DOCKER_IMAGE}:${DOCKER_TAG_COMMIT}").push()
            }
          }
        }
      }
    }
  }
  
  post {
    always {
      // Clean up Docker images to save space
      script {
        try {
          docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").remove()
          docker.image("${DOCKER_IMAGE}:${DOCKER_TAG_LATEST}").remove()
          docker.image("${DOCKER_IMAGE}:${DOCKER_TAG_COMMIT}").remove()
        } catch (Exception e) {
          echo "Failed to remove some Docker images: ${e.getMessage()}"
        }
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
