#!/bin/bash

set -x

bundle check || bundle install -j4

rm -f tmp/pids/server.pid

# If you are in the development, set -e development 
bundle exec puma -C config/puma.rb -e production
