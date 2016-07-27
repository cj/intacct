module Intacct
  module Models
    class ProjectResource < Intacct::Base

      api_name 'projectresources'

      def create_xml(xml)
        xml.projectid attributes.projectid
        xml.employeeid attributes.employeeid
        xml.itemid attributes.itemid
        xml.billingrate attributes.billingrate
        xml.description attributes.description
      end

      def update_xml(xml)
        create_xml(xml)
      end
    end
  end
end