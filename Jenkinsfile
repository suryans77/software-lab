pipeline {
    agent any

    tools {
        maven 'Maven'      // Confirmed in your Jenkins
        jdk   'JDK21'      // Confirmed in your Jenkins
    }

    environment {
        // Your exact Docker Hub path (username + roll number repo + image name)
        DOCKERHUB_REPO = 'suryans77/imt2023041/todo-app'
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                // Automatic because you use Pipeline script from SCM + credential below
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn -B clean test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package → Fat JAR') {
            steps {
                sh 'mvn -B clean package shade:shade'
                // Creates target/todo-app.jar (thanks to <finalName>todo-app</finalName>)
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKERHUB_REPO}:${IMAGE_TAG}")
                    docker.build("${DOCKERHUB_REPO}:latest")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'suryans7') {
                        // Your exact Docker Hub credential ID
                        docker.image("${DOCKERHUB_REPO}:${IMAGE_TAG}").push()
                        docker.image("${DOCKERHUB_REPO}:latest").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "SUCCESS! Your image is live at:"
            echo "https://hub.docker.com/r/suryans77/imt2023041"
            echo "Run: docker pull suryans77/imt2023041/todo-app:latest"
        }
        failure {
            echo 'Pipeline failed — check the console output above'
        }
        always {
            cleanWs()
        }
    }
}