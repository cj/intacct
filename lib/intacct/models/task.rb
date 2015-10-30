module Intacct
  module Models
    class Task < Intacct::Base

      def create_xml(xml)
        xml.taskname object.taskname
        xml.projectid object.projectid
        xml.pbegindate  {
          xml.year object.pbegindate.try(:strftime, "%Y")
          xml.month object.pbegindate.try(:strftime, "%m")
          xml.day object.pbegindate.try(:strftime, "%d")
        }
        xml.penddate {
          xml.year object.penddate.try(:strftime, "%Y")
          xml.month object.penddate.try(:strftime, "%m")
          xml.day object.penddate.try(:strftime, "%d")
        }
        xml.itemid object.itemid
        xml.billable object.billable
        xml.taxdescription object.taxdescription
        xml.ismilestone object.ismilestone
        xml.utilized object.utilized
        xml.priority object.priority
        xml.taskno object.taskno
        xml.taskstatus object.taskstatus
        xml.parenttaskname object.parenttaskname
        xml.budgetqty object.budgetqty
        xml.estqty object.estqty

        if object.taskresources
          xml.taskresources {
            object.taskresources.each do |taskresource|
              xml.employeeid tasresource.employeeid
            end
          }
        end

        if object.customfields
          xml.customfields {
            object.customfields.each do |customfield|
              xml.customfield {
                xml.customfieldname customfield.name
                xml.customfieldvalue customfield.value
              }
            end
          }
        end
      end

      def update_xml(xml)
        create_xml(xml)
      end

    end
  end
end
