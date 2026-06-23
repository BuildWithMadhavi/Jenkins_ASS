pipeline {
  agent any

  parameters {
    booleanParam(name: 'MANUAL_APPROVAL', defaultValue: false, description: 'Require manual approval before deploy')
    string(name: 'VM_IP', defaultValue: '', description: 'Target VM IP for deployment')
  }

  environment {
    IMAGE_NAME = 'ci-cd-demo'
    DOCKERHUB_REPO = 'yourdockerhubuser/ci-cd-demo'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'npm ci'
        sh 'npm run build'
      }
    }

    stage('Test') {
      steps {
        sh 'npm test'
      }
    }

    stage('Package') {
      steps {
        sh 'tar -czf ci-artifact.tar.gz server.js app lib package.json'
        archiveArtifacts artifacts: 'ci-artifact.tar.gz', fingerprint: true
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
      }
    }

    stage('Push to Docker Hub') {
      when {
        expression { return env.DOCKERHUB_CREDENTIALS_ID != null && env.DOCKERHUB_CREDENTIALS_ID != '' }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh "docker tag ${IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKERHUB_REPO}:${env.BUILD_NUMBER}"
          sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"
          sh "docker push ${DOCKERHUB_REPO}:${env.BUILD_NUMBER}"
        }
      }
    }

    stage('Approval') {
      when { expression { return params.MANUAL_APPROVAL == true } }
      steps {
        input message: 'Approve deployment?', ok: 'Deploy'
      }
    }

    stage('Deploy') {
      steps {
        // Requires an SSH private key stored in Jenkins credentials (type: SSH Username with private key)
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-credentials-id', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
          sh '''
            chmod 600 ${SSH_KEY}
            if [ -n "${DOCKERHUB_REPO}" ]; then
              REMOTE_IMAGE="${DOCKERHUB_REPO}:${BUILD_NUMBER}"
            else
              REMOTE_IMAGE="${IMAGE_NAME}:${BUILD_NUMBER}"
            fi
            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@${VM_IP} \"docker rm -f ci-cd-demo || true; docker pull ${REMOTE_IMAGE} || true; docker run -d --name ci-cd-demo -p 80:3000 ${REMOTE_IMAGE}\"
          '''
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}
