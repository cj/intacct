module IntacctCustomerSteps
  step('I have a customer') { customer }

  step 'I create an Intacct Customer object' do
    @intacct_customer = Intacct::Customer.new customer
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

  step 'I use the #delete method' do
    @response = @intacct_customer.delete
  end

  step 'I should recieve "id, name and termname"' do
    expect(@response.keys).to include :id, :name, :termname
  end
end
