pipeline {
    agent any

    stages {
        stage('Checkout') {
    steps {
        checkout scm
    }
}

stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }
    

stage('Format Check') {
    steps {
        sh 'black --check .'
    }
}

stage('Test') {
    steps {
        sh 'pytest'
    }
}

stage('Docker Build') {
    steps {
        sh 'docker build -t cicd-pipeline-app:1.0 .'
    }
}

stage('Security Scan') {
            steps {
                sh 'trivy image --exit-code 1 --severity HIGH,CRITICAL cicd-pipeline-app:1.0'
            }
        }
    }
}