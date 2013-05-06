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
    And the player save hash should include map and location
    And the player should have been notified that he entered a map

  Scenario: test a basic continuous maps's player enter method with other players in the room
    Given a BasicContinuousMap object
    And a new player object
    And another player in the start location
    When a player enters the map
    Then the player should have been notified that he entered a map
    And the other player should have been notified too

