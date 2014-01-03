require 'rubygems'
require 'bundler/setup'
# our gem
require 'intacct'
require 'dotenv'
require "faker"
require "pry"
require 'awesome_print'
require 'helpers'

Dotenv.load

Dir["./spec/steps/**/*steps.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Helpers
end
