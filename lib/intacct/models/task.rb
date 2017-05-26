module Intacct
  module Models
    class Task < Intacct::Base

      def create_xml(xml)
        xml.recordno           attributes.recordno if attributes.recordno
        xml.name               attributes.name
        xml.description        attributes.description
        xml.projectid          attributes.projectid

        xml.pbegindate         attributes.pbegindate.try(:strftime, '%m/%d/%Y')
        xml.penddate           attributes.penddate.try(:strftime, '%m/%d/%Y')

        xml.itemid             attributes.itemid
        xml.billable           attributes.billable
        xml.taxdescription     attributes.taxdescription
        xml.ismilestone        attributes.ismilestone
        xml.utilized           attributes.utilized
        xml.priority           attributes.priority
        xml.taskno             attributes.taskno
        xml.taskstatus         attributes.taskstatus
        xml.parenttaskname     attributes.parenttaskname
        xml.budgetqty          attributes.budgetqty
        xml.estqty             attributes.estqty
        xml.obspercentcomplete attributes.obspercentcomplete

        # Custom field for Mavenlink
        # TODO(AB): Remove this later
        xml.mavenlink_id attributes.mavenlink_id

        if attributes.taskresources
          xml.taskresources {
            attributes.taskresources.each do |taskresource|
              xml.employeeid taskresource[:employeeid]
            end
          }
        end

        if attributes.customfields
          xml.customfields {
            attributes.customfields.each do |customfield|
              xml.customfield {
                xml.customfieldname customfield[:customfieldname]
                xml.customfieldvalue customfield[:customfieldvalue]
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
