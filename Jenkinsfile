pipeline {
    agent any
    
    environment {
        SOLUTION_NAME = 'LibraryApplication'
        DOCKER_IMAGE = 'library-application'
        DOCKER_REGISTRY = 'hasancagri'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOTNET_VERSION = '9.0'
        // Docker Hub credentials - Jenkins'te environment variables olarak ayarlayın
        DOCKER_HUB_USERNAME = credentials('docker-hub-username')
        DOCKER_HUB_PASSWORD = credentials('docker-hub-password')
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image for WebApi...'
                dir('src/Presentation/WebApi') {
                    script {
                        def image = docker.build("${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}")
                        sh "docker tag ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
                        echo "Docker image built: ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
        
        stage('Push to Registry') {
            when {
                branch 'main'
            }
            steps {
                echo 'Pushing Docker image to registry...'
                script {
                    try {
                        // Docker Hub'a login
                        sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
                        
                        // Push images
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
                        
                        echo "✅ Docker image pushed successfully!"
                    } catch (Exception e) {
                        echo "⚠️ Push failed: ${e.getMessage()}"
                        echo "Skipping push - check Docker Hub credentials"
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to production...'
                script {
                    try {
                        sh """
                            echo "Stopping existing container..."
                            docker stop library-application-prod || echo "No existing container to stop"
                            docker rm library-application-prod || echo "No existing container to remove"
                            
                            echo "Starting new container..."
                            docker run -d --name library-application-prod \
                            -p 5059:8080 \
                            -e ASPNETCORE_ENVIRONMENT=Production \
                            --restart unless-stopped \
                            ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                            
                            echo "Waiting for container to start..."
                            sleep 5
                            
                            echo "Container status:"
                            docker ps --filter "name=library-application-prod"
                        """
                        echo "✅ Application deployed to production!"
                    } catch (Exception e) {
                        echo "⚠️ Deploy failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed! Check console output for details.'
        }
    }
}
