# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = ROM.container(
      :sql,
      "sqlite:/home/marcin/Projects/Rails/cqrs_exploration/db/development.db",
    )
  end
end

Rails.application.load_tasks

require 'rom/sql/rake_task'
require 'rom'
