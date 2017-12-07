ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'watir'
require 'headless'

require './init.rb'

HOST = 'http://localhost:9292'

def homepage
  HOST
end
