pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/maven/apache-maven-3.9.6/bin:$PATH"
    }

    stages {
        stage("Build stage"){
            steps {
                echo "----------- build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "----------- build complted ----------"
            }
        }
        stage("Executing Unit Tests"){
            steps{
                echo "----------- unit test started ----------"
                sh 'mvn surefire-report:report'
                 echo "----------- unit test Complted ----------"
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

        stage("Quality Gate Results"){
        steps {
        script {
        timeout(time: 1, unit: 'HOURS') {
        def qg = waitForQualityGate()
        if (qg.status != 'OK') {
        error "Pipeline aborted due to quality gate failure: ${qg.status}"
    }
  }
}
    }
  }
    }
}