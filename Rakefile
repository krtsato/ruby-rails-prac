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
