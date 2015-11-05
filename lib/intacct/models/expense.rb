module Intacct
  module Models
    class Expense < Intacct::Base

      api_name 'EEXPENSES'

      def create_xml(xml)
        xml.employeeid attributes.employeeid
        xml.datecreated  {
          xml.year  attributes.datecreated.try(:strftime, "%Y")
          xml.month attributes.datecreated.try(:strftime, "%m")
          xml.day   attributes.datecreated.try(:strftime, "%d")
        }
        xml.expensereportno attributes.expensereportno
        xml.description     attributes.description
        xml.basecurr        attributes.basecurr
        xml.currency        attributes.currency

        xml.expenses {
          attributes.expenses.each { |expense|
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

      def update_xml(xml)
        xml.recordno recordno
        xml.employeeid attributes.employeeid
        xml.datecreated  {
          xml.year  attributes.datecreated.try(:strftime, "%Y")
          xml.month attributes.datecreated.try(:strftime, "%m")
          xml.day   attributes.datecreated.try(:strftime, "%d")
        }
        xml.expensereportno attributes.expensereportno
        xml.description     attributes.description
        xml.basecurr        attributes.basecurr
        xml.currency        attributes.currency

        if attributes.customfields
          xml.customfields {
            attributes.customfields.each do |customfield|
              xml.customfield {
                xml.customfieldname customfield.name
                xml.customfieldvalue customfield.value
              }
            end
          }
        end

        if attributes.updateexpenses
          xml.updateexpenses {
            attributes.updateexpenses.each { |updateexpense|
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
end
