module Intacct
  class Invoice < Intacct::Base
    define_hook :custom_invoice_fields

    def create
      return false if object.invoice.intacct_system_id.present?

      send_xml do |xml|
        xml.function(controlid: "f1") {
          xml.send("create_invoice") {
            invoice_xml xml
          }
        }
      end

      successful?
    end

    def update updated_vendor = false
      @object = updated_vendor if updated_vendor
      return false if object.intacct_system_id.nil?


      send_xml do |xml|
        xml.function(controlid: "1") {
          xml.update_vendor(vendorid: intacct_system_id) {
            vendor_xml xml
          }
        }
      end

      successful?
    end

    def destroy
      return false if object.intacct_system_id.nil?

      @response = send_xml do |xml|
        xml.function(controlid: "1") {
          xml.delete_vendor(vendorid: intacct_system_id)
        }
      end

      successful?
    end

    def intacct_invoice_id
      "A#{object.invoice.id}"
    end

    def intacct_system_id
      "A#{object.invoice.intacct_system_id}"
    end

    def invoice_xml xml
      xml.customerid "#{object.customer.intacct_system_id}"
      xml.datecreated {
        xml.year object.invoice.date_time_created.strftime("%Y")
        xml.month object.invoice.date_time_created.strftime("%m")
        xml.day object.invoice.date_time_created.strftime("%d")
      }
      xml.invoiceno intacct_invoice_id
      run_hook :custom_invoice_fields, xml
    end
  end
end
