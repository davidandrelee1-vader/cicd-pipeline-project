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
        sh 'python3 -m venv .venv'
        sh '.venv/bin/pip install -r requirements.txt'
    }
}

stage('Format Check') {
    steps {
        sh '.venv/bin/black --check .'
    }
}

stage('Test') {
    steps {
        sh '.venv/bin/pytest'
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