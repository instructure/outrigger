FROM instructure/rvm

WORKDIR /usr/src/app

RUN rvm use --default 2.5

COPY --chown=docker:docker outrigger.gemspec Gemfile* /usr/src/app/
COPY --chown=docker:docker lib/outrigger/version.rb /usr/src/app/lib/outrigger/

RUN bundle install -j 4

COPY --chown=docker:docker . /usr/src/app
