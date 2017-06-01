module Intacct
  module Models
    class Project < Intacct::Base

      def create_xml(xml)
        xml.recordno attributes.recordno if attributes.recordno
        xml.projectid attributes.projectid
        xml.name attributes.name
        xml.description attributes.description

        xml.currency attributes.currency
        xml.projectcategory attributes.projectcategory
        xml.projectstatuskey attributes.projectstatuskey
        xml.projectstatus attributes.projectstatus
        xml.preventtimesheet attributes.preventtimesheet
        xml.preventexpense attributes.preventexpense
        xml.preventappo attributes.preventappo
        xml.preventgeninvoice attributes.preventgeninvoice

        xml.begindate attributes.begindate.try(:strftime, '%m/%d/%Y')
        xml.enddate attributes.enddate.try(:strftime, '%m/%d/%Y')

        xml.budgetamount attributes.budgetamount
        xml.contractamount attributes.contractamount
        xml.actualamount attributes.actualamount
        xml.budgetqty attributes.budgetqty

        xml.percentcomplete attributes.percentcomplete

        xml.customerkey attributes.cutomerkey
        xml.customerid attributes.customerid

        xml.projecttypekey attributes.projecttypekey
        xml.projecttype attributes.projecttype

        xml.departmentid attributes.departmentid
        xml.locationid attributes.locationid

        xml.managerid attributes.managerid

        xml.classid attributes.classid

        xml.docnumber attributes.docnumber

        xml.billingtype attributes.billingtype

        xml.ponumber attributes.ponumber

        # Custom field for Mavenlink purposes
        # TODO(AB): Remove this later
        xml.mavenlink_id attributes.mavenlink_id

        if attributes.projectresources
          xml.projectresources {
            attributes.projectresources.each { |projectresource|
              xml.projectresource {
                xml.employeeid projectresource[:employeeid]
                xml.itemid projectresource[:itemid]
                xml.resourcedescription projectresource[:resoucedescription]
                xml.billingrate projectresource[:billingrate]

              }
            }
          }
        end

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

      end

      def update_xml(xml)
        create_xml(xml)
      end
    end
  end
end
