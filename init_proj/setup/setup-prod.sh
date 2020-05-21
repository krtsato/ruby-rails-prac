#!/bin/bash

set -x

# 初回起動の場合
if [ ! -d "vendor/bundle" ] && [ ! -d "public/assets" ]; then 
  mkdir -p tmp/{db,pids,sockets}
  docker-compose run --rm web bash -c \
  "set -x \
  && ./init_proj/setup/wait-for-db.sh \
  && bundle install -j4 \
  && bundle exec rails db:create RAILS_ENV=production \
  && bundle exec rails db:migrate RAILS_ENV=production \
  && bundle exec rails db:seed RAILS_ENV=production \
  && bundle exec rails assets:precompile RAILS_ENV=production"
fi

docker-compose up -d
