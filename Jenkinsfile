pipeline {
    agent any

    options {
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {
        stage('Prepare') {
            steps {
                sh 'docker version'
                sh 'docker info'
                sh 'docker pull mobiledevops/flutter-sdk-image:3.16.3'
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'mobiledevops/flutter-sdk-image:3.16.3'
                    args '-u root:root'
                    reuseNode true
                }
            }
            steps {
                sh 'echo "Current directory: $PWD"'
                sh 'ls -la'
                sh 'which flutter || echo "Flutter not found in PATH"'
                sh 'echo $PATH'
                sh 'flutter --version || echo "Flutter command not found"'
                dir('android') {
                    sh 'echo "Android directory: $PWD"'
                    sh 'ls -la'
                    sh 'flutter build apk || echo "Flutter build failed"'
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk', fingerprint: true
        }
        failure {
            echo 'The Pipeline failed :('
            sh 'docker ps -a'
            sh 'docker logs $(docker ps -aq | head -n 1)'
        }
    }
}
