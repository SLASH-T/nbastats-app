# frozen_string_literal: false

source 'https://rubygems.org'
#ruby '2.4.2'

# Networking gems
gem 'http'

# Web app related
gem 'econfig'
gem 'pry' # to run console in production
gem 'puma'
gem 'rake' # to run console in production
gem 'roda'

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
  gem 'rake'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'rerun'

  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
