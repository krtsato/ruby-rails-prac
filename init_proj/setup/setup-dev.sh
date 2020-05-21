#!/usr/local/bin/zsh

set -ex

# Create setup files
chmod -R +x init_proj/
source init_proj/create-files/create-setup-files.sh
create_docker_compose
create_dockerfile
create_dockerignore
create_gemfile
touch Gemfile.lock
mkdir -p app/{forms,presenters,services} config/{environments,initializers,locales/views} lib/ spec/{factories,support}
touch app/{forms,presenters,services}/.keep
create_app_presenters_model_presenter
create_config_application
create_config_database
create_config_init_blocked_hosts
create_config_locales_views_paginate_ja
create_lib_html_builder
create_lib_rails_routes
create_rakefile
create_rubocop_files

# Setup rails app
docker-compose run --rm web bash -c \
"set -x \
&& bundle install -j4 \
&& bundle exec rails new . -d postgresql -BCGMST --skip --skip-turbolinks --skip-gemfile \
&& yarn check \
&& bundle exec rails db:create \
&& bundle exec rails g rspec:install \
&& bundle exec rails g kaminari:config \
&& bundle exec rails g kaminari:views default \
&& bundle exec rubocop --auto-gen-config"

# Setup additional files after rails new
append_config_env_dev
append_spec_rails_helper
append_etc_host
create_gitignore

# Start rails development
docker-compose up -d
