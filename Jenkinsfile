pipeline {
    agent {
        kubernetes {
            defaultContainer "maven"
            yamlFile "jenkins.k8s.yaml"
        }
    }
    tools { 
        maven "Maven 3.8.6"
    }
    options { 
        skipDefaultCheckout() 
    }
    stages {
        stage("Checkout") {
            steps {
                container("gitversion") {
                    script {
                        checkoutSCM(scm)
                        version()
                    }
                }
            }
        }
        // stage("Build") {
        //   steps {
        //       sh "mvn clean package -DskipTests=true"
        //   }
        // }

        // stage("Test") {
        //   steps {
        //       sh "mvn test"
        //   }
        //   post {
        //     always {
        //         junit "target/surefire-reports/*.xml" 
        //     }
        //   }
        // }

        // stage("SonarQube") {
        //     environment {
        //         scannerHome = tool "sonar"
        //     }
        //     steps {
        //         withSonarQubeEnv(installationName: "sonar") {
        //             sh "mvn sonar:sonar -Dsonar.organization=sergeydz -Dsonar.projectKey=SergeyDz_spring-petclinic"
        //         }
        //     }
        // }

        stage("Docker.Build") {
            steps {
                container("docker") {
                    sh "docker build -t sergeydz/spring-petclinic:${env.version} ."
                }
            }
        }
    }
}

def checkoutSCM(scm) {
    checkout([
        $class: "GitSCM",
        branches: scm.branches,
        doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
        extensions: [
            [$class: "CloneOption", reference: "", noTags: false, shallow: false, depth: 0],
            [$class: "RelativeTargetDirectory", relativeTargetDir: ""]
        ],
        userRemoteConfigs: scm.userRemoteConfigs
    ])
}

def version() {
    def gitversion = sh(script: "/tools/dotnet-gitversion", returnStdout: true)
    env.version = readJSON(text: gitversion)?.FullSemVer

    sh "git config --global --add safe.directory ${workspace}"
    def author = sh(script: """git show -s --format=\"%ae\"""", returnStdout: true)

    currentBuild.description = "${env.version} by ${author}"
}