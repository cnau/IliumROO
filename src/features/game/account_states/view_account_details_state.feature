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

Feature: test ViewAccountDetailsState finite state machine state
  As a game I use a finite state machine for my menu
  So test the ViewAccountDetailsState

  Scenario: test the execute method
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity expecting a change of state for ViewAccountDetailsState
    When I call the execute method of ViewAccountDetailsState
    Then I should get redirected to "MainMenuState" by ViewAccountDetailsState

  Scenario: test the enter method with no accounts
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity expecting a change of state for ViewAccountDetailsState
    And an account list with names of "" and object ids of "" for ViewAccountDetailsState
    And a mocked GameObjects returning the account list for ViewAccountDetailsState
    When I call the enter method of ViewAccountDetailsState
    Then I should get redirected to "MainMenuState" by ViewAccountDetailsState
    
  Scenario: test the enter method with an invalid index choice
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity expecting a change of state for ViewAccountDetailsState
    And an entity with last_client_data of "2" for ViewAccountDetailsState
    And an account list with names of "Acct-1" and object ids of "acct-1" for ViewAccountDetailsState
    And a mocked GameObjects returning the account list for ViewAccountDetailsState
    When I call the enter method of ViewAccountDetailsState
    Then I should get redirected to "MainMenuState" by ViewAccountDetailsState

  Scenario: test the enter method with a valid index choice
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity with last_client_data of "1" for ViewAccountDetailsState
    And an entity with display type of "ASCII" for ViewAccountDetailsState
    And an entity expecting to receive a menu for ViewAccountDetailsState
    And an account list with names of "Acct-1" and object ids of "acct-1" for ViewAccountDetailsState
    And a mocked client account get_account call with account id of "acct-1" for ViewAccountDetailsState
    And a mocked GameObjects returning the account list for ViewAccountDetailsState
    When I call the enter method of ViewAccountDetailsState
    Then I should get an appropriate output message for ViewAccountDetailsState
