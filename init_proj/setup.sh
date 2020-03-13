#!/usr/local/bin/zsh

set -ex

# Create setup files
chmod +x init_proj/create*.sh
source init_proj/create-setup-files.sh
create_docker_compose
create_dockerfile
create_dockerignore
create_gemfile
mkdir -p config/environments config/initializers
create_config_application
create_config_database
create_config_init_blocked_hosts
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
&& bundle exec rubocop --auto-gen-config"

# Setup additional files after rails new
append_config_env_dev
append_etc_host
create_gitignore

# Start rails development
docker-compose up -d
