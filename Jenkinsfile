pipeline {
    agent any

    stages {
        stage('SCM') {
            steps {
                git 'https://github.com/ninggf/dockerfile.git'
            }

            post {
                success {
                    sh 'echo "php version: ${PHP_VERSION}"'
                }
            }
        }

        stage('Build Images') {
            steps {
                sh 'docker build --compress -t wulaphp/php:${PHP_VERSION}-dev -f ${WORKSPACE}/74-dev.Dockerfile ${WORKSPACE}'
                sh 'docker build --compress -t wulaphp/php:${PHP_VERSION}-cli -f ${WORKSPACE}/74-cli.Dockerfile ${WORKSPACE}'
                sh 'docker build --compress -t wulaphp/php:${PHP_VERSION}-fpm -f ${WORKSPACE}/74-fpm.Dockerfile ${WORKSPACE}'
            }
            post {
                success {
                    sh 'echo "images build successfully"'
                }
            }
        }

        stage('Publish Images') {
             steps {
                sh 'docker push wulaphp/php:${PHP_VERSION}-dev'
                sh 'docker push wulaphp/php:${PHP_VERSION}-cli'
                sh 'docker push wulaphp/php:${PHP_VERSION}-fpm'
             }
             post {
                success {
                    sh 'echo "images published to docker hub successfully"'
                }
             }
        }
    }
}
