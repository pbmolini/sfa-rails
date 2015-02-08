Feature: sign up
  In order to rent a boat or to put up my boat for rent
  As a visitor
  I want to sign up

  Scenario: the user signs up
    Given I am on SeaForAll
    When I sign up as "tizio@example.com"
    Then I should be signed in

#take a look at https://github.com/diaspora/diaspora/blob/master/features/desktop/signs_up.feature for inspiration