pipeline {
  agent any

  environment {
    DOCKER_HUB_REPO = "notgub/my-portfolio-nextjs"
    DOCKER_HUB_CREDENTIALS = "docker-hub-credential"
    DOCKER_HUB_TAG = "latest"
    // commitHash will be set dynamically
  }

  stages {
    stage('Pre processing') {
      steps {
        deleteDir()
      }
    }

    stage('Checkout') {
      steps {
	      checkout scm

        script {
          env.commitHash = sh(
              script: "git rev-parse --short HEAD",
              returnStdout: true
            ).trim()
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def dockerImage = docker.build("${DOCKER_HUB_REPO}:${DOCKER_HUB_TAG}")
          dockerImage.tag("${env.commitHash}")
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
            def dockerImage = docker.image("${DOCKER_HUB_REPO}:${DOCKER_HUB_TAG}")
            dockerImage.push()
            dockerImage.push("${env.commitHash}")
          }
        }
      }
    }

    stage('Deploy Docker Container') {
      steps {
        script {
          // Stop and remove any existing container with the same name
          sh '''
            docker rm -f my-portfolio-nextjs || true
          '''

          // Run new container from pushed image
          sh '''
            docker run -d --name my-portfolio-nextjs -p 3000:3000 ${DOCKER_HUB_REPO}:${DOCKER_HUB_TAG}
          '''
          // Optionally, to deploy from the commit hash tag:
          // sh '''
          //   docker run -d --name my-portfolio-nextjs -p 3000:3000 ${DOCKER_HUB_REPO}:${commitHash}
          // '''
        }
      }
    }
  }
}
