pipeline {
    agent any

    stages {
        stage('Git Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ramadevops2025/k8s-ansible-jenkins.git'
            }
        }
        
        stage('Sending Docker file to Ansible Server using SSH') {
            steps {
                sshagent(['ansible_server']) {
                    sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161'
                    sh 'scp /var/lib/jenkins/workspace/k8s-jenkins-ansible/Dockerfile rama@192.168.204.161:/home/rama'

                }
            }
        }
        
        stage('Build the Docker Image') {
            steps {
                sshagent(['ansible_server']) {
                    sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161'
                    sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 docker build -t $JOB_NAME:v1.$BUILD_ID -f /home/rama/Dockerfile .'
                }
            }
        }
        
        stage('Docker Image Tagging') {
            steps {
                sshagent(['ansible_server']) {
                   sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 cd /home/rama'
                   sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 docker image tag $JOB_NAME:v1.$BUILD_ID ramapemmasani/$JOB_NAME:v1.$BUILD_ID'
                   sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 docker image tag $JOB_NAME:v1.$BUILD_ID ramapemmasani/$JOB_NAME:latest'
                }
            }
        }
        
        stage('Pushing Docker Image to DockerHUB from Ansible Server') {
            steps {
                sshagent(['ansible_server']) {
                    withCredentials([string(credentialsId: 'dockerhub_access', variable: 'dockerhub_access')]) {
                        sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 docker login -u ramapemmasani -p $dockerhub_access'
                        sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 docker image push ramapemmasani/$JOB_NAME:v1.$BUILD_ID'
                        sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 docker image push ramapemmasani/$JOB_NAME:latest'
                    }    
                }
            }
        }
        
        stage('Send Yaml file to K8S server') {
            steps {
                sshagent(['k8s-server']) {
                   sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.136'
                   sh 'scp /var/lib/jenkins/workspace/k8s-jenkins-ansible/Deployment.yaml rama@192.168.204.136:/home/rama'
                   sh 'scp /var/lib/jenkins/workspace/k8s-jenkins-ansible/Service.yaml rama@192.168.204.136:/home/rama'
                }    
            }
        }
        
        stage('Sending Ansible Playbook to Ansible Server using SSH') {
            steps {
                sshagent(['ansible_server']) {
                    sh 'ssh -o StrictHostKeyChecking=no rama@192.168.204.161 cd /home/rama'
                    sh 'scp /var/lib/jenkins/workspace/k8s-jenkins-ansible/ansible.yaml rama@192.168.204.161:/home/rama'
                }
            }
        }
        
        // stage('Hello') {
        //     steps {
        //         echo 'Hello World'
        //     }
        // }
    }
}
