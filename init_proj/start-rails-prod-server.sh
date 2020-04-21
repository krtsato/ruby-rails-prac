#!/bin/bash

set -x

bundle exec rails db:migrate

bundle exec rails assets:precompile

bundle exec rails s -b '0.0.0.0' -p 3000
