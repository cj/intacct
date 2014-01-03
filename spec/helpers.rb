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
      billing_address: OpenStruct.new({
        address1: Faker::Address.street_address,
        address2: Faker::Address.secondary_address,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        zipcode: Faker::Address.zip_code[0..4]
      })
    })
  end

  def invoice
    @invoice ||= OpenStruct.new({
      id: current_random_id,
      intacct_system_id: current_random_id,
    })
  end
end
