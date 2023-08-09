// Start the Pipeline
pipeline {
  // Define the agent where it will run
  agent {
    // kubernetes = kubernetes cloud in Jenkins
    kubernetes { 
// Define the pod template, what will the pods be, and resources for them
yaml '''
kind: Pod
spec:
  containers:
  - name: alpine
    image: alpine:latest
    command:
    - sleep
    args:
    - 1d
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 1d
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  restartPolicy: Never
  volumes:
  - name: kaniko-secret
    projected:
      sources:
      - secret:
          name: dockercred
          items:
          - key: .dockerconfigjson
            path: config.json
'''
    }
  }
// Start declaring the stages of the pipeline
  stages { 
    // Stage #1 - Clone the repository
    stage('Clone Repository to Kaniko') {
      steps {
        container('kaniko') {
          git url: 'https://github.com/PREngineer/prengineer.github.io', branch: 'master'
        }
      }
    }
    // Stage #2 - Build the Docker image using Kaniko and push to registry
    stage('Build and Push Docker Image to Registry') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor --context "`pwd`" --destination prengineer/cvjp:latest
          '''
        }
      }
    }
    // Stage #3 - Deploy the image to the production kubernetes cluster using an SSH agent
    stage('Deploy to Kubernetes Cluster'){
      steps {
        sshagent(['RPi-SSH']) {
          sh '''
            curl https://raw.githubusercontent.com/PREngineer/prengineer.github.io/master/cvjp-deployment.yaml > cvjp-deployment.yaml
            kubectl apply -f cvjp-deployment.yaml
          '''
        }
      }
    }
  }
}