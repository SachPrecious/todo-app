
def TIME_STAMP = "`date +%Y%m%d-%H%M`"
pipeline{
   agent any
   parameters {
      string(defaultValue: "https://github.com/SachPrecious/${JOB_BASE_NAME}.git", description: 'Whats the GITLAB URL?', name: 'GITLAB_URL')
      listGitBranches branchFilter: '.*', description: 'Select the Branch', credentialsId: 'github', defaultValue: 'develop', listSize: '5', name: 'GITLAB_BRANCH', quickFilterEnabled: false, remoteURL: "https://github.com/SachPrecious/${JOB_BASE_NAME}.git", selectedValue: 'DEFAULT', sortMode: 'DESCENDING_SMART', tagFilter: '*', type: 'PT_BRANCH'
  }
    
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
                      branches: [[name: "${params.GITLAB_BRANCH}"]],
                      doGenerateSubmoduleConfigurations: false,
                      extensions: [],                      
                      submoduleCfg: [],
                      userRemoteConfigs: [[credentialsId: "github", url: 'https://github.com/SachPrecious/${JOB_BASE_NAME}.git']]
                    ])
    
                }     
            }           
        }
        stage('Get Version Frontend') {
          steps {
            script {
              def VERSION_TAG = sh (returnStdout: true, script:"""
              #!/bin/bash
              set -e
              set -x 
              VERSION_NUM=`jq -r .version ./todo-app/package.json`
              echo \$VERSION_NUM
              """)
              VERSION_TAG = VERSION_TAG.trim()
              VERSION_NUM = VERSION_TAG
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
                    sh "cd todo-app && docker build -t sachithram/${JOB_BASE_NAME}:${DOCKER_IMAGE_TAG} ."
                    
                }
        }
        stage('Push Image to Docker Hub'){
                steps{
                   withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                        sh 'docker login -u sachithram -p ${dockerhub}'
                    }
                    sh "docker push sachithram/${JOB_BASE_NAME}:${DOCKER_IMAGE_TAG}"
                    sh "docker rmi sachithram/${JOB_BASE_NAME}:${DOCKER_IMAGE_TAG}"
                  
                }
        }    
        stage('Prepare Deployment') {
                steps {
                    // Replacing DOCKER_IMAGE_TAG with Envrionment variables
                    sh "sed -ie 's|DOCKER_IMAGE_TAG|'${DOCKER_IMAGE_TAG}'|g' $WORKSPACE/kubernetes/deployment.yaml"
                }
        }    
        stage('Deploy to Kubernetes') {
                steps {                
                    withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                         sh 'scp -i /home/deploy-server.pem docker-stack.yml ubuntu@54.144.131.180:/tmp/'
                         sh "ssh -t -i /home/deploy-server.pem ubuntu@54.144.131.180 'docker login -u sachithram -p ${dockerhubpwd} ; cd /tmp/ ; docker stack deploy --compose-file docker-stack.yml test'"
                    }
                }
        }

}
}