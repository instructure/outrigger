#! /usr/bin/env groovy

pipeline {
  agent { label 'docker' }

  environment {
    // Make sure we're ignoring any override files that may be present
    COMPOSE_FILE = "docker-compose.yml"
  }

  stages {
    stage('Test') {
      matrix {
        agent { label 'docker' }
        axes {
          axis {
            name 'RUBY_VERSION'
            values '3.2', '3.3', '3.4'
          }
          axis {
            name 'LOCKFILE'
            values 'activerecord-7.1', 'activerecord-7.2', 'Gemfile.lock'
          }
        }
        stages {
          stage('Build') {
            steps {
              sh "docker compose build --pull --build-arg RUBY_VERSION=${RUBY_VERSION} --build-arg BUNDLE_LOCKFILE=${LOCKFILE} app"
              sh 'docker compose run --rm app rake'
            }
          }
        }
      }
    }

    stage('Lint') {
      steps {
        sh "docker compose build --pull --build-arg BUNDLE_LOCKFILE=Gemfile.lock"
        sh "docker compose run --rm app bin/rubocop"
      }
    }
  }

  post {
    cleanup {
      sh 'docker compose down --remove-orphans --rmi all'
    }
  }
}
