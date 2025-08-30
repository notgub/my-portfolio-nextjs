pipeline {
  agent any
  
  environment {
    DOCKER_HUB_REPO = "notgub/my-portfolio-nextjs"
    DOCKER_HUB_CREDENTIALS = "docker-hub-credential"
  }
  
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies & Build Next.js') {
      steps {
        sh 'npm install'
        sh 'npm run build'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          def imageTag = "${DOCKER_HUB_REPO}:${commitHash}"
          sh "docker build -t ${imageTag} ."
          sh "docker tag ${imageTag} ${DOCKER_HUB_REPO}:latest"
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh "docker push ${DOCKER_HUB_REPO}:latest"
        }
      }
    }
  }

  post {
    success {
      echo "✅ Build & Push successful!"
    }
    failure {
      echo "❌ Build failed."
    }
  }
}