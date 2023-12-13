pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url:'https://github.com/Hemantakumarpati/billing-system.git'
            }
        }
         stage('Ant build') {
             steps {
                 sh 'ant clean compile test package war'
             }
         }
             }
         }
