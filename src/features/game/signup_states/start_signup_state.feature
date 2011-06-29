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

Feature: test StartSignupState finite state machine state
  As a game I use a finite state machine for my signup menu
  So test the StartSignupState

  Scenario: test the enter method of StartSignupState
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And an entity with an email address of "test@test.com" for StartSignupState
    And an entity expecting to receive a prompt for StartSignupState
    When I call the enter method of StartSignupState
    Then I should get "Give me a password for test@test.com:" from StartSignupState

  Scenario: test the execute method of StartSignupState with no client data
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And an entity with last_client_data of "" for StartSignupState
    And an entity expecting to receive a prompt for StartSignupState
    And an entity expecting a change of state for StartSignupState
    When I call the execute method of StartSignupState
    Then I should get "Invalid password.  Please try again." from StartSignupState
    And I should get redirected to "StartSignupState" by StartSignupState

  Scenario: test the execute method of StartSignupState with client data and no existing accounts
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And a mocked client for StartSignupState
    And a ClientAccount expecting to create a new client account with email "test@test.com" and password "password" for StartSignupState
    And a client expecting to set_last_login for StartSignupState
    And an entity and client expecting attach and detach client calls for StartSignupState
    And an entity with the mocked client for StartSignupState
    And an entity with last_client_data of "password" for StartSignupState
    And an entity with email address of "test@test.com" for StartSignupState
    And a mocked Password update function with password of "password" for StartSignupState
    And a ClientAccount with account_count of "1" for StartSignupState
    And an ClientAccount expecting to receive a prompt for StartSignupState
    And a ClientAccount expecting a change of state for StartSignupState
    And a ClientAccount expecting to get set as admin and saved
    When I call the execute method of StartSignupState
    Then I should get "This is the first account created in this database.  Setting account as admin." from StartSignupState
    And the ClientAccount should get redirected to "MainMenuState" by StartSignupState

  Scenario: test the execute method of StartSignupState with client data and existing accounts
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And a mocked client for StartSignupState
    And a ClientAccount expecting to create a new client account with email "test@test.com" and password "password" for StartSignupState
    And a client expecting to set_last_login for StartSignupState
    And an entity and client expecting attach and detach client calls for StartSignupState
    And an entity with the mocked client for StartSignupState
    And an entity with last_client_data of "password" for StartSignupState
    And an entity with email address of "test@test.com" for StartSignupState
    And a mocked Password update function with password of "password" for StartSignupState
    And a ClientAccount with account_count of "2" for StartSignupState
    And a ClientAccount expecting a change of state for StartSignupState
    When I call the execute method of StartSignupState
    And the ClientAccount should get redirected to "MainMenuState" by StartSignupState