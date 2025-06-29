pipeline {

    agent any
    
    options {
        timeout(time: 5, unit: "MINUTES")
        timestamps()
    }

    environment {

        GITHUB_REPOSITORY_APP = "github.com/itaytzdaka/weather-app.git"

        ECR_REGISTRY = "054037125849.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPOSITORY_CLIENT = "weather/client"
        ECR_REPOSITORY_SERVER = "weather/server"
        
    }


    stages {

        stage('Print Branch Info') {
            steps {
                echo "Building branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

    //     stage("Get Committer Email") {
    //         steps {
    //             script {
    //                 COMMIT_AUTHOR_EMAIL = sh(
    //                     script: "git log -1 --pretty=format:'%ae'",
    //                     returnStdout: true
    //                 ).trim()
    //                 echo "Commit by: ${COMMIT_AUTHOR_EMAIL}"
    //             }
    //         }
    //     }


        // // not necessary 
        // stage("Build") {
        //     when {
        //         anyOf {
        //             branch 'main'
        //         }
        //     } 
        //     steps {
        //         script {
        //             parallel(
        //                 client: {
        //                     dir('client') {
        //                         sh 'docker build -t weather-client .'
        //                     }
        //                 },
        //                 server: {
        //                     dir('server') {
        //                         sh 'docker build -t weather-server .'
        //                     }
        //                 }
        //             )
        //         }
        //     }
        // }


        stage('E2E Tests') {
            when {
                anyOf {
                    branch 'main'
                    expression { env.BRANCH_NAME.startsWith("feature/") }
                }
            } 
            steps {

                sh 'docker compose up -d --build'
                
                echo "⏳ Waiting for app to be ready..."

                sh 'docker ps'

                sh """
                    for i in \$(seq 1 20); do
                        if curl -sf http://nginx:80/ > /dev/null; then
                            echo "✅ App is up!"
                            break
                        else
                            echo "⏳ Attempt \$i failed, retrying..."
                        fi
                        sleep 2
                    done
                """

                dir('e2e') {
                    sh '''
                        ./e2e-test.sh nginx
                    '''
                }

                sh 'docker compose down'
            }
        }

        stage("version") {
            when {
                anyOf {
                    branch 'main'
                }
            } 
            steps {
                script {


                    sh '''#!/bin/bash
                    
                        git config user.name "Jenkins"
                        git config user.email "jenkins@example.com"

                        # Clean all local tags                                
                        git tag -l | xargs -r git tag -d

                        # Fetch all tags
                        git fetch --tags

                        # Get latest tag
                        latest_version=$(git tag --list '[0-9]*' --sort=-v:refname | head -n 1)

                        if [ -z "$latest_version" ]; then
                            echo "No existing tags found. Using default version: 1.0.0"
                            new_version="1.0.0"
                        else
                            echo "Latest tag: $latest_version"
                            version="$latest_version"
                            IFS='.' read -r major minor patch <<< "$version"
                            new_patch=$((patch + 1)) 
                            new_version="${major}.${minor}.${new_patch}"
                        fi

                        echo "Set new version: $new_version"
                        echo "$new_version" > .version
                    '''

                    def version = readFile('.version').trim()
                    env.VERSION_TAG = version
                    echo "VERSION_TAG set to ${env.VERSION_TAG}"
                        
                    
                }
            }
        }


        stage("push") {
            when {
                anyOf {
                    branch 'main'
                }
            }
            steps {
                script {

                    withEnv(["DOCKER_REGISTRY=${ECR_REGISTRY}"]) {
                        sh """
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin \$DOCKER_REGISTRY

                            docker tag weather-client \$DOCKER_REGISTRY/${ECR_REPOSITORY_CLIENT}:${env.VERSION_TAG}
                            docker push \$DOCKER_REGISTRY/${ECR_REPOSITORY_CLIENT}:${env.VERSION_TAG}

                            docker tag weather-server \$DOCKER_REGISTRY/${ECR_REPOSITORY_SERVER}:${env.VERSION_TAG}
                            docker push \$DOCKER_REGISTRY/${ECR_REPOSITORY_SERVER}:${env.VERSION_TAG}
                        """
                    }
                }
            }
        }


        stage('tag') {
            when {
                branch 'main'
            }
            steps {
                script {
                    withCredentials([string(
                        credentialsId: 'github-token',
                        variable: 'GITHUB_TOKEN'
                    )]) {
                        sh '''#!/bin/bash
                            git config user.name "Jenkins"
                            git config user.email "jenkins@example.com"

                            # Use the GitHub token to authenticate
                            REPO_URL="https://${GITHUB_TOKEN}@${GITHUB_REPOSITORY_APP}"
                            git remote set-url origin "$REPO_URL"

                            echo "Creating tag: $VERSION_TAG"
                            git tag "$VERSION_TAG"
                            git push origin "$VERSION_TAG"
                        '''
                    }
                }
            }
        }


        stage("Deploy") {
            when {
                anyOf {
                    branch 'main'
                }
            }
            steps {
                script {

                    withCredentials([string(
                        credentialsId: 'github-token',
                        variable: 'GITHUB_TOKEN'
                    )]) {
                        sh '''#!/bin/bash

                            # Use the GitHub token to authenticate
                            REPO_URL="https://${GITHUB_TOKEN}@${GITHUB_REPOSITORY_APP}"
                            git remote set-url origin "$REPO_URL"

                            # Update the image tag in values.yaml (example path)
                            sed -i 's/^appVersion:.*$/appVersion: "'${VERSION_TAG}'"/' gitops/charts/application/Chart.yaml

                            cat gitops/charts/application/Chart.yaml

                            # Commit and push
                            git add .
                            git commit -m "Update application version to ${VERSION_TAG}"
                            git push origin HEAD:main
                        '''
                    }
                }
            }
        }

    }

    post { 

        failure {
            echo "failure!"
        }

        success {
            echo "success!"
        }

        always { 

            sh '''
                docker compose down || true
            '''
            
            cleanWs() 
        } 
    }

}
