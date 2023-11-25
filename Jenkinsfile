pipeline {
    agent any
    
    environment {
        // Defina suas variáveis de ambiente aqui, se necessário
        DOCKER_HUB_REPO = "marcosab10/minsait"
        KUBE_NAMESPACE = "desafio"
    }

    stages {
        stage('Build do Projeto') {
            steps {
                script {
                    // Execute os comandos para realizar o build do projeto Spring Boot Java 17
                    sh 'mvn clean package'
                }
            }
        }

        stage('Testes Unitários') {
            steps {
                script {
                    // Execute os comandos para realizar os testes unitários
                    sh 'mvn test'
                }
            }
        }

        stage('Gerar Imagem Docker') {
            steps {
                script {
                    dockerapp = docker.build("$DOCKER_HUB_REPO:latest", '-f ./Dockerfile .')
                }
            }
        }

        stage('Push para Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com','dockerhub'){
                    dockerapp.push('latest')
                }
            }
        }

        stage('Deploy no Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh "kubectl apply -f ./k8s/deployment.yaml --namespace=$KUBE_NAMESPACE"
                }
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh "kubectl set image deployment/web web=$DOCKER_HUB_REPO:latest"
                }
            }
        }
    }
}
