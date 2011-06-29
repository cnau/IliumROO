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

Feature: test PlayerPromptState finite state machine state
  As a game I use a finite state machine for my player prompt
  So test the PlayerPromptState

  Scenario: test the enter method of PlayerPromptState
    Given an instance of PlayerPromptState
    And a mocked entity for PlayerPromptState
    And an entity expecting to receive a prompt for PlayerPromptState
    When I call the enter method of PlayerPromptState
    Then I should get an appropriate prompt from PlayerPromptState

  Scenario: test the execute method of PlayerPromptState with a client
    Given an instance of PlayerPromptState
    And a mocked process_command method for PlayerPromptState
    And a mocked entity for PlayerPromptState
    And an entity with last_client_data of "foo" for PlayerPromptState
    And an entity with a non-nil client for PlayerPromptState
    And an entity expecting a change of state for PlayerPromptState
    When I call the execute method of PlayerPromptState
    Then I should get redirected to "PlayerPromptState" by PlayerPromptState

  Scenario: test the execute method of PlayerPromptState with a client
    Given an instance of PlayerPromptState
    And a mocked process_command method for PlayerPromptState
    And a mocked entity for PlayerPromptState
    And an entity with last_client_data of "foo" for PlayerPromptState
    And an entity with a nil client for PlayerPromptState
    When I call the execute method of PlayerPromptState