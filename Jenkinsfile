pipeline {
    
  agent {
    kubernetes { 
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

  stages { 
    stage('Clone Repository to Kaniko') {
      steps {
        container('kaniko') {
          git url: 'https://github.com/PREngineer/prengineer.github.io', branch: 'main'
        }
      }
    }
    stage('Build and Push Docker Image to Registry') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor --context "`pwd`" --destination prengineer/cvjp:latest
          '''
        }
      }
    }
  }
}