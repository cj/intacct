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
        xml.createdfrom attributes.createdfrom
        xml.customerid  attributes.customerid
        xml.documentno  attributes.documentno
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
        xml.externalid     attributes.externalid
        xml.basecurr       attributes.basecurr
        xml.currency       attributes.currency
        xml.exchratedate {
          xml.year  attributes.exchratedate.try(:strftime, "%Y")
          xml.month attributes.exchratedate.try(:strftime, "%m")
          xml.day   attributes.exchratedate.try(:strftime, "%d")
        }
        xml.exchratetype   attributes.exchratetype
        xml.vsoepricelist  attributes.vsoepricelist

        if attributes.customfields
          xml.customfields {
            attributes.customfields.each { |customfield|
              xml.customfield {
                xml.customfieldname customfield[:customfieldname]
                xml.customfieldvalue customfield[:customfieldvalue]
              }
            }
          }
        end

        xml.state          attributes.state
        xml.projectid      attributes.projectid

        if attributes.sotransitems
          xml.sotransitems {
            attributes.sotransitems.each { |sotransitem|
              xml.sotransitem {
                xml.itemid            sotransitem[:itemid]
                xml.itemdesc          sotransitem[:itemdesc]
                xml.quantity          sotransitem[:quantity]
                xml.unit              sotransitem[:unit]
                xml.price             sotransitem[:price]
                xml.locationid        sotransitem[:locationid]
                xml.departmentid      sotransitem[:departmentid]
                xml.memo              sotransitem[:memo]
                xml.projectid         sotransitem[:projectid]
                xml.customerid        sotransitem[:customerid]
                xml.vendorid          sotransitem[:vendorid]
                xml.employeeid        sotransitem[:employeeid]
                xml.classid           sotransitem[:classid]
                xml.contractid        sotransitem[:contractid]
                xml.fulfillmentstatus sotransitem[:fulfillmentstatus]
                xml.taskno            sotransitem[:taskno]
                xml.billingtemplate   sotransitem[:billingtemplate]
                xml.dropship          sotransitem[:dropship]
              }
            }
          }
        end
      end
    end
  end
end
