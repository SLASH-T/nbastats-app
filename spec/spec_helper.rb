ENV['RACK_ENV'] = 'development'

require 'minitest/autorun'
require 'minitest/rg'
require 'watir'
require 'headless'

require './init.rb'

HOST = 'http://localhost:9000'

def homepage
  HOST
end
 
