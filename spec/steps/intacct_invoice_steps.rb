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
    @intacct_invoice = Intacct::Models::Invoice.new({
      invoice: invoice,
      customer: customer,
      vendor: vendor
    })
  end

  step 'I use the #create method' do
    # We need to remove the fake intacct_system_id so it creates a real one
    @intacct_invoice.attributes.invoice.intacct_system_id = nil
    @intacct_invoice.attributes.customer.intacct_system_id = nil
    @intacct_invoice.attributes.vendor.intacct_system_id = nil
    @response = @intacct_invoice.create
    IntacctInvoiceSteps.intacct_key = @intacct_invoice.attributes.invoice.intacct_key
  end

  step 'I use the #delete method' do
    @intacct_invoice.attributes.invoice.intacct_key = IntacctInvoiceSteps.intacct_key
    @response = @intacct_invoice.delete
    if @response
      Intacct::Models::Customer.new(@intacct_invoice.attributes.customer).delete
      Intacct::Models::Vendor.new(@intacct_invoice.attributes.vendor).delete
    end
  end

  def custom_fields_for_auto
    Intacct::Models::Invoice.class_eval do
      custom_invoice_fields do |xml|
        xml.customfields {
          xml.customfield {
            xml.customfieldname "CLAIM_NUMBER_ACD"
            xml.customfieldvalue attributes.invoice.claim.dlnumber
          }
          xml.customfield {
            xml.customfieldname "CLAIM_NUMBER_CLIENT"
            xml.customfieldvalue attributes.invoice.claim.claimnumber
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_YEAR"
            xml.customfieldvalue attributes.invoice.claim.vehicle.year
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_MAKE"
            xml.customfieldvalue attributes.invoice.claim.vehicle.make
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_MODEL"
            xml.customfieldvalue attributes.invoice.claim.vehicle.model
          }
          xml.customfield {
            xml.customfieldname "VEHICLE_TYPE"
            xml.customfieldvalue attributes.invoice.claim.appraisal_type
          }
          xml.customfield {
            xml.customfieldname "NAME_OWNER"
            xml.customfieldvalue attributes.invoice.claim.owner.full_name
          }
          xml.customfield {
            xml.customfieldname "NAME_INSURED"
            xml.customfieldvalue attributes.invoice.claim.owner.insuredorclaimant=="INSURED" ? attributes.invoice.claim.owner.full_name : attributes.invoice.claim.insured_full_name
          }
          xml.customfield {
            xml.customfieldname "NAME_CLAIMANT"
            xml.customfieldvalue attributes.invoice.claim.owner.insuredorclaimant=="CLAIMANT" ? attributes.invoice.claim.owner.full_name : ""
          }
          xml.customfield {
            xml.customfieldname "LOCATION_CITY"
            xml.customfieldvalue attributes.invoice.claim.vehicle.address.city
          }
          xml.customfield {
            xml.customfieldname "LOCATION_STATE"
            xml.customfieldvalue attributes.invoice.claim.vehicle.address.state
          }
          xml.customfield {
            xml.customfieldname "LOCATION_ZIP"
            xml.customfieldvalue attributes.invoice.claim.vehicle.address.zipcode
          }
          xml.customfield {
            xml.customfieldname "MILEAGE_RT_BILLABLE"
            xml.customfieldvalue 30
          }
          xml.customfield {
            xml.customfieldname "MILEAGE_RT_TOTAL"
            xml.customfieldvalue attributes.invoice.claim.appraiser_driving_distance.to_i*2
          }
          xml.customfield {
            xml.customfieldname "MILEAGE_RATE"
            xml.customfieldvalue attributes.invoice.mileage_rate
          }
          xml.customfield {
            xml.customfieldname "NAME_ADJUSTER"
            xml.customfieldvalue "#{attributes.invoice.claim.adjuster.last_name}, #{attributes.invoice.claim.adjuster.first_name}"
          }
          xml.customfield {
            xml.customfieldname "CLAIM_CREATED_DATE"
            xml.customfieldvalue attributes.invoice.claim.dtcreated.strftime("%m/%d/%Y")
          }
          xml.customfield {
            xml.customfieldname "NAME_PROCESSOR"
            xml.customfieldvalue attributes.invoice.creator.full_name
          }
          if attributes.invoice.claim.dtloss.present?
            xml.customfield {
              xml.customfieldname "LOSS_DATE"
              xml.customfieldvalue attributes.invoice.claim.dtloss.strftime("%m/%d/%Y")
            }
          end
          xml.customfield {
            xml.customfieldname "LOSS_CATEGORY"
            xml.customfieldvalue attributes.invoice.claim.coveragetype
          }
          if attributes.invoice.claim.estimate_id.present?
            xml.customfield {
              xml.customfieldname "LOSS_ESTIMATE_AMOUNT"
              xml.customfieldvalue attributes.invoice.claim.estimate.estimate_amt
            }
            xml.customfield {
              xml.customfieldname "LOSS_FINAL_AMOUNT"
              xml.customfieldvalue attributes.invoice.claim.estimate.estimate_final_amt
            }
          end
          xml.customfield {
            xml.customfieldname "ASSIGNMENT_TYPE"
            xml.customfieldvalue attributes.invoice.type
          }
        }
        xml.invoiceitems {
          #set amount
          standard_amount = attributes.invoice.base_fee+attributes.invoice.additional_fee
          xml.lineitem {
            xml.glaccountno 4180
            xml.amount standard_amount
            xml.memo attributes.invoice.note
            xml.locationid "ACDCorp"
            xml.customerid attributes.customer.intacct_system_id
            # xml.vendorid "#{payment.payee.intacct_system_id if payment}"
            xml.employeeid
            xml.classid "A100" #hardcoded = will always be A100
          }
          #set mileage amount if exists
          if attributes.invoice.mileage_fee!=0
            xml.lineitem {
              xml.glaccountno 4180
              xml.amount attributes.invoice.mileage_fee
              xml.memo attributes.invoice.note
              xml.locationid "ACDCorp"
              xml.customerid attributes.customer.intacct_system_id
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
