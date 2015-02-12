Feature: put up a boat for rent (create a boat)
  In order to let another person rent my boat
  As a boat owner (captain)
  I want to register my boat

  Background:
    Given I am on "the list of boats"
    And I'm signed in
    And I own a boat called "Catrinza"

  @javascript
  Scenario: registering a new boat
    When I click on "Rent your boat"
    And I add the details of my boat
    Then I should see my boat in the list of boats