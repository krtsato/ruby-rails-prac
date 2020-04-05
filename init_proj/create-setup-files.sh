#!/usr/local/bin/zsh

#################### docker-compose.yml ####################

create_docker_compose() {
  cat <<EOF > docker-compose.yml
version: '3.7'
services:
  db:
    container_name: rrrp-db-cont
    environment:
      - POSTGRES_USER
      - POSTGRES_PASSWORD
    image: postgres:12.2-alpine
    ports:
      - 5432:5432
    volumes:
      - ./tmp/db:/var/lib/postgresql/data

  web:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: rrrp-web-cont
    depends_on:
      - db
    environment:
      - POSTGRES_USER
      - POSTGRES_PASSWORD
      - DB_HOST
      - DB_PORT
      - DB_DEV_NAME
      - DB_TEST_NAME
      - DB_PROD_NAME
      - ADMIN_STAFF_HOST_NAME
      - CUSTOMER_HOST_NAME
      - RAILS_SERVE_STATIC_FILES
      - RUBYOPT
      - TZ
    image: rrrp-web-img
    volumes:
      - .:/proj-cont
      - ./vendor/bundle:/usr/local/bundle
      - ./node_modules:/proj-cont/node_modules
    ports:
      - 3000:3000 # Rails
      - 3001:3001 # webpack-dev-server
    tty: true
EOF
}

#################### Dockerfile ####################

create_dockerfile() {
  cat <<EOF > Dockerfile
FROM ruby:2.7.0-alpine3.11

WORKDIR /proj-cont

COPY init_proj/create-rc-files.sh .

RUN set -ox pipefail \
  && ./create-rc-files.sh \
  && apk update \
  && apk add --no-cache \
    bash vim yarn tzdata build-base \
    postgresql-client postgresql-dev \
  && gem install bundler -N \
  && rm -rf /var/cache/apk/*s

COPY . .

CMD ["init_proj/start-rails-server.sh"]
EOF
}

#################### .dockerignore ####################

create_dockerignore() {
  cat <<EOF > .dockerignore
.env
.git
.gitignore
**/docker-compose*
**/Dockerfile*
**/node_modules
**/npm-debug.log
README.md
yarn-error.log
EOF
}

#################### Gemfile ####################

create_gemfile() {
  cat <<EOF > Gemfile
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails'
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bcrypt'
gem 'rails-i18n'
gem 'kaminari'
gem 'date_validator'
gem 'valid_email2'
gem 'nokogiri'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end
EOF
}

#################### config/database.yml ####################

create_config_database() {
  cat <<EOF > config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV['DB_HOST'] %> 
  password: <%= ENV['POSTGRES_PASSWORD'] %>
  pool: <%= ENV.fetch('RAILS_MAX_THREADS') { 5 } %>
  timeout: 5000
  username: <%= ENV['POSTGRES_USER'] %>

development:
  <<: *default
  database: <%= ENV['DB_DEV_NAME'] %> 
  port: <%= ENV['DB_PORT'] %>

test:
  <<: *default
  database: <%= ENV['DB_TEST_NAME'] %>

production:
  <<: *default
  database: <%= ENV['DB_PROD_NAME'] %>
EOF
}

#################### .gitignore ####################

create_gitignore() {
  cat <<EOF > .gitignore
# Ignore bundler config.
/vendor/*
!/vendor/.keep

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

/yarn-error.log
yarn-debug.log*

# Ignore uploaded files in development.
/storage/*
!/storage/.keep

/public/assets
.byebug_history

# Ignore master key for decrypting credentials and more.
/config/master.key
/.env

# others
/public/packs
/public/packs-test
/node_modules
/.markdownlint.yml
.yarn-integrity
EOF
}

#################### config/application.rb ####################

create_config_application() {
  cat <<EOF > config/application.rb
require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyRailsRSepcPrac
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # The setting of time and locale
    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # In the case of hands-on, stop automatical generations
    config.generators do |g|
      g.assets false
      g.controller_specs false
      g.helper false
      g.skip_routes true
      g.test_framework :rspec
      g.view_specs false
    end

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
EOF
}

#################### config/environments/development.rb ####################

append_config_env_dev() {
  readonly local CONFIG_ENV_DEV_DIR=config/environments/development.rb
  sed -i "" -e '$d' $CONFIG_ENV_DEV_DIR # Delete the last line
  cat <<EOF >> $CONFIG_ENV_DEV_DIR

  # For web-console running on the docker network
  config.web_console.whitelisted_ips = [ "172.16.0.0/12" ]
end
EOF
}

#################### config/initializers/blocked_hosts.rb ####################

create_config_init_blocked_hosts() {
  cat <<EOF > config/initializers/blocked_hosts.rb
Rails.application.configure do
  config.hosts << "localhost"
  config.hosts << ENV["CUSTOMER_HOST_NAME"]
  config.hosts << ENV["STAFF_HOST_NAME"]
end
EOF
}

#################### Rakefile ####################

create_rakefile() {
  cat <<EOF > Rakefile
# Tasks will automatically be available to rake/rails.
# e.g. lib/tasks/capistrano.rake 

require_relative 'config/application'
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-performance'
  task.requires << 'rubocop-rspec'
  task.requires << 'rubocop-rails'
end

Rails.application.load_tasks
EOF
}

#################### spec/rails_helper.rb ####################

append_spec_rails_helper() {
  touch spec/factories/.keep
  readonly local SPEC_RAILS_HELPER_DIR=spec/rails_helper.rb
  readonly local ORIGINAL_TEXT="^require 'rspec\/rails'$"
  readonly local ORIGINAL_LINE_NUM=$(grep -n $ORIGINAL_TEXT $SPEC_RAILS_HELPER_DIR | cut -c 1)
  readonly local TARGET_LINE_NUM=$(($ORIGINAL_LINE_NUM + 1))
  readonly local INSERTED_TEXT="Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each {|f| require f}"

  # spec/support に shared_example・shared_context を配置する
  # BSD sed の行番号指定による挿入
  # ダブルクォートで囲む場合は \ でエスケープ
  # sed '<行番号>i\
  #   <挿入文字列>' <ファイルパス>
  sed -i '' -e "${TARGET_LINE_NUM}i\\
    $INSERTED_TEXT" $SPEC_RAILS_HELPER_DIR

  # Factory Bot のメソッドを spec ファイルで使用する
  sed -i "" -e '$d' $SPEC_RAILS_HELPER_DIR # Delete the last line
  cat <<EOF >> $SPEC_RAILS_HELPER_DIR

  # enable to use methods which is defined in FactoryBot::Syntax::Methods
  config.include FactoryBot::Syntax::Methods
end
EOF
}


#################### /etc/hosts in the host machine ####################

append_etc_host() {
  sudo zsh -c "cat >> /etc/hosts" <<EOF
# Added by ruby-rails-rspec-prac
127.0.0.1 example.com rrrp.example.com
# End of section
EOF
}

#################### rubocop files ####################

create_rubocop_files() {
  touch .rubocop_todo.yml
  cat <<EOF > .rubocop.yml
inherit_from:
  - .rubocop_todo.yml

require:
  - rubocop-performance
  - rubocop-rails
  - rubocop-rspec

AllCops:
  TargetRubyVersion: 2.7
  Exclude:
    - app/views/**/*
    - bin/**/*
    - config/**/*
    - db/**/*
    - init_proj/**/*
    - lib/**/*
    - log/**/*
    - node_modules/**/*
    - public/**/*
    - storage/**/*
    - tmp/**/*
    - vendor/**/*
    - config.ru
    - Gemfile
    - Rakefile

Layout/LineLength:
  Max: 120

Layout/SpaceInLambdaLiteral:
  EnforcedStyle: require_space

Layout/SpaceInsideBlockBraces:
  EnforcedStyle: no_space
  SpaceBeforeBlockParameters: false

Layout/SpaceInsideHashLiteralBraces:
  EnforcedStyle: no_space

Metrics/AbcSize:
  Max: 20

Metrics/BlockLength:
  Exclude:
    - 'spec/**/*'

Metrics/MethodLength:
  Max: 15

RSpec/ExampleLength:
  Max: 10

Style/AsciiComments:
  Enabled: false

Style/Documentation:
  Enabled: false

Style/HashEachMethods:
  Enabled: true

Style/HashTransformKeys:
  Enabled: true

Style/HashTransformValues:
  Enabled: true

Style/IfUnlessModifier:
  Enabled: false

Style/RedundantSelf:
  Enabled: false
EOF
}
