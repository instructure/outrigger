#! /bin/bash
. ~/.bash_profile
export COVERAGE=1
rvm use ruby-2.1.5 2>/dev/null || :

gem install bundler
bundle install
bundle exec rspec
