pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk   'JDK21'
    }

    environment {
        // NOTE: Changed DOCKERHUB_REPO to use standard format (username/repo-name)
        // If 'suryans77' is your username, this is correct.
        DOCKERHUB_REPO = 'suryans77/imt2023041/todo-app' 
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
        FULL_IMAGE     = "${DOCKERHUB_REPO}:${IMAGE_TAG}"
        LATEST_IMAGE   = "${DOCKERHUB_REPO}:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
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
                script {
                    // FIX: We need to authenticate with Docker Hub before calling docker build,
                    // as pulling the base image (eclipse-temurin:21-jdk) requires authorization.
                    withCredentials([usernamePassword(
                        credentialsId: 'suryans7',      // MUST match your stored Jenkins Credential ID
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        // Log in to Docker Hub using BAT/Windows syntax
                        bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                        
                        // Execute the build command (now authorized to pull base images)
                        bat """
                            docker build -t ${FULL_IMAGE} .
                            docker tag ${FULL_IMAGE} ${LATEST_IMAGE}
                        """
                    }
                }
                echo "Built ${FULL_IMAGE} and tagged as latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // We run the login again here to ensure the session is fresh for the push,
                // although the previous login should still be valid.
                withCredentials([usernamePassword(
                    credentialsId: 'suryans7',       // MUST match your stored Jenkins Credential ID
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