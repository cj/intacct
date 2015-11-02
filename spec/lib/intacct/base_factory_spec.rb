require 'spec_helper'

describe Intacct::BaseFactory do

  class Intacct::Models::Foo ; end

  let(:client) { double() }
  let(:klass)  { 'Foo' }
  subject      { Intacct::BaseFactory.new(client, klass)}

  it "initializes correctly" do
    expect(subject.client).to       eq(client)
    expect(subject.target_class).to eq(Intacct::Models::Foo)
  end

  it "proxies get to the target class" do
    expect(Intacct::Models::Foo).to receive(:get).with(client, '1')
    subject.get('1')
  end

  it "proxies read_by_query to the target class" do
    expect(Intacct::Models::Foo).to receive(:read_by_query).with(client, query: 'FOO')
    subject.read_by_query(query: 'FOO')
  end

  it "returns the target class" do
    expect(subject.target_class).to eq(Intacct::Models::Foo)
  end

  it "proxies build to the target class" do
    attrs = double()
    expect(Intacct::Models::Foo).to receive(:build).with(client, attrs)
    subject.build(attrs)
  end
end