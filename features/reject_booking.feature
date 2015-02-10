Feature: reject a booking for one of my boats
  In order to rent my boats only to people I trust and when they are available
  As a boat owner
  I want to reject a booking

  Background:
    Given I am signed in
    And Someone booked one of my boats

  Scenario: the boat is available but I don't trust the guest
    Given My boat is available for the requested period
    When I reject the booking
    Then The booking is canceled
    #And The guest is notified