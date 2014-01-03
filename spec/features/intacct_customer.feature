Feature: Intacct Customer
  I need to be able to send and receive Intacct customers (companies)

  Background:
    Given I have setup the correct settings
    And I have a customer
    Then I create an Intacct Customer object

  Scenario Outline: It should "CRUD" a customer in Intacct
    Given I use the #<method> method
    Then I should recieve a sucessfull response

    Examples:
      | method  |
      | create  |
      | update  |
      | get     |
      | destroy |
