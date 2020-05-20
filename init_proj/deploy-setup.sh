#!/bin/bash

set -ex

cd ruby-rails-rspec-prac && mkdir -p tmp/{db,pids,sockets}

docker-compose run --rm web bash -c \
"set -x \
&& bundle install -j4 --deployment \
&& yarn install --production \
&& bundle exec rails db:create RAILS_ENV=production \
&& bundle exec rails db:migrate RAILS_ENV=production \
&& bundle exec rails db:seed RAILS_ENV=production \
&& bundle exec rails assets:precompile RAILS_ENV=production"

docker-compose up
