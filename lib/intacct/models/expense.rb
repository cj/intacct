module Intacct
  module Models
    class Expense < Intacct::Base

      api_name 'EEXPENSES'

      def create
        send_xml('create') do |xml|
          xml.function(controlid: '1') {
            xml.create_expense {
              create_expense_xml(xml)
            }
          }
        end
      end

      def update
        send_xml('update') do |xml|
          xml.function(controlid: '1') {
            xml.update_expense(key: key) {
              update_expense_xml(xml)
            }
          }
        end
      end

      private

      def create_expense_xml(xml)
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

      def update_expense_xml(xml)
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

        xml.updateexpenses {
          object.updateexpenses.each { |updateexpense|
            xml.updateexpense {
              xml.expensetype  updateexpense[:expensetype]
              xml.glaccountno  updateexpense[:glaccountno]
              xml.amount       updateexpense[:amount]
              xml.currency     updateexpense[:currency]
              xml.trx_amount   updateexpense[:trx_amount]
              xml.exchratedate  {
                xml.year  updateexpense[:exchratedate].try(:strftime, "%Y")
                xml.month updateexpense[:exchratedate].try(:strftime, "%m")
                xml.day   updateexpense[:exchratedate].try(:strftime, "%d")
              }
              xml.exchratetype  updateexpense[:exchratetype]
              xml.exchrate      updateexpense[:exchrate]
              xml.expensedate  {
                xml.year  updateexpense[:expensedate].try(:strftime, "%Y")
                xml.month updateexpense[:expensedate].try(:strftime, "%m")
                xml.day   updateexpense[:expensedate].try(:strftime, "%d")
              }
              xml.memo         updateexpense[:memo]
              xml.locationid   updateexpense[:locationid]
              xml.departmentid updateexpense[:departmentid]
              if updateexpense[:customfields]
                xml.customfields {
                  updateexpense[:customfields].each do |customfield|
                    xml.customfield {
                      xml.customfieldname customfield[:name]
                      xml.customfieldvalue customfield[:value]
                    }
                  end
                }
              end
              xml.projectid   updateexpense[:projectid]
              xml.customerid  updateexpense[:customerid]
              xml.vendorid    updateexpense[:vendorid]
              xml.employeeid  updateexpense[:employeeid]
              xml.itemid      updateexpense[:itemid]
              xml.classid     updateexpense[:classid]
            }
          }
        }
      end


    end
  end
end