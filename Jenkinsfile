pipeline {
   agent {
      label 'terraform-agent'
   }

   environment {
      TF_IN_AUTOMATION = "true"
   }

   stages {
     stage('Checkout') {
        steps {
           checkout scm
        }
     }

     stage('Terraformt') {
        agent {
          docker {
              image 'hashicorp/terraform:light'
              reuseNode true
              args '--entrypoint=""'
          }
        }
        steps {
          sh 'terraform --version'
          sh 'terraform init'
          sh 'terraform plan -out=tfplan'
          sh 'terraform apply --auto-approve'
        }
     }
   }

   post {
     always {
        cleanWs()
     }
   }
}
