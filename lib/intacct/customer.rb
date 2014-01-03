require 'pry'
require 'nokogiri'

module Intacct
  class Customer < Struct.new(:customer, :current_user)
    attr_accessor :last_response

    def create
      @last_response = Intacct.send_xml do |xml|
        xml.function(controlid: "1") {
          xml.send("create_customer") {
            xml.customerid intacct_customer_id
            xml.name customer.name
            xml.comments
            xml.status "active"
          }
        }
      end

      if last_response.at('//result//status') and last_response.at('//result//status').content=="success"
        # client.intacct_system_id = intacct_customer_id
        # client.intacct_updated_at = Time.now
        # client.save!
        true
      else
        false
      end
    end

    def get
      return false if customer.intacct_system_id.nil?

      @last_response = Intacct.send_xml do |xml|
        xml.function(controlid: "f4") {
          xml.get(object: "customer", key: "#{intacct_system_id}") {
            xml.fields {
              xml.field "customerid"
              xml.field "name"
              xml.field "termname"
            }
          }
        }
      end

      if last_response.at('//result//status') and last_response.at('//result//status').content=="success"
        # Add hook to allow for log creating
        true
      else
        false
      end
    end

    def intacct_customer_id
      "C#{customer.id}"
    end

    def intacct_system_id
      "C#{customer.intacct_system_id}"
    end
  end
end
