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

Feature: test DisplayOptionsState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the DisplayOptionsState state

  Scenario: test a DisplayOptionsState enter method with ANSI turned on
    Given an instance of DisplayOptionsState
    When I have a display type of "ANSI" for the enter method
    And I call the enter method of DisplayOptionsState
    Then I should get appropriate output from DisplayOptionsState enter method

   Scenario: test a DisplayOptionsState enter method with ANSI turned off
    Given an instance of DisplayOptionsState
    When I have a display type of "NONE" for the enter method
    And I call the enter method of DisplayOptionsState
    Then I should get appropriate output from DisplayOptionsState enter method

  Scenario: test a DisplayOptionsState execute method with ANSI turned on
    Given an instance of DisplayOptionsState
    And a mocked entity
    When I have a display type of "ANSI" for the execute method
    And I have a client data of ""
    And I call the execute method of DisplayOptionsState
    Then I should get redirected to "MainMenuState" by DisplayOptionsState
    
  Scenario: test a DisplayOptionsState execute method with an invalid last client data
    Given an instance of DisplayOptionsState
    And a mocked entity
    And an entity expecting output of "Invalid choice."
    When I have a display type of "ANSI" for the execute method
    And I have a client data of "2"
    And I call the execute method of DisplayOptionsState
    Then I should get appropriate output from DisplayOptionsState execute method
    And I should get redirected to "DisplayOptionsState" by DisplayOptionsState

  Scenario: test a DisplayOptionsState execute method with a valid last client data
    Given an instance of DisplayOptionsState
    And a mocked entity
    And an entity expecting a display type of "NONE"
    And an entity expecting to be saved
    When I have a display type of "ANSI" for the execute method
    And I have a client data of "1"
    And I call the execute method of DisplayOptionsState
    And I should get redirected to "MainMenuState" by DisplayOptionsState

  Scenario: test a DisplayOptionsState execute method with a valid last client data
    Given an instance of DisplayOptionsState
    And a mocked entity
    And an entity expecting a display type of "ANSI"
    And an entity expecting to be saved
    When I have a display type of "NONE" for the execute method
    And I have a client data of "1"
    And I call the execute method of DisplayOptionsState
    And I should get redirected to "MainMenuState" by DisplayOptionsState
