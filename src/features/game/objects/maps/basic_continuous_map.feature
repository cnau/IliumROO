#Copyright (c) 2009-2012 Christian Nau

#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:

#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Feature: test basic continuous game map
  As a game I need a continuous map
  So let's test our basic continuous game map

  Scenario: test a basic continuous map's save function
    Given a BasicContinuousMap object
    When I save the continuous map
    Then I should get a correctly saved continuous map

  Scenario: test a basic continuous map's player enter method
    Given a BasicContinuousMap object
    And a new player object
    When a player enters the map
    Then the player should have been updated to include his location
    And the player should have been notified that he entered a map

  Scenario: test a basic continuous maps's player enter method with other players in the room
    Given a BasicContinuousMap object
    And a new player object
    And a second player object
    And the second player in the start location
    And the player is entering in the start location
    When a player enters the map
    Then the player should have been notified that he entered a map
    And the other player should have been notified too

  Scenario: test a basic continuous map's calc_movement_dir function
    Given a BasicContinuousMap object
    When calculating directions for new location "[0,0,1]" and old location "[0,0,0]"
    Then the text directions should be "below"
    When calculating directions for new location "[0,0,0]" and old location "[0,0,1]"
    Then the text directions should be "above"
    When calculating directions for new location "[0,0,0]" and old location "[0,1,0]"
    Then the text directions should be "the north"
    When calculating directions for new location "[0,1,0]" and old location "[0,0,0]"
    Then the text directions should be "the south"
    When calculating directions for new location "[0,0,0]" and old location "[1,0,0]"
    Then the text directions should be "the east"
    When calculating directions for new location "[1,0,0]" and old location "[0,0,0]"
    Then the text directions should be "the west"
    When calculating directions for new location "[0,0,0]" and old location "[1,1,0]"
    Then the text directions should be "the northeast"
    When calculating directions for new location "[1,0,0]" and old location "[0,1,0]"
    Then the text directions should be "the northwest"
    When calculating directions for new location "[0,1,0]" and old location "[1,0,0]"
    Then the text directions should be "the southeast"
    When calculating directions for new location "[1,1,0]" and old location "[0,0,0]"
    Then the text directions should be "the southwest"
    When calculating directions for new location "[1,1,1]" and old location "[0,0,0]"
    Then the text directions should be "below and southwest"
    When calculating directions for new location "[0,0,0]" and old location "[1,1,1]"
    Then the text directions should be "above and northeast"
    When calculating directions for new location "[0,0,1]" and old location "[0,0,0]" and exiting
    Then the text directions should be "up"
    When calculating directions for new location "[0,0,0]" and old location "[0,0,1]" and exiting
    Then the text directions should be "down"
    When calculating directions for new location "[0,0,0]" and old location "[0,1,0]" and exiting
    Then the text directions should be "south"
    When calculating directions for new location "[0,1,0]" and old location "[0,0,0]" and exiting
    Then the text directions should be "north"
    When calculating directions for new location "[0,0,0]" and old location "[1,0,0]" and exiting
    Then the text directions should be "west"
    When calculating directions for new location "[1,0,0]" and old location "[0,0,0]" and exiting
    Then the text directions should be "east"
    When calculating directions for new location "[0,0,0]" and old location "[1,1,0]" and exiting
    Then the text directions should be "southwest"
    When calculating directions for new location "[1,0,0]" and old location "[0,1,0]" and exiting
    Then the text directions should be "southeast"
    When calculating directions for new location "[0,1,0]" and old location "[1,0,0]" and exiting
    Then the text directions should be "northwest"
    When calculating directions for new location "[1,1,0]" and old location "[0,0,0]" and exiting
    Then the text directions should be "northeast"
    When calculating directions for new location "[1,1,1]" and old location "[0,0,0]" and exiting
    Then the text directions should be "up and northeast"
    When calculating directions for new location "[0,0,0]" and old location "[1,1,1]" and exiting
    Then the text directions should be "down and southwest"

  Scenario: test a basic continuous map's enter room method
    Given a BasicContinuousMap object
    And a new player object
    And a second player object
    When a player enters the room at "[0,0,1]"
    And a second player enters the room at "[0,0,1]" from "[0,0,0]"
    Then the player should have been sent the message "Second arrives from below."

  Scenario: test a basic continuous map's exit room method
    Given a BasicContinuousMap object
    And a new player object
    And a second player object
    And the second player in the start location
    And the player is entering in the start location
    When a player enters the map
    And a second player exits the room at "[0,0,0]" to "[0,0,1]"
    Then the player should have been sent the message "Second leaves up."

  Scenario: test a basic continuous map's exit method
    Given a BasicContinuousMap object
    And a new player object
    And a second player object
    And the second player in the start location
    And the player is entering in the start location
    When a player enters the map
    And the player exits the map
    Then the player should have been notified that he exited the map
    And the second player should have been notified that he exited the map

  Scenario: test a basic continuous map's direction methods
    Given a BasicContinuousMap object
    And a new player object
    And a second player object
    And the second player in the start location
    And the player is entering in the start location
    When a player enters the map
    And the second player exits the room to the "north"
    Then the player should have been sent the message "Second leaves north."

  Scenario: test a basic continuous map's direction methods on arrival
    Given a BasicContinuousMap object
    And a new player object
    And a second player object
    And the second player in the start location
    When a player enters the room at "[0,1,0]"
    And the second player exits the room to the "north"
    Then the player should have been sent the message "Second arrives from the south."
