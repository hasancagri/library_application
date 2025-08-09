pipeline {
    agent any
    
    environment {
        SOLUTION_NAME = 'LibraryApplication'
        DOCKER_IMAGE = 'library-application'
        DOCKER_REGISTRY = 'hasancagri'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOTNET_VERSION = '9.0'
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
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
                    }
                    echo "✅ Docker image pushed successfully!"
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
                    sh """
                        docker stop library-application-prod || true
                        docker rm library-application-prod || true
                        docker run -d --name library-application-prod \
                        -p 80:8080 \
                        -e ASPNETCORE_ENVIRONMENT=Production \
                        --restart unless-stopped \
                        ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                    echo "✅ Application deployed to production!"
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
