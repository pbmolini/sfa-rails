Feature: approve a booking for one of my boats
  In order to rent out my boat when it's available
  As a boat owner
  I want to approve a booking

  Background:
    Given I am signed in
    And Someone booked one of my boats
    And My boat is available for the requested period

  Scenario: I approve a booking for an available boat
    When I approve the booking
    Then The booking is confirmed
    #And The guest is notified