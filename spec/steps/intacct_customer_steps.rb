module IntacctCustomerSteps
  attr_accessor :random_id

  def current_random_id
    return @random_id if @random_id
    number = SecureRandom.random_number.to_s
    @random_id = number[2..number.length]
  end

  step 'I have setup the correct settings' do
    Intacct.setup do |config|
      config.xml_sender_id  = ENV['INTACCT_XML_SENDER_ID']
      config.xml_password   = ENV['INTACCT_XML_PASSWORD']
      config.app_user_id    = ENV['INTACCT_USER_ID']
      config.app_company_id = ENV['INTACCT_COMPANY_ID']
      config.app_password   = ENV['INTACCT_PASSWORD']
    end
  end

  step 'I have a company' do
    @company = OpenStruct.new({
      id: current_random_id,
      intacct_system_id: current_random_id,
      name: 'Some Company'
    })
  end

  step 'I create an Intacct Customer object' do
    @intacct_customer = Intacct::Customer.new @company
  end

  step 'I use the #send method to submit the customer' do
    @response = @intacct_customer.create
  end

  step 'I use the #get method to grab a customer' do
    @response = @intacct_customer.get
  end

  step 'I should recieve a sucessfull response' do
    expect(@response).to be_true
  end
end
