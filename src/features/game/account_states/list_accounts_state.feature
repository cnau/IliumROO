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

Feature: test ListAccountsState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the ListAccountsState

  Scenario: test the enter method with an empty accounts tag
    Given an instance of ListAccountsState
    And an account list with names of "" and object ids of ""
    And a mocked GameObjects returning the account list
    And a mocked entity for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    When I call the enter method of ListAccountsState
    Then I should get redirected to "MainMenuState" by ListAccountsState

  Scenario: test the enter method with some accounts
    Given an instance of ListAccountsState
    And an account list with names of "acc-1,acc-2" and object ids of "ACC-1,ACC-2"
    And a mocked GameObjects returning the account list
    And a mocked entity for ListAccountsState
    And an entity expecting to receive a menu for ListAccountsState
    And an entity with display type of "NONE" for ListAccountsState
    When I call the enter method of ListAccountsState
    Then I should get an appropriate menu for ListAccountsState

  Scenario: test the execute method with empty last client data
    Given an instance of ListAccountsState
    And a mocked entity for ListAccountsState
    And an entity with last_client_data of "" for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    When I call the execute method of ListAccountsState
    Then I should get redirected to "MainMenuState" by ListAccountsState

  Scenario: test the execute method with an invalid index
    Given an instance of ListAccountsState
    And a mocked entity for ListAccountsState
    And an entity with last_client_data of "2" for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    And an account list with names of "acc-3" and object ids of "ACC-3"
    And a mocked GameObjects returning the account list
    When I call the execute method of ListAccountsState
    Then I should get redirected to "ListAccountsState" by ListAccountsState

  Scenario: test the execute method with a valid index
    Given an instance of ListAccountsState
    And a mocked entity for ListAccountsState
    And an entity with last_client_data of "1" for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    And an account list with names of "acc-4" and object ids of "ACC-4"
    And a mocked GameObjects returning the account list
    When I call the execute method of ListAccountsState
    Then I should get redirected to "ViewAccountDetailsState" by ListAccountsState