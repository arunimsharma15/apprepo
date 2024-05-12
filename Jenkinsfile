def registry = 'https://arunim.jfrog.io'
def imageName = 'arunim.jfrog.io/arunim/ttrend'


pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/maven/apache-maven-3.9.6/bin:$PATH"
        version = ''
    }

    stages {
        stage("Build stage"){
            steps {
                
                echo "----------- build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'

                script {
                    version = sh(script: "mvn -q -Dexec.executable=echo -Dexec.args='\${project.version}' --non-recursive exec:exec", returnStdout: true).trim()
                }
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

        
         stage("Jar Publish") {
            steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifactory_cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "arunim-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }

    stage(" Docker Build ") {
      steps {
        script {
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build("${imageName}:${version}", "--build-arg version=${version} .")
           echo '<--------------- Docker Build Ends --------------->'
        }
      }
    }

    // stage("Docker Image Scan") {
    //         steps {
    //             script {
    //                 echo '<--------------- Docker Image Scan Started --------------->'
    //                 sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${imageName}:${version}"
    //                 echo '<--------------- Docker Image Scan Ended --------------->'
    //             }
    //         }
    //     }



            stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'  
                docker.withRegistry(registry, 'artifactory_cred'){
                    app.push()
                }    
               echo '<--------------- Docker Publish Ended --------------->'
               echo '<--------------- Docker Cleanup Started --------------->'
               sh "docker rmi ${imageName}:${version}"
               sh 'docker rmi $(docker images -f "dangling=true" -q)'
               sh "docker rmi openjdk:17"
               echo '<--------------- Docker Cleanup Ended --------------->'
            }
        }
    }



    }
}