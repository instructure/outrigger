#! /usr/bin/env groovy

pipeline {
  agent { label 'docker' }

  stages {
    stage('Build') {
      steps {
        sh 'docker build -t outrigger .'
      }
    }
    stage('Rubocop') {
      steps {
        sh 'docker run --rm outrigger /bin/bash -l -c "bundle exec rubocop --cache false --fail-level autocorrect"'
      }
    }
    stage('Test') {
      steps {
        sh 'docker run --rm outrigger /bin/bash -l -c "bundle exec wwtd --parallel"'
      }
    }
  }
}
