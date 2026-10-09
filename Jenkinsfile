pipeline {
    agent any

    environment {
        APP_NAME = 'task-manager-api'
        IMAGE_TAG = "v${BUILD_NUMBER}"
        CONTAINER_NAME = 'task-api-container'
    }

    stages {
        stage('Build') {
            steps {
                echo '=== Stage 1: Building Spring Boot Application ==='
                bat 'mvnw.cmd clean compile'
            }
        }

        stage('Test') {
            steps {
                echo '=== Stage 2: Running Unit Tests ==='
                bat 'mvnw.cmd test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package Archive') {
            steps {
                echo '=== Stage 3: Packaging JAR Artifact ==='
                bat 'mvnw.cmd package -DskipTests'
                archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: false
            }
        }

        stage('Deploy (Podman)') {
            steps {
                echo '=== Stage 4: Containerizing & Deploying with Podman ==='
                bat """
                    @echo off
                    echo Stopping existing container if running...
                    podman stop ${CONTAINER_NAME} || exit /b 0
                    podman rm -f ${CONTAINER_NAME} || exit /b 0
                    
                    echo Building Podman image...
                    podman build -t ${APP_NAME}:${IMAGE_TAG} .
                    podman tag ${APP_NAME}:${IMAGE_TAG} ${APP_NAME}:latest
                    
                    echo Deploying new Podman container...
                    podman run -d -p 8080:8080 --name ${CONTAINER_NAME} ${APP_NAME}:latest
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Application deployed at http://localhost:8080/api/tasks"
        }
        failure {
            echo "Pipeline failed. Please check build logs above."
        }
    }
}
