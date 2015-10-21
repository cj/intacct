module Intacct
  module Models
    class Timesheet < Intacct::Base

      def create
        send_xml('create') do |xml|
          xml.function(controlid: "1") {
            xml.create_timesheet {
              timesheet_xml(xml)
            }
          }
        end
      end

      private

      def timesheet_xml(xml)
        xml.employeeid object.employeeid
        xml.begindate {
          xml.year object.begindate.try(:strftime, "%Y")
          xml.month object.begindate.try(:strftime, "%m")
          xml.day object.begindate.try(:strftime, "%d")
        }
        xml.timesheetdescription object.timesheetdescriptiontime

        xml.timesheetitems {
          object.timesheetitems.each { |timesheetitem|
            xml.timesheetitem {
              xml.customerid timesheetitem[:customerid]
              xml.itemid timesheetitem[:itemid]
              xml.projectid timesheetitem[:projectid]
              xml.taskname timesheetitem[:taskname]
              xml.timetype timesheetitem[:timetype]
              xml.locationid timesheetitem[:locationid]
              xml.departmentid timesheetitem[:departmentid]
              xml.entrydate {
                xml.year timesheetitem[:entrydate].try(:strftime, "%Y")
                xml.month timesheetitem[:entrydate].try(:strftime, "%m")
                xml.day timesheetitem[:entrydate].try(:strftime, "%d")
              }
              xml.qty timesheetitem[:qty]
              xml.timesheetentrydescription timesheetitem[:timesheetentrydescription]
              xml.notes timesheetitem[:notes]
              xml.vendorid timesheetitem[:vendorid]
              xml.classid timesheetitem[:classid]

              if object.customfields
                xml.customfields {
                  object.customfields.each { |customfield|
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
    end
  end
end
