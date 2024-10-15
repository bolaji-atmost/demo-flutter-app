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
                sh 'flutter --version'
                dir('android') {
                    sh '../flutter/bin/flutter build apk'
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
