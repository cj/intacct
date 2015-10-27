module Intacct
  module Models
    class Expense < Intacct::Base

      api_name 'EEXPENSES'

      def create
        send_xml('create') do |xml|
          xml.function(controlid: "1") {
            xml.create_expense {
              expense_xml(xml)
            }
          }
        end
      end

      private

      def expense_xml(xml)
        xml.employeeid object.employeeid
        xml.datecreated  {
          xml.year  object.datecreated.try(:strftime, "%Y")
          xml.month object.datecreated.try(:strftime, "%m")
          xml.day   object.datecreated.try(:strftime, "%d")
        }
        xml.expensereportno object.expensereportno
        xml.description     object.description
        xml.basecurr        object.basecurr
        xml.currency        object.currency

        xml.expenses {
          object.expenses.each { |expense|
            xml.expense {
              xml.expensetype  expense[:expensetype]
              xml.amount       expense[:amount]
              xml.expensedate  {
                xml.year  expense[:expensedate].try(:strftime, "%Y")
                xml.month expense[:expensedate].try(:strftime, "%m")
                xml.day   expense[:expensedate].try(:strftime, "%d")
              }
              xml.memo         expense[:memo]
              xml.locationid   expense[:locationid]
              xml.departmentid expense[:departmentid]
            }
          }
        }
      end


    end
  end
end