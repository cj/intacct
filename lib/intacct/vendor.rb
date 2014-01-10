module Intacct
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
      @object = updated_vendor if updated_vendor
      return false if object.intacct_system_id.nil?


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
      return false if object.intacct_system_id.nil?

      @response = send_xml('delete') do |xml|
        xml.function(controlid: "1") {
          xml.delete_vendor(vendorid: intacct_system_id)
        }
      end

      successful?
    end

    def intacct_object_id
      "#{intacct_vendor_prefix}#{object.id}"
    end

    def vendor_xml xml
      xml.name "#{object.company_name.present? ? object.company_name : object.full_name}"
      #[todo] - Custom
      xml.vendtype "Appraiser"
      xml.taxid object.tax_id
      xml.billingtype "balanceforward"
      xml.status "active"
      xml.contactinfo {
        xml.contact {
          xml.contactname "#{object.last_name}, #{object.first_name} (#{object.id})"
          xml.printas object.full_name
          xml.companyname object.company_name
          xml.firstname object.first_name
          xml.lastname object.last_name
          xml.phone1 object.business_phone
          xml.cellphone object.cell_phone
          xml.email1 object.email
          if object.billing_address.present?
            xml.mailaddress {
              xml.address1 object.billing_address.address1
              xml.address2 object.billing_address.address2
              xml.city object.billing_address.city
              xml.state object.billing_address.state
              xml.zip object.billing_address.zipcode
            }
          end
        }
      }
      if object.ach_routing_number.present?
        xml.achenabled "#{object.ach_routing_number.present? ? "true" : "false"}"
        xml.achbankroutingnumber object.ach_routing_number
        xml.achaccountnumber object.ach_account_number
        xml.achaccounttype "#{object.ach_account_type.capitalize+" Account"}"
        xml.achremittancetype "#{(object.ach_account_classification=="business" ? "CCD" : "PPD")}"
      end
    end
  end
end
