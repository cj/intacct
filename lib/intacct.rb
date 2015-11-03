$: << File.expand_path(File.dirname(__FILE__))

require 'intacct/version'
require 'net/http'
require 'nokogiri'
require 'hooks'
require 'active_support/all'

require 'intacct/actions'
require 'intacct/base'
require 'intacct/base_factory'
require 'intacct/client'
require 'intacct/callbacks'
require 'intacct/errors'
require 'intacct/response'
require 'intacct/xml_request'
require 'intacct/utils'

require 'intacct/models/bill'
require 'intacct/models/customer'
require 'intacct/models/department'
require 'intacct/models/employee'
require 'intacct/models/expense'
require 'intacct/models/invoice'
require 'intacct/models/location'
require 'intacct/models/project'
require 'intacct/models/task'
require 'intacct/models/timesheet'
require 'intacct/models/vendor'


class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end
end

module Intacct
  extend self

  attr_accessor :xml_sender_id  , :xml_password    ,
                :user_id        , :company_id      , :password ,
                :invoice_prefix , :bill_prefix     ,
                :vendor_prefix  , :customer_prefix ,
                :project_prefix , :task_prefix

  def configure
    yield self
  end
end
