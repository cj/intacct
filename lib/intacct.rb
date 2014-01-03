require 'rails'
require "faker"
require "pry"


require "intacct/version"
require 'net/http'
require 'nokogiri'
require "intacct/base"
require "intacct/customer"
require "intacct/vendor"


module Intacct
  extend self

  attr_accessor :xml_sender_id, :xml_password,
    :app_user_id, :app_company_id, :app_password

  def setup
    yield self
  end
end
