pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
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
                sh 'git config --global --add safe.directory /home/mobiledevops/.flutter-sdk'
                sh 'flutter upgrade'
                sh 'flutter --version'
                dir('/home/atmost/agent-002/workspace/njem-appci') {
                    sh 'flutter pub get'
                    sh 'flutter build apk --debug'
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: '**/build/app/outputs/flutter-apk/app-debug.apk', fingerprint: true
        }
        failure {
            echo 'The Pipeline failed :('
            sh 'docker ps -a'
            sh 'docker logs $(docker ps -aq | head -n 1)'
            sh 'docker system prune -f'
        }
    }
}
