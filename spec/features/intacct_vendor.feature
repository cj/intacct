Feature: Intacct Vendor
  I need to be able to send and receive Intacct vendors

  Background:
    Given I have setup the correct settings
    And I have a vendor
    Then I create an Intacct Vendor object

  Scenario Outline: It should "CRUD" a vendor in Intacct
    Given I use the #<method> method
    Then I should recieve a sucessfull response

    Examples:
      | method  |
      | create  |
      | update  |
      | delete |
