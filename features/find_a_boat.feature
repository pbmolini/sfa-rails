Feature: Find a boat
  In order to rent a boat
  As a visitor
  I want to see the list of the available boats

  # this will change when we introduce search
  Scenario: Boats list
    Given These boats are registered on SfA: Niña, Pinta, Santa Maria
    And All boats are available
    When I visit the list of boats
    Then I should see "Niña"
    And I should see "Pinta"
    And I should see "Santa Maria"