step 'I have setup the correct settings' do
  Intacct.setup do |config|
    config.xml_sender_id  = ENV['INTACCT_XML_SENDER_ID']
    config.xml_password   = ENV['INTACCT_XML_PASSWORD']
    config.app_user_id    = ENV['INTACCT_USER_ID']
    config.app_company_id = ENV['INTACCT_COMPANY_ID']
    config.app_password   = ENV['INTACCT_PASSWORD']
  end
end

step 'I should recieve a sucessfull response' do
  expect(@response).to be_true
end
