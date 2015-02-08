Feature: see all the details of a boat
  In order to rent a boat
  As a visitor
  I want to see all the details of a boat

  Background:
    Given These boats are registered on SfA: Niña, Pinta, Santa Maria
  Scenario:
    When I visit the list of boats
    And I click on a boat
    Then I should see all the details of the selected boat
    #And I should see the details of the boat's owner