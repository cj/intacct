step 'I have setup the correct settings' do
  default_setup
end

step 'I should recieve a sucessfull response' do
  expect(@response).to be_true
end
