module Intacct
  class Invoice < Intacct::Base
    define_hook :custom_invoice_fields

    def create
      return false if object.invoice.intacct_system_id.present?

      # Need to create the customer if one doesn't exist
      unless object.customer.intacct_system_id
        intacct_customer = Intacct::Customer.new object.customer
        intacct_customer.create
        if intacct_customer.get
          object.customer.intacct_data = OpenStruct.new intacct_customer.data
        else
          raise 'Could not grab Intacct customer data'
        end
      end

      # Create vendor if we have one and not in Intacct
      if object.vendor and object.vendor.intacct_system_id.blank?
        intacct_vendor = Intacct::Vendor.new object.vendor
        intacct_vendor.create
      end

      send_xml do |xml|
        xml.function(controlid: "f1") {
          xml.send("create_invoice") {
            invoice_xml xml
          }
        }
      end

      successful?
    end

    def delete
      return false unless object.invoice.intacct_system_id.present?

      send_xml do |xml|
        xml.function(controlid: "1") {
          xml.delete_invoice(externalkey: "false", key: object.invoice.intacct_key)
        }
      end

      successful?
    end

    def intacct_object_id
      "AUTO-#{object.invoice.id}"
    end

    def invoice_xml xml
      xml.customerid "#{object.customer.intacct_system_id}"
      xml.datecreated {
        xml.year object.invoice.date_time_created.strftime("%Y")
        xml.month object.invoice.date_time_created.strftime("%m")
        xml.day object.invoice.date_time_created.strftime("%d")
      }

      termname = object.customer.intacct_data.termname
      xml.termname termname.present?? termname : "Net 30"

      xml.invoiceno intacct_object_id
      run_hook :custom_invoice_fields, xml
    end

    def set_intacct_key key
      object.invoice.intacct_key = key
    end

    def delete_intacct_system_id
      object.invoice.intacct_system_id = nil
    end

    def set_date_time type
      if %w(create update delete).include? type
        if object.invoice.respond_to? :"intacct_#{type}d_at"
          object.invoice.send("intacct_#{type}d_at=", DateTime.now)
        end
      end
    end
  end
end
