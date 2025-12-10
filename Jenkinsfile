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

     stage('Terraform') {
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
