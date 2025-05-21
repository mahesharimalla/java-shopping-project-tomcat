pipeline {
    agent any
      tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "MAVEN_HOME"
    }
    
    environment {
        IMAGE_NAME = 'mahesharimalla/java-webapp-tomcat'
        IMAGE_TAG = 'latest'
        PUSH_TO_REGISTRY = 'true'
    }

    stages {
        stage('Fetch Code') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'feature', url: 'https://github.com/mahesharimalla/java-shopping-project-tomcat.git'
            }
            
        }
        stage('Build') {
            steps {
                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    echo 'Archiving the Artifacts'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        
         stage('Deploying into the Tomcat Server') {
            steps {
                // Get some code from a GitHub repository
                deploy adapters: [tomcat9(alternativeDeploymentContext: '', credentialsId: 'tomcat-server', path: '', url: 'http://34.237.136.8:8080')], contextPath: 'java-webapp', war: '**/*.war'
            }
      }
         
         
          stage('Prepare Dockerfile') {
            steps {
                script {
                    writeFile file: 'Dockerfile', text: '''
FROM tomcat:9.0
# Copy built WAR from target directory
COPY target/shopping-site-web-app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        
       stage('Run Docker Container') {
    steps {
        sh '''
            docker rm -f javawebapp-tomcat || true
            docker run -d --name javawebapp-tomcat -p 9090:8080 $IMAGE_NAME
        '''
    }
}

         
         
          stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
    // some block
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG '''
                }
            }
      }
      
      
   }
}
