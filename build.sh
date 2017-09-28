#!/bin/bash -e

docker pull ruby:2.3
docker pull ruby:2.4

docker run --rm -v "`pwd`:/app" -w /app --user `id -u`:`id -g` -e HOME="/tmp" "ruby:2.4" \
  /bin/sh -c "echo \"gem: --no-document\" >> ~/.gemrc && bundle install --jobs 5 --quiet && bundle exec rubocop --cache false --fail-level autocorrect"

for gemfile in $(ls spec/gemfiles/*.gemfile); do
  for version in '2.3' '2.4'; do
    echo "Testing Ruby $version with $gemfile..."
    docker run --rm -v "`pwd`:/app" -w /app --user `id -u`:`id -g` \
      -e HOME="/tmp" -e BUNDLE_GEMFILE="$gemfile" "ruby:$version" \
      /bin/sh -c "echo \"gem: --no-document\" >> ~/.gemrc && bundle install --jobs 5 --quiet && bundle exec rspec"
  done
done
