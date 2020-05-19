#!/bin/bash

set -x

bundle check || bundle install -j4

# if production mode
# bundle exec rails db:migrate
# bundle exec rails assets:precompile

rm -f tmp/pids/server.pid

# bundle exec rails s -b '0.0.0.0' -p 3000
bundle exec puma -C config/puma.rb -e production
