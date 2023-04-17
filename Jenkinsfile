node {
    
    stage('Git Checkout') {
        git branch: 'main', url: 'https://github.com/iamsaikishore/Project5---Deployment-on-Kubernetes-Cluster-using-Jenkins-and-Ansible.git'
    }
    
    stage('Sending Dockerfile to Ansible server over SSH') {
        
        sshagent(['JenkinsAccess']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160'     //ansible server private ip
            sh 'scp /var/lib/jenkins/workspace/kishq-app/* ubuntu@172.31.33.160:/home/ubuntu'
        }
    }
    
    stage('Build the Docker Image') {
        
        sshagent(['JenkinsAccess']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 cd /home/ubuntu'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image build -t $JOB_NAME:v1.$BUILD_NUMBER .'
        }
    }
    
    stage('Build the Docker Image') {
        
        sshagent(['JenkinsAccess']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image tag $JOB_NAME:v1.$BUILD_NUMBER iamsaikishore/$JOB_NAME:v1.$BUILD_NUMBER'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image tag $JOB_NAME:v1.$BUILD_NUMBER iamsaikishore/$JOB_NAME:latest'
        }
    }
    
    stage('Docker Image Tagging') {
        
        sshagent(['JenkinsAccess']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image tag $JOB_NAME:v1.$BUILD_NUMBER iamsaikishore/$JOB_NAME:v1.$BUILD_NUMBER'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image tag $JOB_NAME:v1.$BUILD_NUMBER iamsaikishore/$JOB_NAME:latest'
        }
    }
    
    stage('Push the Docker Images to Docker Hub') {
        
        sshagent(['JenkinsAccess']) {
            withCredentials([string(credentialsId: 'docker_passwd', variable: 'dockerHub')]) {
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker login -u iamsaikishore -p $dockerHub"
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image push iamsaikishore/$JOB_NAME:v1.$BUILD_NUMBER'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image push iamsaikishore/$JOB_NAME:latest'
                
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 docker image rm $JOB_NAME:v1.$BUILD_NUMBER iamsaikishore/$JOB_NAME:v1.$BUILD_NUMBER iamsaikishore/$JOB_NAME:latest'
    
            }
        }
    }
    
    stage('Copying files from Jenkins server to Kubernetes server') {
        
        sshagent(['JenkinsAccess']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.47.132'    //kubernetes server private ip
            sh 'scp /var/lib/jenkins/workspace/kishq-app/* ubuntu@172.31.47.132:/home/ubuntu'
        }
    }
    
    stage('Kubernetes Deployment using Ansible') {
        
        sshagent(['JenkinsAccess']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 cd /home/ubuntu'     //ansible server private ip
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.33.160 ansible-playbook ansible.yml'
        }
    }
    
}
