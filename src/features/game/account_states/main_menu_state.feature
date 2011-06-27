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

Feature: test MainMenuState finite state machine state
  As a game I use a finite state machine for my menu
  So test the MainMenuState

  Scenario: test the enter method of MainMenuState
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting to receive a menu for MainMenuState
    And an entity with account type of "admin" for MainMenuState
    And an entity with display type of "NONE" for MainMenuState
    And a generated main menu with account type of "admin"
    When I call the enter method of MainMenuState
    Then I should get appropriate output from MainMenuState

  Scenario: test the execute method of MainMenuState with an invalid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting to receive a menu for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "7" for MainMenuState
    And an entity with account type of "" for MainMenuState
    And a generated invalid option message for MainMenuState
    When I call the execute method of MainMenuState
    Then I should get appropriate output from MainMenuState
    And I should get redirected to "MainMenuState" by MainMenuState
    
  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "1" for MainMenuState
    And an entity with account type of "" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "EnterWorldState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "2" for MainMenuState
    And an entity with account type of "" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "AddCharacterState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "3" for MainMenuState
    And an entity with account type of "" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "DeleteCharacterState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "4" for MainMenuState
    And an entity with account type of "" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "DisplayOptionsState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "5" for MainMenuState
    And an entity with account type of "" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "LogoutState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "6" for MainMenuState
    And an entity with account type of "admin" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "ListAccountsState" by MainMenuState
    
  Scenario: test the execute method of MainMenuState with a valid menu choice and an invalid account type
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "6" for MainMenuState
    And an entity with account type of "" for MainMenuState
    And an entity expecting to receive a menu for MainMenuState
    And a generated invalid option message for MainMenuState
    When I call the execute method of MainMenuState
    Then I should get appropriate output from MainMenuState
    And I should get redirected to "MainMenuState" by MainMenuState