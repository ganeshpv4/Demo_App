pipeline{

    agent any

    stages{

        stage("Git checkout"){

            steps{
                checkout([$class: 'GitSCM', 
                        branches: [[name: '*/main']],  
                        userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/ganeshpv7/Real-time-project.git']]])
            }
        }
        stage("UNIT Testing"){
            steps{
                sh 'mvn test'
            }
        }
      //  stage("Integration test"){
      //      steps{
    //            sh 'mvn verify -DskipUnitTest'
  //         }
   //     }
        stage("Maven build"){
            steps{
                sh 'mvn clean install'
            }
        }
        stage("Sonarqube Analysis"){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
 //       stage("Quality gate status"){
 //           steps{
 //               script{
 //                   waitForQualityGate abortPipeline: false, 
 //                   credentialsId: 'sonar-api'
 //               }
 //           }
 //       }
        stage("Upload war file to nexus"){
            steps{
                script{

                    def PomVersion = readMavenPom file: 'pom.xml'
                    def NexusRepo = PomVersion.version.endsWith("SNAPSHOT") ? "demoapp-snapshot" : "demoapp-release"

                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: 'real-time', 
                            classifier: '', 
                            file: "target/real-time.war", 
                            type: 'war'
                            ]
                    ], 
                    credentialsId: 'nexus', 
                    groupId: 'com.example', 
                    nexusUrl: '34.205.15.205:8081', 
                    nexusVersion: 'nexus3', 
                    protocol: 'http', 
                    repository: NexusRepo, 
                    version: "${PomVersion.version}"
                }
            }
        }
    }
}