require 'pry'
require 'nokogiri'

module Intacct
  class Customer < Struct.new(:customer, :current_user)
    attr_accessor :last_response, :data

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

      successful?
    end

    def get *fields
      return false if customer.intacct_system_id.nil?

      fields = [
        :customerid,
        :name,
        :termname
      ] if fields.empty?

      @last_response = Intacct.send_xml do |xml|
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
          id: last_response.at("//customer//customerid").content,
          name: last_response.at("//customer//name").content,
          termname: last_response.at("//customer//termname").content
        })
      end

      successful?
    end

    def update updated_customer = false
      @customer = updated_customer if updated_customer
      return false if customer.intacct_system_id.nil?

      @last_response = Intacct.send_xml do |xml|
        xml.function(controlid: "1") {
          xml.update_customer(customerid: intacct_system_id) {
            xml.name customer.name
            xml.comments
            xml.status "active"
          }
        }
      end

      successful?
    end

    def destroy
      return false if customer.intacct_system_id.nil?

      @last_response = Intacct.send_xml do |xml|
        xml.function(controlid: "1") {
          xml.delete_customer(customerid: intacct_system_id)
        }
      end

      successful?
    end

    def intacct_customer_id
      "C#{customer.id}"
    end

    def intacct_system_id
      "C#{customer.intacct_system_id}"
    end

    private

    def successful?
      if last_response.at('//result//status') and last_response.at('//result//status').content=="success"
        true
      else
        false
      end
    end
  end
end
