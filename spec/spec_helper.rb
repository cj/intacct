require 'rubygems'
require 'bundler/setup'
# our gem
require 'intacct'
require 'dotenv'
Dotenv.load

Dir["./spec/steps/**/*steps.rb"].each { |f| require f }

RSpec.configure do |config|

end
