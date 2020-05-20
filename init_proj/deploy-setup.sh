#!/bin/bash

set -ex

mkdir -p tmp/{db,pids,sockets}

# assets:precompile in the prod mode contains yarn installation
docker-compose run --rm web bash -c \
"set -x \
&& bundle install -j4 \
&& bundle exec rails db:create RAILS_ENV=production \
&& bundle exec rails db:migrate RAILS_ENV=production \
&& bundle exec rails db:seed RAILS_ENV=production \
&& bundle exec rails assets:precompile RAILS_ENV=production"

docker-compose up
