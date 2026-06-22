pipeline {
    agent any

    environment {
        PROJECT_DIR = '/home/ubuntu/jenkins-pipeline-envs'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository..."
                git branch: env.BRANCH_NAME, url: 'https://github.com/zaheer-ahmed001/jenkins-pipeline-envs.git'
            }
        }

        stage('Set Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.DEPLOY_ENV = 'prod'
                        env.PORT = '80'
                    } else if (env.BRANCH_NAME == 'staging') {
                        env.DEPLOY_ENV = 'staging'
                        env.PORT = '8082'
                    } else {
                        env.DEPLOY_ENV = 'dev'
                        env.PORT = '8081'
                    }
                    echo "Deploying to: ${env.DEPLOY_ENV} on port ${env.PORT}"
                }
            }
        }

        stage('Tear Down Old Stack') {
            steps {
                sh """
                    cd ${PROJECT_DIR}
                    docker compose -f docker-compose.${env.DEPLOY_ENV}.yml down --remove-orphans || true
                """
            }
        }

        stage('Deploy Stack') {
            steps {
                sh """
                    cd ${PROJECT_DIR}
                    docker compose -f docker-compose.${env.DEPLOY_ENV}.yml up -d --build
                """
            }
        }

        stage('Health Check') {
            steps {
                sh """
                    cd ${PROJECT_DIR}
                    bash scripts/healthcheck.sh ${env.DEPLOY_ENV} ${env.PORT}
                """
            }
        }

        stage('Verify Running Containers') {
            steps {
                sh "docker ps --filter name=${env.DEPLOY_ENV}"
            }
        }
    }

    post {
        success {
            echo " ${env.DEPLOY_ENV} deployment successful!"
        }
        failure {
            echo " Deployment failed! Tearing down..."
            sh """
                cd ${PROJECT_DIR}
                docker compose -f docker-compose.${env.DEPLOY_ENV}.yml down || true
            """
        }
    }
}
