#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.

Feature: test basic game object
  As a game I need game objects
  So let's test our basic game object

  Scenario: test a basic game object's class functions
    Given a BasicGameObject class
    When I request verbs
    And when I request properties
    Then I should get appropriate values

  Scenario: test a basic game object's properties
    Given a new BasicGameObject instance
    When I check game object id
    Then I should get a valid game object id
    And I should be able to see that id in the object's to_hash function

  Scenario: test game object's client wrapper mixin
    Given an instance of BasicGameObject
    When I mock a client object
    And I attach the mock client object to the game object
    Then the client object should be attached

  Scenario: test game object's client wrapper mixin's verbs
    Given an instance of BasicGameObject 2
    When I mock a client object 2
    And I attach the client object to the game object 2
    And I test the verbs for the client wrapper
    Then the verbs should work properly

  Scenario: test a game object's state machine mixin
    Given an instance of BasicGameObject 3
    When I mock a couple of state classes
    And I change the state of BasicGameObject
    Then I expect the state changes to take place
    When I revert the state
    Then I expect the state to be reverted

  Scenario: test a game object's global state
    Given an instance of BasicGameObject 4
    When I mock a global state
    And I assign the global state to the game object
    Then I expect the state change to take place