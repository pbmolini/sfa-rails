Feature: book a boat
  In order to rent someone else's boat
  As a registered guest
  I want to book the boat I want to rent
  # submit a request to book?

  Background:
    #Given I'm signed in
    Given There is a boat with:
      | name            | Caramanda |
      | guest_capacity  | 10        |
    When I go to the details of the boat

  Scenario: booking without errors
    When I fill in the period I am interested in as follows:
      | start_time      | Time.zone.tomorrow.beginning_of_day |
      | end_time        | 2.days.from_now.end_of_day   |
      | people_on_board | 5                            |
    And I click on the "Book" button
    Then There should be a booking for the specified dates

  Scenario: booking an unavailable period
    Given the boat is already booked
      | start_time      | Time.zone.tomorrow.noon       |
      | end_time        | Time.zone.tomorrow.end_of_day |
      | people_on_board | 5                             |
    When I fill in the period I am interested in as follows:
      | start_time      | Time.zone.tomorrow.noon + 2.hours |
      | end_time        | 2.days.from_now.end_of_day   |
      | people_on_board | 5                            |
    And I click on the "Book" button
    Then I should be notified the boat is unavailable