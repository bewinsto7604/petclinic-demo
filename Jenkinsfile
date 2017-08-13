def projectProperties = [
    [$class: 'BuildDiscarderProperty',strategy: [$class: 'LogRotator', numToKeepStr: '3']],
]
def d
def props
def owner
def version
def artifactid
def sonar_host
def sonar_jdbc
properties(projectProperties)
pipeline {
  agent any
  
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/bewinsto7604/petclinic-demo.git'
        script {
            version = readMavenPom().getVersion().substring(0,5)
            artifactid = readMavenPom().getArtifactId()
            d = [test: 'Default', something: 'Default', other: 'Default']
            props = readProperties defaults: d, file: 'pipeline.properties', text: 'other=Override'
            owner = props['PROJECT_OWNER'] 
            sonar_host = props['SONAR_HOST']
            sonar_jdbc = props['SONAR_JDBC']
        }        
      }
    }  
    stage('Cleanup') {
      steps {
        withMaven(maven: 'Maven3.5') {
          sh 'mvn clean'
        }
        
      }
    }
    stage('Compile') {
      steps {
        withMaven(maven: 'Maven3.5') {
          sh 'mvn compile'
        }
        
      }
    }    
    stage('Unit Test') {
      steps {
        withMaven(maven: 'Maven3.5') {
          sh 'mvn test'
        }
        
      }
    }
    stage('Quality Analysis') {
    	environment {
    		SONAR = credentials('sonar')
    	}
    	steps {
    		withMaven(maven: 'Maven3.5') {
    		  sh "mvn sonar:sonar -Dsonar.host.url=${sonar_host} -Dsonar.jdbc.url=jdbc:h2:${sonar_jdbc}"
    		}	
    	}
    }    
    stage('Build jar and image') {
      steps {
        sh """ \
          set +x
          unset TAG
          echo TAG=$owner/$artifactid:$version > .env
        """       
        script {
            def image=docker.build("$owner/$artifactid:$version", '.')
        }
      }
    }
  }
  post {
    always {
        sh 'curl -o vault.zip https://releases.hashicorp.com/vault/0.7.3/vault_0.7.3_linux_amd64.zip ; yes | unzip vault.zip'
        withCredentials([string(credentialsId: 'role', variable: 'ROLE_ID'),string(credentialsId: 'VAULTTOKEN', variable: 'VAULT_TOKEN')]) {
        sh """ \
          set +x
          export VAULT_ADDR=`awk -F= '\$1=="VAULT_ADDR"{print \$2}' pipeline.properties`
          export VAULT_SKIP_VERIFY=true
          export SECRET_ID=\$(./vault write -field=secret_id -f auth/approle/role/java-example/secret-id)
          export VAULT_TOKEN=\$(./vault write -field=token auth/approle/login role_id=\${ROLE_ID} secret_id=\${SECRET_ID})
          export DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE=\$(./vault read -field=value secret/hello)
          export DOCKER_CONTENT_TRUST=0          
          docker push $owner/$artifactid:$version
          export DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE=''
        """        
        }
        script {
            env.RELEASE_SCOPE = input message: 'User input required', ok: 'Release!',
                    parameters: [choice(name: 'Deploy?', choices: 'yes\nno', description: 'Deploy to Integration environment?')]
        }
        echo "${env.RELEASE_SCOPE}"
        sh """\
            set +x
            export PETCLINICTAG=`awk -F= '\$1=="TAG"{print \$2}' .env`
            docker stack deploy --compose-file=docker-compose.yml $artifactid    
        """            
    }  
  }
  environment {
    mvnHome = 'Maven3.5'
  }
}