FROM instructure/rvm

WORKDIR /usr/src/app

RUN rvm use --default 2.5

COPY --chown=docker:docker outrigger.gemspec Gemfile* /usr/src/app/
COPY --chown=docker:docker lib/outrigger/version.rb /usr/src/app/lib/outrigger/

RUN /bin/bash -lc "rvm 2.5,2.6,2.7 do gem install bundler -v 2.2.15"

RUN bundle install -j 4

COPY --chown=docker:docker . /usr/src/app
