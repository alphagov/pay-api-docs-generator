#!/usr/bin/env groovy

pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "eu-west-1"
  }

  stages {
    stage('Build') {
      steps {
        sh "./build.sh"
      }
    }
    stage('Deploy') {
      steps {
        sh "echo ${AWS_DEFAULT_REGION}"
        sh "bash ./deploy.sh"
      }
    }
  }
}
