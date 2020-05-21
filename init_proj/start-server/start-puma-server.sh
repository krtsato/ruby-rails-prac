#!/bin/bash

set -x

bundle check || bundle install -j4

rm -f tmp/pids/server.pid

bundle exec puma -C config/puma.rb -e production
