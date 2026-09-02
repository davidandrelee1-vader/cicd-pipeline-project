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
        sh 'PYTHONPATH=. .venv/bin/pytest'
    }
}

stage('Docker Build') {
    steps {
        sh 'docker build -t cicd-pipeline-app:1.3 .'
    }
}

stage('AWS Authentication') {
    steps {
        withCredentials([
            string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            sh 'aws sts get-caller-identity'
            sh 'aws ecr describe-repositories --region us-east-1'
        }
    }
}

stage('Security Scan') {
            steps {
                sh 'trivy image --timeout 10m --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed cicd-pipeline-app:1.3'
            }
        }
    }
}

