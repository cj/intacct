module IntacctVendorSteps
  step 'I have a vendor' do
    @vendor = OpenStruct.new({
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

  step 'I create an Intacct Vendor object' do
    @intacct_vendor = Intacct::Vendor.new @vendor
  end

  step 'I use the #create method' do
    @response = @intacct_vendor.create
  end

  step 'I use the #update method' do
    @response = @intacct_vendor.update
  end

  step 'I use the #destroy method' do
    @response = @intacct_vendor.destroy
  end

  step 'I should recieve a sucessfull response' do
    expect(@response).to be_true
  end

  step 'I should recieve "id, name and termname"' do
    expect(@response.keys).to include :id, :name, :termname
  end
end
