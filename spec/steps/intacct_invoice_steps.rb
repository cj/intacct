module IntacctInvoiceSteps
  class << self
    attr_accessor :intacct_key
  end

  step 'I have setup the correct settings' do
    default_setup
    custom_fields_for_auto
  end

  step('I have an invoice, customer and vendor') { invoice; customer; vendor }

  step 'I create an Intacct Invoice object' do
    @intacct_invoice = Intacct::Invoice.new({
      invoice: invoice,
      customer: customer,
      vendor: vendor
    })
  end

  step 'I use the #create method' do
    # We need to remove the fake intacct_system_id so it creates a real one
    @intacct_invoice.object.invoice.intacct_system_id = nil
    @intacct_invoice.object.customer.intacct_system_id = nil
    @intacct_invoice.object.vendor.intacct_system_id = nil
    @response = @intacct_invoice.create
    IntacctInvoiceSteps.intacct_key = @intacct_invoice.object.invoice.intacct_key
  end

  step 'I use the #delete method' do
    @intacct_invoice.object.invoice.intacct_key = IntacctInvoiceSteps.intacct_key
    @response = @intacct_invoice.delete
    if @response
      Intacct::Customer.new(@intacct_invoice.object.customer).delete
      Intacct::Vendor.new(@intacct_invoice.object.vendor).delete
    end
  end

  def custom_fields_for_auto
    Intacct::Invoice.class_eval do
      custom_invoice_fields do |xml|
        xml.customfields {
          xml.customfield {
            xml.customfieldname "CLAIM_NUMBER_ACD"
            xml.customfieldvalue object.invoice.claim.dlnumber
          }
          xml.customfield {
            xml.customfieldname "CLAIM_NUMBER_CLIENT"
            xml.customfieldvalue object.invoice.claim.claimnumber
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_YEAR"
            xml.customfieldvalue object.invoice.claim.vehicle.year
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_MAKE"
            xml.customfieldvalue object.invoice.claim.vehicle.make
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_MODEL"
            xml.customfieldvalue object.invoice.claim.vehicle.model
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_TYPE"
            xml.customfieldvalue object.invoice.claim.appraisal_type
          }
          xml.customfield {
            xml.customfieldname "NAME_OWNER"
            xml.customfieldvalue object.invoice.claim.owner.full_name
          }
          xml.customfield {
            xml.customfieldname "NAME_INSURED"
            xml.customfieldvalue object.invoice.claim.owner.insuredorclaimant=="INSURED" ? object.invoice.claim.owner.full_name : object.invoice.claim.insured_full_name
          }
          xml.customfield {
            xml.customfieldname "NAME_CLAIMANT"
            xml.customfieldvalue object.invoice.claim.owner.insuredorclaimant=="CLAIMANT" ? object.invoice.claim.owner.full_name : ""
          }
          xml.customfield {
            xml.customfieldname "LOCATION_CITY"
            xml.customfieldvalue object.invoice.claim.vehicle.address.city
          }
          xml.customfield {
            xml.customfieldname "LOCATION_STATE"
            xml.customfieldvalue object.invoice.claim.vehicle.address.state
          }
          xml.customfield {
            xml.customfieldname "LOCATION_ZIP"
            xml.customfieldvalue object.invoice.claim.vehicle.address.zipcode
          }
          xml.customfield {
            xml.customfieldname "MILEAGE_RT_BILLABLE"
            xml.customfieldvalue 30
          }
          xml.customfield {
            xml.customfieldname "MILEAGE_RT_TOTAL"
            xml.customfieldvalue object.invoice.claim.appraiser_driving_distance.to_i*2
          }
          xml.customfield {
            xml.customfieldname "MILEAGE_RATE"
            xml.customfieldvalue object.invoice.mileage_rate
          }
          xml.customfield {
            xml.customfieldname "NAME_ADJUSTER"
            xml.customfieldvalue "#{object.invoice.claim.adjuster.last_name}, #{object.invoice.claim.adjuster.first_name}"
          }
          xml.customfield {
            xml.customfieldname "CLAIM_CREATED_DATE"
            xml.customfieldvalue object.invoice.claim.dtcreated.strftime("%m/%d/%Y")
          }
          xml.customfield {
            xml.customfieldname "NAME_PROCESSOR"
            xml.customfieldvalue object.invoice.creator.full_name
          }
          if object.invoice.claim.dtloss.present?
            xml.customfield {
              xml.customfieldname "LOSS_DATE"
              xml.customfieldvalue object.invoice.claim.dtloss.strftime("%m/%d/%Y")
            }
          end
          xml.customfield {
            xml.customfieldname "LOSS_CATEGORY"
            xml.customfieldvalue object.invoice.claim.coveragetype
          }
          if object.invoice.claim.estimate_id.present?
            xml.customfield {
              xml.customfieldname "LOSS_ESTIMATE_AMOUNT"
              xml.customfieldvalue object.invoice.claim.estimate.estimate_amt
            }
            xml.customfield {
              xml.customfieldname "LOSS_FINAL_AMOUNT"
              xml.customfieldvalue object.invoice.claim.estimate.estimate_final_amt
            }
          end
          xml.customfield {
            xml.customfieldname "ASSIGNMENT_TYPE"
            xml.customfieldvalue object.invoice.type
          }
        }
        xml.invoiceitems {
          #set amount
          standard_amount = object.invoice.base_fee+object.invoice.additional_fee
          xml.lineitem {
            xml.glaccountno 4180
            xml.amount standard_amount
            xml.memo object.invoice.note
            xml.locationid "ACDCorp"
            xml.customerid object.customer.intacct_system_id
            # xml.vendorid "#{payment.payee.intacct_system_id if payment}"
            xml.employeeid
            xml.classid "A100" #hardcoded = will always be A100
          }
          #set mileage amount if exists
          if object.invoice.mileage_fee!=0
            xml.lineitem {
              xml.glaccountno 4180
              xml.amount object.invoice.mileage_fee
              xml.memo object.invoice.note
              xml.locationid "ACDCorp"
              xml.customerid object.customer.intacct_system_id
              # xml.vendorid "#{payment.payee.intacct_system_id if payment}"
              xml.employeeid
              xml.classid "A100" #hardcoded = will always be A100
            }
          end
        }
      end
    end
  end
end
