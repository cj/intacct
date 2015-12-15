module Intacct
  module Models
    class Timesheet < Intacct::Base

      def create_xml(xml)
        xml.employeeid attributes.employeeid
        xml.begindate attributes.begindate.try(:strftime, '%Y-%m-%d')
        xml.description attributes.description
        xml.state attributes.state
        xml.lines attributes.lines

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

        xml.timesheetentries {
          attributes.timesheetentries.each { |timesheetentry|
            xml.timesheetentry {
              xml.lineno timesheetentry[:lineno]
              xml.projectid timesheetentry[:projectid]
              xml.taskkey timesheetentry[:taskkey]
              xml.customerid timesheetentry[:customerid]
              xml.itemid timesheetentry[:itemid]
              xml.entrydate timesheetentry[:entrydate].try(:strftime, '%m/%d/%Y')
              xml.qty timesheetentry[:qty]
              xml.description timesheetentry[:description]
              xml.notes timesheetentry[:notes]
              xml.state timesheetentry[:state]
              xml.locationid timesheetentry[:locationid]
              xml.departmentid timesheetentry[:departmentid]
              xml.timetype timesheetentry[:timetype]
              xml.billable timesheetentry[:billable]

              xml.vendorid timesheetentry[:vendorid]
              xml.classid timesheetentry[:classid]


              if timesheetentry[:customfields]
                xml.customfields {
                  timesheetentry[:customfields].each { |customfield|
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
