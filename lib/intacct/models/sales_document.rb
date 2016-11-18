module Intacct
  module Models
    class SalesDocument < Base
      api_name 'sodocument'

      def create_name
        'create_sotransaction'
      end

      def create_xml(xml)
        xml.transactiontype attributes.transactiontype
        xml.datecreated {
          xml.year  attributes.datecreated.try(:strftime, "%Y")
          xml.month attributes.datecreated.try(:strftime, "%m")
          xml.day   attributes.datecreated.try(:strftime, "%d")
        }
        xml.dateposted {
          xml.year  attributes.dateposted.try(:strftime, "%Y")
          xml.month attributes.dateposted.try(:strftime, "%m")
          xml.day   attributes.dateposted.try(:strftime, "%d")
        }
        xml.customerid attributes.customerid
        xml.documentno attributes.documentno
        xml.origdocdate {
          xml.year  attributes.origdocdate.try(:strftime, "%Y")
          xml.month attributes.origdocdate.try(:strftime, "%m")
          xml.day   attributes.origdocdate.try(:strftime, "%d")
        }
        xml.referenceno attributes.referenceno
        xml.termname    attributes.termname
        xml.datedue {
          xml.year  attributes.datedue.try(:strftime, "%Y")
          xml.month attributes.datedue.try(:strftime, "%m")
          xml.day   attributes.datedue.try(:strftime, "%d")
        }
        xml.message        attributes.message
        xml.shippingmethod attributes.shippingmethod
        xml.supdocid       attributes.supdocid
        xml.vsoepricelist  attributes.vsoepricelist
        xml.state          attributes.state
        xml.projectid      attributes.projectid
        xml.currency       attributes.currency

        if attributes.sotransitems
          xml.sotransitems {
            attributes.sotransitems.each { |sotransitem|
              xml.sotransitem {
                xml.itemid      sotransitem[:itemid]
                xml.itemdesc    sotransitem[:itemdesc]
                xml.warehouseid sotransitem[:warehouseid]
                xml.quantity    sotransitem[:quantity]
                xml.unit        sotransitem[:unit]
              }
            }
          }
        end
      end
    end
  end
end
