module Intacct
  module Models
    class Project < Intacct::Base

      def create_xml(xml)
        xml.projectid attributes.projectid
        xml.name attributes.name
        xml.description attributes.description
        xml.parentid attributes.parentid
        # xml.invoicewithparent attributes.invoicewithparent
        xml.projectcategory attributes.projectcategory
        xml.projecttype attributes.projecttype
        xml.projectstatus attributes.projectstatus
        xml.customerid attributes.customerid
        xml.managerid attributes.managerid
        xml.custuserid attributes.custuserid
        xml.salescontactid attributes.salescontactid
        xml.begindate {
          xml.year attributes.begindate.try(:strftime, "%Y")
          xml.month attributes.begindate.try(:strftime, "%m")
          xml.day attributes.begindate.try(:strftime, "%d")
        }
        xml.enddate {
          xml.year attributes.enddate.try(:strftime, "%Y")
          xml.month attributes.enddate.try(:strftime, "%m")
          xml.day attributes.enddate.try(:strftime, "%d")
        }
        xml.departmentid attributes.departmentid
        xml.locationid attributes.locationid
        # xml.classid attributes.classid
        xml.currency attributes.currency
        xml.billingtype attributes.billingtype
        xml.termname attributes.termname
        xml.docnumber attributes.docnumber
        xml.sonumber attributes.sonumber
        xml.ponumber attributes.ponumber
        xml.poamount attributes.poamount
        xml.pqnumber attributes.pqnumber
        # xml.budgetamount attributes.budgetamount
        # xml.budgetedcost attributes.budgetedcost
        # xml.budgetqty attributes.budgetqty
        xml.userrestrictions attributes.userRestrictions
        # xml.obspercentcomplete attributes.obspercentcomplete
        # xml.budgetid attributes.budgetid
        # xml.billingrate attributes.billingrate
        # xml.billingpricing attributes.billingpricing
        # xml.expenserate attributes.expenserate
        # xml.expensepricing attributes.expensepricing
        # xml.poaprate attributes.poaprate
        # xml.poappricing attributes.poappricing
        xml.status attributes.status
        # xml.supdocid attributes.supdocid
        # xml.invoicemessage attributes.invoicemessage
        # xml.invoicecurrency attributes.invoicecurrency

        if attributes.projectresources
          xml.projectresources {
            attributes.projectresources.each { |projectresource|
              xml.projectresource {
                xml.employeeid projectresource.employeeid
                xml.itemid projectresource.itemid
                xml.resourcedescription projectresource.resoucedescription
                xml.billingrate projectresource.billingrate

              }
            }
          }
        end

        if attributes.customfields
          xml.customfields {
            attributes.customfields.each { |label, customfield|
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