pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk   'JDK21'
    }

    environment {
        // Changed to your personal namespace → no organization permission issues
        DOCKERHUB_REPO = 'suryans77/todo-app'
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
        FULL_IMAGE     = "${DOCKERHUB_REPO}:${IMAGE_TAG}"
        LATEST_IMAGE   = "${DOCKERHUB_REPO}:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                bat 'mvn -B clean test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package → Fat JAR') {
            steps {
                bat 'mvn -B clean package shade:shade'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                    docker build -t ${FULL_IMAGE} .
                    docker tag ${FULL_IMAGE} ${LATEST_IMAGE}
                """
                echo "Built ${FULL_IMAGE} and tagged as latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'suryans7',           // keep your existing credential ID
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker push ${FULL_IMAGE}
                        docker push ${LATEST_IMAGE}
                    """
                }
                echo 'Successfully pushed to Docker Hub!'
            }
        }
    }

    post {
        success {
            echo 'SUCCESS! Your image is now live on Docker Hub'
            echo "https://hub.docker.com/r/${DOCKERHUB_REPO}"
            echo "docker pull ${LATEST_IMAGE}"
        }
        failure {
            echo 'Pipeline failed — check the console output above'
        }
        always {
            cleanWs()
        }
    }
}