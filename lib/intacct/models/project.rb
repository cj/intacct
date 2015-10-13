module Intacct
  class Project < Intacct::Base

    def create
      send_xml('create') do |xml|
        xml.function(controlid: "1") {
          xml.create_project {
            xml.projectid intacct_object_id
            xml.name object.name
            xml.description object.description
            xml.parentid object.parent_id
            xml.invoicewithparent object.invoice_with_parent
            xml.projectcategory object.project_category
            xml.projecttype object.project_type
            xml.projectstatus object.project_status
            xml.customerid object.customer_id
            xml.managerid object.manager_id
            xml.custuserid object.cust_user_id
            xml.salescontactid object.sales_contact_id
            xml.begindate {
              xml.year object.begin_date.try(:strftime, "%Y")
              xml.month object.begin_date.try(:strftime, "%m")
              xml.day object.begin_date.try(:strftime, "%d")
            }
            xml.enddate {
              xml.year object.end_date.try(:strftime, "%Y")
              xml.month object.end_date.try(:strftime, "%m")
              xml.day object.end_date.try(:strftime, "%d")
            }
            xml.departmentid object.department_id
            xml.locationid object.location_id
            xml.classid object.class_id
            xml.currency object.currency
            xml.billingtype object.billing_type
            xml.termname object.term_name
            xml.docnumber object.doc_number
            # xml.billto object.bill_to
            # xml.shipto object.ship_to
            # xml.contactinfo object.contact_info
            xml.sonumber object.so_number
            xml.ponumber object.po_number
            xml.poamount object.po_amount
            xml.pqnumber object.pq_number
            xml.budgetamount object.budget_amount
            xml.budgetedcost object.budgeted_cost
            xml.budgetqty object.budget_qty
            xml.userrestrictions object.user_restrictions
            xml.obspercentcomplete object.obs_percent_complete
            xml.budgetid object.budget_id
            xml.billingrate object.billing_rate
            xml.billingpricing object.billing_pricing
            xml.expenserate object.expense_rate
            xml.expensepricing object.expense_pricing
            xml.poaprate object.po_ap_rate
            xml.poappricing object.po_ap_pricing
            xml.status object.status
            xml.supdocid object.sup_doc_id
            xml.invoicemessage object.invoice_message
            xml.invoicecurrency object.invoice_currency

            if object.project_resources
              xml.projectresources {
                object.project_resources.each { |project_resource|
                  xml.projectresource {
                    xml.employeeid project_resource.employee_id
                    xml.itemid project_resource.item_id
                    xml.resourcedescription project_resource.resouce_description
                    xml.billingrate project_resource.billing_rate

                  }
                }
              }
            end
          }
        }
      end
    end
  end
end