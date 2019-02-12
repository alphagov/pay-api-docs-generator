#!/usr/bin/env groovy

pipeline {
    agent any

    parameters {
        string(defaultValue: "master", description: 'Public API git branch/tag', name: 'PublicApiBranch')
    }

    environment {
        AWS_DEFAULT_REGION = "eu-west-1"
        PUBLIC_API_BRANCH = "${params.PublicApiBranch}"
    }

    stages {
        stage('Build') {
            steps {
                sh "./build.sh"
            }
        }
        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                sh "echo ${AWS_DEFAULT_REGION}"
                sh "bash ./deploy.sh"
            }
        }
    }
}
