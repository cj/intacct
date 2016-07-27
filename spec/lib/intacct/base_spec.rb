require 'spec_helper'

describe Intacct::Base do

  class Intacct::Models::Example < Intacct::Base; end;

  let(:client)  { double("client") }
  let(:attrs)   { Hash.new }

  subject { Intacct::Models::Example.new(client, attrs) }

  it 'builds an Example model' do
    example = Intacct::Models::Example.build(client, id: '12345')

    expect(example.client).to eq(client)
    expect(example.id).to eq '12345'
  end
end