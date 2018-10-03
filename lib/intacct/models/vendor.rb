module Intacct
  module Models
    class Vendor < Intacct::Base
      def create
        send_xml('create') do |xml|
          xml.function(controlid: "1") {
            xml.create_vendor {
              xml.vendorid intacct_object_id
              vendor_xml xml
            }
          }
        end

        successful?
      end

      def update updated_vendor = false
        @attributes = updated_vendor if updated_vendor
        return false if attributes.intacct_system_id.nil?


        send_xml('update') do |xml|
          xml.function(controlid: "1") {
            xml.update_vendor(vendorid: intacct_system_id) {
              vendor_xml xml
            }
          }
        end

        successful?
      end

      def delete
        return false if attributes.intacct_system_id.nil?

        @response = send_xml('delete') do |xml|
          xml.function(controlid: "1") {
            xml.delete_vendor(vendorid: intacct_system_id)
          }
        end

        successful?
      end

      def intacct_object_id
        "#{intacct_vendor_prefix}#{attributes.id}"
      end

      def vendor_xml xml
        xml.name "#{attributes.company_name.present? ? attributes.company_name : attributes.full_name}"
        #[todo] - Custom
        xml.vendtype "Appraiser"
        xml.taxid attributes.tax_id
        xml.billingtype "balanceforward"
        xml.status "active"
        xml.contactinfo {
          xml.contact {
            xml.contactname "#{attributes.last_name}, #{attributes.first_name} (#{attributes.id})"
            xml.printas attributes.full_name
            xml.companyname attributes.company_name
            xml.firstname attributes.first_name
            xml.lastname attributes.last_name
            xml.phone1 attributes.business_phone
            xml.cellphone attributes.cell_phone
            xml.email1 attributes.email
            if attributes.billing_address.present?
              xml.mailaddress {
                xml.address1 attributes.billing_address.address1
                xml.address2 attributes.billing_address.address2
                xml.city attributes.billing_address.city
                xml.state attributes.billing_address.state
                xml.zip attributes.billing_address.zipcode
              }
            end
          }
        }
        if attributes.ach_routing_number.present?
          xml.achenabled "#{attributes.ach_routing_number.present? ? "true" : "false"}"
          xml.achbankroutingnumber attributes.ach_routing_number
          xml.achaccountnumber attributes.ach_account_number
          xml.achaccounttype "#{attributes.ach_account_type.capitalize+" Account"}"
          xml.achremittancetype "#{(attributes.ach_account_classification=="business" ? "CCD" : "PPD")}"
        end
      end
    end
  end
end
