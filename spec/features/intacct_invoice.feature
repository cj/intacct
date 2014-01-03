Feature: Intacct Invoice
  I need to be able to send and receive Intacct Invoices.
  We need to also pass a customer and invoice when creating the object.

  Background:
    Given I have setup the correct settings
    Then I create an Intacct Invoice object

  Scenario Outline: It should "CRUD" an invoice in Intacct
    Given I use the #<method> method
    Then I should recieve a sucessfull response

    Examples:
      | method  |
      | create  |
      | update  |
      | destroy |
