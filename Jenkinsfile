pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/maven/apache-maven-3.9.6/bin:$PATH"
        MAVEN_OPTS = "-Xmx4096m"
        SONAR_SCANNER_OPTS = "-Xmx512m"
    }

    stages {
        stage("build"){
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage("SonarQube analysis"){
            environment {
                scannerHome = tool 'arunim-sonar-scanner'
            }
            steps{
                withSonarQubeEnv('arunim-sonarqube-server') { 
                    sh "${scannerHome}/bin/sonar-scanner"
                }    
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}