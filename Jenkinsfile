#!/usr/bin/env groovy

pipeline {
    agent any

    parameters {
        string(defaultValue: "master", description: 'Public API git branch/tag', name: 'PublicApiBranch')
        booleanParam(
                description: 'Check this parameter to publish API documentation',
                name: 'DEPLOY',
                defaultValue: false)
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
                allOf {
                    branch 'master'
                    expression { params.DEPLOY == true }
                }
            }
            steps {
                sh "echo ${AWS_DEFAULT_REGION}"
                sh "bash ./deploy.sh"
            }
        }
    }
}
