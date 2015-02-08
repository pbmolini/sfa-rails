Feature: approve a booking for one of my boats
  In order to rent out my boat when it's available
  As a boat owner
  I want to approve a booking

  Background:
    When I am signed in
    And I have a boat on SeaForAll

  Scenario:
    Given I received a booking
    And My boat is available for the requested period
    When I approve the booking
    Then The booking is confirmed
    #And The guest is notified