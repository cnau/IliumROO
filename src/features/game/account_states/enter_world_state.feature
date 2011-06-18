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

Feature: test EnterWorldState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the EnterWorldState state

  Scenario: test the enter method with no characters
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity is expecting a new state from EnterWorldState
    And this character list "" with a name of ""
    When I call the enter method of EnterWorldState
    Then I should get redirected to "MainMenuState" by EnterWorldState

  Scenario: test the enter method a character
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And this character list "char-1" with a name of "CharOne"
    When I call the enter method of EnterWorldState
    Then I should get an appropriate menu for EnterWorldState

  Scenario: test the execute method with empty last client data
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "" for EnterWorldState
    And the mocked entity is expecting a new state from EnterWorldState
    When I call the execute method of EnterWorldState
    Then I should get redirected to "MainMenuState" by EnterWorldState

  Scenario: test the execute method with an invalid index
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "2" for EnterWorldState
    And the mocked entity is expecting a new state from EnterWorldState
    And this character list "char-1" with a name of ""
    When I call the execute method of EnterWorldState
    Then I should get redirected to "EnterWorldState" by EnterWorldState

  Scenario: test the execute method with a valid index
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "1" for EnterWorldState
    And the mocked entity has a mocked client for EnterWorldState
    And this character list "char-1" with a name of ""
    And a mocked GameObjectLoader for EnterWorldState
    And the mocked player object is expecting to attach the entity client
    And the old entity is expecting to detach client for EnterWorldState
    And the player object is expecting a new state from EnterWorldState
    When I call the execute method of EnterWorldState
    Then I should get redirected to "PlayerPromptState" by EnterWorldState

