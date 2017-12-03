require 'rake/testtask'

namespace :db do
  require_relative 'config/environment.rb'
  require 'sequel'

  Sequel.extension :migration
  app = NBAStats::Api
  desc 'run migrations'
  task :migrate do
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'infrastructure/database/migrations')
  end

  desc 'Drop all tables'
  task :drop do
    require_relative 'config/environment.rb'
    app.DB[:players].delete
    app.DB[:gameinfos].delete
  end

  desc 'Reset all database table'
  task reset:[:drop, :migrate]

  desc 'Delete dev or test database file'
  task :wipe do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    FileUtils.rm(app.config.db_filename)
    puts "Deleted #{app.config.db_filename}"
  end
end

desc 'run tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'rerun tests'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

namespace :run do
  task :dev do
    sh 'rerun -c "rackup -p 9090"'
  end

  task :test do
    sh 'RACK_ENV=test rerun -c "rackup -p 9000"'
  end
end

desc 'console test'
task :console do
  sh 'pry -r ./spec/test_load_all'
end

desc 'rm vcr'
task :rmvcr do
  sh 'rm spec/fixtures/cassettes/nba_stats_api.yml'
end

desc 'default'
task :default do
  sh 'rake -T'
end

namespace :quality do
  desc 'rubocap test'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'flog test'
  task :flog do
    sh 'flog lib/'
  end

  desc 'reek test'
  task :reek do
    sh 'reek lib/'
  end
end
