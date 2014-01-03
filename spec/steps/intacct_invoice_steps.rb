module IntacctInvoiceSteps
  step('I have an invoice, customer and vendor') { invoice; customer; vendor }

  step 'I create an Intacct Invoice object' do
    @intacct_invoice = Intacct::Invoice.new({
      invoice: invoice,
      customer: customer,
      vendor: vendor
    })
  end

  step 'I use the #create method' do
    # We need to remove the fake intacct_system_id so it creates a real one
    @intacct_invoice.object.intacct_system_id = nil
    @intacct_invoice.create
  end
end
