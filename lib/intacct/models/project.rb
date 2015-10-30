module Intacct
  module Models
    class Project < Intacct::Base

      def create_xml(xml)
        xml.projectid key if key
        xml.name object.name
        xml.description object.description
        xml.parentid object.parentid
        # xml.invoicewithparent object.invoicewithparent
        xml.projectcategory object.projectcategory
        xml.projecttype object.projecttype
        xml.projectstatus object.projectstatus
        xml.customerid object.customerid
        xml.managerid object.managerid
        xml.custuserid object.custuserid
        xml.salescontactid object.salescontactid
        xml.begindate {
          xml.year object.begindate.try(:strftime, "%Y")
          xml.month object.begindate.try(:strftime, "%m")
          xml.day object.begindate.try(:strftime, "%d")
        }
        xml.enddate {
          xml.year object.enddate.try(:strftime, "%Y")
          xml.month object.enddate.try(:strftime, "%m")
          xml.day object.enddate.try(:strftime, "%d")
        }
        xml.departmentid object.departmentid
        xml.locationid object.locationid
        # xml.classid object.classid
        xml.currency object.currency
        xml.billingtype object.billingtype
        xml.termname object.termname
        xml.docnumber object.docnumber
        xml.sonumber object.sonumber
        xml.ponumber object.ponumber
        xml.poamount object.poamount
        xml.pqnumber object.pqnumber
        # xml.budgetamount object.budgetamount
        # xml.budgetedcost object.budgetedcost
        # xml.budgetqty object.budgetqty
        xml.userrestrictions object.userRestrictions
        # xml.obspercentcomplete object.obspercentcomplete
        # xml.budgetid object.budgetid
        # xml.billingrate object.billingrate
        # xml.billingpricing object.billingpricing
        # xml.expenserate object.expenserate
        # xml.expensepricing object.expensepricing
        # xml.poaprate object.poaprate
        # xml.poappricing object.poappricing
        xml.status object.status
        # xml.supdocid object.supdocid
        # xml.invoicemessage object.invoicemessage
        # xml.invoicecurrency object.invoicecurrency

        if object.projectresources
          xml.projectresources {
            object.projectresources.each { |projectresource|
              xml.projectresource {
                xml.employeeid projectresource.employeeid
                xml.itemid projectresource.itemid
                xml.resourcedescription projectresource.resoucedescription
                xml.billingrate projectresource.billingrate

              }
            }
          }
        end

        if object.customfields
          xml.customfields {
            object.customfields.each { |label, customfield|
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