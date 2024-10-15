        // stage('Distribute to Google Play') {
        //     steps {
        //         androidApkUpload(
        //             googleCredentialsId: 'your-google-play-credentials-id',
        //             apkFilesPattern: 'build/app/outputs/flutter-apk/app-release.apk',
        //             trackName: 'internal'  // Can be 'internal', 'alpha', 'beta', or 'production'
        //         )
        //     }
        // }


class Constants {

    static final String MASTER_BRANCH = 'main'

    static final String QA_BUILD = 'Debug'
    static final String RELEASE_BUILD = 'Release'

    static final String INTERNAL_TRACK = 'internal'
    static final String RELEASE_TRACK = 'release'
}

def getBuildType() {
    switch (env.BRANCH_NAME) {
        case Constants.MASTER_BRANCH:
            return Constants.RELEASE_BUILD
        default:
            return Constants.QA_BUILD
    }
}

def getTrackType() {
    switch (env.BRANCH_NAME) {
        case Constants.MASTER_BRANCH:
            return Constants.RELEASE_TRACK
        default:
            return Constants.INTERNAL_TRACK
    }
}

def isDeployCandidate() {
    return ("${env.BRANCH_NAME}" =~ /(develop|master)/)
}

pipeline {
    agent { 
        dockerfile {
            filename 'Dockerfile' 
        }
    }
    // agent any
    // agent { dockerfile true }
    environment {
        appName = 'demo-flutter-app'
        // Keystore credentials for signing the Android app
        // KEY_PASSWORD = credentials('keyPassword')
        // KEY_ALIAS = credentials('keyAlias')
        // KEYSTORE = credentials('keystore')
        // STORE_PASSWORD = credentials('storePassword')
    }
    stages {
        // stage('Setup Android SDK') {
        //     steps {
        //         script {
        //             // Install Build Essentials
        //             sh '''
        //             apt-get update && \
        //             apt-get install -y build-essential
        //             '''

        //             // Set Environment Variables
        //             env.SDK_URL = "https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
        //             env.ANDROID_HOME = "/usr/local/android-sdk"
        //             env.ANDROID_VERSION = "29"

        //             // Download Android SDK
        //             sh '''
        //             mkdir -p "$ANDROID_HOME" .android && \
        //             cd "$ANDROID_HOME" && \
        //             curl -o sdk.zip $SDK_URL && \
        //             unzip sdk.zip && \
        //             rm sdk.zip && \
        //             mkdir -p "$ANDROID_HOME/licenses" && \
        //             echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" && \
        //             yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
        //             '''

        //             // Install Android Build Tool and Libraries
        //             sh '''
        //             $ANDROID_HOME/tools/bin/sdkmanager --update && \
        //             $ANDROID_HOME/tools/bin/sdkmanager "build-tools;29.0.2" "platforms;android-${ANDROID_VERSION}" "platform-tools"
        //             '''
        //         }
        //     }
        // }
        
        // Checkout the latest code from the repository
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/bolaji-atmost/demo-flutter-app.git',
                        credentialsId: 'github-token'
                    ]]
                ])
                sh 'ls -la' // Check files after checkout
            }
        }

        stage('Setup Git Safe Directory') {
            steps {
                sh 'git config --global --add safe.directory /home/mobiledevops/.flutter-sdk'
            }
        }

        
        stage('BUILD') {
            steps {
                script  {
                    dir('andriod') {
                        sh 'flutter build apk --debug'
                    }         
                }
            }
        }
        stage('DISTRIBUTE') {
            steps {
                appCenter apiToken: '',
                        ownerName: '',
                        appName: '',
                        pathToApp: 'build/app/outputs/flutter-apk/',
                        distributionGroups: ''
            }
        }
        stage('Deploy App to Store') {
            when { expression { return isDeployCandidate() } }
            steps {
                echo 'Deploying'
                script {
                    VARIANT = getBuildType()
                    TRACK = getTrackType()

                    if (TRACK == Constants.RELEASE_TRACK) {
                        timeout(time: 5, unit: 'MINUTES') {
                            input "Proceed with deployment to ${TRACK}?"
                        }
                    }

                    try {
                        CHANGELOG = readFile(file: 'CHANGELOG.txt')
                    } catch (err) {
                        echo "Issue reading CHANGELOG.txt file: ${err.localizedMessage}"
                        CHANGELOG = ''
                    }

                    androidApkUpload googleCredentialsId: 'play-store-credentials',
                            filesPattern: "**/outputs/bundle/${VARIANT.toLowerCase()}/*.aab",
                            trackName: TRACK,
                            recentChangeList: [[language: 'en-US', text: CHANGELOG]]
                }
            }
        }
    }
}
