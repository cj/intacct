module Intacct
  class Customer < Intacct::Base
    def create
      send_xml('create') do |xml|
        xml.function(controlid: "1") {
          xml.send("create_customer") {
            xml.customerid intacct_object_id
            xml.name object.name
            xml.comments
            xml.status "active"
          }
        }
      end

      successful?
    end

    def get *fields
      return false unless object.intacct_system_id.present?

      fields = [
        :customerid,
        :name,
        :termname
      ] if fields.empty?

      send_xml('get') do |xml|
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
      return false unless object.intacct_system_id.present?

      send_xml('update') do |xml|
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

    def delete
      return false unless object.intacct_system_id.present?

      @response = send_xml('delete') do |xml|
        xml.function(controlid: "1") {
          xml.delete_customer(customerid: intacct_system_id)
        }
      end

      successful?
    end

    def intacct_object_id
      "C#{object.id}"
    end
  end
end
