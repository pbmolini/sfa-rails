Feature: book a boat
  In order to rent someone else's boat
  As a registered guest
  I want to book the boat I want to rent
  # submit a request to book?

  Background:
    When I'm signed in

  Scenario:
    When I go to the details of a boat
    And I fill in the period I am interested in as follows:
      | date_from | tomorrow |
      | date_to   | 2.days.from_now |
    And I click on "Book"
    Then I have a pending booking for the specified dates