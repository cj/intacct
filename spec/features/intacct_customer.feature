Feature: Intacct Customer
  I need to be able to send and receive Intacct customers (companies)

  Background:
    Given I have setup the correct settings
    And I have a company
    Then I create an Intacct Customer object

  Scenario: It should create a customer in Intacct
    Given I use the #create method to submit the customer
    Then I should recieve a sucessfull response

  Scenario: It should get a customer from Intacct
    Given I use the #get method to grab a customer
    Then I should recieve "id, name and termname"

  Scenario: It should destroy a customer from Intact
    Given I use the #destroy method
    Then I should recieve a sucessfull response
