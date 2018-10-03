module Intacct
  module Models
    class Timesheet < Intacct::Base

      def create_xml(xml)
        xml.employeeid attributes.employeeid
        xml.BEGINDATE attributes.begindate.try(:strftime, '%m/%d/%Y')
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
              xml.ENTRYDATE timesheetentry[:entrydate].try(:strftime, '%m/%d/%Y')
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

              xml.extbillrate timesheetentry[:extbillrate]
              xml.extcostrate timesheetentry[:extcostrate]


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
