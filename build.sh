#! /bin/bash

set -e

docker run --rm -v $(pwd):/usr/src/app instructure/ruby:2.1 /bin/bash -c "bundle install && bundle exec rspec"
