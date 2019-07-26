#!/bin/bash -e

docker build -t outrigger .
docker run --rm outrigger /bin/bash -l -c "bundle exec rubocop --cache false --fail-level autocorrect"
docker run --rm outrigger /bin/bash -l -c "bundle exec wwtd --parallel"
