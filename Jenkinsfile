
def TIME_STAMP = "`date +%Y%m%d-%H%M`"
def VERSION_NUM = "0.0.1"
pipeline{
   agent any
    stages{
        stage('Clean Workspace Before Build'){
            steps {
              cleanWs()
                 dir("${env.WORKSPACE}@tmp") {
                   deleteDir()
                 }
            }
        }
        stage('Git Checkout'){
            steps{
                 dir('todo-app') {
                    checkout([$class: 'GitSCM',
                      branches: [[name: "main"]],
                      doGenerateSubmoduleConfigurations: false,
                      extensions: [],                      
                      submoduleCfg: [],
                      userRemoteConfigs: [[credentialsId: "github", url: 'https://github.com/SachPrecious/todo-app.git']]
                    ])
    
                }     
            }           
        }
        stage('Get Version Frontend') {
          steps {
            script {
              def DOCKER_TAG = sh (returnStdout: true, script:"""
              #!/bin/bash
              set -e
              set -x 
              DOCKER_IMAGE_TAG=${VERSION_NUM}-SNAPSHOT-${TIME_STAMP}
              echo \$DOCKER_IMAGE_TAG
              """)
              DOCKER_TAG = DOCKER_TAG.trim()
              DOCKER_IMAGE_TAG = DOCKER_TAG          
            }
          }                    
        }
        stage('Build Docker Image'){
                steps{
                    sh "cd todo-app && docker build -t sach149/${JOB_BASE_NAME}:${DOCKER_IMAGE_TAG} ."
                }
        }
        stage('Push Image to Docker Hub'){
                steps{
                   withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                        sh 'docker login -u sach149 -p ${dockerhub}'
                    }
                    sh "docker push sach149/${JOB_BASE_NAME}:${DOCKER_IMAGE_TAG}"
                    sh "docker rmi sach149/${JOB_BASE_NAME}:${DOCKER_IMAGE_TAG}"
                  
                }
        }    
        stage('Prepare Deployment') {
                steps {
                    // Replacing DOCKER_IMAGE_TAG with Envrionment variables
                    sh "sed -ie 's|DOCKER_IMAGE_TAG|'${DOCKER_IMAGE_TAG}'|g' $WORKSPACE/todo-app/kubernetes/deployment.yaml"
                }
        }    
        stage('Deploy to Kubernetes') {
                steps {                
                    sh "kubectl apply -f $WORKSPACE/todo-app/kubernetes/deployment.yaml"
                }
        }

}
}