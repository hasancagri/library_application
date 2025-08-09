pipeline {
    agent any

    environment {
        TAG = "${BUILD_NUMBER}-${env.GIT_COMMIT.substring(0, 6)}"
        NAMESPACE = 'app-staging'
    }

    stages {
        stage('LIBRARY_MODULE') {
            stages {
                stage('LIBRARY_MODULE - Build/Push Image and Deploy') {
                    steps {
                        sh("docker build  --build-arg MODE=${params.MODE} -t hasancagri/library-webapi:$TAG -f src/Presentation/WebApi/Dockerfile .")
                        sh("docker push hasancagri/library-webapi:$TAG")
                    }
                }
            }
        }   
    }
}
