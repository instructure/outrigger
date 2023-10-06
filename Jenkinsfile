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
            values '2.7', '3.0', '3.1', '3.2'
          }
          axis {
            name 'RAILS_VERSION'
            values '6.0', '6.1', '7.0', '7.1'
          }
        }
        excludes {
          exclude {
            axis {
              name 'RUBY_VERSION'
              values '2.6'
            }
            axis {
              name 'RAILS_VERSION'
              values '7.0'
            }
          }
        }
        stages {
          stage('Build') {
            steps {
              sh "docker compose build --pull --build-arg RUBY_VERSION=${RUBY_VERSION} --build-arg BUNDLE_LOCKFILE=Gemfile.activerecord-${RAILS_VERSION}.lock app"
              sh 'docker compose run --rm app rake'
            }
          }
        }
      }
    }

    stage('Lint') {
      steps {
        // We should be able to use Gemfile.lock here, but currently we cannot
        sh "docker compose build --pull --build-arg BUNDLE_LOCKFILE=Gemfile.activerecord-7.1.lock"
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
