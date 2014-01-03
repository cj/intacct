require 'pry'
require 'nokogiri'

module Intacct
  class Customer < Intacct::Base
    def create
      send_xml do |xml|
        xml.function(controlid: "1") {
          xml.send("create_customer") {
            xml.customerid intacct_customer_id
            xml.name object.name
            xml.comments
            xml.status "active"
          }
        }
      end

      successful?
    end

    def get *fields
      return false if object.intacct_system_id.nil?

      fields = [
        :customerid,
        :name,
        :termname
      ] if fields.empty?

      send_xml do |xml|
        xml.function(controlid: "f4") {
          xml.get(object: "customer", key: "#{intacct_system_id}") {
            xml.fields {
              fields.each do |field|
                xml.field field.to_s
              end
            }
          }
        }
      end

      if successful?
        @data = OpenStruct.new({
          id: response.at("//customer//customerid").content,
          name: response.at("//customer//name").content,
          termname: response.at("//customer//termname").content
        })
      end

      successful?
    end

    def update updated_customer = false
      @object = updated_customer if updated_customer
      return false if object.intacct_system_id.nil?

      send_xml do |xml|
        xml.function(controlid: "1") {
          xml.update_customer(customerid: intacct_system_id) {
            xml.name object.name
            xml.comments
            xml.status "active"
          }
        }
      end

      successful?
    end

    def destroy
      return false if object.intacct_system_id.nil?

      @response = send_xml do |xml|
        xml.function(controlid: "1") {
          xml.delete_customer(customerid: intacct_system_id)
        }
      end

      successful?
    end

    def intacct_customer_id
      "C#{object.id}"
    end

    def intacct_system_id
      "C#{object.intacct_system_id}"
    end
  end
end
