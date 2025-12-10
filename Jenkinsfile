
pipeline {
   agent any
   environment {
      TF_IN_AUTOMATION = "true"
   }
   tools {
      terraform "terraform-latest"
   }

   stages {
     stage('Checkout') {
        steps {
           checkout scm
        }
     }

     stage('Terraform Init') {
        steps {
          sh 'terraform init'
        }
     }

     stage('Terraform Plan') {
        steps {
           sh 'terraform plan -out=tfplan'
        }
     }

     stage('Terraform Apply') {
        steps {
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
