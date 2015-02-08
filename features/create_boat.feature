Feature: put up a boat for rent (create a boat)
  In order to let another person rent my boat
  As a boat owner (captain)
  I want to register my boat

  Background:
    Given I'm signed in
  Scenario: registering a new boat
    When I click on "Rent your boat"
    And I fill in the form with these details
      # TODO | ... | ... |
    Then I should see my boat in the list of boats