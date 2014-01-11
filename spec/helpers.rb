module Helpers
  class << self
    def random_id
      return @random_id if @random_id
      number = SecureRandom.random_number.to_s
      @random_id = number[2..number.length]
    end
  end

  def current_random_id
    Helpers.random_id
  end

  def address
    OpenStruct.new({
      address1: Faker::Address.street_address,
      address2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zipcode: Faker::Address.zip_code[0..4]
    })
  end

  def person
    fields = {
      full_name: Faker::Name.name,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
    }

    fields.merge! yield if block_given?

    OpenStruct.new fields
  end

  def customer
    @customer ||= OpenStruct.new({
      id: current_random_id,
      intacct_system_id: current_random_id,
      name: 'RSpec Company'
    })
  end

  def vendor
    @vendor ||= OpenStruct.new({
      id: current_random_id,
      intacct_system_id: current_random_id,
      first_name: "Rspec",
      last_name: "Test",
      full_name: "Rspec Test",
      email: "test@example.com",
      ach_account_number: "123456789",
      ach_routing_number: "123456789",
      ach_account_type: "savings",
      ach_account_classification: "business",
      ach_last_updated_at: Time.now,
      billing_address: address
    })
  end

  def payment
    @payment ||= OpenStruct.new(invoice.to_h.merge({
      type: 'some_type',
      paid_at: DateTime.now,
      base_amt: Faker::Number.number(2),
      additional_amt: Faker::Number.number(2)
    }))
  end

  def invoice
    @invoice ||= OpenStruct.new({
      id: current_random_id,
      intacct_system_id: current_random_id,
      created_at: DateTime.now,
      mileage_miles: Faker::Number.number(3),
      mileage_rate: Faker::Number.number(2),
      mileage_fee: Faker::Number.number(2),
      base_fee: Faker::Number.number(2),
      additional_fee: Faker::Number.number(2),
      note: Faker::Lorem.words,
      creator: person,
      claim: OpenStruct.new({
        dlnumber: Faker::Number.number(6),
        claimnumber: Faker::Number.number(6),
        appraisal_type: 'auto',
        insured_full_name: Faker::Name.name,
        appraiser_driving_distance: Faker::Number.number(2),
        dtcreated: DateTime.now,
        vehicle: OpenStruct.new({
          year: 2001,
          make: Faker::Name.name,
          model: 'A1',
          address: address
        }),
        owner: person { {insuredorclaimant: 'INSURED' } },
        adjuster: person
      })
    })
  end

  def default_setup
    Intacct.setup do |config|
      config.invoice_prefix  = 'AUTO-'
      config.bill_prefix     = 'AUTO-'
      config.customer_prefix = 'C'
      config.vendor_prefix   = 'A'
      config.xml_sender_id  = ENV['INTACCT_XML_SENDER_ID']
      config.xml_password   = ENV['INTACCT_XML_PASSWORD']
      config.app_user_id    = ENV['INTACCT_USER_ID']
      config.app_company_id = ENV['INTACCT_COMPANY_ID']
      config.app_password   = ENV['INTACCT_PASSWORD']
      yield if block_given?
    end
  end
end
