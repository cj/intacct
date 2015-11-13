module Intacct
  module Models
    class Timesheet < Intacct::Base

      def create_xml(xml)
        xml.employeeid attributes.employeeid
        xml.begindate attributes.begindate.try(:strftime, '%Y-%m-%d')
        xml.description attributes.description

        xml.timesheetitems {
          attributes.timesheetitems.each { |timesheetitem|
            xml.timesheetitem {
              xml.customerid timesheetitem[:customerid]
              xml.itemid timesheetitem[:itemid]
              xml.projectid timesheetitem[:projectid]
              xml.taskkey timesheetitem[:taskkey]
              xml.taskname timesheetitem[:taskname]
              xml.timetype timesheetitem[:timetype]
              xml.locationid timesheetitem[:locationid]
              xml.departmentid timesheetitem[:departmentid]

              xml.entrydate timesheetitem[:entrydate].try(:strftime, '%Y-%m-%d')
              xml.billable timesheetitem[:billable]
              xml.qty timesheetitem[:qty]
              xml.notes timesheetitem[:notes]
              xml.vendorid timesheetitem[:vendorid]
              xml.classid timesheetitem[:classid]

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
            }
          }
        }
      end

      def update_xml(xml)
        create_xml(xml)
      end
    end
  end
end
