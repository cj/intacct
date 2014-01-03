Feature: Intacct Customer
  I need to be able to send and receive Intacct customers (companies)

  Background:
    Given I have setup the correct settings
    And I have a company
    Then I create an Intacct Customer object

  Scenario: It should create a customer in Intacct
    Given I use the #send method to submit the customer
    Then I should recieve a sucessfull response

  Scenario: It should get a customer from Intacct
    Given I use the #get method to grab a customer
    Then I should recieve a sucessfull response
