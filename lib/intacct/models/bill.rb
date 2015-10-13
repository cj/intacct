module Intacct
  module Models
    class Bill < Intacct::Base

      attr_accessor :customer_data

      # define_hook :custom_bill_fields, :bill_item_fields

      def create
        return false if object.payment.intacct_system_id.present?

        # Need to create the customer if one doesn't exist
        unless object.customer.intacct_system_id
          intacct_customer = Intacct::Customer.new object.customer
          unless intacct_customer.create
            raise 'Could not grab Intacct customer data'
          end
        end

        # Create vendor if we have one and not in Intacct
        if object.vendor and object.vendor.intacct_system_id.blank?
          intacct_vendor = Intacct::Vendor.new object.vendor
          if intacct_vendor.create
            object.vendor = intacct_vendor.object
          else
            raise 'Could not create vendor'
          end
        end

        send_xml('create') do |xml|
          xml.function(controlid: "f1") {
            xml.send("create_bill") {
              bill_xml xml
            }
          }
        end

        successful?
      end

      def delete
        return false unless object.payment.intacct_system_id.present?

        send_xml('delete') do |xml|
          xml.function(controlid: "1") {
            xml.delete_bill(externalkey: "false", key: object.payment.intacct_key)
          }
        end

        successful?
      end

      def intacct_object_id
        "#{intacct_bill_prefix}#{object.payment.id}"
      end

      def bill_xml xml
        xml.vendorid object.vendor.intacct_system_id
        xml.datecreated {
          xml.year object.payment.created_at.strftime("%Y")
          xml.month object.payment.created_at.strftime("%m")
          xml.day object.payment.created_at.strftime("%d")
        }
        xml.dateposted {
          xml.year object.payment.created_at.strftime("%Y")
          xml.month object.payment.created_at.strftime("%m")
          xml.day object.payment.created_at.strftime("%d")
        }
        xml.datedue {
          xml.year object.payment.paid_at.strftime("%Y")
          xml.month object.payment.paid_at.strftime("%m")
          xml.day object.payment.paid_at.strftime("%d")
        }
        run_hook :custom_bill_fields, xml
        run_hook :bill_item_fields, xml
      end

      def set_intacct_system_id
        object.payment.intacct_system_id = intacct_object_id
      end

      def set_intacct_key key
        object.payment.intacct_key = key
      end

      def delete_intacct_system_id
        object.payment.intacct_system_id = nil
      end

      def delete_intacct_key
        object.payment.intacct_key = nil
      end

      def set_date_time type
        if %w(create update delete).include? type
          if object.payment.respond_to? :"intacct_#{type}d_at"
            object.payment.send("intacct_#{type}d_at=", DateTime.now)
          end
        end
      end

    end
  end
end
