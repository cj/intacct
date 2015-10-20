module Intacct
  module Models
    class Project < Intacct::Base

      def create
        send_xml('create') do |xml|
          xml.function(controlid: "1") {
            xml.create_project {
              project_xml(xml)
            }
          }
        end
      end

      def update
        send_xml('update') do |xml|
          xml.function(controlid: '1') {
            xml.update_project(key: key) {
              project_xml(xml)
            }
          }
        end
      end

      read_only_fields :budgetduration, :percentcomplete, :supdocid, :contactinfo, :whenmodified

      private

      def project_xml(xml)
        xml.projectid key if key
        xml.name object.name
        xml.description object.description
        xml.parentid object.parentid
        xml.invoicewithparent object.invoicewithparent
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
        xml.classid object.classid
        xml.currency object.currency
        xml.billingtype object.billingtype
        xml.termname object.termname
        xml.docnumber object.docnumber
        xml.sonumber object.sonumber
        xml.ponumber object.ponumber
        xml.poamount object.poamount
        xml.pqnumber object.pqnumber
        xml.budgetamount object.budgetamount
        xml.budgetedcost object.budgetedcost
        xml.budgetqty object.budgetqty
        xml.userrestrictions object.userRestrictions
        xml.obspercentcomplete object.obspercentcomplete
        xml.budgetid object.budgetid
        xml.billingrate object.billingrate
        xml.billingpricing object.billingpricing
        xml.expenserate object.expenserate
        xml.expensepricing object.expensepricing
        xml.poaprate object.poaprate
        xml.poappricing object.poappricing
        xml.status object.status
        xml.supdocid object.supdocid
        xml.invoicemessage object.invoicemessage
        xml.invoicecurrency object.invoicecurrency

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
      end
    end
  end
end