module Intacct
  module Models
    class TaskResource < Intacct::Base

      api_name 'TASKRESOURCES'

      def create_xml(xml)
        xml.taskname attributes.taskname
        xml.employeeid attributes.employeeid
        xml.pbegindate attributes.pbegindate
        xml.penddate attributes.penddate
        xml.abegindate attributes.abegindate
        xml.aenddate attributes.aenddate
        xml.budgetqty attributes.budgetqty
        xml.estqty attributes.estqty
        xml.description attributes.description
        xml.isfulltime attributes.isfulltime
      end

      def update_xml(xml)
        create_xml(xml)
      end
    end
  end
end
