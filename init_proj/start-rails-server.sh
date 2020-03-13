#!/bin/bash

set -x

bundle check || bundle install -j4

rm -f tmp/pids/server.pid

bundle exec rails s -b "0.0.0.0" -p 3000
