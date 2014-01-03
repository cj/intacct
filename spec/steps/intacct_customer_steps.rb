module IntacctCustomerSteps
  step 'I have a company' do
    @company = OpenStruct.new({
      id: current_random_id,
      intacct_system_id: current_random_id,
      name: 'RSpec Company'
    })
  end

  step 'I create an Intacct Customer object' do
    @intacct_customer = Intacct::Customer.new @company
  end

  step 'I use the #create method' do
    @response = @intacct_customer.create
  end

  step 'I use the #get method' do
    @response = @intacct_customer.get
  end

  step 'I use the #update method' do
    @response = @intacct_customer.update
  end

  step 'I use the #destroy method' do
    @response = @intacct_customer.destroy
  end

  step 'I should recieve a sucessfull response' do
    expect(@response).to be_true
  end

  step 'I should recieve "id, name and termname"' do
    expect(@response.keys).to include :id, :name, :termname
  end
end
