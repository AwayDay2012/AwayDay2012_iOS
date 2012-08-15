Feature: Navigating between screens

Scenario: Moving from the 'Home' screen to the 'Events' screen
Given I launch the app
Then I should be on the Home screen

When I navigate to "Events"
Then I should be on the Events screen