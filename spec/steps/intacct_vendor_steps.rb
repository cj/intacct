module IntacctVendorSteps
  step('I have a vendor') { vendor }

  step 'I create an Intacct Vendor object' do
    @intacct_vendor = Intacct::Vendor.new vendor
  end

  step 'I use the #create method' do
    @response = @intacct_vendor.create
  end

  step 'I use the #update method' do
    @response = @intacct_vendor.update
  end

  step 'I use the #delete method' do
    @response = @intacct_vendor.delete
  end

  step 'I should recieve "id, name and termname"' do
    expect(@response.keys).to include :id, :name, :termname
  end
end
